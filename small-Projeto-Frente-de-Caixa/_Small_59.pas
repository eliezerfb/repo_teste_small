{ *********************************************************************** }
{ Dados para emitir CF-e no MFE Ceará                                     }
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
{Unit criada seguindo como padrão as outras units de comunicação com ECF  }
{Possui as mesmas chamadas de funções, mas implementadas de acordo com os }
{equipamentos SAT e MFE                                                   }
{ *********************************************************************** }

unit _Small_59;

interface

uses

  Windows, Messages, Fiscal, SysUtils,Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Mask, Grids, DBGrids, DB, DBCtrls,
  IniFiles, ShellApi, Printers
  {$IFDEF VER150}
  , IBCustomDataSet, IBQuery, IBDatabase,
  {$ELSE}
  , IBX.IBDatabase, IBX.IBQuery, IBX.IBCustomDataSet
  {$ENDIF}
  , StrUtils, Variants
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
  const SAT_CODIGO_MEIO_PAGAMENTO_18_TRANSFERENCIA_BANCARIA_CARTEIRA_DIGITAL      = '18'; //Transferência bancária, Carteira Digital
  const SAT_CODIGO_MEIO_PAGAMENTO_19_PROGRAMA_FIDELIDADE_CASHBACK_CREDITO_VIRTUAL = '19'; //Programa de fidelidade, Cashback, Crédito Virtual
  const SAT_CODIGO_MEIO_PAGAMENTO_99_OUTROS                                       = '99';

  const SAT_MENSAGEM_AGUARDANDO_RESPOSTA_DO_SERVIDOR = 'Aguardando resposta do Servidor'; // Sandro Silva 2021-08-27 const SAT_MENSAGEM_AGUARDANDO_RESPOSTA_DO_SERVIDOR_SAT = 'Aguardando resposta do Servidor SAT';

  function ConsisteInscricaoEstadual(sIE, sUF: AnsiString): Boolean; StdCall; External 'DllInscE32.Dll';
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
  SmallFunc_xe
  , SMALL_DBEDIT
  , Unit2
  , Unit22
  , ufuncoesfrente
  , _Small_IntegradorFiscal
  , Unit10
  , umfe // Sandro Silva 2022-05-17 Após o prazo de 07/11/2022, tirar essa uses e eliminar as dependências relacionadas ao Integrador e Validador Fiscal das demais unit do projeto
  , ucadadquirentes
//  , upafecfmensagens
  , udadospos
  , Unit27
  , uimpressaopdf
  , uclassetransacaocartao
  , umontaxmlvendasat
  , Unit12
  , uConverteDocumentoParaDocFiscal;

function FormataFloatXML(dValor: Double; iDecimais: Integer): String;
begin
  Result := StringReplace(StrZero(dValor, 1, iDecimais), ',', '.', [rfReplaceAll]);
end;

function FormataDataSQL(Data: TDate): String;
// Sandro Silva 2011-10-13 inicio Formata a data no padrão sql
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
Extrai configuração existente no texto.
Quando existir mais de uma configuração deverão estar separadas por ponto e vírgula(;)
Inicialmente usado para configuração D101-Indicador da Natureza do Frete Contratado e
D101-Código da Base de Cálculo do Crédito}
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
const Especial = '|ÁÀÂÄÃÉÈÊËÍÌÎÏÓÒÔÖÕÚÙÜÛÇÝáàâäãéèêëíìîïóòôöõúùüûçýÿªº''';
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
  Result := '999'; // Outros sempre será o padrão
    
  if sCNPJ = '03.106.213/0001-90' then
    Result := '001'; // Administradora de Cartões Sicredi Ltda.
  if sCNPJ = '03.106.213/0002-71' then
    Result := '002'; // Administradora de Cartões Sicredi Ltda.(filial RS)
  if sCNPJ = '60.419.645/0001-95' then
    Result := '003'; // Banco American Express S/A - AMEX
  if sCNPJ = '62.421.979/0001-29' then
    Result := '004'; // BANCO GE - CAPITAL
  if sCNPJ = '58.160.789/0001-28' then
    Result := '005'; // BANCO SAFRA S/A
  if sCNPJ = '07.679.404/0001-00' then
    Result := '006'; // BANCO TOPÁZIO S/A
  if sCNPJ = '17.351.180/0001-59' then
    Result := '007'; // BANCO TRIANGULO S/A
  if sCNPJ = '04.627.085/0001-93' then
    Result := '008'; // BIGCARD Adm. de Convenios e Serv.
  if sCNPJ = '01.418.852/0001-66' then
    Result := '009'; // BOURBON Adm. de Cartões de Crédito
  if sCNPJ = '03.766.873/0001-06' then
    Result := '010'; // CABAL Brasil Ltda.
  if sCNPJ = '03.722.919/0001-87' then
    Result := '011'; // CETELEM Brasil S/A - CFI
  if sCNPJ = '01.027.058/0001-91' then
    Result := '012'; // CIELO S/A
  if sCNPJ = '03.529.067/0001-06' then
    Result := '013'; // CREDI 21 Participações Ltda.
  if sCNPJ = '71.225.700/0001-22' then
    Result := '014'; // ECX CARD Adm. e Processadora de Cartões S/A
  if sCNPJ = '03.506.307/0001-57' then
    Result := '015'; // Empresa Bras. Tec. Adm. Conv. Hom. Ltda. - EMBRATEC
  if sCNPJ = '04.432.048/0001-20' then
    Result := '016'; // EMPÓRIO CARD LTDA
  if sCNPJ = '07.953.674/0001-50' then
    Result := '017'; // FREEDDOM e Tecnologia e Serviços S/A
  if sCNPJ = '03.322.366/0001-75' then
    Result := '018'; // FUNCIONAL CARD LTDA.
  if sCNPJ = '03.012.230/0001-69' then
    Result := '019'; // HIPERCARD Banco Multiplo S/A
  if sCNPJ = '03.966.317/0001-75' then
    Result := '020'; // MAPA Admin. Conv. e Cartões Ltda.
  if sCNPJ = '00.163.051/0001-34' then
    Result := '021'; // Novo Pag Adm. e Proc. de Meios Eletrônicos de Pagto. Ltda.
  if sCNPJ = '43.180.355/0001-12' then
    Result := '022'; // PERNAMBUCANAS Financiadora S/A Crédito, Fin. e Invest.
  if sCNPJ = '00.904.951/0001-95' then
    Result := '023'; // POLICARD Systems e Serviços Ltda.
  if sCNPJ = '33.098.658/0001-37' then
    Result := '024'; // PROVAR Negócios de Varejo Ltda.
  if sCNPJ = '01.425.787/0001-04' then // Sandro Silva 2020-07-16 if sCNPJ = '01.425.787/0001-01' then
    Result := '025'; // REDECARD S/A
  if sCNPJ = '90.055.609/0001-50' then
    Result := '026'; // RENNER Adm. Cartões de Crédito Ltda.
  if sCNPJ = '03.007.699/0001-00' then
    Result := '027'; // RP Administração de Convênios Ltda.
  if sCNPJ = '00.122.327/0001-36' then
    Result := '028'; // SANTINVEST S/A Crédito, Financiamento e Investimentos
  if sCNPJ = '69.034.668/0001-56' then
    Result := '029'; // SODEXHO Pass do Brasil Serviços e Comércio S/A
  if sCNPJ = '60.114.865/0001-00' then
    Result := '030'; // SOROCRED Meios de Pagamentos Ltda.
  if sCNPJ = '51.427.102/0004-71' then
    Result := '031'; // Tecnologia Bancária S/A - TECBAN
  if sCNPJ = '47.866.934/0001-74' then
    Result := '032'; // TICKET Serviços S/A
  if sCNPJ = '00.604.122/0001-97' then
    Result := '033'; // TRIVALE Administração Ltda.
  if sCNPJ = '61.071.387/0001-61' then
    Result := '034'; // Unicard Banco Múltiplo S/A - TRICARD
  
  //ShowMessage('teste 01 384 ' + RESULT); // Sandro Silva 2020-07-16
