{ *********************************************************************** }
{ Dados para emitir CF-e no MFE Cear�                                     }
{Elgin MFe                                                                }
{Fabricante SAT=0701                                                      }
{CNPJ SH=10615281000140                                                   }
{Codigo Ativacao=123456789                                                }
{Assinatura Associada=CODIGO DE VINCULACAO AC DO MFE-CFE                  }
{Emitente    CGC = '14.200.166/0001-66'      IE = '1234567890'            }
{Integrador estabelecimento CNPJ 22295347000141 IE    065911482           }
{Integrador software house CNPJ  72618748000163                           }
{Integrador Assinatura Vinculada
MD2Nof/O0tQMPKiYeeAydSjYt7YV9kU0nWKZGXHVdYIzR2W9Z6tgXni/Y5bnjmU
Ak8MkqlBJIiOOIskKCjJ086k7vAP0EU5cBRYj/nzHUiRdu9AVD7WRfVs00BDyb5
fsnnKg7gAXXH6SBgCxG9yjAkxJ0l2E2idsWBAJ5peQEBZqtHytRUC+FLaSfd3+6
6QNxIBlDwQIRzUGPaU6fvErVDSfMUf8WpkwnPz36fCQnyLypqe/5mbox9pt3RCb
bXcYqnR/4poYGr9M9Kymj4/PyX9xGeiXwbgzOOHNIU5M/aAs0rulXz948bZla0e
XABgEcp6mDkTzweLPZTbmOhX+eA==
{ *********************************************************************** }

{ *********************************************************************** }
{Unit criada seguindo como padr�o as outras units de comunica��o com ECF  }
{Possui as mesmas chamadas de fun��es, mas implementadas de acordo com os }
{equipamentos SAT e MFE                                                   }
{ *********************************************************************** }

unit _Small_59;

interface

uses

  Windows, Messages, Fiscal, SysUtils,Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Mask, Grids, DBGrids, DB, DBCtrls,
  IniFiles, ShellApi, Printers,
  {$IFDEF VER150}
  IBCustomDataSet, IBQuery, IBDatabase,
  {$ELSE}
  , IBX.IBDatabase, IBX.IBQuery, IBX.IBCustomDataSet
  {$ENDIF}
  StrUtils, Variants
  , usmallsat
  ;

  const NOME_APLICATIVO_59             = 'cfesat.exe';
  const CHAVE_INI_AVANCO_PAPEL         = 'Avanco Papel'; // Sandro Silva 2016-03-18
  const CHAVE_MODO_OPERACAO            = 'Modo Operacao';
  const CHAVE_CAMINHO_SERVIDOR         = 'Caminho Servidor';
  const _59_CHAVE_CODIGO_ATIVACAO      = 'Codigo Ativacao';
  const _59_CHAVE_CODIGO_FABRICANTE    = 'Fabricante SAT';
  const _59_CHAVE_CNPJ_SOFTWARE_HOUSE  = 'CNPJ SH';
  const _59_CHAVE_CAMINHO_DLL          = 'dll';
  const _59_CHAVE_VERSAO_DADOS_ENTRADA = 'Versao Dados Entrada';
  const _59_CHAVE_AMBIENTE             = 'Ambiente';
  const _59_AMBIENTE_HOMOLOGACAO       = 'HOMOLOGACAO';
  const _59_AMBIENTE_PRODUCAO          = 'PRODUCAO';

  const _59_CHAVE_METODO_CHAMADA_DLL_ALTERNATIVO = 'CHAMADA DLL'; // Sandro Silva 2017-01-09
  const _59_PREFIXO_GENERATOR_CAIXA_SAT = 'G_NUMEROCFESAT_';

  const VDE_007 = '0.07';
  const VDE_008 = '0.08'; // Sandro Silva 2018-09-03

  const SAT_CODIGO_MEIO_PAGAMENTO_01_DINHEIRO                                     = '01';
  const SAT_CODIGO_MEIO_PAGAMENTO_02_CHEQUE                                       = '02';
  const SAT_CODIGO_MEIO_PAGAMENTO_03_CARTAO_CREDITO                               = '03';
  const SAT_CODIGO_MEIO_PAGAMENTO_04_CARTAO_DEBITO                                = '04';
  const SAT_CODIGO_MEIO_PAGAMENTO_05_CREDITO_LOJA                                 = '05';
  const SAT_CODIGO_MEIO_PAGAMENTO_10_VALE_ALIMENTACAO                             = '10';
  const SAT_CODIGO_MEIO_PAGAMENTO_11_VALE_REFEICAO                                = '11';
  const SAT_CODIGO_MEIO_PAGAMENTO_12_VALE_PRESENTE                                = '12';
  const SAT_CODIGO_MEIO_PAGAMENTO_13_VALE_COMBUSTIVEL                             = '13';
  const SAT_CODIGO_MEIO_PAGAMENTO_16_DEPOSITO_BANCARIO                            = '16';
  const SAT_CODIGO_MEIO_PAGAMENTO_17_PAGAMENTO_INSTANTANEO                        = '17';
  const SAT_CODIGO_MEIO_PAGAMENTO_18_TRANSFERENCIA_BANCARIA_CARTEIRA_DIGITAL      = '18'; //Transfer�ncia banc�ria, Carteira Digital
  const SAT_CODIGO_MEIO_PAGAMENTO_19_PROGRAMA_FIDELIDADE_CASHBACK_CREDITO_VIRTUAL = '19'; //Programa de fidelidade, Cashback, Cr�dito Virtual
  const SAT_CODIGO_MEIO_PAGAMENTO_99_OUTROS                                       = '99';

  const SAT_MENSAGEM_AGUARDANDO_RESPOSTA_DO_SERVIDOR = 'Aguardando resposta do Servidor'; // Sandro Silva 2021-08-27 const SAT_MENSAGEM_AGUARDANDO_RESPOSTA_DO_SERVIDOR_SAT = 'Aguardando resposta do Servidor SAT';

  function ConsisteInscricaoEstadual(sIE, sUF: String): Boolean; StdCall; External 'DllInscE32.Dll';
  function MontaXMLVenda(sCaixa: String; dtData: TDate;
    sCupom: String; var sLog: String): AnsiString;
  function FormataFloatXML(dValor: Double; iDecimais: Integer): String;
  function FormataDataSQL(Data: TDate): String;
  function ValidaEAN(const vEAN: String): Boolean;
  function ExtrairConfiguracao(sTexto: String; sSigla: String;
    bLimparNumero: Boolean = True): String;
  function AliquotaIcms(sAliqICMS: String): String;
  function RemoveCaracterEspecial(sTexto: String): String;
  function CodigoCredenciadora(sCNPJ: String): String;

  function _ecf59_CodeErro(Pp1: Integer):Integer;
  function _ecf59_Inicializa(Pp1: String): Boolean;
  function _ecf59_FechaCupom(Pp1: Boolean): Boolean;
  function _ecf59_Pagamento(Pp1: Boolean): Boolean;
  function _ecf59_CancelaUltimoItem(Pp1: Boolean): Boolean;
  function _ecf59_SubTotal(Pp1: Boolean):Real;
  function _ecf59_AbreGaveta(Pp1: Boolean): Boolean;
  function _ecf59_Sangria(Pp1: Real): Boolean;
  function _ecf59_Suprimento(Pp1: Real): Boolean;
  function _ecf59_NovaAliquota(Pp1: String): Boolean;
  function _ecf59_LeituraDaMFD(pP1, pP2, pP3: String): Boolean;
  function _ecf59_LeituraMemoriaFiscal(pP1, pP2: String): Boolean;
  function _ecf59_CancelaUltimoCupom(Pp1: Boolean): Boolean;
  function _ecf59_AbreNovoCupom(Pp1: Boolean): Boolean;
  function _ecf59_NumeroDoCupom(Pp1: Boolean):String;
  function _ecf59_CancelaItemN(pP1, pP2: String): Boolean;
  function _ecf59_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String): Boolean;
  function _ecf59_ReducaoZ(pP1: Boolean): Boolean;
  function _ecf59_LeituraX(pP1: Boolean): Boolean;
  function _ecf59_RetornaVerao(pP1: Boolean): Boolean;
  function _ecf59_LigaDesLigaVerao(pP1: Boolean): Boolean;
  function _ecf59_VersodoFirmware(pP1: Boolean): String;
  function _ecf59_NmerodeSrie(pP1: Boolean): String;
  function _ecf59_CGCIE(pP1: Boolean): String;
  function _ecf59_Cancelamentos(pP1: Boolean): String;
  function _ecf59_Descontos(pP1: Boolean): String;
  function _ecf59_ContadorSeqencial(pP1: Boolean): String;
  function _ecf59_Nmdeoperaesnofiscais(pP1: Boolean): String;
  function _ecf59_NmdeCuponscancelados(pP1: Boolean): String;
  function _ecf59_NmdeRedues(pP1: Boolean): String;
  function _ecf59_Nmdeintervenestcnicas(pP1: Boolean): String;
  function _ecf59_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
  function _ecf59_Clichdoproprietrio(pP1: Boolean): String;
  function _ecf59_NmdoCaixa(pP1: Boolean): String;
  function _ecf59_Nmdaloja(pP1: Boolean): String;
  function _ecf59_Moeda(pP1: Boolean): String;
  function _ecf59_Dataehoradaimpressora(pP1: Boolean): String;
  function _ecf59_Datadaultimareduo(pP1: Boolean): String;
  function _ecf59_Datadomovimento(pP1: Boolean): String;
  function _ecf59_Tipodaimpressora(pP1: Boolean = False): String;
  function _ecf59_StatusGaveta(Pp1: Boolean):String;
  function _ecf59_RetornaAliquotas(pP1: Boolean): String;
  function _ecf59_Vincula(pP1: String): Boolean;
  function _ecf59_FlagsDeISS(pP1: Boolean): String;
  function _ecf59_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
  function _ecf59_MudaMoeda(pP1: String): Boolean;
  function _ecf59_MostraDisplay(pP1: String): Boolean;
  function _ecf59_LeituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
  function _ecf59_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean;
  function _ecf59_ImpressaoNaoSujeitoaoICMS(sP1: String; bPDF: Boolean = False; LarguraPapel: Integer = 640): Boolean; // Sandro Silva 2018-11-20 function _ecf59_ImpressaoNaoSujeitoaoICMS(sP1: String; bPDF: Boolean = False): Boolean;
  function _ecf59_FechaCupom2(sP1: Boolean): Boolean;
  function _ecf59_ImprimeCheque(rP1: Real; sP2: String): Boolean;
  function _ecf59_MapaResumo(sP1: Boolean): Boolean;
  function _ecf59_FormataTx(sP1: String): Integer;
  function _ecf59_GrandeTotal(sP1: Boolean): String;
  function _ecf59_TotalizadoresDasAliquotas(sP1: Boolean): String;
  function _ecf59_CupomAberto(sP1: Boolean): boolean;
  function _ecf59_FaltaPagamento(sP1: Boolean): boolean;
  function _ecf59_Visualiza_DANFECE(pSLote: String; pFNFe : WideString): Boolean;
  function _ecf59_Imprime_DANFECE(pSLote: String; pFNFe : WideString): Boolean;
  function _ecf59_Email_DANFECE(pSLote: String; pFNFe : WideString): Boolean;
  function _ecf59_FinalizaVendaSAT: Boolean;
  function _ecf59_CancelaCFeSat(Pp1: Boolean): Boolean;
  function _ecf59_NomeExeSAT: String;
  function SangriaSuprimento(dValor: Double; sTipo: String): Boolean;
  procedure _ecf59_ImportaConfiguracao;
  procedure _ecf59_ConsultaSat(const bExibeRetorno: Boolean;
    bExibirMensagemSefaz: Boolean);
  procedure _ecf59_ConsultaStatusOperacional;
  procedure _ecf59_ExtrairLog;
  procedure _ecf59_ConfiguraDadosEmitente;
  procedure _ecf59_FinalizaSAT;
  procedure _ecf59_CriaSequencialCaixa(sCaixa: String);
  function _ecf59_AtivarSat(codigoDeAtivacao: String;
    CNPJ: String; cUF: String; mmLog: TMemo = nil): Boolean;
  function _ecf59_AssociarAssinatura(codigoDeAtivacao: String;
    CNPJEmitente: String; assinaturaCNPJs: String;
    mmLog: TMemo = nil): Boolean;
  function _ecf59_GravaAssinaturaAssociada(sAssinatura: String): Boolean;
  function _ecf59_LeAssinaturaAssociada: String;
  function _ecf59_ConfiguraCaixaSAT(sCaixa: String; bDefinirProximoSequencia: Boolean = False): String; // Sandro Silva 2021-03-05 function _ecf59_ConfiguraCaixaSAT(sCaixa: String): String;
  function _ecf59_ConfiguraSAT: Boolean;
  procedure _ecf59_ConfiguraFabricanteModeloSAT(
    var sCodigoFabricante: String);
  function _ecf59_ValidaKitDesenvolvimento: Boolean;
  procedure _ecf59_HabilitaUsarDriverMFE_1_05(bHabilitar: Boolean);

  type
    TMobile = class(TComponent)
      private
      FVendaImportando: String;
    procedure SetVendaImportando(const Value: String);
      public
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
        property VendaImportando: String read FVendaImportando write SetVendaImportando;
    end;


var
  iCaracteres : Integer;
  Memo4: TMemo;
  _59: TSmall59;
  xBlockInput: function (Block: BOOL): BOOL; stdcall;
  Mobile_59: TMobile;

implementation

uses
  smallfunc
  , SMALL_DBEDIT
  , Unit2
  , Unit22
  , ufuncoesfrente
  , _Small_IntegradorFiscal
  , Unit10
  , umfe // Sandro Silva 2022-05-17 Ap�s o prado de 07/11/2022, tirar essa uses e eliminar as depend�ncias relacionadas ao Integrador e Validador Fiscal das demais unit do projeto
  , ucadadquirentes
//  , upafecfmensagens
  , udadospos
  , Unit27
  , uimpressaopdf
  , uclassetransacaocartao
  , umontaxmlvendasat
  , Unit12
  ;

function FormataFloatXML(dValor: Double; iDecimais: Integer): String;
begin
  Result := StringReplace(StrZero(dValor, 1, iDecimais), ',', '.', [rfReplaceAll]);
end;

function FormataDataSQL(Data: TDate): String;
// Sandro Silva 2011-10-13 inicio Formata a data no padr�o sql
begin
  Result := FormatDateTime('yyyy-mm-dd', Data);
end;

function ValidaEAN(const vEAN: String): Boolean;
var
  Temp1, Temp2, Digito: Integer;
  Temp3, Temp4: String;
begin
  Result := False;
  try
    Temp2 := 0;
    Temp3 := '';

    if ((Length(vEan) <> 8) and
        (Length(vEan) <> 12) and
        (Length(vEan) <> 13) and
        (Length(vEan) <> 14)
       )
      or (Length(vEan) <> Length(LimpaNumero(vEan)))
        then
    begin
      Result := False;
    end
    else
    begin

      if (vEAN = DupeString('0', 18))
        or (vEAN = DupeString('1', 18))
        or (vEAN = DupeString('2', 18))
        or (vEAN = DupeString('3', 18))
        or (vEAN = DupeString('4', 18))
        or (vEAN = DupeString('5', 18))
        or (vEAN = DupeString('6', 18))
        or (vEAN = DupeString('7', 18))
        or (vEAN = DupeString('8', 18))
        or (vEAN = DupeString('9', 18)) then
        Exit;

      Temp4  := '131313131313131313';
      Temp4  := Copy(Temp4,(Length(Temp4)-Length(vEan)),Length(vEan)-1);
      Digito := StrToInt(Copy(vEan,Length(vEan),1));
      Temp3  := Copy(vEan,1,Length(vEan)-1);

      for Temp1 := 1 to Length(Temp3) do
        Temp2 := Temp2+StrToInt(Temp3[Temp1])*StrToInt(Temp4[Temp1]);

      Temp2 := 10-Round(Frac(Temp2/10)*10);
      if Temp2 = 10 then
        Temp2 := 0;
      Result := (Temp2 = Digito);
    end;
  except

  end;
end;

function ExtrairConfiguracao(sTexto, sSigla: String;
  bLimparNumero: Boolean = True): String;
{Sandro Silva 2012-01-11 inicio
Extrai configura��o existente no texto.
Quando existir mais de uma configura��o dever�o estar separadas por ponto e v�rgula(;)
Inicialmente usado para configura��o D101-Indicador da Natureza do Frete Contratado e
D101-C�digo da Base de C�lculo do Cr�dito}
begin
  Result := '';
  sTexto := StringReplace(sTexto, ' = ', '=', [rfReplaceAll]);
  sTexto := StringReplace(sTexto, ' =', '=', [rfReplaceAll]);
  sTexto := StringReplace(sTexto, '= ', '=', [rfReplaceAll]);

  with TStringList.Create do
  begin
    NameValueSeparator := '=';
    Delimiter          := ';';
    DelimitedText      := AnsiUpperCase(sTexto);
    Result             := Values[sSigla];
    Free;
  end;

  if bLimparNumero then
    Result := LimpaNumero(Result);
end;

function AliquotaIcms(sAliqICMS: String): String;
begin
  Result := '0,00';
  if (StrToFloatDef(sAliqICMS, 0) = 0) then // Pode ser I, F, N
    Result := '0,00'
  else
    Result := Strzero((StrToFloatDef(sAliqICMS, 0) / 100), 3, 2);
end;

function RemoveCaracterEspecial(sTexto: String): String;
// Sandro Silva 2012-02-02 inicio Remove os acentos dos caracteres
const Especial = '|���������������������������������������������������''';
const Normal   = ' AAAAAEEEEIIIIOOOOOUUUUCYaaaaaeeeeiiiiooooouuuucyy   ';
var
  iPosicao: Integer;
begin
  Result := '';
  for iPosicao := 1 to Length(sTexto) do
  begin
    if Pos(Copy(sTexto, iPosicao, 1), Especial) > 0 then
      Result := Result + Copy(Normal, Pos(Copy(sTexto, iPosicao, 1), Especial), 1)
    else
      Result := Result + Copy(sTexto, iPosicao, 1);
  end;
end;

function CodigoCredenciadora(sCNPJ: String): String;
begin
  sCNPJ := FormataCpfCgc(LimpaNumero(sCNPJ));
  Result := '999'; // Outros sempre ser� o padr�o
    
  if sCNPJ = '03.106.213/0001-90' then
    Result := '001'; // Administradora de Cart�es Sicredi Ltda.
  if sCNPJ = '03.106.213/0002-71' then
    Result := '002'; // Administradora de Cart�es Sicredi Ltda.(filial RS)
  if sCNPJ = '60.419.645/0001-95' then
    Result := '003'; // Banco American Express S/A - AMEX
  if sCNPJ = '62.421.979/0001-29' then
    Result := '004'; // BANCO GE - CAPITAL
  if sCNPJ = '58.160.789/0001-28' then
    Result := '005'; // BANCO SAFRA S/A
  if sCNPJ = '07.679.404/0001-00' then
    Result := '006'; // BANCO TOP�ZIO S/A
  if sCNPJ = '17.351.180/0001-59' then
    Result := '007'; // BANCO TRIANGULO S/A
  if sCNPJ = '04.627.085/0001-93' then
    Result := '008'; // BIGCARD Adm. de Convenios e Serv.
  if sCNPJ = '01.418.852/0001-66' then
    Result := '009'; // BOURBON Adm. de Cart�es de Cr�dito
  if sCNPJ = '03.766.873/0001-06' then
    Result := '010'; // CABAL Brasil Ltda.
  if sCNPJ = '03.722.919/0001-87' then
    Result := '011'; // CETELEM Brasil S/A - CFI
  if sCNPJ = '01.027.058/0001-91' then
    Result := '012'; // CIELO S/A
  if sCNPJ = '03.529.067/0001-06' then
    Result := '013'; // CREDI 21 Participa��es Ltda.
  if sCNPJ = '71.225.700/0001-22' then
    Result := '014'; // ECX CARD Adm. e Processadora de Cart�es S/A
  if sCNPJ = '03.506.307/0001-57' then
    Result := '015'; // Empresa Bras. Tec. Adm. Conv. Hom. Ltda. - EMBRATEC
  if sCNPJ = '04.432.048/0001-20' then
    Result := '016'; // EMP�RIO CARD LTDA
  if sCNPJ = '07.953.674/0001-50' then
    Result := '017'; // FREEDDOM e Tecnologia e Servi�os S/A
  if sCNPJ = '03.322.366/0001-75' then
    Result := '018'; // FUNCIONAL CARD LTDA.
  if sCNPJ = '03.012.230/0001-69' then
    Result := '019'; // HIPERCARD Banco Multiplo S/A
  if sCNPJ = '03.966.317/0001-75' then
    Result := '020'; // MAPA Admin. Conv. e Cart�es Ltda.
  if sCNPJ = '00.163.051/0001-34' then
    Result := '021'; // Novo Pag Adm. e Proc. de Meios Eletr�nicos de Pagto. Ltda.
  if sCNPJ = '43.180.355/0001-12' then
    Result := '022'; // PERNAMBUCANAS Financiadora S/A Cr�dito, Fin. e Invest.
  if sCNPJ = '00.904.951/0001-95' then
    Result := '023'; // POLICARD Systems e Servi�os Ltda.
  if sCNPJ = '33.098.658/0001-37' then
    Result := '024'; // PROVAR Neg�cios de Varejo Ltda.
  if sCNPJ = '01.425.787/0001-04' then // Sandro Silva 2020-07-16 if sCNPJ = '01.425.787/0001-01' then
    Result := '025'; // REDECARD S/A
  if sCNPJ = '90.055.609/0001-50' then
    Result := '026'; // RENNER Adm. Cart�es de Cr�dito Ltda.
  if sCNPJ = '03.007.699/0001-00' then
    Result := '027'; // RP Administra��o de Conv�nios Ltda.
  if sCNPJ = '00.122.327/0001-36' then
    Result := '028'; // SANTINVEST S/A Cr�dito, Financiamento e Investimentos
  if sCNPJ = '69.034.668/0001-56' then
    Result := '029'; // SODEXHO Pass do Brasil Servi�os e Com�rcio S/A
  if sCNPJ = '60.114.865/0001-00' then
    Result := '030'; // SOROCRED Meios de Pagamentos Ltda.
  if sCNPJ = '51.427.102/0004-71' then
    Result := '031'; // Tecnologia Banc�ria S/A - TECBAN
  if sCNPJ = '47.866.934/0001-74' then
    Result := '032'; // TICKET Servi�os S/A
  if sCNPJ = '00.604.122/0001-97' then
    Result := '033'; // TRIVALE Administra��o Ltda.
  if sCNPJ = '61.071.387/0001-61' then
    Result := '034'; // Unicard Banco M�ltiplo S/A - TRICARD
  
  //ShowMessage('teste 01 384 ' + RESULT); // Sandro Silva 2020-07-16
end;

