{************************************************************************}
{                                                                        }
{ Classe responsável por criar o xml de venda para SAT/MFE               }
{                                                                        }
{                                                                        }
{************************************************************************}

unit umontaxmlvendasat;

interface

uses
  Controls, IBQuery, Classes, SysUtils, StrUtils, Forms, Windows
  , IBCustomDataSet
  , ufuncoesfrente
  , usmallsat
  , smallfunc
  , uclassetransacaocartao
  ;

type
  TDestinatarioInformadoNaTela = class
  private
    FCnpjCpf: String;
    FNome: String;
  public
    property CnpjCPF: String read FCnpjCpf write FCnpjCpf;
    property Nome: String read FNome write FNome;
  end;

  TPagamentosSat = class
  private
    FTransacoesCartao: TTransacaoFinanceira;
    FTEFPago: Double;
    FNomeRede: String;
    FDataSetFormasPagamento: TIBDataSet; // Sandro Silva 2021-03-10
    FOrdemExtra1: String;
    FOrdemExtra2: String;
    FOrdemExtra3: String;
    FOrdemExtra4: String;
    FOrdemExtra5: String;
    FOrdemExtra6: String;
    FOrdemExtra7: String;
    FOrdemExtra8: String;
  public
    constructor Create;
    property TransacoesCartao: TTransacaoFinanceira read FTransacoesCartao write FTransacoesCartao;
    property TEFPago: Double read FTEFPago write FTEFPago;
    property NomeRede: String read FNomeRede write FNomeRede;
    property DataSetFormasPagamento: TIBDataSet read FDataSetFormasPagamento write FDataSetFormasPagamento;
    property OrdemExtra1: String read FOrdemExtra1 write FOrdemExtra1;
    property OrdemExtra2: String read FOrdemExtra2 write FOrdemExtra2;
    property OrdemExtra3: String read FOrdemExtra3 write FOrdemExtra3;
    property OrdemExtra4: String read FOrdemExtra4 write FOrdemExtra4;
    property OrdemExtra5: String read FOrdemExtra5 write FOrdemExtra5;
    property OrdemExtra6: String read FOrdemExtra6 write FOrdemExtra6;
    property OrdemExtra7: String read FOrdemExtra7 write FOrdemExtra7;
    property OrdemExtra8: String read FOrdemExtra8 write FOrdemExtra8;    
  end;

  TMontaXmlVendaSAT = class
  private
    IBQALTERACA: TIBQuery;
    IBQDESCONTOITEM: TIBQuery;
    IBQDESCONTOCUPOM: TIBQuery;
    IBQACRESCIMOCUPOM: TIBQuery;
    IBQTOTALCUPOM: TIBQuery;
    IBQEMITENTE: TIBQuery;
    IBQCLIFOR: TIBQuery;
    IBQLEI12741: TIBQuery;
    ssignAC: String;
    sDadosIde: String;
    sDadosEmitente: String;
    sDadosDestinatario: String;
    sDadosLocalEntrega: String;
    sDadosItens: String;
    sDadosTotal: String;
    sDadosPagamento: String;
    sDadosinfAdic: String;
    sXMLCFe: String; // Sandro Silva 2016-04-12
    iItem: Integer;
    sCFOPItem: String;
    sOrigItem: String;
    sCST_ICMSItem: String;
    scListServ: String;
    sUnidadeMedida: String;
    svUnCom: String; // Sandro Silva 2016-03-24
    sCSOSNItem: String; // 2016-01-14
    sCodigoANP: String; // Sandro Silva 2019-04-16
    scServTribMun: String; // Sandro Silva 2020-08-21 
    dTotal: Double;
    dDescontoItem: Double;
    dRateioDescontoItem: Double;
    dRateioAcrescimoItem: Double;
    dItemImpostoLei12741: Double;
    dTotalLei12741: Double;
    dValorLiquidoItem: Double; // Sandro Silva 2017-04-28
    dvAliq_U04: Double; // 2016-01-13
    dpICMS_N08: Double; // 2016-01-19
    sCNPJEmitente: String;
    sIEEmitente: String;
    sIMEmitente: String;
    sTipoCartao: String;
    sWA05: String; // Sandro Silva 2016-11-23
    dvMP_WA03_10: Double; // Sandro Silva 2016-08-12
    dvMP_WA03_11: Double; // Sandro Silva 2016-08-12
    dvMP_WA03_12: Double; // Sandro Silva 2016-08-12
    dvMP_WA03_13: Double; // Sandro Silva 2016-08-12
    dvMP_WA03_16: Double; // Sandro Silva 2021-08-10
    dvMP_WA03_17: Double; // Sandro Silva 2021-08-10
    dvMP_WA03_18: Double; // Sandro Silva 2021-08-10
    dvMP_WA03_19: Double; // Sandro Silva 2021-08-10
    dvMP_WA03_99: Double; // Sandro Silva 2016-08-12
    dvBCPisCofins: Double; // Sandro Silva 2016-10-12
    dpPIS: Double; // Sandro Silva 2016-10-12
    dpCOFINS: Double; // Sandro Silva 2016-10-12
    slLog: TStringList;
    FDestinatarioInformadoNaTela: TDestinatarioInformadoNaTela;
    FXmlVenda: String;
    FCaixa: String;
    FLog: String;
    FCupom: String;
    FData: TDate;
    FSAT: TSmall59;
    FPagamentos: TPagamentosSat;
    function GrupoPISCofins: String;
    function DadosPagamento(CodigoMeio: String; dValorMeio: Double): String;
    procedure AcumulaFormaExtraSAT(sOrdemExtra: String; dValor: Double);
    function GetFXmlVenda: String;
    function MontaXMLVenda(_59: TSmall59; sCaixa: String; dtData: TDate;
      sCupom: String; var sLog: String): AnsiString;
  public
    constructor Create;
    destructor Destroy; override; 
    property DestinatarioInformadoNaTela: TDestinatarioInformadoNaTela read FDestinatarioInformadoNaTela write FDestinatarioInformadoNaTela;
    property XmlVenda: String read GetFXmlVenda;
    property Pagamentos: TPagamentosSat read FPagamentos write FPagamentos;
    function GeraXMLVenda(_59: TSmall59; sCaixa: String; dtData: TDate;
      sCupom: String; var sLog: String): String; 
  end;

implementation

uses
  _Small_59;

{ TMontaXmlVendaSAT }

function TMontaXmlVendaSAT.GrupoPISCofins: String;
var
  sPisCofinsItem: String;
  sCSTPISCOFINS: String;
  dValorTotalItem: Double; // Sandro Silva 2021-07-27