end;

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
  // Sandro Silva 2017-08-02 Não deu certo  Result := Form1.Small_InputBox(pP1, pP2, pP3);
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
  if LoadLibrary(PChar(LibName)) = 0 then exit;
  LibHandle := GetModuleHandle(PChar(LibName));
  if LibHandle <> 0 then
  begin
    LibPointer := GetProcAddress(LibHandle, PChar(FuncName));
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
// a impressora está conectada               //
// MATRICIAL MECAF / BEMATECH MP 2000 CI NF  //
//-------------------------------------------//
function _ecf59_Inicializa(Pp1: String): Boolean;
var
  iTentativa: Integer;
  sMensagem: String;
  sNumeroSat: String;
  //sPathDll: String;
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
      Application.MessageBox(PChar('Acesse o Small e configure os dados do emitente ' + #13 +
                                   'e reinicie aplicação' + #13 + #13 +
                                   'Essa aplicação será fechada'),'Atenção', MB_ICONWARNING + MB_OK);
      FecharAplicacao(ExtractFileName(Application.ExeName));
      Abort;
    end;

    if (Form1.ibDataSet13.FieldByName('ESTADO').AsString = 'CE') then
    begin

      _59.TipoEquipamento := TIPO_EQUIPAMENTO_MFE;

      {Sandro Silva 2023-06-14 inicio
      if Form1.UsaIntegradorFiscal('') then
        _59.ModoOperacao    := moIntegradorMFE;
      }

      {Sandro Silva 2021-08-23 inicio}
      if FileExists('c:\Program Files (x86)\SEFAZ-CE\Driver MFE\Biblioteca de funções\mfe.dll') or FileExists('c:\Program Files\SEFAZ-CE\Driver MFE\Biblioteca de funções\mfe.dll') then
      begin

        if FileExists('c:\Program Files (x86)\SEFAZ-CE\Driver MFE\Biblioteca de funções\mfe.dll') then
          GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CAMINHO_DLL, 'c:\Program Files (x86)\SEFAZ-CE\Driver MFE\Biblioteca de funções\mfe.dll') // 64 bits
        else
          GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CAMINHO_DLL, 'c:\Program Files\SEFAZ-CE\Driver MFE\Biblioteca de funções\mfe.dll'); // 32 bits
          
        _ecf59_HabilitaUsarDriverMFE_1_05(True);

        Form1.ExibePanelMensagem('Driver MFE atualizado', True);
        Sleep(3000);
        Form1.OcultaPanelMensagem;

      end
      else
      begin
        _ecf59_HabilitaUsarDriverMFE_1_05(False);
        Form1.ExibePanelMensagem('Atualize o Driver MFE para versão mais atual', True);
        Sleep(3000);
        Form1.OcultaPanelMensagem;
      end;

      _59.DriverMFE01_05_15_Superior := (Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_VERSAO_DRIVER_MFE_1_05, 'Não')) = 'Sim');
      {Sandro Silva 2021-08-23 fim}

      {Sandro Silva 2023-06-14 inicio
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
      }
      
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
      _59.IntegradorMFE := Form1.IntegradorCE; // Aponta o componente Integrador dentro do SAT para o componente criado no form1 usado também para NFC-e Sandro Silva 2018-07-03

      {Sandro Silva 2023-06-14 inicio
      if Form1.UsaIntegradorFiscal() then
      begin

        if Form1.bBalancaAutonoma = False then // Sandro Silva 2019-01-23
        begin

          if InicializaIntegradorFiscal(Form22.Label6) = False then
            Abort;

        end;

      end;
      }

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
          if Application.MessageBox('O Equipamento SAT está conectado neste computador?', 'Conexão com SAT', MB_YESNO + MB_ICONINFORMATION + MB_DEFBUTTON1) = ID_NO then
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
          if Application.MessageBox('O Equipamento SAT está conectado neste computador?', 'Conexão com SAT', MB_YESNO + MB_ICONINFORMATION + MB_DEFBUTTON1) = ID_NO then
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

    //sPathDll             := Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CAMINHO_DLL, sPathDll));

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
      begin// Ajusta código do fabricante, passou a ter 4 dígitos para contemplar modelos diferente de sat do mesmo fabricante
        sCodigoFabricante := FormatFloat('00', StrToIntDef(Trim(sCodigoFabricante), 0)) + '01';
        GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CODIGO_FABRICANTE, sCodigoFabricante);
      end;

      if Trim(sCNPJSoftwareHouse) = '' then
      begin
        sCNPJSoftwareHouse := LimpaNumero(CNPJ_SOFTWARE_HOUSE_PAF);
        GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CNPJ_SOFTWARE_HOUSE, sCNPJSoftwareHouse);
      end;

      if Trim(sCodigoAtivacao) = '' then
      begin
        if Form1.bBalancaAutonoma = False then // Sandro Silva 2019-01-23
        begin
          sCodigoAtivacao := Small_InputBox('Código de ativação', 'Informe o código de ativação do ' + _59.TipoEquipamento + ':', sCodigoAtivacao); // Sandro Silva 2018-07-03  Small_InputBox('Código de ativação', 'Informe o código de ativação do ' + NOME_CUPOM_59 + ':', sCodigoAtivacao);

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
    // Emulador e Gertec precisa declarar as chamadas das funções como CDELC
    // Opção para configurar outros modelos
    if ((_59.FabricanteCodigo = FABRICANTE_EMULADOR) or (_59.FabricanteCodigo = FABRICANTE_GERTEC))
      and (Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_METODO_CHAMADA_DLL_ALTERNATIVO, '')) = '') then
      SalvarConfiguracao(FRENTE_INI, SECAO_59, _59_CHAVE_METODO_CHAMADA_DLL_ALTERNATIVO, 'Sim');

    _59.MetodoChamadaDLL      := mcStdCall;
    if Trim(LerParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_METODO_CHAMADA_DLL_ALTERNATIVO, 'Não')) = 'Sim' then
      _59.MetodoChamadaDLL    := mcCdecl;

    _59.CaminhoInstalado  := Form1.sAtual; // Sandro Silva 2017-02-14

    if (_59.TipoEquipamento <> TIPO_EQUIPAMENTO_MFE) then // Sandro Silva 2017-05-24
    begin
      // Ceará utiliza Integrador Fiscal que permite gerenciamento de "n" PDV em um equipamento SAT

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
        Application.MessageBox(PChar('Configure o código de ativação do ' + _59.TipoEquipamento + ' no arquivo FRENTE.INI' + #13 + // Sandro Silva 2018-07-03  'Configure o código de ativação do SAT no arquivo FRENTE.INI' + #13 +
                                     'e reinicie aplicação' + #13 + #13 +
                                     'Essa aplicação será fechada'),'Atenção', MB_ICONWARNING + MB_OK);
        FecharAplicacao(ExtractFileName(Application.ExeName));
        Abort;
      end;

      if Trim(_59.CaminhoSATDLL) = '' then
      begin
        Application.MessageBox(PChar('Configure o caminho e nome da DLL de comunicação com ' + _59.TipoEquipamento + ' no arquivo FRENTE.INI' + #13 + // Sandro Silva 2018-07-03  'Configure o caminho e nome da DLL de comunicação com SAT no arquivo FRENTE.INI' + #13 +
                                     'e reinicie aplicação' + #13 + #13 +
                                     'Essa aplicação será fechada'),'Atenção', MB_ICONWARNING + MB_OK);
        FecharAplicacao(ExtractFileName(Application.ExeName));
        Abort;
      end;

      if Trim(_59.Fabricante) = '' then
      begin
        Application.MessageBox(PChar('Configure o fabricante do equipamento ' + _59.TipoEquipamento + ' no arquivo FRENTE.INI' + #13 + // Sandro Silva 2018-07-03  'Configure o fabricante do equipamento SAT no arquivo FRENTE.INI' + #13 +
                                     'e reinicie aplicação' + #13 + #13 +
                                     'Essa aplicação será fechada'),'Atenção', MB_ICONWARNING + MB_OK);
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

    {Sandro Silva 2023-06-14 inicio
    if Form1.UsaIntegradorFiscal(Form1.ibDataSet13.FieldByName('ESTADO').AsString) then // Sandro Silva 2022-07-12
    begin

      if Trim(LerParametroIni(FRENTE_INI, SECAO_MFE, CHAVE_VENDA_NO_CARTAO, '')) = '' then
      begin

        if Form1.bBalancaAutonoma = False then // Sandro Silva 2019-01-23
        begin
          if QtdAdquirentes = 0 then
          begin

            Application.MessageBox(PChar('Configure os dados das adquirentes de cartões'), 'Atenção', MB_ICONWARNING + MB_OK);

            SalvarConfiguracao(FRENTE_INI, SECAO_MFE, CHAVE_VENDA_NO_CARTAO, 'Não');

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
    }
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
            Application.MessageBox(PChar('O número de série do equipamento mudou' + #10 + #10 +
              'Configure um novo número de caixa para identificar as vendas deste PDV' + #10 + #10 +
              'O número do caixa não pode ter sido usado anteriormente'),'Atenção', MB_ICONINFORMATION + MB_OK);


            GravarParametroIni(FRENTE_INI, SECAO_59, 'Numero', sNumeroSat);
            _59.Caixa      := _ecf59_ConfiguraCaixaSAT(_59.Caixa); // Sandro Silva 2017-02-22
            SalvarConfiguracao(FRENTE_INI, SECAO_FRENTE_CAIXA, 'Caixa', _59.Caixa);

            Application.MessageBox(PChar('Essa aplicação será fechada' + #10 + #10 +
              'Reinicie a aplicação para usar o novo número do caixa configurado'),'Atenção', MB_ICONINFORMATION + MB_OK);
            }
            Application.MessageBox(PChar('O número de série do equipamento mudou' + #10 + #10 +
              'Será configurado um novo número de caixa para identificar as vendas deste PDV'),'Atenção', MB_ICONINFORMATION + MB_OK);

            GravarParametroIni(FRENTE_INI, SECAO_59, 'Numero', sNumeroSat);
            _59.Caixa      := _ecf59_ConfiguraCaixaSAT(_59.Caixa, True); // Sandro Silva 2017-02-22
            _ecf59_CriaSequencialCaixa(_59.Caixa);
            SalvarConfiguracao(FRENTE_INI, SECAO_FRENTE_CAIXA, 'Caixa', _59.Caixa);

            Commitatudo(True);

            Application.MessageBox(PChar('Essa aplicação será fechada' + #10 + #10 +
              'Reinicie a aplicação para usar o novo número do caixa configurado'),'Atenção', MB_ICONINFORMATION + MB_OK);

            FecharAplicacao(ExtractFileName(Application.ExeName));

            Abort;

          end;
        end;
        {Sandro Silva 2021-03-03 fim}

        try
          if Trim(ConverteAcentos2(_59.MensagemSEFAZ)) <> '' then
          begin
            sStatusOperacional := sStatusOperacional + #13 + 'Mensagem da SEFAZ: ' + _59.MensagemSEFAZ;
            Application.MessageBox(PChar('Mensagem da SEFAZ:' + #13 + #13 + _59.MensagemSEFAZ), 'Informação', MB_ICONINFORMATION + MB_OK);
          end;

          if Form1.bBalancaAutonoma = False then // Sandro Silva 2019-01-23
          begin
            if (_59.RetornoStatusOperacional.EEEEE <> '10000') or _59.BloqueioAutonomo then
            begin
              if _59.ModoOperacao <> moServer then
                if Trim(sStatusOperacional) <> '' then
                  Application.MessageBox(PChar(sStatusOperacional),'Retorno Status Operacional', MB_ICONINFORMATION + MB_OK);
            end;

            if _59.BloqueioAutonomo then
              Application.MessageBox(PChar( 'Seu equipamento ' + _59.TipoEquipamento + ' está sob BLOQUEIO AUTÔNOMO, devido:' + #10 + // Sandro Silva 2018-07-03  'Seu equipamento SAT está sob BLOQUEIO AUTÔNOMO, devido:' + #10 +
                                           '- Falta de comunicação com qualquer um dos Web services da SEFAZ;' + #10 +
                                           '- Presença de CF-e na memória de trabalho do equipamento ' + _59.TipoEquipamento + ', emitido e não transmitido a mais tempo do que o valor em horas pré-determinado;' + #10 +// Sandro Silva 2018-07-03  '- Presença de CF-e na memória de trabalho do equipamento SAT-CF-e, emitido e não transmitido a mais tempo do que o valor em horas pré-determinado;' + #10 +
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
          if Trim(LerParametroIni(FRENTE_INI, 'NFCE', 'Contingencia', 'Não')) = 'Sim' then
          begin // 2015-07-09 NFCe ativou contingência
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

        {Sandro Silva 2023-06-14 inicio
        if Form1.UsaIntegradorFiscal() then
        begin
          if (Form1.ibDataSet13.FieldByName('ESTADO').AsString = 'CE') then
          begin
            Form1.DriverMFE010515ousuperior1.Visible := True;
          end;
          Form1.DriverMFE010515ousuperior1.Checked := _59.DriverMFE01_05_15_Superior;
        end;
        }

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

        Form1.NFCenoperodo1.Caption                   := NomeModeloDocumento('59') + ' no período...'; // Sandro Silva 2020-08-24 Form1.NomeModeloDocumento('59') + ' no período...';  // Sandro Silva 2018-07-03  'CF-e-SAT no período'; // Sandro Silva 2018-06-04
        Form1.ConsultarStatusdoServio1.Caption        := 'Consultar ' + _59.TipoEquipamento + '...'; // Sandro Silva 2018-07-03 'Consultar SAT...';
        Form1.GerenciadordeNFCe1.Caption              := 'Gerenciador de ' + NomeModeloDocumento('59'); // Sandro Silva 2020-08-24 'Gerenciador de ' + Form1.NomeModeloDocumento('59');  // Sandro Silva 2018-07-03 NOME_CUPOM_59;// 2014-04-02 'Gerenciador de S@T-CFe';
        Form1.ConfigurarlogotipodoDANFE1.Caption      := 'Configurar logotipo do Extrato do ' + NomeModeloDocumento('59') + '...'; // Sandro Silva 2020-08-24 'Configurar logotipo do Extrato do ' + Form1.NomeModeloDocumento('59') + '...';   // Sandro Silva 2018-07-03 'Configurar logotipo do Extrato do ' + NOME_CUPOM_59 + '...';
        Form1.DANFCEdetalhado1.Caption                := 'Imprimir Extrato ' + NomeModeloDocumento('59') + ' detalhado'; // Sandro Silva 2020-08-24 'Imprimir Extrato ' + Form1.NomeModeloDocumento('59') + ' detalhado';   // Sandro Silva 2018-07-03 'Imprimir Extrato ' + NOME_CUPOM_59 + ' detalhado';
        Form1.IDTokenNFCE1.Caption                    := 'Código de ativação do ' + _59.TipoEquipamento;// Sandro Silva 2018-07-03 'Código de ativação do SAT';  // 2014-04-02 'Código de ativação S@T-CFe';
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
        Form1.SATInicializaoAlternativa1.Caption      := 'Inicialização Alternativa do ' + _59.TipoEquipamento;
        Form1.VersodoleiautedoCFeSAT1.Caption         := 'Versão do Leiaute do ' + NomeModeloDocumento('59'); // Sandro Silva 2020-08-24 'Versão do Leiaute do ' + Form1.NomeModeloDocumento('59');

        Form1.VisualizarDANFCE1.Checked          := (LerParametroIni(FRENTE_INI, SECAO_59, 'Visualizar Extrato', 'Não') = 'Sim');

        _59.VisualizarExtrato := Form1.VisualizarDANFCE1.Checked;

        //Form1.EnviaraNFCe1.
        //Form1.VisualizarDANFCE1.Visible      := False;
        //Form1.VisualizaroDANFCE1.Visible     := False;
        Form1.Versodolayout1.Visible         := False;
        Form1.EnviaraNFCe1.Visible           := False;
        Form1.EnviaroDANFCEporeMail1.Visible := True;
        {Sandro Silva 2014-01-28 final}
        Form1.VersodoManualdaNFCe1.Visible   := False; // Sandro Silva 2016-06-15
        // Ativar se necessário Form1.VersodoleiautedoCFeSAT1.Visible := True; // Sandro Silva 2016-06-15
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
          // Elgin tem SAT Linker e Linker II. Por padrão tenta usar dll do Linker. Se falhar usa dll do Linker II
          GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CAMINHO_DLL, 'DLLSAT\ELGIN\LinkerII\dllsat.dll');
          Break;
        end
        else
        begin
          case iTentativa of
            1:
              begin
                sMensagem := 'Não foi possível estabelecer comunicação com o ' + _59.TipoEquipamento; // Sandro Silva 2018-07-03 'Não foi possível estabelecer comunicação com o SAT';
                if Pos('ERRO DESCONHECIDO', AnsiUpperCase(_59.Retorno)) > 0 then
                  SmallMsg('Feche o ' + NOME_APLICATIVO_59 + #13 +
                              'Desligue e ligue novamente o equipamento ' + _59.TipoEquipamento + #13 + // Sandro Silva 2018-07-03  'Desligue e ligue novamente o equipamento SAT' + #13 +
                              'Aguarde até que o ' + _59.TipoEquipamento + ' tenha completado sua inicialização' + #13 + // Sandro Silva 2018-07-03  'Aguarde até que o SAT tenha completado sua inicialização' + #13 +
                              'Abra novamente o ' + NOME_APLICATIVO_59);

              end;
            2: sMensagem := 'Verifique se o ' + _59.TipoEquipamento + ' está ligado'; // Sandro Silva 2018-07-03  'Verifique se o SAT está ligado';
            3: sMensagem := 'Verifique se o ' + _59.TipoEquipamento + ' está conectado ao computador'; // Sandro Silva 2018-07-03 'Verifique se o SAT está conectado ao computador';
            4: sMensagem := 'Verifique se o ' + _59.TipoEquipamento + ' não está sendo atualizado pela SEFAZ';// Sandro Silva 2018-07-03  'Verifique se o SAT não está sendo atualizado pela SEFAZ';
          end;

          sMensagem := sMensagem + #10 + #13 + #10 + #13 + _59.StatusRetornoSAT(_59.Retorno) + #10 + #13 + #10 + #13 + 'Tentar novamente?';

          if Application.MessageBox(PChar(sMensagem), 'Atenção', MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON1) = idNo then
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
  FormatSettings.DecimalSeparator := ',';
  FormatSettings.DateSeparator    := '/';
  //
end;
// ------------------------------ //
// Fecha o cupom que está sendo   //
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
      // Não conseguiu autorizar a venda porque a assinatura não está vinculada no equipamento
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
// Cancela o último item          //
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
// Retorna o número do Cupom        //
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
        Form1.IBDataSet150.FieldByName('NUMERONF').AsString := Result;
        Form1.IBDataSet150.FieldByName('DATA').AsDateTime   := Date;
        Form1.IBDataSet150.FieldByName('CAIXA').AsString    := Form1.sCaixa;
        Form1.IBDataSet150.FieldByName('MODELO').AsString   := '59';
        Form1.IBDataSet150.Post;
        //
        {Sandro Silva 2023-08-22 inicio
        Mais1Ini.WriteString('NFCE','CUPOM',Result);
        }
        GravaNumeroCupomFrenteINI(Result, '59'); // Sandro Silva 2023-08-22
        {Sandro Silva 2023-08-22 fim}                     

        //SmallMsg('Próximo Número: ' + Result); // 2015-06-22
        //
      except end;
    end else
    begin
      //
      try
        {Sandro Silva 2023-08-22 inicio
        Result := FormataNumeroDoCupom(StrToInt(Mais1Ini.ReadString('NFCE','CUPOM','000001')));
        }
        Result := FormataNumeroDoCupom(StrToInt(LeNumeroCupomFrenteINI('59', '000001')));
        {Sandro Silva 2023-08-22 fim}
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
  Garantir que Result não tenha quantidade de caractéres além da capacidade com campo onde será gravado}
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
        Rewrite(FLocal);                           // Abre para gravação
        //
        // Para mudar a sequencia de caracteres para abrir a gaveta
        // editar o arquivo frente.ini com os seguintes valores:
        //
        // [Impressora Fiscal]
        // Abre Gaveta=027,118,140
        // Abre Gaveta=027,112,027
        //
        // Onde os valores entre as virgolas representão um chr.
        //
        try
           Writeln(FLocal,Chr(StrToInt(Copy(Mais1Ini.ReadString('Frente de Caixa','Abre Gaveta','027,118,140'),1,3)))
                        + Chr(StrToInt(Copy(Mais1Ini.ReadString('Frente de Caixa','Abre Gaveta','027,118,140'),5,3)))
                        + Chr(StrToInt(Copy(Mais1Ini.ReadString('Frente de Caixa','Abre Gaveta','027,118,140'),9,3))));
        except
          SmallMsg('Dados inválidos na chave "Abre Gaveta".')
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
      except SmallMsg('Dados inválidos na chave "Abre Gaveta".') end;
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
  SmallMsg('Função não suportada pelo modelo de ECF utilizado.');
  Result := True;
end;

function _ecf59_LeituraMemoriaFiscal(pP1, pP2: String): Boolean;
begin
  SmallMsg('Função não suportada pelo modelo de ECF utilizado.');
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
  SmallMsg('Função não suportada pelo modelo de ECF utilizado.');
  Result := True;
end;

// -------------------------------- //
// Leitura X                        //
// -------------------------------- //
function _ecf59_LeituraX(pP1: Boolean): Boolean;
begin
  SmallMsg('Função não suportada pelo modelo de ECF utilizado.');
  Result := True;
end;

// ---------------------------------------------- //
// Retorna se o horario de verão está selecionado //
// ---------------------------------------------- //
function _ecf59_RetornaVerao(pP1: Boolean): Boolean;
begin
  Result := False;
end;

// -------------------------------- //
// Liga ou desliga horário de verao //
// -------------------------------- //
function _ecf59_LigaDesLigaVerao(pP1: Boolean): Boolean;
begin
  Result := True;
end;

// -------------------------------- //
// Retorna a versão do firmware     //
// -------------------------------- //
function _ecf59_VersodoFirmware(pP1: Boolean): String;
begin
  Result := 'SAT-CFe';
end;

// -------------------------------- //
// Retorna o número de série        //
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
// Retorna o número de cancelamentos //
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
// Retorna o número de operações    //
// não fiscais acumuladas           //
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
// Importante retornar apenas 3 dígitos //
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
  Result := Copy(FormatSettings.CurrencyString,1,1);
end;

function _ecf59_Dataehoradaimpressora(pP1: Boolean): String;
begin
  FormatSettings.ShortDateFormat := 'dd/mm/yy';   {Bug 2001 free}
  Result := StrTran(StrTran(Copy(DateToStr(Date),1,8)+TimeToStr(Time),'/',''),':','');
  FormatSettings.ShortDateFormat := 'dd/mm/yyyy';   {Bug 2001 free}
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
// Os 2 primeiros dígitos são o número de aliquotas gravadas: Ex 16       //
// os póximos de 4 em 4 são as aliquotas Ex: 1800                         //
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
  Result := Form1.ImpressaoNaoSujeitoaoICMS(sP1, bPDF, LarguraPapel);// Sandro Silva 2018-06-04 SAT e NFC-e usando mesma função para impressão gerencial
end;

function _ecf59_FechaCupom2(sP1: Boolean): Boolean;
begin
  Result := True;
end;

//                                      //
// Imprime cheque - Parametro é o valor //
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
  Result := False;// Sempre começa como falso. Verdadeiro somente se encontrar pendente

  {Sandro Silva 2023-08-22 inicio
  Mais1ini  := TIniFile.Create(FRENTE_INI);

  //
  try
    sCupom := FormataNumeroDoCupom(StrToInt(Mais1Ini.ReadString('NFCE','CUPOM','000001'))); // Sandro Silva 2021-12-02 sCupom := StrZero(StrToInt(Mais1Ini.ReadString('NFCE','CUPOM','000001')),6,0);
  except
    sCupom := FormataNumeroDoCupom(0); // Sandro Silva 2021-12-02 sCupom := '000000';
  end;
  //
  Mais1Ini.Free;
  }
  try
    sCupom := FormataNumeroDoCupom(StrToInt(LeNumeroCupomFrenteINI('59', '000001')));
  except
    sCupom := FormataNumeroDoCupom(0); // Sandro Silva 2021-12-02 sCupom := '000000';
  end;
  {Sandro Silva 2023-08-22 fim}

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
    // Sandro Silva 2018-07-31 CF-e não autorizado
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
Não utilizando FechaCupom() por que quando essa função é chamada ainda não foi digitado as formas de pagamento}
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
  FIBQuery65: TIBQuery;
  sNumeroGerencialConvertido: String;
  ConverteVenda: TConverteVendaParaNovoDocFiscal;
  FormasPagamento59: TPagamentoPDV;
  TransacoesCartao59: TTransacaoFinanceira;
  ModalidadeTransacao59: TTipoModalidadeTransacao;
begin
  Result := False;
  tInicio := Now;

  Form1.ExibePanelMensagem('Aguarde, enviando ' + NomeModeloDocumento('59') + '...', True);

  Commitatudo2(False);

  FIBQuery65 := CriaIBQuery(Form1.ibDataSet27.Transaction);

  try
    FIBQuery65.Close;
    FIBQuery65.SQL.Text :=
      'select A.PEDIDO, A.DATA ' +
      'from ALTERACA A ' +
      'where A.PEDIDO = ' + QuotedStr(FormataNumeroDoCupom(Form1.icupom)) + // Sandro Silva 2021-11-29 'where A.PEDIDO = ' + QuotedStr(StrZero(Form1.icupom,6,0)) +
      ' and A.CAIXA = ' + QuotedStr(Form1.sCaixa) +
      ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
      ' group by A.PEDIDO, A.DATA ' +
      ' order by DATA desc';
    FIBQuery65.Open;

    dtDataCupom := FIBQuery65.FieldByName('DATA').AsDateTime;

    FIBQuery65.Close;
    FIBQuery65.SQL.Text :=
      'select count(A.ITEM) as NUM_ITENS ' +
      'from ALTERACA A ' +
      'where A.PEDIDO = ' + QuotedStr(FormataNumeroDoCupom(Form1.icupom)) + // Sandro Silva 2021-11-29 'where A.PEDIDO = ' + QuotedStr(StrZero(Form1.icupom,6,0)) +
      ' and A.CAIXA = ' + QuotedStr(Form1.sCaixa) +
      ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
      ' and A.DESCRICAO <> ''Desconto'' ' +
      ' and A.DESCRICAO <> ''Acréscimo'' ' +
      ' and A.DESCRICAO <> ''<CANCELADO>'' ';
    FIBQuery65.Open;

    if FIBQuery65.FieldByName('NUM_ITENS').AsInteger = 0 then
    begin
      if (Form1.ClienteSmallMobile.sVendaImportando = '') then
        SmallMsg('Nenhum item encontrado' + #13 + 'Cupom não pode ser fechado');
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
    _59.VisualizarExtrato := (LerParametroIni(FRENTE_INI, SECAO_59, 'Visualizar Extrato', 'Não') = 'Sim');//Form1.VisualizarDANFCE1.Checked;
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
          Form1.ExibePanelMensagem('Atenção! ' + _59.MensagemSEFAZ);
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
              Form1.ExibePanelMensagem('Atenção! Ajuste o cadastro de emitente. CRT diferentes' + #13 +
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

        {Sandro Silva 2023-09-20 inicio
        // Neste ponto já o sat autorizou a venda, não tem porque mudar os valores nas formas de pagamento gravadas em PAGAMENT
        try
          if Form1.ibDataSet25ACUMULADO3.AsFloat > 0 then // ACUMULADO3 = TROCO
          begin
            if Form1.ibDataSet25ACUMULADO2.AsFloat > Form1.ibDataSet25ACUMULADO3.AsFloat then //ACUMULADO2 = DINHEIRO
            begin
              Form1.ibDataSet25ACUMULADO2.AsFloat := Form1.ibDataSet25ACUMULADO2.AsFloat - Form1.ibDataSet25ACUMULADO3.AsFloat;
            end else
            begin
              if Form1.ibDataSet25ACUMULADO1.AsFloat > Form1.ibDataSet25ACUMULADO3.AsFloat then // ACUMULADO1 = CHEQUE
              begin
                Form1.ibDataSet25ACUMULADO1.AsFloat := Form1.ibDataSet25ACUMULADO1.AsFloat - Form1.ibDataSet25ACUMULADO3.AsFloat;
              end;
            end;
          end;
        except

        end;
        }

        Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible  := False;
        //
        try
          //
          FIBQuery65.Close;
          FIBQuery65.SQL.Text :=
            'select GERENCIAL, DATA from NFCE where NUMERONF = ' + QuotedStr(FormataNumeroDoCupom(Form1.iCupom)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa) + ' and MODELO = ' + QuotedStr('59'); // Sandro Silva 2023-07-31 'select DATA from NFCE where NUMERONF = ' + QuotedStr(FormataNumeroDoCupom(Form1.iCupom)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa) + ' and MODELO = ' + QuotedStr('59'); // Sandro Silva 2021-11-29 'select DATA from NFCE where NUMERONF = ' + QuotedStr(StrZero(Form1.iCupom,6,0)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa) + ' and MODELO = ' + QuotedStr('59'); 
          FIBQuery65.Open;

          sNFCEDataOld := FIBQuery65.FieldByName('DATA').AsString;

          {Sandro Silva 2023-07-31 inicio}
          sNumeroGerencialConvertido := FIBQuery65.FieldByName('GERENCIAL').AsString; //  Recupera o número da venda gerencial, caso tenha sido importada
          {Sandro Silva 2023-07-31 fim}

          FIBQuery65.Close;
          FIBQuery65.SQL.Clear;
          FIBQuery65.SQL.Add('delete from NFCE where NUMERONF = ' + QuotedStr(FormataNumeroDoCupom(Form1.iCupom)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa) + ' and MODELO = ' + QuotedStr('59')); // Sandro Silva 2021-11-29 FIBQuery65.SQL.Add('delete from NFCE where NUMERONF = ' + QuotedStr(StrZero(Form1.iCupom,6,0)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa) + ' and MODELO = ' + QuotedStr('59'));
          FIBQuery65.ExecSQL;

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
          {Sandro Silva 2023-07-31 inicio}
          Form1.IBDataSet150.FieldByName('GERENCIAL').Clear;
          if Trim(sNumeroGerencialConvertido) <> '' then
            Form1.IBDataSet150.FieldByName('GERENCIAL').AsString   := sNumeroGerencialConvertido;
          {Sandro Silva 2023-07-31 fim}
          Form1.IBDataSet150.Post;

          //
          Form1.ibDataset150.Close;

          //Seleciona novamente o itens para alterar o número do pedido para o número do CFe
          Form1.ibDataSet27.Close;
          Form1.ibDataSet27.SelectSQL.Text :=
            'select * from ALTERACA where CAIXA='+QuotedStr(Form1.sCaixa)+' and PEDIDO='+QuotedStr(FormataNumeroDoCupom(Form1.icupom)) + // Sandro Silva 2021-11-29 'select * from ALTERACA where CAIXA='+QuotedStr(Form1.sCaixa)+' and PEDIDO='+QuotedStr(StrZero(Form1.icupom,6,0)) +
            ' and COO is null'; // Apenas os itens da venda atual. Para separar de vendas anteriores com mesmo número do caixa
          Form1.ibDataSet27.Open;

          sDAV     := '';
          sTIPODAV := '';
          sAlteracaPedidoOld := Form1.ibDataSet27.FieldByName('PEDIDO').AsString;

          if Form1.sOrcame <> '' then
          begin
            sDAV     := Form1.sOrcame;
            sTIPODAV := 'ORÇAMENTO';
          end;

          if Form1.sOs <> '' then
          begin
            sDAV     := Form1.sOs;
            sTIPODAV := 'OS';
          end;

          {Sandro Silva 2023-08-25 inicio
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
          }
          AtualizaNumeroPedidoTabelaPendencia(Form1.ibDataSet27.Transaction, Form1.sCaixa, sAlteracaPedidoOld, Right(sCFe, 6), Form1.sCaixa);
          {Sandro Silva 2023-08-25 fim}  

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
              // NFC-e não grava COO e CCF para os descontos e acréscimos
              //
              if (Form1.ibDataSet27.FieldByName('COO').AsString = '') and (Form1.ibDataSet27.FieldByName('CCF').AsString = '') then // Não atualizar número do CF-e em vendas antigas de ECF
              begin

                try
                  // Produtos com controle de número de série
                    if (Form1.ibDataSet27.FieldByName('CODIGO').AsString <> '') and
                      ((Form1.ibDataSet27.FieldByName('TIPO').AsString = 'BALCAO') or (Form1.ibDataSet27.FieldByName('TIPO').AsString = 'LOKED')) then
                    begin
                      // Seleciona o produto na tabela SERIE, com a data e o número temporário da venda, para atualizar com a data e o número do CF-e gerados pelo SAT
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

          Form1.AtualizaDetalhe(Form1.ibDataSet27.Transaction, sTIPODAV, sDAV, Form1.sCaixa, Form1.sCaixa, sCFe, 'Fechada');

          // Seleciona novamente os dados para usar na sequência da venda
          Form1.ibDataSet27.Close;
          Form1.ibDataSet27.SelectSQL.Text :=
            'select * from ALTERACA where CAIXA='+QuotedStr(Form1.sCaixa)+' and PEDIDO='+QuotedStr(FormataNumeroDoCupom(StrToInt(sCFe))); // Sandro Silva 2021-12-01 'select * from ALTERACA where CAIXA='+QuotedStr(Form1.sCaixa)+' and PEDIDO='+QuotedStr(StrZero(StrToInt(sCFe),6,0));
          Form1.ibDataSet27.Open;
          Form1.ibDataSet27.Last;

          {Sandro Silva 2023-08-28 inicio
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
          }

          // Receber
          {Sandro Silva 2023-08-30 inicio}
          Form1.ibDataSet7.Close;
          Form1.ibDataSet7.SelectSQL.Text := 'select * from RECEBER where NUMERONF = ' + QuotedStr(FormataNumeroDoCupom(Form1.icupom)+Copy(Form1.sCaixa, 1, 3));
          Form1.ibDataSet7.Open;
          {Sandro Silva 2023-08-30 fim}

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

          FormasPagamento59 := TPagamentoPDV.Create;
          TransacoesCartao59 := TTransacaoFinanceira.Create(nil); 

          AtualizaDadosPagament(Form1.ibDataSet28, {Form1.ibDataSet28.Transaction,} Form1.sModeloECF, Form1.sCaixa,
            FormataNumeroDoCupom(Form1.icupom), Form1.sCaixa, FormataNumeroDoCupom(StrToInt(sCFe)), _59.CFedEmi,
            Form1.sConveniado, Form1.sVendedor, FormasPagamento59, Form1.fTEFPago, TransacoesCartao59, ModalidadeTransacao59);
          FreeAndNil(FormasPagamento59);
          FreeAndNil(TransacoesCartao59);
          {Sandro Silva 2023-08-25 fim}


          // Por último atualiza a variável com o número do cupom SAT
          Form1.icupom := StrToInt(sCFe);
          Form1.iGNF   := StrToInt(sCFe);

          //
        except end;
        //
        Form1.Label_7.Hint := 'Tempo de envio e impressão: '+' '+FormatDateTime('HH:nn:ss', Now - TInicio)+' ';

        // 2015-07-09 if Form1.bImportando = False then
        if (Form1.ClienteSmallMobile.sVendaImportando = '') then
        begin
          if _59.VisualizarExtrato then
            _ecf59_Visualiza_DANFECE(sCFe, _59.CFeXML);

          // Não retornar False se não imprimir ou enviar o email
          // False apenas se não conseguir gerar CF-e-SAT
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
                  // Após upload exclui o arquivo
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
          end; // não é contingência if Pos(TIPOCONTINGENCIA, Form1.ClienteSmallMobile.sVendaImportando) = 0 then
        end;// Importando SmallMobile

        IncrementaGenerator(_59_PREFIXO_GENERATOR_CAIXA_SAT + Form1.sCaixa, 1);// Para garantir que o generator nunca fique com o mesmo número sequencial do SAT // Sandro Silva 2021-03-05 IncrementaGenerator('G_NUMEROCFESAT_' + Form1.sCaixa, 1); // 2015-07-21

      end
      else
      begin

        // Ocorreu erro na emissão do CF-e-SAT

        if Form1.Panel3.Visible then
          Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible := False;

        try
          //
          // Seleciona o último registro com o NUMERONF = iCupom
          Form1.ibDataset150.Close;
          Form1.ibDataset150.SelectSql.Clear;
          Form1.ibDataset150.SelectSQL.Add('select first 1 * from NFCE where coalesce(NFEID, '''') = '''' and NUMERONF='+QuotedStr(FormataNumeroDoCupom(Form1.iCupom)) + ' order by REGISTRO desc'); // Sandro Silva 2021-11-29 Form1.ibDataset150.SelectSQL.Add('select first 1 * from NFCE where coalesce(NFEID, '''') = '''' and NUMERONF='+QuotedStr(StrZero(Form1.iCupom,6,0)) + ' order by REGISTRO desc');
          Form1.ibDataset150.Open;

          // Salva o XML para poder analisar os dados lançados
          Form1.IBDataSet150.Edit;
          Form1.IBDataSet150.FieldByName('NFEXML').AsString := _59.XMLDadosVenda; // Sandro Silva 2021-11-17 Form1.IBDataSet150.FieldByName('NFEXML').AsString := _59.CfeXML;
          Form1.IBDataSet150.FieldByName('CAIXA').AsString  := Form1.sCaixa;
          Form1.IBDataSet150.FieldByName('MODELO').AsString := '59';
          Form1.IBDataSet150.FieldByName('STATUS').AsString := Copy(_59.CFeStatus + ' ' + Trim(sLog), 1, Form1.IBDataSet150.FieldByName('STATUS').Size); // Sandro Silva 2021-11-17 Form1.IBDataSet150.FieldByName('STATUS').AsString := Copy(_59.CFeStatus, 1, Form1.IBDataSet150.FieldByName('STATUS').Size);
          Form1.IBDataSet150.Post;
          //
          Form1.ibDataset150.Close;


          {Sandro Silva 2023-08-25 inicio}
          ConverteVenda := TConverteVendaParaNovoDocFiscal.Create;
          ConverteVenda.ModeloOld         := '59';
          ConverteVenda.Caixa             := Form1.sCaixa;
          ConverteVenda.ModeloDocumento   := Form1.sModeloECF;
          ConverteVenda.IBTransaction     := Form1.ibDataSet27.Transaction;
          ConverteVenda.IBDataSet27       := Form1.IBDataSet27;
          ConverteVenda.IBDataSet30       := Form1.IBDataSet30;
          ConverteVenda.IBDataset150      := Form1.IBDataSet150;
          ConverteVenda.IBDataSet7        := Form1.IBDataSet7;
          ConverteVenda.IBDataSet28       := Form1.IBDataSet28;
          ConverteVenda.IBDataSet25       := Form1.ibDataSet25;
          ConverteVenda.TransacoesCartao  := Form1.TransacoesCartao;
          ConverteVenda.NomeDoTEF         := Form10.sNomeDoTEF;
          ConverteVenda.DebitoOuCredito   := Form1.sDebitoOuCredito;
          ConverteVenda.sConveniado       := Form1.sConveniado;
          ConverteVenda.sVendedor         := Form1.sVendedor;
          ConverteVenda.NumeroGerencial   := FormataNumeroDoCupom(Form1.iCupom);
          ConverteVenda.Converte;
          FreeAndNil(ConverteVenda);
          {Sandro Silva 2023-08-25 fim}

        except

        end;

        if (Form1.ClienteSmallMobile.sVendaImportando = '') then
        begin

          if (_59.LogComando <> '') then
          begin
            Application.MessageBox(PChar(_59.LogComando), 'Atenção', MB_ICONWARNING + MB_OK);
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

          {Sandro Silva 2023-08-22 inicio
          GravarParametroIni(FRENTE_INI, 'NFCE', 'CUPOM', FormataNumeroDoCupom(0));
          }
          GravaNumeroCupomFrenteINI(FormataNumeroDoCupom(0), '59'); // Sandro Silva 2023-08-22
          {Sandro Silva 2023-08-22 fim}


          if DirectoryExists(Form1.sAtual + '\mobile') = False then
            ForceDirectories(Form1.sAtual + '\mobile');

          if Form1.ClienteSmallMobile.ImportandoMobile then // Sandro Silva 2022-08-08 if ImportandoMobile then
          begin
            Form1.ClienteSmallMobile.LogRetornoMobile(_59.LogComando); // Sandro Silva 2022-08-08 LogRetornoMobile(_59.LogComando); // No processamento da fila de vendas mobile será retornado para o smallmobile o log
          end;

        end; // if Form1.bImportandoMobile = False then

      end; // if sResposta = '06000' then // '06000' Retorno de emitido com sucesso

    except

    end;

  finally
    //FreeAndNil(RetornoVenda); // 2015-07-09
    FreeAndNil(FIBQuery65);
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
  _59.VisualizarExtrato := (LerParametroIni(FRENTE_INI, SECAO_59, 'Visualizar Extrato','Não') = 'Sim');// Sandro Silva 2017-02-10  _59.VisualizarExtrato := Form1.VisualizarDANFCE1.Checked;
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
    + ' and substring(NFEID from 23 for 9) = ' + QuotedStr(_59.NumeroSerieSAT) // 2014-10-22 Identifica o número do sat para não excluir o cupom com mesmo número emitido por outro equipamento
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
      begin// Emitido e não cancelado

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
                                        + ' and (substring(NFEID from 21 for 2) = ' + QuotedStr(_59.ModeloDocumento) + ' or coalesce(NFEID, '''') = '''') ' // 2014-10-22 para não selecionar nfc-e
                                        + ' and substring(NFEID from 23 for 9) = ' + QuotedStr(_59.NumeroSerieSAT) // 2014-10-22 Identifica o número do sat para não excluir o cupom com mesmo número emitido por outro equipamento
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
      SmallMsg('Cupom Fiscal Eletrônico já cancelado');// Sandro Silva 2018-07-03  SmallMsg('Cupom fiscal eletrônico - SAT já cancelado');
      Result := True;
    end;

    // Não consegui usar aqui qualquer manipulação de objetos pertencentes ao Form1 após executar chamadas ao componente smallsat.
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
    // Implementar visualização do danfe para SAT

    _59.ExtratoDetalhado := Form1.DANFCEdetalhado1.Checked;

    _59.OrientacaoConsultarQRCode := '';

    if (xmlNodeValue(pFNFe, '//ide/cUF') = '35') or (AnsiUpperCase(_59.Emitente.UF) = 'SP') then  // São Paulo
      _59.OrientacaoConsultarQRCode := 'Consulte o QR Code pelo aplicativo "De olho na nota", disponível na AppStore (Apple) e PlayStore (Android)';

    {Sandro Silva 2023-08-30 inicio}
    if (xmlNodeValue(pFNFe, '//ide/cUF') = '23') or (AnsiUpperCase(_59.Emitente.UF) = 'CE') then  // Ceará
      _59.OrientacaoConsultarQRCode := 'Consulte o QR Code pelo aplicativo "Sua Nota Tem Valor", disponível na AppStore (Apple) e PlayStore (Android)';
    {Sandro Silva 2023-08-30 fim}

    Form1.ExibePanelMensagem('Aguarde... Gerando Extrato ' + Form1.sTipoDocumento + ' em PDF'); // Sandro Silva 2018-08-01

    _59.ImprimirCupomDinamico(pFNFe, toImage, _59.Ambiente);

    Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible := False; // Sandro Silva 2016-08-25

    if LimpaNumero(xmlNodeValue(pFNFe, '//CFeCanc/infCFe/@chCanc')) <> '' then
      sFileCFeSAT := 'ADC' + LimpaNumero(xmlNodeValue(pFNFe, '//CFeCanc/infCFe/@Id'))
    else
      sFileCFeSAT := 'AD' + LimpaNumero(xmlNodeValue(pFNFe, '//CFe/infCFe/@Id'));

    sFileCFeSAT := ExtractFilePath(Application.ExeName) + 'CFeSAT\' + sFileCFeSAT + '.pdf';

    if FileExists(sFileCFeSAT) then
      ShellExecute(Application.Handle, 'open', PChar(sFileCFeSAT), '', '', SW_MAXIMIZE);

  except
    on E: Exception do
    begin
      Application.MessageBox(PChar(E.Message+chr(10)+chr(10)+'Ao visualizar o DANFCE'
      ),'Atenção',mb_Ok + MB_ICONWARNING);
      Result := False;
    end;
  end;
end;

function _ecf59_Imprime_DANFECE(pSLote: String; pFNFe : WideString): Boolean;
begin
  Result := False; // Sandro Silva 2018-08-29
  Form1.ExibePanelMensagem('Aguarde, imprimindo Extrato do CF-e...');

  _59.OrientacaoConsultarQRCode := '';
  if (xmlNodeValue(pFNFe, '//ide/cUF') = '35') or (AnsiUpperCase(_59.Emitente.UF) = 'SP') then  // São Paulo
    _59.OrientacaoConsultarQRCode := 'Consulte o QR Code pelo aplicativo "De olho na nota", disponível na AppStore (Apple) e PlayStore (Android)';
    
  {Sandro Silva 2023-08-30 inicio}
  if (xmlNodeValue(pFNFe, '//ide/cUF') = '23') or (AnsiUpperCase(_59.Emitente.UF) = 'CE') then  // Ceará
    _59.OrientacaoConsultarQRCode := 'Consulte o QR Code pelo aplicativo "Sua Nota Tem Valor", disponível na AppStore (Apple) e PlayStore (Android)';
  {Sandro Silva 2023-08-30 fim}

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
      DeleteFile(PChar(sZipFile));

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
      while not FileExists(PChar(sZipFile)) do
      begin
        Sleep(100);
      end;
      //
      while FileExists(PChar(sFileCFeSAT)) do
      begin
        DeleteFile(PChar(sFileCFeSAT));
        Sleep(100);
      end;

      while FileExists(PChar(sFileXML)) do
      begin
        DeleteFile(PChar(sFileXML));
        Sleep(100);
      end;
    end;
    Result := True;
  end;
begin
  //
  sEmail    := AllTrim(Copy(StrTran(AllTrim(Form2.Edit10.Text),';',Replicate(' ',512))+Replicate(' ',265),1,256)); // Fica sómente um e-mail
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

    // Sandro Silva 2023-01-09 sFileCFeSAT := ExtractFilePath(Application.ExeName) + 'email\' + sFileCFeSAT + '.pdf'; // Sandro Silva 2022-09-02 sFileCFeSAT := ExtractFilePath(Application.ExeName) + 'CFeSAT\' + sFileCFeSAT + '.pdf';
    sFileCFeSAT := ExtractFilePath(Application.ExeName) + 'cfesat\' + sFileCFeSAT + '.pdf';

    while FileExists(PChar(sFileXML)) do
    begin
      DeleteFile(PChar(sFileXML));
      Sleep(100);
    end;

    slXMl := TStringList.Create; //
    slXMl.Text      := pFNFe;
    slXMl.SaveToFile(sFileXML);
    slXMl.Free;
    {Sandro Silva 2021-11-26 fim}

    if Form1.EnviarDANFCEeXMLcompactado1.Checked = False then
    begin

      if FileExists(PChar(sFileXML)) then
      begin
        sTextoCorpoEmail := 'Segue em anexo seu XML do Cupom Fiscal Eletrônico - SAT.'+chr(10);
        if Form1.sPropaganda <> '' then
          sTextoCorpoEmail := sTextoCorpoEmail + Form1.sPropaganda + Chr(10);
        sTextoCorpoEmail := sTextoCorpoEmail + Chr(10) + 'Este e-mail foi enviado automaticamente pelo sistema Small.'+chr(10)+'www.smallsoft.com.br';
        EnviarEMail('',sEmail,'','XML do Cupom Fiscal Eletrônico - SAT',PansiChar(sTextoCorpoEmail),PansiChar(sFileXML),False);
      end;

      if FileExists(sFileCFeSAT) then
      begin
        sTextoCorpoEmail := 'Segue em anexo seu Extrato Cupom Fiscal Eletrônico em arquivo PDF.'+chr(10); // Sandro Silva 2018-07-03 sTextoCorpoEmail := 'Segue em anexo seu Extrato Cupom Fiscal Eletrônico - SAT em arquivo PDF.'+chr(10);
        if Form1.sPropaganda <> '' then
          sTextoCorpoEmail := sTextoCorpoEmail + Form1.sPropaganda + Chr(10);
        sTextoCorpoEmail := sTextoCorpoEmail + Chr(10) + 'Este e-mail foi enviado automaticamente pelo sistema Small.'+chr(10)+'www.smallsoft.com.br';
        EnviarEMail('',sEmail,'','Extrato Cupom Fiscal Eletrônico',PansiChar(sTextoCorpoEmail),PansiChar(sFileCFeSAT),False); // Sandro Silva 2018-07-03 EnviarEMail('',sEmail,'','Extrato Cupom Fiscal Eletrônico - SAT',pchar(sTextoCorpoEmail),pChar(sFileCFeSAT),False);
      end;

    end
    else
    begin
      //sZipFile := ExtractFilePath(Application.ExeName) + 'email\' + 'CFeSat_xml_pdf_' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzzz', Now) + '.zip'; // Sandro Silva 2022-09-02 sZipFile := ExtractFilePath(Application.ExeName) + 'CFeSAT\' + 'CFeSat_xml_pdf.zip';
      //sZipFile := ChangeFileExt(sFileCFeSAT, 'zip');
      Compactar(sZipFile);
      if FileExists(PChar(sZipFile)) then
      begin
        sTextoCorpoEmail := 'Segue em anexo seu XML e Extrato Cupom Fiscal Eletrônico.'+chr(10); // Sandro Silva 2018-07-03 sTextoCorpoEmail := 'Segue em anexo seu XML e Extrato Cupom Fiscal Eletrônico - SAT.'+chr(10);
        if Form1.sPropaganda <> '' then
          sTextoCorpoEmail := sTextoCorpoEmail + Form1.sPropaganda + Chr(10);
        sTextoCorpoEmail := sTextoCorpoEmail + Chr(10) + 'Este e-mail foi enviado automaticamente pelo sistema Small.'+chr(10)+'www.smallsoft.com.br';

        EnviarEMail('', sEmail, '', 'Extrato Cupom Fiscal Eletrônico e XML', PansiChar(sTextoCorpoEmail),PansiChar(sZipFile), False); // Sandro Silva 2018-07-03 EnviarEMail('', sEmail, '', 'Extrato Cupom Fiscal Eletrônico - SAT e XML', pchar(sTextoCorpoEmail),pChar(sZipFile), False);
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
// Sandro Silva 2015-03-30 Impressão de comprovante de sangria ou suprimento
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
      'NÃO É DOCUMENTO FISCAL'+chr(10)+
      'COMPROVANTE NÃO FISCAL'+chr(10)+
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
      SmallMsg('SAT não foi inicializado')
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
        SmallMsg('SAT não foi inicializado')
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
              Application.MessageBox(PChar(_59.RespostaSat + #13 + #13 + 'A aplicação será finalizada'),'Atenção', MB_ICONWARNING + MB_OK);
              FecharAplicacao(ExtractFileName(Application.ExeName));
              Abort;
            end
            else
              Application.MessageBox(PChar(_59.CodigoRetornoSAT + ' ' + _59.MensagemSat),'Atenção', MB_ICONWARNING + MB_OK);
          end
          else
          begin
            if ((_59.CodigoRetornoSAT <> '08000') and (_59.CodigoRetornoSAT <> '')) or bMensagem then
            begin
              if (_59.EmOperacao) or bMensagem then
              begin
                //Application.MessageBox(PChar(_59.RespostaSAT),'SAT', MB_ICONINFORMATION + MB_OK);
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
            Application.MessageBox(PChar(_59.CodigoRetornoSAT + ' ' + _59.MensagemSEFAZ), 'Atenção Mensagem da SEFAZ', MB_ICONINFORMATION + MB_OK);
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
          SmallMsg('SAT não foi inicializado')
        else
          _59.SATConsultarStatusOperacional(Memo4, True);

        Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible := False; // Sandro Silva 2017-05-10

        if _59.ModoOperacao = moClient then
          Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible := False; // Sandro Silva 2017-02-24

        if _59.ConteudoStatusOperacional <> '' then
          Application.MessageBox(PChar(_59.ConteudoStatusOperacional), 'Retorno Status Operacional', MB_ICONINFORMATION + MB_OK);

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
      SmallMsg('SAT não foi inicializado')
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
      SmallMsg('SAT não foi inicializado')
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
      SmallMsg('SAT não foi inicializado')
    end
    else
    begin
      if _ecf59_ValidaKitDesenvolvimento then
      begin // Equipamento kit desenvolvedor não pode ser reconfigurado pelo AC, sempre retorna True
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
      sCaixa := Small_InputBox('Número do Caixa',
                               'Informe o número do caixa para identificar as vendas deste PDV',
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
            if (_59.ModoOperacao = moAlone) and (IBQREDUCOES.FieldByName('SMALL').AsString <> '65') then // Não está executando como cliente sat/mfe e caixa foi usado anteriormente
            begin

              if (_59.NumeroSerieSAT <> IBQREDUCOES.FieldByName('SERIE').AsString) then
              begin
                Result := '';

                Application.MessageBox(PChar('O caixa ' + sCaixa + ' já foi utilizado anteriormente com ' +
                                                 IfThen(IBQREDUCOES.FieldByName('SMALL').AsString = '59', 'SAT/MFE ', 'ECF ') + IBQREDUCOES.FieldByName('SERIE').AsString + #13 + #13 +
                                                 'Informe outro o número diferente de ' + sCaixa),
                                       'Atenção!', MB_ICONINFORMATION + MB_OK);

              end;

            end;
          end;
        end
        else
        begin

          if Application.MessageBox(PChar('O caixa ' + sCaixa + ' já foi utilizado anteriormente' + #13 + #13 +
                                          'Certifique-se de que o número ' + sCaixa + ' não identifique outro PDV' + #13 + #13 +
                                          'Deseja continuar?'),
                                          'Atenção!', MB_ICONQUESTION + MB_YESNO) = ID_YES then

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
      SmallMsg('Informe o código de ativação configurado no equipamento ' + _ecf59_Tipodaimpressora);
      Form1.sStatusECF := _ecf59_Tipodaimpressora + ' - Não autorizado.';
      Result := False;
    end;

    if (_59.Fabricante = '') then
    begin
      SmallMsg('Informe o código do fabricante do equipamento ' + _ecf59_Tipodaimpressora);
      Form1.sStatusECF := _ecf59_Tipodaimpressora + ' - Não autorizado. Código do fabricante inválido';
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

      sResposta := Form1.GetAssinaturaHttpPost(StrTran(Form22.sSerie, 'Número de série: ', ''), _59.Emitente.CNPJ, _59.Fabricante, _59.NumeroSerieSAT);

      if (Trim(xmlNodeValue(sResposta, '//assinaturaassociada')) <> '') then
      begin

        _ecf59_GravaAssinaturaAssociada(Trim(xmlNodeValue(sResposta, '//assinaturaassociada')));

      end;

      if LerParametroIni(Form1.sArquivo, SECAO_59, _59_CHAVE_ASSINATURA_ASSOCIADA, '') = '' then
      begin

        sAssinaturaAssociada := Small_InputBox('Assinatura Associada',
                                            'Informe a Assinatura Associada fornecida pela Zucchetti. ', sAssinaturaAssociada); // Sandro Silva 2022-12-02 Unochapeco 'Informe a Assinatura Associada fornecida pela Smallsoft. ', sAssinaturaAssociada);
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

            Form1.sStatusECF := _ecf59_Tipodaimpressora +  ' - Não autorizado. ' + _ecf59_Tipodaimpressora + ' não foi ativado'; // Sandro Silva 2017-05-10  'SAT - Não autorizado. SAT não foi ativado';
            Result := False;

          end;
  //ShowMessage('Teste 01 4942'); // Sandro Silva 2018-11-19

          // Sempre associa a assinatura após fazer o download
          if Result then
          begin

  //ShowMessage('Teste 01 4949'); // Sandro Silva 2018-11-19
            try
              if _ecf59_AssociarAssinatura(_59.CodigoAtivacao, _59.Emitente.CNPJ, _59.AssinaturaAssociada) = False then
              begin

                Form1.sStatusECF := _ecf59_Tipodaimpressora + ' - Não autorizado. Assinatura não associada'; // Sandro Silva 2017-05-10  'SAT - Não autorizado. Assinatura não associada';
                Result := False;

              end;
            except
              Result := False; // SAT da ControlID KIT desenvolvimento sempre ocorre access violation quando não existe assinatura no cripta
            end;

          end;

  //ShowMessage('Teste 01 4961'); // Sandro Silva 2018-11-19

        end
        else
        begin

          Form1.sStatusECF := _ecf59_Tipodaimpressora + ' - Não autorizado. Assinatura Associada não encontrada'; // Sandro Silva 2017-05-10  'SAT - Não autorizado. Assinatura Associada não encontrada';
          Result := False;

        end;

      end; //if _59.ModoOperacao <> moClient then // Sandro Silva 2017-02-23

  //ShowMessage('Teste 01 4974'); // Sandro Silva 2018-11-19

      if Trim(xmlNodeValue(sResposta, '//alerta')) <> '' then
      begin
        SmallMsgBox(PChar('Não foi possível obter a Assinatura Associada para o ' + _ecf59_Tipodaimpressora + #13 + Utf8ToAnsi(Trim(xmlNodeValue(sResposta, '//alerta')))), 'Atenção', MB_ICONWARNING + MB_OK);
      end;

      // Se não conseguiu obter a assinatura associada
      if (_59.AssinaturaAssociada = '') then
      begin
        Form1.sStatusECF := _ecf59_Tipodaimpressora + ' - Não autorizado. Assinatura Associada não encontrada'; // Sandro Silva 2017-05-10  'SAT - Não autorizado. Assinatura Associada não encontrada';
        Result := False;
      end;

  //ShowMessage('Teste 01 4988'); // Sandro Silva 2018-11-19
      if Form1.bBalancaAutonoma = False then // Sandro Silva 2019-01-23
      begin
        Form22.Label6.Caption := 'Aguarde! Verificando a disponibilidade dos serviços ' + _ecf59_Tipodaimpressora(True) + '....';
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
      SmallMsgBox('Código do fabricante e modelo inválido', 'Atenção', MB_OK + MB_ICONWARNING)
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
      SmallMsg('Código do fabricante inválido');
  end;

  if Length(Trim(sCodigoFabricante)) <= 2 then
  begin
    sCodigoFabricante := FormatFloat('00', StrToIntDef(Trim(sCodigoFabricante), 0)) + '01';
    GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_CODIGO_FABRICANTE, sCodigoFabricante);
  end;
end;

function _ecf59_ValidaKitDesenvolvimento: Boolean;
begin // Retorna True quando equipamento usado for KIT para desenvolvimento, observando se a assinatura associada for igual a uma das assinaturas padrões para testes com os kit's
  Result := False;
  if (_59.AssinaturaAssociada = _59_ASSINATURA_ASSOCIADA_MFE) // MFE ELGIN
    or (_59.AssinaturaAssociada = _59_ASSINATURA_ASSOCIADA_INTEGRADOR)
    or (_59.AssinaturaAssociada = _59_ASSINATURA_ASSOCIADA_SAT) // SAT/MFE TANCA/BEMATECH
    or (_59.AssinaturaAssociada = _59_ASSINATURA_ASSOCIADA_EMULADOR_SP) // EMULADOR SEFAZ/SP
    then
    Result := True;
end;

procedure _ecf59_HabilitaUsarDriverMFE_1_05(bHabilitar: Boolean);
// Habilita o uso do driver de comunicação com MFE versão 1.05 ou superior, dispensando o uso
// do integrador fiscal para comunicar-se com o MFE
begin
  try
    GravarParametroIni(FRENTE_INI, SECAO_59, _59_CHAVE_VERSAO_DRIVER_MFE_1_05, IfThen(bHabilitar, 'Sim', 'Não'));
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