(*// Sandro Silva 2021-11-25
function MontaXMLVenda(sCaixa: String; dtData: TDate; sCupom: String;
  var sLog: String): AnsiString;
//Sandro Silva 2012-12-10 Seleciona os dados do cupom informado e monta o xml conforme padr�o especificado
var
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
  iTransacaoCartao: Integer; // Sandro Silva 2017-06-16
  slLog: TStringList; // Sandro Silva 2021-03-10
  function GrupoPISCofins: String;
  var
    sPisCofinsItem: String;
    sCSTPISCOFINS: String;
    dValorTotalItem: Double; // Sandro Silva 2021-07-27
  begin
    sPisCofinsItem := '';
    { Deve gravar o xml com problema enviado ao sat
      Visualiza��o do xml deve permitir identificar problema
    if (Trim(IBQALTERACA.FieldByName('CST_PIS_COFINS').AsString) = '') then
      SmallMsg(IBQALTERACA.FieldByName('DESCRICAO').AsString + #13 +
                  'Configure o CST PIS/COFINS e Al�quota');
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
                             '<pPIS>' + FormataFloatXML(dpPIS, 4) + '</pPIS>' +       // Q09 Sefaz-SP orientou que deve enviar a al�quota dividida por 100
                           '</PISAliq>' +
                         '</PIS>';

      // COFINS
      sPisCofinsItem := sPisCofinsItem + '<COFINS>' +                                    // S01
                           '<COFINSAliq>' +                                              // S02 CST = 01 ou 02
                             '<CST>' + sCSTPISCOFINS + '</CST>' +                        // S07
                             '<vBC>' + FormataFloatXML(dvBCPisCofins, 2) + '</vBC>' +    // S08
                             '<pCOFINS>' + FormataFloatXML(dpCOFINS, 4) + '</pCOFINS>' + // S09 Sefaz-SP orientou que deve enviar a al�quota dividida por 100
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
                           '<PISOutr>' +                                               // Q06 CST = 99 Informar campos para c�lculo do PIS com aliquota em percentual (Q08 e Q09) ou campos para PIS com aliquota em valor (Q11 e Q12).
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

  function DadosPagamento(CodigoMeio: String; dValorMeio: Double): String;
  begin

    if (sWA05 <> '') then
      sWA05 := '<cAdmC>' + sWA05 + '</cAdmC>';

    Result :=
      '<MP>' +                                               // WA02
       '<cMP>' + CodigoMeio + '</cMP>' +                     // WA03 Nova reda��o, efeitos v00.03 01 - Dinheiro; 02 - Cheque; 03 - cart�o de cr�dito; 04 - cart�o de d�bito; 05 - vale refei��o; 06 - vale alimenta��o; 07 - vale presente; 08 - cr�dito por financeira; 09 - d�bito em folha de pagamento de funcion�rios; 10 - pagamento banc�rio (exemplo: boleto, dep�sito em conta); 11 - cr�dito de devolu��o de mercadoria; 12 - cr�dito de empresa conveniada 13 - pagamento antecipado; 99 - outros vales e meios de pagamento
       '<vMP>' + FormataFloatXML(dValorMeio, 2) + '</vMP>' + // WA04
       sWA05 +
     '</MP>';

  end;

  procedure AcumulaFormaExtraSAT(sOrdemExtra: String; dValor: Double);
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

begin
  //Result := '';
  sXMLCFe := ''; // Sandro Silva 2016-04-12
  sLog := ''; // Sandro Silva 2021-03-11

  slLog := TStringList.Create;
  IBQALTERACA       := CriaIBQuery(Form1.ibDataSet27.Transaction);
  IBQDESCONTOITEM   := CriaIBQuery(Form1.ibDataSet27.Transaction);
  IBQDESCONTOCUPOM  := CriaIBQuery(Form1.ibDataSet27.Transaction);
  IBQACRESCIMOCUPOM := CriaIBQuery(Form1.ibDataSet27.Transaction);
  IBQCLIFOR         := CriaIBQuery(Form1.ibDataSet27.Transaction);
  IBQEMITENTE       := CriaIBQuery(Form1.ibDataSet27.Transaction);
  IBQTOTALCUPOM     := CriaIBQuery(Form1.ibDataSet27.Transaction);
  IBQLEI12741       := CriaIBQuery(Form1.ibDataSet27.Transaction);

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
        '(select first 1 ICM.ISS from ICM where ICM.NOME = ''Servi�os'' or coalesce(ICM.ISS, 0) > 0) as ISS ' + // 2016-01-13
        'from ALTERACA A ' +
        'left join ESTOQUE E on E.CODIGO = A.CODIGO ' +
        'where A.PEDIDO = ' + QuotedStr(sCupom) +
        ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
        ' and A.CAIXA = ' + QuotedStr(sCaixa) +
        ' and A.DATA = ' + QuotedStr(FormataDataSQL(dtData)) +
        ' and (A.DESCRICAO <> ''<CANCELADO>'' ' +
         ' and A.DESCRICAO <> ''Desconto'' ' +
         ' and A.DESCRICAO <> ''Acr�scimo'') ' +
        ' and coalesce(A.ITEM, '''') <> '''' ' + // Que tenha n�mero do item informado no campo ALTERACA.ITEM
        ' order by A.REGISTRO';
      IBQALTERACA.Open;

      // Seleciona os descontos concedidos espec�ficos aos itens
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
        ' order by A.ITEM'; // Que tenha n�mero do item informado no campo ALTERACA.ITEM
      IBQDESCONTOITEM.Open;

      // Seleciona os descontos lan�ados para o cupom
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

      // Seleciona os acr�scimos lan�ados para o cupom
      IBQACRESCIMOCUPOM.Close;
      IBQACRESCIMOCUPOM.SQL.Text :=
        'select sum(A.TOTAL) as ACRESCIMOCUPOM ' +
        'from ALTERACA A ' +
        'where A.PEDIDO = ' + QuotedStr(sCupom) +
        ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
        ' and A.CAIXA = ' + QuotedStr(sCaixa) +
        ' and A.DATA = ' + QuotedStr(FormataDataSQL(dtData)) +
        ' and A.DESCRICAO = ''Acr�scimo'' ' +
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
        ' and (A.DESCRICAO <> ''Acr�scimo'') ';
      IBQTOTALCUPOM.Open;

      if IBQALTERACA.Eof = False then
      begin
        ssignAC := _59.AssinaturaAssociada; // Sandro Silva 2016-11-09  AssinaturaAssociada;

        sDadosIde := '<ide>' +                         // B01
                       '<CNPJ>' + _59.CNPJSoftwareHouse + '</CNPJ>' + // Sandro Silva 2016-11-09  B11                '<CNPJ>' + FCNPJSoftwareHouse + '</CNPJ>' + // B11
                       '<signAC>' + ssignAC + '</signAC>' +     // B12
                       '<numeroCaixa>' + sCaixa + '</numeroCaixa>' + // B14 utilizando equipamento ou emulador compat�vel com espec�fica��o 2.3.13 ou superior
                     '</ide>';
        // Seleciona dados do emitente
        sCNPJEmitente := LimpaNumero(_59.Emitente.CNPJ);
        sIEEmitente   := LimpaNumero(_59.Emitente.IE);
        sIMEmitente   := LimpaNumero(_59.Emitente.IM);

        if LerParametroIni('FRENTE.INI', 'SAT-CFe', 'Completar IE', 'N�o') = 'Sim' then
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

          if ValidaEAN(Trim(IBQALTERACA.FieldByName('EAN').AsString)) then // Preencher com o c�digo GTIN-8, GTIN-12, GTIN-13 ou GTIN-14 (antigos c�digos EAN, UPC e DUN-14), n�o informar o conte�do da TAG em caso de o produto n�o possuir este c�digo.
            sDadosItens := sDadosItens + '<cEAN>' + IBQALTERACA.FieldByName('EAN').AsString + '</cEAN>';           // I03

          sDadosItens := sDadosItens + '<xProd>' + Trim(ConverteAcentos2(IBQALTERACA.FieldByName('DESCRICAO').AsString)) + '</xProd>';     // I04

          // C�digo NCM (8 posi��es), informar o g�nero (posi��o do cap�tulo do NCM)
          // quando a opera��o n�o for de com�rcio exterior (importa��o/ exporta��o)
          // ou o produto n�o seja tributado pelo IPI.
          // Em caso de servi�o informar o c�digo 99

          if Trim(IBQALTERACA.FieldByName('TIPO_ITEM').AsString) = '09' then
              sDadosItens := sDadosItens + '<NCM>99</NCM>'       // I05
          else
            if Length(Trim(IBQALTERACA.FieldByName('NCM').AsString)) in [2, 8] then
              sDadosItens := sDadosItens + '<NCM>' + Trim(IBQALTERACA.FieldByName('NCM').AsString) + '</NCM>'       // I05
            else
              slLog.Add('Ajuste no estoque ' + IBQALTERACA.FieldByName('CODIGO').AsString + '-' + IBQALTERACA.FieldByName('DESCRICAO').AsString + ' - NCM inv�lido: "' + Trim(IBQALTERACA.FieldByName('NCM').AsString) + '"'); // Sandro Silva 2021-03-10

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
          //Regra: Deve ser informado com 3 decimais no caso de combust�veis (Portaria DNC 30/94), para os demais com 2 decimais. Ver Especifica��o_SAT_v_ER_2_27_05.pdf
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

            // Informa��es CEST
            if (LimpaNumero(IBQALTERACA.FieldByName('CEST').AsString) <> '')
              and (Trim(IBQALTERACA.FieldByName('TIPO_ITEM').AsString) <> '09') then
            begin
              //Artigo 1� - Fica acrescentado o Artigo 33-B � Portaria CAT 147/12, de 5 de novembro de 2012, com a seguinte reda��o:
              //�Artigo 33-B - Nas opera��es com mercadorias ou bens listados nos Anexos do Conv�nio ICMS 92, de 20-08-2015, sujeitos aos regimes de substitui��o tribut�ria ou de antecipa��o do recolhimento do imposto, o contribuinte dever� preencher obrigatoriamente o respectivo C�digo Especificador da Substitui��o Tribut�ria - CEST, conforme segue:
              //I - campo ID I18 (xCampoDet): preencher com �Cod. CEST�;
              //II - campo ID I19 (xTextoDet): utilizar o C�digo Especificador da Substitui��o Tribut�ria - CEST, conforme definido no conv�nio ICMS 92, de 20-08-2015.� (NR).
              //Artigo 2� - Esta portaria entra em vigor na data de sua publica��o, produzindo efeitos a partir de 01-04-2016. (Reda��o dada ao artigo pela Portaria CAT-155/15, de 23-12-2015; DOE 24-12-2015)
              //Artigo 2� - Esta portaria entra em vigor na data de sua publica��o, produzindo efeitos a partir de 01-01-2016.

              sDadosItens := sDadosItens + '<obsFiscoDet xCampoDet="' + 'Cod. CEST' + '">' +
                                             '<xTextoDet>' + LimpaNumero(IBQALTERACA.FieldByName('CEST').AsString) + '</xTextoDet>' +
                                           '</obsFiscoDet>';
            end;

          end;

          if (sCFOPItem = '5656') or (sCFOPItem = '5667') then // Combust�vel // Sandro Silva 2019-05-20 if (sCFOPItem = '5656') then // Combust�vel
          begin
            // Nova   reda��o   para   efeitos   a partir de 01.01.19:
            // Conte�do do campo. No caso de combust�veis  e/ou   lubrificantes, quando informado �CFOP 5656 �Venda de combust�vel ou lubrificante adquirido ou recebido de terceiros destinado a consumidor  ou  usu�rio  final�,
            // informar  c�digo  de  produto  do Sistema    de    Informa��es    de Movimenta��o    de    produtos-SIMP (http://www.anp.gov.br/simp).
            // Informar 999999999 se o produto  n�o  possuir  c�digo  de produto ANP.
            sCodigoANP := Trim(RetornaValorDaTagNoCampo('cProdANP', IBQALTERACA.FieldByname('TAGS_').AsString));
            if sCodigoANP = '' then
            begin
              Form1.ExibePanelMensagem(IBQALTERACA.FieldByname('CODIGO').AsString + ' ' + IBQALTERACA.FieldByname('DESCRICAO').AsString + ' sem CODIGO ANP. Preencha a tag cProdANP no cadastro do estoque');
              Sleep(5000);
              sCodigoANP := '999999999';
            end;
            sDadosItens := sDadosItens + '<obsFiscoDet xCampoDet="' + 'Cod. Produto ANP' + '">' +
                                           '<xTextoDet>' + sCodigoANP + '</xTextoDet>' +
                                         '</obsFiscoDet>';
          end;

          sDadosItens := sDadosItens +
                 // Quando frente vai gerar informa��o para este elemento? '<vOutro>0.00</vOutro>' +                                   // I13
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
                if Trim(IBQALTERACA.FieldByName('CSOSN_NFCE').AsString) <> '' then // Se tem configurado CSOSN para movimentar no balc�o, prioridade para ele
                  sCSOSNItem := Trim(IBQALTERACA.FieldByName('CSOSN_NFCE').AsString); // ESTOQUE.CSOSN_NFCE
              end
              else
              begin
                {Sandro Silva 2021-08-26 inicio}

                // Caso tenha lan�ado o item na venda, ocorreu rejei��o e tenha corrigido no Estoque
                // Permite alterar sem precisar cancelar o item e lan�ar novamente

                if Trim(IBQALTERACA.FieldByName('CSOSN_NFCE').AsString) <> '' then // Tem CSOSN definido para venda no balc�o
                begin
                  if Trim(IBQALTERACA.FieldByName('CSOSN').AsString) <> Trim(IBQALTERACA.FieldByName('CSOSN_NFCE').AsString) then // O CSOSN que foi salvo no Alteraca � diferente daquele definido no Estoque para venda no balc�o
                    sCSOSNItem := Trim(IBQALTERACA.FieldByName('CSOSN_NFCE').AsString); // Priodidade para o CSOSN definido para venda no balc�o ESTOQUE.CSOSN
                end
                else
                begin
                  // N�o tem CSOSN definido para venda no balc�o

                  if Trim(IBQALTERACA.FieldByName('ESTOQUE_CSOSN').AsString) <> '' then // O CSOSN foi configurado no Estoque
                  begin
                    if Trim(IBQALTERACA.FieldByName('CSOSN').AsString) <> Trim(IBQALTERACA.FieldByName('ESTOQUE_CSOSN').AsString) then // O CSOSN que foi salvo no Alteraca � diferente daquele definido no Estoque
                      sCSOSNItem := Trim(IBQALTERACA.FieldByName('ESTOQUE_CSOSN').AsString); // Usa o CSOSN do Estoque ESTOQUE.CSOSN
                  end;
                end;
                {Sandro Silva 2021-08-26 fim}
              end;

              {Sandro Silva 2021-08-26 inicio}
              if (Trim(sCSOSNItem) <> '') and (Trim(sCSOSNItem) <> Trim(IBQALTERACA.FieldByName('CSOSN').AsString)) then // Se o CSOSN selecionado � diferente daquele lan�ado no Alteraca faz a atualiza��o no Alteraca
              begin

                // Atualiza ALTERACA.CSOSN com aquele que ser� informado no xml
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

              end;
              {Sandro Silva 2021-08-26 fim}
          
              {Sandro Silva 2021-03-11 inicio}
              if Trim(sCSOSNItem) = '' then
              begin
                slLog.Add(IBQALTERACA.FieldByName('CODIGO').AsString + '-' + IBQALTERACA.FieldByName('DESCRICAO').AsString + ' - CSOSN inv�lido: "' + Trim(sCSOSNItem) + '"'); // Sandro Silva 2021-03-10
              end;
              {Sandro Silva 2021-03-11 fim}

              if ((_59.VersaoDadosEnt = VDE_007) and ((sCSOSNItem = '102') or (sCSOSNItem = '300') or (sCSOSNItem = '400') or (sCSOSNItem = '500')) )
                or ((_59.VersaoDadosEnt = VDE_008) and ((sCSOSNItem = '102') or (sCSOSNItem = '300') or (sCSOSNItem = '400') or (sCSOSNItem = '500')) ) // Sandro Silva 2019-04-16
               then
              begin
                //102- Tributada pelo Simples Nacional sem permiss�o de cr�dito.
                //300 � Imune
                //400 � N�o tributada
                //500 � ICMS cobrado anteriormente por substitui��o tribut�ria (substitu�do) ou por antecipa��o
                sDadosItens := sDadosItens + '<ICMSSN102>' +                         // N04 Tributa��o do ICMS: pelo SIMPLES NACIONAL e CSOSN=102, 300, 500
                                               '<Orig>' + sOrigItem + '</Orig>' +    // N06
                                               '<CSOSN>' + sCSOSNItem + '</CSOSN>' + // N10
                                             '</ICMSSN102>';
              end
              else
              begin // Outros CSOSN. Ex.: 900
                sDadosItens := sDadosItens + '<ICMSSN900>' +                         // N05 Tributa��o do ICMS: pelo SIMPLES NACIONAL e CSOSN=900
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

              if Length(LimpaNumero(IBQALTERACA.FieldByname('CST_NFCE').AsString)) > 1 then // Se existir CST para NFC-e usa a configura��o
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
                sCST_ICMSItem := '00'; // CST_ICMS for diferente, definir 00 como padr�o

              if _59.IBDATASET27.FieldByname('CST_ICMS').Value <> Trim(sOrigItem) + Trim(sCST_ICMSItem)  then
              begin
                _59.IBDATASET27.Edit;
                _59.IBDATASET27.FieldByname('CST_ICMS').Value := Trim(sOrigItem) + Trim(sCST_ICMSItem);
                _59.IBDATASET27.Post;
              end;

              if StrToInt(sCST_ICMSItem) in [00, 20, 90] then
              begin // Grupo de Tributa��o do ICMS= 00, 20, 90

                dpICMS_N08 := StrToFloat(AliquotaIcms(Trim(IBQALTERACA.FieldByName('ALIQUICM').AsString)));
                if IBQALTERACA.FieldByname('ALIQUOTA_NFCE').AsFloat > 0.00 then
                begin
                  dpICMS_N08 := IBQALTERACA.FieldByName('ALIQUOTA_NFCE').AsFloat;
                  _59.IBDATASET27.Edit;
                  _59.IBDATASET27.FieldByName('ALIQUICM').AsString := LimpaNumero(FormatFloat('00.00', dpICMS_N08));
                  _59.IBDATASET27.Post;
                end;

                sDadosItens := sDadosItens + '<ICMS00>' +                            // N02 Tributa��o do ICMS: 00 � Tributada integralmente 20 - Com redu��o de base de c�lculo 90 - Outros
                                               '<Orig>' + sOrigItem + '</Orig>' +    // N06 Origem da mercadoria: 0 � Nacional; 1 � Estrangeira � Importa��o direta; 2 � Estrangeira � Adquirida no mercado interno.
                                               '<CST>' + sCST_ICMSItem + '</CST>' +  // N07
                                               // 2016-01-19 '<pICMS>' + FormataFloatXML(StrToFloat(AliquotaIcms(Trim(IBQALTERACA.FieldByName('ALIQUICM').AsString))), 2) + '</pICMS>' + // N08
                                               '<pICMS>' + FormataFloatXML(dpICMS_N08, 2) + '</pICMS>' + // N08
                                             '</ICMS00>';
              end;

              if (_59.VersaoDadosEnt = VDE_007) or (_59.VersaoDadosEnt = VDE_008) then // Sandro Silva 2019-04-16 if _59.VersaoDadosEnt = VDE_007 then
              begin
                if StrToInt(sCST_ICMSItem) in [40, 41, 60] then
                begin // Grupo de Tributa��o do ICMS = 40, 41, 60
                  sDadosItens := sDadosItens + '<ICMS40>' +                            // N03 Tributa��o do ICMS: 40 - Isenta 41 - N�o tributada 60 - ICMS cobrado anteriormente por substitui��o tribut�ria
                                                 '<Orig>' + sOrigItem + '</Orig>' +    // N06 Origem da mercadoria: 0 � Nacional; 1 � Estrangeira � Importa��o direta; 2 � Estrangeira � Adquirida no mercado interno.
                                                 '<CST>' + sCST_ICMSItem + '</CST>' +  // N07
                                               '</ICMS40>';
                end;
              end;
            end; // if IBQEMITENTE.FieldByName('CRT').AsString = _59_CRT_SIMPLES_NACIONAL then

            sDadosItens := sDadosItens + '</ICMS>';

            sDadosItens := sDadosItens + GrupoPISCofins;

          end
          else
          begin // Servi�os

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

            /// Servi�o  ALIQUOTA_NFCE
            sDadosItens := sDadosItens + '<ISSQN>' +                                             // U01
                                           '<vDeducISSQN>0.00</vDeducISSQN>' +                   // U02
                                           '<vAliq>' + Right('00' + FormataFloatXML(dvAliq_U04, 2), 6) + '</vAliq>' +  // U04
                                           '<cMunFG>' + Trim(Copy(IBQEMITENTE.FieldByname('CODIGO').AsString,1,7)) + '</cMunFG>' + // U6
                                           scListServ + // 2015-05-19 '<cListServ>' + LimpaNumero(ExtrairConfiguracao(IBQALTERACA.FieldByName('LIVRE4').AsString, SIGLA_CLISTSERV, False)) + '</cListServ>' +
                                           '<cServTribMun>' + scServTribMun + '</cServTribMun>' + // Sandro Silva 2020-08-21 '<cServTribMun>' + Right(DupeString('0', 20) + IBQALTERACA.FieldByname('EAN').AsString, 20) + '</cServTribMun>' +
                                           '<cNatOp>01</cNatOp>' +                                 // U09 1 - Tributa��o no munic�pio; 2 - Tributa��o fora do munic�pio; 3 - Isen��o; 4 - Imune; 5 - Exigibilidade suspensa por decis�o judicial 6 - Exigibilidade suspensa por procedimento administrativo; 7 - N�o tribut�vel ou n�o incid�ncia; 8 - Exporta��o de Servi�o.
                                           '<indIncFisc>2</indIncFisc>' +                         // U10 1 - Sim; 2 - N�o
                                         '</ISSQN>';

            sDadosItens := sDadosItens + GrupoPISCofins; // Sandro Silva 2016-03-28 PIS/Cofins ap�s ISSQN

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
          2�, �2� da referida lei.
          - obrigat�rio, caso o contribuinte n�o opte por informar o valor em painel afixado no estabelecimento, conforme artigo
          2�, �2� da referida lei.}
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
          2�, �2� da referida lei.
          - obrigat�rio, caso o contribuinte n�o opte por informar o valor em painel afixado no estabelecimento, conforme artigo
          2�, �2� da referida lei.}
        begin
          sDadosTotal := '<total>';
          sDadosTotal := sDadosTotal + '<vCFeLei12741>' + FormataFloatXML(dTotalLei12741, 2) + '</vCFeLei12741>';
          sDadosTotal := sDadosTotal + '</total>';
        end;

        sDadosPagamento := '<pgto>'; // 2013-02-08 '';

        if Form1.fTEFPago                      > 0 then
        begin
          //
          // SmallMsg('Cart�o TEF');
          //
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
            //Localiza todos cadastros com OBS contendo o nome da rede ou que o relacionamento = credenciadora de cart�o
            IBQCLIFOR.Close;
            IBQCLIFOR.SQL.Text :=
              'select * ' +
              'from CLIFOR ' +
              'where (OBS containing ' + QuotedStr(BandeiraSemCreditoDebito(Form1.sNomeRede)) + ' and coalesce(CLIFOR, '''') = ''Credenciadora de cart�o'') or coalesce(CLIFOR, '''') = ''Credenciadora de cart�o'' ';
            IBQCLIFOR.Open;

            sWA05 := CodigoCredenciadora(Trim(LimpaNumero(SelecionaCNPJCredenciadora(IBQCLIFOR, BandeiraSemCreditoDebito(Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].NomeRede)))));

            sDadosPagamento := sDadosPagamento + DadosPagamento(sTipoCartao, Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].ValorPago);

            sWA05 := ''; // Para n�o interfertir nas demais formas de pagamento usadas na venda Sandro Silva 2020-08-03

          end;
          //
        end;
        //
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
        //

        if LerParametroIni(FRENTE_INI, SECAO_65, CHAVE_FORMAS_CONFIGURADAS, 'N�o') = 'Sim' then
        begin

          if Form1.ibDataSet25VALOR01.AsFloat    <> 0 then
          begin
            AcumulaFormaExtraSAT(Form1.sOrdemExtraNFCe1, Form1.ibDataSet25VALOR01.AsFloat);
          end;

          if Form1.ibDataSet25VALOR02.AsFloat    <> 0 then
          begin
            AcumulaFormaExtraSAT(Form1.sOrdemExtraNFCe2, Form1.ibDataSet25VALOR02.AsFloat);
          end;

          if Form1.ibDataSet25VALOR03.AsFloat    <> 0 then
          begin
            AcumulaFormaExtraSAT(Form1.sOrdemExtraNFCe3, Form1.ibDataSet25VALOR03.AsFloat);
          end;

          if Form1.ibDataSet25VALOR04.AsFloat    <> 0 then
          begin
            AcumulaFormaExtraSAT(Form1.sOrdemExtraNFCe4, Form1.ibDataSet25VALOR04.AsFloat);
          end;

          if Form1.ibDataSet25VALOR05.AsFloat    <> 0 then
          begin
            AcumulaFormaExtraSAT(Form1.sOrdemExtraNFCe5, Form1.ibDataSet25VALOR05.AsFloat);
          end;

          if Form1.ibDataSet25VALOR06.AsFloat    <> 0 then
          begin
            AcumulaFormaExtraSAT(Form1.sOrdemExtraNFCe6, Form1.ibDataSet25VALOR06.AsFloat);
          end;

          if Form1.ibDataSet25VALOR07.AsFloat    <> 0 then
          begin
            AcumulaFormaExtraSAT(Form1.sOrdemExtraNFCe7, Form1.ibDataSet25VALOR07.AsFloat);
          end;

          if Form1.ibDataSet25VALOR08.AsFloat    <> 0 then
          begin
            AcumulaFormaExtraSAT(Form1.sOrdemExtraNFCe8, Form1.ibDataSet25VALOR08.AsFloat);
          end;


          if dvMP_WA03_10 > 0 then
            sDadosPagamento := sDadosPagamento + DadosPagamento(SAT_CODIGO_MEIO_PAGAMENTO_10_VALE_ALIMENTACAO, dvMP_WA03_10); // 10=Vale Alimenta��o

          if dvMP_WA03_11 > 0 then
            sDadosPagamento := sDadosPagamento + DadosPagamento(SAT_CODIGO_MEIO_PAGAMENTO_11_VALE_REFEICAO, dvMP_WA03_11); // 11=Vale Refei��o

          if dvMP_WA03_12 > 0 then
            sDadosPagamento := sDadosPagamento + DadosPagamento(SAT_CODIGO_MEIO_PAGAMENTO_12_VALE_PRESENTE, dvMP_WA03_12); // 12=Vale Presente

          if dvMP_WA03_13 > 0 then
            sDadosPagamento := sDadosPagamento + DadosPagamento(SAT_CODIGO_MEIO_PAGAMENTO_13_VALE_COMBUSTIVEL, dvMP_WA03_13); // 13=Vale Combust�vel

          {Sandro Silva 2021-08-10 inicio}
          if dvMP_WA03_16 > 0 then
            sDadosPagamento := sDadosPagamento + DadosPagamento(SAT_CODIGO_MEIO_PAGAMENTO_16_DEPOSITO_BANCARIO, dvMP_WA03_16); // 16=Dep�sito Banc�rio
          if dvMP_WA03_17 > 0 then
            sDadosPagamento := sDadosPagamento + DadosPagamento(SAT_CODIGO_MEIO_PAGAMENTO_17_PAGAMENTO_INSTANTANEO, dvMP_WA03_17); // 17=Pagamento Instant�neo
          if dvMP_WA03_18 > 0 then
            sDadosPagamento := sDadosPagamento + DadosPagamento(SAT_CODIGO_MEIO_PAGAMENTO_18_TRANSFERENCIA_BANCARIA_CARTEIRA_DIGITAL, dvMP_WA03_18); // 18=Transfer�ncia banc�ria, Carteira Digital
          if dvMP_WA03_19 > 0 then
            sDadosPagamento := sDadosPagamento + DadosPagamento(SAT_CODIGO_MEIO_PAGAMENTO_19_PROGRAMA_FIDELIDADE_CASHBACK_CREDITO_VIRTUAL, dvMP_WA03_19); // 19=Programa de fidelidade, Cashback, Cr�dito Virtual
          {Sandro Silva 2021-08-10 fim}

          if dvMP_WA03_99 > 0 then
            sDadosPagamento := sDadosPagamento + DadosPagamento(SAT_CODIGO_MEIO_PAGAMENTO_99_OUTROS, dvMP_WA03_99); // 99=Outros
            
        end
        else
        begin
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
        end;

        sDadosPagamento := sDadosPagamento + '</pgto>'; // 2013-02-08;

        if _59.MensagemPromocional <> '' then
          sDadosinfAdic := '<infAdic><infCpl>' + Form1.ConverteAcentosXML(_59.MensagemPromocional) + ' '; // Sandro Silva 2017-02-17  ConverteAcentos2(_59.MensagemPromocional) + ' '; // Sandro Silva 2016-05-24 ConverteAcentos2()
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

  ChDir(Form1.sAtual); // Sandro Silva 2017-03-31

  sLog := slLog.Text; // Sandro Silva 2021-03-10

  FreeAndNil(slLog); // Sandro Silva 2021-09-09