begin
  sPisCofinsItem := '';
  { Deve gravar o xml com problema enviado ao sat
    Visualização do xml deve permitir identificar problema
  if (Trim(IBQALTERACA.FieldByName('CST_PIS_COFINS').AsString) = '') then
    SmallMsg(IBQALTERACA.FieldByName('DESCRICAO').AsString + #13 +
                'Configure o CST PIS/COFINS e Alíquota');
  }
  sCSTPISCOFINS := Trim(IBQALTERACA.FieldByName('CST_PIS_COFINS').AsString);

  if indRegraSAT(sCFOPItem) = 'T' then // if sindRegra = 'T' then
    dvBCPisCofins := TruncaValor((IBQALTERACA.FieldByName('UNITARIO').AsFloat * IBQALTERACA.FieldByName('QUANTIDADE').AsFloat), 2) + dRateioDescontoItem + dRateioAcrescimoItem // trunca o total com 2 casas decimais // Sandro Silva 2019-05-23 dvBCPisCofins := (Trunc((IBQALTERACA.FieldByName('UNITARIO').AsFloat * IBQALTERACA.FieldByName('QUANTIDADE').AsFloat) * 100) / 100) + dRateioDescontoItem + dRateioAcrescimoItem // trunca o total com 2 casas decimais
  else
    dvBCPisCofins := StrToFloat(Trim(IBQALTERACA.FieldByName('VL_ITEM').AsString)) + dRateioDescontoItem + dRateioAcrescimoItem;

  if LimpaNumero(IBQEMITENTE.FieldByName('CRT').AsString) <> CRT_SIMPLES_NACIONAL then
  begin
    if indRegraSAT(sCFOPItem) = 'T' then // if sindRegra = 'T' then
      dValorTotalItem := TruncaValor((IBQALTERACA.FieldByName('UNITARIO').AsFloat * IBQALTERACA.FieldByName('QUANTIDADE').AsFloat), 2) + dRateioDescontoItem + dRateioAcrescimoItem // trunca o total com 2 casas decimais // Sandro Silva 2019-05-23 dvBCPisCofins := (Trunc((IBQALTERACA.FieldByName('UNITARIO').AsFloat * IBQALTERACA.FieldByName('QUANTIDADE').AsFloat) * 100) / 100) + dRateioDescontoItem + dRateioAcrescimoItem // trunca o total com 2 casas decimais
    else
      dValorTotalItem := StrToFloat(Trim(IBQALTERACA.FieldByName('VL_ITEM').AsString)) + dRateioDescontoItem + dRateioAcrescimoItem;

    if sCST_ICMSItem <> '60' then // Sandro Silva 2021-08-04
    begin
      dvBCPisCofins := dvBCPisCofins - StrToFloat(FormatFloat('0.00', dpICMS_N08 * dValorTotalItem / 100));
      if dvBCPisCofins < 0 then
        dvBCPisCofins := 0.00;
    end;
  end;
  {Sandro Silva 2021-07-27 fim}

  dpPIS    := StrToFloatDef(Trim(IBQALTERACA.FieldByName('ALIQ_PIS').AsString), 0) / 100; // Sandro Silva 2016-10-27
  dpCOFINS := StrToFloatDef(Trim(IBQALTERACA.FieldByName('ALIQ_COFINS').AsString), 0) / 100; // Sandro Silva 2016-10-27

  if (sCSTPISCOFINS <> '01')
    and (sCSTPISCOFINS <> '02')
    and (sCSTPISCOFINS <> '03')
    and (sCSTPISCOFINS <> '04')
    and (sCSTPISCOFINS <> '05')
    and (sCSTPISCOFINS <> '06')
    and (sCSTPISCOFINS <> '07')
    and (sCSTPISCOFINS <> '08')
    and (sCSTPISCOFINS <> '09')
    and (sCSTPISCOFINS <> '49')
    and (sCSTPISCOFINS <> '99') then
    sCSTPISCOFINS := '01';

  if (sCSTPISCOFINS = '01')
    or (sCSTPISCOFINS = '02')
    or (sCSTPISCOFINS = '05') // Sandro Silva 2021-08-19
    or (sCSTPISCOFINS = '') then
  begin
    sPisCofinsItem := sPisCofinsItem + '<PIS>' +                                    // Q01
                         '<PISAliq>' +                                              // Q02 CST = 01 e 02
                           '<CST>' + sCSTPISCOFINS + '</CST>' +                     // Q07
                           '<vBC>' + FormataFloatXML(dvBCPisCofins, 2) + '</vBC>' + // Q08
                           '<pPIS>' + FormataFloatXML(dpPIS, 4) + '</pPIS>' +       // Q09 Sefaz-SP orientou que deve enviar a alíquota dividida por 100
                         '</PISAliq>' +
                       '</PIS>';

    // COFINS
    sPisCofinsItem := sPisCofinsItem + '<COFINS>' +                                    // S01
                         '<COFINSAliq>' +                                              // S02 CST = 01 ou 02
                           '<CST>' + sCSTPISCOFINS + '</CST>' +                        // S07
                           '<vBC>' + FormataFloatXML(dvBCPisCofins, 2) + '</vBC>' +    // S08
                           '<pCOFINS>' + FormataFloatXML(dpCOFINS, 4) + '</pCOFINS>' + // S09 Sefaz-SP orientou que deve enviar a alíquota dividida por 100
                         '</COFINSAliq>' +
                       '</COFINS>';
  end;

  if (sCSTPISCOFINS = '03') then
  begin
    sPisCofinsItem := sPisCofinsItem + '<PIS>' +                               // Q01
                         '<PISQtde>' +                                         // Q03 CST = 03
                           '<CST>' + sCSTPISCOFINS + '</CST>' +                // Q07
                           // Sandro Silva 2016-05-31  '<PISQtde>' + FormataFloatXML(StrToFloat(Trim(IBQALTERACA.FieldByName('QUANTIDADE').AsString)), 4) + '</PISQtde>' +                             // Q11
                           '<qBCProd>' + FormataFloatXML(StrToFloat(Trim(IBQALTERACA.FieldByName('QUANTIDADE').AsString)), 4) + '</qBCProd>' +                           // S11
                           '<vAliqProd>' + FormataFloatXML(StrToFloat(Trim(IBQALTERACA.FieldByName('ALIQ_PIS').AsString)), 4) + '</vAliqProd>' +                         // Q12
                         '</PISQtde>' +
                       '</PIS>';

    sPisCofinsItem := sPisCofinsItem + '<COFINS>' +                            // S01
                         '<COFINSQtde>' +                                      // S03 CST = 03
                           '<CST>' + sCSTPISCOFINS + '</CST>' +                // S07
                           '<qBCProd>' + FormataFloatXML(StrToFloat(Trim(IBQALTERACA.FieldByName('QUANTIDADE').AsString)), 4) + '</qBCProd>' +                           // S11
                           '<vAliqProd>' + FormataFloatXML(StrToFloat(Trim(IBQALTERACA.FieldByName('ALIQ_COFINS').AsString)), 4) + '</vAliqProd>' +                      // S12
                         '</COFINSQtde>' +
                       '</COFINS>';
  end;

  if (sCSTPISCOFINS = '04')
    or (sCSTPISCOFINS = '06')
    or (sCSTPISCOFINS = '07')
    or (sCSTPISCOFINS = '08')
    or (sCSTPISCOFINS = '09') then
  begin
    sPisCofinsItem := sPisCofinsItem + '<PIS>' +                // Q01
                         '<PISNT>' +                            // Q04 CST = 04, 06, 07, 08 ou 09
                           '<CST>' + sCSTPISCOFINS + '</CST>' + // Q07
                         '</PISNT>' +
                       '</PIS>';

    sPisCofinsItem := sPisCofinsItem + '<COFINS>' +             // S01
                         '<COFINSNT>' +                         // S04 CST = 04, 06, 07, 08 ou 09
                           '<CST>' + sCSTPISCOFINS + '</CST>' + // S07
                         '</COFINSNT>' +
                       '</COFINS>';

  end;

  if (sCSTPISCOFINS = '49') then
  begin
    sPisCofinsItem := sPisCofinsItem + '<PIS>' +                // Q01
                         '<PISSN>' +                            // Q05 CST = 49
                           '<CST>' + sCSTPISCOFINS + '</CST>' + // Q07
                         '</PISSN>' +
                       '</PIS>';

    sPisCofinsItem := sPisCofinsItem + '<COFINS>' +             // S01
                         '<COFINSSN>' +                         // CST = 49
                           '<CST>' + sCSTPISCOFINS + '</CST>' + // S07
                         '</COFINSSN>' +
                       '</COFINS>';

  end;

  if (sCSTPISCOFINS = '99') then
  begin
    sPisCofinsItem := sPisCofinsItem + '<PIS>' +                                     // Q01
                         '<PISOutr>' +                                               // Q06 CST = 99 Informar campos para cálculo do PIS com aliquota em percentual (Q08 e Q09) ou campos para PIS com aliquota em valor (Q11 e Q12).
                           '<CST>' + sCSTPISCOFINS + '</CST>' +                      // Q07
                           '<vBC>' + FormataFloatXML(dvBCPisCofins, 2) + '</vBC>' +  // Q08
                           '<pPIS>' + FormataFloatXML(dpPIS, 4) + '</pPIS>' +        // Q09
                           // Quando calculado por quantidade
                           //'<qBCProd></qBCProd>' +                                 // Q11
                           //'<vAliqProd></vAliqProd>' +                             // Q12
                         '</PISOutr>' +
                       '</PIS>';

    sPisCofinsItem := sPisCofinsItem + '<COFINS>' +                                     // S01
                         '<COFINSOutr>' +                                               // CST = 99
                           '<CST>' + sCSTPISCOFINS + '</CST>' +                         // S07
                           '<vBC>' + FormataFloatXML(dvBCPisCofins, 2) + '</vBC>' +     // S08
                           '<pCOFINS>' + FormataFloatXML(dpCOFINS, 4) + '</pCOFINS>' +  // S09
                           /// Quando calculado por quantidade
                           //'<qBCProd></qBCProd>' +                                    // S11
                           //'<vAliqProd></vAliqProd>' +                                // S12
                         '</COFINSOutr>' +
                       '</COFINS>';
  end;

  {Sandro Silva 2021-08-19 inicio
  if (sCSTPISCOFINS = '05') then
  begin
    sPisCofinsItem := sPisCofinsItem + '<PIS>' +                                    // Q01
                         '<PISST>' +                                                // R01
                           '<vBC>' + FormataFloatXML(dvBCPisCofins, 2) + '</vBC>' + // R02
                           '<pPIS>' + FormataFloatXML(dpPIS, 4) + '</pPIS>' +       // R03
                           // Quando calculado por quantidade
                           //'<qBCProd></qBCProd>' +                                // R04
                           //'<vAliqProd></vAliqProd>' +                            // R05
                         '</PISST>' +
                       '</PIS>';

    sPisCofinsItem := sPisCofinsItem + '<COFINS>' +                                     // S01
                         '<COFINSST>' +                                                 // T01
                           '<vBC>' + FormataFloatXML(dvBCPisCofins, 2) + '</vBC>' +     // T02
                           '<pCOFINS>' + FormataFloatXML(dpCOFINS, 4) + '</pCOFINS>' +  // T03
                           // Quando calculado por quantidade
                           //'<qBCProd></qBCProd>' +                                    // T04
                           //'<vAliqProd></vAliqProd>' +                                // T05
                         '</COFINSST>' +
                       '</COFINS>';
  end;
  {Sandro Silva 2021-08-19 fim}
  Result := sPisCofinsItem;
end;

function TMontaXmlVendaSAT.DadosPagamento(CodigoMeio: String; dValorMeio: Double): String;
begin

  if (sWA05 <> '') then
    sWA05 := '<cAdmC>' + sWA05 + '</cAdmC>';

  Result :=
    '<MP>' +                                               // WA02
     '<cMP>' + CodigoMeio + '</cMP>' +                     // WA03 Nova redação, efeitos v00.03 01 - Dinheiro; 02 - Cheque; 03 - cartão de crédito; 04 - cartão de débito; 05 - vale refeição; 06 - vale alimentação; 07 - vale presente; 08 - crédito por financeira; 09 - débito em folha de pagamento de funcionários; 10 - pagamento bancário (exemplo: boleto, depósito em conta); 11 - crédito de devolução de mercadoria; 12 - crédito de empresa conveniada 13 - pagamento antecipado; 99 - outros vales e meios de pagamento
     '<vMP>' + FormataFloatXML(dValorMeio, 2) + '</vMP>' + // WA04
     sWA05 +
   '</MP>';

end;

procedure TMontaXmlVendaSAT.AcumulaFormaExtraSAT(sOrdemExtra: String; dValor: Double);
begin

  if sOrdemExtra = SAT_CODIGO_MEIO_PAGAMENTO_10_VALE_ALIMENTACAO then
    dvMP_WA03_10 := dvMP_WA03_10 + dValor;

  if sOrdemExtra = SAT_CODIGO_MEIO_PAGAMENTO_11_VALE_REFEICAO then
    dvMP_WA03_11 := dvMP_WA03_11 + dValor;

  if sOrdemExtra = SAT_CODIGO_MEIO_PAGAMENTO_12_VALE_PRESENTE then
    dvMP_WA03_12 := dvMP_WA03_12 + dValor;

  if sOrdemExtra = SAT_CODIGO_MEIO_PAGAMENTO_13_VALE_COMBUSTIVEL then
    dvMP_WA03_13 := dvMP_WA03_13 + dValor;

  {Sandro Silva 2021-08-09 inicio}
  if sOrdemExtra = SAT_CODIGO_MEIO_PAGAMENTO_16_DEPOSITO_BANCARIO then
    dvMP_WA03_16 := dvMP_WA03_16 + dValor;
  if sOrdemExtra = SAT_CODIGO_MEIO_PAGAMENTO_17_PAGAMENTO_INSTANTANEO then
    dvMP_WA03_17 := dvMP_WA03_17 + dValor;
  if sOrdemExtra = SAT_CODIGO_MEIO_PAGAMENTO_18_TRANSFERENCIA_BANCARIA_CARTEIRA_DIGITAL then
    dvMP_WA03_18 := dvMP_WA03_18 + dValor;
  if sOrdemExtra = SAT_CODIGO_MEIO_PAGAMENTO_19_PROGRAMA_FIDELIDADE_CASHBACK_CREDITO_VIRTUAL then
    dvMP_WA03_19 := dvMP_WA03_19 + dValor;
  {Sandro Silva 2021-08-09 fim}

  if sOrdemExtra = SAT_CODIGO_MEIO_PAGAMENTO_99_OUTROS then
    dvMP_WA03_99 := dvMP_WA03_99 + dValor;
end;

function TMontaXmlVendaSAT.MontaXMLVenda(_59: TSmall59; sCaixa: String; dtData: TDate;
  sCupom: String; var sLog: String): AnsiString;
var
  iTransacaoCartao: Integer; // Sandro Silva 2017-06-16
begin
  sXMLCFe := ''; // Sandro Silva 2016-04-12
  sLog := ''; // Sandro Silva 2021-03-11

  slLog := TStringList.Create;
  {Sandro Silva 2021-11-25 inicio
  IBQALTERACA       := CriaIBQuery(Form1.ibDataSet27.Transaction);
  IBQDESCONTOITEM   := CriaIBQuery(Form1.ibDataSet27.Transaction);
  IBQDESCONTOCUPOM  := CriaIBQuery(Form1.ibDataSet27.Transaction);
  IBQACRESCIMOCUPOM := CriaIBQuery(Form1.ibDataSet27.Transaction);
  IBQCLIFOR         := CriaIBQuery(Form1.ibDataSet27.Transaction);
  IBQEMITENTE       := CriaIBQuery(Form1.ibDataSet27.Transaction);
  IBQTOTALCUPOM     := CriaIBQuery(Form1.ibDataSet27.Transaction);
  IBQLEI12741       := CriaIBQuery(Form1.ibDataSet27.Transaction);
  }
  IBQALTERACA       := CriaIBQuery(_59.ibDataSet27.Transaction);
  IBQDESCONTOITEM   := CriaIBQuery(_59.ibDataSet27.Transaction);
  IBQDESCONTOCUPOM  := CriaIBQuery(_59.ibDataSet27.Transaction);
  IBQACRESCIMOCUPOM := CriaIBQuery(_59.ibDataSet27.Transaction);
  IBQCLIFOR         := CriaIBQuery(_59.ibDataSet27.Transaction);
  IBQEMITENTE       := CriaIBQuery(_59.ibDataSet27.Transaction);
  IBQTOTALCUPOM     := CriaIBQuery(_59.ibDataSet27.Transaction);
  IBQLEI12741       := CriaIBQuery(_59.ibDataSet27.Transaction);
  {Sandro Silva 2021-11-25 fim}

  try

    try
      IBQEMITENTE.Close;
      IBQEMITENTE.SQL.Text :=
        'select first 1 EM.CGC, EM.IE, EM.IM, EM.MUNICIPIO, EM.CRT, EM.ESTADO, ' +
        'MUN.CODIGO, ' +
        '(select CHAVE from IBPT_ where CODIGO=''01012100'') as CHAVE_IBPT ' +
        'from EMITENTE EM ' +
        'left join MUNICIPIOS MUN on MUN.NOME = EM.MUNICIPIO and MUN.UF = EM.ESTADO ';
      IBQEMITENTE.Open;

      // Seleciona os itens vendidos
      IBQALTERACA.Close;
      IBQALTERACA.SQL.Text :=
        'select ' +
        '(select first 1 A2.CLIFOR ' +
         'from ALTERACA A2 ' +
         'where coalesce(A2.CLIFOR,  '''') <> '''' ' +
         'and A2.PEDIDO = A.PEDIDO ' +
         'and A2.TIPO = A.TIPO ' +
         'and A2.CAIXA = A.CAIXA ' +
         'and A2.DATA = A.DATA ' +
         'order by A2.REGISTRO) as CLIFOR, ' +
        '(select first 1 A2.CNPJ ' +
         'from ALTERACA A2 ' +
         'where coalesce(A2.CLIFOR,  '''') <> '''' ' +
         'and A2.PEDIDO = A.PEDIDO ' +
         'and A2.TIPO = A.TIPO ' +
         'and A2.CAIXA = A.CAIXA ' +
         'and A2.DATA = A.DATA ' +
         'order by A2.REGISTRO) as CNPJ, ' +
        'A.REGISTRO, ' + // Sandro Silva 2019-04-08
        'A.ITEM, A.CODIGO, A.DESCRICAO, A.MEDIDA as UN, A.QUANTIDADE, A.UNITARIO, ' +
        'A.CST_ICMS, A.ALIQUICM, A.CST_PIS_COFINS, A.ALIQ_PIS, A.ALIQ_COFINS, A.CFOP, ' +
        '(coalesce(A.TOTAL, 0) + coalesce(A.DESCONTO, 0)) as VL_ITEM, A.CSOSN, ' +
        'E.REFERENCIA as EAN, E.CF as NCM, coalesce(E.IAT, ''T'') as IAT, E.CSOSN as ESTOQUE_CSOSN, ' +
        'E.TIPO_ITEM, E.LIVRE4, E.IIA, E.CFOP as ESTOQUE_CFOP, ' +
        'E.ALIQUOTA_NFCE, E.CSOSN_NFCE, E.CST_NFCE, ' + // 2016-01-13
        'E.CEST, ' + // Sandro Silva 2016-03-24
        'E.TAGS_, ' + // Sandro Silva 2019-04-16
        '(select first 1 ICM.ISS from ICM where ICM.NOME = ''Serviços'' or coalesce(ICM.ISS, 0) > 0) as ISS ' + // 2016-01-13
        'from ALTERACA A ' +
        'left join ESTOQUE E on E.CODIGO = A.CODIGO ' +
        'where A.PEDIDO = ' + QuotedStr(sCupom) +
        ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
        ' and A.CAIXA = ' + QuotedStr(sCaixa) +
        ' and A.DATA = ' + QuotedStr(FormataDataSQL(dtData)) +
        ' and (A.DESCRICAO <> ''<CANCELADO>'' ' +
         ' and A.DESCRICAO <> ''Desconto'' ' +
         ' and A.DESCRICAO <> ''Acréscimo'') ' +
        ' and coalesce(A.ITEM, '''') <> '''' ' + // Que tenha número do item informado no campo ALTERACA.ITEM
        ' order by A.REGISTRO';
      IBQALTERACA.Open;

      // Seleciona os descontos concedidos específicos aos itens
      IBQDESCONTOITEM.Close;
      IBQDESCONTOITEM.SQL.Text :=
        'select A.CODIGO, A.ITEM, A.TOTAL as DESCONTO ' +
        'from ALTERACA A ' +
        'where A.PEDIDO = ' + QuotedStr(sCupom) +
        ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
        ' and A.CAIXA = ' + QuotedStr(sCaixa) +
        ' and A.DATA = ' + QuotedStr(FormataDataSQL(dtData)) +
        ' and A.DESCRICAO = ''Desconto'' ' +
        ' and coalesce(A.ITEM, '''') <> '''' ' +
        ' order by A.ITEM'; // Que tenha número do item informado no campo ALTERACA.ITEM
      IBQDESCONTOITEM.Open;

      // Seleciona os descontos lançados para o cupom
      IBQDESCONTOCUPOM.Close;
      IBQDESCONTOCUPOM.SQL.Text :=
        'select sum(A.TOTAL) as DESCONTOCUPOM ' +
        'from ALTERACA A ' +
        'where A.PEDIDO = ' + QuotedStr(sCupom) +
        ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
        ' and A.CAIXA = ' + QuotedStr(sCaixa) +
        ' and A.DATA = ' + QuotedStr(FormataDataSQL(dtData)) +
        ' and A.DESCRICAO = ''Desconto'' ' +
        ' and coalesce(A.ITEM, '''') = '''' ';
      IBQDESCONTOCUPOM.Open;

      // Seleciona os acréscimos lançados para o cupom
      IBQACRESCIMOCUPOM.Close;
      IBQACRESCIMOCUPOM.SQL.Text :=
        'select sum(A.TOTAL) as ACRESCIMOCUPOM ' +
        'from ALTERACA A ' +
        'where A.PEDIDO = ' + QuotedStr(sCupom) +
        ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
        ' and A.CAIXA = ' + QuotedStr(sCaixa) +
        ' and A.DATA = ' + QuotedStr(FormataDataSQL(dtData)) +
        ' and A.DESCRICAO = ''Acréscimo'' ' +
        ' and coalesce(A.ITEM, '''') = '''' ';
      IBQACRESCIMOCUPOM.Open;

      // Seleciona o total do cupom
      IBQTOTALCUPOM.Close;
      IBQTOTALCUPOM.SQL.Text :=
        'select sum(A.TOTAL + coalesce(A.DESCONTO, 0)) as TOTALCUPOM ' +
        'from ALTERACA A ' +
        'where A.PEDIDO = ' + QuotedStr(sCupom) +
        ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
        ' and A.CAIXA = ' + QuotedStr(sCaixa) +
        ' and A.DATA = ' + QuotedStr(FormataDataSQL(dtData)) +
        ' and (A.DESCRICAO <> ''<CANCELADO>'') '  +
        ' and (A.DESCRICAO <> ''Desconto'') ' +
        ' and (A.DESCRICAO <> ''Acréscimo'') ';
      IBQTOTALCUPOM.Open;

      if IBQALTERACA.Eof = False then
      begin
        ssignAC := _59.AssinaturaAssociada; // Sandro Silva 2016-11-09  AssinaturaAssociada;

        sDadosIde := '<ide>' +                         // B01
                       '<CNPJ>' + _59.CNPJSoftwareHouse + '</CNPJ>' + // Sandro Silva 2016-11-09  B11                '<CNPJ>' + FCNPJSoftwareHouse + '</CNPJ>' + // B11
                       '<signAC>' + ssignAC + '</signAC>' +     // B12
                       '<numeroCaixa>' + sCaixa + '</numeroCaixa>' + // B14 utilizando equipamento ou emulador compatível com específicação 2.3.13 ou superior
                     '</ide>';
        // Seleciona dados do emitente
        sCNPJEmitente := LimpaNumero(_59.Emitente.CNPJ);
        sIEEmitente   := LimpaNumero(_59.Emitente.IE);
        sIMEmitente   := LimpaNumero(_59.Emitente.IM);

        if LerParametroIni('FRENTE.INI', 'SAT-CFe', 'Completar IE', 'Não') = 'Sim' then
          sIEEmitente := Right(DupeString('0', 12) + sIEEmitente, 12); // TANCA valida IE. Precisa tem ao menos 12 digitos

        sDadosEmitente :=
          '<emit>' +                        //C01
            '<CNPJ>' + sCNPJEmitente + '</CNPJ>' +  // C02
            '<IE>' + sIEEmitente + '</IE>';        // C12
        if Trim(LimpaNumero(sIMEmitente)) <> '' then
          sDadosEmitente := sDadosEmitente +
                '<IM>' + sIMEmitente + '</IM>';       // C13

        sDadosEmitente := sDadosEmitente +
                '<cRegTribISSQN>1</cRegTribISSQN>' +                                                    // C15
                '<indRatISSQN>S</indRatISSQN>' +                                                        // C16
              '</emit>';

        sDadosDestinatario := '<dest/>';
        sDadosLocalEntrega := '';

        IBQCLIFOR.Close;
        IBQCLIFOR.SQL.Text :=
          'select first 1 NOME, CGC as CNPJ, ENDERE as ENDERECO, ' +
          'COMPLE as BAIRRO, CIDADE, ESTADO as UF ' +
          'from CLIFOR ' +
          'where NOME = ' + QuotedStr(IBQALTERACA.FieldByName('CLIFOR').AsString);
        IBQCLIFOR.Open;

        //
        if (IBQALTERACA.FieldByName('CLIFOR').AsString = IBQCLIFOR.FieldByName('NOME').AsString)
          and (Alltrim(IBQCLIFOR.FieldByName('NOME').AsString) <> '') then
        begin

          sDadosDestinatario := '<dest>';
          if Trim(LimpaNumero(IBQCLIFOR.FieldByName('CNPJ').AsString)) <> '' then
          begin
            if Length(Trim(LimpaNumero(IBQCLIFOR.FieldByName('CNPJ').AsString))) > 11 then
              sDadosDestinatario := sDadosDestinatario + '<CNPJ>' + Trim(LimpaNumero(IBQCLIFOR.FieldByName('CNPJ').AsString)) + '</CNPJ>' //E02
            else
              sDadosDestinatario := sDadosDestinatario + '<CPF>' + Trim(LimpaNumero(IBQCLIFOR.FieldByName('CNPJ').AsString)) + '</CPF>'   //E03
          end;

          if (Trim(IBQALTERACA.FieldByName('CLIFOR').AsString) <> '') then
            sDadosDestinatario := sDadosDestinatario +
              '<xNome>' + Trim(Copy(ConverteAcentos2(IBQALTERACA.FieldByName('CLIFOR').AsString), 1, 60)) + '</xNome>'; //E04

          sDadosDestinatario := sDadosDestinatario + '</dest>';

          if (Trim(IBQCLIFOR.FieldByName('ENDERECO').AsString) <> '')
            or (Trim(IBQCLIFOR.FieldByName('BAIRRO').AsString) <> '')
            or (Trim(IBQCLIFOR.FieldByName('CIDADE').AsString) <> '')
            or (Trim(IBQCLIFOR.FieldByName('UF').AsString) <> '') then
          begin
            sDadosLocalEntrega := '<entrega>';

            if (Trim(IBQCLIFOR.FieldByName('ENDERECO').AsString) <> '') then
            begin
              sDadosLocalEntrega := sDadosLocalEntrega + '<xLgr>' + Trim(ConverteAcentos2(Endereco_Sem_Numero(Trim(IBQCLIFOR.FieldByName('ENDERECO').AsString)))) + '</xLgr>';
              sDadosLocalEntrega := sDadosLocalEntrega + '<nro>' + Numero_Sem_Endereco(Trim(IBQCLIFOR.FieldByName('ENDERECO').AsString)) + '</nro>';
            end
            else
            begin
              sDadosLocalEntrega := sDadosLocalEntrega + '</xLgr>';
              sDadosLocalEntrega := sDadosLocalEntrega + '</nro>';
            end;

            if (Trim(IBQCLIFOR.FieldByName('BAIRRO').AsString) <> '') then
              sDadosLocalEntrega := sDadosLocalEntrega + '<xBairro>' + Trim(ConverteAcentos2(IBQCLIFOR.FieldByName('BAIRRO').AsString)) + '</xBairro>'
            else
              sDadosLocalEntrega := sDadosLocalEntrega + '</xBairro>';

            if (Trim(IBQCLIFOR.FieldByName('CIDADE').AsString) <> '') then
              sDadosLocalEntrega := sDadosLocalEntrega + '<xMun>' + Trim(ConverteAcentos2(IBQCLIFOR.FieldByName('CIDADE').AsString)) + '</xMun>'
            else
              sDadosLocalEntrega := sDadosLocalEntrega + '</xMun>';

            if (Trim(IBQCLIFOR.FieldByName('UF').AsString) <> '') then
              sDadosLocalEntrega := sDadosLocalEntrega + '<UF>' + Trim(IBQCLIFOR.FieldByName('UF').AsString) + '</UF>'
            else
              sDadosLocalEntrega := sDadosLocalEntrega + '</UF>';

           sDadosLocalEntrega := sDadosLocalEntrega + '</entrega>';
          end;
        end
        else
        begin


          {Sandro Silva 2021-11-25 inicio
          if ((IBQALTERACA.FieldByName('CLIFOR').AsString = '') and (LimpaNumero(Form2.Edit2.Text) <> '')) or (Trim(Form2.Edit8.Text) <> '') then // Ficha 4251 Sandro Silva 2018-10-29 if (IBQALTERACA.FieldByName('CLIFOR').AsString = '') and (LimpaNumero(Form2.Edit2.Text) <> '') then
          begin

            sDadosDestinatario := '<dest>';
            if Trim(LimpaNumero(Form2.Edit2.Text)) <> '' then
            begin
              if Length(Trim(LimpaNumero(Form2.Edit2.Text))) > 11 then
                sDadosDestinatario := sDadosDestinatario + '<CNPJ>' + Trim(LimpaNumero(Form2.Edit2.Text)) + '</CNPJ>' //E02
              else
                sDadosDestinatario := sDadosDestinatario + '<CPF>' + Trim(LimpaNumero(Form2.Edit2.Text)) + '</CPF>'   //E03
            end;

            if (Trim(Form2.Edit8.Text) <> '') then
            begin
              sDadosDestinatario := sDadosDestinatario +
                '<xNome>' + Copy(ConverteAcentos2(Trim(Form2.Edit8.Text)), 1, 60) + '</xNome>'; //E04
            end;

            sDadosDestinatario := sDadosDestinatario + '</dest>';
          end;
          }

          if ((IBQALTERACA.FieldByName('CLIFOR').AsString = '') and (LimpaNumero(FDestinatarioInformadoNaTela.CnpjCPF) <> '')) or (Trim(FDestinatarioInformadoNaTela.Nome) <> '') then // Ficha 4251
          begin

            sDadosDestinatario := '<dest>';
            if Trim(LimpaNumero(FDestinatarioInformadoNaTela.CnpjCPF)) <> '' then
            begin
              if Length(Trim(LimpaNumero(FDestinatarioInformadoNaTela.CnpjCPF))) > 11 then
                sDadosDestinatario := sDadosDestinatario + '<CNPJ>' + Trim(LimpaNumero(FDestinatarioInformadoNaTela.CnpjCPF)) + '</CNPJ>' //E02
              else
                sDadosDestinatario := sDadosDestinatario + '<CPF>' + Trim(LimpaNumero(FDestinatarioInformadoNaTela.CnpjCPF)) + '</CPF>'   //E03
            end;

            if (Trim(FDestinatarioInformadoNaTela.Nome) <> '') then
            begin
              sDadosDestinatario := sDadosDestinatario +
                '<xNome>' + Copy(ConverteAcentos2(Trim(FDestinatarioInformadoNaTela.Nome)), 1, 60) + '</xNome>'; //E04
            end;

            sDadosDestinatario := sDadosDestinatario + '</dest>';
          end;

          //Ficha 4251
          if sDadosDestinatario = '<dest>' + '</dest>' then
            sDadosDestinatario := '';

        end; //if (IBQALTERACA.FieldByName('IBQALTERACA').AsString <> '')

        sDadosItens    := '';
        iItem          := 1;
        dTotalLei12741 := 0;
        dTotal         := 0;

        while IBQALTERACA.Eof = False do
        begin
          _59.IBDATASET27.Locate('REGISTRO', IBQALTERACA.FieldByName('REGISTRO').AsString, []);// Posiciona no mesmo item nos 2 DataSet Sandro Silva 2019-04-08

          sDadosItens := sDadosItens +
              '<det nItem="' + IntToStr(iItem) + '">' +                  // H01
                '<prod>';                                                 // I01

          if (RetornaValorDaTagNoCampo('cProd', IBQALTERACA.FieldByname('TAGS_').AsString) <> '') then // Ficha  4796
            sDadosItens := sDadosItens + '<cProd>' + Copy(RetornaValorDaTagNoCampo('cProd', IBQALTERACA.FieldByname('TAGS_').AsString), 1, 60) + '</cProd>'  // I02
          else
            sDadosItens := sDadosItens + '<cProd>' + IBQALTERACA.FieldByName('CODIGO').AsString + '</cProd>';         // I02

          if ValidaEAN(Trim(IBQALTERACA.FieldByName('EAN').AsString)) then // Preencher com o código GTIN-8, GTIN-12, GTIN-13 ou GTIN-14 (antigos códigos EAN, UPC e DUN-14), não informar o conteúdo da TAG em caso de o produto não possuir este código.
            sDadosItens := sDadosItens + '<cEAN>' + IBQALTERACA.FieldByName('EAN').AsString + '</cEAN>';           // I03

          sDadosItens := sDadosItens + '<xProd>' + Trim(ConverteAcentos2(IBQALTERACA.FieldByName('DESCRICAO').AsString)) + '</xProd>';     // I04

          // Código NCM (8 posições), informar o gênero (posição do capítulo do NCM)
          // quando a operação não for de comércio exterior (importação/ exportação)
          // ou o produto não seja tributado pelo IPI.
          // Em caso de serviço informar o código 99

          if Trim(IBQALTERACA.FieldByName('TIPO_ITEM').AsString) = '09' then
              sDadosItens := sDadosItens + '<NCM>99</NCM>'       // I05
          else
            if Length(Trim(IBQALTERACA.FieldByName('NCM').AsString)) in [2, 8] then
              sDadosItens := sDadosItens + '<NCM>' + Trim(IBQALTERACA.FieldByName('NCM').AsString) + '</NCM>'       // I05
            else
              slLog.Add('Ajuste no estoque ' + IBQALTERACA.FieldByName('CODIGO').AsString + '-' + IBQALTERACA.FieldByName('DESCRICAO').AsString + ' - NCM inválido: "' + Trim(IBQALTERACA.FieldByName('NCM').AsString) + '"'); // Sandro Silva 2021-03-10

          if (_59.VersaoDadosEnt <> VDE_007) then
          begin
            if Trim(IBQALTERACA.FieldByName('CEST').AsString) <> '' then
              sDadosItens := sDadosItens + '<CEST>' + Trim(IBQALTERACA.FieldByName('CEST').AsString) + '</CEST>';       // I05
          end;

          sCFOPItem := Trim(ExtrairConfiguracao(IBQALTERACA.FieldByName('LIVRE4').AsString, SIGLA_CFOP_ST_ECF));

          if Trim(IBQALTERACA.FieldByName('ESTOQUE_CFOP').AsString) <> '' then
            sCFOPItem := Trim(IBQALTERACA.FieldByName('ESTOQUE_CFOP').AsString);

          if sCFOPItem = '' then
          begin
            if Trim(IBQALTERACA.FieldByName('TIPO_ITEM').AsString) = '09' then
              sCFOPItem := '5933'
            else
              sCFOPItem := '5102';
          end;

          if _59.IBDATASET27.FieldByName('CFOP').AsString <> sCFOPItem then
          begin
            _59.IBDATASET27.Edit;
            _59.IBDATASET27.FieldByName('CFOP').AsString := sCFOPItem;
            _59.IBDATASET27.Post;
          end;

          sOrigItem := LimpaNumero(Copy(IBQALTERACA.FieldByName('CST_ICMS').AsString, 1, 1)); // Sandro Silva 2021-03-11 Trim(Copy(IBQALTERACA.FieldByName('CST_ICMS').AsString, 1, 1));
          if sOrigItem = '' then
            sOrigItem := '0';

          sUnidadeMedida := Trim(IBQALTERACA.FieldByName('UN').AsString);
          if sUnidadeMedida = '' then
            sUnidadeMedida := 'UN';

          //Sempre considerar 3 casas, para evitar conflitos em outras rotinas do frente de caixa Sandro Silva 2019-05-20
          svUnCom := FormataFloatXML(IBQALTERACA.FieldByName('UNITARIO').AsFloat, 3);
          //Regra: Deve ser informado com 3 decimais no caso de combustíveis (Portaria DNC 30/94), para os demais com 2 decimais. Ver Especificação_SAT_v_ER_2_27_05.pdf
          if (sCFOPItem <> '5656') and (sCFOPItem <> '5667') then // Sandro Silva 2019-05-23
          begin
            if Right(svUnCom, 1) = '0' then // Sandro Silva 2016-03-24
              svUnCom := Copy(svUnCom, 1, Length(svUnCom) - 1);
          end;

          sDadosItens := sDadosItens + '<CFOP>' + sCFOPItem + '</CFOP>' +                                    // I06
                  '<uCom>' + sUnidadeMedida + '</uCom>' +                                                    // I07
                  '<qCom>' + FormataFloatXML(IBQALTERACA.FieldByName('QUANTIDADE').AsFloat, 4) + '</qCom>' + // I08
                  '<vUnCom>' + svUnCom + '</vUnCom>';                                                        // I09
          sDadosItens := sDadosItens + '<indRegra>' + indRegraSAT(sCFOPItem) + '</indRegra>';                // I11  sDadosItens := sDadosItens + '<indRegra>' + sindRegra + '</indRegra>';                // I11

          dDescontoItem := 0;
          if IBQDESCONTOITEM.Locate('ITEM', IBQALTERACA.FieldByName('ITEM').AsString, []) then
            dDescontoItem := IBQDESCONTOITEM.FieldByName('DESCONTO').AsFloat;
          if Abs(dDescontoItem) > 0 then
            sDadosItens := sDadosItens + '<vDesc>' + FormataFloatXML(Abs(dDescontoItem), 2) + '</vDesc>';    // I12

          dRateioDescontoItem := StrToFloat(StrZero((((IBQALTERACA.FieldByName('QUANTIDADE').AsFloat * IBQALTERACA.FieldByName('UNITARIO').AsFloat) +
                                                      dDescontoItem) / IBQTOTALCUPOM.FieldByName('TOTALCUPOM').AsFloat) * IBQDESCONTOCUPOM.FieldByName('DESCONTOCUPOM').AsFloat, 0, 2));

          dRateioAcrescimoItem := StrToFloat(StrZero((((IBQALTERACA.FieldByName('QUANTIDADE').AsFloat * IBQALTERACA.FieldByName('UNITARIO').AsFloat) +
                                                      dDescontoItem) / IBQTOTALCUPOM.FieldByName('TOTALCUPOM').AsFloat) * IBQACRESCIMOCUPOM.FieldByName('ACRESCIMOCUPOM').AsFloat, 0, 2));

          if _59.VersaoDadosEnt = VDE_007 then // Sandro Silva 2019-04-16
          begin

            // Informações CEST
            if (LimpaNumero(IBQALTERACA.FieldByName('CEST').AsString) <> '')
              and (Trim(IBQALTERACA.FieldByName('TIPO_ITEM').AsString) <> '09') then
            begin
              //Artigo 1º - Fica acrescentado o Artigo 33-B à Portaria CAT 147/12, de 5 de novembro de 2012, com a seguinte redação:
              //“Artigo 33-B - Nas operações com mercadorias ou bens listados nos Anexos do Convênio ICMS 92, de 20-08-2015, sujeitos aos regimes de substituição tributária ou de antecipação do recolhimento do imposto, o contribuinte deverá preencher obrigatoriamente o respectivo Código Especificador da Substituição Tributária - CEST, conforme segue:
              //I - campo ID I18 (xCampoDet): preencher com “Cod. CEST”;
              //II - campo ID I19 (xTextoDet): utilizar o Código Especificador da Substituição Tributária - CEST, conforme definido no convênio ICMS 92, de 20-08-2015.” (NR).
              //Artigo 2º - Esta portaria entra em vigor na data de sua publicação, produzindo efeitos a partir de 01-04-2016. (Redação dada ao artigo pela Portaria CAT-155/15, de 23-12-2015; DOE 24-12-2015)
              //Artigo 2º - Esta portaria entra em vigor na data de sua publicação, produzindo efeitos a partir de 01-01-2016.

              sDadosItens := sDadosItens + '<obsFiscoDet xCampoDet="' + 'Cod. CEST' + '">' +
                                             '<xTextoDet>' + LimpaNumero(IBQALTERACA.FieldByName('CEST').AsString) + '</xTextoDet>' +
                                           '</obsFiscoDet>';
            end;

          end;

          if (sCFOPItem = '5656') or (sCFOPItem = '5667') then // Combustível // Sandro Silva 2019-05-20 if (sCFOPItem = '5656') then // Combustível
          begin
            // Nova   redação   para   efeitos   a partir de 01.01.19:
            // Conteúdo do campo. No caso de combustíveis  e/ou   lubrificantes, quando informado “CFOP 5656 –Venda de combustível ou lubrificante adquirido ou recebido de terceiros destinado a consumidor  ou  usuário  final”,
            // informar  código  de  produto  do Sistema    de    Informações    de Movimentação    de    produtos-SIMP (http://www.anp.gov.br/simp).
            // Informar 999999999 se o produto  não  possuir  código  de produto ANP.
            sCodigoANP := Trim(RetornaValorDaTagNoCampo('cProdANP', IBQALTERACA.FieldByname('TAGS_').AsString));
            if sCodigoANP = '' then
            begin
              // Sandro Silva 2021-11-25 Form1.ExibePanelMensagem(IBQALTERACA.FieldByname('CODIGO').AsString + ' ' + IBQALTERACA.FieldByname('DESCRICAO').AsString + ' sem CODIGO ANP. Preencha a tag cProdANP no cadastro do estoque');
              // Sandro Silva 2021-11-25 Sleep(5000);
              sCodigoANP := '999999999';
            end;
            sDadosItens := sDadosItens + '<obsFiscoDet xCampoDet="' + 'Cod. Produto ANP' + '">' +
                                           '<xTextoDet>' + sCodigoANP + '</xTextoDet>' +
                                         '</obsFiscoDet>';
          end;

          sDadosItens := sDadosItens +
                 // Quando frente vai gerar informação para este elemento? '<vOutro>0.00</vOutro>' +                                   // I13
                '</prod>' +
                '<imposto>';                                             // M01
          // 2014-01-17 sDadosItens := sDadosItens + '<vItem12741>0.00</vItem12741>';
          IBQLEI12741.Close;
          IBQLEI12741.SQL.Text :=
            'select IIA as TRIBUTOSFEDERAL, '
                 + 'IIA_UF as TRIBUTOSESTADUAL, '
                 + 'IIA_MUNI as TRIBUTOSMUNICIPAL '
            + 'from ESTOQUE '
            + 'where CODIGO = ' + QuotedStr(IBQALTERACA.FieldByName('CODIGO').AsString);
          IBQLEI12741.Open;

          dValorLiquidoItem := (IBQALTERACA.FieldByName('QUANTIDADE').AsFloat * IBQALTERACA.FieldByName('UNITARIO').AsFloat)
                                                      + dDescontoItem
                                                      + dRateioDescontoItem
                                                      + dRateioAcrescimoItem;

          dItemImpostoLei12741 := StrtoFloat(FormatFloat('#0.00', (IBQLEI12741.FieldByName('TRIBUTOSFEDERAL').AsFloat / 100) * dValorLiquidoItem));
          dItemImpostoLei12741 := dItemImpostoLei12741 + StrtoFloat(FormatFloat('#0.00', (IBQLEI12741.FieldByName('TRIBUTOSESTADUAL').AsFloat / 100) * dValorLiquidoItem));
          dItemImpostoLei12741 := dItemImpostoLei12741 + StrtoFloat(FormatFloat('#0.00', (IBQLEI12741.FieldByName('TRIBUTOSMUNICIPAL').AsFloat / 100) * dValorLiquidoItem));


          dTotalLei12741 := dTotalLei12741 + dItemImpostoLei12741;

          sDadosItens := sDadosItens + '<vItem12741>' + FormataFloatXML(dItemImpostoLei12741, 2) + '</vItem12741>';

          if Trim(IBQALTERACA.FieldByName('TIPO_ITEM').AsString) <> '09' then
          begin
            // Produtos

            sDadosItens := sDadosItens + '<ICMS>';                                 // N01

            if LimpaNumero(IBQEMITENTE.FieldByName('CRT').AsString) = CRT_SIMPLES_NACIONAL then
            begin

              sCSOSNItem := Trim(IBQALTERACA.FieldByName('CSOSN').AsString); // Primeiro ALTERACA.CSOSN
              if sCSOSNItem = '' then
              begin // CSOSN ficou vazio
                sCSOSNItem := Trim(IBQALTERACA.FieldByName('ESTOQUE_CSOSN').AsString); // Usa CSOSN configurado no ESTOQUE ESTOQUE.CSOSN
                if Trim(IBQALTERACA.FieldByName('CSOSN_NFCE').AsString) <> '' then // Se tem configurado CSOSN para movimentar no balcão, prioridade para ele
                  sCSOSNItem := Trim(IBQALTERACA.FieldByName('CSOSN_NFCE').AsString); // ESTOQUE.CSOSN_NFCE
              end
              else
              begin
                {Sandro Silva 2021-08-26 inicio}

                // Caso tenha lançado o item na venda, ocorreu rejeição e tenha corrigido no Estoque
                // Permite alterar sem precisar cancelar o item e lançar novamente

                if Trim(IBQALTERACA.FieldByName('CSOSN_NFCE').AsString) <> '' then // Tem CSOSN definido para venda no balcão
                begin
                  if Trim(IBQALTERACA.FieldByName('CSOSN').AsString) <> Trim(IBQALTERACA.FieldByName('CSOSN_NFCE').AsString) then // O CSOSN que foi salvo no Alteraca é diferente daquele definido no Estoque para venda no balcão
                    sCSOSNItem := Trim(IBQALTERACA.FieldByName('CSOSN_NFCE').AsString); // Priodidade para o CSOSN definido para venda no balcão ESTOQUE.CSOSN
                end
                else
                begin
                  // Não tem CSOSN definido para venda no balcão

                  if Trim(IBQALTERACA.FieldByName('ESTOQUE_CSOSN').AsString) <> '' then // O CSOSN foi configurado no Estoque
                  begin
                    if Trim(IBQALTERACA.FieldByName('CSOSN').AsString) <> Trim(IBQALTERACA.FieldByName('ESTOQUE_CSOSN').AsString) then // O CSOSN que foi salvo no Alteraca é diferente daquele definido no Estoque
                      sCSOSNItem := Trim(IBQALTERACA.FieldByName('ESTOQUE_CSOSN').AsString); // Usa o CSOSN do Estoque ESTOQUE.CSOSN
                  end;
                end;
                {Sandro Silva 2021-08-26 fim}
              end;

              {Sandro Silva 2021-08-26 inicio}
              if (Trim(sCSOSNItem) <> '') and (Trim(sCSOSNItem) <> Trim(IBQALTERACA.FieldByName('CSOSN').AsString)) then // Se o CSOSN selecionado é diferente daquele lançado no Alteraca faz a atualização no Alteraca
              begin

                {Sandro Silva 2021-11-25 inicio
                // Atualiza ALTERACA.CSOSN com aquele que será informado no xml
                Form1.ibDataSet27.Close;
                Form1.ibDataSet27.SelectSQL.Text :=
                  'select * ' +
                  'from ALTERACA ' +
                  'where CAIXA = ' + QuotedStr(sCaixa) +
                  ' and PEDIDO = ' + QuotedStr(sCupom) +
                  ' and ITEM = ' + QuotedStr(IBQALTERACA.FieldByName('ITEM').AsString);
                Form1.ibDataSet27.Open;

                if (sCupom = Form1.ibDataSet27.FieldByName('PEDIDO').AsString) and (IBQALTERACA.FieldByName('ITEM').AsString = Form1.ibDataSet27.FieldByName('ITEM').AsString) then
                begin
                  Form1.ibDataSet27.Edit;
                  Form1.ibDataSet27.FieldByName('CSOSN').AsString := Trim(sCSOSNItem);
                  Form1.ibDataSet27.Post;
                end;
                }
                // Atualiza ALTERACA.CSOSN com aquele que será informado no xml                
                _59.ibDataSet27.Close;
                _59.ibDataSet27.SelectSQL.Text :=
                  'select * ' +
                  'from ALTERACA ' +
                  'where CAIXA = ' + QuotedStr(sCaixa) +
                  ' and PEDIDO = ' + QuotedStr(sCupom) +
                  ' and ITEM = ' + QuotedStr(IBQALTERACA.FieldByName('ITEM').AsString);
                _59.ibDataSet27.Open;

                if (sCupom = _59.ibDataSet27.FieldByName('PEDIDO').AsString) and (IBQALTERACA.FieldByName('ITEM').AsString = _59.ibDataSet27.FieldByName('ITEM').AsString) then
                begin
                  _59.ibDataSet27.Edit;
                  _59.ibDataSet27.FieldByName('CSOSN').AsString := Trim(sCSOSNItem);
                  _59.ibDataSet27.Post;
                end;
                {Sandro Silva 2021-11-25 fim}

              end;
              {Sandro Silva 2021-08-26 fim}
          
              {Sandro Silva 2021-03-11 inicio}
              if Trim(sCSOSNItem) = '' then
              begin
                slLog.Add(IBQALTERACA.FieldByName('CODIGO').AsString + '-' + IBQALTERACA.FieldByName('DESCRICAO').AsString + ' - CSOSN inválido: "' + Trim(sCSOSNItem) + '"'); // Sandro Silva 2021-03-10
              end;
              {Sandro Silva 2021-03-11 fim}

              if ((_59.VersaoDadosEnt = VDE_007) and ((sCSOSNItem = '102') or (sCSOSNItem = '300') or (sCSOSNItem = '400') or (sCSOSNItem = '500')) )
                or ((_59.VersaoDadosEnt = VDE_008) and ((sCSOSNItem = '102') or (sCSOSNItem = '300') or (sCSOSNItem = '400') or (sCSOSNItem = '500')) ) // Sandro Silva 2019-04-16
               then
              begin
                //102- Tributada pelo Simples Nacional sem permissão de crédito.
                //300 – Imune
                //400 – Não tributada
                //500 – ICMS cobrado anteriormente por substituição tributária (substituído) ou por antecipação
                sDadosItens := sDadosItens + '<ICMSSN102>' +                         // N04 Tributação do ICMS: pelo SIMPLES NACIONAL e CSOSN=102, 300, 500
                                               '<Orig>' + sOrigItem + '</Orig>' +    // N06
                                               '<CSOSN>' + sCSOSNItem + '</CSOSN>' + // N10
                                             '</ICMSSN102>';
              end
              else
              begin // Outros CSOSN. Ex.: 900
                sDadosItens := sDadosItens + '<ICMSSN900>' +                         // N05 Tributação do ICMS: pelo SIMPLES NACIONAL e CSOSN=900
                                               '<Orig>' + sOrigItem + '</Orig>' +    // N06
                                               '<CSOSN>' + sCSOSNItem + '</CSOSN>' + // N10
                                               '<pICMS>' + FormataFloatXML(StrToFloat(AliquotaIcms(Trim(IBQALTERACA.FieldByName('ALIQUICM').AsString))), 2) + '</pICMS>' + // N08
                                             '</ICMSSN900>';
              end;
            end
            else
            begin
              // 2 - SIMPLES NACIONAL EXCESSO LIMITE RECEITA BRUTA
              // 3 - REGIME NORMAL

              sCST_ICMSItem := Copy(Trim(IBQALTERACA.FieldByName('CST_ICMS').AsString), 2, 2);

              if Length(LimpaNumero(IBQALTERACA.FieldByname('CST_NFCE').AsString)) > 1 then // Se existir CST para NFC-e usa a configuração
              begin
                sCST_ICMSItem := Right('000' + LimpaNumero(IBQALTERACA.FieldByname('CST_NFCE').AsString), 2);
              end;

              if (sCST_ICMSItem <> '00')
                and (sCST_ICMSItem <> '20')
                and (sCST_ICMSItem <> '40')
                and (sCST_ICMSItem <> '41')
                and (sCST_ICMSItem <> '50')
                and (sCST_ICMSItem <> '60')
                and (sCST_ICMSItem <> '90') then
                sCST_ICMSItem := '00'; // CST_ICMS for diferente, definir 00 como padrão

              if _59.IBDATASET27.FieldByname('CST_ICMS').Value <> Trim(sOrigItem) + Trim(sCST_ICMSItem)  then
              begin
                _59.IBDATASET27.Edit;
                _59.IBDATASET27.FieldByname('CST_ICMS').Value := Trim(sOrigItem) + Trim(sCST_ICMSItem);
                _59.IBDATASET27.Post;
              end;

              if StrToInt(sCST_ICMSItem) in [00, 20, 90] then
              begin // Grupo de Tributação do ICMS= 00, 20, 90

                dpICMS_N08 := StrToFloat(AliquotaIcms(Trim(IBQALTERACA.FieldByName('ALIQUICM').AsString)));
                if IBQALTERACA.FieldByname('ALIQUOTA_NFCE').AsFloat > 0.00 then
                begin
                  dpICMS_N08 := IBQALTERACA.FieldByName('ALIQUOTA_NFCE').AsFloat;
                  _59.IBDATASET27.Edit;
                  _59.IBDATASET27.FieldByName('ALIQUICM').AsString := LimpaNumero(FormatFloat('00.00', dpICMS_N08));
                  _59.IBDATASET27.Post;
                end;

                sDadosItens := sDadosItens + '<ICMS00>' +                            // N02 Tributação do ICMS: 00 – Tributada integralmente 20 - Com redução de base de cálculo 90 - Outros
                                               '<Orig>' + sOrigItem + '</Orig>' +    // N06 Origem da mercadoria: 0 – Nacional; 1 – Estrangeira – Importação direta; 2 – Estrangeira – Adquirida no mercado interno.
                                               '<CST>' + sCST_ICMSItem + '</CST>' +  // N07
                                               // 2016-01-19 '<pICMS>' + FormataFloatXML(StrToFloat(AliquotaIcms(Trim(IBQALTERACA.FieldByName('ALIQUICM').AsString))), 2) + '</pICMS>' + // N08
                                               '<pICMS>' + FormataFloatXML(dpICMS_N08, 2) + '</pICMS>' + // N08
                                             '</ICMS00>';
              end;

              if (_59.VersaoDadosEnt = VDE_007) or (_59.VersaoDadosEnt = VDE_008) then // Sandro Silva 2019-04-16 if _59.VersaoDadosEnt = VDE_007 then
              begin
                if StrToInt(sCST_ICMSItem) in [40, 41, 60] then
                begin // Grupo de Tributação do ICMS = 40, 41, 60
                  sDadosItens := sDadosItens + '<ICMS40>' +                            // N03 Tributação do ICMS: 40 - Isenta 41 - Não tributada 60 - ICMS cobrado anteriormente por substituição tributária
                                                 '<Orig>' + sOrigItem + '</Orig>' +    // N06 Origem da mercadoria: 0 – Nacional; 1 – Estrangeira – Importação direta; 2 – Estrangeira – Adquirida no mercado interno.
                                                 '<CST>' + sCST_ICMSItem + '</CST>' +  // N07
                                               '</ICMS40>';
                end;
              end;
            end; // if IBQEMITENTE.FieldByName('CRT').AsString = _59_CRT_SIMPLES_NACIONAL then

            sDadosItens := sDadosItens + '</ICMS>';

            sDadosItens := sDadosItens + GrupoPISCofins;

          end
          else
          begin // Serviços

            scListServ := ExtrairConfiguracao(IBQALTERACA.FieldByName('LIVRE4').AsString, SIGLA_CLISTSERV, False);

            if RetornaValorDaTagNoCampo('cListServ', IBQALTERACA.FieldByName('TAGS_').AsString) <> '' then
              scListServ := RetornaValorDaTagNoCampo('cListServ', IBQALTERACA.FieldByName('TAGS_').AsString);

            scServTribMun := IBQALTERACA.FieldByname('EAN').AsString;
            if RetornaValorDaTagNoCampo('cServico', IBQALTERACA.FieldByName('TAGS_').AsString) <> '' then
              scServTribMun := RetornaValorDaTagNoCampo('cServico', IBQALTERACA.FieldByName('TAGS_').AsString);
            scServTribMun := Right(DupeString('0', 20) + scServTribMun, 20);

            if scListServ <> '' then
              scListServ := '<cListServ>' + scListServ + '</cListServ>';

            dvAliq_U04 := IBQALTERACA.FieldByName('ISS').AsFloat;
            if IBQALTERACA.FieldByName('ALIQUOTA_NFCE').AsFloat > 0.00 then
              dvAliq_U04 := IBQALTERACA.FieldByName('ALIQUOTA_NFCE').AsFloat;

            /// Serviço  ALIQUOTA_NFCE
            sDadosItens := sDadosItens + '<ISSQN>' +                                             // U01
                                           '<vDeducISSQN>0.00</vDeducISSQN>' +                   // U02
                                           '<vAliq>' + Right('00' + FormataFloatXML(dvAliq_U04, 2), 6) + '</vAliq>' +  // U04
                                           '<cMunFG>' + Trim(Copy(IBQEMITENTE.FieldByname('CODIGO').AsString,1,7)) + '</cMunFG>' + // U6
                                           scListServ + // 2015-05-19 '<cListServ>' + LimpaNumero(ExtrairConfiguracao(IBQALTERACA.FieldByName('LIVRE4').AsString, SIGLA_CLISTSERV, False)) + '</cListServ>' +
                                           '<cServTribMun>' + scServTribMun + '</cServTribMun>' + // Sandro Silva 2020-08-21 '<cServTribMun>' + Right(DupeString('0', 20) + IBQALTERACA.FieldByname('EAN').AsString, 20) + '</cServTribMun>' +
                                           '<cNatOp>01</cNatOp>' +                                 // U09 1 - Tributação no município; 2 - Tributação fora do município; 3 - Isenção; 4 - Imune; 5 - Exigibilidade suspensa por decisão judicial 6 - Exigibilidade suspensa por procedimento administrativo; 7 - Não tributável ou não incidência; 8 - Exportação de Serviço.
                                           '<indIncFisc>2</indIncFisc>' +                         // U10 1 - Sim; 2 - Não
                                         '</ISSQN>';

            sDadosItens := sDadosItens + GrupoPISCofins; // Sandro Silva 2016-03-28 PIS/Cofins após ISSQN

          end; // if Trim(IBQALTERACA.FieldByName('TIPO_ITEM').AsString) <> '09' then

          sDadosItens := sDadosItens + '</imposto>' +
                             '</det>';
          dTotal := dTotal + IBQALTERACA.FieldByName('VL_ITEM').AsFloat;

          IBQALTERACA.Next;

          Inc(iItem);

        end; // while IBQALTERACA.Eof = False do

        if (IBQDESCONTOCUPOM.FieldByName('DESCONTOCUPOM').AsFloat <> 0)
          or (IBQACRESCIMOCUPOM.FieldByName('ACRESCIMOCUPOM').AsFloat <> 0) then
        begin
          sDadosTotal :=
            '<total>' +                                                 // W01
              '<DescAcrEntr>';                                          // W19
          if (IBQDESCONTOCUPOM.FieldByName('DESCONTOCUPOM').AsFloat <> 0) then
            sDadosTotal :=  sDadosTotal +
                '<vDescSubtot>' + FormataFloatXML(ABS(IBQDESCONTOCUPOM.FieldByName('DESCONTOCUPOM').AsFloat), 2) + '</vDescSubtot>';                         // W20
          if (IBQACRESCIMOCUPOM.FieldByName('ACRESCIMOCUPOM').AsFloat <> 0) then
            sDadosTotal :=  sDadosTotal +
                '<vAcresSubtot>' + FormataFloatXML(IBQACRESCIMOCUPOM.FieldByName('ACRESCIMOCUPOM').AsFloat, 2) + '</vAcresSubtot>';                       // W21
          sDadosTotal :=  sDadosTotal +
              '</DescAcrEntr>';
          {Sandro Silva 2013-04-09 inicio
          Valor aproximado dos tributos do CF-e-SAT, declarado pelo emitente, conforme Lei 12741/2012.
          Valor deve ser maior ou igual a zero. Campo de preenchimento:
          - opcional, caso o contribuinte opte por informar o valor em painel afixado no estabelecimento, conforme artigo
          2º, §2º da referida lei.
          - obrigatório, caso o contribuinte não opte por informar o valor em painel afixado no estabelecimento, conforme artigo
          2º, §2º da referida lei.}
          // 2014-01-17 sDadosTotal := sDadosTotal + '<vCFeLei12741>0.00</vCFeLei12741>';
          sDadosTotal := sDadosTotal + '<vCFeLei12741>' + FormataFloatXML(dTotalLei12741, 2) + '</vCFeLei12741>';

          sDadosTotal := sDadosTotal + '</total>';
        end
        else
          {Sandro Silva 2013-04-09 inicio
          sDadosTotal := '<total/>';

          Valor aproximado dos tributos do CF-e-SAT, declarado pelo emitente, conforme Lei 12741/2012.
          Valor deve ser maior ou igual a zero. Campo de preenchimento:
          - opcional, caso o contribuinte opte por informar o valor em painel afixado no estabelecimento, conforme artigo
          2º, §2º da referida lei.
          - obrigatório, caso o contribuinte não opte por informar o valor em painel afixado no estabelecimento, conforme artigo
          2º, §2º da referida lei.}
        begin
          sDadosTotal := '<total>';
          sDadosTotal := sDadosTotal + '<vCFeLei12741>' + FormataFloatXML(dTotalLei12741, 2) + '</vCFeLei12741>';
          sDadosTotal := sDadosTotal + '</total>';
        end;

        sDadosPagamento := '<pgto>'; // 2013-02-08 '';

        if FPagamentos.FTEFPago > 0 then // Sandro Silva 2021-11-26 if Form1.fTEFPago                      > 0 then
        begin
          //
          // SmallMsg('Cartão TEF');
          //
          (*{Sandro Silva 2021-11-26 inicio
          for iTransacaoCartao := 0 to Form1.TransacoesCartao.Transacoes.Count -1 do
          begin

            if Pos('CREDITO', Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].DebitoOuCredito) <> 0 then
              sTipoCartao := SAT_CODIGO_MEIO_PAGAMENTO_03_CARTAO_CREDITO // '03'
            else
              sTipoCartao := SAT_CODIGO_MEIO_PAGAMENTO_04_CARTAO_DEBITO; // '04';

            {Sandro Silva 2021-07-07 inicio}
            //if Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].CarteiraDigital then
            if Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].Modalidade <> tModalidadeCartao then
            begin
              sTipoCartao := SAT_CODIGO_MEIO_PAGAMENTO_99_OUTROS  ;// Mudar quando entrar em vigor as novas formas SAT_CODIGO_MEIO_PAGAMENTO_18_TRANSFERENCIA_BANCARIA_CARTEIRA_DIGITAL;
            end;
            {Sandro Silva 2021-07-07 fim}

            if Trim(Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].NomeRede) <> '' then // Somente se informou o nome da rede Sandro Silva 2020-07-16
              Form1.sNomeRede := Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].NomeRede;
            //Localiza todos cadastros com OBS contendo o nome da rede ou que o relacionamento = credenciadora de cartão
            IBQCLIFOR.Close;
            IBQCLIFOR.SQL.Text :=
              'select * ' +
              'from CLIFOR ' +
              'where (OBS containing ' + QuotedStr(BandeiraSemCreditoDebito(Form1.sNomeRede)) + ' and coalesce(CLIFOR, '''') = ''Credenciadora de cartão'') or coalesce(CLIFOR, '''') = ''Credenciadora de cartão'' ';
            IBQCLIFOR.Open;

            sWA05 := CodigoCredenciadora(Trim(LimpaNumero(SelecionaCNPJCredenciadora(IBQCLIFOR, BandeiraSemCreditoDebito(Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].NomeRede)))));

            sDadosPagamento := sDadosPagamento + DadosPagamento(sTipoCartao, Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].ValorPago);

            sWA05 := ''; // Para não interfertir nas demais formas de pagamento usadas na venda Sandro Silva 2020-08-03

          end;
          *)
          for iTransacaoCartao := 0 to FPagamentos.TransacoesCartao.Transacoes.Count -1 do
          begin

            if Pos('CREDITO', FPagamentos.TransacoesCartao.Transacoes.Items[iTransacaoCartao].DebitoOuCredito) <> 0 then
              sTipoCartao := SAT_CODIGO_MEIO_PAGAMENTO_03_CARTAO_CREDITO // '03'
            else
              sTipoCartao := SAT_CODIGO_MEIO_PAGAMENTO_04_CARTAO_DEBITO; // '04';

            {Sandro Silva 2021-07-07 inicio}
            //if FPagamentos.TransacoesCartao.Transacoes.Items[iTransacaoCartao].CarteiraDigital then
            if FPagamentos.TransacoesCartao.Transacoes.Items[iTransacaoCartao].Modalidade <> tModalidadeCartao then
            begin
              sTipoCartao := SAT_CODIGO_MEIO_PAGAMENTO_99_OUTROS  ;// Mudar quando entrar em vigor as novas formas SAT_CODIGO_MEIO_PAGAMENTO_18_TRANSFERENCIA_BANCARIA_CARTEIRA_DIGITAL;
            end;
            {Sandro Silva 2021-07-07 fim}

            if Trim(FPagamentos.TransacoesCartao.Transacoes.Items[iTransacaoCartao].NomeRede) <> '' then // Somente se informou o nome da rede Sandro Silva 2020-07-16
              FPagamentos.NomeRede := FPagamentos.TransacoesCartao.Transacoes.Items[iTransacaoCartao].NomeRede;
            //Localiza todos cadastros com OBS contendo o nome da rede ou que o relacionamento = credenciadora de cartão
            IBQCLIFOR.Close;
            IBQCLIFOR.SQL.Text :=
              'select * ' +
              'from CLIFOR ' +
              'where (OBS containing ' + QuotedStr(BandeiraSemCreditoDebito(FPagamentos.NomeRede)) + ' and coalesce(CLIFOR, '''') = ''Credenciadora de cartão'') or coalesce(CLIFOR, '''') = ''Credenciadora de cartão'' ';
            IBQCLIFOR.Open;

            sWA05 := CodigoCredenciadora(Trim(LimpaNumero(SelecionaCNPJCredenciadora(IBQCLIFOR, BandeiraSemCreditoDebito(FPagamentos.TransacoesCartao.Transacoes.Items[iTransacaoCartao].NomeRede)))));

            sDadosPagamento := sDadosPagamento + DadosPagamento(sTipoCartao, FPagamentos.TransacoesCartao.Transacoes.Items[iTransacaoCartao].ValorPago);

            sWA05 := ''; // Para não interfertir nas demais formas de pagamento usadas na venda Sandro Silva 2020-08-03

          end;

          {Sandro Silva 2021-11-26 fim}
          //
        end;
        //
        {Sandro Silva 2021-11-26 inicio

        if Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat                      > 0 then
        begin
          //
          // SmallMsg('Cheque');
          //
          sDadosPagamento := sDadosPagamento + DadosPagamento(SAT_CODIGO_MEIO_PAGAMENTO_02_CHEQUE, Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat);
          //
        end;
        //
        if Form1.ibDataSet25.FieldByName('DIFERENCA_').AsFloat                      > 0 then
        begin
          //
          // SmallMsg('Prazo');
          //
          sDadosPagamento := sDadosPagamento + DadosPagamento(SAT_CODIGO_MEIO_PAGAMENTO_05_CREDITO_LOJA, Form1.ibDataSet25.FieldByName('DIFERENCA_').AsFloat);
          //
        end;
        //
        if StrToFloat(FormatFloat('0.00', Form1.ibDataSet25.FieldByName('ACUMULADO2').AsFloat))                      > 0 then
        begin
          //
          // SmallMsg('Dinheiro');
          //
           sDadosPagamento := sDadosPagamento + DadosPagamento(SAT_CODIGO_MEIO_PAGAMENTO_01_DINHEIRO, Form1.ibDataSet25.FieldByName('ACUMULADO2').AsFloat);
          //
        end;
        }
        //
        if FPagamentos.DataSetFormasPagamento.FieldByName('ACUMULADO1').AsFloat                      > 0 then
        begin
          //
          // SmallMsg('Cheque');
          //
          sDadosPagamento := sDadosPagamento + DadosPagamento(SAT_CODIGO_MEIO_PAGAMENTO_02_CHEQUE, FPagamentos.DataSetFormasPagamento.FieldByName('ACUMULADO1').AsFloat);
          //
        end;
        //
        if FPagamentos.DataSetFormasPagamento.FieldByName('DIFERENCA_').AsFloat                      > 0 then
        begin
          //
          // SmallMsg('Prazo');
          //
          sDadosPagamento := sDadosPagamento + DadosPagamento(SAT_CODIGO_MEIO_PAGAMENTO_05_CREDITO_LOJA, FPagamentos.DataSetFormasPagamento.FieldByName('DIFERENCA_').AsFloat);
          //
        end;
        //
        if StrToFloat(FormatFloat('0.00', FPagamentos.DataSetFormasPagamento.FieldByName('ACUMULADO2').AsFloat))                      > 0 then
        begin
          //
          // SmallMsg('Dinheiro');
          //
           sDadosPagamento := sDadosPagamento + DadosPagamento(SAT_CODIGO_MEIO_PAGAMENTO_01_DINHEIRO, FPagamentos.DataSetFormasPagamento.FieldByName('ACUMULADO2').AsFloat);
          //
        end;
        {Sandro Silva 2021-11-26 fim}

        if LerParametroIni(FRENTE_INI, SECAO_65, CHAVE_FORMAS_CONFIGURADAS, 'Não') = 'Sim' then
        begin

          {Sandro Silva 2021-11-26 inicio
          if Form1.ibDataSet25.FieldByName('VALOR01').AsFloat    <> 0 then
          begin
            AcumulaFormaExtraSAT(Form1.sOrdemExtraNFCe1, Form1.ibDataSet25.FieldByName('VALOR01').AsFloat);
          end;

          if Form1.ibDataSet25.FieldByName('VALOR02').AsFloat    <> 0 then
          begin
            AcumulaFormaExtraSAT(Form1.sOrdemExtraNFCe2, Form1.ibDataSet25.FieldByName('VALOR02').AsFloat);
          end;

          if Form1.ibDataSet25.FieldByName('VALOR03').AsFloat    <> 0 then
          begin
            AcumulaFormaExtraSAT(Form1.sOrdemExtraNFCe3, Form1.ibDataSet25.FieldByName('VALOR03').AsFloat);
          end;

          if Form1.ibDataSet25.FieldByName('VALOR04').AsFloat    <> 0 then
          begin
            AcumulaFormaExtraSAT(Form1.sOrdemExtraNFCe4, Form1.ibDataSet25.FieldByName('VALOR04').AsFloat);
          end;

          if Form1.ibDataSet25.FieldByName('VALOR05').AsFloat    <> 0 then
          begin
            AcumulaFormaExtraSAT(Form1.sOrdemExtraNFCe5, Form1.ibDataSet25.FieldByName('VALOR05').AsFloat);
          end;

          if Form1.ibDataSet25.FieldByName('VALOR06').AsFloat    <> 0 then
          begin
            AcumulaFormaExtraSAT(Form1.sOrdemExtraNFCe6, Form1.ibDataSet25.FieldByName('VALOR06').AsFloat);
          end;

          if Form1.ibDataSet25.FieldByName('VALOR07').AsFloat    <> 0 then
          begin
            AcumulaFormaExtraSAT(Form1.sOrdemExtraNFCe7, Form1.ibDataSet25.FieldByName('VALOR07').AsFloat);
          end;

          if Form1.ibDataSet25.FieldByName('VALOR08').AsFloat    <> 0 then
          begin
            AcumulaFormaExtraSAT(Form1.sOrdemExtraNFCe8, Form1.ibDataSet25.FieldByName('VALOR08').AsFloat);
          end;
          }

          if FPagamentos.DataSetFormasPagamento.FieldByName('VALOR01').AsFloat    <> 0 then
          begin
            AcumulaFormaExtraSAT(FPagamentos.OrdemExtra1, FPagamentos.DataSetFormasPagamento.FieldByName('VALOR01').AsFloat);
          end;

          if FPagamentos.DataSetFormasPagamento.FieldByName('VALOR02').AsFloat    <> 0 then
          begin
            AcumulaFormaExtraSAT(FPagamentos.OrdemExtra2, FPagamentos.DataSetFormasPagamento.FieldByName('VALOR02').AsFloat);
          end;

          if FPagamentos.DataSetFormasPagamento.FieldByName('VALOR03').AsFloat    <> 0 then
          begin
            AcumulaFormaExtraSAT(FPagamentos.OrdemExtra3, FPagamentos.DataSetFormasPagamento.FieldByName('VALOR03').AsFloat);
          end;

          if FPagamentos.DataSetFormasPagamento.FieldByName('VALOR04').AsFloat    <> 0 then
          begin
            AcumulaFormaExtraSAT(FPagamentos.OrdemExtra4, FPagamentos.DataSetFormasPagamento.FieldByName('VALOR04').AsFloat);
          end;

          if FPagamentos.DataSetFormasPagamento.FieldByName('VALOR05').AsFloat    <> 0 then
          begin
            AcumulaFormaExtraSAT(FPagamentos.OrdemExtra5, FPagamentos.DataSetFormasPagamento.FieldByName('VALOR05').AsFloat);
          end;

          if FPagamentos.DataSetFormasPagamento.FieldByName('VALOR06').AsFloat    <> 0 then
          begin
            AcumulaFormaExtraSAT(FPagamentos.OrdemExtra6, FPagamentos.DataSetFormasPagamento.FieldByName('VALOR06').AsFloat);
          end;

          if FPagamentos.DataSetFormasPagamento.FieldByName('VALOR07').AsFloat    <> 0 then
          begin
            AcumulaFormaExtraSAT(FPagamentos.OrdemExtra7, FPagamentos.DataSetFormasPagamento.FieldByName('VALOR07').AsFloat);
          end;

          if FPagamentos.DataSetFormasPagamento.FieldByName('VALOR08').AsFloat    <> 0 then
          begin
            AcumulaFormaExtraSAT(FPagamentos.OrdemExtra8, FPagamentos.DataSetFormasPagamento.FieldByName('VALOR08').AsFloat);
          end;
          {Sandro Silva 2021-11-26 fim}


          if dvMP_WA03_10 > 0 then
            sDadosPagamento := sDadosPagamento + DadosPagamento(SAT_CODIGO_MEIO_PAGAMENTO_10_VALE_ALIMENTACAO, dvMP_WA03_10); // 10=Vale Alimentação

          if dvMP_WA03_11 > 0 then
            sDadosPagamento := sDadosPagamento + DadosPagamento(SAT_CODIGO_MEIO_PAGAMENTO_11_VALE_REFEICAO, dvMP_WA03_11); // 11=Vale Refeição

          if dvMP_WA03_12 > 0 then
            sDadosPagamento := sDadosPagamento + DadosPagamento(SAT_CODIGO_MEIO_PAGAMENTO_12_VALE_PRESENTE, dvMP_WA03_12); // 12=Vale Presente

          if dvMP_WA03_13 > 0 then
            sDadosPagamento := sDadosPagamento + DadosPagamento(SAT_CODIGO_MEIO_PAGAMENTO_13_VALE_COMBUSTIVEL, dvMP_WA03_13); // 13=Vale Combustível

          {Sandro Silva 2021-08-10 inicio}
          if dvMP_WA03_16 > 0 then
            sDadosPagamento := sDadosPagamento + DadosPagamento(SAT_CODIGO_MEIO_PAGAMENTO_16_DEPOSITO_BANCARIO, dvMP_WA03_16); // 16=Depósito Bancário
          if dvMP_WA03_17 > 0 then
            sDadosPagamento := sDadosPagamento + DadosPagamento(SAT_CODIGO_MEIO_PAGAMENTO_17_PAGAMENTO_INSTANTANEO, dvMP_WA03_17); // 17=Pagamento Instantâneo
          if dvMP_WA03_18 > 0 then
            sDadosPagamento := sDadosPagamento + DadosPagamento(SAT_CODIGO_MEIO_PAGAMENTO_18_TRANSFERENCIA_BANCARIA_CARTEIRA_DIGITAL, dvMP_WA03_18); // 18=Transferência bancária, Carteira Digital
          if dvMP_WA03_19 > 0 then
            sDadosPagamento := sDadosPagamento + DadosPagamento(SAT_CODIGO_MEIO_PAGAMENTO_19_PROGRAMA_FIDELIDADE_CASHBACK_CREDITO_VIRTUAL, dvMP_WA03_19); // 19=Programa de fidelidade, Cashback, Crédito Virtual
          {Sandro Silva 2021-08-10 fim}

          if dvMP_WA03_99 > 0 then
            sDadosPagamento := sDadosPagamento + DadosPagamento(SAT_CODIGO_MEIO_PAGAMENTO_99_OUTROS, dvMP_WA03_99); // 99=Outros
            
        end
        else
        begin
          {Sandro Silva 2021-11-26 inicio
          if (Form1.ibDataSet25.FieldByName('VALOR01').AsFloat +
              Form1.ibDataSet25.FieldByName('VALOR02').AsFloat +
              Form1.ibDataSet25.FieldByName('VALOR03').AsFloat +
              Form1.ibDataSet25.FieldByName('VALOR04').AsFloat +
              Form1.ibDataSet25.FieldByName('VALOR05').AsFloat +
              Form1.ibDataSet25.FieldByName('VALOR06').AsFloat +
              Form1.ibDataSet25.FieldByName('VALOR07').AsFloat +
              Form1.ibDataSet25.FieldByName('VALOR08').AsFloat) <> 0 then
          begin
            sDadosPagamento := sDadosPagamento + DadosPagamento('99', (Form1.ibDataSet25.FieldByName('VALOR01').AsFloat +
                                                                       Form1.ibDataSet25.FieldByName('VALOR02').AsFloat +
                                                                       Form1.ibDataSet25.FieldByName('VALOR03').AsFloat +
                                                                       Form1.ibDataSet25.FieldByName('VALOR04').AsFloat +
                                                                       Form1.ibDataSet25.FieldByName('VALOR05').AsFloat +
                                                                       Form1.ibDataSet25.FieldByName('VALOR06').AsFloat +
                                                                       Form1.ibDataSet25.FieldByName('VALOR07').AsFloat +
                                                                       Form1.ibDataSet25.FieldByName('VALOR08').AsFloat));
            //
          end;
          }
          if (FPagamentos.DataSetFormasPagamento.FieldByName('VALOR01').AsFloat +
              FPagamentos.DataSetFormasPagamento.FieldByName('VALOR02').AsFloat +
              FPagamentos.DataSetFormasPagamento.FieldByName('VALOR03').AsFloat +
              FPagamentos.DataSetFormasPagamento.FieldByName('VALOR04').AsFloat +
              FPagamentos.DataSetFormasPagamento.FieldByName('VALOR05').AsFloat +
              FPagamentos.DataSetFormasPagamento.FieldByName('VALOR06').AsFloat +
              FPagamentos.DataSetFormasPagamento.FieldByName('VALOR07').AsFloat +
              FPagamentos.DataSetFormasPagamento.FieldByName('VALOR08').AsFloat) <> 0 then
          begin
            sDadosPagamento := sDadosPagamento + DadosPagamento('99', (FPagamentos.DataSetFormasPagamento.FieldByName('VALOR01').AsFloat +
                                                                       FPagamentos.DataSetFormasPagamento.FieldByName('VALOR02').AsFloat +
                                                                       FPagamentos.DataSetFormasPagamento.FieldByName('VALOR03').AsFloat +
                                                                       FPagamentos.DataSetFormasPagamento.FieldByName('VALOR04').AsFloat +
                                                                       FPagamentos.DataSetFormasPagamento.FieldByName('VALOR05').AsFloat +
                                                                       FPagamentos.DataSetFormasPagamento.FieldByName('VALOR06').AsFloat +
                                                                       FPagamentos.DataSetFormasPagamento.FieldByName('VALOR07').AsFloat +
                                                                       FPagamentos.DataSetFormasPagamento.FieldByName('VALOR08').AsFloat));
            //
          end;
          {Sandro Silva 2021-11-26 fim}
        end;

        sDadosPagamento := sDadosPagamento + '</pgto>'; // 2013-02-08;

        if _59.MensagemPromocional <> '' then
          sDadosinfAdic := '<infAdic><infCpl>' + ConverteAcentosXML(_59.MensagemPromocional) + ' '; // Sandro Silva 2021-11-26 sDadosinfAdic := '<infAdic><infCpl>' + Form1.ConverteAcentosXML(_59.MensagemPromocional) + ' ';
        if sDadosinfAdic <> '' then
          sDadosinfAdic := sDadosinfAdic + '</infCpl></infAdic>';

        sXMLCFe := RemoveCaracterEspecial(
          '<?xml version="1.0" encoding="UTF-8"?>' +
          '<CFe>' +
            '<infCFe versaoDadosEnt="' + _59.VersaoDadosEnt + '">' + // A01
              sDadosIde +
              sDadosEmitente +
              sDadosDestinatario +
              sDadosLocalEntrega + // 2014-03-27
              sDadosItens +
              sDadosTotal +
              sDadosPagamento +
              sDadosinfAdic +
            '</infCFe>' +
          '</CFe>');

        _59.SalvaLogDadosEnviados(sXMLCFe);
      end; // if IBQALTERACA.Eof = False then
    except
      sXMLCFe := ''; // Sandro Silva 2020-02-13
    end;

  finally
    FreeAndNil(IBQLEI12741);
    FreeAndNil(IBQTOTALCUPOM);
    FreeAndNil(IBQDESCONTOITEM);
    FreeAndNil(IBQDESCONTOCUPOM);
    FreeAndNil(IBQACRESCIMOCUPOM);
    FreeandNil(IBQEMITENTE);
    FreeAndNil(IBQCLIFOR);
    FreeAndNil(IBQALTERACA);
  end;

  Result := sXMLCFe; // Sandro Silva 2016-08-12

  // Sandro Silva 2021-11-26 ChDir(Form1.sAtual); // Sandro Silva 2017-03-31

  sLog := slLog.Text; // Sandro Silva 2021-03-10

  FreeAndNil(slLog); // Sandro Silva 2021-09-09