end;
*)

function MontaXMLVenda(sCaixa: String; dtData: TDate; sCupom: String;
  var sLog: String): AnsiString;
var
  XmlVendaSat: TMontaXmlVendaSAT;
begin
  Result := '';
  XmlVendaSat := TMontaXmlVendaSAT.Create;
  try
    XmlVendaSat.DestinatarioInformadoNaTela.CnpjCPF := Form2.Edit2.Text;
    XmlVendaSat.DestinatarioInformadoNaTela.Nome    := Form2.Edit8.Text;
    XmlVendaSat.Pagamentos.TEFPago                := Form1.fTEFPago;
    XmlVendaSat.Pagamentos.NomeRede               := Form1.sNomeRede;
    XmlVendaSat.Pagamentos.TransacoesCartao       := Form1.TransacoesCartao;
    XmlVendaSat.Pagamentos.OrdemExtra1            := Form1.sOrdemExtraNFCe1;
    XmlVendaSat.Pagamentos.OrdemExtra2            := Form1.sOrdemExtraNFCe2;
    XmlVendaSat.Pagamentos.OrdemExtra3            := Form1.sOrdemExtraNFCe3;
    XmlVendaSat.Pagamentos.OrdemExtra4            := Form1.sOrdemExtraNFCe4;
    XmlVendaSat.Pagamentos.OrdemExtra5            := Form1.sOrdemExtraNFCe5;
    XmlVendaSat.Pagamentos.OrdemExtra6            := Form1.sOrdemExtraNFCe6;
    XmlVendaSat.Pagamentos.OrdemExtra7            := Form1.sOrdemExtraNFCe7;
    XmlVendaSat.Pagamentos.OrdemExtra8            := Form1.sOrdemExtraNFCe8;
    XmlVendaSat.Pagamentos.DataSetFormasPagamento := Form1.ibDataSet25;
    Result := XmlVendaSat.GeraXMLVenda(_59, sCaixa, dtData, sCupom, sLog);
    if XmlVendaSat.Pagamentos.NomeRede <> Form1.sNomeRede then
      Form1.sNomeRede := XmlVendaSat.Pagamentos.NomeRede;
  finally
  end;
  FreeAndNil(XmlVendaSat);

  ChDir(Form1.sAtual); // Sandro Silva 2017-03-31
end;

function Small_InputBox(pP1, pP2, pP3: String): String;
begin
  Result := '';
  if Form12 = nil then
  begin
    Application.CreateForm(TForm12, Form12);
  end;
  Form12.Label1.Caption := pP1;
  Form12.Label2.Caption := pP2;
  Form12.Edit1.Text     := pP3;
  //
  if Pos('SENHA',Uppercase(pP1))=0 then Form12.Edit1.PasswordChar := #0 else Form12.Edit1.PasswordChar := Char('*');
  //
  Form12.ShowModal;
  //
  Result := Form12.Edit1.Text;
  // Sandro Silva 2017-08-02 N�o deu certo  Result := Form1.Small_InputBox(pP1, pP2, pP3);
  //
end;

function Small_InputComboBox(pP1, pP2, pP3: String): String;
// Precisa ser declarada aqui para poder usar no projeto servidorsat
begin
  Result := '';
  if Form27 = nil then
  begin
    Application.CreateForm(TForm27, Form27);
  end;

  Form27.TipoInformacaoCombo := tiInfoComboModeloSAT; // Sandro Silva 2017-09-06 
  Form27.Label1.Caption   := pP1;
  Form27.Label2.Caption   := pP2;
  Form27.FabricanteModelo := pP3;
  //
  Form27.ShowModal;
  //
  if AnsiContainsText(Form27.Label1.Caption, 'Equipamento SAT') then
    Result := LimpaNumero(Copy(Form27.ComboBox1.Text, 1, 4))
  else
    Result := Form27.ComboBox1.Text;
  //
  FreeAndNil(Form27);
end;

function FunctionDetect(LibName, FuncName: String; var LibPointer: Pointer): boolean;
var
  LibHandle: tHandle;
begin
  Result := false;
  LibPointer := NIL;
  if LoadLibrary(PAnsiChar(LibName)) = 0 then exit;
  LibHandle := GetModuleHandle(PAnsiChar(LibName));
  if LibHandle <> 0 then
  begin
    LibPointer := GetProcAddress(LibHandle, PAnsiChar(FuncName));
    if LibPointer <> NIL then Result := true;
  end;
end;

// ---------------------------------- //
// ---------------------------------- //
function _ecf59_CodeErro(Pp1: Integer):Integer;
begin
  Result := 0;
end;

//-------------------------------------------//
// Detecta qual a porta que                  //
// a impressora est� conectada               //
// MATRICIAL MECAF / BEMATECH MP 2000 CI NF  //
//-------------------------------------------//
function _ecf59_Inicializa(Pp1: String): Boolean;
var
  iTentativa: Integer;
  sMensagem: String;
  sNumeroSat: String;
  sPathDll: String;
  sPathXMLSat: String;
  sAssinaturaAssociada: String;
  sCodigoAtivacao: String;
  sCodigoFabricante: String;
  sCNPJSoftwareHouse: String;
  sStatusOperacional: String;
  IBQAMBIENTE: TIBQuery;
  iTentativaDLL: Integer;
  sCaminhoIntegrador: String;
  sChaveAcessoValidador: String;
begin
  Result := False;
  if _59 = nil then
  begin
    Application.Title    := 'Aplicativo Emissor de CF-e-SAT';
    _59 := TSmall59.Create(Form1);// Sandro Silva 2017-02-09  TSmall59.Create(nil);

    Mobile_59 := TMobile.Create(nil); // Sandro Silva 2016-08-25
    _59.TipoEquipamento := TIPO_EQUIPAMENTO_SAT;

    _ecf59_ConfiguraDadosEmitente;
    if (Form1.ibDataSet13.FieldByName('ESTADO').AsString = '') then
    begin
      Application.MessageBox(PAnsiChar('Acesse o Small e configure os dados do emitente ' + #13 +
                                   'e reinicie aplica��o' + #13 + #13 +
                                   'Essa aplica��o ser� fechada'),'Aten��o', MB_ICONWARNING + MB_OK);
      FecharAplicacao(ExtractFileName(Application.ExeName));
      Abort;
    end;

    if (Form1.ibDataSet13.FieldByName('ESTADO').AsString = 'CE') then
    begin

      _59.TipoEquipamento := TIPO_EQUIPAMENTO_MFE;

      if Form1.UsaIntegradorFiscal('') then
        _59.ModoOperacao    := moIntegradorMFE;

      {Sandro Silva 2021-08-23 inicio}
      if FileExists('c:\Program Files (x86)\SEFAZ-CE\Driver MFE\Biblioteca de fun��es\mfe.dll') or FileExists('c:\Program Files\SEFAZ-CE\Driver MFE\Biblioteca de fun��es\mfe.dll') then
      begin

        if FileExists('c:\Program Files (x86)\SEFAZ-CE\Driver MFE\Biblioteca de fun��es\mfe.dll') then
          GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CAMINHO_DLL, 'c:\Program Files (x86)\SEFAZ-CE\Driver MFE\Biblioteca de fun��es\mfe.dll') // 64 bits
        else
          GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CAMINHO_DLL, 'c:\Program Files\SEFAZ-CE\Driver MFE\Biblioteca de fun��es\mfe.dll'); // 32 bits
          
        _ecf59_HabilitaUsarDriverMFE_1_05(True);

        Form1.ExibePanelMensagem('Driver MFE atualizado', True);
        Sleep(3000);
        Form1.OcultaPanelMensagem;

      end
      else
      begin
        _ecf59_HabilitaUsarDriverMFE_1_05(False);
        Form1.ExibePanelMensagem('Atualize o Driver MFE para vers�o mais atual', True);
        Sleep(3000);
        Form1.OcultaPanelMensagem;
      end;

      _59.DriverMFE01_05_15_Superior := (Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_VERSAO_DRIVER_MFE_1_05, 'N�o')) = 'Sim');
      {Sandro Silva 2021-08-23 fim}


      if Form1.bBalancaAutonoma = False then // Sandro Silva 2019-01-23
      begin

        if Form1.UsaIntegradorFiscal(_59.Emitente.UF) then // Sandro Silva 2022-07-11
        begin

          while sCaminhoIntegrador = '' do
          begin

            sCaminhoIntegrador  := LerParametroIni(FRENTE_INI, SECAO_MFE, CHAVE_CAMINHO_INTEGRADOR_FISCAL, Form1.IntegradorCE.CaminhoIntegrador);  // Sandro Silva 2018-07-03 LerParametroIni(FRENTE_INI, SECAO_MFE, CHAVE_CAMINHO_INTEGRADOR_FISCAL, _59.IntegradorMFE.CaminhoIntegrador); // 'c:\Integrador';
            if sCaminhoIntegrador = '' then
            begin
              if ConfiguraCaminhoIntegradorFiscal then // Sandro Silva 2018-07-03 if _ecf59_ConfiguraCaminhoIntegradorFiscal then
                sCaminhoIntegrador := LerParametroIni(FRENTE_INI, SECAO_MFE, CHAVE_CAMINHO_INTEGRADOR_FISCAL, Form1.IntegradorCE.CaminhoIntegrador); // Sandro Silva 2018-07-03 LerParametroIni(FRENTE_INI, SECAO_MFE, CHAVE_CAMINHO_INTEGRADOR_FISCAL, _59.IntegradorMFE.CaminhoIntegrador); // 'c:\Integrador';
            end;

            if DirectoryExists(sCaminhoIntegrador) = False then
            begin
              sCaminhoIntegrador := '';
              SalvarConfiguracao(FRENTE_INI, SECAO_MFE, CHAVE_CAMINHO_INTEGRADOR_FISCAL, ''); // Sandro Silva 2017-07-24
            end;

          end;

        end; //if Form1.UsaIntegradorFiscal(_59.Emitente.UF) then

      end;

      if Form1.sCaixa = '' then
      begin
        Form1.sCaixa := LerParametroIni(FRENTE_INI, SECAO_FRENTE_CAIXA, 'Caixa', ''); // Sandro Silva 2018-07-03
      end;

      Form1.IntegradorCE.CnpjContribuinte  := LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString); // Sandro Silva 2018-07-03
      Form1.IntegradorCE.DiretorioAtual    := Form1.sAtual; // Sandro Silva 2018-07-03
      Form1.IntegradorCE.CaminhoLog        := ExtractFilePath(Application.ExeName) + 'log';// Sandro Silva 2018-07-03
      Form1.IntegradorCE.CaminhoIntegrador := sCaminhoIntegrador; // Sandro Silva 2018-07-03
      Form1.IntegradorCE.ComponenteMFE     := COMPONENTE_MFE; // Sandro Silva 2018-07-03
      Form1.IntegradorCE.Caixa             := Form1.sCaixa; // Sandro Silva 2018-07-03
      _59.IntegradorMFE := Form1.IntegradorCE; // Aponta o componente Integrador dentro do SAT para o componente criado no form1 usado tamb�m para NFC-e Sandro Silva 2018-07-03

      if Form1.UsaIntegradorFiscal() then
      begin

        if Form1.bBalancaAutonoma = False then // Sandro Silva 2019-01-23
        begin

          if InicializaIntegradorFiscal(Form22.Label6) = False then
            Abort;

        end;

      end;

    {Sandro Silva 2021-08-27 inicio
    end
    else
    begin

      if Form1.bBalancaAutonoma = False then // Sandro Silva 2019-01-23
      begin
        if ConsultaProcesso('servidorsat.exe') then // Sandro Silva 2017-03-21
        begin
          GravarParametroIni(FRENTE_INI, SECAO_59, CHAVE_MODO_OPERACAO, 'CLIENTE'); // Sandro Silva 2017-03-21
          _59.ModoOperacao := moClient;
        end;

        if (Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CODIGO_FABRICANTE, '')) = '') and
          (LerParametroIni(FRENTE_INI, SECAO_59, CHAVE_MODO_OPERACAO, '') = '') then
        begin
          if Application.MessageBox('O Equipamento SAT est� conectado neste computador?', 'Conex�o com SAT', MB_YESNO + MB_ICONINFORMATION + MB_DEFBUTTON1) = ID_NO then
          begin
            if Form1.bBalancaAutonoma = False then
            begin
              Form1.SATConectarServidorSAT1Click(Form1.SATConectarServidorSAT1);
            end;
            Abort;
          end;
        end;

        if (AnsiUpperCase(LerParametroIni(FRENTE_INI, SECAO_59, CHAVE_MODO_OPERACAO, '')) = 'CLIENTE') then
          _59.ModoOperacao := moClient;
      end;
    end;
    }
    end;

    if _59.DriverMFE01_05_15_Superior or (AnsiUpperCase(Form1.ibDataSet13.FieldByName('ESTADO').AsString) <> 'CE')  then
    begin

      if Form1.bBalancaAutonoma = False then // Sandro Silva 2019-01-23
      begin
        if ConsultaProcesso('servidorsat.exe') then // Sandro Silva 2017-03-21
        begin
          GravarParametroIni(FRENTE_INI, SECAO_59, CHAVE_MODO_OPERACAO, 'CLIENTE'); // Sandro Silva 2017-03-21
          _59.ModoOperacao := moClient;
        end;

        if (Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CODIGO_FABRICANTE, '')) = '') and
          (LerParametroIni(FRENTE_INI, SECAO_59, CHAVE_MODO_OPERACAO, '') = '') then
        begin
          if Application.MessageBox('O Equipamento SAT est� conectado neste computador?', 'Conex�o com SAT', MB_YESNO + MB_ICONINFORMATION + MB_DEFBUTTON1) = ID_NO then
          begin
            if Form1.bBalancaAutonoma = False then
            begin
              Form1.SATConectarServidorSAT1Click(Form1.SATConectarServidorSAT1);
            end;
            Abort;
          end;
        end;

        if (AnsiUpperCase(LerParametroIni(FRENTE_INI, SECAO_59, CHAVE_MODO_OPERACAO, '')) = 'CLIENTE') then
          _59.ModoOperacao := moClient;
      end; // if Form1.bBalancaAutonoma = False then
      
    end;

    {Sandro Silva 2021-08-27 fim}

    _59.ConfiguracaoCasasDecimaisPreco := Form1.ConfPreco;
    _59.ConfiguracaoCasasDecimaisQtd   := Form1.ConfCasas;

    _59.CaminhoComunicacao := LerParametroIni(FRENTE_INI, SECAO_59, CHAVE_CAMINHO_SERVIDOR, ExtractFilePath(Application.ExeName) + 'SAT');

    if (_59.ModoOperacao = moClient) or
      (_59.TipoEquipamento = TIPO_EQUIPAMENTO_MFE) then // Sandro Silva 2017-05-23  (Form1.ibDataSet13.FieldByName('ESTADO').AsString = 'CE') then
    begin
       _59.Caixa        := LerParametroIni(FRENTE_INI, SECAO_FRENTE_CAIXA, 'Caixa', '');

       if (_59.TipoEquipamento = TIPO_EQUIPAMENTO_SAT) then
       begin
         _59.ModoOperacao   := moClient;
         _59.DiretorioAtual := Form1.sAtual; // Sandro Silva 2017-09-08
         _ecf59_ImportaConfiguracao;
       end;

    end;

    sPathDll             := Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CAMINHO_DLL, sPathDll));

    sCNPJSoftwareHouse   := Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CNPJ_SOFTWARE_HOUSE, sCNPJSoftwareHouse));
    sPathXMLSat          := Form1.sAtual + '\XmlDestinatario\CFeSAT';
    ForceDirectories(sPathXMLSat);

    sCodigoFabricante    := Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CODIGO_FABRICANTE, sCodigoFabricante));
    sCodigoAtivacao      := Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CODIGO_ATIVACAO, sCodigoAtivacao));
    sAssinaturaAssociada := Trim(LerParametroIni(Form1.sArquivo, SECAO_59, _59_CHAVE_ASSINATURA_ASSOCIADA, sAssinaturaAssociada));

    IBQAMBIENTE := CriaIBQuery(FORM1.IBQuery65.Transaction);
    IBQAMBIENTE.Close;
    IBQAMBIENTE.SQL.Text :=
      'select first 1 REGISTRO ' +
      'from NFCE ' +
      'where NFEXML containing ''<tpAmb>1</tpAmb>'' ';
    IBQAMBIENTE.Open;

    if (Trim(IBQAMBIENTE.FieldByName('REGISTRO').AsString) <> '') then
    begin
      if ((Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_AMBIENTE, '')) <> _59_AMBIENTE_HOMOLOGACAO)
          and (Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_AMBIENTE, '')) <> _59_AMBIENTE_PRODUCAO)) then
        GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_AMBIENTE, _59_AMBIENTE_PRODUCAO);
    end;

    FreeAndNil(IBQAMBIENTE);

    Form1.Homologao1.Caption := AnsiUpperCase(Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_AMBIENTE, _59_AMBIENTE_PRODUCAO))); // Sandro Silva 2019-07-04 Form1.Homologao1.Caption := AnsiUpperCase(Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_AMBIENTE, _59_AMBIENTE_HOMOLOGACAO)));

    if Form1.bBalancaAutonoma = False then // Sandro Silva 2019-01-28
    begin

      if Trim(sCodigoFabricante) = '' then
        _ecf59_ConfiguraFabricanteModeloSAT(sCodigoFabricante);

      if Length(Trim(sCodigoFabricante)) = 2 then
      begin// Ajusta c�digo do fabricante, passou a ter 4 d�gitos para contemplar modelos diferente de sat do mesmo fabricante
        sCodigoFabricante := FormatFloat('00', StrToIntDef(Trim(sCodigoFabricante), 0)) + '01';
        GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CODIGO_FABRICANTE, sCodigoFabricante);
      end;

      if Trim(sCNPJSoftwareHouse) = '' then
      begin
        sCNPJSoftwareHouse := '07426598000124';
        GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CNPJ_SOFTWARE_HOUSE, sCNPJSoftwareHouse);
      end;

      if Trim(sCodigoAtivacao) = '' then
      begin
        if Form1.bBalancaAutonoma = False then // Sandro Silva 2019-01-23
        begin
          sCodigoAtivacao := Small_InputBox('C�digo de ativa��o', 'Informe o c�digo de ativa��o do ' + _59.TipoEquipamento + ':', sCodigoAtivacao); // Sandro Silva 2018-07-03  Small_InputBox('C�digo de ativa��o', 'Informe o c�digo de ativa��o do ' + NOME_CUPOM_59 + ':', sCodigoAtivacao);

          if Trim(sCodigoAtivacao) <> '' then
            GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CODIGO_ATIVACAO, sCodigoAtivacao);
        end;
      end;
    end;

    if (Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_VERSAO_DADOS_ENTRADA, '')) = '') or
      (Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_VERSAO_DADOS_ENTRADA, '')) = '0.06') then // Sandro Silva 2019-06-04 if Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_VERSAO_DADOS_ENTRADA, '')) = '' then
      GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_VERSAO_DADOS_ENTRADA, VDE_007);

    if Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_VERSAO_DADOS_ENTRADA, VDE_007)) = VDE_007 then
      Form1.VersoLeiauteSat0071.Checked := True;

    if Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_VERSAO_DADOS_ENTRADA, VDE_008)) = VDE_008 then
      Form1.VersoLeiauteSat0081.Checked := True;

    // Form1.IntegradorCE.DiretorioAtual := Form1.sAtual; // Sandro Silva 2018-07-03  _59.IntegradorMFE.DiretorioAtual := Form1.sAtual; // Sandro Silva 2017-05-20

    _59.DiretorioAtual        := Form1.sAtual;// Sandro Silva 2016-10-25
    _59.ModeloDocumento       := '59';
    _59.IBDATABASE            := Form1.ibQuery6.Database; // Form1.IBDatabase1;
    _59.CodigoAtivacao        := Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CODIGO_ATIVACAO, _59.CodigoAtivacao));
    _59.Fabricante            := Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CODIGO_FABRICANTE, ''));
    // Emulador e Gertec precisa declarar as chamadas das fun��es como CDELC
    // Op��o para configurar outros modelos
    if ((_59.FabricanteCodigo = FABRICANTE_EMULADOR) or (_59.FabricanteCodigo = FABRICANTE_GERTEC))
      and (Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_METODO_CHAMADA_DLL_ALTERNATIVO, '')) = '') then
      SalvarConfiguracao(FRENTE_INI, SECAO_59, _59_CHAVE_METODO_CHAMADA_DLL_ALTERNATIVO, 'Sim');

    _59.MetodoChamadaDLL      := mcStdCall;
    if Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_METODO_CHAMADA_DLL_ALTERNATIVO, 'N�o')) = 'Sim' then
      _59.MetodoChamadaDLL    := mcCdecl;

    _59.CaminhoInstalado  := Form1.sAtual; // Sandro Silva 2017-02-14

    if (_59.TipoEquipamento <> TIPO_EQUIPAMENTO_MFE) then // Sandro Silva 2017-05-24
    begin
      // Cear� utiliza Integrador Fiscal que permite gerenciamento de "n" PDV em um equipamento SAT

      try
        if AnsiUpperCase(LerParametroIni(FRENTE_INI, SECAO_59, CHAVE_MODO_OPERACAO, '')) = 'CLIENTE' then
        begin
          Form1.SATConectarServidorSAT1.Checked := True;// Sandro Silva 2017-03-03
          _59.ModoOperacao := moClient;
          _59.Caixa        := LerParametroIni(FRENTE_INI, SECAO_FRENTE_CAIXA, 'Caixa', '');
          if _59.Caixa = '' then
          begin
            _59.Caixa      := _ecf59_ConfiguraCaixaSAT(_59.Caixa, True); // Sandro Silva 2021-03-05 _59.Caixa      := _ecf59_ConfiguraCaixaSAT(_59.Caixa); // Sandro Silva 2017-02-22
            SalvarConfiguracao(FRENTE_INI, SECAO_FRENTE_CAIXA, 'Caixa', _59.Caixa);
          end;
        end;

      except

      end;
    end;

    if Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CAMINHO_DLL, '')) = '' then
    begin
      GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CAMINHO_DLL, _59.CaminhoSATDLL);
    end;
    _59.CaminhoSATDLL         := Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CAMINHO_DLL, _59.CaminhoSATDLL));
    _59.VersaoDadosEnt        := Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_VERSAO_DADOS_ENTRADA, VDE_007));
    _59.CNPJSoftwareHouse     := Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CNPJ_SOFTWARE_HOUSE, sCNPJSoftwareHouse));
    _59.AvancoPapel           := StrToIntDef(LerParametroIni('Frente.ini', SECAO_59, CHAVE_INI_AVANCO_PAPEL, '0'), 0); // Sandro Silva 2016-08-25

    if Form1.bBalancaAutonoma = False then // Sandro Silva 2019-01-23
    begin
      if Trim(_59.CodigoAtivacao) = '' then
      begin
        Application.MessageBox(PAnsiChar('Configure o c�digo de ativa��o do ' + _59.TipoEquipamento + ' no arquivo FRENTE.INI' + #13 + // Sandro Silva 2018-07-03  'Configure o c�digo de ativa��o do SAT no arquivo FRENTE.INI' + #13 +
                                     'e reinicie aplica��o' + #13 + #13 +
                                     'Essa aplica��o ser� fechada'),'Aten��o', MB_ICONWARNING + MB_OK);
        FecharAplicacao(ExtractFileName(Application.ExeName));
        Abort;
      end;

      if Trim(_59.CaminhoSATDLL) = '' then
      begin
        Application.MessageBox(PAnsiChar('Configure o caminho e nome da DLL de comunica��o com ' + _59.TipoEquipamento + ' no arquivo FRENTE.INI' + #13 + // Sandro Silva 2018-07-03  'Configure o caminho e nome da DLL de comunica��o com SAT no arquivo FRENTE.INI' + #13 +
                                     'e reinicie aplica��o' + #13 + #13 +
                                     'Essa aplica��o ser� fechada'),'Aten��o', MB_ICONWARNING + MB_OK);
        FecharAplicacao(ExtractFileName(Application.ExeName));
        Abort;
      end;

      if Trim(_59.Fabricante) = '' then
      begin
        Application.MessageBox(PAnsiChar('Configure o fabricante do equipamento ' + _59.TipoEquipamento + ' no arquivo FRENTE.INI' + #13 + // Sandro Silva 2018-07-03  'Configure o fabricante do equipamento SAT no arquivo FRENTE.INI' + #13 +
                                     'e reinicie aplica��o' + #13 + #13 +
                                     'Essa aplica��o ser� fechada'),'Aten��o', MB_ICONWARNING + MB_OK);
        FecharAplicacao(ExtractFileName(Application.ExeName));
        Abort;
      end;

    end;

    _59.ArquivoAssinatura := Form1.sArquivo; //2014-10-22

    if Form12 <> nil then
      FreeAndNil(Form12);
  end; // if _59 = nil then

  _59.TamanhoPapel := Form1.sTamanhoPapel; // Sandro Silva 2018-06-18  AnsiUpperCase(LerParametroIni(FRENTE_INI, SECAO_FRENTE_CAIXA, 'Papel Cupom', '')); // Sandro Silva 2018-06-15

  _59.Ambiente := AnsiUpperCase(Form1.Homologao1.Caption);

  if (_59.Ambiente = _59_AMBIENTE_HOMOLOGACAO) and (_ecf59_ValidaKitDesenvolvimento = False) then
  begin
    GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_AMBIENTE, _59_AMBIENTE_PRODUCAO);

    Form1.Homologao1.Caption := AnsiUpperCase(Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_AMBIENTE, _59_AMBIENTE_PRODUCAO)));
    Form1.Homologao1.Enabled := False;

    _59.Ambiente := AnsiUpperCase(Form1.Homologao1.Caption);
  end;

  if (_59.Ambiente = _59_AMBIENTE_PRODUCAO) and (_ecf59_ValidaKitDesenvolvimento) then
  begin
    GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_AMBIENTE, _59_AMBIENTE_HOMOLOGACAO);

    Form1.Homologao1.Caption := AnsiUpperCase(Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_AMBIENTE, _59_AMBIENTE_HOMOLOGACAO)));
    Form1.Homologao1.Enabled := False;

    _59.Ambiente := AnsiUpperCase(Form1.Homologao1.Caption);
  end;

  if (_59.TipoEquipamento = TIPO_EQUIPAMENTO_MFE) then
  begin

    _59.Caixa := LerParametroIni(FRENTE_INI, SECAO_FRENTE_CAIXA, 'Caixa', '');
    if _59.Caixa = '' then
    begin
      _59.Caixa  := _ecf59_ConfiguraCaixaSAT(_59.Caixa, True); // Sandro Silva 2021-03-05 _59.Caixa      := _ecf59_ConfiguraCaixaSAT(_59.Caixa); // Sandro Silva 2017-02-22
      SalvarConfiguracao(FRENTE_INI, SECAO_FRENTE_CAIXA, 'Caixa', _59.Caixa);
    end;

    if Form1.UsaIntegradorFiscal(Form1.ibDataSet13.FieldByName('ESTADO').AsString) then // Sandro Silva 2022-07-12
    begin
    
      if Trim(LerParametroIni(FRENTE_INI, SECAO_MFE, CHAVE_VENDA_NO_CARTAO, '')) = '' then
      begin

        if Form1.bBalancaAutonoma = False then // Sandro Silva 2019-01-23
        begin
          if QtdAdquirentes = 0 then
          begin

            Application.MessageBox(PansiChar('Configure os dados das adquirentes de cart�es'), 'Aten��o', MB_ICONWARNING + MB_OK);

            SalvarConfiguracao(FRENTE_INI, SECAO_MFE, CHAVE_VENDA_NO_CARTAO, 'N�o');

            if FCadAdquirentes = nil then
            begin
              Application.CreateForm(TFCadAdquirentes, FCadAdquirentes);
              FCadAdquirentes.ShowModal;
              FreeAndNil(FCadAdquirentes);
            end;

          end;
        end;

      end;

      if Form1.sUltimaAdquirenteUsada = '' then
        Form1.sUltimaAdquirenteUsada := AdquirentePadrao;

      {Sandro Silva 2022-07-11 inicio
      _59.Caixa := LerParametroIni(FRENTE_INI, SECAO_FRENTE_CAIXA, 'Caixa', '');
      if _59.Caixa = '' then
      begin
        _59.Caixa := _ecf59_ConfiguraCaixaSAT(_59.Caixa, True); // Sandro Silva 2021-03-05 _59.Caixa      := _ecf59_ConfiguraCaixaSAT(_59.Caixa); // Sandro Silva 2017-02-22
        SalvarConfiguracao(FRENTE_INI, SECAO_FRENTE_CAIXA, 'Caixa', _59.Caixa);
      end;
      }

      sChaveAcessoValidador := LerParametroIni(FRENTE_INI, SECAO_MFE, CHAVE_CHAVE_ACESSO_VALIDADOR, Form1.IntegradorCE.ChaveAcessoValidador); // Sandro Silva 2018-07-03  sChaveAcessoValidador := LerParametroIni(FRENTE_INI, SECAO_MFE, CHAVE_CHAVE_ACESSO_VALIDADOR, _59.IntegradorMFE.ChaveAcessoValidador); // '25CFE38D-3B92-46C0-91CA-CFF751A82D3D';
      if sChaveAcessoValidador = '' then
      begin
        if Form1.bBalancaAutonoma = False then // Sandro Silva 2019-01-23
        begin
          if ConfiguraChaveAcessoValidadorFiscal then // Sandro Silva 2018-07-03 if _ecf59_ConfiguraChaveAcessoValidadorFiscal then
            sChaveAcessoValidador := LerParametroIni(FRENTE_INI, SECAO_MFE, CHAVE_CHAVE_ACESSO_VALIDADOR, Form1.IntegradorCE.ChaveAcessoValidador); // Sandro Silva 2018-07-03 sChaveAcessoValidador := LerParametroIni(FRENTE_INI, SECAO_MFE, CHAVE_CHAVE_ACESSO_VALIDADOR, _59.IntegradorMFE.ChaveAcessoValidador); // '25CFE38D-3B92-46C0-91CA-CFF751A82D3D';
        end;
      end;
      Form1.IntegradorCE.codigoDeAtivacao     := _59.CodigoAtivacao;
      Form1.IntegradorCE.ChaveAcessoValidador := sChaveAcessoValidador;
      
    end; // if Form1.UsaIntegradorFiscal(Form1.ibDataSet13.FieldByName('ESTADO').AsString) then
    
  end;

  _59.MensagemPromocional := Form1.sMensagemPromocional;

  begin
    iTentativa := 1;
    if _59.FabricanteCodigo <> FABRICANTE_ELGIN then // Sandro Silva 2017-07-11  if _59.Fabricante <> FABRICANTE_ELGIN then
      iTentativaDLL := 2
    else
      iTentativaDLL := 1;
    while _59.ForcarComunicacaoComSat do // Sandro Silva 2019-02-27  while True do
    begin
      try
        if Form1.bBalancaAutonoma = False then // Sandro Silva 2019-01-23
        begin
          _59.Inicializa; // Sandro Silva 2019-01-28
          if _59.NumeroSerieSAT <> '' then
          begin
            _ecf59_ConsultaSat(False, False);
          end
          else
          begin
            if iTentativa > 1 then
            begin
              _59.SATConsultarStatusOperacional(Memo4);
            end
            else
            begin
              _59.SATConsultarStatusOperacional(Memo4);
            end;
          end;

          sNumeroSat := _59.NumeroSerieSAT;

        end
        else
        begin
          sNumeroSat := '00000000';
        end;


        if sNumeroSat = '' then
        begin
          _59.SATConsultarStatusOperacional(Memo4);
          sNumeroSat := _59.NumeroSerieSAT;
        end;

        {Sandro Silva 2021-03-03 inicio}
        if (sNumeroSat <> '') and (Form1.bBalancaAutonoma = False) then // Sandro Silva 2021-04-05 if (sNumeroSat <> '') then
        begin
          if LerParametroIni(FRENTE_INI, SECAO_59, 'Numero', '') = '' then
          begin
            GravarParametroIni(FRENTE_INI, SECAO_59, 'Numero', sNumeroSat);
          end;

          if sNumeroSat <> LerParametroIni(FRENTE_INI, SECAO_59, 'Numero', '') then
          begin

            {Sandro Silva 2021-03-05 inicio
            Application.MessageBox(PansiChar('O n�mero de s�rie do equipamento mudou' + #10 + #10 +
              'Configure um novo n�mero de caixa para identificar as vendas deste PDV' + #10 + #10 +
              'O n�mero do caixa n�o pode ter sido usado anteriormente'),'Aten��o', MB_ICONINFORMATION + MB_OK);


            GravarParametroIni(FRENTE_INI, SECAO_59, 'Numero', sNumeroSat);
            _59.Caixa      := _ecf59_ConfiguraCaixaSAT(_59.Caixa); // Sandro Silva 2017-02-22
            SalvarConfiguracao(FRENTE_INI, SECAO_FRENTE_CAIXA, 'Caixa', _59.Caixa);

            Application.MessageBox(PansiChar('Essa aplica��o ser� fechada' + #10 + #10 +
              'Reinicie a aplica��o para usar o novo n�mero do caixa configurado'),'Aten��o', MB_ICONINFORMATION + MB_OK);
            }
            Application.MessageBox(PansiChar('O n�mero de s�rie do equipamento mudou' + #10 + #10 +
              'Ser� configurado um novo n�mero de caixa para identificar as vendas deste PDV'),'Aten��o', MB_ICONINFORMATION + MB_OK);

            GravarParametroIni(FRENTE_INI, SECAO_59, 'Numero', sNumeroSat);
            _59.Caixa      := _ecf59_ConfiguraCaixaSAT(_59.Caixa, True); // Sandro Silva 2017-02-22
            _ecf59_CriaSequencialCaixa(_59.Caixa);
            SalvarConfiguracao(FRENTE_INI, SECAO_FRENTE_CAIXA, 'Caixa', _59.Caixa);

            Commitatudo(True);

            Application.MessageBox(PansiChar('Essa aplica��o ser� fechada' + #10 + #10 +
              'Reinicie a aplica��o para usar o novo n�mero do caixa configurado'),'Aten��o', MB_ICONINFORMATION + MB_OK);

            FecharAplicacao(ExtractFileName(Application.ExeName));

            Abort;

          end;
        end;
        {Sandro Silva 2021-03-03 fim}

        try
          if Trim(ConverteAcentos2(_59.MensagemSEFAZ)) <> '' then
          begin
            sStatusOperacional := sStatusOperacional + #13 + 'Mensagem da SEFAZ: ' + _59.MensagemSEFAZ;
            Application.MessageBox(PansiChar('Mensagem da SEFAZ:' + #13 + #13 + _59.MensagemSEFAZ), 'Informa��o', MB_ICONINFORMATION + MB_OK);
          end;

          if Form1.bBalancaAutonoma = False then // Sandro Silva 2019-01-23
          begin
            if (_59.RetornoStatusOperacional.EEEEE <> '10000') or _59.BloqueioAutonomo then
            begin
              if _59.ModoOperacao <> moServer then
                if Trim(sStatusOperacional) <> '' then
                  Application.MessageBox(PansiChar(sStatusOperacional),'Retorno Status Operacional', MB_ICONINFORMATION + MB_OK);
            end;

            if _59.BloqueioAutonomo then
              Application.MessageBox(PansiChar( 'Seu equipamento ' + _59.TipoEquipamento + ' est� sob BLOQUEIO AUT�NOMO, devido:' + #10 + // Sandro Silva 2018-07-03  'Seu equipamento SAT est� sob BLOQUEIO AUT�NOMO, devido:' + #10 +
                                           '- Falta de comunica��o com qualquer um dos Web services da SEFAZ;' + #10 +
                                           '- Presen�a de CF-e na mem�ria de trabalho do equipamento ' + _59.TipoEquipamento + ', emitido e n�o transmitido a mais tempo do que o valor em horas pr�-determinado;' + #10 +// Sandro Silva 2018-07-03  '- Presen�a de CF-e na mem�ria de trabalho do equipamento SAT-CF-e, emitido e n�o transmitido a mais tempo do que o valor em horas pr�-determinado;' + #10 +
                                           '- Vencimento do certificado digital do ' + _59.TipoEquipamento + ';'),'Retorno Status Operacional'// Sandro Silva 2018-07-03  '- Vencimento do certificado digital do SAT;'),'Retorno Status Operacional'
                                           , MB_ICONINFORMATION + MB_OK);
          end;
        except

        end;

        ConfiguraNFCE(True); //_ecf59_Inicializa()

        //Form1.EnviaroDANFCEporeMail1.Enabled := False;
        //Form1.IDTokenNFCE1.Visible := False;
        Form1.NmerodoTokenNFCE1.Visible                := False;
        Form1.ConfigurarDANFCE1.Visible                := False;
        Form1.InutilizaodeNFCes1.Visible               := False;
        Form1.NFCeemContingncia1.Visible               := False; // 2015-07-09
        Form1.NFCenoperodo1.Visible                    := True; // Sandro Silva 2018-06-04 False  // Sandro Silva 2018-04-11
        Form1.LarguradoPapel76mm1.Visible              := True; // Sandro Silva 2018-06-18
        Form1.LarguradoPapelA41.Visible                := True; // Sandro Silva 2018-06-18
        Form1.VincularAssinaturaAC1.Visible            := True; // Sandro Silva 2018-08-29
        Form1.VersoLeiauteSat0071.Visible              := True; // Sandro Silva 2019-05-14
        Form1.VersoLeiauteSat0081.Visible              := True; // Sandro Silva 2019-05-14

        // Sandro Silva 2018-09-03 Descomentar  Form1.FormatarIEdoemitentecom12dgitos1.Visible := True; // Sandro Silva 2018-09-03
        Form1.Selecionarcertificadodigital1.Visible    := False; // 2015-07-21
        Form1.InformaesdoresponsveltcnicoNFCe1.Visible := False; // Sandro Silva 2019-04-11

        if Trim(LerParametroIni(FRENTE_INI, 'NFCE', 'Certificado', '')) <> '' then
        begin
          if Trim(LerParametroIni(FRENTE_INI, 'NFCE', 'Contingencia', 'N�o')) = 'Sim' then
          begin // 2015-07-09 NFCe ativou conting�ncia
            Form1.NFCeemContingncia1.Visible := True;
            Form1.NFCeemContingncia1.Checked := True;
          end;
        end;

        Form1.NFCe1.Caption                                := NomeModeloDocumento('59'); // Sandro Silva 2020-08-24 Form1.NomeModeloDocumento('59');  // Sandro Silva 2018-07-03  NOME_CUPOM_59;
        if _59.TipoEquipamento = 'MFE' then {Sandro Silva 2018-07-03 inicio}
          Form1.NFCe1.Caption := _59.TipoEquipamento; // Sandro Silva 2018-07-03
        Form1.N11.Visible                                  := False;
        Form1.EspelhoMFD1.Visible                          := False;
        Form1.ConsultaStatusOperacionaldoSAT1.Visible      := True;
        Form1.ExtrairLogdoSAT1.Visible                     := True;
        Form1.SATInicializaoAlternativa1.Visible           := True;

        {Sandro Silva 2021-08-23 inicio}
        if Form1.UsaIntegradorFiscal() then
        begin
          if (Form1.ibDataSet13.FieldByName('ESTADO').AsString = 'CE') then
          begin
            Form1.DriverMFE010515ousuperior1.Visible := True;
          end;
          Form1.DriverMFE010515ousuperior1.Checked := _59.DriverMFE01_05_15_Superior;
        end;
        {Sandro Silva 2021-08-23 fim}

        if (_59.ModoOperacao <> moIntegradorMFE) then
        begin
          Form1.SATConectarServidorSAT1.Visible              := True; // Sandro Silva 2017-03-03
          Form1.SATCaminhodecomunicaocomServidorSAT1.Visible := True; // Sandro Silva 2017-03-03
        end
        else
        begin

          {Sandro Silva 2021-08-27 inicio}
          if (_59.DriverMFE01_05_15_Superior) then
          begin
            Form1.SATConectarServidorSAT1.Visible              := True; // Sandro Silva 2017-03-03
            Form1.SATCaminhodecomunicaocomServidorSAT1.Visible := True; // Sandro Silva 2017-03-03
          end;
          {Sandro Silva 2021-08-27 fim}

          Form1.IntegradorFiscal1.Visible := True;
          if _ecf59_Tipodaimpressora = 'MFE' then
          begin
            Form1.AdquirentesPOS1.Enabled      := True; // Sandro Silva 2017-05-19 (Form1.sTef <> 'Sim');
            Form1.AdquirentesPOS1.Visible      := True;
            Form1.N27.Visible                  := True;
          end;
        end;
        Form1.ConfigurarNmerodoCaixa1.Visible         := True; // Sandro Silva 2017-03-03
        Form1.ConfigurarFabricanteeModeloSAT1.Visible := True; // Sandro Silva 2017-07-12

        Form1.NFCenoperodo1.Caption                   := NomeModeloDocumento('59') + ' no per�odo...'; // Sandro Silva 2020-08-24 Form1.NomeModeloDocumento('59') + ' no per�odo...';  // Sandro Silva 2018-07-03  'CF-e-SAT no per�odo'; // Sandro Silva 2018-06-04
        Form1.ConsultarStatusdoServio1.Caption        := 'Consultar ' + _59.TipoEquipamento + '...'; // Sandro Silva 2018-07-03 'Consultar SAT...';
        Form1.GerenciadordeNFCe1.Caption              := 'Gerenciador de ' + NomeModeloDocumento('59'); // Sandro Silva 2020-08-24 'Gerenciador de ' + Form1.NomeModeloDocumento('59');  // Sandro Silva 2018-07-03 NOME_CUPOM_59;// 2014-04-02 'Gerenciador de S@T-CFe';
        Form1.ConfigurarlogotipodoDANFE1.Caption      := 'Configurar logotipo do Extrato do ' + NomeModeloDocumento('59') + '...'; // Sandro Silva 2020-08-24 'Configurar logotipo do Extrato do ' + Form1.NomeModeloDocumento('59') + '...';   // Sandro Silva 2018-07-03 'Configurar logotipo do Extrato do ' + NOME_CUPOM_59 + '...';
        Form1.DANFCEdetalhado1.Caption                := 'Imprimir Extrato ' + NomeModeloDocumento('59') + ' detalhado'; // Sandro Silva 2020-08-24 'Imprimir Extrato ' + Form1.NomeModeloDocumento('59') + ' detalhado';   // Sandro Silva 2018-07-03 'Imprimir Extrato ' + NOME_CUPOM_59 + ' detalhado';
        Form1.IDTokenNFCE1.Caption                    := 'C�digo de ativa��o do ' + _59.TipoEquipamento;// Sandro Silva 2018-07-03 'C�digo de ativa��o do SAT';  // 2014-04-02 'C�digo de ativa��o S@T-CFe';
        Form1.ImprimirDANFCE1.Caption                 := 'Imprimir o Extrato do ' + NomeModeloDocumento('59'); // Sandro Silva 2020-08-24 'Imprimir o Extrato do ' + Form1.NomeModeloDocumento('59');  // Sandro Silva 2018-07-03 'Imprimir o Extrato do ' + NOME_CUPOM_59;  // Sandro Silva 2017-09-05  + '...';
        Form1.ImprimeoDANFCE1.Caption                 := 'Imprimir o Extrato do ' + NomeModeloDocumento('59') + '...'; // Sandro Silva 2020-08-24 'Imprimir o Extrato do ' + Form1.NomeModeloDocumento('59') + '...';  // Sandro Silva 2018-07-03 'Imprimir o Extrato do ' + NOME_CUPOM_59 + '...';
        Form1.VisualizaroDANFCE1.Caption              := 'Visualizar o Extrato do ' + NomeModeloDocumento('59') + '...'; // Sandro Silva 2020-08-24 'Visualizar o Extrato do ' + Form1.NomeModeloDocumento('59') + '...';   // Sandro Silva 2018-07-03 'Visualizar o Extrato do ' + NOME_CUPOM_59 + '...';
        Form1.VisualizaroXMLdaNFCe1.Caption           := 'Visualizar o XML do '  + NomeModeloDocumento('59') + '...'; // Sandro Silva 2020-08-24 'Visualizar o XML do '  + Form1.NomeModeloDocumento('59') + '...';  // Sandro Silva 2018-07-03 'Visualizar o XML do '  + NOME_CUPOM_59 + '...';
        Form1.CancelaraNFCe1.Caption                  := 'Cancelar a ' + NomeModeloDocumento('59') + '...'; // Sandro Silva 2020-08-24 'Cancelar a ' + Form1.NomeModeloDocumento('59') + '...';  // Sandro Silva 2018-07-03 'Cancelar a ' + NOME_CUPOM_59 + '...';
        Form1.EnviaroDANFCEporeMail1.Caption          := 'Enviar o Extrato do ' + NomeModeloDocumento('59') + ' e XML por e-Mail...'; // Sandro Silva 2020-08-24 'Enviar o Extrato do ' + Form1.NomeModeloDocumento('59') + ' e XML por e-Mail...';  // Sandro Silva 2018-07-03 'Enviar o Extrato do ' + NOME_CUPOM_59 + ' e XML por e-Mail...';
        Form1.VisualizarDANFCE1.Caption               := 'Visualizar o ' + NomeModeloDocumento('59'); // Sandro Silva 2020-08-24 'Visualizar o ' + Form1.NomeModeloDocumento('59');  // Sandro Silva 2018-07-03 'Visualizar o Extrato CF-e-SAT';

        Form1.ConsultaStatusOperacionaldoSAT1.Caption := 'Consulta Status Operacional do ' + _59.TipoEquipamento + '...';
        Form1.ConfigurarFabricanteeModeloSAT1.Caption := 'Configurar Fabricante e Modelo do ' + _59.TipoEquipamento + '...';
        Form1.ExtrairLogdoSAT1.Caption                := 'Extrair Log do ' + _59.TipoEquipamento + '...';
        Form1.SATInicializaoAlternativa1.Caption      := 'Inicializa��o Alternativa do ' + _59.TipoEquipamento;
        Form1.VersodoleiautedoCFeSAT1.Caption         := 'Vers�o do Leiaute do ' + NomeModeloDocumento('59'); // Sandro Silva 2020-08-24 'Vers�o do Leiaute do ' + Form1.NomeModeloDocumento('59');

        Form1.VisualizarDANFCE1.Checked          := (LerParametroIni(FRENTE_INI, SECAO_59, 'Visualizar Extrato', 'N�o') = 'Sim');

        _59.VisualizarExtrato := Form1.VisualizarDANFCE1.Checked;

        //Form1.EnviaraNFCe1.
        //Form1.VisualizarDANFCE1.Visible      := False;
        //Form1.VisualizaroDANFCE1.Visible     := False;
        Form1.Versodolayout1.Visible         := False;
        Form1.EnviaraNFCe1.Visible           := False;
        Form1.EnviaroDANFCEporeMail1.Visible := True;
        {Sandro Silva 2014-01-28 final}
        Form1.VersodoManualdaNFCe1.Visible   := False; // Sandro Silva 2016-06-15
        // Ativar se necess�rio Form1.VersodoleiautedoCFeSAT1.Visible := True; // Sandro Silva 2016-06-15
        Form1.Fusohorario1.Visible           := False;
        Form1.LimiteparaIdentificarConsumidor1.Visible := False;
      except

      end;

      Result := False;

      if (sNumeroSat <> '') then
      begin
        Result := True;

        Break;
      end
      else
      begin
        Sleep(500);  // Sandro Silva 2017-05-23

        if (_59.FabricanteCodigo = FABRICANTE_ELGIN)
          and (_59.FabricanteModelo = FABRICANTE_ELGIN_LINKER_II)
          and (_59.FabricanteModelo = FABRICANTE_ELGIN_SMART)
          and (iTentativaDLL = 1) then
        begin
          // Elgin tem SAT Linker e Linker II. Por padr�o tenta usar dll do Linker. Se falhar usa dll do Linker II
          GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CAMINHO_DLL, 'DLLSAT\ELGIN\LinkerII\dllsat.dll');
          Break;
        end
        else
        begin
          case iTentativa of
            1:
              begin
                sMensagem := 'N�o foi poss�vel estabelecer comunica��o com o ' + _59.TipoEquipamento; // Sandro Silva 2018-07-03 'N�o foi poss�vel estabelecer comunica��o com o SAT';
                if Pos('ERRO DESCONHECIDO', AnsiUpperCase(_59.Retorno)) > 0 then
                  SmallMsg('Feche o ' + NOME_APLICATIVO_59 + #13 +
                              'Desligue e ligue novamente o equipamento ' + _59.TipoEquipamento + #13 + // Sandro Silva 2018-07-03  'Desligue e ligue novamente o equipamento SAT' + #13 +
                              'Aguarde at� que o ' + _59.TipoEquipamento + ' tenha completado sua inicializa��o' + #13 + // Sandro Silva 2018-07-03  'Aguarde at� que o SAT tenha completado sua inicializa��o' + #13 +
                              'Abra novamente o ' + NOME_APLICATIVO_59);

              end;
            2: sMensagem := 'Verifique se o ' + _59.TipoEquipamento + ' est� ligado'; // Sandro Silva 2018-07-03  'Verifique se o SAT est� ligado';
            3: sMensagem := 'Verifique se o ' + _59.TipoEquipamento + ' est� conectado ao computador'; // Sandro Silva 2018-07-03 'Verifique se o SAT est� conectado ao computador';
            4: sMensagem := 'Verifique se o ' + _59.TipoEquipamento + ' n�o est� sendo atualizado pela SEFAZ';// Sandro Silva 2018-07-03  'Verifique se o SAT n�o est� sendo atualizado pela SEFAZ';
          end;

          sMensagem := sMensagem + #10 + #13 + #10 + #13 + _59.StatusRetornoSAT(_59.Retorno) + #10 + #13 + #10 + #13 + 'Tentar novamente?';

          if Application.MessageBox(PansiChar(sMensagem), 'Aten��o', MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON1) = idNo then
          begin
            _59.ForcarComunicacaoComSat := False;
            Break;
          end;

          Inc(iTentativa);
          if iTentativa > 4 then
            iTentativa := 1;
        end;
        Inc(iTentativaDLL); // Sandro Silva 2017-03-07
      end;
      //
    end; // while True do
  end; // if Pp1 <> '' then
  //
  DecimalSeparator := ',';
  DateSeparator    := '/';
  //
end;
// ------------------------------ //
// Fecha o cupom que est� sendo   //
// emitido                        //
// ------------------------------ //
function _ecf59_FechaCupom(Pp1: Boolean): Boolean;
begin
  // -------------------- //
  // Fecha o cupom fiscal //
  // -------------------- //
  Result := True;
  //
end; 

// ------------------------------ //
// Formas de pagamento            //
// ------------------------------ //
function _ecf59_Pagamento(Pp1: Boolean): Boolean;
begin
  Result := _ecf59_FinalizaVendaSAT;

  try
    if (_59.CodigoRetornoSAT = '06003') or (_59.CodigoRetornoSAT = '06004') then
    begin
      // N�o conseguiu autorizar a venda porque a assinatura n�o est� vinculada no equipamento
      if _ecf59_AssociarAssinatura(_59.CodigoAtivacao, _59.Emitente.CNPJ, _59.AssinaturaAssociada) then
      begin
        Form1.ExibePanelMensagem('Assinatura Vinculada. Finalizando a venda');
        Result := _ecf59_FinalizaVendaSAT;
      end;
    end;
  except

  end;

end;

// ------------------------------ //
// Cancela o �ltimo item          //
// ------------------------------ //
function _ecf59_CancelaUltimoItem(Pp1: Boolean): Boolean;
begin
  Result := True;
end;

function _ecf59_CancelaUltimoCupom(Pp1: Boolean): Boolean;
begin
  Screen.Cursor := crHourGlass; // Sandro Silva 2017-02-14
  Result := _ecf59_CancelaCFeSat(Pp1);
  Screen.Cursor := crDefault; // Sandro Silva 2017-02-14 
end;

function _ecf59_SubTotal(Pp1: Boolean):Real;
begin
  //
  Form1.fTotal := Form1.SubTotalAlteraca(Form1.sModeloECF, Form1.icupom, Form1.sCaixa, Form1.fTotal); // Sandro Silva 2019-04-30 Form1.fTotal := Form1.SubTotalAlteraca;
  Result := Form1.fTotal;
  //
  // SmallMsg(FloatToStr(Form1.fTotal)+chr(10)+'Casas decimais: '+Form1.ConfPreco);
  //
end;


// ------------------------------ //
// Abre um novo copom fiscal      //
// ------------------------------ //
function _ecf59_AbreNovoCupom(Pp1: Boolean): Boolean;
begin
  Form1.bCupomAberto := _ecf59_CupomAberto(True); // Sandro Silva 2018-08-01 
  Result := True;
end;

// -------------------------------- //
// Retorna o n�mero do Cupom        //
// -------------------------------- //
function _ecf59_NumeroDoCupom(Pp1: Boolean):String;
var
  Mais1Ini : tIniFile;
begin
  //
  try
    //
    Mais1ini  := TIniFile.Create(FRENTE_INI);
    //

    if _ecf59_CupomAberto(True) then
      Pp1 := False;

    //
    if pP1 then
    begin
      _ecf59_CriaSequencialCaixa(Form1.sCaixa);
      while True do
      begin
        Result := FormataNumeroDoCupom(IncrementaGenerator(_59_PREFIXO_GENERATOR_CAIXA_SAT + Form1.sCaixa, 1)); // Sandro Silva 2021-12-01 Result := StrZero(IncrementaGenerator(_59_PREFIXO_GENERATOR_CAIXA_SAT + Form1.sCaixa, 1), 6, 0); // Sandro Silva 2021-03-05 Result := StrZero(IncrementaGenerator('G_NUMEROCFESAT_' + Form1.sCaixa, 1), 6, 0);
        Form1.ibQuery65.Close;
        Form1.ibQuery65.SQL.Text :=
          'select CAIXA, MODELO, REGISTRO, NUMERONF ' +
          'from NFCE ' +
          'where CAIXA = ' + QuotedStr(Form1.sCaixa) +
          ' and MODELO = ''59''' +
          ' and NUMERONF = ' + QuotedStr(Result);
        Form1.ibQuery65.Open;
        if Form1.ibQuery65.FieldByName('NUMERONF').AsString = '' then
        begin
          Break;
        end;
      end;

      //
      try
        //
        Form1.ibDataset150.Close;
        Form1.ibDataset150.SelectSql.Clear;
        Form1.ibDataset150.SelectSQL.Text :=
          'select * ' +
          'from NFCE ' +
          'where NUMERONF = ' + QuotedStr(FormataNumeroDoCupom(0)) + // Sandro Silva 2021-12-02 'where NUMERONF=''000000'' ' +
          ' and CAIXA = ' + QuotedStr(Form1.sCaixa) +
          ' and MODELO = ' + QuotedStr('59');
        Form1.ibDataset150.Open;
        //
        Form1.IBDataSet150.Append;
        Form1.IBDataSet150NUMERONF.AsString  := Result;
        Form1.IBDataSet150DATA.AsDateTime    := Date;
        Form1.IBDataSet150.FieldByName('CAIXA').AsString  := Form1.sCaixa;
        Form1.IBDataSet150.FieldByName('MODELO').AsString := '59';
        Form1.IBDataSet150.Post;
        //
        Mais1Ini.WriteString('NFCE','CUPOM',Result);

        //SmallMsg('Pr�ximo N�mero: ' + Result); // 2015-06-22
        //
      except end;
    end else
    begin
      //
      try
        Result := FormataNumeroDoCupom(StrToInt(Mais1Ini.ReadString('NFCE','CUPOM','000001'))); // Sandro Silva 2021-12-01 Result := StrZero(StrToInt(Mais1Ini.ReadString('NFCE','CUPOM','000001')),6,0);
      except
        Result := FormataNumeroDoCupom(0); // Sandro Silva 2021-12-02 Result := '000000';
      end;
      //
    end;
    //
    Mais1Ini.Free;
    //
  except
    //
    Result := '000001';
    //
  end;
  //
  if StrToIntDef(LimpaNumero(Result),0)=0 then
    Result := '000001';
  //

  try
    Result := FormataNumeroDoCupom(StrToIntDef(Result, 1)); // Sandro Silva 2021-12-01
  except
  end;

  {Sandro Silva 2014-06-11 inicio
  Garantir que Result n�o tenha quantidade de caract�res al�m da capacidade com campo onde ser� gravado}
  if Length(Result) > 6 then
    Result := Right(Result, 6);
  {Sandro Silva 2014-06-11 final}

end;

// ------------------------------ //
// Cancela um item N              //
// ------------------------------ //
function _ecf59_CancelaItemN(pP1, pP2 : String): Boolean;
begin
  //
  Result := True;
  //
end;

// -------------------------------- //
// Abre a gaveta                    //
// -------------------------------- //
function _ecf59_AbreGaveta(Pp1: Boolean): Boolean;
var
  FLocal : TextFile;
  Mais1ini : TiniFile;
begin
  // ------------- //
  // Abre a gaveta //
  // ------------- //

  if Pp1 then
  begin
    Mais1ini  := TIniFile.Create(FRENTE_INI);
    if Mais1Ini.ReadString('Frente de Caixa','Gaveta','0') <> '0' then
    begin
      Mais1ini  := TIniFile.Create(FRENTE_INI);
      try
        //
        if UpperCase(Mais1Ini.ReadString('Frente de Caixa','Porta','LPT1')) = 'LPT0' then
        begin
          AssignFile(FLocal,'GAVETA.TXT');
        end else
        begin
          try
            AssignFile(FLocal,Mais1Ini.ReadString('Frente de Caixa','Porta','LPT1'));
          except end;
        end;
        Rewrite(FLocal);                           // Abre para grava��o
        //
        // Para mudar a sequencia de caracteres para abrir a gaveta
        // editar o arquivo frente.ini com os seguintes valores:
        //
        // [Impressora Fiscal]
        // Abre Gaveta=027,118,140
        // Abre Gaveta=027,112,027
        //
        // Onde os valores entre as virgolas represent�o um chr.
        //
        try
           Writeln(FLocal,Chr(StrToInt(Copy(Mais1Ini.ReadString('Frente de Caixa','Abre Gaveta','027,118,140'),1,3)))
                        + Chr(StrToInt(Copy(Mais1Ini.ReadString('Frente de Caixa','Abre Gaveta','027,118,140'),5,3)))
                        + Chr(StrToInt(Copy(Mais1Ini.ReadString('Frente de Caixa','Abre Gaveta','027,118,140'),9,3))));
        except
          SmallMsg('Dados inv�lidos na chave "Abre Gaveta".')
        end;
        //
        CloseFile(FLocal);
        //
      except end;
      //
    end;
  end else
  begin
    Mais1ini  := TIniFile.Create(FRENTE_INI);
    if Mais1Ini.ReadString('Frente de Caixa','Gaveta','0') <> '0' then
    begin
      try
         Writeln(Form1.fCupom,Chr(StrToInt(Copy(Mais1Ini.ReadString('Frente de Caixa','Abre Gaveta','027,118,140'),1,3)))
                      + Chr(StrToInt(Copy(Mais1Ini.ReadString('Frente de Caixa','Abre Gaveta','027,118,140'),5,3)))
                      + Chr(StrToInt(Copy(Mais1Ini.ReadString('Frente de Caixa','Abre Gaveta','027,118,140'),9,3))));
      except SmallMsg('Dados inv�lidos na chave "Abre Gaveta".') end;
    end;
  end;
  Result := True;
end;

// -------------------------------- //
// Status da gaveta                 //
// -------------------------------- //
function _ecf59_StatusGaveta(Pp1: Boolean):String;
begin
  Result := '255';
end;

// -------------------------------- //
// SAngria                          //
// -------------------------------- //
function _ecf59_Sangria(Pp1: Real): Boolean;
begin
  Result := SangriaSuprimento(Pp1, 'Sangria');
end;

// -------------------------------- //
// Suprimento                       //
// -------------------------------- //
function _ecf59_Suprimento(Pp1: Real): Boolean;
begin
  Result := SangriaSuprimento(Pp1, 'Suprimento');
end;

// -------------------------------- //
// REducao Z                        //
// -------------------------------- //
function _ecf59_NovaAliquota(Pp1: String): Boolean;
begin
  Result := True;
end;

function _ecf59_LeituraDaMFD(pP1, pP2, pP3: String): Boolean;
begin
  SmallMsg('Fun��o n�o suportada pelo modelo de ECF utilizado.');
  Result := True;
end;

function _ecf59_LeituraMemoriaFiscal(pP1, pP2: String): Boolean;
begin
  SmallMsg('Fun��o n�o suportada pelo modelo de ECF utilizado.');
  Result := True;
end;

// -------------------------------- //
// Venda do Item                    //
// -------------------------------- //
function _ecf59_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String): Boolean;
begin
  // --------------------- //
  //  Retorno do Subtotal  //
  // --------------------- //
  if Form1.fTotal > 999999.98 then Form1.fTotal := 0;
  //
  // SmallMsg('Teste: ' + Form1.fTotal + '+'+ FloatToStr(TruncaDecimal((TruncaDecimal(Form1.ibDataSet4PRECO.AsFloat)) * (StrToInT(pP4)/1000)))+' = '+ FloatToStr(TruncaDecimal(Form1.fTotal) + TruncaDecimal((TruncaDecimal(Form1.ibDataSet4PRECO.AsFloat)  * (StrToInT(pP4)/1000)))));
  //
  Form1.fTotal := Form1.fTotal + TruncaDecimal((TruncaDecimal(Form1.ibDataSet27.FieldByName('TOTAL').AsFloat,Form1.iTrunca)),Form1.iTrunca);
  //
  // SmallMsg(FloatToStr(Form1.fTotal));
  Result := True;
  //