end;

constructor TMontaXmlVendaSAT.Create;
begin
  FDestinatarioInformadoNaTela := TDestinatarioInformadoNaTela.Create;
  FPagamentos := TPagamentosSat.Create;
end;

function TMontaXmlVendaSAT.GetFXmlVenda: String;
begin
  Result := FXmlVenda;
end;

function TMontaXmlVendaSAT.GeraXMLVenda(_59: TSmall59; sCaixa: String;
  dtData: TDate; sCupom: String; var sLog: String): String;
begin
  Result := '';
  FSAT   := _59;
  FCaixa := sCaixa;
  FData  := dtData;
  FCupom := sCupom;
  FLog   := sLog;

  if FSAT = nil then
    sLog := sLog + #13 + 'SAT está nil';

  if FCaixa = '' then
    sLog := sLog + #13 + 'Caixa não informado';

  if FCupom = '' then
    sLog := sLog + #13 + 'Cupom não informado';

  if sLog = '' then
  begin
    FXmlVenda := MontaXMLVenda(FSAT, FCaixa, FData, FCupom, FLog);
    Result := FXmlVenda;
    sLog      := FLog;
  end
  else
    Application.MessageBox(PAnsiChar(sLog), 'Atenção', mrOk + MB_ICONWARNING)

end;

destructor TMontaXmlVendaSAT.Destroy;
begin
  FDestinatarioInformadoNaTela.Free;
  inherited;
end;

{ TPagamentosSat }

constructor TPagamentosSat.Create;
begin
  //FTransacoesCartao := TTransacaoFinanceira.Create(Application);
end;

end.