end;

// -------------------------------- //
// Reducao Z                        //
// -------------------------------- //
function _ecf59_ReducaoZ(pP1: Boolean): Boolean;
begin
  SmallMsg('Fun��o n�o suportada pelo modelo de ECF utilizado.');
  Result := True;
end;

// -------------------------------- //
// Leitura X                        //
// -------------------------------- //
function _ecf59_LeituraX(pP1: Boolean): Boolean;
begin
  SmallMsg('Fun��o n�o suportada pelo modelo de ECF utilizado.');
  Result := True;
end;

// ---------------------------------------------- //
// Retorna se o horario de ver�o est� selecionado //
// ---------------------------------------------- //
function _ecf59_RetornaVerao(pP1: Boolean): Boolean;
begin
  Result := False;
end;

// -------------------------------- //
// Liga ou desliga hor�rio de verao //
// -------------------------------- //
function _ecf59_LigaDesLigaVerao(pP1: Boolean): Boolean;
begin
  Result := True;
end;

// -------------------------------- //
// Retorna a vers�o do firmware     //
// -------------------------------- //
function _ecf59_VersodoFirmware(pP1: Boolean): String;
begin
  Result := 'SAT-CFe';
end;

// -------------------------------- //
// Retorna o n�mero de s�rie        //
// -------------------------------- //
function _ecf59_NmerodeSrie(pP1: Boolean): String;
begin
  Result := _59.NumeroSerieSAT;
end;

// -------------------------------- //
// Retorna o CGC e IE               //
// -------------------------------- //
function _ecf59_CGCIE(pP1: Boolean): String;
begin
  Result := Form1.ibDataSet13.FieldByname('CGC').AsString+Chr(10)+Form1.ibDataSet13.FieldByname('IE').AsString;
end;

// --------------------------------- //
// Retorna o n�mero de cancelamentos //
// --------------------------------- //
function _ecf59_Cancelamentos(pP1: Boolean): String;
begin
  Result := '0';
end;


// -------------------------------- //
// Retorna o valor de descontos     //
// -------------------------------- //
function _ecf59_Descontos(pP1: Boolean): String;
begin
  Result := '0';
end;

// -------------------------------- //
// Retorna o contados sequencial    //
// -------------------------------- //
function _ecf59_ContadorSeqencial(pP1: Boolean): String;
begin
  Result := '0';
end;

// -------------------------------- //
// Retorna o n�mero de opera��es    //
// n�o fiscais acumuladas           //
// -------------------------------- //
function _ecf59_Nmdeoperaesnofiscais(pP1: Boolean): String;
begin
  Result := '0';
end;

function _ecf59_NmdeCuponscancelados(pP1: Boolean): String;
begin
  Result := '0';
end;

function _ecf59_NmdeRedues(pP1: Boolean): String;
begin
  Result := '0';
end;

function _ecf59_Nmdeintervenestcnicas(pP1: Boolean): String;
begin
  Result := '0';
end;

function _ecf59_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
begin
  Result := '0';
end;

function _ecf59_Clichdoproprietrio(pP1: Boolean): String;
begin
  Result := Form1.ibDataSet13.FieldByname('NOME').AsString+Chr(10)+
            Form1.ibDataSet13.FieldByname('CGC').AsString+Chr(10)+
            AllTrim(Form1.ibDataSet2.FieldByname('ENDERE').AsString)+' '+AllTrim(Form1.ibDataSet2.FieldByname('COMPLE').AsString)+Chr(10)+
            Form1.ibDataSet13.FieldByname('CEP').AsString+Form1.ibDataSet13.FieldByname('CIDADE').AsString+' - '+Form1.ibDataSet13.FieldByname('ESTADO').AsString+Chr(10);
end;

// ------------------------------------ //
// Importante retornar apenas 3 d�gitos //
// Ex: 001                              //
// ------------------------------------ //
function _ecf59_NmdoCaixa(pP1: Boolean): String;
begin
  if (_59.ModoOperacao <> moClient) and (_59.ModoOperacao <> moIntegradorMFE) then // Sandro Silva 2018-04-05  if _59.ModoOperacao <> moClient then
  begin
    Result := Form1.GetNumeroCaixa('59', _ecf59_NmerodeSrie(True));
  end
  else
    Result := LerParametroIni(FRENTE_INI, SECAO_FRENTE_CAIXA, 'Caixa', '');
  _59.Caixa := Result;
end;

function _ecf59_Nmdaloja(pP1: Boolean): String;
begin
  Result := '059';
end;

function _ecf59_Moeda(pP1: Boolean): String;
begin
  Result := Copy(CurrencyString,1,1);
end;

function _ecf59_Dataehoradaimpressora(pP1: Boolean): String;
begin
  ShortDateFormat := 'dd/mm/yy';   {Bug 2001 free}
  Result := StrTran(StrTran(Copy(DateToStr(Date),1,8)+TimeToStr(Time),'/',''),':','');
  ShortDateFormat := 'dd/mm/yyyy';   {Bug 2001 free}
end;

function _ecf59_Datadaultimareduo(pP1: Boolean): String;
begin
  Result := '00/00/0000';
end;

function _ecf59_Datadomovimento(pP1: Boolean): String;
begin
  Result := '00/00/0000';
end;

function _ecf59_Tipodaimpressora(pP1: Boolean = False): String;
begin
  Result := 'SAT'; // Sandro Silva 2019-08-26 ER 02.06 UnoChapeco Result := 'SAT-CFe';
  if (Form1.ibDataSet13.FieldByName('ESTADO').AsString = 'CE') then
    Result := 'MFE';
end;

// Deve retornar uma String com:                                          //
// Os 2 primeiros d�gitos s�o o n�mero de aliquotas gravadas: Ex 16       //
// os p�ximos de 4 em 4 s�o as aliquotas Ex: 1800                         //
// Ex: 161800120005000000000000000000000000000000000000000000000000000000 //
function _ecf59_RetornaAliquotas(pP1: Boolean): String;
begin
  Result := Replicate('0',72);
end;

function _ecf59_Vincula(pP1: String): Boolean;
begin
  Result := False;
end;

function _ecf59_FlagsDeISS(pP1: Boolean): String;
begin
  Result := chr(0)+chr(0);
end;

function _ecf59_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
begin
  Result := True;
end;

function _ecf59_MudaMoeda(pP1: String): Boolean;
begin
  Result := True;
end;

function _ecf59_MostraDisplay(pP1: String): Boolean;
begin
  Result := True;
end;

function _ecf59_LeituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
begin
  Result := True;
end;

function _ecf59_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean;
begin
  _ecf59_ImpressaoNaoSujeitoaoICMS(sP1);
  Result := True;
end;

function _ecf59_ImpressaoNaoSujeitoaoICMS(sP1: String; bPDF: Boolean = False; LarguraPapel: Integer = 640): Boolean; // Sandro Silva 2018-11-20 function _ecf59_ImpressaoNaoSujeitoaoICMS(sP1: String; bPDF: Boolean = False): Boolean;
begin
  Result := Form1.ImpressaoNaoSujeitoaoICMS(sP1, bPDF, LarguraPapel);// Sandro Silva 2018-06-04 SAT e NFC-e usando mesma fun��o para impress�o gerencial
end;

function _ecf59_FechaCupom2(sP1: Boolean): Boolean;
begin
  Result := True;
end;

//                                      //
// Imprime cheque - Parametro � o valor //
//                                      //
function _ecf59_ImprimeCheque(rP1: Real; sP2: String): Boolean;
begin
  Result := False;
end;

function _ecf59_MapaResumo(sP1: Boolean): Boolean;
begin
  Result := True;
end;

function _ecf59_FormataTx(sP1: String): Integer;
begin
  Result := 0;
end;

function _ecf59_GrandeTotal(sP1: Boolean): String;
begin
  Result := Replicate('0',18);
end;

function _ecf59_TotalizadoresDasAliquotas(sP1: Boolean): String;
begin
  Result := Replicate('0',438);
end;

function _ecf59_CupomAberto(sP1: Boolean): boolean;
var
  Mais1Ini: TIniFile;
  sCupom  : String;
begin
  Result := False;// Sempre come�a como falso. Verdadeiro somente se encontrar pendente
  //
  Mais1ini  := TIniFile.Create(FRENTE_INI);

  //
  try
    sCupom := FormataNumeroDoCupom(StrToInt(Mais1Ini.ReadString('NFCE','CUPOM','000001'))); // Sandro Silva 2021-12-02 sCupom := StrZero(StrToInt(Mais1Ini.ReadString('NFCE','CUPOM','000001')),6,0);
  except
    sCupom := FormataNumeroDoCupom(0); // Sandro Silva 2021-12-02 sCupom := '000000';
  end;
  //
  Mais1Ini.Free;

  sCupom := FormataNumeroDoCupom(StrToInt(sCupom)); // Sandro Silva 2021-12-01

  //
  Form1.ibQuery65.Close;
  Form1.ibQuery65.SQL.Clear;
  Form1.ibQuery65.SQL.Text := 'select * from NFCE where NUMERONF='+QuotedStr(sCupom)+' and CAIXA = ' + QuotedStr(Form1.sCaixa) + ' and MODELO = 59 ';
  ///
  Form1.ibQuery65.Open;
  //
  //
  if Form1.ibQuery65.FieldByname('NUMERONF').AsString=sCupom then
  begin
    // Sandro Silva 2018-07-31 CF-e n�o autorizado
    if ((Pos('Id="CFe', Form1.ibQuery65.FieldByname('NFEXML').AsString) = 0) and (Pos('versaoSB=', Form1.ibQuery65.FieldByname('NFEXML').AsString) = 0))
      or (Pos(TIPOCONTINGENCIA, Form1.ClienteSmallMobile.sVendaImportando) > 0) // Sandro Silva 2016-04-19
    then
    begin
      if (Form1.ClienteSmallMobile.sVendaImportando = '') then
      begin
        Form1.icupom := StrToInt(sCupom);

        Result := True;
      end;

    end else
    begin
      Result := False;
    end;

  end else
  begin
    Result := False;
  end;
  //
  Form1.ibQuery65.Close;
  //
end;

function _ecf59_FaltaPagamento(sP1: Boolean): boolean;
begin
  Result := False;
end;

function _ecf59_FinalizaVendaSAT: Boolean;
{Sandro Silva 2013-01-30 inicio
Finaliza a venda por CF-e-SAT
N�o utilizando FechaCupom() por que quando essa fun��o � chamada ainda n�o foi digitado as formas de pagamento}
var
  sResposta: String;
  tInicio: TDate;
  sCFe: String;
  sPdfMobile: String;
  sVendedorNome: String;
  sNFCEDataOld: String;
  sDAV: String;
  sTIPODAV: String;
  sAlteracaPedidoOld: String;
  dtDataCupom: TDate;
  IBQPENDENCIA: TIBQuery; // Sandro Silva 2019-03-25
  iSleep: Integer;
  sLog: String; // Sandro Silva 2021-03-10
begin
  Result := False;
  tInicio := Now;

  Form1.ExibePanelMensagem('Aguarde, enviando ' + NomeModeloDocumento('59') + '...', True);

  Commitatudo2(False);

  try
    Form1.ibQuery65.Close;
    Form1.ibQuery65.SQL.Text :=
      'select A.PEDIDO, A.DATA ' +
      'from ALTERACA A ' +
      'where A.PEDIDO = ' + QuotedStr(FormataNumeroDoCupom(Form1.icupom)) + // Sandro Silva 2021-11-29 'where A.PEDIDO = ' + QuotedStr(StrZero(Form1.icupom,6,0)) +
      ' and A.CAIXA = ' + QuotedStr(Form1.sCaixa) +
      ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
      ' group by A.PEDIDO, A.DATA ' +
      ' order by DATA desc';
    Form1.ibQuery65.Open;

    dtDataCupom := Form1.ibQuery65.FieldByName('DATA').AsDateTime;

    Form1.ibQuery65.Close;
    Form1.ibQuery65.SQL.Text :=
      'select count(A.ITEM) as NUM_ITENS ' +
      'from ALTERACA A ' +
      'where A.PEDIDO = ' + QuotedStr(FormataNumeroDoCupom(Form1.icupom)) + // Sandro Silva 2021-11-29 'where A.PEDIDO = ' + QuotedStr(StrZero(Form1.icupom,6,0)) +
      ' and A.CAIXA = ' + QuotedStr(Form1.sCaixa) +
      ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
      ' and A.DESCRICAO <> ''Desconto'' ' +
      ' and A.DESCRICAO <> ''Acr�scimo'' ' +
      ' and A.DESCRICAO <> ''<CANCELADO>'' ';
    Form1.ibQuery65.Open;

    if Form1.ibQuery65.FieldByName('NUM_ITENS').AsInteger = 0 then
    begin
      if (Form1.ClienteSmallMobile.sVendaImportando = '') then
        SmallMsg('Nenhum item encontrado' + #13 + 'Cupom n�o pode ser fechado');
      Exit;
    end;

    Form1.ibDataSet27.Close;
    Form1.ibDataSet27.SelectSQL.Clear;
    Form1.ibDataSet27.SelectSQL.Add('select * from ALTERACA where CAIXA='+QuotedStr(Form1.sCaixa)+' and PEDIDO='+QuotedStr(FormataNumeroDoCupom(Form1.icupom))+' '); // Sandro Silva 2021-11-29 Form1.ibDataSet27.SelectSQL.Add('select * from ALTERACA where CAIXA='+QuotedStr(Form1.sCaixa)+' and PEDIDO='+QuotedStr(StrZero(Form1.icupom,6,0))+' ');
    Form1.ibDataSet27.Open;
    //
    Form1.ibDataSet27.First;

    sVendedorNome := Form1.ibDataSet27.FieldByName('VENDEDOR').AsString; // 2015-06-09

    sPdfMobile := '';
    if Form1.ClienteSmallMobile.ImportandoMobile then // Sandro Silva 2022-08-08 if ImportandoMobile then
      sPdfMobile := Form1.sAtual + '\mobile\' + StringReplace(Form1.ClienteSmallMobile.sVendaImportando, TIPOMOBILE, '', [rfReplaceAll]) + '.pdf';

    _ecf59_ConfiguraDadosEmitente;

    _59.ExtratoDetalhado  := Form1.DANFCEdetalhado1.Checked;
    _59.ImprimirExtrato   := Form1.ImprimirDANFCE1.Checked;
    _59.VisualizarExtrato := (LerParametroIni(FRENTE_INI, SECAO_59, 'Visualizar Extrato', 'N�o') = 'Sim');//Form1.VisualizarDANFCE1.Checked;
    _59.VersaoDadosEnt    := Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_VERSAO_DADOS_ENTRADA, VDE_007));
    _59.CNPJSoftwareHouse := Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CNPJ_SOFTWARE_HOUSE, ''));

    _59.IBDATASET27 := Form1.ibDataSet27; // 2016-01-19

    try

      _59.TributosFederais    := Form1.fTributos_federais;
      _59.TributosEstaduais   := Form1.fTributos_estaduais;
      _59.TributosMunicipais  := Form1.fTributos_municipais;
      _59.MensagemPromocional := Form1.sMensagemPromocional; // Sandro Silva 2016-06-14

      _59.XMLDadosVenda       := MontaXMLVenda(Form1.sCaixa, dtDataCupom, FormataNumeroDoCupom(Form1.icupom), sLog); // Sandro Silva 2021-03-11 _59.XMLDadosVenda       := MontaXMLVenda(Form1.sCaixa, dtDataCupom, StrZero(Form1.icupom,6,0); // Sandro Silva 2016-11-09

      if Trim(sLog) = '' then // Sandro Silva 2021-03-11
      begin
      
        if _59.ModoOperacao = moClient then
          Form1.ExibePanelMensagem(SAT_MENSAGEM_AGUARDANDO_RESPOSTA_DO_SERVIDOR + ' ' + _ecf59_Tipodaimpressora, True); // Sandro Silva 2017-02-24

        if _59.DriverMFE01_05_15_Superior = False then // Sandro Silva 2021-08-23
        begin
          if _59.ModoOperacao = moIntegradorMFE then
            Form1.ExibePanelMensagem('Aguardando resposta do Integrador Fiscal', True); // Sandro Silva 2017-02-24
        end;

        _59.SATEnviarDadosVenda(Memo4); // Envia o xml para o SAT

        if _59.ModoOperacao = moClient then
          Form1.ExibePanelMensagem('Processando resposta do Servidor ' + _ecf59_Tipodaimpressora, True); // Sandro Silva 2021-08-27 Form1.ExibePanelMensagem('Processando resposta do Servidor SAT'); // Sandro Silva 2017-02-24

        sResposta := _59.RetornoVenda.EEEEE;

        if _59.MensagemSEFAZ <> '' then
        begin
          Form1.ExibePanelMensagem('Aten��o! ' + _59.MensagemSEFAZ);
          Sleep(3000);
        end;
        
      end
      else
      begin
        _59.LogComando := sLog;
        sResposta := '';
      end; //

      if sResposta = '06000' then // '06000' Retorno de emitido com sucesso
      begin
        Result := True;

        if xmlNodeValue(_59.CFeXML, '//emit/cRegTrib') <> '' then
        begin
          if xmlNodeValue(_59.CFeXML, '//emit/cRegTrib') <> LimpaNumero(Form1.ibDataSet13.FieldByName('CRT').AsString) then
          begin

            for iSleep := 1 to 100 do
            begin
              Form1.ExibePanelMensagem('Aten��o! Ajuste o cadastro de emitente. CRT diferentes' + #13 +
                                      '- SEFAZ: ' + DescricaoCRT(xmlNodeValue(_59.CFeXML, '//emit/cRegTrib')) + #13 +
                                      '- Small: ' + DescricaoCRT(Form1.ibDataSet13.FieldByName('CRT').AsString)
                                      );
              Sleep(100);
            end;

          end;
        end;

        sCFe := FormataNumeroDoCupom(StrToIntDef(_59.nCFe, 0)); // Sandro Silva 2021-12-01 sCFe := _59.nCFe;

        if (_ecf59_Tipodaimpressora = 'MFE') then
        begin
          //Repassar idRespostaFiscal para todos as formasde pagto usadas
          EnviarRespostaFiscalValidadorFiscal(_59.CFeID); // Sandro Silva 2018-07-03 _ecf59_EnviarRespostaFiscalValidadorFiscal(_59.CFeID);
        end;

        try
          if Form1.ibDataSet25ACUMULADO3.AsFloat {Troco} > 0 then
          begin
            if Form1.ibDataSet25ACUMULADO2.AsFloat {Dinheiro} > Form1.ibDataSet25ACUMULADO3.AsFloat {Troco} then
            begin
              Form1.ibDataSet25ACUMULADO2.AsFloat {Dinheiro} := Form1.ibDataSet25ACUMULADO2.AsFloat {Dinheiro} - Form1.ibDataSet25ACUMULADO3.AsFloat {Troco};
            end else
            begin
              if Form1.ibDataSet25ACUMULADO1.AsFloat {Cheque} > Form1.ibDataSet25ACUMULADO3.AsFloat {Troco} then
              begin
                Form1.ibDataSet25ACUMULADO1.AsFloat {Cheque} := Form1.ibDataSet25ACUMULADO1.AsFloat {Cheque} - Form1.ibDataSet25ACUMULADO3.AsFloat {Troco};
              end;
            end;
          end;
        except

        end;

        Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible  := False;
        //
        try
          //
          Form1.ibQuery65.Close;
          Form1.ibQuery65.SQL.Text :=
            'select DATA from NFCE where NUMERONF = ' + QuotedStr(FormataNumeroDoCupom(Form1.iCupom)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa) + ' and MODELO = ' + QuotedStr('59'); // Sandro Silva 2021-11-29 'select DATA from NFCE where NUMERONF = ' + QuotedStr(StrZero(Form1.iCupom,6,0)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa) + ' and MODELO = ' + QuotedStr('59');
          Form1.ibQuery65.Open;

          sNFCEDataOld := Form1.ibQuery65.FieldByName('DATA').AsString;

          Form1.ibQuery65.Close;
          Form1.ibQuery65.SQL.Clear;
          Form1.ibQuery65.SQL.Add('delete from NFCE where NUMERONF = ' + QuotedStr(FormataNumeroDoCupom(Form1.iCupom)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa) + ' and MODELO = ' + QuotedStr('59')); // Sandro Silva 2021-11-29 Form1.ibQuery65.SQL.Add('delete from NFCE where NUMERONF = ' + QuotedStr(StrZero(Form1.iCupom,6,0)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa) + ' and MODELO = ' + QuotedStr('59'));
          Form1.ibQuery65.ExecSQL;

          //
          Form1.ibDataset150.Close;
          Form1.ibDataset150.SelectSql.Clear;
          Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF=' + QuotedStr(FormataNumeroDoCupom(0)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa)); // Sandro Silva 2021-12-02 Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF=''000000'' and CAIXA = ' + QuotedStr(Form1.sCaixa));
          Form1.ibDataset150.Open;
          //
          Form1.IBDataSet150.Append;
          Form1.IBDataSet150.FieldByName('NFEID').AsString    := _59.CFeID;// sID;
          Form1.IBDataSet150.FieldByName('NFEXML').AsString   := _59.CFeXML; // fNFe;
          Form1.IBDataSet150.FieldByName('STATUS').AsString   := Trim(Copy(_59.CFeStatus, 1, Form1.IBDataSet150.FieldByName('STATUS').Size));
          Form1.IBDataSet150.FieldByName('NUMERONF').AsString := sCFe; //StrZero(Form1.iCupom,6,0);
          Form1.IBDataSet150.FieldByName('DATA').AsDateTime   := _59.CFedEmi;
          Form1.IBDataSet150.FieldByName('CAIXA').AsString    := Form1.sCaixa;
          Form1.IBDataSet150.FieldByName('MODELO').AsString   := '59';
          if xmlNodeValue(_59.CFeXML, '//vCFe') <> '' then
            Form1.IBDataSet150.FieldByName('TOTAL').AsFloat    := xmlNodeValueToFloat(_59.CFeXML, '//vCFe'); // Ficha 4302 Sandro Silva 2018-12-05
          Form1.IBDataSet150.Post;

          //
          Form1.ibDataset150.Close;

          //Seleciona novamente o itens para alterar o n�mero do pedido para o n�mero do CFe
          Form1.ibDataSet27.Close;
          Form1.ibDataSet27.SelectSQL.Text :=
            'select * from ALTERACA where CAIXA='+QuotedStr(Form1.sCaixa)+' and PEDIDO='+QuotedStr(FormataNumeroDoCupom(Form1.icupom)) + // Sandro Silva 2021-11-29 'select * from ALTERACA where CAIXA='+QuotedStr(Form1.sCaixa)+' and PEDIDO='+QuotedStr(StrZero(Form1.icupom,6,0)) +
            ' and COO is null'; // Apenas os itens da venda atual. Para separar de vendas anteriores com mesmo n�mero do caixa
          Form1.ibDataSet27.Open;

          sDAV     := '';
          sTIPODAV := '';
          sAlteracaPedidoOld := Form1.ibDataSet27.FieldByName('PEDIDO').AsString;

          if Form1.sOrcame <> '' then
          begin
            sDAV     := Form1.sOrcame;
            sTIPODAV := 'OR�AMENTO';
          end;

          if Form1.sOs <> '' then
          begin
            sDAV     := Form1.sOs;
            sTIPODAV := 'OS';
          end;

          IBQPENDENCIA := CriaIBQuery(Form1.ibDataSet27.Transaction);
          try
            IBQPENDENCIA.Close;
            IBQPENDENCIA.SQL.Text :=
              'update PENDENCIA set ' +
              'PEDIDO = ' + QuotedStr(Right(sCFe, 6)) +
              ' where PEDIDO = ' + QuotedStr(sAlteracaPedidoOld) +
              ' and CAIXA = ' + QuotedStr(Form1.sCaixa);
            IBQPENDENCIA.ExecSQL;
          except

          end;
          FreeAndNil(IBQPENDENCIA);

          while Form1.ibDataSet27.Eof = False do
          begin

            if (sDAV = '')
              and (Form1.ibDataSet27.FieldByName('DAV').AsString <> '')
              and (Form1.ibDataSet27.FieldByName('TIPODAV').AsString <> '') then
            begin
              // Identifica o primeiro DAV que encontrar nos itens da venda
              sDAV     := Form1.ibDataSet27.FieldByName('DAV').AsString;
              sTIPODAV := Form1.ibDataSet27.FieldByName('TIPODAV').AsString;
            end;

            if (Form1.ibDataSet27.FieldByName('CAIXA').AsString = Form1.sCaixa)
              and (Form1.ibDataSet27.FieldByName('PEDIDO').AsString = FormataNumeroDoCupom(Form1.icupom)) then // Sandro Silva 2021-11-29 and (Form1.ibDataSet27.FieldByName('PEDIDO').AsString = StrZero(Form1.icupom,6,0)) then
            begin
              //
              // NFC-e n�o grava COO e CCF para os descontos e acr�scimos
              //
              if (Form1.ibDataSet27.FieldByName('COO').AsString = '') and (Form1.ibDataSet27.FieldByName('CCF').AsString = '') then // N�o atualizar n�mero do CF-e em vendas antigas de ECF
              begin

                try
                  // Produtos com controle de n�mero de s�rie
                    if (Form1.ibDataSet27.FieldByName('CODIGO').AsString <> '') and
                      ((Form1.ibDataSet27.FieldByName('TIPO').AsString = 'BALCAO') or (Form1.ibDataSet27.FieldByName('TIPO').AsString = 'LOKED')) then
                    begin
                      // Seleciona o produto na tabela SERIE, com a data e o n�mero tempor�rio da venda, para atualizar com a data e o n�mero do CF-e gerados pelo SAT
                      Form1.ibDataSet30.Close;
                      Form1.ibDataSet30.SelectSQL.Clear;
                      Form1.ibDataSet30.Selectsql.Add('select * from SERIE where CODIGO='+QuotedStr(Form1.ibDataSet27.FieldByName('CODIGO').AsString) + ' and NFVENDA = ' + QuotedStr(FormataNumeroDoCupom(Form1.icupom)) + ' and DATVENDA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form1.ibDataSet27.FieldByName('DATA').AsDateTime))); // Sandro Silva 2021-11-29 Form1.ibDataSet30.Selectsql.Add('select * from SERIE where CODIGO='+QuotedStr(Form1.ibDataSet27.FieldByName('CODIGO').AsString) + ' and NFVENDA = ' + QuotedStr(StrZero(Form1.icupom,6,0)) + ' and DATVENDA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form1.ibDataSet27.FieldByName('DATA').AsDateTime)));
                      Form1.ibDataSet30.Open;

                      while Form1.ibDataSet30.Eof = False do
                      begin
                        if (Form1.ibDataSet30.FieldByName('CODIGO').AsString <> '') and (Form1.ibDataSet30.FieldByName('CODIGO').AsString = Form1.ibDataSet27.FieldByName('CODIGO').AsString) then
                        begin
                          Form1.ibDataset30.Edit;
                          Form1.ibDataset30.FieldByName('NFVENDA').AsString  := Right(sCFe, 6);
                          //
                          try
                            Form1.ibDataset30.FieldByName('VALVENDA').AsFloat  := Form1.ibDataSet27.FieldByName('UNITARIO').AsFloat;
                            Form1.ibDataset30.FieldByName('DATVENDA').AsFloat  := _59.CFedEmi;
                            Form1.ibDataset30.Post; // Sandro Silva 2018-12-07
                          except end;
                        end;
                        Form1.ibDataSet30.Next;
                      end;
                    end;
                except

                end;

                try
                  Form1.ibDataSet27.Edit;
                  Form1.ibDataSet27.FieldByName('PEDIDO').AsString := sCFe;
                  Form1.ibDataSet27.FieldByName('COO').AsString    := sCFe;
                  Form1.ibDataSet27.FieldByName('CCF').AsString    := sCFe;
                  //Atualiza dados do cliente
                  if (Form1.sConveniado <> '') then
                  begin
                    if (Form1.sConveniado = Form1.IBDataSet2.FieldByName('NOME').AsString) then
                    begin
                      Form1.ibDataSet27.FieldByName('CLIFOR').AsString := Form1.sConveniado;
                      Form1.ibDataSet27.FieldByName('CNPJ').AsString   := Form1.IBDataSet2.FieldByName('CGC').AsString;
                    end;
                  end
                  else
                  begin
                    Form1.ibDataSet27.FieldByName('CLIFOR').AsString := '';
                    Form1.ibDataSet27.FieldByName('CNPJ').AsString   := '';
                  end;

                  // Sandro Silva 2015-03-30 Mantem ALTERACA.DATA = NFCE.DATA
                  if Form1.ibDataSet27.FieldByName('DATA').AsDateTime <> Form1.IBDataSet150.FieldByName('DATA').AsDateTime then
                  begin
                     Form1.ibDataSet27.FieldByName('DATA').AsDateTime := _59.CFedEmi;
                     Form1.ibDataSet27.FieldByName('HORA').AsString   := _59.CFehEmi;
                  end;
                  Form1.ibDataSet27.Post;
                except
                end;

              end; // if (Form1.ibDataSet27.FieldByName('DATA').AsDateTime >= StrToDate(sNFCEDataOld))

            end; // if (Form1.ibDataSet27.FieldByName('CAIXA').AsString = Form1.sCaixa)

            Form1.ibDataSet27.Next;
          end; // while

          AtualizaDetalhe(Form1.ibDataSet27.Transaction, sTIPODAV, sDAV, Form1.sCaixa, Form1.sCaixa, sCFe, 'Fechada');

          // Seleciona novamente os dados para usar na sequ�ncia da venda
          Form1.ibDataSet27.Close;
          Form1.ibDataSet27.SelectSQL.Text :=
            'select * from ALTERACA where CAIXA='+QuotedStr(Form1.sCaixa)+' and PEDIDO='+QuotedStr(FormataNumeroDoCupom(StrToInt(sCFe))); // Sandro Silva 2021-12-01 'select * from ALTERACA where CAIXA='+QuotedStr(Form1.sCaixa)+' and PEDIDO='+QuotedStr(StrZero(StrToInt(sCFe),6,0));
          Form1.ibDataSet27.Open;
          Form1.ibDataSet27.Last;

          //Pagament
          Form1.ibDataSet28.First;
          while Form1.ibDataSet28.Eof = False do
          begin
            if (Form1.ibDataSet28.FieldByName('CAIXA').AsString = Form1.sCaixa)
              and (Form1.ibDataSet28.FieldByName('PEDIDO').AsString = FormataNumeroDoCupom(Form1.icupom)) then // Sandro Silva 2021-11-29 and (Form1.ibDataSet28.FieldByName('PEDIDO').AsString = StrZero(Form1.icupom,6,0)) then
            begin
              try // Sandro Silva 2018-12-07 Evitar erro quando atualiza dados
                Form1.ibDataSet28.Edit;
                Form1.ibDataSet28.FieldByName('PEDIDO').AsString := sCFe;
                Form1.ibDataSet28.FieldByName('DATA').AsDateTime := _59.CFedEmi; // Sandro Silva 2016-04-27
                Form1.ibDataSet28.FieldByName('HORA').AsString   := _59.CFehEmi; // Sandro Silva 2018-11-30
                Form1.ibDataSet28.Post;
              except
              end;
            end;
            Form1.ibDataSet28.Next;
          end;

          // Receber
          Form1.ibDataSet7.First;
          while Form1.ibDataSet7.Eof = False do
          begin
            if (Form1.ibDataSet7.FieldByName('NUMERONF').AsString = FormataNumeroDoCupom(Form1.icupom)+Copy(Form1.sCaixa, 1, 3)) then // Sandro Silva 2021-11-29 if (Form1.ibDataSet7.FieldByName('NUMERONF').AsString = StrZero(Form1.icupom,6,0)+Copy(Form1.sCaixa, 1, 3)) then
            begin
              try // Sandro Silva 2018-12-07 Evitar erro quando atualiza dados
                Form1.ibDataSet7.Edit;
                Form1.ibDataSet7.FieldByName('NUMERONF').AsString  := FormataNumeroDoCupom(StrToInt(sCFe)) + Copy(Form1.sCaixa, 1, 3); // Sandro Silva 2021-11-29 Form1.ibDataSet7.FieldByName('NUMERONF').AsString  := StrZero(StrToInt(sCFe), 6, 0) + Copy(Form1.sCaixa, 1, 3);
                Form1.ibDataSet7.FieldByName('HISTORICO').AsString := StringReplace(Form1.ibDataSet7.FieldByName('HISTORICO').AsString, FormataNumeroDoCupom(Form1.icupom), FormataNumeroDoCupom(StrToInt(sCFe)), [rfReplaceAll]); // Sandro Silva 2021-11-29 Form1.ibDataSet7.FieldByName('HISTORICO').AsString := StringReplace(Form1.ibDataSet7.FieldByName('HISTORICO').AsString, StrZero(Form1.icupom,5,0), StrZero(StrToInt(sCFe),5,0), [rfReplaceAll]);
                Form1.ibDataSet7.FieldByName('DOCUMENTO').AsString := Form1.sCaixa + FormataNumeroDoCupom(StrToInt(sCFe)) + RightStr(Form1.ibDataSet7.FieldByName('DOCUMENTO').AsString, 1); // Sandro Silva 2021-11-29 Form1.ibDataSet7.FieldByName('DOCUMENTO').AsString := Form1.sCaixa + StrZero(StrToInt(sCFe),6,0) + RightStr(Form1.ibDataSet7.FieldByName('DOCUMENTO').AsString, 1);
                Form1.ibDataSet7.FieldByName('EMISSAO').AsDateTime := _59.CFedEmi; // Sandro Silva 2016-04-27
                Form1.ibDataSet7.Post;
              except
              end;
            end;
            Form1.ibDataSet7.Next;
          end;

          // Por �ltimo atualiza a vari�vel com o n�mero do cupom SAT
          Form1.icupom := StrToInt(sCFe);
          Form1.iGNF   := StrToInt(sCFe);

          //
        except end;
        //
        Form1.Label_7.Hint := 'Tempo de envio e impress�o: '+' '+FormatDateTime('HH:nn:ss', Now - TInicio)+' ';

        // 2015-07-09 if Form1.bImportando = False then
        if (Form1.ClienteSmallMobile.sVendaImportando = '') then
        begin
          if _59.VisualizarExtrato then
            _ecf59_Visualiza_DANFECE(sCFe, _59.CFeXML);

          // N�o retornar False se n�o imprimir ou enviar o email
          // False apenas se n�o conseguir gerar CF-e-SAT
          if _59.ImprimirExtrato then
            _ecf59_Imprime_DANFECE(sCFe, _59.CFeXML);

          if Form1.EnviaremailcomXMLePDFacadavenda1.Checked then // Ficha 4736 Sandro Silva 2019-08-02
            _ecf59_Email_DANFECE(sCFe, _59.CFeXML);

          {Sandro Silva 2022-02-10 inicio}
          if Form1.PosElginPay.Transacao.ImprimirComprovanteVenda then
            Form1.PosElginPay.ImpressaoComprovanteVenda(_59.CFeXML);
          {Sandro Silva 2022-02-10 fim}


        end
        else
        begin  // Importando MOBILE

          if Form1.ClienteSmallMobile.ImportandoMobile then // Sandro Silva 2022-08-08 if ImportandoMobile then
          begin
            //Primeiro envia extrato cf-e para mobile
            try
              if DirectoryExists(Form1.sAtual + '\mobile') = False then
                ForceDirectories(Form1.sAtual + '\mobile');

              if sPdfMobile <> '' then
              begin
                _59.ImprimirCupomDinamico(_59.CFeXML, toImage, _59.Ambiente, sPdfMobile);
                Sleep(1000);
                if FileExists(sPdfMobile) then
                begin
                  // upload pdf
                  // Sandro Silva 2022-08-08 UploadMobile(
                  Form1.ClienteSmallMobile.UploadMobile(sPdfMobile);
                  // Ap�s upload exclui o arquivo
                  DeleteFile(sPdfMobile);
                end;
              end;
            except
              on E: Exception do
              begin
                //sLogErro := E.Message;
              end;
            end;

            try
              if Form1.ImprimirDANFCE1.Checked then
                _ecf59_Imprime_DANFECE(sCFe, _59.CFeXML);
            except
            end;

            if Form1.EnviaremailcomXMLePDFacadavenda1.Checked then // Ficha 4736 Sandro Silva 2019-08-02
              _ecf59_Email_DANFECE(sCFe, _59.CFeXML);
              
          end
          else
          begin
            Form1.ibDataSet2.Close;
            Form1.ibDataSet2.SelectSQL.Clear;
            Form1.ibDataSet2.SelectSQL.Add('select * from CLIFOR where NOME='+QuotedStr(Form1.ibDataSet27.FieldByName('CLIFOR').AsString)+' and trim(coalesce(NOME,'''')) <> '''' ');
            Form1.ibDataSet2.Open;

            if ((Form1.ibDataSet27.FieldByName('CLIFOR').AsString = Form1.ibDataSet2.FieldByName('NOME').AsString) and (Alltrim(Form1.ibDataSet27.FieldByName('CLIFOR').AsString)<>''))
              or (Form2.Edit10.Text <> '') then
            begin
              if ((Form1.ibDataSet27.FieldByName('CLIFOR').AsString = Form1.ibDataSet2.FieldByName('NOME').AsString) and (Alltrim(Form1.ibDataSet27.FieldByName('CLIFOR').AsString)<>'')) then
                Form2.Edit10.Text := Form1.ibDataSet2.FieldByName('EMAIL').AsString;

              if Form1.EnviaremailcomXMLePDFacadavenda1.Checked then // Ficha 4736 Sandro Silva 2019-08-02
                _ecf59_Email_DANFECE(sCFe, _59.CFeXML);
                
            end;
          end; // n�o � conting�ncia if Pos(TIPOCONTINGENCIA, Form1.ClienteSmallMobile.sVendaImportando) = 0 then
        end;

        IncrementaGenerator(_59_PREFIXO_GENERATOR_CAIXA_SAT + Form1.sCaixa, 1); // Sandro Silva 2021-03-05 IncrementaGenerator('G_NUMEROCFESAT_' + Form1.sCaixa, 1); // 2015-07-21

      end
      else
      begin

        // Ocorreu erro na emiss�o do CF-e-SAT

        if Form1.Panel3.Visible then
          Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible := False;

        try
          //
          // Seleciona o �ltimo registro com o NUMERONF = iCupom
          Form1.ibDataset150.Close;
          Form1.ibDataset150.SelectSql.Clear;
          Form1.ibDataset150.SelectSQL.Add('select first 1 * from NFCE where coalesce(NFEID, '''') = '''' and NUMERONF='+QuotedStr(FormataNumeroDoCupom(Form1.iCupom)) + ' order by REGISTRO desc'); // Sandro Silva 2021-11-29 Form1.ibDataset150.SelectSQL.Add('select first 1 * from NFCE where coalesce(NFEID, '''') = '''' and NUMERONF='+QuotedStr(StrZero(Form1.iCupom,6,0)) + ' order by REGISTRO desc');
          Form1.ibDataset150.Open;

          // Salva o XML para poder analisar os dados lan�ados
          Form1.IBDataSet150.Edit;
          Form1.IBDataSet150.FieldByName('NFEXML').AsString := _59.XMLDadosVenda; // Sandro Silva 2021-11-17 Form1.IBDataSet150.FieldByName('NFEXML').AsString := _59.CfeXML;
          Form1.IBDataSet150.FieldByName('CAIXA').AsString  := Form1.sCaixa;
          Form1.IBDataSet150.FieldByName('MODELO').AsString := '59';
          Form1.IBDataSet150.FieldByName('STATUS').AsString := Copy(_59.CFeStatus + ' ' + Trim(sLog), 1, Form1.IBDataSet150.FieldByName('STATUS').Size); // Sandro Silva 2021-11-17 Form1.IBDataSet150.FieldByName('STATUS').AsString := Copy(_59.CFeStatus, 1, Form1.IBDataSet150.FieldByName('STATUS').Size);
          Form1.IBDataSet150.Post;
          //
          Form1.ibDataset150.Close;
        except

        end;

        if (Form1.ClienteSmallMobile.sVendaImportando = '') then
        begin

          if (_59.LogComando <> '') then
          begin
            Application.MessageBox(PansiChar(_59.LogComando), 'Aten��o', MB_ICONWARNING + MB_OK);
          end;

        end
        else
        begin

          Form1.Visible := True;

          Form1.WindowState := wsMaximized;
          FlashWindow(Application.Handle, true);
          Sleep(500);
          FlashWindow(Application.Handle, true);
          Sleep(500);
          FlashWindow(Application.Handle, true);
          Sleep(500);
          FlashWindow(Application.Handle, true);

          Form1.SetIconSysTrayIcone('small2.ico');

          GravarParametroIni(FRENTE_INI, 'NFCE', 'CUPOM', FormataNumeroDoCupom(0)); // Sandro Silva 2021-12-02 GravarParametroIni(FRENTE_INI, 'NFCE', 'CUPOM', '000000');

          if DirectoryExists(Form1.sAtual + '\mobile') = False then
            ForceDirectories(Form1.sAtual + '\mobile');

          if Form1.ClienteSmallMobile.ImportandoMobile then // Sandro Silva 2022-08-08 if ImportandoMobile then
          begin
            Form1.ClienteSmallMobile.LogRetornoMobile(_59.LogComando); // Sandro Silva 2022-08-08 LogRetornoMobile(_59.LogComando); // No processamento da fila de vendas mobile ser� retornado para o smallmobile o log
          end;

        end; // if Form1.bImportandoMobile = False then

      end; // if sResposta = '06000' then // '06000' Retorno de emitido com sucesso

    except

    end;

  finally
    //FreeAndNil(RetornoVenda); // 2015-07-09
  end;

  ChDir(Form1.sAtual); // Sandro Silva 2017-03-31
end;

function _ecf59_CancelaCFeSat(Pp1: Boolean): Boolean;
var
  sResposta: String;
  sCaixaOld: String;
begin
  //
  sResposta := '';
  Result := False;

  sCaixaOld := _59.Caixa;

  _ecf59_ConfiguraDadosEmitente; // Sandro Silva 2017-02-10

  _59.ExtratoDetalhado  := Form1.DANFCEdetalhado1.Checked;
  _59.ImprimirExtrato   := Form1.ImprimirDANFCE1.Checked;
  _59.VisualizarExtrato := (LerParametroIni(FRENTE_INI, SECAO_59, 'Visualizar Extrato','N�o') = 'Sim');// Sandro Silva 2017-02-10  _59.VisualizarExtrato := Form1.VisualizarDANFCE1.Checked;
  _59.VersaoDadosEnt    := Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_VERSAO_DADOS_ENTRADA, VDE_007));
  _59.CNPJSoftwareHouse := Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CNPJ_SOFTWARE_HOUSE, ''));

  //
  try
    //
    Form1.ibDataset150.Close;
    Form1.ibDataset150.SelectSql.Clear;
    Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF='+QuotedStr(FormataNumeroDoCupom(Form1.iCupom)) // Sandro Silva 2021-11-29 Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF='+QuotedStr(StrZero(Form1.iCupom,6,0))
    + ' and MODELO = ' + QuotedStr(_59.ModeloDocumento)
    + ' and CAIXA = ' + QuotedStr(Form1.sCaixa)
    + ' and substring(NFEID from 23 for 9) = ' + QuotedStr(_59.NumeroSerieSAT) // 2014-10-22 Identifica o n�mero do sat para n�o excluir o cupom com mesmo n�mero emitido por outro equipamento
    );
    Form1.ibDataset150.Open;
    //
    if Form1.ibDataset150.FieldByName('NUMERONF').AsString = FormataNumeroDoCupom(Form1.iCupom) then // Sandro Silva 2021-11-29 if Form1.ibDataset150.FieldByName('NUMERONF').AsString = StrZero(Form1.iCupom,6,0) then
    begin
      // Sandro Silva 2016-10-06  if (Pos('<infCFe Id="',Form1.ibDataSet150.FieldByName('NFEXML').AsString) <> 0)
      if ((Pos('infCFe', Form1.ibDataSet150NFEXML.AsString) <> 0) and
          (Pos('Id="CFe', Form1.ibDataSet150NFEXML.AsString) <> 0) and
          (Pos('versaoSB=', Form1.ibDataSet150NFEXML.AsString) <> 0))
       and (Pos('chCanc="', Form1.ibDataSet150.FieldByName('NFEXML').AsString) = 0) then
      begin// Emitido e n�o cancelado

        case _59.ModoOperacao of
          moClient:
            begin
              Form1.ExibePanelMensagem(SAT_MENSAGEM_AGUARDANDO_RESPOSTA_DO_SERVIDOR + ' ' + _ecf59_Tipodaimpressora); // Sandro Silva 2017-02-24
            end;
          moIntegradorMFE:
            begin
              if _59.DriverMFE01_05_15_Superior = False then // Sandro Silva 2021-08-23
                Form1.ExibePanelMensagem('Aguardando resposta do Integrador Fiscal'); // Sandro Silva 2017-02-24
            end;
        end;

        _59.Caixa := Form1.sCaixa;
        _59.SATCancelarUltimaVenda(Form1.ibDataSet150.FieldByName('NFEXML').AsString, Memo4);
        case _59.ModoOperacao of
          moClient:
            begin
              Form1.ExibePanelMensagem('Procesando resposta do Servidor ' + _ecf59_Tipodaimpressora); // Sandro Silva 2021-08-27 Form1.ExibePanelMensagem('Procesando resposta do Servidor SAT'); // Sandro Silva 2017-02-24
            end;
          moIntegradorMFE:
            begin
              if _59.DriverMFE01_05_15_Superior = False then // Sandro Silva 2021-08-23
                Form1.ExibePanelMensagem('Procesando resposta do Integrador Fiscal'); // Sandro Silva 2017-02-24
            end;
        end;

        try
          sResposta := _59.RetornoCancelamento.EEEEE; // Sandro Silva 2017-02-10 Essa linha precisa estar dentro de um try. Sem causa erro com Kryptus
        except

        end;

        Result := (sResposta = '07000');
        if Result then
        begin

          IncrementaGenerator(_59_PREFIXO_GENERATOR_CAIXA_SAT + _59.Caixa, 1); // Sandro Silva 2021-03-05 IncrementaGenerator('G_NUMEROCFESAT_' + _59.Caixa, 1);// Sandro Silva 2016-10-06  IncrementaGenerator('G_NUMEROCFESAT_' + Form1.sCaixa, 1);

          {Sandro Silva 2016-11-09 inicio}
          Form1.ibDataset150.Close;
          Form1.ibDataset150.SelectSql.Clear;
          Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF='+QuotedStr(FormataNumeroDoCupom(Form1.iCupom)) // Sandro Silva 2021-11-29 Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF='+QuotedStr(StrZero(Form1.iCupom,6,0))
                                        + ' and (substring(NFEID from 21 for 2) = ' + QuotedStr(_59.ModeloDocumento) + ' or coalesce(NFEID, '''') = '''') ' // 2014-10-22 para n�o selecionar nfc-e
                                        + ' and substring(NFEID from 23 for 9) = ' + QuotedStr(_59.NumeroSerieSAT) // 2014-10-22 Identifica o n�mero do sat para n�o excluir o cupom com mesmo n�mero emitido por outro equipamento
                                          );
          Form1.ibDataset150.Open;

          Form1.ibDataSet150.Edit;
          Form1.ibDataSet150STATUS.AsString := _59.CFeStatus;// 'Cancelamento Registrado e viculado a NFCe';
          Form1.ibDataSet150NFEXML.AsString := _59.CFeXML; //LoadXmlDestinatario(pChar(Form1.ibDataSet150NFEID.AsString));
          Form1.IBDataSet150.FieldByName('TOTAL').Clear; // Ficha 4302 Sandro Silva 2018-12-05
          Form1.ibDataSet150.Post;


          if _59.ImprimirExtrato then
            _ecf59_Imprime_DANFECE('', _59.CFeXML);

        end
        else
        begin
          SmallMsg(_59.RetornoCancelamento.mensagem + #13 + #13 + _59.Retorno);
        end;

      end;
    end
    else // Sandro Silva 2016-10-06  if (Pos('<infCFe Id="',Form1.ibDataSet150NFEXML.AsString) <> 0)
      if ((Pos('infCFe', Form1.ibDataSet150NFEXML.AsString) <> 0)
         and (Pos('Id="CFe', Form1.ibDataSet150NFEXML.AsString) <> 0)
        )
       and (Pos('chCanc="', Form1.ibDataSet150NFEXML.AsString) <> 0) then
    begin
      SmallMsg('Cupom Fiscal Eletr�nico j� cancelado');// Sandro Silva 2018-07-03  SmallMsg('Cupom fiscal eletr�nico - SAT j� cancelado');
      Result := True;
    end;

    // N�o consegui usar aqui qualquer manipula��o de objetos pertencentes ao Form1 ap�s executar chamadas ao componente smallsat.
    // Sempre retorna access violation (?)

    //
  except end;
  //
  Screen.Cursor            := crDefault;
  //
  Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible := False;
  ChDir(Form1.sAtual); // Sandro Silva 2017-03-31
end;

function _ecf59_Visualiza_DANFECE(pSLote: String; pFNFe : WideString): Boolean;
var
  sFileCFeSAT: String;
begin
  //
  Result := True;
  //
  //if FunctionDetect('USER32.DLL','BlockInput',@xBlockInput) then xBlockInput(False);  // Enable  Keyboard & mouse
  //
  try
    // Implementar visualiza��o do danfe para SAT

    _59.ExtratoDetalhado := Form1.DANFCEdetalhado1.Checked;

    _59.OrientacaoConsultarQRCode := '';

    if (xmlNodeValue(pFNFe, '//ide/cUF') = '35') or (AnsiUpperCase(_59.Emitente.UF) = 'SP') then  // S�o Paulo
      _59.OrientacaoConsultarQRCode := 'Consulte o QR Code pelo aplicativo "De olho na nota", dispon�vel na AppStore (Apple) e PlayStore (Android)';

    Form1.ExibePanelMensagem('Aguarde... Gerando Extrato ' + Form1.sTipoDocumento + ' em PDF'); // Sandro Silva 2018-08-01

    _59.ImprimirCupomDinamico(pFNFe, toImage, _59.Ambiente);

    Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible := False; // Sandro Silva 2016-08-25

    if LimpaNumero(xmlNodeValue(pFNFe, '//CFeCanc/infCFe/@chCanc')) <> '' then
      sFileCFeSAT := 'ADC' + LimpaNumero(xmlNodeValue(pFNFe, '//CFeCanc/infCFe/@Id'))
    else
      sFileCFeSAT := 'AD' + LimpaNumero(xmlNodeValue(pFNFe, '//CFe/infCFe/@Id'));

    sFileCFeSAT := ExtractFilePath(Application.ExeName) + 'CFeSAT\' + sFileCFeSAT + '.pdf';

    if FileExists(sFileCFeSAT) then
      ShellExecute(Application.Handle, 'open', PAnsiChar(sFileCFeSAT), '', '', SW_MAXIMIZE);

  except
    on E: Exception do
    begin
      Application.MessageBox(PansiChar(E.Message+chr(10)+chr(10)+'Ao visualizar o DANFCE'
      ),'Aten��o',mb_Ok + MB_ICONWARNING);
      Result := False;
    end;
  end;
end;

function _ecf59_Imprime_DANFECE(pSLote: String; pFNFe : WideString): Boolean;
begin
  Result := False; // Sandro Silva 2018-08-29
  Form1.ExibePanelMensagem('Aguarde, imprimindo Extrato do CF-e...');

  _59.OrientacaoConsultarQRCode := '';
  if (xmlNodeValue(pFNFe, '//ide/cUF') = '35') or (AnsiUpperCase(_59.Emitente.UF) = 'SP') then  // S�o Paulo
    _59.OrientacaoConsultarQRCode := 'Consulte o QR Code pelo aplicativo "De olho na nota", dispon�vel na AppStore (Apple) e PlayStore (Android)';

  _59.AvancoPapel := StrToIntDef(LerParametroIni('Frente.ini', SECAO_59, CHAVE_INI_AVANCO_PAPEL, '0'), 0); // Sandro Silva 2016-08-25

  _59.TamanhoPapel := Form1.sTamanhoPapel;

  _59.ExtratoDetalhado := Form1.DANFCEdetalhado1.Checked;

  if Printer.Printers.Count > 0 then // Sandro Silva 2018-06-13
  begin
    Printer.PrinterIndex := Printer.Printers.IndexOf(Form1.sImpressoraPadraoWindows);
    if Trim(Form1.sImpressoraDestino) <> '' then
    begin
      try
        Printer.PrinterIndex := Printer.Printers.IndexOf(Form1.sImpressoraDestino);
      except
        Printer.PrinterIndex := Printer.Printers.IndexOf(Form1.sImpressoraPadraoWindows);
      end;
    end;
    try
      Result := _59.ImprimirCupomDinamico(pFNFe, toPrinter, _59.Ambiente);

      if Trim(Form1.sImpressoraDestino) <> '' then
        Printer.PrinterIndex := Printer.Printers.IndexOf(Form1.sImpressoraPadraoWindows);

    except
      Screen.Cursor := crDefault;
    end;
  end
  else
    ShowMessage('Instale uma impressora no Windows');

  Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible := False;
end;

function _ecf59_Email_DANFECE(pSLote: String; pFNFe : WideString): Boolean;
var
  sEmail : String;
  sFileCFeSAT: String;
  sFileXML: String;
  sZipFile: String;
  sTextoCorpoEmail: String;
  slXMl: TStringList; // Sandro Silva 2021-11-26
  function Compactar(sZipFile: String): Boolean;
  begin
    if FileExists(sZipFile) then
      DeleteFile(PansiChar(sZipFile));

    if FileExists('szip.exe') then
    begin

      // Primeiro compacta o xml
      if FileExists(sFileXML) then
        ShellExecuteA(Application.Handle, PAnsiChar('Open'), PAnsiChar('szip.exe'), PAnsiChar('backup "'+Alltrim(sFileXML)+'" "'+ sZipFile + '"'), PAnsiChar(''), SW_SHOWMAXIMIZED); // Ficha 5157 Sandro Silva 2020-10-27  ShellExecuteW( 0,           'Open',            'szip.exe',  PWideChar('backup "'+Alltrim(sFileXML)+'" "'+ sZipFile + '"'),           '', SW_SHOWMINIMIZED); // Sandro Silva 2020-09-14 ShellExecute( 0, 'Open','szip.exe',pChar('backup "'+Alltrim(sFileXML)+'" "'+ sZipFile + '"'), '', SW_SHOWMAXIMIZED);

      //
      while ConsultaProcesso('szip.exe') do
      begin
        // Sandro Silva 2016-05-23  Application.ProcessMessages;
        Sleep(100);
      end;

      // PDF demora mais causa travamento do szip.exe se compactado antes do xml
      if FileExists(sFileCFeSAT) then
        ShellExecuteA(Application.Handle, PAnsiChar('Open'), PAnsiChar('szip.exe'), PAnsiChar('backup "'+Alltrim(sFileCFeSAT)+'" "'+ sZipFile + '"'), PAnsiChar(''), SW_SHOWMAXIMIZED); // Ficha 5157 Sandro Silva 2020-10-27  ShellExecuteW( 0, 'Open','szip.exe',PWideChar('backup "'+Alltrim(sFileCFeSAT)+'" "'+ sZipFile + '"'), '', SW_SHOWMINIMIZED); // Sandro Silva 2020-09-14 ShellExecute( 0, 'Open','szip.exe',pChar('backup "'+Alltrim(sFileCFeSAT)+'" "'+ sZipFile + '"'), '', SW_SHOWMAXIMIZED);

      //
      while ConsultaProcesso('szip.exe') do
      begin
        // Sandro Silva 2016-05-23  Application.ProcessMessages;
        Sleep(100);
      end;
      //
      while not FileExists(PansiChar(sZipFile)) do
      begin
        Sleep(100);
      end;
      //
      while FileExists(PansiChar(sFileCFeSAT)) do
      begin
        DeleteFile(PansiChar(sFileCFeSAT));
        Sleep(100);
      end;

      while FileExists(PansiChar(sFileXML)) do
      begin
        DeleteFile(PansiChar(sFileXML));
        Sleep(100);
      end;
    end;
    Result := True;
  end;
begin
  //
  sEmail    := AllTrim(Copy(StrTran(AllTrim(Form2.Edit10.Text),';',Replicate(' ',512))+Replicate(' ',265),1,256)); // Fica s�mente um e-mail
  //
  if ValidaEmail(sEmail) then
  begin

    Form1.ExibePanelMensagem('Aguarde... Enviando email para ' + sEmail); // Sandro Silva 2022-09-02 Form1.ExibePanelMensagem('Aguarde... Enviando e-mail com o Extrato ' + Form1.sTipoDocumento + ' em PDF');

    ChDir(ExtractFilePath(Application.ExeName));
    CreateDir('email');

    _59.ExtratoDetalhado := Form1.DANFCEdetalhado1.Checked;
    _59.ImprimirCupomDinamico(pFNFe, toImage, _59.Ambiente);

    Sleep(2000); // 2015-11-30

    if LimpaNumero(xmlNodeValue(pFNFe, '//CFeCanc/infCFe/@chCanc')) <> '' then
      sFileCFeSAT := 'ADC' + LimpaNumero(xmlNodeValue(pFNFe, '//CFeCanc/infCFe/@Id'))
    else
      sFileCFeSAT := 'AD' + LimpaNumero(xmlNodeValue(pFNFe, '//CFe/infCFe/@Id'));

    sZipFile := ExtractFilePath(Application.ExeName) + 'email\' + sFileCFeSAT + '.zip';

    sFileXML := ExtractFilePath(Application.ExeName) + 'email\' + sFileCFeSAT + '.xml'; // Sandro Silva 2022-09-02 sFileXML := ExtractFilePath(Application.ExeName) + 'CFeSAT\' + sFileCFeSAT + '.xml';

    sFileCFeSAT := ExtractFilePath(Application.ExeName) + 'email\' + sFileCFeSAT + '.pdf'; // Sandro Silva 2022-09-02 sFileCFeSAT := ExtractFilePath(Application.ExeName) + 'CFeSAT\' + sFileCFeSAT + '.pdf';

    while FileExists(PansiChar(sFileXML)) do
    begin
      DeleteFile(PansiChar(sFileXML));
      Sleep(100);
    end;

    slXMl := TStringList.Create; //
    slXMl.Text      := pFNFe;
    slXMl.SaveToFile(sFileXML);
    slXMl.Free;
    {Sandro Silva 2021-11-26 fim}

    if Form1.EnviarDANFCEeXMLcompactado1.Checked = False then
    begin

      if FileExists(PansiChar(sFileXML)) then
      begin
        sTextoCorpoEmail := 'Segue em anexo seu XML do Cupom Fiscal Eletr�nico - SAT.'+chr(10);
        if Form1.sPropaganda <> '' then
          sTextoCorpoEmail := sTextoCorpoEmail + Form1.sPropaganda + Chr(10);
        sTextoCorpoEmail := sTextoCorpoEmail + Chr(10) + 'Este e-mail foi enviado automaticamente pelo sistema Smallsoft.'+chr(10)+'www.smallsoft.com.br';
        EnviarEMail('',sEmail,'','XML do Cupom Fiscal Eletr�nico - SAT',PansiChar(sTextoCorpoEmail),PansiChar(sFileXML),False);
      end;

      if FileExists(sFileCFeSAT) then
      begin
        sTextoCorpoEmail := 'Segue em anexo seu Extrato Cupom Fiscal Eletr�nico em arquivo PDF.'+chr(10); // Sandro Silva 2018-07-03 sTextoCorpoEmail := 'Segue em anexo seu Extrato Cupom Fiscal Eletr�nico - SAT em arquivo PDF.'+chr(10);
        if Form1.sPropaganda <> '' then
          sTextoCorpoEmail := sTextoCorpoEmail + Form1.sPropaganda + Chr(10);
        sTextoCorpoEmail := sTextoCorpoEmail + Chr(10) + 'Este e-mail foi enviado automaticamente pelo sistema Smallsoft.'+chr(10)+'www.smallsoft.com.br';
        EnviarEMail('',sEmail,'','Extrato Cupom Fiscal Eletr�nico',PansiChar(sTextoCorpoEmail),PansiChar(sFileCFeSAT),False); // Sandro Silva 2018-07-03 EnviarEMail('',sEmail,'','Extrato Cupom Fiscal Eletr�nico - SAT',pchar(sTextoCorpoEmail),pChar(sFileCFeSAT),False);
      end;

    end
    else
    begin
      //sZipFile := ExtractFilePath(Application.ExeName) + 'email\' + 'CFeSat_xml_pdf_' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzzz', Now) + '.zip'; // Sandro Silva 2022-09-02 sZipFile := ExtractFilePath(Application.ExeName) + 'CFeSAT\' + 'CFeSat_xml_pdf.zip';
      //sZipFile := ChangeFileExt(sFileCFeSAT, 'zip');
      Compactar(sZipFile);
      if FileExists(PansiChar(sZipFile)) then
      begin
        sTextoCorpoEmail := 'Segue em anexo seu XML e Extrato Cupom Fiscal Eletr�nico.'+chr(10); // Sandro Silva 2018-07-03 sTextoCorpoEmail := 'Segue em anexo seu XML e Extrato Cupom Fiscal Eletr�nico - SAT.'+chr(10);
        if Form1.sPropaganda <> '' then
          sTextoCorpoEmail := sTextoCorpoEmail + Form1.sPropaganda + Chr(10);
        sTextoCorpoEmail := sTextoCorpoEmail + Chr(10) + 'Este e-mail foi enviado automaticamente pelo sistema Smallsoft.'+chr(10)+'www.smallsoft.com.br';

        EnviarEMail('', sEmail, '', 'Extrato Cupom Fiscal Eletr�nico e XML', PansiChar(sTextoCorpoEmail),PansiChar(sZipFile), False); // Sandro Silva 2018-07-03 EnviarEMail('', sEmail, '', 'Extrato Cupom Fiscal Eletr�nico - SAT e XML', pchar(sTextoCorpoEmail),pChar(sZipFile), False);
      end;
    end;

    {Sandro Silva 2022-09-02 inicio
    if Form1.Panel3.Visible then
      Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible := False;
    }   
  end;
  {Sandro Silva 2022-09-02 inicio}
  if Form1.Panel3.Visible then
    Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible := False;
  {Sandro Silva 2022-09-02 fim}
  //
  Result := True;
  //
  ChDir(Form1.sAtual); // Sandro Silva 2017-03-31
end;

function _ecf59_NomeExeSAT: String;
begin
  Result := NOME_APLICATIVO_59;
end;

function SangriaSuprimento(dValor: Double; sTipo: String): Boolean;
// Sandro Silva 2015-03-30 Impress�o de comprovante de sangria ou suprimento
var
  sCupomFiscalVinculado: String;
begin

  try

    sCupomFiscalVinculado := ' '+ Chr(10);
    Form1.ibQuery65.Close;
    Form1.ibQuery65.SQL.Clear;
    Form1.ibQuery65.SQL.Text := 'select NOME, CGC, IE, IM from EMITENTE';
    Form1.ibQuery65.Open;

    sCupomFiscalVinculado := sCupomFiscalVinculado +
      Copy(Form1.ibQuery65.FieldByName('NOME').AsString + Replicate(' ',40-13),1,40-13)+chr(10) +
      'CNPJ: '+ Form1.ibQuery65.FieldByname('CGC').AsString + Chr(10) +
      'IE: '+ Form1.ibQuery65.FieldByname('IE').AsString + Chr(10) +
      'IM: '+ Form1.ibQuery65.FieldByname('IM').AsString + Chr(10) +
      '-----------------------------------------------'+ Chr(10) +
      FormatDateTime('dd/mm/yyyy HH:nn:ss', Now) + ' Caixa: ' + StrZero(Form1.iCaixa, 3, 0) +  Chr(10)+
      'N�O � DOCUMENTO FISCAL'+chr(10)+
      'COMPROVANTE N�O FISCAL'+chr(10)+
      '-----------------------------------------------'+chr(10) +
      sTipo + ' R$ ' + Format('%8.2n',[dValor])+chr(10) +
      '-----------------------------------------------'+chr(10);

    _ecf59_ImpressaoNaoSujeitoaoICMS(ConverteAcentos(sCupomFiscalVinculado));
    Form1.ibQuery65.Close;
  except

  end;
  Result := True;
end;

procedure _ecf59_ImportaConfiguracao;
var
  Cursor: TCursor;
  sXMLConfiguracao: String;
begin
  Cursor := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;
    if _59 = nil then
      //_ecf59_Inicializa('');
      SmallMsg('SAT n�o foi inicializado')
    else
    begin

      sXMLConfiguracao := '';
      if (Trim(LerParametroIni(Form1.sArquivo, SECAO_59, _59_CHAVE_ASSINATURA_ASSOCIADA, '')) = '')
        or (Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CODIGO_ATIVACAO, '')) = '')
        or (Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CNPJ_SOFTWARE_HOUSE, '')) = '')
        or (Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CODIGO_FABRICANTE, '')) = '') then
      begin
        sXMLConfiguracao := _59.ConfiguracaoSATServidor;
      end;

      if xmlNodeValue(sXMLConfiguracao, '//configuracao') <> '' then
      begin
        if xmlNodeValue(sXMLConfiguracao, '//assinaturaassociada') <> '' then
          _ecf59_GravaAssinaturaAssociada(xmlNodeValue(sXMLConfiguracao, '//assinaturaassociada'));

        if xmlNodeValue(sXMLConfiguracao, '//codigoativacao') <> '' then
          GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CODIGO_ATIVACAO, xmlNodeValue(sXMLConfiguracao, '//codigoativacao'));

        if xmlNodeValue(sXMLConfiguracao, '//cnpjsh') <> '' then
          GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CNPJ_SOFTWARE_HOUSE, xmlNodeValue(sXMLConfiguracao, '//cnpjsh'));

        if xmlNodeValue(sXMLConfiguracao, '//codigofabricante') <> '' then
          GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CODIGO_FABRICANTE, xmlNodeValue(sXMLConfiguracao, '//codigofabricante'));

        if xmlNodeValue(sXMLConfiguracao, '//dllfabricante') <> '' then
          GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CAMINHO_DLL, xmlNodeValue(sXMLConfiguracao, '//dllfabricante')); // Sandro Silva 2017-09-08

        if xmlNodeValue(sXMLConfiguracao, '//versaodadosentrada') <> '' then
          GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_VERSAO_DADOS_ENTRADA, xmlNodeValue(sXMLConfiguracao, '//versaodadosentrada')); // Sandro Silva 2017-09-08

        if xmlNodeValue(sXMLConfiguracao, '//ambiente') <> '' then
        begin
          //_59.Ambiente := xmlNodeValue(sXMLConfiguracao, '//ambiente');

          GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_AMBIENTE, xmlNodeValue(sXMLConfiguracao, '//ambiente')); // Sandro Silva 2017-09-08

        end;

      end;
    end;

  finally
    Screen.Cursor := Cursor;
  end;

end;

procedure _ecf59_ConsultaSat(const bExibeRetorno: Boolean;
  bExibirMensagemSefaz: Boolean);
var
  Cursor: TCursor;
  bMensagem: Boolean;
begin
  Cursor := Screen.Cursor;
  bMensagem := bExibeRetorno;
  if Form1.bBalancaAutonoma = False then // Sandro Silva 2019-02-27
  begin
    try

      if bExibeRetorno and bExibirMensagemSefaz then
      begin
        case _59.ModoOperacao of
          moClient:
            Form1.ExibePanelMensagem(SAT_MENSAGEM_AGUARDANDO_RESPOSTA_DO_SERVIDOR + ' ' + _ecf59_Tipodaimpressora);
          moIntegradorMFE:
              if _59.DriverMFE01_05_15_Superior = False then // Sandro Silva 2021-08-23
                Form1.ExibePanelMensagem('Aguardando resposta do Integrador Fiscal'); // Sandro Silva 2017-02-24
        else
          Form1.ExibePanelMensagem('Aguarde, consultando status do ' + _ecf59_Tipodaimpressora); // Sandro Silva 2021-08-27 Form1.ExibePanelMensagem('Aguarde, consultando status do SAT');
        end;
      end;

      Screen.Cursor := crHourGlass;
      if _59 = nil then
        //_ecf59_Inicializa('');
        SmallMsg('SAT n�o foi inicializado')
      else
      begin
        _59.CodigoRetornoConsultarSAT := '';

        _59.SATConsultar(bExibeRetorno, bExibirMensagemSefaz);
        if bMensagem then
        begin
          if _59.CodigoRetornoSAT <> '08000' then
          begin
            if _59.CodigoRetornoSAT = '' then
            begin
              Application.MessageBox(PansiChar(_59.RespostaSat + #13 + #13 + 'A aplica��o ser� finalizada'),'Aten��o', MB_ICONWARNING + MB_OK);
              FecharAplicacao(ExtractFileName(Application.ExeName));
              Abort;
            end
            else
              Application.MessageBox(PansiChar(_59.CodigoRetornoSAT + ' ' + _59.MensagemSat),'Aten��o', MB_ICONWARNING + MB_OK);
          end
          else
          begin
            if ((_59.CodigoRetornoSAT <> '08000') and (_59.CodigoRetornoSAT <> '')) or bMensagem then
            begin
              if (_59.EmOperacao) or bMensagem then
              begin
                //Application.MessageBox(PansiChar(_59.RespostaSAT),'SAT', MB_ICONINFORMATION + MB_OK);
                if Form22.Visible then
                begin
                  if (_59.CodigoRetornoSAT <> '08000') then
                  begin
                    Form22.Label6.Caption := _59.MensagemSat;
                    Form22.Label6.Repaint;
                  end;
                end
                else
                begin
                  Form1.ExibePanelMensagem(_59.MensagemSat);
                end;
                Sleep(2000);
              end;
            end;
          end;
          Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible := False;
        end;
        //}

        if bExibirMensagemSefaz then
          if Trim(_59.MensagemSEFAZ) <> '' then
            Application.MessageBox(PansiChar(_59.CodigoRetornoSAT + ' ' + _59.MensagemSEFAZ), 'Aten��o Mensagem da SEFAZ', MB_ICONINFORMATION + MB_OK);
      end;

    finally
      // Sandro Silva 2019-02-27  Screen.Cursor := Cursor;
    end;
  end; // if Form1.bBalancaAutonoma = False then // Sandro Silva 2019-02-27
  Screen.Cursor := Cursor;
end;

procedure _ecf59_ConsultaStatusOperacional;
var
  Cursor: TCursor;
begin
  Cursor := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;
    if Form1.bBalancaAutonoma = False then // Sandro Silva 2019-02-27
    begin
      try

        case _59.ModoOperacao of
          moClient:
            Form1.ExibePanelMensagem(SAT_MENSAGEM_AGUARDANDO_RESPOSTA_DO_SERVIDOR + ' ' + _ecf59_Tipodaimpressora);
          moIntegradorMFE:
            if _59.DriverMFE01_05_15_Superior = False then // Sandro Silva 2021-08-23
              Form1.ExibePanelMensagem('Aguardando resposta do Integrador Fiscal'); // Sandro Silva 2017-02-24
        else
          Form1.ExibePanelMensagem('Aguarde, consultando status do ' + _ecf59_Tipodaimpressora); // Sandro Silva 2021-08-27 Form1.ExibePanelMensagem('Aguarde, consultando status do SAT');
        end;

        if _59 = nil then
          //_ecf59_Inicializa('');
          SmallMsg('SAT n�o foi inicializado')
        else
          _59.SATConsultarStatusOperacional(Memo4, True);

        Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible := False; // Sandro Silva 2017-05-10

        if _59.ModoOperacao = moClient then
          Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible := False; // Sandro Silva 2017-02-24

        if _59.ConteudoStatusOperacional <> '' then
          Application.MessageBox(PansiChar(_59.ConteudoStatusOperacional), 'Retorno Status Operacional', MB_ICONINFORMATION + MB_OK);

      except

      end;
    end; // if Form1.bBalancaAutonoma = False then // Sandro Silva 2019-02-27
  finally
    Screen.Cursor := Cursor;
  end;
  Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible := False; // Sandro Silva 2017-05-10
end;

procedure _ecf59_ExtrairLog;
var
  Cursor: TCursor;
begin
  Cursor := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;

    Form1.ExibePanelMensagem('Aguarde, extraindo logs...');

    if _59 = nil then
      SmallMsg('SAT n�o foi inicializado')
    else
      _59.SATExtrairLogs(True);
  finally
      Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible := False;
    Screen.Cursor := Cursor;
  end;
  ChDir(Form1.sAtual); // Sandro Silva 2017-03-31
end;

procedure _ecf59_ConfiguraDadosEmitente;
begin
  _59.Emitente.CNPJ := LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString);
  _59.Emitente.IE   := LimpaNumero(Form1.ibDataSet13.FieldByName('IE').AsString);
  _59.Emitente.IM   := LimpaNumero(Form1.ibDataSet13.FieldByName('IM').AsString);
  _59.Emitente.UF   := AnsiUpperCase(Form1.ibDataSet13.FieldByName('ESTADO').AsString);

end;

procedure _ecf59_FinalizaSAT;
begin
  _59.Free;
end;

procedure _ecf59_CriaSequencialCaixa(sCaixa: String);
var
  sAlteracaPedido: String;
begin
  if sCaixa <> '' then
  begin
    try
      Form1.ibQuery65.Close;
      Form1.ibQuery65.SQL.Text :=
        'select trim(RDB$GENERATOR_NAME) as GENERATOR_NAME ' +
        'from RDB$GENERATORS ' +
        'where RDB$GENERATOR_NAME = ' + QuotedStr(_59_PREFIXO_GENERATOR_CAIXA_SAT + sCaixa); // Sandro Silva 2021-03-05 'where RDB$GENERATOR_NAME = ' + QuotedStr('G_NUMEROCFESAT_' + sCaixa);
      Form1.ibQuery65.Open;

      if Form1.ibQuery65.FieldByName('GENERATOR_NAME').AsString = '' then
      begin
        Form1.ibQuery65.Close;
        Form1.ibQuery65.SQL.Text :=
          'create sequence ' + _59_PREFIXO_GENERATOR_CAIXA_SAT + sCaixa; // Sandro Silva 2021-03-05 'create sequence G_NUMEROCFESAT_' + sCaixa;
        Form1.ibQuery65.ExecSQL;

        if IncrementaGenerator(_59_PREFIXO_GENERATOR_CAIXA_SAT + sCaixa, 0) = 0 then // Sandro Silva 2021-03-05 if IncrementaGenerator('G_NUMEROCFESAT_' + sCaixa, 0) = 0 then
        begin

          Form1.ibQuery65.Close;
          Form1.ibQuery65.SQL.Clear;
          Form1.ibQuery65.Sql.TExt := 'select coalesce(max(PEDIDO), 0) as MAIORALTERACAPEDIDO from ALTERACA where CAIXA = ' + QuotedStr(sCaixa);
          Form1.ibQuery65.Open;
          sAlteracaPedido := Form1.ibQuery65.FieldByName('MAIORALTERACAPEDIDO').AsString;

          Form1.ibQuery65.Close;
          Form1.ibQuery65.SQL.Text :=
            'alter sequence ' + _59_PREFIXO_GENERATOR_CAIXA_SAT  + sCaixa + ' restart with ' + sAlteracaPedido; // Sandro Silva 2021-03-05 'alter sequence G_NUMEROCFESAT_' + sCaixa + ' restart with ' + sAlteracaPedido;
          Form1.ibQuery65.ExecSQL;
        end;
      end;

    except

    end;
  end;
end;

function _ecf59_AtivarSat(codigoDeAtivacao: String; CNPJ: String;
  cUF: String; mmLog: TMemo = nil): Boolean;
var
  Cursor: TCursor;
  sRetorno: String;
begin
  Cursor := Screen.Cursor;
  Result := False;
  try
    Screen.Cursor := crHourGlass;
    if _59 = nil then
    begin
      SmallMsg('SAT n�o foi inicializado')
    end
    else
    begin
      sRetorno := _59.SATAtivarSAT(1, codigoDeAtivacao, CNPJ, cUF);
      Result := ((sRetorno = '04000') or (sRetorno = '04003'));
    end;
  finally
    Screen.Cursor := Cursor;
  end;
end;

function _ecf59_AssociarAssinatura(codigoDeAtivacao: String;
  CNPJEmitente: String; assinaturaCNPJs: String;
  mmLog: TMemo = nil): Boolean;
var
  Cursor: TCursor;
begin
  Cursor := Screen.Cursor;
  Result := False;
  try
    Screen.Cursor := crHourGlass;
    if _59 = nil then
    begin
      SmallMsg('SAT n�o foi inicializado')
    end
    else
    begin
      if _ecf59_ValidaKitDesenvolvimento then
      begin // Equipamento kit desenvolvedor n�o pode ser reconfigurado pelo AC, sempre retorna True
        Result := True;
      end
      else
      begin
        _59.SATAssociarAssinatura(codigoDeAtivacao, CNPJEmitente, assinaturaCNPJs);
        Result := (_59.CodigoRetornoSAT = '13000') or (_59.CodigoRetornoSAT = '13099');
      end;
    end;
  finally
    Screen.Cursor := Cursor;
  end;
end;

function _ecf59_GravaAssinaturaAssociada(sAssinatura: String): Boolean;
begin
  if sAssinatura <> '' then
    GravarParametroIni(Form1.sArquivo, SECAO_59, _59_CHAVE_ASSINATURA_ASSOCIADA, sAssinatura);
  Result := True;
end;

function _ecf59_LeAssinaturaAssociada: String;
begin
  Result := Trim(LerParametroIni(Form1.sArquivo, SECAO_59, _59_CHAVE_ASSINATURA_ASSOCIADA, ''));
end;

function _ecf59_ConfiguraCaixaSAT(sCaixa: String; bDefinirProximoSequencia: Boolean = False): String; // Sandro Silva 2021-03-05 function _ecf59_ConfiguraCaixaSAT(sCaixa: String): String;
var
  IBQCAIXA: TIBQuery;
  IBQREDUCOES: TIBQuery;
  sCaixaOld: String;
begin
  Result := '';
  sCaixaOld := sCaixa;
  IBQCAIXA := CriaIBQuery(FORM1.IBQuery65.Transaction);
  IBQREDUCOES := CriaIBQuery(FORM1.IBQuery65.Transaction);
  while Result = '' do
  begin
    sCaixa := sCaixaOld; // Inicia com o caixa atual Sandro Silva 2020-06-30

    if bDefinirProximoSequencia then
    begin
      try
        IBQCAIXA.Close;
        IBQCAIXA.SQL.Text :=
          'select first 1 replace(trim(RDB$GENERATOR_NAME), ''' + _59_PREFIXO_GENERATOR_CAIXA_SAT + ''', '''') as NUMEROCAIXA ' +
          'from RDB$GENERATORS ' +
          'where RDB$GENERATOR_NAME starting ''' + _59_PREFIXO_GENERATOR_CAIXA_SAT + ''' ' +
          'order by 1 desc';
        IBQCAIXA.Open;
        if IBQCAIXA.FieldByName('NUMEROCAIXA').AsString <> '' then
          sCaixa := FormatFloat('000', StrToIntDef(IBQCAIXA.FieldByName('NUMEROCAIXA').AsString, 0) + 1)
        else
          sCaixa := '001';
      except
        bDefinirProximoSequencia := False;
        sCaixa := sCaixaOld;
      end;
    end;

    if bDefinirProximoSequencia = False then
    begin
      sCaixa := Small_InputBox('N�mero do Caixa',
                               'Informe o n�mero do caixa para identificar as vendas deste PDV',
                               sCaixa);
    end;

    // Sempre a partir do segundo loop bDefinirProximoSequencia deve ser False;
    //    bDefinirProximoSequencia := False;

    if (sCaixa <> '') and (sCaixa <> sCaixaOld) then // Sandro Silva 2020-06-30 if sCaixa <> '' then
    begin
      sCaixa := Right('00' + LimpaNumero(sCaixa), 3);
      IBQCAIXA.Close;
      IBQCAIXA.SQL.Text :=
        'select CAIXA ' +
        'from ALTERACA ' +
        'where CAIXA = :CAIXA'; // Sandro Silva 2020-06-30  'where CAIXA = ' + QuotedStr(sCaixa);
      IBQCAIXA.ParamByName('CAIXA').AsString := sCaixa;
      IBQCAIXA.Open;

      IBQREDUCOES.Close;
      IBQREDUCOES.SQL.Text :=
        'select distinct PDV, SERIE, SMALL ' +
        'from REDUCOES ' +
        'where coalesce(SERIE, '''') <> '''' ' +
        ' and PDV = :PDV';
      IBQREDUCOES.ParamByName('PDV').AsString := sCaixa;
      IBQREDUCOES.Open;

      if (IBQCAIXA.FieldByName('CAIXA').AsString <> '') or (IBQREDUCOES.FieldByName('PDV').AsString <> '') then // Sandro Silva 2020-06-30 if IBQCAIXA.FieldByName('CAIXA').AsString <> '' then
      begin

        if IBQREDUCOES.FieldByName('PDV').AsString <> '' then
        begin
          Result := sCaixa;
          if IBQREDUCOES.FieldByName('SMALL').AsString <> '' then
          begin
            if (_59.ModoOperacao = moAlone) and (IBQREDUCOES.FieldByName('SMALL').AsString <> '65') then // N�o est� executando como cliente sat/mfe e caixa foi usado anteriormente
            begin

              if (_59.NumeroSerieSAT <> IBQREDUCOES.FieldByName('SERIE').AsString) then
              begin
                Result := '';

                Application.MessageBox(PAnsiChar('O caixa ' + sCaixa + ' j� foi utilizado anteriormente com ' +
                                                 IfThen(IBQREDUCOES.FieldByName('SMALL').AsString = '59', 'SAT/MFE ', 'ECF ') + IBQREDUCOES.FieldByName('SERIE').AsString + #13 + #13 +
                                                 'Informe outro o n�mero diferente de ' + sCaixa),
                                       'Aten��o!', MB_ICONINFORMATION + MB_OK);

              end;

            end;
          end;
        end
        else
        begin

          if Application.MessageBox(PansiChar('O caixa ' + sCaixa + ' j� foi utilizado anteriormente' + #13 + #13 +
                                          'Certifique-se de que o n�mero ' + sCaixa + ' n�o identifique outro PDV' + #13 + #13 +
                                          'Deseja continuar?'),
                                          'Aten��o!', MB_ICONQUESTION + MB_YESNO) = ID_YES then

            Result := sCaixa;

        end;
      end
      else
      begin
        Result := sCaixa;
      end;
    end;
  end;
  FreeAndNil(IBQCAIXA); // Sandro Silva 2019-06-18
end;

function _ecf59_ConfiguraSAT: Boolean;
var
  sResposta: String;
  sAssinaturaAssociada: String;
begin
  Result := True;
  if Form1.bBalancaAutonoma = False then
  begin
    if (_59.CodigoAtivacao = '') then
    begin
      SmallMsg('Informe o c�digo de ativa��o configurado no equipamento ' + _ecf59_Tipodaimpressora);
      Form1.sStatusECF := _ecf59_Tipodaimpressora + ' - N�o autorizado.';
      Result := False;
    end;

    if (_59.Fabricante = '') then
    begin
      SmallMsg('Informe o c�digo do fabricante do equipamento ' + _ecf59_Tipodaimpressora);
      Form1.sStatusECF := _ecf59_Tipodaimpressora + ' - N�o autorizado. C�digo do fabricante inv�lido';
      Result := False;
    end;
  end
  else
    Result := False; // Sandro Silva 2019-01-28

  if Form1.bBalancaAutonoma = False then // Sandro Silva 2019-01-29
  begin

    if (_59.AssinaturaAssociada = '') then
    begin
      Form22.Label6.Caption := 'Aguarde! Obtendo a Assinatura Associada....';
      Form22.Label6.Repaint;

      sResposta := Form1.GetAssinaturaHttpPost(StrTran(Form22.sSerie, 'N�mero de s�rie: ', ''), _59.Emitente.CNPJ, _59.Fabricante, _59.NumeroSerieSAT);

      if (Trim(xmlNodeValue(sResposta, '//assinaturaassociada')) <> '') then
      begin

        _ecf59_GravaAssinaturaAssociada(Trim(xmlNodeValue(sResposta, '//assinaturaassociada')));

      end;

      if LerParametroIni(Form1.sArquivo, SECAO_59, _59_CHAVE_ASSINATURA_ASSOCIADA, '') = '' then
      begin

        sAssinaturaAssociada := Small_InputBox('Assinatura Associada',
                                            'Informe a Assinatura Associada fornecida pela Smallsoft. ', sAssinaturaAssociada);
        if Trim(sAssinaturaAssociada) <> '' then
          _ecf59_GravaAssinaturaAssociada(sAssinaturaAssociada);

      end;

      if Trim(xmlNodeValue(sResposta, '//cnpjsh')) <> '' then
      begin

        GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CNPJ_SOFTWARE_HOUSE, Trim(xmlNodeValue(sResposta, '//cnpjsh')));
        _59.CNPJSoftwareHouse := Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CNPJ_SOFTWARE_HOUSE, _59.CNPJSoftwareHouse));

      end;

      if AnsiUpperCase(LerParametroIni(FRENTE_INI, SECAO_59, CHAVE_MODO_OPERACAO, '')) <> 'CLIENTE' then // Sandro Silva 2017-02-23
      begin

        if (_59.AssinaturaAssociada <> '')
          and (_59.CodigoAtivacao <> '') then
        begin

          Form22.Label6.Caption := 'Aguarde! Ativando SAT....';
          Form22.Label6.Repaint;

          if _ecf59_AtivarSat(_59.CodigoAtivacao, _59.Emitente.CNPJ, _59.Emitente.UF) then
          begin

            Form22.Label6.Caption := 'Aguarde! Associando Assinatura do Contribuinte + Software House....';
            Form22.Label6.Repaint;

          end
          else
          begin

            Form1.sStatusECF := _ecf59_Tipodaimpressora +  ' - N�o autorizado. ' + _ecf59_Tipodaimpressora + ' n�o foi ativado'; // Sandro Silva 2017-05-10  'SAT - N�o autorizado. SAT n�o foi ativado';
            Result := False;

          end;
  //ShowMessage('Teste 01 4942'); // Sandro Silva 2018-11-19

          // Sempre associa a assinatura ap�s fazer o download
          if Result then
          begin

  //ShowMessage('Teste 01 4949'); // Sandro Silva 2018-11-19
            try
              if _ecf59_AssociarAssinatura(_59.CodigoAtivacao, _59.Emitente.CNPJ, _59.AssinaturaAssociada) = False then
              begin

                Form1.sStatusECF := _ecf59_Tipodaimpressora + ' - N�o autorizado. Assinatura n�o associada'; // Sandro Silva 2017-05-10  'SAT - N�o autorizado. Assinatura n�o associada';
                Result := False;

              end;
            except
              Result := False; // SAT da ControlID KIT desenvolvimento sempre ocorre access violation quando n�o existe assinatura no cripta
            end;

          end;

  //ShowMessage('Teste 01 4961'); // Sandro Silva 2018-11-19

        end
        else
        begin

          Form1.sStatusECF := _ecf59_Tipodaimpressora + ' - N�o autorizado. Assinatura Associada n�o encontrada'; // Sandro Silva 2017-05-10  'SAT - N�o autorizado. Assinatura Associada n�o encontrada';
          Result := False;

        end;

      end; //if _59.ModoOperacao <> moClient then // Sandro Silva 2017-02-23

  //ShowMessage('Teste 01 4974'); // Sandro Silva 2018-11-19

      if Trim(xmlNodeValue(sResposta, '//alerta')) <> '' then
      begin
        SmallMsgBox(PansiChar('N�o foi poss�vel obter a Assinatura Associada para o ' + _ecf59_Tipodaimpressora + #13 + Utf8ToAnsi(Trim(xmlNodeValue(sResposta, '//alerta')))), 'Aten��o', MB_ICONWARNING + MB_OK);
      end;

      // Se n�o conseguiu obter a assinatura associada
      if (_59.AssinaturaAssociada = '') then
      begin
        Form1.sStatusECF := _ecf59_Tipodaimpressora + ' - N�o autorizado. Assinatura Associada n�o encontrada'; // Sandro Silva 2017-05-10  'SAT - N�o autorizado. Assinatura Associada n�o encontrada';
        Result := False;
      end;

  //ShowMessage('Teste 01 4988'); // Sandro Silva 2018-11-19
      if Form1.bBalancaAutonoma = False then // Sandro Silva 2019-01-23
      begin
        Form22.Label6.Caption := 'Aguarde! Verificando a disponibilidade dos servi�os ' + _ecf59_Tipodaimpressora(True) + '....';
        Form22.Label6.Repaint;
      end;

    end;

  //ShowMessage('Teste 01 4995'); // Sandro Silva 2018-11-19
    if _59.BloqueioAutonomo then
    begin
      Form1.sStatusECF := _ecf59_Tipodaimpressora + ' em Bloqueio Autonomo'; // Sandro Silva 2017-05-10  'SAT em Bloqueio Autonomo';
      Result := False;
    end;
  //ShowMessage('Teste 01 5001'); // Sandro Silva 2018-11-19
  end;
end;

procedure _ecf59_ConfiguraFabricanteModeloSAT(
  var sCodigoFabricante: String);
begin
  while True do
  begin
    sCodigoFabricante := LimpaNumero(Small_InputComboBox('Equipamento SAT',
                                    'Selecione o Fabricante e o Modelo do equipamento SAT. ',
                                    sCodigoFabricante));
    if (Length(sCodigoFabricante) <> 4) then
      SmallMsgBox('C�digo do fabricante e modelo inv�lido', 'Aten��o', MB_OK + MB_ICONWARNING)
    else
      Break;
  end;
  if (Length(Trim(sCodigoFabricante)) = 4) then // Sandro Silva 2017-06-12 if (Trim(sCodigoFabricante) <> '') then
  begin
    if StrToIntDef(Trim(sCodigoFabricante), -1) > -1 then
    begin
      sCodigoFabricante := FormatFloat('0000', StrToInt(Trim(sCodigoFabricante)));
      GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CODIGO_FABRICANTE, sCodigoFabricante);
    end
    else
      SmallMsg('C�digo do fabricante inv�lido');
  end;

  if Length(Trim(sCodigoFabricante)) <= 2 then
  begin
    sCodigoFabricante := FormatFloat('00', StrToIntDef(Trim(sCodigoFabricante), 0)) + '01';
    GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CODIGO_FABRICANTE, sCodigoFabricante);
  end;
end;

function _ecf59_ValidaKitDesenvolvimento: Boolean;
begin // Retorna True quando equipamento usado for KIT para desenvolvimento, observando se a assinatura associada for igual a uma das assinaturas padr�es para testes com os kit's
  Result := False;
  if (_59.AssinaturaAssociada = _59_ASSINATURA_ASSOCIADA_MFE) // MFE ELGIN
    or (_59.AssinaturaAssociada = _59_ASSINATURA_ASSOCIADA_INTEGRADOR)
    or (_59.AssinaturaAssociada = _59_ASSINATURA_ASSOCIADA_SAT) // SAT/MFE TANCA/BEMATECH
    or (_59.AssinaturaAssociada = _59_ASSINATURA_ASSOCIADA_EMULADOR_SP) // EMULADOR SEFAZ/SP
    then
    Result := True;
end;

procedure _ecf59_HabilitaUsarDriverMFE_1_05(bHabilitar: Boolean);
// Habilita o uso do driver de comunica��o com MFE vers�o 1.05 ou superior, dispensando o uso
// do integrador fiscal para comunicar-se com o MFE
begin
  try
    GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_VERSAO_DRIVER_MFE_1_05, IfThen(bHabilitar, 'Sim', 'N�o'));
  except

  end;

end;

{ TMobile }

constructor TMobile.Create;
begin
  inherited;
  FVendaImportando := '';
end;

destructor TMobile.Destroy;
begin
  inherited;
end;

procedure TMobile.SetVendaImportando(const Value: String);
begin
  FVendaImportando := Value;
end;

end.
