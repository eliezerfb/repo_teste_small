//
// FALTA
//
// Testar o sistema em impressoras não fiscais DARUMA-OK, BEMATECH-OK e EPSON(T20 funciona) a (T70) não funciona
//
// TAG dos produtos tributados
//

// Sefaz - CE 85 3108 0283 / 3108 0284

//*
// NFC-e AM homologação
// Alteramos recentemente o padrão do token de homologação para o ambiente de desenvolvedores.
//Os usuários desse ambiente devem substituir antiga sistemática de geração (CNPJ RAIZ + 2014 + 0001) pelo valor fixo 0123456789
// IdToken = '000001'
//*

// Consulta Ceará Homologação http://nfceh.sefaz.ce.gov.br/pages/consultaNota.jsf

(*
Alterações para aplicar nas versões novas do retrato.rtm

A partir da versão 2017.0.0.12 passou-se a usar o novo layout de impressão da versão NFC-e 4.0
A expressão troco e o seu valor estão com a propriedade Visible desmarcadas. Marcar quando o troco passar a existir no xml

Alterar tamanho do campo código do produto (17,726) para suportar a impressão de GTIN-14. Ver ficha depuração 3479
Alterar conforme ficha de depuração 3467:
- dados do emitente negrito e fonte fontb88 tamanho 6
- código, descrição, qtde, un, vl unit, vl total foi alterado para a fonte font88
- numero do codigo, fonte alterada para fontb88
- descrição do produto desativado o negrito, fonte 7 fontb88
- Forma de pagamento usada e o valor marcado negrito e usado a fonte fontb88

////////////////////////////////////////
*)

unit _small_65;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Mask, Grids, DBGrids, DB, DBCtrls,
  IniFiles, FileCtrl, spdNFCeDataSets, spdNFCe, spdNFCeType, Printers,
  shellApi, Registry, TLHelp32
  , IBX.IBDatabase, IBX.IBQuery, IBX.IBCustomDataSet
  , StrUtils, Variants,
  Math, ComCtrls, msxml, DateUtils, RTLConsts
  ;

  // ------------ //
  // NFC-e        //
  // ------------ //

  //const MODELO_65          = '65';
  const NOME_APLICATIVO_65 = 'nfce.exe';
  //const SECAO_65           = 'NFCE';
  const _65_AMBIENTE       = 'Ambiente';
  const TIMEOUT_NFCE       = 300; // Sandro Silva 2018-04-19 20 Padrão inicial 20 segundo

  const CHAVE_INI_VERSAO_MANUAL    = 'Versao Manual';
  const CHAVE_INI_VERSAO_ESQUEMA   = 'Versao Schema';

  const TPEMIS_NFCE_NORMAL               = '1'; // Emissão normal (não em contingência);
  const TPEMIS_NFCE_CONTINGENCIA_OFFLINE = '9'; //Contingência off-line da NFC-e

  const TPAMB_PRODUCAO    = '1';
  const TPAMB_HOMOLOGACAO = '2';

  const INDPRES_OPERACAO_PRESENCIAL                     = '1';
  const INDPRES_OPERACAO_NAO_PRESENCIAL_PELA_INTERNET   = '2';
  const INDPRES_OPERACAO_NAO_PRESENCIAL_TELEATENDIMENTO = '3';
  const INDPRES_OPERACAO_NAO_PRESENCIAL_OUTROS          = '9';

  const NFCE_FORMA_01_DINHEIRO                                     = '01';
  const NFCE_FORMA_02_CHEQUE                                       = '02';
  const NFCE_FORMA_03_CARTAO_CREDITO                               = '03';
  const NFCE_FORMA_04_CARTAO_DEBITO                                = '04';
  const NFCE_FORMA_05_CREDITO_LOJA                                 = '05';
  const NFCE_FORMA_10_VALE_ALIMENTACAO                             = '10';
  const NFCE_FORMA_11_VALE_REFEICAO                                = '11';
  const NFCE_FORMA_12_VALE_PRESENTE                                = '12';
  const NFCE_FORMA_13_VALE_COMBUSTIVEL                             = '13';
  const NFCE_FORMA_16_DEPOSITO_BANCARIO                            = '16';
  const NFCE_FORMA_17_PAGAMENTO_INSTANTANEO_PIX_DINAMICO           = '17'; // PIX Dinâmico
  const NFCE_FORMA_18_TRANSFERENCIA_BANCARIA_CARTEIRA_DIGITAL      = '18'; // Transferência bancária, Carteira Digital
  const NFCE_FORMA_19_PROGRAMA_FIDELIDADE_CASHBACK_CREDITO_VIRTUAL = '19'; // Programa de fidelidade, Cashback, Crédito Virtual
  const NFCE_FORMA_20_PAGAMENTO_INSTANTANEO_PIX_ESTATICO           = '20'; // PIX estático
  const NFCE_FORMA_99_OUTROS                                       = '99';

  const _65_AMBIENTE_HOMOLOGACAO  = 'HOMOLOGACAO';
  const _65_AMBIENTE_PRODUCAO     = 'PRODUCAO';

  const NFCE_EMITIDA_EM_CONTINGENCIA        = 'NFC-e emitida em modo de contingência'; // Mudar aqui afeta select que buscam registros antigos com esse texto
  const NFCE_NAO_HOUVE_RETORNO_SERVIDOR     = 'Não houve retorno do Servidor da SEFAZ';
  const ALERTA_CONTINGENCIA_NAO_TRANSMITIDA = 'Atenção... Contingência Não Transmitida';
  const NFCE_XJUST_CONTINGENCIA_AUTOMATICA  = 'Servidor da SEFAZ nao esta retornando resposta do envio';// Sandro Silva 2021-06-11

  const NFCE_STATUS_AUTORIZADO_USO_EM_HOMOLOGACAO = 'Autorizado o uso da NFC-e em ambiente de homologação';
  const NFCE_STATUS_AUTORIZADO_USO_EM_PRODUCAO    = 'Autorizado o uso da NFC-e';
  const NFCE_STATUS_CANCELAMENTO                  = 'Cancelamento Registrado e vinculado a NFCe';

  function ConsisteInscricaoEstadual(sIE, sUF: AnsiString): Boolean; StdCall; External 'DllInscE32.Dll';
  //
  function _ecf65_CodeErro(Pp1: Integer):Integer;
  function _ecf65_Inicializa(Pp1: String):Boolean;
  function _ecf65_FechaCupom(Pp1: Boolean):Boolean;
  function _ecf65_Pagamento(Pp1: Boolean):Boolean;
  function _ecf65_CancelaUltimoItem(Pp1: Boolean):Boolean;
  function _ecf65_SubTotal(Pp1: Boolean):Real;
  function _ecf65_AbreGaveta(Pp1: Boolean):Boolean;
  function _ecf65_Sangria(Pp1: Real):Boolean;
  function _ecf65_Suprimento(Pp1: Real):Boolean;
  function _ecf65_NovaAliquota(Pp1: String):Boolean;
  function _ecf65_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
  function _ecf65_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
  function _ecf65_CancelaUltimoCupom(Pp1: Boolean):Boolean;
  function _ecf65_AbreNovoCupom(Pp1: Boolean):Boolean;
  function _ecf65_NumeroDoCupom(Pp1: Boolean):String;
  function _ecf65_CancelaItemN(pP1, pP2: String):Boolean;
  function _ecf65_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
  function _ecf65_ReducaoZ(pP1: Boolean):Boolean;
  function _ecf65_LeituraX(pP1: Boolean):Boolean;
  function _ecf65_RetornaVerao(pP1: Boolean):Boolean;
  function _ecf65_LigaDesLigaVerao(pP1: Boolean):Boolean;
  function _ecf65_VersodoFirmware(pP1: Boolean): String;
  function _ecf65_NmerodeSrie(pP1: Boolean): String;
  function _ecf65_CGCIE(pP1: Boolean): String;
  function _ecf65_Cancelamentos(pP1: Boolean): String;
  function _ecf65_Descontos(pP1: Boolean): String;
  function _ecf65_ContadorSeqencial(pP1: Boolean): String;
  function _ecf65_Nmdeoperaesnofiscais(pP1: Boolean): String;
  function _ecf65_NmdeCuponscancelados(pP1: Boolean): String;
  function _ecf65_NmdeRedues(pP1: Boolean): String;
  function _ecf65_Nmdeintervenestcnicas(pP1: Boolean): String;
  function _ecf65_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
  function _ecf65_Clichdoproprietrio(pP1: Boolean): String;
  function _ecf65_NmdoCaixa(pP1: Boolean): String;
  function _ecf65_Nmdaloja(pP1: Boolean): String;
  function _ecf65_Moeda(pP1: Boolean): String;
  function _ecf65_Dataehoradaimpressora(pP1: Boolean): String;
  function _ecf65_Datadaultimareduo(pP1: Boolean): String;
  function _ecf65_Datadomovimento(pP1: Boolean): String;
  function _ecf65_Tipodaimpressora(pP1: Boolean): String;
  function _ecf65_StatusGaveta(Pp1: Boolean):String;
  function _ecf65_RetornaAliquotas(pP1: Boolean): String;
  function _ecf65_Vincula(pP1: String): Boolean;
  function _ecf65_FlagsDeISS(pP1: Boolean): String;
  function _ecf65_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
  function _ecf65_MudaMoeda(pP1: String): Boolean;
  function _ecf65_MostraDisplay(pP1: String): Boolean;
  function _ecf65_leituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
  function _ecf65_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean;
  function _ecf65_ImpressaoNaoSujeitoaoICMS(sP1: String; bPDF: Boolean = False; LarguraPapel: Integer = 640): Boolean; // Sandro Silva 2018-11-20 function _ecf65_ImpressaoNaoSujeitoaoICMS(sP1: String; bPDF: Boolean = False): Boolean;
  function _ecf65_FechaCupom2(sP1: Boolean): Boolean;
  function _ecf65_ImprimeCheque(rP1: Real; sP2: String): Boolean;
  function _ecf65_MapaResumo(sP1: Boolean): Boolean;
  function _ecf65_FormataTx(sP1: String): Integer;
  function _ecf65_GrandeTotal(sP1: Boolean): String;
  function _ecf65_TotalizadoresDasAliquotas(sP1: Boolean): String;
  function _ecf65_CupomAberto(sP1: Boolean): boolean;
  function _ecf65_FaltaPagamento(sP1: Boolean): boolean;
  function _ecf65_Visualiza_DANFECE(pSLote: String; pFNFe : WideString): Boolean;
  function _ecf65_Imprime_DANFECE(pSLote: String; pFNFe : WideString): Boolean;
  function _ecf65_Email_DANFECE(pSLote: String; pFNFe : WideString): Boolean;
  function _ecf65_ConsultarStatusServico(bExibirMensagem: Boolean = True): String;
  function _ecf65_InutilizacaoNFCe: String; overload;
  function _ecf65_InutilizacaoNFCe(sID, aAno, aModelo, aSerie, aIni, aFim, txtJustificativa: string): String; overload;
  procedure _ecf65_GeraXmlCorrigindoDados(iPedido: Integer; sCaixaXml: String); // Sandro Silva 2018-03-05
  function _ecf65_EnviarNFCe(pp1: Boolean): Boolean;
  function _ecf65_ArquivoRTM: String;
  function _ecf65_EnviarEMail(sDe, sPara, sCC, sAssunto, sTexto, sAnexo: string; bConfirma: Boolean): Integer;
  function _ecf65_SangriaSuprimento(dValor: Double; sTipo: String): Boolean;
  function _ecf65_LoadXmlDestinatario(sID: String): WideString;
  function _ecf65_LoadXmlRecuperado(sID: String): WideString;
  function _ecf65_EnviarNFCeContingencia(dtData: TDate; sNumeroNF: String;
    sCaixa: String): Boolean;//; sCaixa: String): Boolean;//(sNumero: String; sCaixa: String): Boolean;
  function _ecf65_CancelaNFCe(pp1: Boolean): Boolean;
  function _ecf65_CancelaNFCePorSubstituicao(sNfeIdCancelar: String;
    sJustificativa: String; sNfeIdContingencia: String;
    var sRetorno: String): Boolean;
  procedure _ecf65_SelecionaXmlInutilizacao(var Lista: TStringList; sCaminho: String);
  procedure _ecf65_NumeroSessaoIntegradorFiscal;
  procedure _ecf65_RateioAcrescimo(dTotalVenda: Double; dAcrescimoTotal: Double;
    iCupom: Integer; sCaixa: String);                                     // Sandro Silva 2018-08-01
  procedure _ecf65_RateioDesconto(dTotalVenda: Double; dDescontoTotal: Double;
    iCupom: Integer; sCaixa: String); overload;                                    // Sandro Silva 2018-08-01
  function ConverteAcentosXML(pP1: String): String;                       // Sandro Silva 2018-08-01
  procedure _ecf65_AdicionaPagamento(tPag_YA02: String; vPag_YA03: String);      // Sandro Silva 2018-08-01
  procedure _ecf65_AcumulaFormaExtraNFCe(sOrdemExtra: String; dValor: Double;
    var dvPag_YA03_10: Double; var dvPag_YA03_11: Double;
    var dvPag_YA03_12: Double; var dvPag_YA03_13: Double;
    var dvPag_YA03_16: Double; var dvPag_YA03_17: Double;
    var dvPag_YA03_18: Double; var dvPag_YA03_19: Double;
    var dvPag_YA03_20: Double;
    var dvPag_YA03_99: Double);                                           // Sandro Silva 2018-08-01
  procedure _ecf65_DadosCredenciadoraCartoes(spdNFCeDataSets: TspdNFCeDataSets;
    sCNPJ_YA05: String; NomeRede: String; NumeroAutorizacao: String);     // Sandro Silva 2018-08-01
  procedure _ecf65_DadosAutorizacaoPix(spdNFCeDataSets: TspdNFCeDataSets; sCodigoAutorizacao, sCNPJInstituicaoPIX : string); // Mauricio Parizotto 2024-07-03
  function _ecf65_DescricaoFormaExtra99: String;
  function _ecf65_DadosCarneNoXML: String;                                       // Sandro Silva 2018-08-01
  function _ecf65_CNPJAdministradoraCartao(xml: String): String;
  function _ecf65_GravaPagamentFromXML(sXML: String; sPedido: String;
    sCaixa: String): Boolean;
  procedure _ecf65_IdentificaPercentuaisBaseICMS(var dpRedBC_N14: Real);
  procedure _ecf65_IdentificaPercentuaisICMSEfetivo(var dpICMSEfet_N36: Double; var dpRedBCEfet_N34: Double);
  procedure _ecf65_IdentificacaoResponsavelTecnico(spdNFCeDataSets: TspdNFCeDataSets);
  function _ecf65_GravarInutilizacao(sXML: String; IBQuery: TIBQuery): Boolean;
  procedure _ecf65_ImportaXmlInutilizacao(sCaminhoXml: String);
  function _ecf65_ValidaGtinNFCe(sEan: String): Boolean;
  procedure _ecf65_InfAddProdFCP(spdNFCeDataSets: TspdNFCeDataSets; dvFCP_N17c: Double;
    dvBC_N15: Double);
  function _ecf65_GeraContingenciaParaCancelamentoPorSubstituicao(sNumeroNF: String;
    sCaixa: String; dtEnvio: TDate; sNFEXml: String; sNumeroOrcamento: String;
    sNumeroOs: String): Boolean;
  function _ecf65_XmlNfceCancelado(sXml: String): Boolean;
  function _ecf65_ConsultaChaveNFCe: Boolean;
  function _ecf65_VerificaContingenciaPendentedeTransmissao(
    dtDataIni: TDate; dtDataFim: TDate; sCaixa: String): Boolean;
  procedure _ecf65_CalculaDesoneracao(sUF: String; sCit: String; sCrt: String;
    sCst: String; sAliquota: String; dpRedBC: Double; dvBC: Double;
    DataSetICM: TDataSet; DataSetESTOQUE: TDataSet;
    var dvICMSDeson_N28a: Real; var dvICMS: Double);
  function _ecf65_CorrigePadraoRespostaSefaz(sResposta: String): String;
  procedure _ecf65_CorrigeXmlNoBanco;
  procedure _ecf65_ListaArquivos(sArquivo: String);
  procedure _ecf65_CorrigeRejeicaoChaveDeAcessoDifere(sNumeroNF: String;
    sCaixaNF: String; bCommitarTudoNoFinal: Boolean = True);
  function _ecf65_UsoDenegado(sXmlRetorno: String): Boolean;
  function _ecf65_SimulaRetornoUsoDenegado(Value: String): String;
  function _ecf65_SimulaSemRetornoSefaz(Value: String): String;
  function _ecf65_TimeOutComunicacaoSefaz: Integer;
  function _ecf65_TimeOutPadraoConsultaStatusServicoNFCe: Integer;
  function _ecf65_ContadorGRG(IBDataBase: TIBDatabase;
    sCaixa: String; Incrementa: Integer): String;
  function _ecf65_HabilitarGerarindIntermed(bHabilitar: Boolean): Boolean; // Sandro Silva 2021-03-05
  procedure _ecf65_ValidaNFCe_Setup;
  procedure _ecf65_AdicionaCNPJCOntabilidade(spdNFCeDataSets: TspdNFCeDataSets); // Sandro Silva 2020-09-01
  procedure _ecf65_ImportaCertificadoNFe(ArquivoNFeIni: String);
  function _ecf65_JaTemContingenciaPorSubstituicao(Transaction: TIBTransaction; sIDNFCe: String): Boolean;
  function _ecf65_tpEmisFromChave(sChave: String): String;
  function _ecf65_TodosItensCancelados(IBTransaction: TIBTransaction; Pedido: String; Caixa: String): Boolean; // Sandro Silva 2021-11-01
  function _ecf65_SerieAtual(IBTransaction: TIBTransaction): String; // Sandro Silva 2021-11-12
  function _ecf65_NumeroNfFromChave(sChave: String): String;
  function _ecf65_ConsultaIdNFCeEnviadaSemRespostaFazendoReenvio(spdNFCe: TspdNFCe;
    sLote: String; xmlEnvio: String): String;
  procedure _ecf65_RecuparaXML(sNumeroNF: String; sCaixaNF: String);
  function _ecf65_xmlAutorizado(sXML: String): Boolean;
  procedure _ecf65_GravaIdCSC(sIdToken: String);
  procedure _ecf65_GravaCSC(sCSC: String);
  function _ecf65_GerarcProdANVISA(sTAGS_: String; sNCM: String): Boolean;
  procedure _ecf65_DisponibilizarDANFCe(sStatus: String; sLote: String; fNFE: String);

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
  fNFe : WideString;
  iCaracteres : Integer;
  xBlockInput : function (Block: BOOL): BOOL; stdcall;  // Causava muito problema até versão 2015, bloqueava teclado e mouse, precisando fechar e abrir o frente
  Mobile_65: TMobile;
  aAcrescimoItem: array of Double; // 2016-01-08
  aDescontoItem: array of Double; // 2016-01-08
  _ecf65_bTransmitindoContingenciaNFCe: Boolean; // Sandro Silva 2019-07-25
  _ecf65_sDataHoraNFCeSubstituida: String; // Sandro Silva 2019-08-27

implementation

uses
//  RTLConsts
   SmallFunc_xe
  , SMALL_DBEdit
  , Fiscal
  , Unit2
  , Unit22
  , Unit10
  , uclassetransacaocartao
  , uimpressaopdf
  , ucadadquirentes
  , urecuperaxmlnfce
  , umfe
//  , _Small_IntegradorFiscal // Sandro Silva 2018-07-03
  ,  ufuncoesfrente // Sandro Silva 2018-07-03
  , uValidaRecursosDelphi7, uEmail, uSmallConsts;

function AlertaCredenciadoraCartao(sNomeRede: String): String;
begin
  Result := 'Configure no Small, em Cadastros, os dados da sua Credenciadora de Cartão Débito/Crédito  e no campo Observação adicione ";" e a Rede Adquirente: ' + sNomeRede;
end;

procedure ConcatenaLog(var sLog: String; sConcatenar: String);
// Concatena os log de erro sem duplicar mesmo log
begin

  if AnsiContainsText(StringReplace(sLog, Chr(10), '', [rfReplaceAll]), StringReplace(sConcatenar, Chr(10), '', [rfReplaceAll])) = False then
  begin
    sLog := sLog + sConcatenar +chr(10);
  end;

end;

procedure LogErroCredenciadoraCartao(sNomeRede: String;
  sCNPJ_YA05: String; var sLogErro: String);
begin
  if (sNomeRede <> '') and (sCNPJ_YA05 = '') then
  begin
    if AnsiContainsText(sLogErro, AlertaCredenciadoraCartao(Form1.sNomeRede)) = False then
      sLogErro := sLogErro + chr(10) + AlertaCredenciadoraCartao(Form1.sNomeRede) + Chr(10);
  end;
end;

function ItemRejeicao(sRejeicao: String; sXml: String): String;
var
  i: Integer;
begin
  if Pos('nItem:', sRejeicao) > 0 then
  begin
    for i := Pos('nItem', sRejeicao) + Length('nItem:') to Length(sRejeicao) do
    begin
      if Copy(sRejeicao, i , 1) = ']' then
        Break;
      Result := Result + Copy(sRejeicao, i , 1);
    end;
  end;
  Result := Trim(Result);
  if Result <> '' then
  begin
    Result := xmlNodeValue(sXML, '//det[@nItem="' + Result + '"]/prod/cProd') + '-' + xmlNodeValue(sXML, '//det[@nItem="' + Result + '"]/prod/xProd');
  end;
end;

function FunctionDetect(LibName, FuncName: String; var LibPointer: Pointer): boolean;
var
  LibHandle: tHandle;
begin
  Result := false;
  LibPointer := NIL;
  if LoadLibrary(PChar(LibName)) = 0 then Exit; // Sandro Silva 2020-09-03 if LoadLibrary(PChar(LibName)) = 0 then Exit;
  LibHandle := GetModuleHandle(PChar(LibName));
  if LibHandle <> 0 then
  begin
    LibPointer := GetProcAddress(LibHandle, PAnsiChar(FuncName)); // Sandro Silva 2020-09-03 LibPointer := GetProcAddress(LibHandle, PChar(FuncName));
    if LibPointer <> NIL then Result := true;
  end;
end;

procedure _ecf65_SelecionaXmlInutilizacao(var Lista: TStringList; sCaminho: String);
var
  S: TSearchREc;
  I: Integer;
begin
  Lista.Clear;
  //
  I := FindFirst(sCaminho, faAnyFile, S); // Sandro Silva 2020-09-03 I := FindFirst( pChar(sCaminho), faAnyFile, S);
  //
  while I = 0 do
  begin
    Lista.Add(S.Name);
    I := FindNext(S);
  end;
  //
  FindClose(S);
  //
end;

function _ecf65_ArquivoRTM: String;
begin

  if Printer.Printers.Count > 0 then // Sandro Silva 2018-06-13
  begin
    try
      Printer.PrinterIndex := Printer.Printers.IndexOf(Form1.sImpressoraPadraoWindows);
      if Trim(Form1.sImpressoraDestino) <> '' then
        Printer.PrinterIndex := Printer.Printers.IndexOf(Form1.sImpressoraDestino);
    except
    end;

    if Form1.sTamanhoPapel = '58' then // Sandro Silva 2018-06-18  if Printer.PageWidth <= 464 then
      Result := Form1.sAtual + '\nfce\Templates\vm60\danfce\retrato40_58mm.rtm'
    else
      Result := Form1.sAtual + '\nfce\Templates\vm60\danfce\retrato40.rtm';

  end
  else
  begin
    Result := Form1.sAtual + '\nfce\Templates\vm60\danfce\retrato40.rtm'
  end;

end;

function _ecf65_EnviarEMail(sDe, sPara, sCC, sAssunto, sTexto, sAnexo: String; bConfirma: Boolean): Integer;
begin
  Form1.ExibePanelMensagem('Aguarde... Enviando email para ' + sPara); // Sandro Silva 2022-09-02
  //Sandro Silva 2021-09-28
  // Usar ufuncoesfrente.EnviarEmail para evitar código duplicado em _Small_65 e _Small_59
  Result := EnviarEMail(sDe, sPara, sCC, sAssunto, sTexto, sAnexo, bConfirma);

  Form1.OcultaPanelMensagem; // Sandro Silva 2022-09-02
end;

function _ecf65_SangriaSuprimento(dValor: Double; sTipo: String): Boolean;
// Sandro Silva 2015-03-30 Impressão de comprovante de sangria ou suprimento
var
  sCupomFiscalVinculado: String;
begin
  // Sandro Silva 2015-03-30
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

    _ecf65_ImpressaoNaoSujeitoaoICMS(ConverteAcentos(sCupomFiscalVinculado));
    Form1.ibQuery65.Close;

  except

  end;
  Result := True;
end;

function _ecf65_LoadXmlDestinatario(sID: String): WideString;
var
 _file : TStringList;
begin
  //
  _file := TStringList.Create;
  //
  try
    //
    if FileExists(PChar(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + sID + '-caneve.xml')) then // Sandro Silva 2020-09-03 if FileExists(pChar(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + sID + '-caneve.xml')) then
    begin
      _file.LoadFromFile(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + sID + '-caneve.xml'); // Sandro Silva 2020-09-03 _file.LoadFromFile(pChar(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + sID + '-caneve.xml'));
      Result := _file.Text;
    end else
    begin
      if FileExists(PChar(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + sID + '-nfce.xml')) then // Sandro Silva 2020-09-03 if FileExists(pChar(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + sID + '-nfce.xml')) then
      begin
        _file.LoadFromFile(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + sID + '-nfce.xml'); // Sandro Silva 2020-09-03 _file.LoadFromFile(pChar(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + sID + '-nfce.xml'));
        Result := _file.Text;
      end;
    end;

    // Componente NFCe está gerando os xml com 'ï»¿' no início do arquivo e causa erro ao exportar para contabilidade
    Result := StringReplace(Result, 'ï»¿','', [rfReplaceAll]);

    Result := _ecf65_CorrigePadraoRespostaSefaz(Result);     
    //
    //
  except
    Result := '';
  end;
  //
  
  _file.Free;
  //
end;

function _ecf65_LoadXmlRecuperado(sID: String): WideString;
var
 _file : TStringList;
begin
  //
  _file := TStringList.Create;
  //
  try
    //
    if FileExists(PChar(Form1.sAtual + '\log\' + sID + '-recuperada-nfce.xml')) then // Sandro Silva 2020-09-03 if FileExists(pChar(Form1.sAtual + '\log\' + sID + '-recuperada-nfce.xml')) then
    begin
      _file.LoadFromFile(Form1.sAtual + '\log\' + sID + '-recuperada-nfce.xml'); // Sandro Silva 2020-09-03 _file.LoadFromFile(pChar(Form1.sAtual + '\log\' + sID + '-recuperada-nfce.xml'));
      Result := _file.Text;

      Result := _ecf65_CorrigePadraoRespostaSefaz(Result);

    end;
    //
    //
  except
    Result := '';
  end;
  //
  _file.Free;
  //
end;

function _ecf65_CancelaNFCe(pp1: Boolean): Boolean;
var
  sJustificativa : string;
  sProtocolo, sRetorno, sStatus : String;
  sXmlCancelamento: String;
  ArqXmlRetorno: TArquivo; // Sandro Silva 2019-07-11
  iTenta: Integer;
  function SalvaXmlCancelamentoEmXmlDestinatario(sXml, sNFEID: String): String;
  begin
    if (Pos('<cStat>135</cStat>',sXml) <> 0) then // Confirmação do evento de cancelamento
    begin
      if AnsiContainsText(sXml, '<?xml version="1.0" encoding="utf-8"?>') = False then
        sXml := '<?xml version="1.0" encoding="utf-8"?>' + xmlNodeXML(sXml, '//procEventoNFe');
      if Trim(sXml) <> '' then
      begin
        ArqXmlRetorno := TArquivo.Create;
        ArqXmlRetorno.Texto := sXml;
        ArqXmlRetorno.SalvarArquivo(PAnsiChar(Alltrim(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + sNFEID + '-caneve.xml'))); // Sandro Silva 2020-09-03 ArqXmlRetorno.SalvarArquivo(pChar(Alltrim(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + sNFEID + '-caneve.xml')));
        FreeAndNil(ArqXmlRetorno);
      end;
    end
    else
      sXml := '';
    Result := sXml;
  end;
begin
  //
  Result := False;
  //
  try
    //
    Form1.ibDataset150.Close;
    Form1.ibDataset150.SelectSql.Clear;
    Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF='+QuotedStr(FormataNumeroDoCupom(Form1.iCupom)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa)); // Sandro Silva 2021-11-29 Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF='+QuotedStr(StrZero(Form1.iCupom,6,0)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa));
    Form1.ibDataset150.Open;
    //
    if Form1.ibDataset150.FieldByName('NUMERONF').AsString = FormataNumeroDoCupom(Form1.iCupom) then // Sandro Silva 2021-11-29 if Form1.ibDataset150.FieldByName('NUMERONF').AsString = StrZero(Form1.iCupom,6,0) then
    begin
      //
      if (((Pos('<nfeProc',Form1.ibDataSet150.FieldByName('NFEXML').AsString) <> 0) and (Pos('<nProt>',Form1.ibDataSet150.FieldByName('NFEXML').AsString) <> 0)))
        or (_ecf65_XmlNfceCancelado(Form1.ibDataSet150.FieldByName('NFEXML').AsString))
        and (_ecf65_UsoDenegado(Form1.ibDataSet150.FieldByName('NFEXML').AsString) = False) // Sandro Silva 2020-05-14 
        then
      begin
        //
        try
          //
          if _ecf65_XmlNfceCancelado(Form1.ibDataSet150.FieldByName('NFEXML').AsString) = False then // Sandro Silva 2019-07-31
            sJustificativa := ConverteAcentos2(Form1.Small_InputBox('Atenção',
                                                                    'Para cancelar a NFC-e: '+Form1.ibDataSet150.FieldByName('NUMERONF').AsString+' insira uma justificativa (min. 15 caracteres)'+chr(10)+
                                                                    chr(10), ''));
          //
          if (Length(sJustificativa) >= 15)
            or _ecf65_XmlNfceCancelado(Form1.ibDataSet150.FieldByName('NFEXML').AsString) then
          begin

            if _ecf65_XmlNfceCancelado(Form1.ibDataSet150.FieldByName('NFEXML').AsString) = False then  // Sandro Silva 2019-07-31
            begin

              Form1.ExibePanelMensagem('Transmitindo cancelamento da NFC-e ' + Form1.IBDataSet150.FieldByName('NFEID').AsString); // Sandro Silva 2017-09-21

              //
              // Cancelamento da NF-e por evento.
              //
              sProtocolo := Copy(Form1.IBDataSet150.FieldByName('NFEXML').AsString, pos('<nProt>',Form1.ibDataSet150.FieldByName('NFEXML').AsString)+7,15);
              //
              try
                sRetorno := Form1.spdNFCe1.CancelarNF(Form1.ibDataSet150.FieldByName('NFEID').AsString,sProtocolo,sJustificativa, FormatDateTime('yyyy-mm-dd"T"hh:nn:"00"',Now), 1, Form1.sFuso);

                sRetorno := _ecf65_CorrigePadraoRespostaSefaz(sRetorno);

                /////////////////////////////
                // Somente para teste. Comentar estas linhas depois de testado
                //
                sRetorno := _ecf65_SimulaSemRetornoSefaz(sRetorno); // Sandro Silva 2020-06-25
                //
                ////////////////////////////

                if Trim(sRetorno) = '' then
                begin
                  //
                  // Timeout atingido sem retorno da SEFAZ
                  // Consulta a NFC-e para saber a situação atual dela
                  try // Sandro Silva 2021-09-13
                    sRetorno := Form1.spdNFCe1.ConsultarNF(LimpaNumero(Form1.ibDataSet150.FieldByName('NFEID').AsString));
                  except

                  end;

                  sRetorno := _ecf65_CorrigePadraoRespostaSefaz(sRetorno);

                  /////////////////////////////
                  // Somente para teste. Comentar estas linhas depois de testado
                  //
                  sRetorno := _ecf65_SimulaSemRetornoSefaz(sRetorno); // Sandro Silva 2020-06-25
                  //
                  ////////////////////////////

                  if (Pos('<cStat>135</cStat>',sRetorno) <> 0) // Recebido pelo Sistema de Registro de Eventos, com vinculação do evento na NF-e,
                    or (Pos('<cStat>136</cStat>',sRetorno) <> 0) // Recebido pelo Sistema de Registro de Eventos – vinculação do evento à respectiva NF-e prejudicada
                  then
                  begin
                    sXmlCancelamento := SalvaXmlCancelamentoEmXmlDestinatario(sRetorno, Form1.ibDAtaSet150.FieldByName('NFEID').AsString);
                  end;

                end;

              except end;
            end
            else
            begin
              sRetorno := Form1.ibDataSet150.FieldByName('NFEXML').AsString; // XML cancelamento
              if FileExists(PChar(Alltrim(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + Form1.ibDAtaSet150.FieldByName('NFEID').AsString+'-caneve.xml'))) = False then // Sandro Silva 2020-09-03 if FileExists(pChar(Alltrim(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + Form1.ibDAtaSet150.FieldByName('NFEID').AsString+'-caneve.xml'))) = False then
              begin
                // Salva o retorno para depois abaixo não ficar em loop esperando o arquivo de cancelamento em xmldestinatario
                sXmlCancelamento := SalvaXmlCancelamentoEmXmlDestinatario(sRetorno, Form1.ibDAtaSet150.FieldByName('NFEID').AsString);
              end;

            end; // if _ecf65_XmlNfceCancelado(Form1.ibDataSet150.FieldByName('NFEXML').AsString) = False then  // Sandro Silva 2019-07-31

            sXmlCancelamento := '';

            Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31

            if (Pos('<cStat>135</cStat>',sRetorno) <> 0)   // Recebido pelo Sistema de Registro de Eventos, com vinculação do evento na NF-e,
              or (Pos('<cStat>136</cStat>',sRetorno) <> 0) // Recebido pelo Sistema de Registro de Eventos – vinculação do evento à respectiva NF-e prejudicada
              or (Pos('<cStat>573</cStat>',sRetorno) <> 0) // Duplicidade do evento de cancelamento
              or FileExists(PChar(Alltrim(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + Form1.ibDAtaSet150.FieldByName('NFEID').AsString+'-caneve.xml'))) then // Sandro Silva 2020-09-03 or FileExists(pChar(Alltrim(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + Form1.ibDAtaSet150.FieldByName('NFEID').AsString+'-caneve.xml'))) then
            begin

              if (Pos('<cStat>573</cStat>',sRetorno) <> 0) then // Duplicidade do evento de cancelamento
              begin
                try // Sandro Silva 2021-09-13
                  sXmlCancelamento := Form1.spdNFCe1.ConsultarNF(Form1.ibDataSet150.FieldByName('NFEID').AsString); // Sandro Silva 2017-09-21
                except

                end;

                sXmlCancelamento := _ecf65_CorrigePadraoRespostaSefaz(sXmlCancelamento);

                sXmlCancelamento := StringReplace(sXmlCancelamento, 'ï»¿','', [rfReplaceAll]);
                if (Pos('<cStat>135</cStat>',sXmlCancelamento) <> 0) then // Confirmação do evento de cancelamento
                begin
                  if xmlNodeXML(sXmlCancelamento, '//procEventoNFe') <> '' then
                    sXmlCancelamento := '<?xml version="1.0" encoding="utf-8"?>' + xmlNodeXML(sXmlCancelamento, '//procEventoNFe')
                  else
                    sXmlCancelamento := '';
                end
                else
                  sXmlCancelamento := '';
              end
              else
              begin
                //  Duplicidade
                iTenta := 1;
                while not FileExists(PChar(Alltrim(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + Form1.ibDAtaSet150.FieldByName('NFEID').AsString+'-caneve.xml'))) do // Sandro Silva 2020-09-03 while not FileExists(pChar(Alltrim(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + Form1.ibDAtaSet150.FieldByName('NFEID').AsString+'-caneve.xml'))) do
                begin
                  //
                  Sleep(100);
                  if iTenta > 600 then // Evitar que fique em loop caso não existir o xml na pasta. 600 * 100 milisegundos equivale a 60 segundo aguardando. Sandro Silva 2019-08-16
                    Break;
                  //
                end;
                //
                if FileExists(PChar(Alltrim(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + Form1.ibDAtaSet150.FieldByName('NFEID').AsString + '-caneve.xml'))) then // Sandro Silva 2020-09-03 if FileExists(pChar(Alltrim(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + Form1.ibDAtaSet150.FieldByName('NFEID').AsString + '-caneve.xml'))) then
                begin
                  //
                  sXmlCancelamento := _ecf65_LoadXmlDestinatario(Form1.ibDataSet150.FieldByName('NFEID').AsString); // Sandro Silva 2024-02-16 sXmlCancelamento := _ecf65_LoadXmlDestinatario(PAnsiChar(Form1.ibDataSet150.FieldByName('NFEID').AsString));
                  //
                end;
              end;

              if sXmlCancelamento <> '' then
              begin

                if FileExists(PChar(Alltrim(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + Form1.ibDAtaSet150.FieldByName('NFEID').AsString + '-caneve.xml'))) = False then // Sandro Silva 2020-09-03 if FileExists(pChar(Alltrim(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + Form1.ibDAtaSet150.FieldByName('NFEID').AsString + '-caneve.xml'))) = False then
                  SalvaXmlCancelamentoEmXmlDestinatario(sXmlCancelamento, Form1.ibDAtaSet150.FieldByName('NFEID').AsString);

                Form1.ibDataSet150.Edit;
                Form1.ibDataSet150.FieldByName('STATUS').AsString := NFCE_STATUS_CANCELAMENTO; // Sandro Silva 2021-12-07 'Cancelamento Registrado e vinculado a NFCe';// Sandro Silva 2017-09-29  'Cancelamento Registrado e viculado a NFCe';
                Form1.ibDataSet150.FieldByName('NFEXML').AsString := sXmlCancelamento;
                Form1.IBDataSet150.FieldByName('TOTAL').Clear; // Ficha 4302 Sandro Silva 2018-12-05
                Form1.IBDataSet150.FieldByName('NFEIDSUBSTITUTO').Clear; // Sandro Silva 2019-08-27
                Form1.ibDataSet150.Post;
                //
                Result := True;
              end;

              //
            end else
            begin
              //
              sStatus := '';
              while sRetorno <> '' do
              begin
                if copy(sRetorno,1,9)='<xMotivo>' then
                begin
                  sStatus  := sStatus + chr(10) + Copy(sRetorno,10,Pos('</xMotivo>',sRetorno)-10);
                  sRetorno := Copy(sRetorno,9,Length(sRetorno)-10);
                end else
                begin
                  sRetorno := Copy(sRetorno,2,Length(sRetorno)-1);
                end;
              end;

              if sStatus = '' then
                sStatus := 'Nenhuma resposta da SEFAZ';

              //
              SmallMsg(sStatus);
              //
            end;
          end else
          begin
            if AllTrim(sJustificativa) <> '' then
            begin
              SmallMsg('A justificativa tem que ter no mínimo 15 caracteres.');
            end;
          end;
          //
        except end;
      end;
    end;
    //
  except end;
  //
  Screen.Cursor            := crDefault;
  //
end;

function _ecf65_CancelaNFCePorSubstituicao(sNfeIdCancelar: String;
  sJustificativa: String; sNfeIdContingencia: String;
  var sRetorno: String): Boolean;
var
  sDataHoraEvento: String;
  sRetornoConsultaRecibo: String;
  sProtocoloCancelar: String;
  iTenta: Integer;
begin
  Result := False;
  //
  try
    sRetorno := '';
    try // Sandro Silva 2021-09-13
      sRetornoConsultaRecibo := Form1.spdNFCe1.ConsultarNF(sNfeIdCancelar);
    except

    end;

    sRetornoConsultaRecibo := _ecf65_CorrigePadraoRespostaSefaz(sRetornoConsultaRecibo);

    // Sandro Silva 2022-04-12 if (Pos('<cStat>100</cStat>', sRetornoConsultaRecibo) <> 0) or (Pos('<cStat>150</cStat>', sRetornoConsultaRecibo) <> 0) then // 100|Autorizado o uso da NF-e ou 150|Autorizado o uso da NF-e, autorização fora de prazo // Sandro Silva 2018-08-10
    if _ecf65_xmlAutorizado(sRetornoConsultaRecibo) then
    begin

      sProtocoloCancelar := LimpaNumero(xmlNodeValue(sRetornoConsultaRecibo, '//infProt/nProt'));

      if sProtocoloCancelar <> '' then
      begin

        sDataHoraEvento := FormatDateTime('yyyy-mm-dd', Date) + 'T' + FormatDateTime('HH:nn:ss', Time);

        sRetorno := Form1.spdNFCe1.CancelarNFSubstituicao(sNfeIdCancelar, sProtocoloCancelar, ConverteAcentosXML(sJustificativa), sDataHoraEvento, StrToInt('1'), Form1.sFuso, Copy(sNfeIdCancelar, 1, 2), Build, sNfeIdContingencia, taEmpresaEmitente, FormatDateTime('yymmddHHnnsszzz', Now));

        sRetorno := _ecf65_CorrigePadraoRespostaSefaz(sRetorno);

        if Trim(sRetorno) = '' then
        begin
          // Não houve retorno da SEFAZ, tenta 3x com intervalos de 5 segundos entre tentativas
          Sleep(5000);
          for iTenta := 1 to 3 do
          begin
            try // Sandro Silva 2021-09-13
              sRetorno := Form1.spdNFCe1.ConsultarNF(sNfeIdCancelar);
            except

            end;

            sRetorno := _ecf65_CorrigePadraoRespostaSefaz(sRetorno);

            if Trim(sRetorno) <> '' then
              Break;

            Sleep(5000);
          end;
        end;

        if Pos('<cStat>573</cStat>', sRetorno) > 0 then // Rejeição: Duplicidade de Evento cancelamento
        begin
          try // Sandro Silva 2021-09-13
            sRetorno := Form1.spdNFCe1.ConsultarNF(sNfeIdCancelar);
          except

          end;

          sRetorno := _ecf65_CorrigePadraoRespostaSefaz(sRetorno);

        end;

        if _ecf65_XmlNfceCancelado(sRetorno) then
        begin
         //Se retornou cancelado, tenta localizar o xml na pasta xmldestinario para salvar no banco
         if _ecf65_LoadXmlDestinatario(sNfeIdCancelar) <> '' then
           sRetorno := _ecf65_LoadXmlDestinatario(sNfeIdCancelar);
        end;

        // Stat de cancelamento por substituição e tipo de evento de cancelmento por substituição
        Result := (Pos('<cStat>135</cStat>', sRetorno) > 0) and (Pos('<tpEvento>110112</tpEvento>', sRetorno) > 0);

      end;

      if Trim(sRetorno) = '' then
        sRetorno := 'Sem retorno da SEFAZ';

    end;

  except

  end;
end;

procedure _ecf65_GeraXmlCorrigindoDados(iPedido: Integer; sCaixaXml: String); // Sandro Silva 2018-03-05
// Gera novo XML a partir daquele salvo em NFCE.NFEXML, atualizando os dados
var
  //
  Mais1Ini : tIniFile;
  bButton, I : Integer;
  fTotalTributos, fValorProdutos, fTotalSemDesconto, fDescontoDoItem, fDescontoTotalRateado, fDesconto, rBaseICMS, rValorICMS : Real;
  dvBC_U02: Double; // 2015-12-09
  dvISSQN_U04: Double; // 2015-12-09
  dvServ_W18: Double; // 2015-12-09
  dvBC_W19: Double; // 2015-12-09
  dvAliq_U03: Double; // 2015-12-09
  dvISS_W20: Double; // 2015-12-09
  dvPIS_W21: Double; // 2015-12-09
  dvCOFINS_W22: Double; // 2015-12-09
  dAcrescimoTotal: Double; //2015-12-07
  dRateioAcrescimoItem: Double; // 2015-12-10
  dDescontoTotalCupom: Double; // 2015-12-10
  dvOutro_W15: Double; // 2015-12-10
  sNovoNumero, sStatus, sID, sRetorno, sLote: String;
  Hora, Min, Seg, cent : Word;
  tInicio : tTime;
  dtEnvio: TDate; // Sandro Silva 2015-03-30 Data do envio. Usado para atualizar ALTERACA.DATA mantendo NFCE.DATA = ALTARACA.DATA.
  hrEnvio: String; // Sandro Silva 2015-03-30 Data do envio. Usado para atualizar ALTERACA.HORA mantendo igual ao XML quando itens são vendidos em dias diferentes. Ex.: Mesa
  wsNFCeAssinada: WideString;
  dvTotTrib_M02: Double; // Sandro Silva 2015-05-06 Total do aprox. tributo do produto
  dvBC_N15: Double; // Sandro Silva 2018-02-19
  dvFCP_N17c: Real;// Double; // Sandro Silva 2018-02-19
  dvFCP_W04h: Real; // Double; // Sandro Silva 2018-02-19
  dpICMS_N16: Double; // Sandro Silva 2016-01-16 Alíquota do imposto ICMS
  dvICMS_N17: Double; // Sandro Silva 2015-05-07 Total ICMS do produto;
  dvProd_I11: Double; // Sandro Silva 2015-10-16 Valor do Produto
  dvDesc_I17: Double; // Sandro Silva 2016-01-11
  dvBCPIS_Q07: Double; // Sandro Silva 2017-04-24
  dvPIS_Q09: Double; // Sandro Silva 2016-09-30
  dvCOFINS_S11: Double; // Sandro Silva 2016-09-30
  dvBCCofins_S07: Double; // Sandro Silva 2017-04-24
  dvPIS_W13: Double; // Sandro Silva 2016-09-30
  dvCofins_W14: Double; // Sandro Silva 2016-09-30
  dvBCEfet_N35: Real; // Sandro Silva 2019-02-05
  dpRedBCEfet_N34: Double; // Sandro Silva 2019-02-05
  dpICMSEfet_N36: Double; // Sandro Silva 2019-02-05
  dpRedBC_N14: Real; // Sandro Silva 2019-02-08
  dvICMSDeson_N28a: Real; // Sandro Silva 2019-08-29
  dvICMSDeson_W04a: Real; // Sandro Silva 2019-08-29
  dvICMSMonoRet_N45: Real; // Sandro Silva 2023-05-19
  dvICMSMonoRet_N45Total: Real; // Sandro Silva 2023-05-19
  dqBCMonoRet_N43aTotal: real; // Sandro Silva 2023-09-04
  sMensagemIcmMonofasicoSobreCombustiveis: String; // Sandro Silva 2023-09-05
  //
  bOk: Boolean; // Sandro Silva 2015-06-02
  sLogErro: String; // Sandro Silva 2015-06-02
  sLogErroItens: String; // Sandro Silva 2017-08-15
  sPdfMobile: String;
  // Sandro Silva 2019-07-24  sVendedorNome: String;
  sHintAtual: String;
  sDAV: String;
  sTIPODAV: String;
  dtAlteracaData: TDate;
  //aAcrescimoItem: array of Double; // 2016-01-08
  //aDescontoItem: array of Double; // 2016-01-08
  schNFe: String;
  sArqPrimeiroEnvio: String; // Sandro Silva 2016-03-14
  sArqRetSituacao: String; // Sandro Silva 2016-03-14
  sDigestValue: String; // Sandro Silva 2016-03-14
  sXMLConsulta: String; // Sandro Silva 2016-03-16
  sDataXMLRecuperado: String;
  sDataEmitidaXMLRecuperado: String;
  sDataAutorizadaXMLRecuperado: String;
  sValorXMLRecuperado: String;
  //stBand_YA06: String; // Sandro Silva 2016-03-21
  sValorTroco: String; // Sandro Silva 2016-07-14
  sValorRecebido: String; // Sandro Silva 2016-07-14
  svNF_W16: String;
  sCSTPISCofins: String; // Sandro Silva 2016-09-30
  sCNPJ_YA05: String; // Sandro Silva 2016-11-22 CNPJ da adminstradora do cartão
  dvPag_YA03_10: Double; // Sandro Silva 2016-08-12
  dvPag_YA03_11: Double; // Sandro Silva 2016-08-12
  dvPag_YA03_12: Double; // Sandro Silva 2016-08-12
  dvPag_YA03_13: Double; // Sandro Silva 2016-08-12
  dvPag_YA03_16: Double; // Sandro Silva 2021-03-05
  dvPag_YA03_17: Double; // Sandro Silva 2021-03-05
  dvPag_YA03_18: Double; // Sandro Silva 2021-03-05
  dvPag_YA03_19: Double; // Sandro Silva 2021-03-05
  dvPag_YA03_20: Double; // Sandro Silva 2024-07-01

  dvPag_YA03_99: Double; // Sandro Silva 2016-08-12
  iTentaConsulta: Integer; // Sandro Silva 2017-02-02
  iTransacaoCartao: Integer; // Sandro Silva 2017-06-15
  XMLNFE: IXMLDOMDocument;
  xNodePag: IXMLDOMNodeList;
  iNode: Integer;
  IBQALTERACA: TIBQuery; // Query com mesma TTransaction de FORM1.IBDATASET27 para ler dados salvos no alteraca pelo FORM1.IBDATASET27 Sandro Silva 2019-08-05
  sResultado: String; // Sandro Silva 2020-02-13
begin
  //
  // 12:917
  //
  //bButton := -1;
  sResultado := '';
  tInicio := Time;
  Screen.Cursor := crHourGlass;
  sCNPJ_YA05 := '';
  //
  // 1 - Enviar NFC-e
  //
  Form1.ExibePanelMensagem('Aguarde, enviando NFC-e...');
  //

  IBQALTERACA := CriaIBQuery(Form1.ibDataSet27.Transaction); // Sandro Silva 2019-08-05

  if Form1.ibDataset150.FieldByName('NFEXML').AsString <> '' then
  begin
    XMLNFE := CoDOMDocument.Create;
    XMLNFE.loadXML(Form1.ibDataset150.FieldByName('NFEXML').AsString);

    Form1.ibDataset150.Close;
    Form1.ibDataset150.SelectSql.Clear;
    Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF = ' + QuotedStr(FormataNumeroDoCupom(iPedido)) + ' and CAIXA = ' + QuotedStr(sCaixaXml)); // Sandro Silva 2021-12-01 Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF = ' + QuotedStr(StrZero(iPedido,6,0)) + ' and CAIXA = ' + QuotedStr(sCaixaXml));
    Form1.ibDataset150.Open;

    if ((Pos('contingência', AnsiLowerCase(Form1.ibDataset150.FieldByName('STATUS').AsString)) > 0)
        or (Pos('<tpEmis>9</tpEmis>', Form1.ibDataset150.FieldByName('NFEXML').AsString) > 0))
      and (Form1.UsaIntegradorFiscal() = False) // Sandro Silva 2019-10-16 
    then
    begin
      if xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//ide/dhEmi') <> '' then
      begin
        if sDataXMLRecuperado = '' then
          sDataXMLRecuperado := Form1.ibDataset150.FieldByName('NFEXML').AsString;
        sDataEmitidaXMLRecuperado := xmlNodeValue(sDataXMLRecuperado, '//ide/dhEmi');
        sDataEmitidaXMLRecuperado := Copy(sDataEmitidaXMLRecuperado, 9, 2) + '/' + Copy(sDataEmitidaXMLRecuperado, 6, 2) + '/' + Copy(sDataEmitidaXMLRecuperado, 1, 4) + ' ' + Copy(sDataEmitidaXMLRecuperado, 12, 8);
        dtEnvio := StrToDateTimeDef(sDataEmitidaXMLRecuperado, Now);
      end
      else
        dtEnvio := StrToDate(FormatDateTime('dd/mm/yyyy', Form1.ibDataset150.FieldByName('DATA').AsDateTime)) + Time
    end
    else
      dtEnvio := Now; // Sandro Silva 2015-03-30 Manter ALTERACA.DATA = NFCE.DATA

    bOk     := False;
    wsNFCeAssinada := ''; // 2015-07-23
    fNFe           := ''; // 2015-07-23
    sValorRecebido := ''; // Sandro Silva 2016-07-14
    sValorTroco    := ''; // Sandro Silva 2016-07-14
    svNF_W16       := ''; // Sandro Silva 2016-07-14
    dvPIS_W13      := 0.00; // Sandro Silva 2016-09-30
    dvCofins_W14   := 0.00; // Sandro Silva 2016-09-30
    dvPIS_Q09      := 0.00; // Sandro Silva 2016-09-30
    dvCOFINS_S11   := 0.00; // Sandro Silva 2016-09-30
    try
      try

        sCNPJ_YA05 := '';
        Form1.sNomeRede := '';
        //Identifica o nome da rede, quando pagamento com cartão
        if XMLNFE.selectNodes('//detPag[tPag=''03'' or tPag=''04'']/card/CNPJ').length > 0 then
        begin
          if CpfCgc(LimpaNumero(_ecf65_CNPJAdministradoraCartao(XMLNFE.selectNodes('//detPag[tPag=''03'' or tPag=''04'']/card/CNPJ').item[0].xml))) then
          begin
            // Busca o nome da administradora do cartão a partir dos dados nas parcelas em RECEBER
            Form1.ibDataset99.Close;
            Form1.ibDataset99.SelectSql.Clear;
            Form1.ibDataset99.SelectSQL.Add('select NOME ' +
              'from RECEBER ' +
              'where NUMERONF = ' + QuotedStr(FormataNumeroDoCupom(iPedido) + sCaixaXml) +
              ' and upper(HISTORICO) like ''%CART_O%'' ' +
              ' order by REGISTRO desc');
            Form1.ibDataset99.Open;

            Form1.sNomeRede := Form1.ibDataset99.FieldByName('NOME').AsString;
            sCNPJ_YA05      := LimpaNumero(_ecf65_CNPJAdministradoraCartao(XMLNFE.selectNodes('//detPag[tPag=''03'' or tPag=''04'']/card/CNPJ').item[0].xml));
          end;

        end;

        //
        //
        Form1.ibDataset99.Close;
        Form1.ibDataset99.SelectSql.Clear;
        Form1.ibDataset99.SelectSQL.Add('select * from MUNICIPIOS where NOME='+QuotedStr(Form1.ibDataSet13.FieldByname('MUNICIPIO').AsString)+' '+' and UF='+QuotedStr(UpperCase(Form1.ibDataSet13.FieldByname('ESTADO').AsString))+' ');
        Form1.ibDataset99.Open;
        //
        Form1.spdNFCeDataSets1.Cancelar;
        Form1.spdNFCeDataSets1.LoteNFCe.Clear;

        Form1.spdNFCeDataSets1.Incluir;         // Inicia a insercao de dados na NFe
        //
        Form1.spdNFCeDataSets1.Campo('cUF_B02').Value    := Copy(Form1.IBDataSet99.FieldByname('CODIGO').AsString,1,2);  //Codigo da UF para o estado SC = '42'
        if xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//ide/cNF') = '' then // Sandro Silva 2019-05-03 Regra B03-10
          Form1.spdNFCeDataSets1.Campo('cNF_B03').Value    := '07426598'
        else // cNF informado anteriormente
          Form1.spdNFCeDataSets1.Campo('cNF_B03').Value    := xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//ide/cNF');// Código Interno do Sistema que está integrando com a NFe Regra B03-10 // Sandro Silva 2019-05-03 Form1.spdNFCeDataSets1.Campo('cNF_B03').Value    := '12345678'; // Código Interno do Sistema que está integrando com a NFe
        Form1.spdNFCeDataSets1.Campo('natOp_B04').Value  := 'VENDA'; // Sandro Silva 2018-03-02 Poder ser venda de produção própria tbm  'VENDA MERC.ADQ.REC.TERC';
        //
        //
        Form1.spdNFCeDataSets1.Campo('mod_B06').Value     := '65';                       // Código do Modelo de Documento Fiscal
        Form1.spdNFCeDataSets1.Campo('serie_B07').Value   := xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//ide/serie'); // Sandro Silva 2021-11-12 '1';                        // Série do Documento
        Form1.spdNFCeDataSets1.Campo('nNF_B08').Value     := IntToStr(iPedido); // StrZero(sPedido,6,0);  // Número da Nota Fiscal
        //
        Form1.spdNFCeDataSets1.Campo('dhEmi_B09').Value   := FormatDateTime('YYYY-mm-dd"T"HH:mm:ss', dtEnvio) + Form1.sFuso; //Data e Hora de emissão do Documento Fiscal
        Form1.spdNFCeDataSets1.Campo('tpNF_B11').Value    := '1'; // Tipo de Documento Fiscal (0-Entrada, 1-Saída)
        //
        // Identificador do local de destino da operação
        //
        Form1.spdNFCeDataSets1.Campo('idDest_B11a').Value := '1'; // Utilize: 1-Operação interna / 2-Operação interestadual / 3-Operação com exterior
        Form1.spdNFCeDataSets1.Campo('cMunFG_B12').Value  := Copy(Form1.ibDAtaSet99.FieldByname('CODIGO').AsString,1,7); // Código da Cidade do Emitente (Tabela do IBGE)
        //
        // Formato do DANFE
        //
        Form1.spdNFCeDataSets1.Campo('tpImp_B21').Value   := '4'; // 0-Sem geração de DANFE; 1-DANFE normal , Retrato; 2-DANFE normal, Paisagem; 3-DANFE Simplificado; 4-DANFE NFC-e; 5-DANFE NFC-e em mensagem eletrônica. Nota: O envio de mensagem eletrônica pode ser feita de forma simultânea com a impressão do DANFE. Usar o tpImp=5 quando esta for a única forma de disponibilização do DANFE.
        //
        // Tipo de Emissão
        //
        Form1.spdNFCeDataSets1.Campo('tpEmis_B22').Value  := xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//ide/tpEmis');// '1'; // 1- Emissão normal (não em contingência); 2- Contingência FS-IA, com impressão do DANFE em formulário de segurança; 3- Contingência SCAN (Sistema de Contingência do Ambiente Nacional); 4- Contingência DPEC (Declaração Prévia da Emissão em Contingência); 5- Contingência FS-DA, com impressão do DANFE em formulário de segurança; 6- Contingência SVC-AN (SEFAZ Virtual de Contingência do AN); 7- Contingência SVC-RS (SEFAZ Virtual de Contingência do RS); 9- Contingência off-line da NFC-e (as demais opções de contingência são válidas também para a NFC-e); Nota: As opções de contingência 3, 4, 6 e 7 (SCAN, DPEC e SVC) não estão disponíveis no momento atual.
        {Sandro Silva 2023-06-14 inicio
        if Form1.UsaIntegradorFiscal() then  // Sandro Silva 2019-10-16
          Form1.spdNFCeDataSets1.Campo('tpEmis_B22').Value  := TPEMIS_NFCE_NORMAL;
        }
        //
        // Contingência
        //
        if Form1.spdNFCeDataSets1.Campo('tpEmis_B22').Value  = TPEMIS_NFCE_CONTINGENCIA_OFFLINE then // Papel normal Contingência
        begin
          Form1.spdNFCeDataSets1.Campo('xJust_B29').Value   := xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//ide/xJust');
          Form1.spdNFCeDataSets1.Campo('dhCont_B28').Value  := xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//ide/dhCont');
        end;
        //
        Form1.spdNFCeDataSets1.Campo('cDV_B23').Value     := '3'; // Calcula Automatico - Linha desnecessária já que o componente calcula o Dígito Verificador automaticamente e coloca no devido campo
        //
        if Form1.spdNFCe1.Ambiente = akHomologacao then
        begin
          Form1.spdNFCeDataSets1.Campo('tpAmb_B24').Value := TPAMB_HOMOLOGACAO;  // 1-produção 2-Homologação
        end else
        begin
          Form1.spdNFCeDataSets1.Campo('tpAmb_B24').Value := TPAMB_PRODUCAO;  // 1-produção 2-Homologação
        end;

        _ecf65_IdentificacaoResponsavelTecnico(Form1.spdNFCeDataSets1); // Sandro Silva 2021-03-01

        //
        Form1.spdNFCeDataSets1.Campo('finNFe_B25').Value    := '1'; // Finalidade da NFe (1-Normal, 2-Complementar, 3-de Ajuste)
        Form1.spdNFCeDataSets1.Campo('indFinal_B25a').Value := '1'; // 0-Não/1-Consumidor Final
        Form1.spdNFCeDataSets1.Campo('indPres_B25b').Value  := INDPRES_OPERACAO_PRESENCIAL; // 1-Operação presencial/2-Operação não presencial, pela internet/3- Operação não presencial, Teleatendimento/9- Operação não presencial, outros.
        if Form1.ClienteSmallMobile.ImportandoMobile then // Sandro Silva 2022-08-08 if ImportandoMobile then
        begin
          if Form1.N4001.Checked then
          begin
            // Sandro Silva 2018-02-23 Servidor AM não aceitou o novo indPres 5=Operação presencial, fora do estabelecimento, para venda ambulante
            Form1.spdNFCeDataSets1.Campo('indPres_B25b').Value  := INDPRES_OPERACAO_PRESENCIAL; // 0=Não se aplica (por exemplo, Nota Fiscal complementar ou de ajuste); 1=Operação presencial; 2=Operação não presencial, pela Internet; 3=Operação não presencial, Teleatendimento; 4=NFC-e em operação com entrega a domicílio; 5=Operação presencial, fora do estabelecimento; 9=Operação não presencial, outros.
          end;
        end;
        //
        Form1.spdNFCeDataSets1.Campo('procEmi_B26').Value := '0'; // Identificador do Processo de emissão (0-Emissão da Nfe com Aplicativo do Contribuinte). Ver outras opções no manual da Receita.
        Form1.spdNFCeDataSets1.Campo('verProc_B27').Value := Build;//2015-05-19 '000'; // Versão do Aplicativo Emissor
        //
        //
        // Dados do emitente
        //
        Form1.spdNFCeDataSets1.Campo('CNPJ_C02').Value    := LimpaNumero(Form1.ibDataSet13.FieldByname('CGC').AsString); // CNPJ do Emitente
        Form1.spdNFCeDataSets1.Campo('xNome_C03').Value   := Trim(ConverteAcentos2(Form1.ibDataSet13.FieldByname('NOME').AsString)); // Razao Social ou Nome do Emitente
        Form1.spdNFCeDataSets1.Campo('xFant_C04').Value   := Trim(ConverteAcentos2(Form1.ibDataSet13.FieldByname('NOME').AsString)); // Nome Fantasia do Emitente
        Form1.spdNFCeDataSets1.Campo('xLgr_C06').Value    := Trim(ConverteAcentos2(Endereco_Sem_Numero(Form1.ibDataSet13.FieldByname('ENDERECO').AsString))); // Logradouro do Emitente
        Form1.spdNFCeDataSets1.Campo('nro_C07').Value     := Trim(Numero_Sem_Endereco(Form1.ibDataSet13.FieldByname('ENDERECO').AsString)); // Numero do Logradouro do Emitente
        Form1.spdNFCeDataSets1.Campo('xBairro_C09').Value := Trim(ConverteAcentos2(Form1.ibDataSet13.FieldByname('COMPLE').AsString)); // Bairro do Emitente
        Form1.spdNFCeDataSets1.Campo('cMun_C10').Value    := Copy(Form1.ibDAtaSet99.FieldByname('CODIGO').AsString,1,7); // Código da Cidade do Emitente (Tabela do IBGE)
        Form1.spdNFCeDataSets1.Campo('xMun_C11').Value    := Trim(ConverteAcentos2(Form1.ibDAtaSet99.FieldByname('NOME').AsString)); // Nome da Cidade do Emitente
        Form1.spdNFCeDataSets1.Campo('UF_C12').Value      := Form1.ibDAtaSet99.FieldByname('UF').AsString; // Código do Estado do Emitente (Tabela do IBGE)
        Form1.spdNFCeDataSets1.Campo('CEP_C13').Value     := LimpaNumero(Form1.ibDataSet13.FieldByname('CEP').AsString); // Cep do Emitente
        //
        if Alltrim(ConverteAcentos2(Form1.ibDAtaSet99.FieldByname('NOME').AsString))='' then
        begin
          sLogErro := 'Erro: Verifique o CEP do emitente';
          Exit;
        end;
        //
        Form1.spdNFCeDataSets1.Campo('cPais_C14').Value   := '1058'; // Código do País do Emitente (Tabela BACEN)
        Form1.spdNFCeDataSets1.Campo('xPais_C15').Value   := 'BRASIL'; // Nome do País do Emitente
        //
        Form1.spdNFCeDataSets1.Campo('IE_C17').Value      := LimpaNumero(Form1.ibDataSet13.FieldByname('IE').AsString); // Inscrição Estadual do Emitente
        //
        if LimpaNumero(Form1.ibDataSet13.FieldByname('IM').AsString) <> '' then
        begin
          Form1.spdNFCeDataSets1.Campo('IM_C19').Value    := StrTran(LimpaNumero(Form1.ibDataSet13.FieldByname('IM').AsString),'-',''); // Inscrição Estadual do Emitente
          //
          if AllTrim(Form1.ibDataSet13.FieldByname('CNAE').AsString) <> '' then
          begin
            Form1.spdNFCeDataSets1.Campo('CNAE_C20').Value    := AllTrim(Form1.ibDataSet13.FieldByname('CNAE').AsString); // CNAE
          end else
          begin
            Form1.spdNFCeDataSets1.Campo('CNAE_C20').Value    := '0000000'; // CNAE
          end;
          //
        end;

        _ecf65_AdicionaCNPJCOntabilidade(Form1.spdNFCeDataSets1); // Sandro Silva 2020-09-01

        Form1.ibDataSet27.Close;
        Form1.ibDataSet27.SelectSQL.Clear;
        Form1.ibDataSet27.SelectSQL.Text :=
          'select A.* ' +
          'from ALTERACA A ' +
          'where A.PEDIDO = ' + QuotedStr(FormataNumeroDoCupom(iPedido)) + // Sandro Silva 2021-12-01 where A.PEDIDO = ' + QuotedStr(strZero(iPedido,6,0)) +
          ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
          ' and A.CAIXA = ' + QuotedStr(sCaixaXml) +
          //' and A.DATA = ' + QuotedStr(FormataDataSQL(dtData)) +
          ' and A.DESCRICAO = ''Acréscimo'' ' +
          ' and coalesce(A.ITEM, '''') = '''' ';
        Form1.ibDataSet27.Open;

        dAcrescimoTotal     := 0.00;
        while Form1.ibDataSet27.Eof = False do
        begin
          dAcrescimoTotal := dAcrescimoTotal + Form1.ibDataSet27.FieldByName('TOTAL').AsFloat;

          Form1.ibDataSet27.Next;
        end;

        // Seleciona os desconto lançados para a venda (tanto nos itens qto no total do cupom)
        Form1.ibDataSet27.Close;
        Form1.ibDataSet27.SelectSQL.Clear;
        Form1.ibDataSet27.SelectSQL.Text :=
          'select A.* ' +
          'from ALTERACA A ' +
          'where A.PEDIDO = ' + QuotedStr(FormataNumeroDoCupom(iPedido)) + // Sandro Silva 2021-12-01 'where A.PEDIDO = ' + QuotedStr(strZero(iPedido,6,0)) +
          ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
          ' and A.CAIXA = ' + QuotedStr(sCaixaXml) +
          ' and A.DESCRICAO = ''Desconto'' ';
        Form1.ibDataSet27.Open;

        Form1.fDescontoNoTotal := 0.00; // Sandro Silva 2018-08-06
        dDescontoTotalCupom    := 0.00; // 2015-12-10
        while Form1.ibDataSet27.Eof = False do
        begin
          dDescontoTotalCupom := dDescontoTotalCupom + Form1.ibDataSet27.FieldByName('TOTAL').AsFloat;

          if (AllTrim(Form1.ibDataSet27.FieldByName('DESCRICAO').AsString) = 'Desconto') and (AllTrim(Form1.ibDataSet27.FieldByName('ITEM').AsString) = '') then
          begin // Corrigir casos que ao entrar em contingência zerou Form1.fDescontoNoTotal, gerando xml com ICMSTot/vDesc zerado e ICMSTot/vNF com valor diferente da soma dos detPag/vPag
            Form1.fDescontoNoTotal := Form1.ibDataSet27.FieldByName('TOTAL').AsFloat * -1;
          end;

          Form1.ibDataSet27.Next;
        end;
        dDescontoTotalCupom := Abs(dDescontoTotalCupom); // 2015-12-10 Desconsidera o sinal negativo, usa o valor absoluto
        //
        Form1.ibDataSet27.Close;
        Form1.ibDataSet27.SelectSQL.Clear;
        Form1.ibDataSet27.SelectSQL.Text :=
          'select * ' +
          'from ALTERACA ' +
          'where CAIXA = ' + QuotedStr(sCaixaXml) +
          ' and PEDIDO = ' + QuotedStr(FormataNumeroDoCupom(iPedido)) + ' ' + // Sandro Silva 2021-12-01 ' and PEDIDO = ' + QuotedStr(StrZero(iPedido,6,0)) + ' ' +
          ' order by ITEM'; // Sandro Silva 2021-06-08 Ordenar por ITEM para depois no SPED selecionar certo no xml
        Form1.ibDataSet27.Open;
        //
        Form1.ibDataSet27.First;

        dtAlteracaData := Form1.ibDataSet27.FieldByName('DATA').AsDateTime; //  Data da venda, usado para atualizar o número da NFCe em ALTERACA.PEDIDO.
        
        if Form1.ClienteSmallMobile.ImportandoMobile then // Sandro Silva 2022-08-08 if ImportandoMobile then
          sPdfMobile := Form1.sAtual + '\mobile\' + StringReplace(Form1.ClienteSmallMobile.sVendaImportando, TIPOMOBILE, '', [rfReplaceAll]) + '.pdf';

        //
        if (xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//dest/CNPJ') <> '') or (xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//dest/CPF') <> '') then//if (Form1.ibDataSet27.FieldByName('CLIFOR').AsString = Form1.ibDataSet2.FieldByName('NOME').AsString) and (Alltrim(Form1.ibDataSet27.FieldByName('CLIFOR').AsString)<>'') then
        begin
          //
          if (xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//dest/CNPJ') <> '') then
            Form1.spdNFCeDataSets1.Campo('CNPJ_E02').Value := xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//dest/CNPJ'); // CNPJ do Destinatário
          if (xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//dest/CPF') <> '') then
            Form1.spdNFCeDataSets1.Campo('CPF_E03').Value := xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//dest/CPF'); // CPF do Destinatário

          if Form1.spdNFCe1.Ambiente = akHomologacao then
          begin
            //
            // Ronei - Alteracao feita a pedido de Lucilene - Auditora fiscal do TO
            //
            Form1.spdNFCeDataSets1.Campo('xNome_E04').Value := Trim(ConverteAcentos2('NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL'));// Sandro Silva 2018-10-31 'NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL';
            //
          end else
          begin
            //
            // Ronei - Alteracao feita a pedido de Lucilene - Auditora fiscal do TO
            //
            if xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//dest/xNome') <> '' then
              Form1.spdNFCeDataSets1.Campo('xNome_E04').Value := xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//dest/xNome');
            //
          end;
          //
          //
          // Quando o consumidor é de fora pega os dados locais
          //
          Form1.spdNFCeDataSets1.Campo('xLgr_E06').Value    := xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//dest/enderDest/xLgr'); // Logradouro do Emitente
          Form1.spdNFCeDataSets1.Campo('nro_E07').Value     := xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//dest/enderDest/nro'); // Numero do Logradouro do Emitente
          Form1.spdNFCeDataSets1.Campo('xBairro_E09').Value := xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//dest/enderDest/xBairro'); // Bairro do Destinatario
          Form1.spdNFCeDataSets1.Campo('cMun_E10').Value    := xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//dest/enderDest/cMun'); // Código do Município do Destinatário (Tabela IBGE)
          Form1.spdNFCeDataSets1.Campo('xMun_E11').Value    := xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//dest/enderDest/xMun'); // Nome da Cidade do Destinatário
          Form1.spdNFCeDataSets1.Campo('UF_E12').Value      := xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//dest/enderDest/UF'); // Sigla do Estado do Destinatário
          Form1.spdNFCeDataSets1.Campo('CEP_E13').Value     := xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//dest/enderDest/CEP');; // Cep do Destinatário
          Form1.spdNFCeDataSets1.Campo('cPais_E14').Value   := xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//dest/enderDest/cPais');   // Código do Pais do Destinatário (Tabela do BACEN)
          Form1.spdNFCeDataSets1.Campo('xPais_E15').Value   := xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//dest/enderDest/xPais'); // Nome do País do Destinatário

          // aqui igual como feito em enviarNFCe()
          if xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//ide/indPres') = '4' then // 4-NFC-e em operação com entrega a domicílio;
          begin
            //muda indPres para 4-entrega a domicílio
            Form1.spdNFCeDataSets1.Campo('indPres_B25b').Value := '4'; // 4-NFC-e em operação com entrega a domicílio;

            // Tags transporte, usa dados do emitente
            Form1.spdNFCeDataSets1.Campo('CNPJ_X04').Value   := Form1.spdNFCeDataSets1.Campo('CNPJ_C02').Value;
            Form1.spdNFCeDataSets1.Campo('xNome_X06').Value  := Form1.spdNFCeDataSets1.Campo('xNome_C03').Value;
            Form1.spdNFCeDataSets1.Campo('IE_X07').Value     := Form1.spdNFCeDataSets1.Campo('IE_C17').Value;
            Form1.spdNFCeDataSets1.Campo('xEnder_X08').Value := Form1.spdNFCeDataSets1.Campo('xLgr_C06').Value + ' ' + Form1.spdNFCeDataSets1.Campo('nro_C07').Value;
            Form1.spdNFCeDataSets1.Campo('xMun_X09').Value   := Form1.spdNFCeDataSets1.Campo('xMun_C11').Value;
            Form1.spdNFCeDataSets1.Campo('UF_X10').Value     := Form1.spdNFCeDataSets1.Campo('UF_C12').Value;
          end;
          //
        end;

        {Sandro Silva 2021-02-05 inicio }//  Ficha 5268
        if Pos('|' + Form1.spdNFCeDataSets1.Campo('indPres_B25b').Value + '|', '|1|4|') > 0 then // Sandro Silva 2022-04-06 if Pos('|' + Form1.spdNFCeDataSets1.Campo('indPres_B25b').Value + '|', '|1|2|3|4|9|') > 0 then
        begin
          // 1=Operação presencial; 2=Operação não presencial, pela Internet; 3=Operação não presencial, Teleatendimento; 4=NFC-e em operação com entrega a domicílio; ou 9=Operação não presencial, outros.
          if LerParametroIni(FRENTE_INI, SECAO_65, 'indIntermed', 'Não') = 'Sim' then
          begin
            Form1.spdNFCeDataSets1.Campo('IndIntermed_B25c').Value := '0'; // 0=Operação sem intermediador (em site ou plataforma própria)

            {Sandro Silva 2022-04-06 inicio}
            try
              //
              // Seleciona dados do Intermediador (Marketplace) que foram lançados no xml
              //
              if xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//infIntermed/CNPJ') <> '' then // Identifica que foi preenchido dados do intermediador no xml
              begin
                //
                Form1.spdNFCeDataSets1.Campo('indIntermed_B25c').Value  := xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//ide/indIntermed');  // Indicador de intermediador/marketplace E B01 N 0-1 1 0=Operação sem intermediador (em site ou plataforma própria) 1=Operação em site ou plataforma de terceiros (intermediadores/marketplace)
                Form1.spdNFCeDataSets1.Campo('CNPJ_YB02').Value         := LimpaNumero(xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//infIntermed/CNPJ'));  // CNPJ do Intermediador da Transação (agenciador, plataforma de delivery, marketplace e similar) de serviços e de negócios.
                Form1.spdNFCeDataSets1.Campo('idCadIntTran_YB03').Value := ConverteAcentos2(xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//infIntermed/idCadIntTran')); // Identificador cadastrado no intermediador
                //
              end;
              //
            except
              on E: Exception do
              begin
                Form1.spdNFCeDataSets1.Campo('indIntermed_B25c').Value  := '0';  // Indicador de intermediador/marketplace E B01 N 0-1 1 0=Operação sem intermediador (em site ou plataforma própria) 1=Operação em site ou plataforma de terceiros (intermediadores/marketplace)
                Form1.spdNFCeDataSets1.Campo('CNPJ_YB02').Value         := '';  // CNPJ do Intermediador da Transação (agenciador, plataforma de delivery, marketplace e similar) de serviços e de negócios.
                Form1.spdNFCeDataSets1.Campo('idCadIntTran_YB03').Value := ''; // Identificador cadastrado no intermediador
              end;
            end;
            {Sandro Silva 2022-04-06 fim}

          end;

        end;
        {Sandro Silva 2021-02-05 fim}

        //
        // Apenas configuração para servidor versão 3.10. O servidor 3.00 foi desativado
        Form1.spdNFCeDataSets1.Campo('indIEDest_E16a').Value  := '9';        // Não Contribuinte
        Form1.spdNFCeDataSets1.Campo('IE_E17').Value          := '';         // Form1.spdNFCeDataSets1.Campo('IE_E17').GeraTagVazia   := True;
        //
        fTotalTributos   := 0;
        fValorProdutos   := 0;
        fDesconto        := 0;
        rBaseICMS        := 0;
        rValorICMS       := 0;
        I                := 0;
        dvOutro_W15      := 0; //2015-12-10
        dvServ_W18       := 0; //2015-12-10
        dvBC_W19         := 0; //2015-12-10
        dvISS_W20        := 0; //2015-12-10
        dvFCP_W04h       := 0; // Sandro Silva 2018-02-19
        dvICMSDeson_W04a := 0.00; // Sandro Silva 2019-08-29
        dvICMSMonoRet_N45Total := 0.00; // Sandro Silva 2023-05-19
        dqBCMonoRet_N43aTotal  := 0.00; // Sandro Silva 2023-09-04
        sMensagemIcmMonofasicoSobreCombustiveis := '';
        //
        // TOTAL Sem o Desconto
        //
        IBQALTERACA.Close;
        IBQALTERACA.SQL.Clear;
        IBQALTERACA.SQL.Text :=
          'select sum(cast(TOTAL as numeric(18,2))) as TOT from ALTERACA where PEDIDO='+QuotedStr(FormataNumeroDoCupom(iPedido))+' and CAIXA='+quotedStr(sCaixaXml)+' and DESCRICAO<>''<CANCELADO>'' and TIPO <> ''KOLNAC'' and Coalesce(ITEM,''XX'') <> ''XX'' '; // Não somar item cancelado. Dead lock mantem item com KOLNAC até que seja destravado e processao o cancelamento // Sandro Silva 2021-12-01 'select sum(cast(TOTAL as numeric(18,2))) as TOT from ALTERACA where PEDIDO='+QuotedStr(strZero(iPedido,6,0))+' and CAIXA='+quotedStr(sCaixaXml)+' and DESCRICAO<>''<CANCELADO>'' and TIPO <> ''KOLNAC'' and Coalesce(ITEM,''XX'') <> ''XX'' '; // Não somar item cancelado. Dead lock mantem item com KOLNAC até que seja destravado e processao o cancelamento
        IBQALTERACA.Open;

        fTotalSemDesconto := IBQALTERACA.FieldByname('TOT').AsFloat;
        {Sandro Silva 2019-08-05 fim}

        _ecf65_RateioAcrescimo(fTotalSemDesconto, dAcrescimoTotal, iPedido, sCaixaXml); // 2016-01-08
        _ecf65_RateioDesconto(fTotalSemDesconto, Form1.fDescontoNoTotal, iPedido, sCaixaXml); // 2016-01-08

        sLogErroItens := ''; // Sandro Silva 2017-08-15
        //
        // Início gerando itens
        //
        while not Form1.ibDataSet27.Eof do
        begin
          //
          Form1.ibDataSet4.Close;
          Form1.ibDataSet4.SelectSQL.Clear;
          Form1.ibDataSet4.SelectSQL.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form1.ibDataSet27CODIGO.AsString)+' ');  //
          Form1.ibDataSet4.Open;
          //
          if (Form1.ibDataSet27.FieldByName('TIPO').AsString = 'BALCAO') or (Form1.ibDataSet27.FieldByName('TIPO').AsString = 'LOKED') then // Apenas os itens não cancelados Sandro Silva 2018-12-19
          begin
            // Sandro Silva 2018-12-07 if (Alltrim(Form1.ibDataSet4DESCRICAO.AsString) = Alltrim(Form1.ibDAtaSet27DESCRICAO.AsString)) and (Alltrim(Form1.ibDataSet4DESCRICAO.AsString) <> '') then
            if (Alltrim(Form1.ibDataSet4.FieldByName('CODIGO').AsString) = Alltrim(Form1.ibDAtaSet27.FieldByName('CODIGO').AsString)) and (Alltrim(Form1.ibDataSet4.FieldByName('CODIGO').AsString) <> '') then
            begin
              //
              Form1.spdNFCeDataSets1.IncluirItem;
              I := I + 1;
              //
              // Informações Referentes aos ITens da NFe
              //
              Form1.spdNFCeDataSets1.Campo('nItem_H02').Value := IntToStr(I); // Número do Item da NFe (1 até 990)
              //
              // Dados do Produto Vendido
              //
              //
              {Sandro Silva 2020-11-23 inicio
              if (RetornaValorDaTagNoCampo('cProd', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '') then // Ficha  4796
                Form1.spdNFCeDataSets1.Campo('cProd_I02').Value    := Copy(RetornaValorDaTagNoCampo('cProd', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 1, 60)
              else
                if Length(Alltrim(LimpaNumero(Form1.ibDataSet4.FieldByname('REFERENCIA').AsString))) < 6 then
                  Form1.spdNFCeDataSets1.Campo('cProd_I02').Value    := Form1.ibDataSet4.FieldByname('CODIGO').AsString //Código do PRoduto ou Serviço
                else
                   Form1.spdNFCeDataSets1.Campo('cProd_I02').Value   := LimpaNumero(Form1.ibDataSet4.FieldByname('REFERENCIA').AsString); // Código de BARRAS
                //
              }
              if (RetornaValorDaTagNoCampo('cProd', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '') then // Ficha  4796
                Form1.spdNFCeDataSets1.Campo('cProd_I02').Value    := Copy(RetornaValorDaTagNoCampo('cProd', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 1, 60)
              else
                if _ecf65_ValidaGtinNFCe(Form1.ibDataSet4.FieldByname('REFERENCIA').AsString) then
                  Form1.spdNFCeDataSets1.Campo('cProd_I02').Value    := Form1.ibDataSet4.FieldByname('CODIGO').AsString //Código do PRoduto ou Serviço
                else
                  //Form1.spdNFCeDataSets1.Campo('cProd_I02').Value   := LimpaNumero(Form1.ibDataSet4.FieldByname('REFERENCIA').AsString); // Código de BARRAS
                  if Length(Alltrim(LimpaNumero(Form1.ibDataSet4.FieldByname('REFERENCIA').AsString))) < 6 then
                    Form1.spdNFCeDataSets1.Campo('cProd_I02').Value    := Form1.ibDataSet4.FieldByname('CODIGO').AsString //Código do PRoduto ou Serviço
                  else
                    Form1.spdNFCeDataSets1.Campo('cProd_I02').Value   := LimpaNumero(Form1.ibDataSet4.FieldByname('REFERENCIA').AsString); // Código de BARRAS
              {Sandro Silva 2020-11-23 fim}
 
              Form1.spdNFCeDataSets1.Campo('cEAN_I03').Value := 'SEM GTIN'; // EAN do Produto
              if _ecf65_ValidaGtinNFCe(Form1.ibDataSet4.FieldByname('REFERENCIA').AsString) then // Ficha 4676 Sandro Silva 2019-06-11 if ValidaEAN13(LimpaNumero(Form1.ibDataSet4.FieldByname('REFERENCIA').AsString)) then
                Form1.spdNFCeDataSets1.Campo('cEAN_I03').Value := LimpaNumero(Form1.ibDataSet4.FieldByname('REFERENCIA').AsString); // EAN do Produto
              {Sandro Silva 2020-04-04 fim}

              //
              //2015-09-21 NT 2015/002 É obrigatório o primeiro item ter a descrição:
              // "NOTA FISCAL EMITIDA EM AMBIENTE DE HOMOLOGAÇÃO - SEM VALOR FISCAL"
              // Rejeição 373 - Descrição do primeiro item diferente da NOTA FISCAL EMITIDA EM AMBIENTE DE HOMOLOGAÇÃO - SEM VALOR FISCAL.
              if (Form1.spdNFCe1.Ambiente = akHomologacao) and (I = 1) then
              begin
                Form1.spdNFCeDataSets1.Campo('xProd_I04').Value  := ConverteAcentos2('NOTA FISCAL EMITIDA EM AMBIENTE DE HOMOLOGAÇÃO - SEM VALOR FISCAL');
              end
              else
              begin
                Form1.spdNFCeDataSets1.Campo('xProd_I04').Value  := Alltrim(ConverteAcentos2(Form1.ibDataSet4.FieldByname('DESCRICAO').AsString));// Descrição do PRoduto
              end;

              // Ficha 4496
              if (AnsiContainsText(Form1.sConcomitante, 'MESA') = False) then // Ficha 4496 Não passar para xml dados da Observação o item quando estiver usando mesas. Desnecessário e usa mais papel para impressão
              begin
                if Trim(Form1.ibDataSet27.FieldByName('OBS').AsString) <> '' then
                  Form1.spdNFCeDataSets1.Campo('infAdProd_V01').AsString := Alltrim(ConverteAcentos2(Form1.ibDataSet27.FieldByName('OBS').AsString));
              end;

              Form1.spdNFCeDataSets1.Campo('NCM_I05').Value   := Alltrim(LimpaNumero(Form1.ibDataSet4.FieldByname('CF').AsString)); // Código do NCM - informar de acordo com o Tabela oficial do NCM

              if (Form1.ibDataSet4.FieldByName('TIPO_ITEM').AsString = '09') then // Serviço
                Form1.spdNFCeDataSets1.Campo('NCM_I05').Value := '00';

              if Alltrim(LimpaNumero(Form1.ibDataSet4.FieldByname('CEST').AsString)) <> '' then
                Form1.spdNFCeDataSets1.Campo('CEST_I05c').Value := Alltrim(LimpaNumero(Form1.ibDataSet4.FieldByname('CEST').AsString)); // Código Especificador da Substituição Tributária – CEST, que estabelece a sistemática de uniformização e identificação das mercadorias e bens passíveis de sujeição aos regimes de substituição tributária e de antecipação de recolhimento do ICMS

              {Sandro Silva 2023-11-09 inicio
              if LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString) <> '1' then // Ficha 4154
              begin
                if (RetornaValorDaTagNoCampo('cBenef', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '') then
                  Form1.spdNFCeDataSets1.Campo('cBenef_I05f').Value := Trim(RetornaValorDaTagNoCampo('cBenef', Form1.ibDataSet4.FieldByname('TAGS_').AsString));
              end;
              }
              if (RetornaValorDaTagNoCampo('cBenef', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '') then
                Form1.spdNFCeDataSets1.Campo('cBenef_I05f').Value := Trim(RetornaValorDaTagNoCampo('cBenef', Form1.ibDataSet4.FieldByname('TAGS_').AsString));
              {Sandro Silva 2023-11-09 fim}
              //
              if Alltrim(LimpaNumero(Form1.ibDataSet4.FieldByname('CFOP').AsString)) = '' then
              begin
                if (Form1.ibDataSet4.FieldByName('TIPO_ITEM').AsString = '09') then // Serviço
                  Form1.spdNFCeDataSets1.Campo('CFOP_I08').Value  := '5933' // CFOP para serviço
                else
                  Form1.spdNFCeDataSets1.Campo('CFOP_I08').Value  := '5102'; // CFOP
              end else
              begin
                Form1.spdNFCeDataSets1.Campo('CFOP_I08').Value  := Alltrim(LimpaNumero(Form1.ibDataSet4.FieldByname('CFOP').AsString)); // CFOP
              end;

              if (Form1.spdNFCeDataSets1.Campo('CFOP_I08').Value = '5656') // Venda de combustível ou lubrificante adquirido ou recebido de terceiros destinado a consumidor ou usuário final
                or (Form1.spdNFCeDataSets1.Campo('CFOP_I08').Value = '5667') // Venda de combustível ou lubrificante a consumidor ou usuário final estabelecido em outra UF
                or (RetornaValorDaTagNoCampo('cProdANP', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '') // Sandro Silva 2018-10-09 or (RetornaValorDaTagNoCampo('cProdANP', Form1.ibDataSet4.FieldByname('OBS').AsString) <> '')  // Sandro Silva 2018-04-06  or (Alltrim(Form1.ibDataSet4.FieldByname('LIVRE1').AsString) <> '') // Sandro Silva 2018-02-19
              then
              begin
                // versão 4.0
                Form1.spdNFCeDataSets1.Campo('cProdANP_LA02').Value := RetornaValorDaTagNoCampo('cProdANP', Form1.ibDataSet4.FieldByname('TAGS_').AsString); // Sandro Silva 2018-10-09 Form1.spdNFCeDataSets1.Campo('cProdANP_LA02').Value := RetornaValorDaTagNoCampo('cProdANP', Form1.ibDataSet4.FieldByname('OBS').AsString);  // cProdANP Código de produto da ANP Sandro Silva 2018-04-06
                if Form1.spdNFCeDataSets1.Campo('cProdANP_LA02').Value = '' then
                  sLogErroItens := sLogErroItens + 'Erro: LA01 ' + Chr(10) + 'Rejeição: cProdANP não informado no grupo LA Combustível. Verifique no cadastro do produto, campo Aplicação, a tag <cProdANP></cProdANP> '
                    + Form1.spdNFCeDataSets1.Campo('cProd_I02').Value + ' ' + Form1.spdNFCeDataSets1.Campo('xProd_I04').Value + Chr(10) + 'Ex.: Para o gás de cozinha o preenchimento seria <cProdANP>210203001</cProdANP>' + Chr(10); // Sandro Silva 2017-08-16  +chr(10)+'Leia atentamente a mensagem acima e tente resolver o problema.'+chr(10)+'Considere pedir ajuda ao seu contador para o preenchimento correto da NFC-e.';
                if RetornaValorDaTagNoCampo('descANP', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '' then // Sandro Silva 2018-10-09 if RetornaValorDaTagNoCampo('descANP', Form1.ibDataSet4.FieldByname('OBS').AsString) <> '' then
                  Form1.spdNFCeDataSets1.Campo('descANP_LA03').Value  := RetornaValorDaTagNoCampo('descANP', Form1.ibDataSet4.FieldByname('TAGS_').AsString) // Sandro Silva 2018-10-09 RetornaValorDaTagNoCampo('descANP', Form1.ibDataSet4.FieldByname('OBS').AsString)  // Utilizar a descrição de produtos do Sistema de Informações de Movimentação de Produtos - SIMP
                else
                  sLogErroItens := sLogErroItens + 'Erro: LA01 ' + Chr(10) + 'Rejeição: descANP não informado no grupo LA Combustível. Verifique no cadastro do produto, campo Aplicação, a tag <descANP></descANP> '
                    + Form1.spdNFCeDataSets1.Campo('cProd_I02').Value + ' ' + Form1.spdNFCeDataSets1.Campo('xProd_I04').Value + Chr(10) + 'Ex.: Para o gás de cozinha o preenchimento seria <descANP>GLP</descANP>' + Chr(10); // Sandro Silva 2017-08-16  +chr(10)+'Leia atentamente a mensagem acima e tente resolver o problema.'+chr(10)+'Considere pedir ajuda ao seu contador para o preenchimento correto da NFC-e.';

                if (Form1.spdNFCeDataSets1.Campo('cProdANP_LA02').Value = '210203001') then
                begin
                  Form1.spdNFCeDataSets1.Campo('pGLP_LA03a').Value := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('pGLP', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0), 4); // Sandro Silva 2018-10-09  Form1.spdNFCeDataSets1.Campo('pGLP_LA03a').Value := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('pGLP', Form1.ibDataSet4.FieldByname('OBS').AsString), 0), 4);  // Percentual do GLP derivado do petróleo no produto GLP (cProdANP=210203001) E LA01 N 0-1 3v4 Informar em número decimal o percentual do GLP derivado de petróleo no produto GLP. Valores de 0 a 100.
                  Form1.spdNFCeDataSets1.Campo('pGNn_LA03b').Value := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('pGNn', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0), 4); // Sandro Silva 2018-10-09  Form1.spdNFCeDataSets1.Campo('pGNn_LA03b').Value := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('pGNn', Form1.ibDataSet4.FieldByname('OBS').AsString), 0), 4);  // Percentual de Gás Natural Nacional – GLGNn para o produto GLP (cProdANP=210203001) E LA01 N 0-1 3v4 Informar em número decimal o percentual do Gás Natural Nacional – GLGNn para o produto GLP. Valores de 0 a 100.
                  Form1.spdNFCeDataSets1.Campo('pGNi_LA03c').Value := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('pGNi', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0), 4); // Sandro Silva 2018-10-09  Form1.spdNFCeDataSets1.Campo('pGNi_LA03c').Value := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('pGNi', Form1.ibDataSet4.FieldByname('OBS').AsString), 0), 4);  // Percentual de Gás Natural Importado – GLGNi para o produto GLP (cProdANP=210203001) E LA01 N 0-1 3v4 Informar em número decimal o percentual do Gás Natural Importado – GLGNi para o produto GLP. Valores de 0 a 100.

                  try
                    if (Form1.spdNFCeDataSets1.Campo('pGLP_LA03a').Value + Form1.spdNFCeDataSets1.Campo('pGNn_LA03b').Value + Form1.spdNFCeDataSets1.Campo('pGNi_LA03c').Value) <> '' then // Se campos estão preenchidos
                    begin
                      if (StrToFloatDef(RetornaValorDaTagNoCampo('pGLP', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0)              // Sandro Silva 2018-10-09   if (StrToFloatDef(RetornaValorDaTagNoCampo('pGLP', Form1.ibDataSet4.FieldByname('OBS').AsString), 0)
                        + StrToFloatDef(RetornaValorDaTagNoCampo('pGNn', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0)              // Sandro Silva 2018-10-09    + StrToFloatDef(RetornaValorDaTagNoCampo('pGNn', Form1.ibDataSet4.FieldByname('OBS').AsString), 0)
                        + StrToFloatDef(RetornaValorDaTagNoCampo('pGNi', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0)) <> 100 then // Sandro Silva 2018-10-09    + StrToFloatDef(RetornaValorDaTagNoCampo('pGNi', Form1.ibDataSet4.FieldByname('OBS').AsString), 0)) <> 100 then
                      begin
                        sLogErroItens := sLogErroItens
                          // Sandro Silva 2018-10-09  + 'Erro: LA01 grupo LA Combustível (pGLP + pGNn + pGNi) = ' + FormatFloat('0.00##', StrToFloatDef(RetornaValorDaTagNoCampo('pGLP', Form1.ibDataSet4.FieldByname('OBS').AsString), 0) + StrToFloatDef(RetornaValorDaTagNoCampo('pGNn', Form1.ibDataSet4.FieldByname('OBS').AsString), 0) + StrToFloatDef(RetornaValorDaTagNoCampo('pGNi', Form1.ibDataSet4.FieldByname('OBS').AsString), 0))
                          + 'Erro: LA01 grupo LA Combustível (pGLP + pGNn + pGNi) = ' + FormatFloat('0.00##', StrToFloatDef(RetornaValorDaTagNoCampo('pGLP', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0) + StrToFloatDef(RetornaValorDaTagNoCampo('pGNn', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0) + StrToFloatDef(RetornaValorDaTagNoCampo('pGNi', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0))
                          + Chr(10) + 'Rejeição: Somatório percentuais de GLP derivado do petróleo, pGLP(id:LA03a) e pGNn(id:LA03b) e pGNi(id:LA03c) diferente de 100. '
                          + Chr(10) + 'Verifique no cadastro do produto, campo Aplicação, o percentual nas tags <pGLP>??,??</pGLP>, <pGNn>??,??</pGNn>, <pGNi>??,??</pGNi> '
                          + Chr(10) + Form1.spdNFCeDataSets1.Campo('cProd_I02').Value + ' ' + Form1.spdNFCeDataSets1.Campo('xProd_I04').Value
                          + Chr(10) + 'Ex.: <pGLP>10,00</pGLP> <pGNn>30,00</pGNn> <pGNi>60,00</pGNi> a soma das tags (10,00 + 30,00 + 60,00) é igual a 100,00)' + Chr(10);
                      end;
                    end;
                  except

                  end;
                  if RetornaValorDaTagNoCampo('vPart', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '' then
                    Form1.spdNFCeDataSets1.Campo('vPart_LA03d').Value := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('vPart', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0));
                end;

                Form1.spdNFCeDataSets1.Campo('UFCons_LA06').Value   := Trim(Form1.ibDAtaSet99.FieldByname('UF').AsString); // UFCons Sigla da UF de consumo
              end;

              if Form1.ibDataSet27.FieldByname('CFOP').Value <> Form1.spdNFCeDataSets1.Campo('CFOP_I08').Value then
              begin
                Form1.ibDataSet27.Edit;
                Form1.ibDataSet27.FieldByname('CFOP').Value := Form1.spdNFCeDataSets1.Campo('CFOP_I08').Value;
              end;
              //
              if Alltrim(ConverteAcentos2(Form1.ibDataSet4.FieldByname('MEDIDA').AsString)) <> '' then
                Form1.spdNFCeDataSets1.Campo('uCom_I09').Value   := ConverteAcentos2(Form1.ibDataSet4.FieldByname('MEDIDA').AsString) // Unidade de Medida do Item
              else
                Form1.spdNFCeDataSets1.Campo('uCom_I09').Value   := 'UND';
              //
              if Frac(Form1.ibDataSet27.FieldByname('QUANTIDADE').AsFloat) = 0 then
                Form1.spdNFCeDataSets1.Campo('qCom_I10').Value   := FormatFloatXML(Form1.ibDataSet27.FieldByname('QUANTIDADE').AsFloat, 0) // Quantidade Comercializada do Item
              else
                if Trim(Form1.ConfCasas) <> '' then
                  Form1.spdNFCeDataSets1.Campo('qCom_I10').Value   := FormatFloatXML(Form1.ibDataSet27.FieldByname('QUANTIDADE').AsFloat, StrToIntDef(Trim(Form1.ConfCasas), 3)) // Quantidade Comercializada do Item
                else
                  Form1.spdNFCeDataSets1.Campo('qCom_I10').Value   := FormatFloatXML(Form1.ibDataSet27.FieldByname('QUANTIDADE').AsFloat, 3); // Quantidade Comercializada do Item

              if Trim(Form1.ConfPreco) <> '' then
                Form1.spdNFCeDataSets1.Campo('vUnCom_I10a').Value  := FormatFloatXML(Form1.ibDataSet27.FieldByname('UNITARIO').AsFloat, StrToIntDef(Trim(Form1.ConfPreco), 3)) // Valor Comercializado do Item
              else
                Form1.spdNFCeDataSets1.Campo('vUnCom_I10a').Value  := FormatFloatXML(Form1.ibDataSet27.FieldByname('UNITARIO').AsFloat, 3); // Valor Comercializado do Item

              dvProd_I11 := StrToFloatDef(FormatFloat('##0.00', Form1.ibDataSet27.FieldByname('TOTAL').AsFloat), 0); // Formata o total com 2 casas para usar no restante da rotina

              Form1.spdNFCeDataSets1.Campo('vProd_I11').Value    := FormatFloatXML(dvProd_I11); // Valor Total Bruto do Item
              //
              // Desconto no item
              //
              IBQALTERACA.Close;
              IBQALTERACA.Sql.Clear;
              IBQALTERACA.SQL.Text := 'select sum(cast(TOTAL as numeric(18,2))) from ALTERACA where PEDIDO='+QuotedStr(FormataNumeroDoCupom(iPedido))+' and CAIXA='+quotedStr(sCaixaXml)+' and ITEM='+QuotedStr(Form1.ibDataSet27ITEM.AsString)+ 'and DESCRICAO=''Desconto'''; // Sandro Silva 2021-12-01 IBQALTERACA.SQL.Text := 'select sum(cast(TOTAL as numeric(18,2))) from ALTERACA where PEDIDO='+QuotedStr(strZero(iPedido,6,0))+' and CAIXA='+quotedStr(sCaixaXml)+' and ITEM='+QuotedStr(Form1.ibDataSet27ITEM.AsString)+ 'and DESCRICAO=''Desconto''';
              IBQALTERACA.Open;
              //
              fDescontoDoItem := 0.00;
              if (IBQALTERACA.FieldByname('SUM').AsFloat * -1) > 0.00 then
                fDescontoDoItem := (IBQALTERACA.FieldByname('SUM').AsFloat * -1);
              //
              //Unit2 aplica *-1 que converte valor positivo do acréscimo em negativo
              if Form1.fDescontoNoTotal > 0 then
              begin
                fDescontoTotalRateado := StrToFloat(StrZero((Form1.fDescontoNoTotal / (fTotalSemDesconto) * (dvProd_I11-fDescontoDoItem)), 0, 2)); // REGRA DE TRÊS rateando o valor do Desconto
              end
              else
              begin
                fDescontoTotalRateado := 0; // 2015-12-07
              end;
              //
              fDescontoTotalRateado := fDescontoTotalRateado + fDescontoDoItem;

              if dDescontoTotalCupom < (fDesconto + fDescontoTotalRateado) then // 2015-12-10  Corrige a diferença entre soma do rateio do desconto e o valor total do desconto do cupom
                fDescontoTotalRateado := fDescontoTotalRateado + (dDescontoTotalCupom - (fDesconto + fDescontoTotalRateado));

              dvDesc_I17 := 0;
              if (Length(aDescontoItem) > 0) then
              begin
                if (FormatFloatXML(aDescontoItem[I - 1]) <> '0.00') then
                begin
                  dvDesc_I17 := aDescontoItem[I - 1];
                end
              end;
              dvDesc_I17 := dvDesc_I17 + fDescontoDoItem;
              if (dvDesc_I17 > 0) then
              begin
                Form1.spdNFCeDataSets1.Campo('vDesc_I17').Value := FormatFloatXML(dvDesc_I17); // Desconto no ítem
              end;
              fDesconto := fDesconto + dvDesc_I17; // Valor Total de Desconto

              dRateioAcrescimoItem := 0.00;
              if Length(aAcrescimoItem) > 0 then
              begin
                if aAcrescimoItem[I - 1] > 0 then
                begin
                  dRateioAcrescimoItem := aAcrescimoItem[I - 1];
                  // Sandro Silva 2017-04-25  Form1.spdNFCeDataSets1.Campo('vOutro_I17a').Value := FormatFloatXML(aAcrescimoItem[I - 1]); // Acréscimo rateado no item
                  Form1.spdNFCeDataSets1.Campo('vOutro_I17a').Value := FormatFloatXML(dRateioAcrescimoItem); // Acréscimo rateado no item
                end;
              end;
              dvOutro_W15 := dvOutro_W15 + dRateioAcrescimoItem; // Sandro Silva 2017-04-26

              {Sandro Silva 2020-04-01 inicio
              // Ficha 4796

              //
              if _ecf65_ValidaGtinNFCe(Form1.ibDataSet4.FieldByname('REFERENCIA').AsString) then // Ficha 4676 Sandro Silva 2019-06-11 if ValidaEAN13(LimpaNumero(Form1.ibDataSet4.FieldByname('REFERENCIA').AsString)) then
              begin
                Form1.spdNFCeDataSets1.Campo('cEANTrib_I12').Value := LimpaNumero(Form1.ibDataSet4.FieldByname('REFERENCIA').AsString); // EAN do Produto
              end
              else
              begin
                if Form1.sVersaoLayoutNFCe = '4.00' then
                begin
                  Form1.spdNFCeDataSets1.Campo('cEANTrib_I12').Value := 'SEM GTIN'; // EAN do Produto
                end;
              end;
              }
              // tem cEanTrib válido configurado
              Form1.spdNFCeDataSets1.Campo('cEANTrib_I12').Value := 'SEM GTIN'; // EAN do Produto
              if (RetornaValorDaTagNoCampo('cEANTrib', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '') and (_ecf65_ValidaGtinNFCe(RetornaValorDaTagNoCampo('cEANTrib', Form1.ibDataSet4.FieldByname('TAGS_').AsString))) then // Ficha  4796
                Form1.spdNFCeDataSets1.Campo('cEANTrib_I12').Value := RetornaValorDaTagNoCampo('cEANTrib', Form1.ibDataSet4.FieldByname('TAGS_').AsString)
              else
                if _ecf65_ValidaGtinNFCe(Form1.ibDataSet4.FieldByname('REFERENCIA').AsString) then // Ficha 4676 Sandro Silva 2019-06-11 if ValidaEAN13(LimpaNumero(Form1.ibDataSet4.FieldByname('REFERENCIA').AsString)) then
                  Form1.spdNFCeDataSets1.Campo('cEANTrib_I12').Value := LimpaNumero(Form1.ibDataSet4.FieldByname('REFERENCIA').AsString); // EAN do Produto
              {Sandro Silva 2020-04-01 fim}

              //
              if Alltrim(ConverteAcentos2(Form1.ibDataSet4.FieldByname('MEDIDA').AsString)) <> '' then
                Form1.spdNFCeDataSets1.Campo('uTrib_I13').Value    := ConverteAcentos2(Form1.ibDataSet4.FieldByname('MEDIDA').AsString) else Form1.spdNFCeDataSets1.Campo('uTrib_I13').Value    := 'UND'; // Unidade de Medida Tributável do Item
              //
              if Frac(Form1.ibDataSet27.FieldByname('QUANTIDADE').AsFloat) = 0 then
                Form1.spdNFCeDataSets1.Campo('qTrib_I14').Value   := FormatFloatXML(Form1.ibDataSet27.FieldByname('QUANTIDADE').AsFloat, 0) // Quantidade Comercializada do Item
              else
                if Trim(Form1.ConfCasas) <> '' then
                  Form1.spdNFCeDataSets1.Campo('qTrib_I14').Value   := FormatFloatXML(Form1.ibDataSet27.FieldByname('QUANTIDADE').AsFloat, StrToIntDef(Trim(Form1.ConfCasas), 3)) // Quantidade Comercializada do Item
                else
                  Form1.spdNFCeDataSets1.Campo('qTrib_I14').Value   := FormatFloatXML(Form1.ibDataSet27.FieldByname('QUANTIDADE').AsFloat, 3); // Quantidade Comercializada do Item

              if Trim(Form1.ConfPreco) <> '' then
                Form1.spdNFCeDataSets1.Campo('vUnTrib_I14a').Value := FormatFloatXML(Form1.ibDataSet27.FieldByname('UNITARIO').AsFloat, StrToInt64Def(Trim(Form1.ConfPreco), 3)) // Valor Tributável do Item
              else
                Form1.spdNFCeDataSets1.Campo('vUnTrib_I14a').Value := FormatFloatXML(Form1.ibDataSet27.FieldByname('UNITARIO').AsFloat, 3); // Valor Tributável do Item

              if RetornaValorDaTagNoCampo('uTrib',Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '' then
              begin // Tem configuração para unidade tributada
                //
                Form1.spdNFCeDataSets1.Campo('uTrib_I13').Value    := RetornaValorDaTagNoCampo('uTrib',Form1.ibDataSet4.FieldByname('TAGS_').AsString);
                //
                if LimpaNumero(RetornaValorDaTagNoCampo('qTrib',Form1.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
                begin
                  if Trim(Form1.ConfCasas) <> '' then
                    Form1.spdNFCeDataSets1.Campo('qTrib_I14').Value    := FormatFloatXML(Form1.ibDataSet27.FieldByname('QUANTIDADE').AsFloat * StrToFloat( RetornaValorDaTagNoCampo('qTrib',Form1.ibDataSet4.FieldByname('TAGS_').AsString)  ), StrToIntDef(Trim(Form1.ConfCasas), 3))  // Quantidade Tributável do Item
                  else
                    Form1.spdNFCeDataSets1.Campo('qTrib_I14').Value    := FormatFloatXML(Form1.ibDataSet27.FieldByname('QUANTIDADE').AsFloat * StrToFloat( RetornaValorDaTagNoCampo('qTrib',Form1.ibDataSet4.FieldByname('TAGS_').AsString)  ));  // Quantidade Tributável do Item

                  Form1.spdNFCeDataSets1.Campo('vUnTrib_I14a').Value := FormatFloatXML(Form1.ibDataSet27.FieldByname('TOTAL').AsFloat / StrToFloat(StrTran(Form1.spdNFCeDataSets1.Campo('qTrib_I14').AsString,'.',',')), 10); // Valor Tributável do Item. Igual gera tag para NF-e
                end;
              end;
              //
              // TAGS
              //
              try
                //
                dvTotTrib_M02 := StrToFloat(
                                   FormatFloat('##0.00',
                                     ((dvProd_I11 - fDescontoTotalRateado + dRateioAcrescimoItem) * Form1.ibDataSet4.FieldByname('IIA').AsFloat / 100) +
                                     ((dvProd_I11 - fDescontoTotalRateado + dRateioAcrescimoItem) * Form1.ibDataSet4.FieldByname('IIA_UF').AsFloat / 100) +
                                     ((dvProd_I11 - fDescontoTotalRateado + dRateioAcrescimoItem) * Form1.ibDataSet4.FieldByname('IIA_MUNI').AsFloat / 100)
                                   )
                );

                Form1.spdNFCeDataSets1.Campo('vTotTrib_M02').Value  := FormatFloatXML(dvTotTrib_M02); //
                fTotalTributos := fTotalTributos + dvTotTrib_M02;
                //
              except
                on E: Exception do
                begin
                  sLogErro := 'Erro: 44' + Chr(10) + E.Message+chr(10)+chr(10)+'Ao calcular tributos';
                  LogErroCredenciadoraCartao(Form1.sNomeRede, sCNPJ_YA05, sLogErro);
                  Exit;
                end;
              end;

              if (Form1.ibDataSet4.FieldByName('TIPO_ITEM').AsString = '09') then // Serviço
              begin
                if Form1.spdNFCeDataSets1.Campo('NCM_I05').Value = '' then
                  Form1.spdNFCeDataSets1.Campo('NCM_I05').Value := '00'; // Nota: Em caso de item de serviço ou item que não tenham produto (ex. transferência de crédito, crédito do ativo imobilizado, etc.), informar o valor 00 (dois zeros).

                dvBC_U02     := dvProd_I11 - fDescontoTotalRateado + dRateioAcrescimoItem;
                dvServ_W18   := dvServ_W18 + dvProd_I11; //vBC_U02;
                dvBC_W19     := dvBC_W19 + dvBC_U02;
                dvAliq_U03   := StrToFloatDef(Form1.AliquotaISSConfigura, 0) / 100;
                if Form1.ibDataSet4.FieldByname('ALIQUOTA_NFCE').AsString <> '' then
                  dvAliq_U03 := Form1.ibDataSet4.FieldByname('ALIQUOTA_NFCE').AsFloat;

                dvISSQN_U04  := StrToFloat(StrZero(((dvBC_U02 * dvAliq_U03) / 100), 0, 2));
                dvISS_W20    := dvISS_W20 + dvISSQN_U04;
                //dvPIS_W21    := dvPIS_W21 + StrToFloat(StrZero((dvBC_U02 * Form1.ibDataSet27.FieldByname('ALIQ_PIS').AsFloat / 100), 0, 2));
                //dvCOFINS_W22 := dvCOFINS_W22 + StrToFloat(StrZero((dvBC_U02 * Form1.ibDataSet27.FieldByname('ALIQ_COFINS').AsFloat / 100), 0, 2));

                Form1.spdNFCeDataSets1.Campo('vBC_U02').Value       := FormatFloatXML(dvBC_U02); // vBC ISSQN
                Form1.spdNFCeDataSets1.Campo('vAliq_U03').Value     := FormatFloatXML(dvAliq_U03); // vAliq ISSQN
                Form1.spdNFCeDataSets1.Campo('vISSQN_U04').Value    := FormatFloatXML(dvISSQN_U04); // vISSQN
                Form1.spdNFCeDataSets1.Campo('cMunFG_U05').Value    := Form1.spdNFCeDataSets1.Campo('cMunFG_B12').Value;

                Form1.spdNFCeDataSets1.Campo('cListServ_U06').Value := Trim(Form1.ExtrairConfiguracao(Form1.ibDataSet4.FieldByName('LIVRE4').AsString, SIGLA_CLISTSERV, False));
                if Form1.spdNFCeDataSets1.Campo('cListServ_U06').Value = '' then // Não encontrou passa valor fixo
                  Form1.spdNFCeDataSets1.Campo('cListServ_U06').Value := '01.04';
                {Sandro Silva 2020-08-21 inicio}
                if RetornaValorDaTagNoCampo('cListServ', Form1.ibDataSet4.FieldByName('TAGS_').AsString) <> '' then
                  Form1.spdNFCeDataSets1.Campo('cListServ_U06').Value := RetornaValorDaTagNoCampo('cListServ', Form1.ibDataSet4.FieldByName('TAGS_').AsString); // Usa valor se existir na aba tag
                {Sandro Silva 2020-08-21 fim}

                //Form1.spdNFCeDataSets1.Campo('vDeducao_U07').Value     := '0.00'; // Valor dedução para redução da Base de Cálculo
                //Form1.spdNFCeDataSets1.Campo('vOutro_U08').Value       := '0.00'; // Valor outras retenções
                //Form1.spdNFCeDataSets1.Campo('vDescIncond_U09').Value  := '0.00'; // Valor desconto incondicionado
                //Form1.spdNFCeDataSets1.Campo('vDescCond_U10').Value    := '0.00'; // Valor desconto condicionado
                //Form1.spdNFCeDataSets1.Campo('vISSRet_U11').Value      := '0.00'; // Valor retenção ISS
                Form1.spdNFCeDataSets1.Campo('indISS_U12').Value       := '1'; // Indicador da exigibilidade do ISS 1=Exigível, 2=Não incidência; 3=Isenção; 4=Exportação; 5=Imunidade; 6=Exigibilidade Suspensa por Decisão Judicial; 7=Exigibilidade Suspensa por Processo Administrativo;
                if RetornaValorDaTagNoCampo('cServico', Form1.ibDataSet4.FieldByName('TAGS_').AsString) <> '' then // Sandro Silva 2018-10-09 if RetornaValorDaTagNoCampo('cServico', Form1.ibDataSet4.FieldByName('OBS').AsString) <> '' then
                  Form1.spdNFCeDataSets1.Campo('cServico_U13').Value     := RetornaValorDaTagNoCampo('cServico', Form1.ibDataSet4.FieldByName('TAGS_').AsString) // Código do serviço prestado dentro do município // Sandro Silva 2018-10-09 Form1.spdNFCeDataSets1.Campo('cServico_U13').Value     := RetornaValorDaTagNoCampo('cServico', Form1.ibDataSet4.FieldByName('OBS').AsString) // Código do serviço prestado dentro do município
                else
                  Form1.spdNFCeDataSets1.Campo('cServico_U13').Value     := '00000000000000000001'; // Código do serviço prestado dentro do município
                Form1.spdNFCeDataSets1.Campo('cMun_U14').Value         := Form1.spdNFCeDataSets1.Campo('cMunFG_B12').Value; // Código do Município de incidência do imposto
                Form1.spdNFCeDataSets1.Campo('cPais_U15').Value        := '1058'; // Código do País onde o serviço foi prestado
                Form1.spdNFCeDataSets1.Campo('indIncentivo_U17').Value := '2'; //  // Indicador de incentivo Fiscal 1=Sim; 2=Não;
              end
              else
              begin // Produtos/Mercadorias
                fValorProdutos := fValorProdutos + dvProd_I11;

                if (LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString) <> '1') then
                begin // NÃO É SIMPLES NACIONAL
                  Form1.spdNFCeDataSets1.Campo('orig_N11').Value    := Copy(Right('000' + LimpaNumero(Form1.ibDataSet4.FieldByname('CST').AsString), 3), 1, 1); //Origemd da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)
                  Form1.spdNFCeDataSets1.Campo('CST_N12').Value     := Right('000' + LimpaNumero(Form1.ibDataSet4.FieldByname('CST').AsString), 2); // Tipo da Tributação do ICMS (00 - Integralmente) ver outras formas no Manual

                  if Length(LimpaNumero(Form1.ibDataSet4.FieldByname('CST_NFCE').AsString)) > 1 then // Se existir CST para NFC-e usa a configuração
                  begin
                    Form1.spdNFCeDataSets1.Campo('orig_N11').Value  := Copy(Right('000' + LimpaNumero(Form1.ibDataSet4.FieldByname('CST_NFCE').AsString), 3), 1, 1); //Origemd da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)
                    Form1.spdNFCeDataSets1.Campo('CST_N12').Value   := Right('000' + LimpaNumero(Form1.ibDataSet4.FieldByname('CST_NFCE').AsString), 2); // Tipo da Tributação do ICMS (00 - Integralmente) ver outras formas no Manual
                  end;

                  if Form1.ibDataSet27.FieldByname('CST_ICMS').Value <> Trim(Form1.spdNFCeDataSets1.Campo('orig_N11').Value) + Trim(Form1.spdNFCeDataSets1.Campo('CST_N12').Value)  then
                  begin
                    Form1.ibDataSet27.Edit;
                    Form1.ibDataSet27.FieldByname('CST_ICMS').Value := Trim(Form1.spdNFCeDataSets1.Campo('orig_N11').Value) + Trim(Form1.spdNFCeDataSets1.Campo('CST_N12').Value);
                    {Sandro Silva 2021-01-13 inicio
                    if Trim(Form1.spdNFCeDataSets1.Campo('CST_N12').Value)  = '40' then
                      Form1.ibDataSet27.FieldByname('ALIQUICM').Value := 'I';
                    if Trim(Form1.spdNFCeDataSets1.Campo('CST_N12').Value)  = '41' then
                      Form1.ibDataSet27.FieldByname('ALIQUICM').Value := 'N';
                    if Trim(Form1.spdNFCeDataSets1.Campo('CST_N12').Value)  = '60' then
                      Form1.ibDataSet27.FieldByname('ALIQUICM').Value := 'F';
                    {Sandro Silva 2021-01-13 fim}
                  end;
                end else
                begin // SIMPLES NACIONAL
                  Form1.spdNFCeDataSets1.Campo('orig_N11').Value    := Copy(LimpaNumero(Form1.ibDataSet4.FieldByname('CST').AsString)+'000',1,1); //Origemd da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)


                  Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value  :=  Form1.ibDataSet4.FieldByname('CSOSN').AsString; // ESTOQUE.CSOSN
                  if Trim(Form1.ibDataSet4.FieldByname('CSOSN_NFCE').AsString) <> '' then // Se existir CSOSN para NFC-e usa a configuração
                  begin
                    Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value := LimpaNumero(Form1.ibDataSet4.FieldByname('CSOSN_NFCE').AsString); // ESTOQUE.CSOSN_NFCE // Tipo da Tributação do ICMS (00 - Integralmente) ver outras formas no Manual
                  end;

                  {Sandro Silva 2023-05-23 inicio}
                  // Não é posssível informar CSOSN 61. Para CSOSN 61 será criado no grupo imposto a tag CST
                  if Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value = '61' then
                  begin
                    // Ficha 6908
                    // Simples nacional usa CST 61 no lugar do CSOSN
                    Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Clear;
                    Form1.spdNFCeDataSets1.Campo('CST_N12').AsString := '61';
                    if Form1.ibDataSet27.FieldByname('CSOSN').AsString <> Trim(Form1.spdNFCeDataSets1.Campo('orig_N11').Value) + Trim(Form1.spdNFCeDataSets1.Campo('CST_N12').AsString) then
                    begin
                      Form1.ibDataSet27.Edit;
                      Form1.ibDataSet27.FieldByname('CSOSN').Value := Trim(Form1.spdNFCeDataSets1.Campo('orig_N11').Value) + Trim(Form1.spdNFCeDataSets1.Campo('CST_N12').Value);
                    end;
                  end;
                  {Sandro Silva 2023-05-23 fim}

                  if (Form1.spdNFCeDataSets1.Campo('CST_N12').Value <> '61') and (Form1.ibDataSet27.FieldByname('CSOSN').AsString <> '') then // Não é posssível informar CSOSN 61. Para CSOSN 61 será criado no grupo imposto a tag CST
                  begin

                    if Form1.ibDataSet27.FieldByname('CSOSN').AsString <> Trim(Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value) then // ALTERACA.CSOSN <> do XML
                    begin
                      Form1.ibDataSet27.Edit;
                      if Trim(Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value) = '' then
                        Form1.ibDataSet27.FieldByname('CSOSN').Clear
                      else
                        Form1.ibDataSet27.FieldByname('CSOSN').AsString := Trim(Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value); // Repassa para ALTERACA.CSOSN o valor atribuido ao XML

                      {Sandro Silva 2021-01-13 inicio
                      if (Trim(Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value) = '102') or (Trim(Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value) = '103') or (Trim(Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value) = '300') then
                        Form1.ibDataSet27.FieldByname('ALIQUICM').Value := 'I';
                      if Trim(Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value) = '400' then
                        Form1.ibDataSet27.FieldByname('ALIQUICM').Value := 'N';
                      if Trim(Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value) = '500' then
                        Form1.ibDataSet27.FieldByname('ALIQUICM').Value := 'F';
                      {Sandro Silva 2021-01-13 fim}

                    end;
                  end;

                  // Sandro Silva 2023-05-23 if Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value = '' then
                  if (Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value = '')
                    and (Form1.spdNFCeDataSets1.Campo('CST_N12').AsString = '') // // Simples nacional usa CST 61 no lugar do CSOSN
                  then
                  begin
                    sStatus := 'Configure no Estoque, o CSOSN para o produto: '+Form1.spdNFCeDataSets1.Campo('cProd_I02').Value+' '+Form1.spdNFCeDataSets1.Campo('xProd_I04').Value;// Sandro Silva 2018-04-11  sStatus := 'CSOSN não configurado para o produto: '+Form1.spdNFCeDataSets1.Campo('cProd_I02').Value+' '+Form1.spdNFCeDataSets1.Campo('xProd_I04').Value;
                    sLogErro := 'Erro:22' + Chr(10) + sStatus +chr(10);  // Sandro Silva 2017-08-16  +chr(10)+'Leia atentamente a mensagem acima e tente resolver o problema.'+chr(10)+'Considere pedir ajuda ao seu contador para o preenchimento correto da NFC-e.';
                    LogErroCredenciadoraCartao(Form1.sNomeRede, sCNPJ_YA05, sLogErro);
                    ConcatenaLog(sLogErroItens, sLogErro); // Sandro Silva 2018-07-20 sLogErroItens := sLogErroItens + Chr(10) + sLogErro;
                  end;

                end;
                //
                //
                //
                dpRedBC_N14 := 0.00;
                _ecf65_IdentificaPercentuaisBaseICMS(dpRedBC_N14);

                dvBC_N15 := (dvProd_I11 - fDescontoTotalRateado + dRateioAcrescimoItem); // BC // Sandro Silva 2019-08-29
                if (Pos('|' + Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring + '|', '|61|') > 0) or
                   (Pos('|' + Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').AsString + '|', '|61|') > 0) then
                  dvBC_N15 := 0.00;

                if (LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString) <> '1') then
                begin
                   //Cálculo da desoneração
                  _ecf65_CalculaDesoneracao(Form1.ibDataSet13.FieldByName('ESTADO').AsString,
                    Form1.ibDataSet4.FieldByName('ST').AsString,
                    LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString),
                    Form1.spdNFCeDataSets1.Campo('orig_N11').Value + Form1.spdNFCeDataSets1.Campo('CST_N12').AsString,
                    Form1.ibDataSet27.FieldByName('ALIQUICM').AsString,
                    dpRedBC_N14,
                    dvBC_N15,
                    Form1.ibDataSet14,
                    Form1.ibDataSet4,
                    dvICMSDeson_N28a,
                    dvICMS_N17
                    );
                end;

                if LimpaNumero(Form1.ibDataSet27.FieldByName('ALIQUICM').AsString) <> '' then
                begin
                  //
                  if (LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString) <> '1') then
                  begin
                    //
                    // Só quando não é simples nacional
                    //
                    if (Form1.spdNFCeDataSets1.Campo('CST_N12').AsString = '20') then
                    begin
                      if dpRedBC_N14 = 0.00 then
                      begin
                        Form1.spdNFCeDataSets1.Campo('pRedBC_N14').Value := FormatFloatXML(100.00); // Sandro Silva 2019-03-11
                      end
                      else if dpRedBC_N14 = 100.00 then
                      begin
                        Form1.spdNFCeDataSets1.Campo('pRedBC_N14').Value := FormatFloatXML(0.00);// Percentual da Redução de BC. Calcula o percentual de redução da base. Ex.: No Estoque pRedBC=66,67, então o percentual de redução que irá para o xml será de 33,33 (100-66,67)
                        dvBC_N15 := 0.00;
                      end
                      else
                      begin
                        Form1.spdNFCeDataSets1.Campo('pRedBC_N14').Value := FormatFloatXML(100 - dpRedBC_N14);// Percentual da Redução de BC. Calcula o percentual de redução da base. Ex.: No Estoque pRedBC=66,67, então o percentual de redução que irá para o xml será de 33,33 (100-66,67)
                        if dpRedBC_N14 > 0 then
                          dvBC_N15    := StrToFloatDef(FormatFloat('0.00', dvBC_N15 * (dpRedBC_N14 / 100)), 0); // Aplica a redução na B.C.
                      end;
                    end;
                    
                    Form1.spdNFCeDataSets1.Campo('vBC_N15').Value := FormatFloatXML(dvBC_N15); // BC // Sandro Silva 2018-02-08

                    //
                    dvICMS_N17 := 0.00;
                    // Diferente de 40=isenta;41=Não tributada;50=Suspensão
                    if Pos('|' + Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring + '|', '|40|41|50|61|') = 0 then // Sandro Silva 2023-05-23 if Pos('|' + Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring + '|', '|40|41|50|') = 0 then
                    begin
                      dvICMS_N17 := StrToFloat(FormatFloat('##0.00', (dvBC_N15 * (StrToIntDef(LimpaNumero(Form1.ibDataSet27.FieldByName('ALIQUICM').AsString), 0) / 10000))));// Sandro Silva 2018-02-19  dvICMS_N17 := StrToFloat(FormatFloat('##0.00', (dvProd_I11 - fDescontoTotalRateado + dRateioAcrescimoItem) * (StrToIntDef(LimpaNumero(Form1.ibDataSet27.FieldByName('ALIQUICM').AsString), 0) / 10000)));
                    end;

                    //
                    // Diferente de 40=Isenta; 41=Não tributada; 60=ST
                    if Pos('|' + Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring + '|', '|40|41|60|61|') = 0 then // Sandro Silva 2023-05-23 if Pos('|' + Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring + '|', '|40|41|60|') = 0 then
                      rBaseICMS  := rBaseICMS + dvBC_N15;// Sandro Silva 2018-02-19  rBaseICMS  := rBaseICMS + (dvProd_I11 - fDescontoTotalRateado + dRateioAcrescimoItem);

                    if dvICMS_N17 > 0.00 then
                    begin
                      Form1.spdNFCeDataSets1.Campo('vICMS_N17').Value := FormatFloatXML(dvICMS_N17); // Valor do ICMS em Reais
                    end
                    else if Pos('|' + Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring + '|', '|40|41|60|61|') = 0 then // Sandro Silva 2023-05-23 else if Pos('|' + Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring + '|', '|40|41|60|') = 0 then
                    begin
                      Form1.spdNFCeDataSets1.Campo('vICMS_N17').Value := FormatFloatXML(dvICMS_N17); // Valor do ICMS em Reais
                    end;

                    rValorICMS := rValorICMS + dvICMS_N17; //(Form1.ibDataSet27.FieldByname('TOTAL').AsFloat-fDescontoTotalRateado)*(StrToInt('0'+LimpaNumero(Form1.ibDataSet27.FieldByName('ALIQUICM').AsString))/10000);

                    //
                    // Só quando não é simples nacional
                    //
                    //
                    // FCP
                    //
                    // Durante testes com ambiente homologação AM sempre retornou rejeição quando preenchidos campo pFCP e vFCP seguindo as orientações da NT 2016_002_v1.40
                    //
                    if RetornaValorDaTagNoCampo('FCP', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '' then // Sandro Silva 2019-05-13  if RetornaValorDaTagNoCampo('pFCP', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '' then // Sandro Silva 2018-10-09 if RetornaValorDaTagNoCampo('pFCP', Form1.ibDataSet4.FieldByname('OBS').AsString) <> '' then
                    begin

                      if (Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring = '00') then
                      begin
                        dvFCP_N17c := StrToFloat(FormatFloat('##0.00', (dvBC_N15 * StrToFloatDef(RetornaValorDaTagNoCampo('FCP', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0)) / 100));
                        dvFCP_W04h := dvFCP_W04h + dvFCP_N17c;
                        Form1.spdNFCeDataSets1.Campo('pFCP_N17b').Value := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('FCP', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0)); // Percentual do Fundo de Combate à Pobreza (FCP) E N17.1 N 1-1 3v2-4 Percentual relativo ao Fundo de Combate à Pobreza (FCP).
                        Form1.spdNFCeDataSets1.Campo('vFCP_N17c').Value := FormatFloatXML(dvFCP_N17c); // Valor do Fundo de Combate à Pobreza (FCP) E N17.1 N 1-1 13v2 Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP).

                        _ecf65_InfAddProdFCP(Form1.spdNFCeDataSets1, dvFCP_N17c, dvBC_N15);

                      end;

                      // “Tributação do ICMS=20 - Tributada com redução de base de cálculo”, “Tributação do ICMS=51 - Tributação com Diferimento” e “Tributação do ICMS=90 - Outros”
                      if Pos('|' + Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring + '|', '|20|51|90|') > 0 then
                      begin
                        dvFCP_N17c := StrToFloat(FormatFloat('##0.00', (dvBC_N15 * StrToFloatDef(RetornaValorDaTagNoCampo('FCP', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0)) / 100));
                        dvFCP_W04h := dvFCP_W04h + dvFCP_N17c;
                        Form1.spdNFCeDataSets1.Campo('vBCFCP_N17a').Value := FormatFloatXML(dvBC_N15); // Informar o valor da Base de Cálculo do FCP
                        Form1.spdNFCeDataSets1.Campo('pFCP_N17b').Value   := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('FCP', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0)); // Percentual do Fundo de Combate à Pobreza (FCP) E N17.1 N 1-1 3v2-4 Percentual relativo ao Fundo de Combate à Pobreza (FCP).
                        Form1.spdNFCeDataSets1.Campo('vFCP_N17c').Value   := FormatFloatXML(dvFCP_N17c); // Valor do Fundo de Combate à Pobreza (FCP) E N17.1 N 1-1 13v2 Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP).
                        {Sandro Silva 2019-06-14 inicio}
                        _ecf65_InfAddProdFCP(Form1.spdNFCeDataSets1, dvFCP_N17c, dvBC_N15);
                        {Sandro Silva 2019-06-14 fim}
                      end;

                    end;

                  end
                  else
                  begin //// SIMPLES NACIONAL
                    /////////////////////////////////////////////////////////////////////////////////
                    Form1.spdNFCeDataSets1.Campo('vBC_N15').Value := FormatFloatXML(dvBC_N15); // BC // Sandro Silva 2018-02-19
                    dvICMS_N17 := 0.00;

                    if Pos('|' + Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').AsString + '|', '|900|') > 0 then // Se CSOSN for 900=Tributação ICMS pelo Simples Nacional
                    begin
                      dvICMS_N17 := StrToFloat(FormatFloat('##0.00', (dvBC_N15 * (StrToIntDef(LimpaNumero(Form1.ibDataSet27.FieldByName('ALIQUICM').AsString), 0) / 10000))));// Sandro Silva 2018-02-19  dvICMS_N17 := StrToFloat(FormatFloat('##0.00', (dvProd_I11 - fDescontoTotalRateado + dRateioAcrescimoItem) * (StrToIntDef(LimpaNumero(Form1.ibDataSet27.FieldByName('ALIQUICM').AsString), 0) / 10000)));
                    end;
                    //
                    if Pos('|' + Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').AsString + '|', '|900|') > 0 then // Se CSOSN for 900=Tributação ICMS pelo Simples Nacional
                      rBaseICMS  := rBaseICMS + dvBC_N15;// Sandro Silva 2018-02-19  rBaseICMS  := rBaseICMS + (dvProd_I11 - fDescontoTotalRateado + dRateioAcrescimoItem);

                    if dvICMS_N17 > 0.00 then
                      Form1.spdNFCeDataSets1.Campo('vICMS_N17').Value := FormatFloatXML(dvICMS_N17); // Valor do ICMS em Reais

                    rValorICMS := rValorICMS + dvICMS_N17; //(Form1.ibDataSet27.FieldByname('TOTAL').AsFloat-fDescontoTotalRateado)*(StrToInt('0'+LimpaNumero(Form1.ibDataSet27.FieldByName('ALIQUICM').AsString))/10000);

                    //
                    // FCP
                    //
                    // Simples não gera FCP
                    //
                    if RetornaValorDaTagNoCampo('FCP', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '' then // Sandro Silva 2019-05-13  if RetornaValorDaTagNoCampo('pFCP', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '' then // Sandro Silva 2018-10-09 if RetornaValorDaTagNoCampo('pFCP', Form1.ibDataSet4.FieldByname('OBS').AsString) <> '' then
                    begin

                      // Se fo CSOSN=900 Tributação ICMS pelo Simples Nacional;
                      if (Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').AssTring = '900') then
                      begin
                        {Sandro Silva 2019-05-13 inicio
                        Não gerou as tags de fcp quanto CSOSN=900
                        dvFCP_N17c := StrToFloat(FormatFloat('##0.00', (dvBC_N15 * StrToFloatDef(RetornaValorDaTagNoCampo('FCP', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0)) / 100));
                        dvFCP_W04h := dvFCP_W04h + dvFCP_N17c;
                        Form1.spdNFCeDataSets1.Campo('pFCP_N17b').Value := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('FCP', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0)); // Percentual do Fundo de Combate à Pobreza (FCP) E N17.1 N 1-1 3v2-4 Percentual relativo ao Fundo de Combate à Pobreza (FCP).
                        Form1.spdNFCeDataSets1.Campo('vFCP_N17c').Value := FormatFloatXML(dvFCP_N17c); // Valor do Fundo de Combate à Pobreza (FCP) E N17.1 N 1-1 13v2 Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP).
                        {Sandro Silva 2019-05-13 fim}
                      end;

                    end; // if RetornaValorDaTagNoCampo('pFCP', Form1.ibDataSet4.FieldByname('OBS').AsString) <> '' then

                    ////////////////////////////////////////////////////////////////////////
                  end; // if (LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString) <> '1') then
                  //
                end else
                begin
                  dvBC_N15 := 0.00;
                  //
                  // Sandro Silva 2023-05-23 Form1.spdNFCeDataSets1.Campo('vBC_N15').Value     := '0.00';  // BC
                  Form1.spdNFCeDataSets1.Campo('vBC_N15').Value     := FormatFloatXML(dvBC_N15);  // BC


                  //
                  if (LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString) <> '1') then
                  begin // NÃO É SIMPLES NACIONAL
                    if Pos('|' + Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring + '|', '|40|41|50|') = 0 then
                    begin
                      Form1.spdNFCeDataSets1.Campo('vICMS_N17').Value   := '0.00';  // Valor do ICMS em Reais
                    end;
                  end;
                  //
                end; // if LimpaNumero(Form1.ibDataSet27.FieldByName('ALIQUICM').AsString) <> '' then      

                {Sandro Silva 2023-05-17 inicio}
                //qBCMonoRet = será igual à quantidade do produto informado na nota
                //adRemICMSRet = buscar da tag adRemICMSRet do cadastro do produto
                //vICMSMonoRet = multiplicar o valor da tag qBCMonoRet pelo valor da tag adRemICMSRet

                // Não é posssível informar CSOSN 61. Para CSOSN 61 será criado no grupo imposto a tag CST
                if (Form1.spdNFCeDataSets1.Campo('CST_N12').AsString = '61') then
                begin

                  sMensagemIcmMonofasicoSobreCombustiveis := 'ICMS monofásico sobre combustíveis cobrado anteriormente conforme Convênio ICMS 199/2022;'; // Sandro Silva 2023-09-05

                  Form1.spdNFCeDataSets1.Campo('vBC_N15').Value     := FormatFloatXML(dvBC_N15);  // BC
                  Form1.spdNFCeDataSets1.Campo('vICMS_N17').Value   := FormatFloatXML(dvICMS_N17);  // Valor do ICMS em Reais

                  Form1.spdNFCeDataSets1.Campo('qBCMonoRet_N43a').Value  := Form1.spdNFCeDataSets1.Campo('qCom_I10').Value;
                  dqBCMonoRet_N43aTotal := dqBCMonoRet_N43aTotal + XmlValueToFloat(Form1.spdNFCeDataSets1.Campo('qCom_I10').Value); // Sandro Silva 2023-09-04
                  Form1.spdNFCeDataSets1.Campo('adRemICMSRet_N44').Value := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('adRemICMSRet', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0.00), 4);
                  dvICMSMonoRet_N45      := XmlValueToFloat(Form1.spdNFCeDataSets1.Campo('qBCMonoRet_N43a').AsString) * XmlValueToFloat(Form1.spdNFCeDataSets1.Campo('adRemICMSRet_N44').AsString);
                  // Sandro Silva 2023-09-05 dvICMSMonoRet_N45Total := dvICMSMonoRet_N45Total + dvICMSMonoRet_N45;

                  Form1.spdNFCeDataSets1.Campo('vICMSMonoRet_N45').Value := FormatFloatXML(dvICMSMonoRet_N45);

                  dvICMSMonoRet_N45Total := dvICMSMonoRet_N45Total + XmlValueToFloat(Form1.spdNFCeDataSets1.Campo('vICMSMonoRet_N45').Value); // Sandro Silva 2023-09-04
                end;
                {Sandro Silva 2023-05-17 fim}

                // Cálculo da desoneração
                if (RetornaValorDaTagNoCampo('motDesICMS', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '') then
                begin
                  Form1.spdNFCeDataSets1.Campo('motDesICMS_N28').Value  := RetornaValorDaTagNoCampo('motDesICMS', Form1.ibDataSet4.FieldByname('TAGS_').AsString);
                  Form1.spdNFCeDataSets1.Campo('vICMSDeson_N28a').Value := FormatFloatXML(dvICMSDeson_N28a);
                  dvICMSDeson_W04a := dvICMSDeson_W04a + dvICMSDeson_N28a;
                end;

                //
                if LimpaNumero(Form1.ibDataSet4.FieldByname('CST_PIS_COFINS_SAIDA').AsString) <> '' then
                begin
                  //PIS e COFINS
                  sCSTPISCofins := Form1.ibDataSet4.FieldByname('CST_PIS_COFINS_SAIDA').AsString;
                  Form1.ibDataSet27.Edit;
                  Form1.ibDataSet27.FieldByname('CST_PIS_COFINS').Value := sCSTPISCofins;
                  Form1.ibDataSet27.FieldByname('ALIQ_PIS').Value       := Form1.ibDataSet4.FieldByname('ALIQ_PIS_SAIDA').AsFloat;
                  Form1.ibDataSet27.FieldByname('ALIQ_COFINS').Value    := Form1.ibDataSet4.FieldByname('ALIQ_COFINS_SAIDA').AsFloat;
                  if (sCSTPISCofins = '01') or (sCSTPISCofins = '02') or (sCSTPISCofins = '49') or (sCSTPISCofins = '99') then
                  begin
                    // Q02 PISAliq 01=Operação Tributável (base de cálculo = valor da operação alíquota normal (cumulativo/não cumulativo)); 02=Operação Tributável (base de cálculo = valor da operação (alíquota diferenciada));
                    // Q05 PISOutr 99=Outras Operações;
                    dvBCPIS_Q07 := dvProd_I11 - fDescontoTotalRateado + dRateioAcrescimoItem;

                    {Sandro Silva 2021-07-26 inicio}
                    if (LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString) <> '1') then
                    begin
                      if (Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring <> '60') then // CST 60 icms efetivo Sandro Silva 2021-08-04
                      begin
                        dvBCPIS_Q07 := dvBCPIS_Q07 - dvICMS_N17;
                        if dvBCPIS_Q07 < 0 then
                          dvBCPIS_Q07 := 0.00;
                      end;
                    end;
                    {Sandro Silva 2021-07-26 fim}

                    dvPIS_Q09 := StrToFloat(FormatFloat('##0.00',dvBCPIS_Q07 * (Form1.ibDataSet4.FieldByname('ALIQ_PIS_SAIDA').AsFloat / 100)));

                    dvPIS_W13 := dvPIS_W13 + dvPIS_Q09;
                    Form1.spdNFCeDataSets1.Campo('CST_Q06').Value  := sCSTPISCofins;
                    Form1.spdNFCeDataSets1.Campo('vBC_Q07').Value  := FormatFloatXML(dvBCPIS_Q07); // Sandro Silva 2017-04-24  FormatFloatXML(dvProd_I11 - fDescontoTotalRateado);
                    Form1.spdNFCeDataSets1.Campo('pPIS_Q08').Value := FormatFloatXML(Form1.ibDataSet4.FieldByname('ALIQ_PIS_SAIDA').AsFloat);
                    Form1.spdNFCeDataSets1.Campo('vPIS_Q09').Value := FormatFloatXML(dvPIS_Q09);

                    // S02 COFINSAliq 01=Operação Tributável (base de cálculo = valor da operação alíquota normal (cumulativo/não cumulativo)); 02=Operação Tributável (base de cálculo = valor da operação (alíquota diferenciada));
                    // S05 COFINSOutr 99=Outras Operações;

                    dvBCCofins_S07 := dvProd_I11 - fDescontoTotalRateado + dRateioAcrescimoItem;
                    {Sandro Silva 2021-07-26 inicio}
                    if (LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString) <> '1') then
                    begin
                      if (Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring <> '60') then // CST 60 icms efetivo Sandro Silva 2021-08-04
                      begin
                        dvBCCofins_S07 := dvBCCofins_S07 - dvICMS_N17;
                        if dvBCCofins_S07 < 0 then
                          dvBCCofins_S07 := 0.00;
                      end;
                    end;
                    {Sandro Silva 2021-07-26 fim}

                    dvCOFINS_S11 := StrToFloat(FormatFloat('##0.00', dvBCCofins_S07 * (Form1.ibDataSet4.FieldByname('ALIQ_COFINS_SAIDA').AsFloat / 100)));

                    dvCofins_W14 := dvCofins_W14 + dvCOFINS_S11;
                    Form1.spdNFCeDataSets1.Campo('CST_S06').Value     := sCSTPISCofins;
                    Form1.spdNFCeDataSets1.Campo('vBC_S07').Value     := FormatFloatXML(dvBCCofins_S07); // Sandro Silva 2017-04-24  FormatFloatXML(dvProd_I11 - fDescontoTotalRateado);
                    Form1.spdNFCeDataSets1.Campo('pCOFINS_S08').Value := FormatFloatXML(Form1.ibDataSet4.FieldByname('ALIQ_COFINS_SAIDA').AsFloat);
                    Form1.spdNFCeDataSets1.Campo('vCOFINS_S11').Value := FormatFloatXML(dvCOFINS_S11);
                  end
                  else if (sCSTPISCofins = '03') then
                  begin
                    // Q03 PISQtde 03=Operação Tributável (base de cálculo = quantidade vendida x alíquota por unidade de produto);
                    dvPIS_Q09 := StrToFloat(FormatFloat('##0.00', Form1.ibDataSet4.FieldByname('ALIQ_PIS_SAIDA').AsFloat * StrToFloat(StringReplace(Form1.spdNFCeDataSets1.Campo('qCom_I10').Value, '.', ',',[rfReplaceAll]))));
                    dvPIS_W13 := dvPIS_W13 + dvPIS_Q09;
                    Form1.spdNFCeDataSets1.Campo('CST_Q06').Value       := sCSTPISCofins;
                    Form1.spdNFCeDataSets1.Campo('qBCProd_Q10').Value   := Form1.spdNFCeDataSets1.Campo('qCom_I10').Value;
                    Form1.spdNFCeDataSets1.Campo('vAliqProd_Q11').Value := FormatFloatXML(Form1.ibDataSet4.FieldByname('ALIQ_PIS_SAIDA').AsFloat);
                    Form1.spdNFCeDataSets1.Campo('vPIS_Q09').Value      := FormatFloatXML(dvPIS_Q09);

                    // S03 COFINSQtde 03=Operação Tributável (base de cálculo = quantidade vendida x alíquota por unidade de produto);
                    dvCOFINS_S11 := StrToFloat(FormatFloat('##0.00', Form1.ibDataSet4.FieldByname('ALIQ_COFINS_SAIDA').AsFloat * StrToFloat(StringReplace(Form1.spdNFCeDataSets1.Campo('qCom_I10').Value, '.', ',',[rfReplaceAll]))));
                    dvCofins_W14 := dvCofins_W14 + dvCOFINS_S11;
                    Form1.spdNFCeDataSets1.Campo('CST_S06').Value       := sCSTPISCofins;
                    Form1.spdNFCeDataSets1.Campo('qBCProd_S09').Value   := Form1.spdNFCeDataSets1.Campo('qCom_I10').Value;
                    Form1.spdNFCeDataSets1.Campo('vAliqProd_S10').Value := FormatFloatXML(Form1.ibDataSet4.FieldByname('ALIQ_COFINS_SAIDA').AsFloat);
                    Form1.spdNFCeDataSets1.Campo('vCOFINS_S11').Value   := FormatFloatXML(dvCOFINS_S11);
                  end
                  else
                  if (sCSTPISCofins = '04') or (sCSTPISCofins = '05') or (sCSTPISCofins = '06') or (sCSTPISCofins = '07')
                    or (sCSTPISCofins = '08') or (sCSTPISCofins = '09') then
                  begin
                    // Q04 PISNT 04=Operação Tributável (tributação monofásica (alíquota zero)); 05=Operação Tributável (Substituição Tributária); 06=Operação Tributável (alíquota zero); 07=Operação Isenta da Contribuição; 08=Operação Sem Incidência da Contribuição; 09=Operação com Suspensão da Contribuição;
                    Form1.spdNFCeDataSets1.Campo('CST_Q06').Value := sCSTPISCofins;

                    // S04 COFINSNT 04=Operação Tributável (tributação monofásica, alíquota zero); 05=Operação Tributável (Substituição Tributária); 06=Operação Tributável (alíquota zero); 07=Operação Isenta da Contribuição; 08=Operação Sem Incidência da Contribuição; 09=Operação com Suspensão da Contribuição;
                    Form1.spdNFCeDataSets1.Campo('CST_S06').Value := sCSTPISCofins;
                  end;

                end; // if LimpaNumero(Form1.ibDataSet4.FieldByname('CST_PIS_COFINS_SAIDA').AsString) <> '' then

                if Form1.spdNFCeDataSets1.Campo('indFinal_B25a').Value = '1' then // Operação consumidor final
                begin

                  if (Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring = '60') or (Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value = '500') then
                  begin

                    dpICMSEfet_N36  := 0.00;
                    dpRedBCEfet_N34 := 0.00;

                    _ecf65_IdentificaPercentuaisICMSEfetivo(dpICMSEfet_N36, dpRedBCEfet_N34);

                    if dpRedBCEfet_N34 <= 0 then
                      dvBCEfet_N35 := StrToFloatDef(FormatFloat('0.00', Form1.ibDataSet27.FieldByname('TOTAL').AsFloat), 0)
                    else
                      dvBCEfet_N35 := StrToFloatDef(FormatFloat('0.00', Form1.ibDataSet27.FieldByname('TOTAL').AsFloat * (dpRedBCEfet_N34 / 100)), 0);  // Aplica o percentual de redução na B.C.

                    Form1.spdNFCeDataSets1.Campo('pRedBCEfet_N34').Value := FormatFloatXML(100 - dpRedBCEfet_N34); // Percentual de redução da base de cálculo efetiva  Calcula o percentual que foi reduzida a base de cálculo. No Estoque pRedBC=66,67, então no xml irá 33,33 (100-66,67)
                    Form1.spdNFCeDataSets1.Campo('vBCEfet_N35').Value    := FormatFloatXML(dvBCEfet_N35);// Valor da base de cálculo efetiva
                    Form1.spdNFCeDataSets1.Campo('pICMSEfet_N36').Value  := FormatFloatXML(dpICMSEfet_N36);// Alíquota do ICMS efetiva
                    Form1.spdNFCeDataSets1.Campo('vICMSEfet_N37').Value  := FormatFloatXML(dvBCEfet_N35 * dpICMSEfet_N36 / 100) ; // Valor do ICMS efetivo

                  end;

                end;

              end; // if Servico then

              {Sandro Silva 2022-05-02 inicio}
              //Nota Técnica 2021.004
              //cProdANVISA_K01a
              //xMotivoIsencao_K01b
              //vPMC_K06

              //if Form1.ibDataSet4.FieldByname('TAGS_').AsString <> '' then
              //begin
                //if (RetornaValorDaTagNoCampo('cProdANVISA', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '') then //
                //begin

                if _ecf65_GerarcProdANVISA(Form1.ibDataSet4.FieldByname('TAGS_').AsString, Form1.spdNFCeDataSets1.Campo('NCM_I05').Value) then
                begin

                  Form1.spdNFCeDataSets1.Campo('cProdANVISA_K01a').Value := AnsiUpperCase(RetornaValorDaTagNoCampo('cProdANVISA', Form1.ibDataSet4.FieldByname('TAGS_').AsString));

                  if Form1.spdNFCeDataSets1.Campo('cProdANVISA_K01a').Value = 'ISENTO' then
                    Form1.spdNFCeDataSets1.Campo('xMotivoIsencao_K01b').Value := Trim(ConverteAcentos2(RetornaValorDaTagNoCampo('xMotivoIsencao', Form1.ibDataSet4.FieldByname('TAGS_').AsString)));

                  Form1.spdNFCeDataSets1.Campo('vPMC_K06').Value := FormatFloatXML(Form1.ibDataSet4.FieldByname('PRECO').AsFloat);
                end;
                //end;
              //end;

              {Sandro Silva 2022-05-02 fim}

              Form1.spdNFCeDataSets1.Campo('indTot_I17b').Value  := '1'; //Indica se valor do Item (vProd) entra no valor total da NFC-e (vProd)
              //
              // END TAGS
              //
              if Form1.spdNFCeDataSets1.Campo('NCM_I05').Value = '' then
              begin
                sLogErro := 'Erro:22' + Chr(10) + 'Configure no Estoque, o NCM para o produto: '+Form1.spdNFCeDataSets1.Campo('cProd_I02').Value+' '+Form1.spdNFCeDataSets1.Campo('xProd_I04').Value+chr(10);  // Sandro Silva 2018-04-11  sLogErro := 'Erro:22' + Chr(10) + 'NCM não preenchido' + Chr(10) + Chr(10)+'Ao salvar item código: '+Form1.spdNFCeDataSets1.Campo('cProd_I02').Value+chr(10)+Form1.spdNFCeDataSets1.Campo('xProd_I04').Value+chr(10);
                sStatus := 'NCM não preenchido' + ' ' + Form1.spdNFCeDataSets1.Campo('cProd_I02').Value+ ' ' +Form1.spdNFCeDataSets1.Campo('xProd_I04').Value;
                LogErroCredenciadoraCartao(Form1.sNomeRede, sCNPJ_YA05, sLogErro);
                ConcatenaLog(sLogErroItens, sLogErro); // Sandro Silva 2018-07-20 sLogErroItens := sLogErroItens + Chr(10) + sLogErro;
              end;
            end; // if (Alltrim(Form1.ibDataSet4.FieldByName('CODIGO').AsString) = Alltrim(Form1.ibDAtaSet27.FieldByName('CODIGO').AsString)) and (Alltrim(Form1.ibDataSet4.FieldByName('CODIGO').AsString) <> '') then
          end; // if (Form1.ibDataSet27.FieldByName('TIPO').AsString = 'BALCAO') or (Form1.ibDataSet27.FieldByName('TIPO').AsString = 'LOKED') then // Apenas os itens não cancelados
          //
          try
            Form1.spdNFCeDataSets1.SalvarItem;
          except
            on E: Exception do
            begin
              LogErroCredenciadoraCartao(Form1.sNomeRede, sCNPJ_YA05, sLogErroItens);
              if AnsiContainsText(sLogErroItens, E.Message) = False then
                sLogErroItens := sLogErroItens + Chr(10) + 'Erro:22' + Chr(10) + E.Message + Chr(10)+ chr(10) + 'Ao incluir item:';
              sLogErroItens := sLogErroItens + chr(10) + Form1.spdNFCeDataSets1.Campo('cProd_I02').Value + ' - ' + Form1.spdNFCeDataSets1.Campo('xProd_I04').Value + chr(10);
              sStatus := E.Message + ' ' + Form1.spdNFCeDataSets1.Campo('cProd_I02').Value + ' ' + Form1.spdNFCeDataSets1.Campo('xProd_I04').Value;
              Form1.spdNFCeDataSets1.Cancelar;
            end;
          end;
          //
          Form1.ibDataSet27.Next;
          //
        end; // while not Form1.ibDataSet27.Eof do
        //
        // Fim gerando itens
        //

        if sLogErroItens <> '' then
        begin
          if AnsiContainsText(sLogErroItens, sLogErro) then
            sLogErro := sLogErroItens
          else
            sLogErro := Chr(10) + sLogErroItens;

          if AnsiContainsText(sLogErro, 'Leia atentamente a mensagem acima e tente resolver o problema.'+chr(10)+'Considere pedir ajuda ao seu contador para o preenchimento correto da NFC-e.') = False then
            if AnsiContainsText(sLogErro, 'Erro:22') then // Alerta para tentar resolver problema sem acionar suporte Small
              sLogErro := sLogErro + chr(10)+'Leia atentamente a mensagem acima e tente resolver o problema.'+chr(10)+'Considere pedir ajuda ao seu contador para o preenchimento correto da NFC-e.';

          Exit;
        end;

        //
        // Totalizadores da NFe
        //
        Form1.spdNFCeDataSets1.Campo('vBC_W03').Value           := FormatFloatXML(rBaseICMS); // Base de Cálculo do ICMS
        Form1.spdNFCeDataSets1.Campo('vICMS_W04').Value         := FormatFloatXML(rValorICMS); // Valor Total do ICMS
        //
        Form1.spdNFCeDataSets1.Campo('vICMSDeson_W04a').Value   := FormatFloatXML(dvICMSDeson_W04a); // Sandro Silva 2019-08-29 '0.00'; // Desonerado
        //
        Form1.spdNFCeDataSets1.Campo('vBCST_W05').Value         := '0.00'; // Base de Cálculo do ICMS Subst. Tributária
        Form1.spdNFCeDataSets1.Campo('vST_W06').Value           := '0.00'; // Valor Total do ICMS Sibst. Tributária
        
        {Sandro Silva 2023-09-04 inicio}
        Form1.spdNFCeDataSets1.Campo('qBCMonoRet_W06d1').Value  := FormatFloatXML(dqBCMonoRet_N43aTotal); //Valor total da quantidade tributada do ICMS monofásico retido anteriormente
        Form1.spdNFCeDataSets1.Campo('vICMSMonoRet_W06e').Value := FormatFloatXML(dvICMSMonoRet_N45Total); //Valor total do ICMS monofásico retido anteriormente
        {Sandro Silva 2023-09-04 fim}

        Form1.spdNFCeDataSets1.campo('vFCPUFDest_W04c').Value   := '0.00'; // Novo Sandro Silva 2018-03-28
        Form1.spdNFCeDataSets1.campo('vICMSUFDest_W04e').Value  := '0.00'; // Novo Sandro Silva 2018-03-28
        Form1.spdNFCeDataSets1.campo('vICMSUFRemet_W04g').Value := '0.00'; // Novo Sandro Silva 2018-03-28
        Form1.spdNFCeDataSets1.campo('vFCP_W04h').Value         := FormatFloatXML(dvFCP_W04h); // Novo Sandro Silva 2018-03-28
        Form1.spdNFCeDataSets1.campo('vFCPST_W06a').Value       := '0.00';//Novo
        Form1.spdNFCeDataSets1.campo('vFCPSTRet_W06b').Value    := '0.00';//Novo
        //
        Form1.spdNFCeDataSets1.Campo('vProd_W07').Value         := FormatFloatXML(fValorProdutos); // Valor Total de Produtos e Serviços
        Form1.spdNFCeDataSets1.Campo('vFrete_W08').Value        := '0.00'; // Valor Total do Frete
        Form1.spdNFCeDataSets1.Campo('vSeg_W09').Value          := '0.00'; // Valor Total do Seguro
        //
        if fDesconto > 0 then
        begin
          Form1.spdNFCeDataSets1.Campo('vDesc_W10').Value       := FormatFloatXML(fDesconto); // Valor Total de Desconto
        end
        else
        begin
          Form1.spdNFCeDataSets1.Campo('vDesc_W10').Value       := '0.00';
        end;

        if dvOutro_W15 > 0 then
        begin
          Form1.spdNFCeDataSets1.Campo('vOutro_W15').Value      := FormatFloatXML(dvOutro_W15); // Valor Total de Acrescimo
        end
        else
        begin
          Form1.spdNFCeDataSets1.Campo('vOutro_W15').Value      := '0.00';
        end;

        if dvServ_W18 > 0 then
        begin
          Form1.spdNFCeDataSets1.Campo('vServ_W18').Value       := FormatFloatXML(dvServ_W18); // Valor Total dos Serviços sob não-incidência ou não tributados pelo ICMS
          if dvBC_W19 > 0 then // 2016-01-14
            Form1.spdNFCeDataSets1.Campo('vBC_W19').Value       := FormatFloatXML(dvBC_W19); // Valor Total dos Serviços sob não-incidência ou não tributados pelo ICMS
          if dvISS_W20 > 0 then // 2016-01-14
            Form1.spdNFCeDataSets1.Campo('vISS_W20').Value      := FormatFloatXML(dvISS_W20); // Valor Total dos Serviços sob não-incidência ou não tributados pelo ICMS
          //Form1.spdNFCeDataSets1.Campo('vPIS_W21').Value        := StrTran(Alltrim(FormatFloat('##0.00', dvPIS_W21)), ',', '.'); // Valor Total dos Serviços sob não-incidência ou não tributados pelo ICMS
          //Form1.spdNFCeDataSets1.Campo('vCOFINS_W22').Value     := StrTran(Alltrim(FormatFloat('##0.00', dvCOFINS_W22)), ',', '.'); // Valor Total dos Serviços sob não-incidência ou não tributados pelo ICMS
          Form1.spdNFCeDataSets1.Campo('dCompet_W22a').Value    := FormatDateTime('YYYY-MM-DD', dtEnvio)// Data da prestação do serviço
        end;
        //
        Form1.spdNFCeDataSets1.Campo('vII_W11').Value           := '0.00'; // Valor Total do II
        Form1.spdNFCeDataSets1.Campo('vIPI_W12').Value          := '0.00'; // Valor Total do IPI
        Form1.spdNFCeDataSets1.campo('vIPIDevol_W12a').Value    := '0.00'; //Novo 4.00
        Form1.spdNFCeDataSets1.Campo('vPIS_W13').Value          := FormatFloatXML(dvPIS_W13); // Sandro Silva 2016-09-30  '0.00'; // Valor Toal do PIS
        Form1.spdNFCeDataSets1.Campo('vCOFINS_W14').Value       := FormatFloatXML(dvCofins_W14); // Sandro Silva 2016-09-30  '0.00'; // Valor Total do COFINS
        Form1.spdNFCeDataSets1.Campo('vNF_W16').Value           := StrTran(Alltrim(FormatFloat('##0.00',fValorProdutos + dvServ_W18 - fDesconto + dvOutro_W15)),',','.'); // Valor Total da NFe - Versão Trial só aceita NF até R$ 1.00
        Form1.spdNFCeDataSets1.Campo('modFrete_X02').Value      := '9'; //Modalidade do frete: 0- Por conta do emitente; 1- Por conta do destinatário/remetente; 2- Por conta de terceiros; 9- Sem frete.
        //
        // Valor Aproximado dos Tributos IIA Indicie de Imposto Aproximado
        //
        Form1.spdNFCeDataSets1.Campo('vTotTrib_W16a').Value     := FormatFloatXML(fTotalTributos); //
        //
        // Não pode sobrar troco para versão inferior 4.00
        //
        {Sandro Silva 2020-10-16 inicio
        //Lendo as formas de pagamento do xml em contingência e repassando para o novo
        xNodePag := XMLNFE.selectNodes('//pag');
        for iNode := 0 to xNodePag.length -1 do
        begin

          if xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//pag[' + IntToStr(iNode) + ']/tPag') <> '' then //3.10
          begin
            Form1.spdNFCeDataSets1.IncluirPart('YA');
            Form1.spdNFCeDataSets1.Campo('tPag_YA02').Value       := xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//pag[' + IntToStr(iNode) + ']/tPag');
            Form1.spdNFCeDataSets1.Campo('vPag_YA03').Value       := xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//pag[' + IntToStr(iNode) + ']/vPag');
            //Identificação da credenciadora
            Form1.spdNFCeDataSets1.Campo('CNPJ_YA05').Value       := xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//pag[' + IntToStr(iNode) + ']/card/CNPJ');
            Form1.spdNFCeDataSets1.Campo('tpIntegra_YA04a').Value := xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//pag[' + IntToStr(iNode) + ']/card/tpIntegra');
            Form1.spdNFCeDataSets1.Campo('tBand_YA06').Value      := xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//pag[' + IntToStr(iNode) + ']/card/tBand');
            Form1.spdNFCeDataSets1.Campo('cAut_YA07').Value       := xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//pag[' + IntToStr(iNode) + ']/card/cAut');
            Form1.spdNFCeDataSets1.SalvarPart('YA');
          end;

          if xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//pag[' + IntToStr(iNode) + ']/detPag/tPag') <> '' then //4.00
          begin
            Form1.spdNFCeDataSets1.IncluirPart('YA');
            Form1.spdNFCeDataSets1.Campo('tPag_YA02').Value       := xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//pag[' + IntToStr(iNode) + ']/detPag/tPag');
            Form1.spdNFCeDataSets1.Campo('vPag_YA03').Value       := xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//pag[' + IntToStr(iNode) + ']/detPag/vPag');
            //Identificação da credenciadora
            Form1.spdNFCeDataSets1.Campo('CNPJ_YA05').Value       := xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//pag[' + IntToStr(iNode) + ']/detPag/card/CNPJ');
            Form1.spdNFCeDataSets1.Campo('tpIntegra_YA04a').Value := xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//pag[' + IntToStr(iNode) + ']/detPag/card/tpIntegra');
            Form1.spdNFCeDataSets1.Campo('tBand_YA06').Value      := xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//pag[' + IntToStr(iNode) + ']/detPag/card/tBand');
            Form1.spdNFCeDataSets1.Campo('cAut_YA07').Value       := xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//pag[' + IntToStr(iNode) + ']/detPag/card/cAut');
            Form1.spdNFCeDataSets1.SalvarPart('YA');
          end;

        end;
        }

        ///<detPag><tPag>
        //Lendo as formas de pagamento do xml em contingência e repassando para o novo
        //Identifica se tags de pagamento estão na estrutura antiga ou da versão 4.00
        if AnsiContainsText(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '<detPag><tPag>') then  // 4.00
          xNodePag := XMLNFE.selectNodes('//detPag')  //4.00
        else
          xNodePag := XMLNFE.selectNodes('//pag');  //3.10

        // Obtem todos os dados das formas de pagamento
        for iNode := 0 to xNodePag.length -1 do
        begin

          Form1.spdNFCeDataSets1.IncluirPart('YA');
          Form1.spdNFCeDataSets1.Campo('tPag_YA02').Value       := xmlNodeValue(xNodePag.item[iNode].xml, '//tPag');
          Form1.spdNFCeDataSets1.Campo('vPag_YA03').Value       := xmlNodeValue(xNodePag.item[iNode].xml, '//vPag');
          //Identificação da credenciadora
          Form1.spdNFCeDataSets1.Campo('CNPJ_YA05').Value       := xmlNodeValue(xNodePag.item[iNode].xml, '//card/CNPJ');
          Form1.spdNFCeDataSets1.Campo('tpIntegra_YA04a').Value := xmlNodeValue(xNodePag.item[iNode].xml, '//card/tpIntegra');
          Form1.spdNFCeDataSets1.Campo('tBand_YA06').Value      := xmlNodeValue(xNodePag.item[iNode].xml, '//card/tBand');
          Form1.spdNFCeDataSets1.Campo('cAut_YA07').Value       := xmlNodeValue(xNodePag.item[iNode].xml, '//card/cAut');
          Form1.spdNFCeDataSets1.SalvarPart('YA');

        end;

        Form1.spdNFCeDataSets1.IncluirPart('YA');
        Form1.spdNFCeDataSets1.Campo('vTroco_YA09').Value  := xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//vTroco');// FormatFloatXML(Form1.ibDataSet25ACUMULADO3.AsFloat); //
        Form1.spdNFCeDataSets1.SalvarPart('YA');

        Mais1ini.Free;
        //

        Form1.spdNFCeDataSets1.Campo('infAdFisco_Z02').Value := ''; // Dados Adicionais da NFe - Observações Interesse do Fisco

        if dvFCP_W04h > 0 then
          Form1.spdNFCeDataSets1.Campo('infAdFisco_Z02').Value := 'Total do FCP:R$' + FormatFloat('0.00', dvFCP_W04h);

        //
        Form1.spdNFCeDataSets1.Campo('infCpl_Z03').Value := xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//infAdic/infCpl');

        {Sandro Silva 2023-09-05 inicio
        if (dvICMSMonoRet_N45Total > 0.00) and (AnsiContainsText(Form1.spdNFCeDataSets1.Campo('infCpl_Z03').Value, 'ICMS monofásico sobre combustíveis cobrado anteriormente conforme Convênio ICMS 199/2022;') = False) then
            Form1.spdNFCeDataSets1.Campo('infCpl_Z03').Value := Form1.spdNFCeDataSets1.Campo('infCpl_Z03').Value + '|' + 'ICMS monofásico sobre combustíveis cobrado anteriormente conforme Convênio ICMS 199/2022;';
        }
        if (sMensagemIcmMonofasicoSobreCombustiveis <> '') and (AnsiContainsText(Form1.spdNFCeDataSets1.Campo('infCpl_Z03').Value, sMensagemIcmMonofasicoSobreCombustiveis) = False) then
          Form1.spdNFCeDataSets1.Campo('infCpl_Z03').Value := Form1.spdNFCeDataSets1.Campo('infCpl_Z03').Value + '|' + sMensagemIcmMonofasicoSobreCombustiveis;
        {Sandro Silva 2023-09-05 fim}

        //
        // SAIDA
        //
        if LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString) <> '' then
        begin
          Form1.spdNFCeDataSets1.Campo('CRT_C21').Value := LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString); // 1 - Simples nacional 2 - Simples Nacional excesso 3 - Regime normal
        end else
        begin
          Form1.spdNFCeDataSets1.Campo('CRT_C21').Value := '1'; // 1 - Simples nacional 2 - Simples Nacional excesso 3 - Regime normal
        end;
        //
        Form1.spdNFCeDataSets1.Campo('versao_A02').Value := '4.00'; // Versão do Layout que está utilizando - Manual 4.0
        // Salva DataSets e Converte em XML montando um LOTE de XMLS a ser assinados
        //
        try
          Form1.spdNFCeDataSets1.Salvar; // Salva DataSets e Converte em XML montando um LOTE de XMLS a ser assinados
        except
          on E: Exception do
          begin
            //
            sLogErro := 'Erro: 21' + Chr(10) + E.Message+chr(10)+
              chr(10)+'Leia atentamente a mensagem acima e tente resolver o problema. Considere pedir ajuda ao seu contador para o preenchimento correto da NFC-e.';
            LogErroCredenciadoraCartao(Form1.sNomeRede, sCNPJ_YA05, sLogErro);
            sStatus := E.Message;
            Exit;
            //
          end;
        end;
        //
        // Assinando
        //
        try
          //
          fNFe := Form1.spdNFCeDataSets1.LoteNFCe.GetText;  //Copia XML que está Componente p/ Field fNFe
          //
        except
          //
          sLogErro := 'Erro ao gravar NFC-e';
          LogErroCredenciadoraCartao(Form1.sNomeRede, sCNPJ_YA05, sLogErro);

          sStatus := sLogErro;
          Exit;
          //
        end;
        //
        // Assinando
        //
        try
          //
          fNFe := Form1.spdNFCe1.AssinarNota(fNFe);
          wsNFCeAssinada := fNFe; // Sandro Silva 2015-03-31 XML assinado para gravar em NFCE.NFEXML se ocorrer rejeição;
          sResultado := wsNFCeAssinada;
          //
        except
          //
          sLogErro := 'Erro ao assinar NFC-e';
          LogErroCredenciadoraCartao(Form1.sNomeRede, sCNPJ_YA05, sLogErro);
          sStatus := sLogErro;
          sResultado := ''; // Sandro Silva 2020-02-13 
          Exit;
          //
        end;
        //
        try
          if Trim(sResultado) <> '' then //if _ecf65_LoadXmlDestinatario(pChar(Form1.ibDataSet150.FieldByName('NFEID').AsString)) <> '' then
          begin
            Form1.IBDataSet150.Close;
            Form1.IBDataSet150.SelectSQL.Text :=
              'select * ' +
              'from NFCE ' +
              'where NUMERONF = ' + QuotedStr(FormataNumeroDoCupom(iPedido)) + // Sandro Silva 2020-10-16 'where NUMERONF = ' + QuotedStr(FormatFloat('000000', iPedido)) +   
              ' and CAIXA = ' + QuotedStr(sCaixaXml) + // Sandro Silva 2018-03-07  ' and CAIXA = ' + QuotedStr(Form1.ClientDataSet1.FieldByName('CAIXA').AsString) +
              ' and MODELO = ''65'' ';
            Form1.IBDataSet150.Open;

            if (Form1.ibDataSet150.State in [dsEdit, dsInsert]) = False then
              Form1.ibDataSet150.Edit;
            Form1.ibDataSet150.FieldByName('NFEXML').AsString := Trim(sResultado);//_ecf65_LoadXmlDestinatario(pChar(Form1.ibDataSet150.FieldByName('NFEID').AsString));
            Form1.ibDataSet150.Post;
          end;
        except
          sResultado := ''; // Sandro Silva 2020-02-13
        end;
        //
      except
        //
        on E: Exception do
        begin
          if sLogErro <> '' then
            sLogErro := sLogErro + Chr(10);
          if E.Message <> 'Operation aborted' then // 2015-07-06
            sLogErro := sLogErro + 'Erro! '+E.Message;
          sResultado := '';
          LogErroCredenciadoraCartao(Form1.sNomeRede, sCNPJ_YA05, sLogErro);
          Exit;
        end;
        //
        // aqui volta na venda
        //
      end;
    finally
      // Sandro Silva 2018-08-06  Result := wsNFCeAssinada;
    end;
  end;

  FreeAndNil(IBQALTERACA); // Sandro Silva 2019-08-05
end;

function _ecf65_EnviarNFCe(pp1: Boolean): Boolean;
var
  Mais1Ini : tIniFile;
  bButton: Integer;
  //{Sandro Silva 2019-07-24 inicio
  I : Integer;
  fTotalTributos, fValorProdutos, fTotalSemDesconto, fDescontoDoItem, fDescontoTotalRateado, fDesconto, rBaseICMS, rValorICMS : Real;
  dvBC_U02: Double; // 2015-12-09
  dvISSQN_U04: Double; // 2015-12-09
  dvServ_W18: Double; // 2015-12-09
  dvBC_W19: Double; // 2015-12-09
  dvAliq_U03: Double; // 2015-12-09
  dvISS_W20: Double; // 2015-12-09
  dvPIS_W21: Double; // 2015-12-09
  dvCOFINS_W22: Double; // 2015-12-09
  dAcrescimoTotal: Double; //2015-12-07
  dRateioAcrescimoItem: Double; // 2015-12-10
  dDescontoTotalCupom: Double; // 2015-12-10
  dvOutro_W15: Double; // 2015-12-10
  //}
  //{Sandro Silva 2019-07-24 fim}
  sNovoNumero, sStatus, sID, sRetorno, sLote: String;
  Hora, Min, Seg, cent : Word;
  tInicio : tTime;
  dtEnvio: TDate; // Sandro Silva 2015-03-30 Data do envio. Usado para atualizar ALTERACA.DATA mantendo NFCE.DATA = ALTARACA.DATA.
  hrEnvio: String; // Sandro Silva 2015-03-30 Data do envio. Usado para atualizar ALTERACA.HORA mantendo igual ao XML quando itens são vendidos em dias diferentes. Ex.: Mesa
  wsNFCeAssinada: WideString;
  dvTotTrib_M02: Double; // Sandro Silva 2015-05-06 Total do aprox. tributo do produto
  dvBC_N15: Double; // Sandro Silva 2018-02-19
  dvFCP_N17c: Real;// Double; // Sandro Silva 2018-02-19
  dvFCP_W04h: Real; // Double; // Sandro Silva 2018-02-19
  dpICMS_N16: Double; // Sandro Silva 2016-01-16 Alíquota do imposto ICMS
  dvICMS_N17: Double; // Sandro Silva 2015-05-07 Total ICMS do produto;
  dvProd_I11: Double; // Sandro Silva 2015-10-16 Valor do Produto
  dvDesc_I17: Double; // Sandro Silva 2016-01-11
  dvBCPIS_Q07: Double; // Sandro Silva 2017-04-24
  dvPIS_Q09: Double; // Sandro Silva 2016-09-30
  dvCOFINS_S11: Double; // Sandro Silva 2016-09-30
  dvBCCofins_S07: Double; // Sandro Silva 2017-04-24
  dvPIS_W13: Double; // Sandro Silva 2016-09-30
  dvCofins_W14: Double; // Sandro Silva 2016-09-30
  dvBCEfet_N35: Real; // Sandro Silva 2019-02-05
  dpRedBCEfet_N34: Double; // Sandro Silva 2019-02-05
  dpICMSEfet_N36: Double; // Sandro Silva 2019-02-05
  dpRedBC_N14: Real; // Sandro Silva 2019-02-08
  dvICMSDeson_N28a: Real; // Sandro Silva 2019-08-29
  dvICMSDeson_W04a: Real; // Sandro Silva 2019-08-29
  dvICMSMonoRet_N45: Real; // Sandro Silva 2023-05-19
  dvICMSMonoRet_N45Total: Real; // Sandro Silva 2023-05-19
  dqBCMonoRet_N43aTotal: Real; // Sandro Silva 2023-09-04
  sMensagemIcmMonofasicoSobreCombustiveis: String; // Sandro Silva 2023-09-05  
  //
  bOk: Boolean; // Sandro Silva 2015-06-02
  sLogErro: String; // Sandro Silva 2015-06-02
  sLogErroCredenciadoraCartao: String; // Sandro Silva 2020-10-21
  sLogErroItens: String; // Sandro Silva 2017-08-15
  sPdfMobile: String;
  sVendedorNome: String;
  sDAV: String;
  sTIPODAV: String;
  dtAlteracaData: TDate;
  schNFe: String;
  sArqPrimeiroEnvio: String; // Sandro Silva 2016-03-14
  sArqRetSituacao: String; // Sandro Silva 2016-03-14
  sDigestValue: String; // Sandro Silva 2016-03-14
  sXMLConsulta: String; // Sandro Silva 2016-03-16
  sDataXMLRecuperado: String;
  sDataEmitidaXMLRecuperado: String;
  sDataAutorizadaXMLRecuperado: String;
  sValorXMLRecuperado: String;
  sValorTroco: String; // Sandro Silva 2016-07-14
  sValorRecebido: String; // Sandro Silva 2016-07-14
  svNF_W16: String;
  sCSTPISCofins: String; // Sandro Silva 2016-09-30
  sCNPJ_YA05: String; // Sandro Silva 2016-11-22 CNPJ da adminstradora do cartão
  dvPag_YA03_10: Double; // Sandro Silva 2016-08-12
  dvPag_YA03_11: Double; // Sandro Silva 2016-08-12
  dvPag_YA03_12: Double; // Sandro Silva 2016-08-12
  dvPag_YA03_13: Double; // Sandro Silva 2016-08-12
  dvPag_YA03_16: Double; // Sandro Silva 2021-03-05
  dvPag_YA03_17: Double; // Sandro Silva 2021-03-05
  dvPag_YA03_18: Double; // Sandro Silva 2021-03-05
  dvPag_YA03_19: Double; // Sandro Silva 2021-03-05
  dvPag_YA03_20: Double; // Sandro Silva 2024-07-01
  dvPag_YA03_99: Double; // Sandro Silva 2016-08-12
  iTransacaoCartao: Integer; // Sandro Silva 2017-06-15
  iTentaConsulta: Integer; // Sandro Silva 2017-02-02
  bEstaEmContingencia: Boolean; // Sandro Silva 2019-07-24
  sNfeIdSubstituido: String; // Sandro Silva 2019-07-24
  sXmlNFCeSubstituida: String; // Sandro Silva 2019-07-25
  sNfeIdSubstituta: String; // Sandro Silva 2019-07-24
  IBQALTERACA: TIBQuery; // Query com mesma TTransaction de FORM1.IBDATASET27 para ler dados salvos no alteraca pelo FORM1.IBDATASET27 Sandro Silva 2019-08-05
  sStatusServico: String; // Sandro Silva 2019-08-09
  sMensagemAlertaUsoDenegado: String; // Sandro Silva 2020-05-21
  sDadosTransacaoEletronicaNoComplemento: String; // Sandro Silva 2023-03-28
  sNumeroGerencialConvertido: String; // Sandro Silva 2023-07-20
  bDisponibilizarDANFCe: Boolean; // Sandro Silva 2023-12-05
  function EncontraItemDataSet(sItemRejeicao: String): String;
  begin

    Result := '';
    try
      if sItemRejeicao <> '' then
      begin

        sItemRejeicao := LimpaNumero(Copy(sItemRejeicao, 1, Pos('-', sItemRejeicao)));
        Form1.ibDataSet27.First;

        while Form1.ibDataSet27.Eof = False do
        begin

          if ((Form1.ibDataSet27.FieldByName('CODIGO').AsString = sItemRejeicao) and (Length(sItemRejeicao) <=5))
            or ((Form1.ibDataSet27.FieldByName('REFERENCIA').AsString = sItemRejeicao) and (Length(sItemRejeicao) > 5))
            then
          begin
            if (Form1.ibDataSet27.FieldByName('TIPO').AsString = 'BALCAO') or (Form1.ibDataSet27.FieldByName('TIPO').AsString = 'LOKED') then
            begin
              Result := 'Item ' +  FormatFloat('000', StrToIntDef(Form1.ibDataSet27.FieldByName('ITEM').AsString, 0)) + ':';
              Break;
            end;
          end;

          Form1.ibDataSet27.Next;

        end;

      end;
    except
      Result := '';
    end;

  end;

  procedure AddDadosTransacaoEletronicaNoComplemento(Bandeira: String; CodigoAutorizacao: String; Valor: Double);
  begin
    if sDadosTransacaoEletronicaNoComplemento <> '' then
      sDadosTransacaoEletronicaNoComplemento := sDadosTransacaoEletronicaNoComplemento + '|';
    sDadosTransacaoEletronicaNoComplemento := sDadosTransacaoEletronicaNoComplemento + Trim(Bandeira) + ' - ' + Trim(CodigoAutorizacao) + ' - R$' + FormatFloat('0.00', Valor);
  end;
begin
//configuração quando marcada e informado destinatário cadastrado, troca indPres para 04

  //
  // 12:917
  //
  //bButton := -1;
  tInicio := Time;
  Screen.Cursor := crHourGlass;
  Result := False;
  sCNPJ_YA05 := '';
  sLogErroCredenciadoraCartao := ''; // Sandro Silva 2020-10-21
  bDisponibilizarDANFCe := False; // Sandro Silva 2023-12-05
  //
  // 1 - Enviar NFC-e
  {Sandro Silva 2019-08-09 inicio}
  //
  if Form1.NFCeemContingncia1.Checked = False then // Sandro Silva 2019-08-13
  begin
    Form1.ExibePanelMensagem('Aguarde, Consultando a disponibilidade do serviço...', True);
    sStatusServico := _ecf65_ConsultarStatusServico(False);  // _ecf65_EnviarNFCe(
  end;

  if (Form1.UsaIntegradorFiscal() = False)
    and ((AnsiUpperCase(Form1.ibDataSet13.FieldByName('ESTADO').AsString) = 'SC') and PAFNFCe) // Sandro Silva 2020-12-09  and (AnsiUpperCase(Form1.ibDataSet13.FieldByName('ESTADO').AsString) <> 'SC')
    and (AnsiUpperCase(Form1.ibDataSet13.FieldByName('ESTADO').AsString) <> 'SP') then // Sandro Silva 2020-11-11  if (Form1.UsaIntegradorFiscal() = False) and (AnsiUpperCase(Form1.ibDataSet13.FieldByName('ESTADO').AsString) <> 'SC') then // Sandro Silva 2019-10-16
  begin
    if Form1.bStatusECF = False then
    begin

      if Form1.NFCeemContingncia1.Checked = False then
      begin
        Form1.sMotivoContingencia := sStatusServico;
        if Length(Form1.sMotivoContingencia) < 15 then
          Form1.sMotivoContingencia := Form1.sMotivoContingencia + IfThen(Trim(Form1.sMotivoContingencia) = '', '', '. ') + 'Servico indisponivel';
        Form1.sMotivoContingencia := Copy(Form1.sMotivoContingencia, 1, 256);

        Application.MessageBox(PChar('Entrando em modo de contingência.'+chr(10)+'Lembre-se de transmitir as notas quando voltar o serviço.'), 'Modo de Contingência Ativado', MB_ICONWARNING + MB_OK); // Sandro Silva 2020-09-03 Application.MessageBox(PChar('Entrando em modo de contingência.'+chr(10)+'Lembre-se de transmitir as notas quando voltar o serviço.'), 'Modo de Contingência Ativado', MB_ICONWARNING + MB_OK);
        Form1.NFCeemContingncia1.Checked := True;

        //
        //Form1.FormShow(Sender);
        //
        Form1.sStatusECF := 'OPERANDO EM CONTINGÊNCIA';
        //Form1.Display(Form1.sStatusECF,Form1.sF);
      end;

    end;
  end;
  {Sandro Silva 2019-08-09 fim}
  //
  Form1.ExibePanelMensagem('Aguarde, enviando NFC-e...', True);
  //

  IBQALTERACA := CriaIBQuery(Form1.ibDataSet27.Transaction); // Sandro Silva 2019-08-05

  Form1.ibDataset150.Close;
  Form1.ibDataset150.SelectSql.Clear;
  Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF = ' + QuotedStr(FormataNumeroDoCupom(Form1.iCupom)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa));
  Form1.ibDataset150.Open;

  if ((Pos('contingência', AnsiLowerCase(Form1.ibDataset150.FieldByName('STATUS').AsString)) > 0)
    or (Pos('<tpEmis>9</tpEmis>', Form1.ibDataset150.FieldByName('NFEXML').AsString) > 0))
    and (Form1.UsaIntegradorFiscal() = False) // Sandro Silva 2019-10-16
    then
  begin
    if xmlNodeValue(Form1.ibDataset150.FieldByName('NFEXML').AsString, '//ide/dhEmi') <> '' then
    begin
      sDataEmitidaXMLRecuperado := xmlNodeValue(sDataXMLRecuperado, '//ide/dhEmi');
      sDataEmitidaXMLRecuperado := Copy(sDataEmitidaXMLRecuperado, 9, 2) + '/' + Copy(sDataEmitidaXMLRecuperado, 6, 2) + '/' + Copy(sDataEmitidaXMLRecuperado, 1, 4) + ' ' + Copy(sDataEmitidaXMLRecuperado, 12, 8);
      dtEnvio := StrToDateTime(sDataEmitidaXMLRecuperado);
    end
    else
      dtEnvio := StrToDate(FormatDateTime('dd/mm/yyyy', Form1.ibDataset150.FieldByName('DATA').AsDateTime)) + Time
  end
  else
  begin
    dtEnvio := Now; // Sandro Silva 2015-03-30 Manter ALTERACA.DATA = NFCE.DATA
  end;

  bOk     := False;
  wsNFCeAssinada := ''; // 2015-07-23
  fNFe           := ''; // 2015-07-23
  //{Sandro Silva 2019-07-24 inicio
  sValorRecebido := ''; // Sandro Silva 2016-07-14
  sValorTroco    := ''; // Sandro Silva 2016-07-14
  svNF_W16       := ''; // Sandro Silva 2016-07-14
  dvPIS_W13      := 0.00; // Sandro Silva 2016-09-30
  dvCofins_W14   := 0.00; // Sandro Silva 2016-09-30
  dvPIS_Q09      := 0.00; // Sandro Silva 2016-09-30
  dvCOFINS_S11   := 0.00; // Sandro Silva 2016-09-30
  //{Sandro Silva 2019-07-24 fim}

  try
    try
      // Início geração do xml

      //
      Form1.ibDataset99.Close;
      Form1.ibDataset99.SelectSql.Clear;
      Form1.ibDataset99.SelectSQL.Add('select * from MUNICIPIOS where NOME='+QuotedStr(Form1.ibDataSet13.FieldByname('MUNICIPIO').AsString)+' '+' and UF='+QuotedStr(UpperCase(Form1.ibDataSet13.FieldByname('ESTADO').AsString))+' ');
      Form1.ibDataset99.Open;
      //

      // Sandro Silva 2020-10-21  sCNPJ_YA05 := '';

      if Form1.sNomeRede = '' then
      begin
        if Form1.TransacoesCartao.Transacoes.Count > 0 then
        begin
          Form1.sNomeRede := Form1.TransacoesCartao.Transacoes.Items[Form1.TransacoesCartao.Transacoes.Count -1].NomeRede;
        end;
      end;

      Form1.spdNFCeDataSets1.Cancelar;
      Form1.spdNFCeDataSets1.LoteNFCe.Clear;

      Form1.spdNFCeDataSets1.Incluir;         // Inicia a insercao de dados na NFe
      //
      Form1.spdNFCeDataSets1.Campo('cUF_B02').Value    := Copy(Form1.IBDataSet99.FieldByname('CODIGO').AsString,1,2);  //Codigo da UF para o estado SC = '42'
      Form1.spdNFCeDataSets1.Campo('cNF_B03').Value    := '07426598'; // Código Interno do Sistema que está integrando com a NFe // Regra B03-10 Sandro Silva 2019-05-03 Form1.spdNFCeDataSets1.Campo('cNF_B03').Value    := '12345678'; // Código Interno do Sistema que está integrando com a NFe
      Form1.spdNFCeDataSets1.Campo('natOp_B04').Value  := 'VENDA'; // Sandro Silva 2018-03-02 Poder ser venda de produção própria tbm  'VENDA MERC.ADQ.REC.TERC';
      //
      //
      Form1.spdNFCeDataSets1.Campo('mod_B06').Value     := '65'; // Código do Modelo de Documento Fiscal
      Form1.spdNFCeDataSets1.Campo('serie_B07').Value   := _ecf65_SerieAtual(Form1.ibDataSet27.Transaction); // Sandro Silva 2021-11-12 '1';  // Série do Documento - Mudando a série precisa mudar o caixa para não selecionar itens de vendas com mesmo número, mas de outras séries
      Form1.spdNFCeDataSets1.Campo('nNF_B08').Value     := IntToStr(Form1.iCupom); // StrZero(Form1.iCupom,6,0);  // Número da Nota Fiscal
      //
      Form1.spdNFCeDataSets1.Campo('dhEmi_B09').Value   := FormatDateTime('YYYY-mm-dd"T"HH:mm:ss', dtEnvio) + Form1.sFuso; //Data e Hora de emissão do Documento Fiscal

      if (Form1.NFCeemContingncia1.Checked) and (Form1.sMotivoContingencia = NFCE_XJUST_CONTINGENCIA_AUTOMATICA) then
      begin
        if Trim(_ecf65_sDataHoraNFCeSubstituida) <> '' then
          Form1.spdNFCeDataSets1.Campo('dhEmi_B09').Value   := _ecf65_sDataHoraNFCeSubstituida;
      end;

      Form1.spdNFCeDataSets1.Campo('tpNF_B11').Value    := '1'; // Tipo de Documento Fiscal (0-Entrada, 1-Saída)
      //
      // Identificador do local de destino da operação
      //
      Form1.spdNFCeDataSets1.Campo('idDest_B11a').Value := '1'; // Utilize: 1-Operação interna / 2-Operação interestadual / 3-Operação com exterior
      Form1.spdNFCeDataSets1.Campo('cMunFG_B12').Value  := Copy(Form1.ibDAtaSet99.FieldByname('CODIGO').AsString,1,7); // Código da Cidade do Emitente (Tabela do IBGE)
      //
      // Formato do DANFE
      //
      Form1.spdNFCeDataSets1.Campo('tpImp_B21').Value   := '4'; // 0-Sem geração de DANFE; 1-DANFE normal , Retrato; 2-DANFE normal, Paisagem; 3-DANFE Simplificado; 4-DANFE NFC-e; 5-DANFE NFC-e em mensagem eletrônica. Nota: O envio de mensagem eletrônica pode ser feita de forma simultânea com a impressão do DANFE. Usar o tpImp=5 quando esta for a única forma de disponibilização do DANFE.
      //
      // Tipo de Emissão
      //
      Form1.spdNFCeDataSets1.Campo('tpEmis_B22').Value  := TPEMIS_NFCE_NORMAL; // 1- Emissão normal (não em contingência); 2- Contingência FS-IA, com impressão do DANFE em formulário de segurança; 3- Contingência SCAN (Sistema de Contingência do Ambiente Nacional); 4- Contingência DPEC (Declaração Prévia da Emissão em Contingência); 5- Contingência FS-DA, com impressão do DANFE em formulário de segurança; 6- Contingência SVC-AN (SEFAZ Virtual de Contingência do AN); 7- Contingência SVC-RS (SEFAZ Virtual de Contingência do RS); 9- Contingência off-line da NFC-e (as demais opções de contingência são válidas também para a NFC-e); Nota: As opções de contingência 3, 4, 6 e 7 (SCAN, DPEC e SVC) não estão disponíveis no momento atual.
      //
      // Contingência
      //
      if Form1.UsaIntegradorFiscal() = False then // Sandro Silva 2019-10-]16
      begin
        if (Form1.NFCeemContingncia1.Checked) or (Pos(TIPOCONTINGENCIA, Form1.ClienteSmallMobile.sVendaImportando) > 0) then
        begin
          Form1.spdNFCeDataSets1.Campo('tpEmis_B22').Value  := TPEMIS_NFCE_CONTINGENCIA_OFFLINE; // Papel normal Contingência
          Form1.spdNFCeDataSets1.Campo('xJust_B29').Value   := Trim(ConverteAcentos2(Form1.sMotivoContingencia)); // Sandro Silva 2021-06-15 Form1.spdNFCeDataSets1.Campo('xJust_B29').Value   := Form1.sMotivoContingencia;
          Form1.spdNFCeDataSets1.Campo('dhCont_B28').Value  := FormatDateTime('YYYY-mm-dd"T"HH:mm:ss', Now) + Form1.sFuso;
        end;
      end;

      //
      Form1.spdNFCeDataSets1.Campo('cDV_B23').Value     := '3'; // Calcula Automatico - Linha desnecessária já que o componente calcula o Dígito Verificador automaticamente e coloca no devido campo
      //
      if Form1.spdNFCe1.Ambiente = akHomologacao then
      begin
        Form1.spdNFCeDataSets1.Campo('tpAmb_B24').Value := TPAMB_HOMOLOGACAO;  // 1-produção 2-Homologação
      end else
      begin
        Form1.spdNFCeDataSets1.Campo('tpAmb_B24').Value := TPAMB_PRODUCAO;  // 1-produção 2-Homologação
      end;

      // Ficha 4578
      // Grupo Responsável técnico
      _ecf65_IdentificacaoResponsavelTecnico(Form1.spdNFCeDataSets1);

      //
      Form1.spdNFCeDataSets1.Campo('finNFe_B25').Value    := '1'; // Finalidade da NFe (1-Normal, 2-Complementar, 3-de Ajuste)
      Form1.spdNFCeDataSets1.Campo('indFinal_B25a').Value := '1'; // 0-Não/1-Consumidor Final
      Form1.spdNFCeDataSets1.Campo('indPres_B25b').Value  := INDPRES_OPERACAO_PRESENCIAL; // 1-Operação presencial/2-Operação não presencial, pela internet/3- Operação não presencial, Teleatendimento/9- Operação não presencial, outros.
      if Form1.ClienteSmallMobile.ImportandoMobile then // Sandro Silva 2022-08-08 if ImportandoMobile then
      begin
        if Form1.N4001.Checked then
        begin
          // Sandro Silva 2018-02-23 Servidor AM não aceitou o novo indPres 5=Operação presencial, fora do estabelecimento, para venda ambulante
          Form1.spdNFCeDataSets1.Campo('indPres_B25b').Value  := INDPRES_OPERACAO_PRESENCIAL; // 0=Não se aplica (por exemplo, Nota Fiscal complementar ou de ajuste); 1=Operação presencial; 2=Operação não presencial, pela Internet; 3=Operação não presencial, Teleatendimento; 4=NFC-e em operação com entrega a domicílio; 5=Operação presencial, fora do estabelecimento; 9=Operação não presencial, outros.
        end;
      end;
      //
      Form1.spdNFCeDataSets1.Campo('procEmi_B26').Value := '0'; // Identificador do Processo de emissão (0-Emissão da Nfe com Aplicativo do Contribuinte). Ver outras opções no manual da Receita.
      Form1.spdNFCeDataSets1.Campo('verProc_B27').Value := Build;//2015-05-19 '000'; // Versão do Aplicativo Emissor
      //
      //
      // Dados do emitente
      //
      Form1.spdNFCeDataSets1.Campo('CNPJ_C02').Value    := LimpaNumero(Form1.ibDataSet13.FieldByname('CGC').AsString); // CNPJ do Emitente
      Form1.spdNFCeDataSets1.Campo('xNome_C03').Value   := Trim(ConverteAcentosNome(Form1.ibDataSet13.FieldByname('NOME').AsString)); // Razao Social ou Nome do Emitente // Sandro Silva 2023-06-05 Trim(ConverteAcentos2(Form1.ibDataSet13.FieldByname('NOME').AsString)); // Razao Social ou Nome do Emitente
      Form1.spdNFCeDataSets1.Campo('xFant_C04').Value   := Trim(ConverteAcentosNome(Form1.ibDataSet13.FieldByname('NOME').AsString)); // Nome Fantasia do Emitente // Sandro Silva 2023-06-05 Trim(ConverteAcentos2(Form1.ibDataSet13.FieldByname('NOME').AsString)); // Nome Fantasia do Emitente 
      Form1.spdNFCeDataSets1.Campo('xLgr_C06').Value    := Trim(ConverteAcentos2(Endereco_Sem_Numero(Form1.ibDataSet13.FieldByname('ENDERECO').AsString))); // Logradouro do Emitente
      Form1.spdNFCeDataSets1.Campo('nro_C07').Value     := Trim(Numero_Sem_Endereco(Form1.ibDataSet13.FieldByname('ENDERECO').AsString)); // Numero do Logradouro do Emitente
      Form1.spdNFCeDataSets1.Campo('xBairro_C09').Value := Trim(ConverteAcentos2(Form1.ibDataSet13.FieldByname('COMPLE').AsString)); // Bairro do Emitente
      Form1.spdNFCeDataSets1.Campo('cMun_C10').Value    := Copy(Form1.ibDAtaSet99.FieldByname('CODIGO').AsString,1,7); // Código da Cidade do Emitente (Tabela do IBGE)
      Form1.spdNFCeDataSets1.Campo('xMun_C11').Value    := Trim(ConverteAcentos2(Form1.ibDAtaSet99.FieldByname('NOME').AsString)); // Nome da Cidade do Emitente
      Form1.spdNFCeDataSets1.Campo('UF_C12').Value      := Form1.ibDAtaSet99.FieldByname('UF').AsString; // Código do Estado do Emitente (Tabela do IBGE)
      Form1.spdNFCeDataSets1.Campo('CEP_C13').Value     := LimpaNumero(Form1.ibDataSet13.FieldByname('CEP').AsString); // Cep do Emitente
      //
      if Alltrim(ConverteAcentos2(Form1.ibDAtaSet99.FieldByname('NOME').AsString))='' then
      begin
        sLogErro := 'Erro: Verifique o CEP do emitente';
        Exit;
      end;
      //
      Form1.spdNFCeDataSets1.Campo('cPais_C14').Value   := '1058'; // Código do País do Emitente (Tabela BACEN)
      Form1.spdNFCeDataSets1.Campo('xPais_C15').Value   := 'BRASIL'; // Nome do País do Emitente
      //
      Form1.spdNFCeDataSets1.Campo('IE_C17').Value      := LimpaNumero(Form1.ibDataSet13.FieldByname('IE').AsString); // Inscrição Estadual do Emitente
      //
      if LimpaNumero(Form1.ibDataSet13.FieldByname('IM').AsString) <> '' then
      begin
        Form1.spdNFCeDataSets1.Campo('IM_C19').Value    := StrTran(LimpaNumero(Form1.ibDataSet13.FieldByname('IM').AsString),'-',''); // Inscrição Estadual do Emitente
        //
        if AllTrim(Form1.ibDataSet13.FieldByname('CNAE').AsString) <> '' then
        begin
          Form1.spdNFCeDataSets1.Campo('CNAE_C20').Value    := AllTrim(Form1.ibDataSet13.FieldByname('CNAE').AsString); // CNAE
        end else
        begin
          Form1.spdNFCeDataSets1.Campo('CNAE_C20').Value    := '0000000'; // CNAE
        end;
        //
      end;

      Form1.ibDataSet27.Close;
      Form1.ibDataSet27.SelectSQL.Clear;
      Form1.ibDataSet27.SelectSQL.Text :=
        'select A.* ' +
        'from ALTERACA A ' +
        'where A.PEDIDO = ' + QuotedStr(FormataNumeroDoCupom(Form1.icupom)) + // Sandro Silva 2021-11-29 'where A.PEDIDO = ' + QuotedStr(strZero(Form1.icupom,6,0)) +
        ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
        ' and A.CAIXA = ' + QuotedStr(Form1.sCaixa) +
        //' and A.DATA = ' + QuotedStr(FormataDataSQL(dtData)) +
        ' and A.DESCRICAO = ''Acréscimo'' ' +
        ' and coalesce(A.ITEM, '''') = '''' ';
      Form1.ibDataSet27.Open;

      dAcrescimoTotal     := 0.00;
      while Form1.ibDataSet27.Eof = False do
      begin
        dAcrescimoTotal := dAcrescimoTotal + Form1.ibDataSet27.FieldByName('TOTAL').AsFloat;

        Form1.ibDataSet27.Next;
      end;

      // Seleciona os desconto lançados para a venda (tanto nos itens qto no total do cupom)
      Form1.ibDataSet27.Close;
      Form1.ibDataSet27.SelectSQL.Clear;
      Form1.ibDataSet27.SelectSQL.Text :=
        'select A.* ' +
        'from ALTERACA A ' +
        'where A.PEDIDO = ' + QuotedStr(FormataNumeroDoCupom(Form1.icupom)) + // Sandro Silva 2021-11-29 'where A.PEDIDO = ' + QuotedStr(strZero(Form1.icupom,6,0)) +
        ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
        ' and A.CAIXA = ' + QuotedStr(Form1.sCaixa) +
        ' and A.DESCRICAO = ''Desconto'' ';
      Form1.ibDataSet27.Open;

      dDescontoTotalCupom := 0.00; // 2015-12-10
      while Form1.ibDataSet27.Eof = False do
      begin
        dDescontoTotalCupom := dDescontoTotalCupom + Form1.ibDataSet27.FieldByName('TOTAL').AsFloat;

        if (AllTrim(Form1.ibDataSet27.FieldByName('DESCRICAO').AsString) = 'Desconto') and (AllTrim(Form1.ibDataSet27.FieldByName('ITEM').AsString) = '') then
        begin // Corrigir casos que ao entrar em contingência zerou Form1.fDescontoNoTotal, gerando xml com ICMSTot/vDesc zerado e ICMSTot/vNF com valor diferente da soma dos detPag/vPag
          Form1.fDescontoNoTotal := Form1.ibDataSet27.FieldByName('TOTAL').AsFloat * -1;
        end;

        Form1.ibDataSet27.Next;
      end;
      dDescontoTotalCupom := Abs(dDescontoTotalCupom); // 2015-12-10 Desconsidera o sinal negativo, usa o valor absoluto

      //
      Form1.ibDataSet27.Close;
      Form1.ibDataSet27.SelectSQL.Clear;
      Form1.ibDataSet27.SelectSQL.Text :=
        'select * ' +
        'from ALTERACA ' +
        'where CAIXA='+QuotedStr(Form1.sCaixa)+
        ' and PEDIDO='+QuotedStr(FormataNumeroDoCupom(Form1.icupom))+' ' + // Sandro Silva 2021-11-29 ' and PEDIDO='+QuotedStr(StrZero(Form1.icupom,6,0))+' ' +
        ' order by ITEM'; // Sandro Silva 2021-06-08 Ordenar por ITEM para depois no SPED selecionar certo no xml
      Form1.ibDataSet27.Open;
      //
      Form1.ibDataSet27.First;

      dtAlteracaData := Form1.ibDataSet27.FieldByName('DATA').AsDateTime; //  Data da venda, usado para atualizar o número da NFCe em ALTERACA.PEDIDO.

      // Sandro Silva 2019-07-24  sVendedorNome := Form1.ibDataSet27.FieldByName('VENDEDOR').AsString; // 2015-06-09

      if Form1.ClienteSmallMobile.ImportandoMobile then // Sandro Silva 2022-08-08 if ImportandoMobile then
        sPdfMobile := Form1.sAtual + '\mobile\' + StringReplace(Form1.ClienteSmallMobile.sVendaImportando, TIPOMOBILE, '', [rfReplaceAll]) + '.pdf';
      //
      // Identificação do consumidor
      //
      //
      Form1.ibDataSet2.Close;
      Form1.ibDataSet2.SelectSQL.Clear;
      Form1.ibDataSet2.SelectSQL.Add('select * from CLIFOR where NOME='+QuotedStr(Form1.ibDataSet27.FieldByName('CLIFOR').AsString)+' and trim(coalesce(NOME,'''')) <> '''' ');
      Form1.ibDataSet2.Open;

      //
      if (Form1.ibDataSet27.FieldByName('CLIFOR').AsString = Form1.ibDataSet2.FieldByName('NOME').AsString) and (Alltrim(Form1.ibDataSet27.FieldByName('CLIFOR').AsString)<>'') then
      begin

        // Sandro Silva 2021-11-05
        // Começa considerando que não tem dados do destinatário para preencher as tag, preenche após validar se tem Destinatário informado na venda
        Form1.spdNFCeDataSets1.Campo('CNPJ_E02').Value    := ''; // CNPJ do Destinatário
        Form1.spdNFCeDataSets1.Campo('CPF_E03').Value     := ''; // CPF do Destinatário
        Form1.spdNFCeDataSets1.Campo('xNome_E04').Value   := ''; // Razao social ou Nome do Destinatário
        Form1.spdNFCeDataSets1.Campo('xLgr_E06').Value    := ''; // Logradouro do Emitente
        Form1.spdNFCeDataSets1.Campo('nro_E07').Value     := ''; // Numero do Logradouro do Emitente
        Form1.spdNFCeDataSets1.Campo('xBairro_E09').Value := ''; // Bairro do Destinatario
        Form1.spdNFCeDataSets1.Campo('cMun_E10').Value    := ''; // Código do Município do Destinatário (Tabela IBGE)
        Form1.spdNFCeDataSets1.Campo('xMun_E11').Value    := ''; // Nome da Cidade do Destinatário
        Form1.spdNFCeDataSets1.Campo('UF_E12').Value      := ''; // Sigla do Estado do Destinatário
        Form1.spdNFCeDataSets1.Campo('CEP_E13').Value     := ''; // Cep do Destinatário
        Form1.spdNFCeDataSets1.Campo('cPais_E14').Value   := '';   // Código do Pais do Destinatário (Tabela do BACEN)
        Form1.spdNFCeDataSets1.Campo('xPais_E15').Value   := ''; // Nome do País do Destinatário

        if (AllTrim(LimpaNumero(Form1.ibDataSet2.FieldByName('CGC').AsString)) <> '') then
        begin
          //
          if (Length(AllTrim(Form1.ibDataSet2.FieldByName('CGC').AsString)) = 18) then
            Form1.spdNFCeDataSets1.Campo('CNPJ_E02').Value := AllTrim(LimpaNumero(Form1.ibDataSet2.FieldByName('CGC').AsString)); // CNPJ do Destinatário
          if (Length(AllTrim(Form1.ibDataSet2.FieldByName('CGC').AsString)) = 14) then
            Form1.spdNFCeDataSets1.Campo('CPF_E03').Value := AllTrim(LimpaNumero(Form1.ibDataSet2.FieldByName('CGC').AsString)); // CPF do Destinatário

          if Form1.spdNFCe1.Ambiente = akHomologacao then
          begin
            //
            // Ronei - Alteracao feita a pedido de Lucilene - Auditora fiscal do TO
            //
            Form1.spdNFCeDataSets1.Campo('xNome_E04').Value := 'NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL';
            //
          end else
          begin
            //
            // Ronei - Alteracao feita a pedido de Lucilene - Auditora fiscal do TO
            //
            Form1.spdNFCeDataSets1.Campo('xNome_E04').Value := Trim(ConverteAcentosNome(Form1.ibDataSet2.FieldByName('NOME').AsString)); // Sandro Silva 2023-06-05 Trim(ConverteAcentos2(Form1.ibDataSet2.FieldByName('NOME').AsString));
            //
          end;
          //

          if Form1.spdNFCeDataSets1.Campo('UF_C12').Value = Form1.ibDataSet2.FieldByName('ESTADO').AsString then
          begin
            //
            Form1.ibDataset99.Close;
            Form1.ibDataset99.SelectSql.Clear;
            Form1.ibDataset99.SelectSQL.Add('select * from MUNICIPIOS where NOME='+QuotedStr(Form1.ibDataSet2.FieldByName('CIDADE').AsString)+' and UF='+QuotedStr(Form1.ibDataSet2.FieldByName('ESTADO').AsString)+' ');
            Form1.ibDataset99.Open;
            //
            // Quando o consumidor é de fora pega os dados locais
            //
            ////Ficha 5575
            if (Trim(Copy(Form1.ibDAtaSet99.FieldByname('CODIGO').AsString,1,7)) <> '')
              and (Alltrim(ConverteAcentos2(Form1.ibDAtaSet99.FieldByname('NOME').AsString)) <> '') then
            begin
              Form1.spdNFCeDataSets1.Campo('xLgr_E06').Value    := Trim(ConverteAcentos2(Endereco_Sem_Numero(Form1.ibDAtaset2.FieldByname('ENDERE').AsString))); // Logradouro do Emitente
              Form1.spdNFCeDataSets1.Campo('nro_E07').Value     := Numero_Sem_Endereco(Form1.ibDAtaset2.FieldByname('ENDERE').AsString); // Numero do Logradouro do Emitente
              Form1.spdNFCeDataSets1.Campo('xBairro_E09').Value := Alltrim(ConverteAcentos2(Form1.ibDAtaset2.FieldByname('COMPLE').AsString)); // Bairro do Destinatario
              Form1.spdNFCeDataSets1.Campo('cMun_E10').Value    := Copy(Form1.ibDAtaSet99.FieldByname('CODIGO').AsString,1,7); // Código do Município do Destinatário (Tabela IBGE)
              Form1.spdNFCeDataSets1.Campo('xMun_E11').Value    := Alltrim(ConverteAcentos2(Form1.ibDAtaSet99.FieldByname('NOME').AsString)); // Nome da Cidade do Destinatário
              Form1.spdNFCeDataSets1.Campo('UF_E12').Value      := Form1.ibDAtaSet99.FieldByname('UF').AsString; // Sigla do Estado do Destinatário
              Form1.spdNFCeDataSets1.Campo('CEP_E13').Value     := LimpaNumero(Form1.ibDataSet2.FieldByname('CEP').AsString); // Cep do Destinatário
              Form1.spdNFCeDataSets1.Campo('cPais_E14').Value   := '1058';   // Código do Pais do Destinatário (Tabela do BACEN)
              Form1.spdNFCeDataSets1.Campo('xPais_E15').Value   := 'BRASIL'; // Nome do País do Destinatário
            end;

            // Aqui identificar se marcou bEntregaDomicilio
            // gerar tags de transportador
            // mudar indPres para 4
            // ajustar na função que corrige xml _ecf65_GeraXmlCorrigindoDados()
            // Tags transporte
            // modFrete_X02=0
            // CNPJ_X04 (ou CPF_X05)
            // xNome_X06
            // IE_X07
            // xEnder_X08
            // xMun_X09
            // UF_X10
            if TipoEntrega.Domicilio then // Sandro Silva 2020-06-01
            begin
              //muda indPres para 4-entrega a domicílio
              Form1.spdNFCeDataSets1.Campo('indPres_B25b').Value  := '4'; // 4=NFC-e em operação com entrega a domicílio;
              // Tags transporte
              Form1.spdNFCeDataSets1.Campo('CNPJ_X04').Value   := Form1.spdNFCeDataSets1.Campo('CNPJ_C02').Value;
              Form1.spdNFCeDataSets1.Campo('xNome_X06').Value  := Form1.spdNFCeDataSets1.Campo('xNome_C03').Value;
              Form1.spdNFCeDataSets1.Campo('IE_X07').Value     := Form1.spdNFCeDataSets1.Campo('IE_C17').Value;
              Form1.spdNFCeDataSets1.Campo('xEnder_X08').Value := Form1.spdNFCeDataSets1.Campo('xLgr_C06').Value + ' ' + Form1.spdNFCeDataSets1.Campo('nro_C07').Value;
              Form1.spdNFCeDataSets1.Campo('xMun_X09').Value   := Form1.spdNFCeDataSets1.Campo('xMun_C11').Value;
              Form1.spdNFCeDataSets1.Campo('UF_X10').Value     := Form1.spdNFCeDataSets1.Campo('UF_C12').Value;
            end;
            //
          end;
        end; // if AllTrim(LimpaNumero(Form1.ibDataSet2.FieldByName('CGC').AsString)) <> '' then
        //
        if AllTrim(Form2.Edit10.Text)='' then
          Form2.Edit10.Text := AllTrim(Form1.ibDataSet2.FieldByname('EMAIL').AsString);
        //
      end else
      begin
        if (LimpaNumero(Form2.Edit2.Text) <> '') then // CPF/CNPJ preenchido // Sandro Silva 2018-03-13  if (AllTrim(Form2.Edit2.Text) <> '') then // CPF/CNPJ preenchido
        begin

          {Sandro Silva 2021-11-05 inicio}
          if (Length(AllTrim(Form2.Edit2.Text)) = 18) then
            Form1.spdNFCeDataSets1.Campo('CNPJ_E02').Value := AllTrim(LimpaNumero(Form2.Edit2.Text)); // CNPJ do Destinatário
          if (Length(AllTrim(Form2.Edit2.Text)) = 14) then
            Form1.spdNFCeDataSets1.Campo('CPF_E03').Value  := AllTrim(LimpaNumero(Form2.Edit2.Text)); // CPF do Destinatário
          {Sandro Silva 2021-11-05 fim}

          //
          // Problema no TO Ronei
          //
          if Form1.spdNFCe1.Ambiente = akHomologacao then
          begin
            //
            Form1.spdNFCeDataSets1.Campo('xNome_E04').Value := 'NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL';
            //
          end else
          begin
            //
            if AllTrim(Form2.Edit8.Text)<>'' then
              Form1.spdNFCeDataSets1.Campo('xNome_E04').Value := Trim(ConverteAcentosNome(Trim(Form2.Edit8.Text))); // Sandro Silva 2023-06-05 Trim(ConverteAcentos2(AllTrim(Form2.Edit8.Text))); //  Sandro Silva 2018-10-31  AllTrim(Form2.Edit8.Text); // else Form1.spdNFCeDataSets1.Campo('xNome_E04').Value := 'VENDA A CONSUMIDOR'; // Razao social ou Nome do Destinatário
            //
          end;
          //
        end;
      end;

      {Sandro Silva 2021-02-05 inicio }//  Ficha 5268
      if Pos('|' + Form1.spdNFCeDataSets1.Campo('indPres_B25b').Value + '|', '|1|4|') > 0 then // Sandro Silva 2022-04-06 if Pos('|' + Form1.spdNFCeDataSets1.Campo('indPres_B25b').Value + '|', '|1|2|3|4|9|') > 0 then
      begin
        // 1=Operação presencial; 2=Operação não presencial, pela Internet; 3=Operação não presencial, Teleatendimento; 4=NFC-e em operação com entrega a domicílio; ou 9=Operação não presencial, outros.
        //if ((Form1.spdNFCe1.Ambiente = akHomologacao) and (Date >= StrToDate('01/03/2021')))
        //  or ((Form1.spdNFCe1.Ambiente = akProducao) and (Date >= StrToDate('01/09/2021')))
        {Sandro Silva 2022-04-05 inicio
        if LerParametroIni(FRENTE_INI, SECAO_65, 'indIntermed', 'Não') = 'Sim' then
          Form1.spdNFCeDataSets1.Campo('IndIntermed_B25c').Value := '0'; // 0=Operação sem intermediador (em site ou plataforma própria)
        }
        if LerParametroIni(FRENTE_INI, SECAO_65, 'indIntermed', 'Não') = 'Sim' then
        begin
          Form1.spdNFCeDataSets1.Campo('IndIntermed_B25c').Value := '0'; // 0=Operação sem intermediador (em site ou plataforma própria)
          if Form1.ibDataSet27.FieldByName('MARKETPLACE').AsString <> '' then
          begin
            try
              //
              // Seleciona dados do Intermediador (Marketplace)
              Form1.ibDataset99.Close;
              Form1.ibDataset99.SelectSql.Clear;
              Form1.ibDataset99.Selectsql.Add(SelectMarketplace(Form1.ibDataSet27.FieldByName('MARKETPLACE').AsString));
              Form1.ibDataset99.Open;
              //
              if Form1.ibDataSet27.FieldByName('MARKETPLACE').AsString = Form1.ibDataset99.FieldByname('NOME').AsString then
              begin
                if Length(LimpaNumero(Form1.ibDataset99.FieldByname('CGC').AsString)) = 14 then // Não pode ser CPF
                begin
                  //
                  Form1.spdNFCeDataSets1.Campo('indIntermed_B25c').Value  := '1';  // Indicador de intermediador/marketplace E B01 N 0-1 1 0=Operação sem intermediador (em site ou plataforma própria) 1=Operação em site ou plataforma de terceiros (intermediadores/marketplace)
                  Form1.spdNFCeDataSets1.Campo('CNPJ_YB02').Value         := LimpaNumero(Form1.ibDataset99.FieldByname('CGC').AsString);  // CNPJ do Intermediador da Transação (agenciador, plataforma de delivery, marketplace e similar) de serviços e de negócios.
                  Form1.spdNFCeDataSets1.Campo('idCadIntTran_YB03').Value := ConverteAcentos2(Form1.ibDataSet13.FieldByname('NOME').AsString); // Identificador cadastrado no intermediador
                  if Trim(RetornaValorDaTagNoCampo('idCadIntTran', Form1.ibDataset99.FieldByname('OBS').AsString)) <> '' then
                  begin
                    Form1.spdNFCeDataSets1.Campo('idCadIntTran_YB03').Value := Trim(RetornaValorDaTagNoCampo('idCadIntTran', Form1.ibDataset99.FieldByname('OBS').AsString)); // Identificador cadastrado no intermediador
                  end;
                  //
                end;
              end;
              //
            except
              on E: Exception do
              begin
                Form1.spdNFCeDataSets1.Campo('indIntermed_B25c').Value  := '0';  // Indicador de intermediador/marketplace E B01 N 0-1 1 0=Operação sem intermediador (em site ou plataforma própria) 1=Operação em site ou plataforma de terceiros (intermediadores/marketplace)
                Form1.spdNFCeDataSets1.Campo('CNPJ_YB02').Value         := '';  // CNPJ do Intermediador da Transação (agenciador, plataforma de delivery, marketplace e similar) de serviços e de negócios.
                Form1.spdNFCeDataSets1.Campo('idCadIntTran_YB03').Value := ''; // Identificador cadastrado no intermediador
              end;
            end;
          end;
        end;
        {Sandro Silva 2022-04-05 fim}

      end;
      {Sandro Silva 2021-02-05 fim}

      //
      // Apenas configuração para servidor versão 3.10. O servidor 3.00 foi desativado
      Form1.spdNFCeDataSets1.Campo('indIEDest_E16a').Value  := '9';        // Não Contribuinte
      Form1.spdNFCeDataSets1.Campo('IE_E17').Value          := '';         // Form1.spdNFCeDataSets1.Campo('IE_E17').GeraTagVazia   := True;

      _ecf65_AdicionaCNPJCOntabilidade(Form1.spdNFCeDataSets1); // Sandro Silva 2020-09-01

      //
      fTotalTributos        := 0;
      fValorProdutos        := 0;
      fDesconto             := 0;
      rBaseICMS             := 0;
      rValorICMS            := 0;
      I                     := 0;
      dvOutro_W15           := 0; //2015-12-10
      dvServ_W18            := 0; //2015-12-10
      dvBC_W19              := 0; //2015-12-10
      dvISS_W20             := 0; //2015-12-10
      dvFCP_W04h            := 0; // Sandro Silva 2018-02-19
      dvICMSDeson_W04a      := 0.00; // Sandro Silva 2019-08-29
      dvICMSMonoRet_N45Total := 0.00; // Sandro Silva 2023-05-19
      dqBCMonoRet_N43aTotal  := 0.00; // Sandro Silva 2023-09-04
      sMensagemIcmMonofasicoSobreCombustiveis := ''; // Sandro Silva 2023-09-05      
      //
      // TOTAL Sem o Desconto
      //
      IBQALTERACA.Close;
      IBQALTERACA.Sql.Clear;
      IBQALTERACA.SQL.Text :=
        'select sum(cast(TOTAL as numeric(18,2))) as TOT ' +
        'from ALTERACA ' +
        // Sandro Silva 2021-11-29 'where PEDIDO='+QuotedStr(strZero(Form1.icupom,6,0))+' and CAIXA = ' + QuotedStr(Form1.sCaixa) + ' and DESCRICAO <> ''<CANCELADO>'' and TIPO <> ''KOLNAC'' and Coalesce(ITEM,''XX'') <> ''XX'' '; // Não somar item cancelado. Dead lock mantem item com TIPO=KOLNAC até que seja destravado e processaDo o cancelamento
        'where PEDIDO='+QuotedStr(FormataNumeroDoCupom(Form1.icupom))+' and CAIXA = ' + QuotedStr(Form1.sCaixa) + ' and DESCRICAO <> ''<CANCELADO>'' and TIPO <> ''KOLNAC'' and Coalesce(ITEM,''XX'') <> ''XX'' '; // Não somar item cancelado. Dead lock mantem item com TIPO=KOLNAC até que seja destravado e processaDo o cancelamento
        //+
      IBQALTERACA.Open;

      fTotalSemDesconto := IBQALTERACA.FieldByname('TOT').AsFloat;
      {Sandro Silva 2019-08-05 fim}

      _ecf65_RateioAcrescimo(fTotalSemDesconto, dAcrescimoTotal, Form1.icupom, Form1.sCaixa); // 2016-01-08
      _ecf65_RateioDesconto(fTotalSemDesconto, Form1.fDescontoNoTotal, Form1.icupom, Form1.sCaixa); // 2016-01-08

      sLogErroItens := ''; // Sandro Silva 2017-08-15
      //
      // Início Gerando Itens
      //
      while not Form1.ibDataSet27.Eof do
      begin
        //
        Form1.ibDataSet4.Close;
        Form1.ibDataSet4.SelectSQL.Clear;
        Form1.ibDataSet4.SelectSQL.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form1.ibDataSet27.FieldByName('CODIGO').AsString)+' ');  //
        Form1.ibDataSet4.Open;

        // Atualiza o nome do vendedor no alteraca
        Form1.ibDataSet27.Edit;
        Form1.ibDataSet27.FieldByName('VENDEDOR').AsString := Form1.sVendedor;

        // Deixa todos itens com mesma data da nota na tabela NFCE
        if Form1.ibDataSet27.FieldByName('DATA').AsDateTime <> dtEnvio then
          Form1.ibDataSet27.FieldByName('DATA').AsDateTime := dtEnvio;

        //
        if (Form1.ibDataSet27.FieldByName('TIPO').AsString = 'BALCAO') or (Form1.ibDataSet27.FieldByName('TIPO').AsString = 'LOKED') then // Apenas os itens não cancelados Sandro Silva 2018-12-19
        begin

          if (Alltrim(Form1.ibDataSet4.FieldByName('CODIGO').AsString) = Alltrim(Form1.ibDAtaSet27.FieldByName('CODIGO').AsString)) and (Alltrim(Form1.ibDataSet4.FieldByName('CODIGO').AsString) <> '') then // Ficha 4352. Descrição pode ser alterada durante a venda
          begin
            //
            Form1.spdNFCeDataSets1.IncluirItem;
            I := I + 1;
            //
            // Informações Referentes aos ITens da NFe
            //
            Form1.spdNFCeDataSets1.Campo('nItem_H02').Value := IntToStr(I); // Número do Item da NFe (1 até 990)
            //
            // Dados do Produto Vendido
            //
            //Ficha 5190
            if (RetornaValorDaTagNoCampo('cProd', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '') then //
              Form1.spdNFCeDataSets1.Campo('cProd_I02').Value    := Copy(RetornaValorDaTagNoCampo('cProd', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 1, 60)
            else
              if _ecf65_ValidaGtinNFCe(Form1.ibDataSet4.FieldByname('REFERENCIA').AsString) then
                Form1.spdNFCeDataSets1.Campo('cProd_I02').Value    := Form1.ibDataSet4.FieldByname('CODIGO').AsString //Código do PRoduto ou Serviço
              else
                //Form1.spdNFCeDataSets1.Campo('cProd_I02').Value   := LimpaNumero(Form1.ibDataSet4.FieldByname('REFERENCIA').AsString); // Código de BARRAS
                if Length(Alltrim(LimpaNumero(Form1.ibDataSet4.FieldByname('REFERENCIA').AsString))) < 6 then
                  Form1.spdNFCeDataSets1.Campo('cProd_I02').Value    := Form1.ibDataSet4.FieldByname('CODIGO').AsString //Código do PRoduto ou Serviço
                else
                  Form1.spdNFCeDataSets1.Campo('cProd_I02').Value   := LimpaNumero(Form1.ibDataSet4.FieldByname('REFERENCIA').AsString); // Código de BARRAS

            Form1.spdNFCeDataSets1.Campo('cEAN_I03').Value := 'SEM GTIN'; // EAN do Produto
            if _ecf65_ValidaGtinNFCe(Form1.ibDataSet4.FieldByname('REFERENCIA').AsString) then // Ficha 4676 Sandro Silva 2019-06-11 if ValidaEAN13(LimpaNumero(Form1.ibDataSet4.FieldByname('REFERENCIA').AsString)) then
              Form1.spdNFCeDataSets1.Campo('cEAN_I03').Value := LimpaNumero(Form1.ibDataSet4.FieldByname('REFERENCIA').AsString); // EAN do Produto

            //
            //2015-09-21 NT 2015/002 É obrigatório o primeiro item ter a descrição:
            // "NOTA FISCAL EMITIDA EM AMBIENTE DE HOMOLOGAÇÃO - SEM VALOR FISCAL"
            // Rejeição 373 - Descrição do primeiro item diferente da NOTA FISCAL EMITIDA EM AMBIENTE DE HOMOLOGAÇÃO - SEM VALOR FISCAL.
            if (Form1.spdNFCe1.Ambiente = akHomologacao) and (I = 1) then
            begin
              Form1.spdNFCeDataSets1.Campo('xProd_I04').Value  := ConverteAcentos2('NOTA FISCAL EMITIDA EM AMBIENTE DE HOMOLOGAÇÃO - SEM VALOR FISCAL');
            end
            else
            begin
              Form1.spdNFCeDataSets1.Campo('xProd_I04').Value  := Alltrim(ConverteAcentos2(Form1.ibDataSet4.FieldByname('DESCRICAO').AsString));// Descrição do PRoduto
            end;
            // Ficha 4496
            if (AnsiContainsText(Form1.sConcomitante, 'MESA') = False) then  // Ficha 4496 Não passar para xml dados da Observação o item quando estiver usando mesas. Desnecessário e usa mais papel para impressão
            begin
              if Trim(Form1.ibDataSet27.FieldByName('OBS').AsString) <> '' then
                Form1.spdNFCeDataSets1.Campo('infAdProd_V01').AsString := Alltrim(ConverteAcentos2(Form1.ibDataSet27.FieldByName('OBS').AsString));
            end;

            Form1.spdNFCeDataSets1.Campo('NCM_I05').Value   := Alltrim(LimpaNumero(Form1.ibDataSet4.FieldByname('CF').AsString)); // Código do NCM - informar de acordo com o Tabela oficial do NCM

            if (Form1.ibDataSet4.FieldByName('TIPO_ITEM').AsString = '09') then // Serviço
              Form1.spdNFCeDataSets1.Campo('NCM_I05').Value := '00';

            if Alltrim(LimpaNumero(Form1.ibDataSet4.FieldByname('CEST').AsString)) <> '' then
              Form1.spdNFCeDataSets1.Campo('CEST_I05c').Value := Alltrim(LimpaNumero(Form1.ibDataSet4.FieldByname('CEST').AsString)); // Código Especificador da Substituição Tributária – CEST, que estabelece a sistemática de uniformização e identificação das mercadorias e bens passíveis de sujeição aos regimes de substituição tributária e de antecipação de recolhimento do ICMS
            //

            {Sandro Silva 2023-11-09 inicio
            if LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString) <> '1' then // Ficha 4154
            begin
              if (RetornaValorDaTagNoCampo('cBenef', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '') then
                Form1.spdNFCeDataSets1.Campo('cBenef_I05f').Value := Trim(RetornaValorDaTagNoCampo('cBenef', Form1.ibDataSet4.FieldByname('TAGS_').AsString));

            end;
            }
            if (RetornaValorDaTagNoCampo('cBenef', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '') then
              Form1.spdNFCeDataSets1.Campo('cBenef_I05f').Value := Trim(RetornaValorDaTagNoCampo('cBenef', Form1.ibDataSet4.FieldByname('TAGS_').AsString));
            {Sandro Silva 2023-11-09 fim}

            if Alltrim(LimpaNumero(Form1.ibDataSet4.FieldByname('CFOP').AsString)) = '' then
            begin
              if (Form1.ibDataSet4.FieldByName('TIPO_ITEM').AsString = '09') then // Serviço
                Form1.spdNFCeDataSets1.Campo('CFOP_I08').Value  := '5933' // CFOP para serviço
              else
                Form1.spdNFCeDataSets1.Campo('CFOP_I08').Value  := '5102'; // CFOP
            end else
            begin
              Form1.spdNFCeDataSets1.Campo('CFOP_I08').Value  := Alltrim(LimpaNumero(Form1.ibDataSet4.FieldByname('CFOP').AsString)); // CFOP
            end;

            if (Form1.spdNFCeDataSets1.Campo('CFOP_I08').Value = '5656') // Venda de combustível ou lubrificante adquirido ou recebido de terceiros destinado a consumidor ou usuário final
              or (Form1.spdNFCeDataSets1.Campo('CFOP_I08').Value = '5667') // Venda de combustível ou lubrificante a consumidor ou usuário final estabelecido em outra UF
              or (RetornaValorDaTagNoCampo('cProdANP', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '')// Sandro Silva 2018-04-06  or (Alltrim(Form1.ibDataSet4.FieldByname('LIVRE1').AsString) <> '') // Sandro Silva 2018-02-19
            then
            begin
              // versão 4.0
              Form1.spdNFCeDataSets1.Campo('cProdANP_LA02').Value := RetornaValorDaTagNoCampo('cProdANP', Form1.ibDataSet4.FieldByname('TAGS_').AsString);// cProdANP Código de produto da ANP Sandro Silva 2018-04-06
              if Form1.spdNFCeDataSets1.Campo('cProdANP_LA02').Value = '' then
                sLogErroItens := sLogErroItens + 'Erro: LA01 ' + Chr(10) + 'Rejeição: cProdANP não informado no grupo LA Combustível. Verifique no cadastro do produto, campo Aplicação, a tag <cProdANP></cProdANP> '
                  + Form1.spdNFCeDataSets1.Campo('cProd_I02').Value + ' ' + Form1.spdNFCeDataSets1.Campo('xProd_I04').Value + Chr(10) + 'Ex.: Para o gás de cozinha o preenchimento seria <cProdANP>210203001</cProdANP>' + Chr(10); // Sandro Silva 2017-08-16  +chr(10)+'Leia atentamente a mensagem acima e tente resolver o problema.'+chr(10)+'Considere pedir ajuda ao seu contador para o preenchimento correto da NFC-e.';

              if RetornaValorDaTagNoCampo('descANP', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '' then
                Form1.spdNFCeDataSets1.Campo('descANP_LA03').Value  := RetornaValorDaTagNoCampo('descANP', Form1.ibDataSet4.FieldByname('TAGS_').AsString) // Utilizar a descrição de produtos do Sistema de Informações de Movimentação de Produtos - SIMP
              else
                sLogErroItens := sLogErroItens + 'Erro: LA01 ' + Chr(10) + 'Rejeição: descANP não informado no grupo LA Combustível. Verifique no cadastro do produto, campo Aplicação, a tag <descANP></descANP> '
                  + Form1.spdNFCeDataSets1.Campo('cProd_I02').Value + ' ' + Form1.spdNFCeDataSets1.Campo('xProd_I04').Value + Chr(10) + 'Ex.: Para o gás de cozinha o preenchimento seria <descANP>GLP</descANP>' + Chr(10); // Sandro Silva 2017-08-16  +chr(10)+'Leia atentamente a mensagem acima e tente resolver o problema.'+chr(10)+'Considere pedir ajuda ao seu contador para o preenchimento correto da NFC-e.';

              if (Form1.spdNFCeDataSets1.Campo('cProdANP_LA02').Value = '210203001') then
              begin
                Form1.spdNFCeDataSets1.Campo('pGLP_LA03a').Value := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('pGLP', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0), 4);  // Percentual do GLP derivado do petróleo no produto GLP (cProdANP=210203001) E LA01 N 0-1 3v4 Informar em número decimal o percentual do GLP derivado de petróleo no produto GLP. Valores de 0 a 100.
                Form1.spdNFCeDataSets1.Campo('pGNn_LA03b').Value := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('pGNn', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0), 4);  // Percentual de Gás Natural Nacional – GLGNn para o produto GLP (cProdANP=210203001) E LA01 N 0-1 3v4 Informar em número decimal o percentual do Gás Natural Nacional – GLGNn para o produto GLP. Valores de 0 a 100.
                Form1.spdNFCeDataSets1.Campo('pGNi_LA03c').Value := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('pGNi', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0), 4);  // Percentual de Gás Natural Importado – GLGNi para o produto GLP (cProdANP=210203001) E LA01 N 0-1 3v4 Informar em número decimal o percentual do Gás Natural Importado – GLGNi para o produto GLP. Valores de 0 a 100.

                try
                  if (Form1.spdNFCeDataSets1.Campo('pGLP_LA03a').Value + Form1.spdNFCeDataSets1.Campo('pGNn_LA03b').Value + Form1.spdNFCeDataSets1.Campo('pGNi_LA03c').Value) <> '' then // Se campos estão preenchidos
                  begin
                    if (StrToFloatDef(RetornaValorDaTagNoCampo('pGLP', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0)
                      + StrToFloatDef(RetornaValorDaTagNoCampo('pGNn', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0)
                      + StrToFloatDef(RetornaValorDaTagNoCampo('pGNi', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0)) <> 100 then
                    begin
                        sLogErroItens := sLogErroItens
                          + 'Erro: LA01 grupo LA Combustível (pGLP + pGNn + pGNi) = ' + FormatFloat('0.00##', StrToFloatDef(RetornaValorDaTagNoCampo('pGLP', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0) + StrToFloatDef(RetornaValorDaTagNoCampo('pGNn', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0) + StrToFloatDef(RetornaValorDaTagNoCampo('pGNi', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0))
                          + Chr(10) + 'Rejeição: Somatório percentuais de GLP derivado do petróleo, pGLP(id:LA03a) e pGNn(id:LA03b) e pGNi(id:LA03c) diferente de 100.'
                          + Chr(10) + 'Verifique no cadastro do produto, campo Aplicação, o percentual nas tags <pGLP>??,??</pGLP>, <pGNn>??,??</pGNn>, <pGNi>??,??</pGNi> '
                          + Chr(10) + Form1.spdNFCeDataSets1.Campo('cProd_I02').Value + ' ' + Form1.spdNFCeDataSets1.Campo('xProd_I04').Value
                          + Chr(10) + 'Ex.: <pGLP>10,00</pGLP> <pGNn>30,00</pGNn> <pGNi>60,00</pGNi> a soma das tags (10,00 + 30,00 + 60,00) é igual a 100,00)' + Chr(10);
                    end;
                  end;
                except

                end;

                if RetornaValorDaTagNoCampo('vPart', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '' then
                  Form1.spdNFCeDataSets1.Campo('vPart_LA03d').Value := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('vPart', Form1.ibDataSet4.FieldByname('OBS').AsString), 0));
              end;

              Form1.spdNFCeDataSets1.Campo('UFCons_LA06').Value   := Trim(Form1.ibDAtaSet99.FieldByname('UF').AsString); // UFCons Sigla da UF de consumo
            end;

            if Form1.ibDataSet27.FieldByname('CFOP').Value <> Form1.spdNFCeDataSets1.Campo('CFOP_I08').Value then
            begin
              Form1.ibDataSet27.Edit;
              Form1.ibDataSet27.FieldByname('CFOP').Value := Form1.spdNFCeDataSets1.Campo('CFOP_I08').Value;
            end;
            //
            if Alltrim(ConverteAcentos2(Form1.ibDataSet4.FieldByname('MEDIDA').AsString)) <> '' then
              Form1.spdNFCeDataSets1.Campo('uCom_I09').Value   := ConverteAcentos2(Form1.ibDataSet4.FieldByname('MEDIDA').AsString) // Unidade de Medida do Item
            else
              Form1.spdNFCeDataSets1.Campo('uCom_I09').Value   := 'UND';
            //
            if Frac(Form1.ibDataSet27.FieldByname('QUANTIDADE').AsFloat) = 0 then
              Form1.spdNFCeDataSets1.Campo('qCom_I10').Value   := FormatFloatXML(Form1.ibDataSet27.FieldByname('QUANTIDADE').AsFloat, 0) // Quantidade Comercializada do Item
            else
              if Trim(Form1.ConfCasas) <> '' then
                Form1.spdNFCeDataSets1.Campo('qCom_I10').Value   := FormatFloatXML(Form1.ibDataSet27.FieldByname('QUANTIDADE').AsFloat, StrToIntDef(Trim(Form1.ConfCasas), 3)) // Quantidade Comercializada do Item
              else
                Form1.spdNFCeDataSets1.Campo('qCom_I10').Value   := FormatFloatXML(Form1.ibDataSet27.FieldByname('QUANTIDADE').AsFloat, 3); // Quantidade Comercializada do Item

            if Trim(Form1.ConfPreco) <> '' then
              Form1.spdNFCeDataSets1.Campo('vUnCom_I10a').Value  := FormatFloatXML(Form1.ibDataSet27.FieldByname('UNITARIO').AsFloat, StrToIntDef(Trim(Form1.ConfPreco), 3)) // Valor Comercializado do Item
            else
              Form1.spdNFCeDataSets1.Campo('vUnCom_I10a').Value  := FormatFloatXML(Form1.ibDataSet27.FieldByname('UNITARIO').AsFloat, 3); // Valor Comercializado do Item

            dvProd_I11 := StrToFloatDef(FormatFloat('##0.00', Form1.ibDataSet27.FieldByname('TOTAL').AsFloat), 0); // Formata o total com 2 casas para usar no restante da rotina

            Form1.spdNFCeDataSets1.Campo('vProd_I11').Value    := FormatFloatXML(dvProd_I11); // Valor Total Bruto do Item
            //
            // Desconto no item
            //
            IBQALTERACA.Close;
            IBQALTERACA.Sql.Clear;
            IBQALTERACA.SQL.Text := 'select sum(cast(TOTAL as numeric(18,2))) from ALTERACA where PEDIDO='+QuotedStr(FormataNumeroDoCupom(Form1.icupom))+' and CAIXA='+quotedStr(Form1.sCaixa)+' and ITEM='+QuotedStr(Form1.ibDataSet27ITEM.AsString)+ 'and DESCRICAO=''Desconto'''; // Sandro Silva 2021-11-29 IBQALTERACA.SQL.Text := 'select sum(cast(TOTAL as numeric(18,2))) from ALTERACA where PEDIDO='+QuotedStr(strZero(Form1.icupom,6,0))+' and CAIXA='+quotedStr(Form1.sCaixa)+' and ITEM='+QuotedStr(Form1.ibDataSet27ITEM.AsString)+ 'and DESCRICAO=''Desconto''';
            IBQALTERACA.Open;
            //
            fDescontoDoItem := 0.00;
            if (IBQALTERACA.FieldByname('SUM').AsFloat * -1) > 0.00 then
              fDescontoDoItem := (IBQALTERACA.FieldByname('SUM').AsFloat * -1);
            //
            //Unit2 aplica *-1 que converte valor positivo do acréscimo em negativo
            if Form1.fDescontoNoTotal > 0 then
            begin
              fDescontoTotalRateado := StrToFloat(StrZero((Form1.fDescontoNoTotal / (fTotalSemDesconto) * (dvProd_I11-fDescontoDoItem)), 0, 2)); // REGRA DE TRÊS rateando o valor do Desconto
            end
            else
            begin
              fDescontoTotalRateado := 0; // 2015-12-07
            end;
            //
            fDescontoTotalRateado := fDescontoTotalRateado + fDescontoDoItem;

            if dDescontoTotalCupom < (fDesconto + fDescontoTotalRateado) then // 2015-12-10  Corrige a diferença entre soma do rateio do desconto e o valor total do desconto do cupom
              fDescontoTotalRateado := fDescontoTotalRateado + (dDescontoTotalCupom - (fDesconto + fDescontoTotalRateado));

            dvDesc_I17 := 0;
            if (Length(aDescontoItem) > 0) then
            begin
              if (FormatFloatXML(aDescontoItem[I - 1]) <> '0.00') then
              begin
                dvDesc_I17 := aDescontoItem[I - 1];
              end
            end;
            dvDesc_I17 := dvDesc_I17 + fDescontoDoItem;
            if (dvDesc_I17 > 0) then
            begin
              Form1.spdNFCeDataSets1.Campo('vDesc_I17').Value := FormatFloatXML(dvDesc_I17); // Desconto no ítem
            end;
            fDesconto := fDesconto + dvDesc_I17; // Valor Total de Desconto

            dRateioAcrescimoItem := 0.00;
            if Length(aAcrescimoItem) > 0 then
            begin
              if aAcrescimoItem[I - 1] > 0 then
              begin
                dRateioAcrescimoItem := aAcrescimoItem[I - 1];
                // Sandro Silva 2017-04-25  Form1.spdNFCeDataSets1.Campo('vOutro_I17a').Value := FormatFloatXML(aAcrescimoItem[I - 1]); // Acréscimo rateado no item
                Form1.spdNFCeDataSets1.Campo('vOutro_I17a').Value := FormatFloatXML(dRateioAcrescimoItem); // Acréscimo rateado no item
              end;
            end;
            dvOutro_W15 := dvOutro_W15 + dRateioAcrescimoItem; // Sandro Silva 2017-04-26
            //
            // tem cEanTrib válido configurado
            Form1.spdNFCeDataSets1.Campo('cEANTrib_I12').Value := 'SEM GTIN'; // EAN do Produto
            if (RetornaValorDaTagNoCampo('cEANTrib', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '') and (_ecf65_ValidaGtinNFCe(RetornaValorDaTagNoCampo('cEANTrib', Form1.ibDataSet4.FieldByname('TAGS_').AsString))) then // Ficha  4796
              Form1.spdNFCeDataSets1.Campo('cEANTrib_I12').Value := RetornaValorDaTagNoCampo('cEANTrib', Form1.ibDataSet4.FieldByname('TAGS_').AsString)
            else
              if _ecf65_ValidaGtinNFCe(Form1.ibDataSet4.FieldByname('REFERENCIA').AsString) then // Ficha 4676 Sandro Silva 2019-06-11 if ValidaEAN13(LimpaNumero(Form1.ibDataSet4.FieldByname('REFERENCIA').AsString)) then
                Form1.spdNFCeDataSets1.Campo('cEANTrib_I12').Value := LimpaNumero(Form1.ibDataSet4.FieldByname('REFERENCIA').AsString); // EAN do Produto

            //
            // Quantidade tributável
            //
            //
            if Alltrim(ConverteAcentos2(Form1.ibDataSet4.FieldByname('MEDIDA').AsString)) <> '' then
              Form1.spdNFCeDataSets1.Campo('uTrib_I13').Value    := ConverteAcentos2(Form1.ibDataSet4.FieldByname('MEDIDA').AsString) else Form1.spdNFCeDataSets1.Campo('uTrib_I13').Value    := 'UND'; // Unidade de Medida Tributável do Item
            //
            if Frac(Form1.ibDataSet27.FieldByname('QUANTIDADE').AsFloat) = 0 then
              Form1.spdNFCeDataSets1.Campo('qTrib_I14').Value   := FormatFloatXML(Form1.ibDataSet27.FieldByname('QUANTIDADE').AsFloat, 0) // Quantidade Comercializada do Item
            else
              if Trim(Form1.ConfCasas) <> '' then
                Form1.spdNFCeDataSets1.Campo('qTrib_I14').Value   := FormatFloatXML(Form1.ibDataSet27.FieldByname('QUANTIDADE').AsFloat, StrToIntDef(Trim(Form1.ConfCasas), 3)) // Quantidade Comercializada do Item
              else
                Form1.spdNFCeDataSets1.Campo('qTrib_I14').Value   := FormatFloatXML(Form1.ibDataSet27.FieldByname('QUANTIDADE').AsFloat, 3); // Quantidade Comercializada do Item

            if Trim(Form1.ConfPreco) <> '' then
              Form1.spdNFCeDataSets1.Campo('vUnTrib_I14a').Value := FormatFloatXML(Form1.ibDataSet27.FieldByname('UNITARIO').AsFloat, StrToInt64Def(Trim(Form1.ConfPreco), 3)) // Valor Tributável do Item
            else
              Form1.spdNFCeDataSets1.Campo('vUnTrib_I14a').Value := FormatFloatXML(Form1.ibDataSet27.FieldByname('UNITARIO').AsFloat, 3); // Valor Tributável do Item

            if RetornaValorDaTagNoCampo('uTrib',Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '' then
            begin // Tem configuração para unidade tributada
              //
              Form1.spdNFCeDataSets1.Campo('uTrib_I13').Value    := RetornaValorDaTagNoCampo('uTrib',Form1.ibDataSet4.FieldByname('TAGS_').AsString);
              //
              if LimpaNumero(RetornaValorDaTagNoCampo('qTrib',Form1.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
              begin
                if Trim(Form1.ConfCasas) <> '' then
                  Form1.spdNFCeDataSets1.Campo('qTrib_I14').Value    := FormatFloatXML(Form1.ibDataSet27.FieldByname('QUANTIDADE').AsFloat * StrToFloat( RetornaValorDaTagNoCampo('qTrib',Form1.ibDataSet4.FieldByname('TAGS_').AsString)  ), StrToIntDef(Trim(Form1.ConfCasas), 3))  // Quantidade Tributável do Item
                else
                  Form1.spdNFCeDataSets1.Campo('qTrib_I14').Value    := FormatFloatXML(Form1.ibDataSet27.FieldByname('QUANTIDADE').AsFloat * StrToFloat( RetornaValorDaTagNoCampo('qTrib',Form1.ibDataSet4.FieldByname('TAGS_').AsString)  ));  // Quantidade Tributável do Item

                Form1.spdNFCeDataSets1.Campo('vUnTrib_I14a').Value := FormatFloatXML(Form1.ibDataSet27.FieldByname('TOTAL').AsFloat / StrToFloat(StrTran(Form1.spdNFCeDataSets1.Campo('qTrib_I14').AsString,'.',',')), 10); // Valor Tributável do Item. Igual gera tag para NF-e
              end;
            end;
            //
            // TAGS
            //
            try
              //
              dvTotTrib_M02 := StrToFloat(
                                 FormatFloat('##0.00',
                                   ((dvProd_I11 - fDescontoTotalRateado + dRateioAcrescimoItem) * Form1.ibDataSet4.FieldByname('IIA').AsFloat / 100) +
                                   ((dvProd_I11 - fDescontoTotalRateado + dRateioAcrescimoItem) * Form1.ibDataSet4.FieldByname('IIA_UF').AsFloat / 100) +
                                   ((dvProd_I11 - fDescontoTotalRateado + dRateioAcrescimoItem) * Form1.ibDataSet4.FieldByname('IIA_MUNI').AsFloat / 100)
                                 )
              );

              Form1.spdNFCeDataSets1.Campo('vTotTrib_M02').Value  := FormatFloatXML(dvTotTrib_M02); //
              fTotalTributos := fTotalTributos + dvTotTrib_M02;
              //
            except
              on E: Exception do
              begin
                sLogErro := sLogErroCredenciadoraCartao + 'Erro: 44' + Chr(10) + E.Message+chr(10)+chr(10)+'Ao calcular tributos';
                Exit;
              end;
            end;

            if (Form1.ibDataSet4.FieldByName('TIPO_ITEM').AsString = '09') then // Serviço
            begin
              if Form1.spdNFCeDataSets1.Campo('NCM_I05').Value = '' then
                Form1.spdNFCeDataSets1.Campo('NCM_I05').Value := '00'; // Nota: Em caso de item de serviço ou item que não tenham produto (ex. transferência de crédito, crédito do ativo imobilizado, etc.), informar o valor 00 (dois zeros).

              dvBC_U02     := dvProd_I11 - fDescontoTotalRateado + dRateioAcrescimoItem;
              dvServ_W18   := dvServ_W18 + dvProd_I11; //vBC_U02;
              dvBC_W19     := dvBC_W19 + dvBC_U02;
              dvAliq_U03   := StrToFloatDef(Form1.AliquotaISSConfigura, 0) / 100;
              if Form1.ibDataSet4.FieldByname('ALIQUOTA_NFCE').AsString <> '' then
                dvAliq_U03 := Form1.ibDataSet4.FieldByname('ALIQUOTA_NFCE').AsFloat;

              dvISSQN_U04  := StrToFloat(StrZero(((dvBC_U02 * dvAliq_U03) / 100), 0, 2));
              dvISS_W20    := dvISS_W20 + dvISSQN_U04;
              //dvPIS_W21    := dvPIS_W21 + StrToFloat(StrZero((dvBC_U02 * Form1.ibDataSet27.FieldByname('ALIQ_PIS').AsFloat / 100), 0, 2));
              //dvCOFINS_W22 := dvCOFINS_W22 + StrToFloat(StrZero((dvBC_U02 * Form1.ibDataSet27.FieldByname('ALIQ_COFINS').AsFloat / 100), 0, 2));

              Form1.spdNFCeDataSets1.Campo('vBC_U02').Value       := FormatFloatXML(dvBC_U02); // vBC ISSQN
              Form1.spdNFCeDataSets1.Campo('vAliq_U03').Value     := FormatFloatXML(dvAliq_U03); // vAliq ISSQN
              Form1.spdNFCeDataSets1.Campo('vISSQN_U04').Value    := FormatFloatXML(dvISSQN_U04); // vISSQN
              Form1.spdNFCeDataSets1.Campo('cMunFG_U05').Value    := Form1.spdNFCeDataSets1.Campo('cMunFG_B12').Value;
              Form1.spdNFCeDataSets1.Campo('cListServ_U06').Value := Trim(Form1.ExtrairConfiguracao(Form1.ibDataSet4.FieldByName('LIVRE4').AsString, SIGLA_CLISTSERV, False));
              if Form1.spdNFCeDataSets1.Campo('cListServ_U06').Value = '' then
                Form1.spdNFCeDataSets1.Campo('cListServ_U06').Value := '01.04';

              if RetornaValorDaTagNoCampo('cListServ', Form1.ibDataSet4.FieldByName('TAGS_').AsString) <> '' then
                Form1.spdNFCeDataSets1.Campo('cListServ_U06').Value := RetornaValorDaTagNoCampo('cListServ', Form1.ibDataSet4.FieldByName('TAGS_').AsString); // Usa valor se existir na aba tag

              //Form1.spdNFCeDataSets1.Campo('vDeducao_U07').Value     := '0.00'; // Valor dedução para redução da Base de Cálculo
              //Form1.spdNFCeDataSets1.Campo('vOutro_U08').Value       := '0.00'; // Valor outras retenções
              //Form1.spdNFCeDataSets1.Campo('vDescIncond_U09').Value  := '0.00'; // Valor desconto incondicionado
              //Form1.spdNFCeDataSets1.Campo('vDescCond_U10').Value    := '0.00'; // Valor desconto condicionado
              //Form1.spdNFCeDataSets1.Campo('vISSRet_U11').Value      := '0.00'; // Valor retenção ISS
              Form1.spdNFCeDataSets1.Campo('indISS_U12').Value       := '1'; // Indicador da exigibilidade do ISS 1=Exigível, 2=Não incidência; 3=Isenção; 4=Exportação; 5=Imunidade; 6=Exigibilidade Suspensa por Decisão Judicial; 7=Exigibilidade Suspensa por Processo Administrativo;
              if RetornaValorDaTagNoCampo('cServico', Form1.ibDataSet4.FieldByName('TAGS_').AsString) <> '' then // Sandro Silva 2018-10-09 if RetornaValorDaTagNoCampo('cServico', Form1.ibDataSet4.FieldByName('OBS').AsString) <> '' then
                Form1.spdNFCeDataSets1.Campo('cServico_U13').Value     := RetornaValorDaTagNoCampo('cServico', Form1.ibDataSet4.FieldByName('TAGS_').AsString) // Código do serviço prestado dentro do município // Sandro Silva 2018-10-09Form1.spdNFCeDataSets1.Campo('cServico_U13').Value     := RetornaValorDaTagNoCampo('cServico', Form1.ibDataSet4.FieldByName('OBS').AsString) // Código do serviço prestado dentro do município
              else
                Form1.spdNFCeDataSets1.Campo('cServico_U13').Value     := '00000000000000000001'; // Código do serviço prestado dentro do município
              Form1.spdNFCeDataSets1.Campo('cMun_U14').Value         := Form1.spdNFCeDataSets1.Campo('cMunFG_B12').Value; // Código do Município de incidência do imposto
              Form1.spdNFCeDataSets1.Campo('cPais_U15').Value        := '1058'; // Código do País onde o serviço foi prestado
              Form1.spdNFCeDataSets1.Campo('indIncentivo_U17').Value := '2'; //  // Indicador de incentivo Fiscal 1=Sim; 2=Não;
            end
            else
            begin // Produtos/Mercadorias
              fValorProdutos := fValorProdutos + dvProd_I11;

              if (LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString) <> '1') then
              begin // NÃO É SIMPLES NACIONAL

                Form1.spdNFCeDataSets1.Campo('orig_N11').Value    := Copy(Right('000' + LimpaNumero(Form1.ibDataSet4.FieldByname('CST').AsString), 3), 1, 1); //Origem da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)
                Form1.spdNFCeDataSets1.Campo('CST_N12').Value     := Right('000' + LimpaNumero(Form1.ibDataSet4.FieldByname('CST').AsString), 2); // Tipo da Tributação do ICMS (00 - Integralmente) ver outras formas no Manual

                if Length(LimpaNumero(Form1.ibDataSet4.FieldByname('CST_NFCE').AsString)) > 1 then // Se existir CST para NFC-e usa a configuração
                begin
                  Form1.spdNFCeDataSets1.Campo('orig_N11').Value  := Copy(Right('000' + LimpaNumero(Form1.ibDataSet4.FieldByname('CST_NFCE').AsString), 3), 1, 1); //Origem da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)
                  Form1.spdNFCeDataSets1.Campo('CST_N12').Value   := Right('000' + LimpaNumero(Form1.ibDataSet4.FieldByname('CST_NFCE').AsString), 2); // Tipo da Tributação do ICMS (00 - Integralmente) ver outras formas no Manual

                  //ShowMessage('Teste 3415 ' + Form1.spdNFCeDataSets1.Campo('CST_N12').Value); // Sandro Silva 2019-03-08

                end;

                if Form1.ibDataSet27.FieldByname('CST_ICMS').Value <> Trim(Form1.spdNFCeDataSets1.Campo('orig_N11').Value) + Trim(Form1.spdNFCeDataSets1.Campo('CST_N12').Value)  then
                begin
                  Form1.ibDataSet27.Edit;
                  Form1.ibDataSet27.FieldByname('CST_ICMS').Value := Trim(Form1.spdNFCeDataSets1.Campo('orig_N11').Value) + Trim(Form1.spdNFCeDataSets1.Campo('CST_N12').Value);

                  {Sandro Silva 2021-01-13 inicio
                  if Trim(Form1.spdNFCeDataSets1.Campo('CST_N12').Value)  = '40' then
                    Form1.ibDataSet27.FieldByname('ALIQUICM').Value := 'I';
                  if Trim(Form1.spdNFCeDataSets1.Campo('CST_N12').Value)  = '41' then
                    Form1.ibDataSet27.FieldByname('ALIQUICM').Value := 'N';
                  if Trim(Form1.spdNFCeDataSets1.Campo('CST_N12').Value)  = '60' then
                    Form1.ibDataSet27.FieldByname('ALIQUICM').Value := 'F';
                  {Sandro Silva 2021-01-13 fim}

                end;

              end else
              begin // SIMPLES NACIONAL

                Form1.spdNFCeDataSets1.Campo('orig_N11').Value    := Copy(LimpaNumero(Form1.ibDataSet4.FieldByname('CST').AsString)+'000',1,1); //Origemd da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)
                Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value  :=  Form1.ibDataSet4.FieldByname('CSOSN').AsString; // ESTOQUE.CSOSN
                if Trim(Form1.ibDataSet4.FieldByname('CSOSN_NFCE').AsString) <> '' then // Se existir CSOSN para NFC-e usa a configuração
                begin
                  Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value := LimpaNumero(Form1.ibDataSet4.FieldByname('CSOSN_NFCE').AsString); // ESTOQUE.CSOSN_NFCE // Tipo da Tributação do ICMS (00 - Integralmente) ver outras formas no Manual
                end;

                {Sandro Silva 2023-05-23 inicio}
                if Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value = '61' then
                begin
                  // Ficha 6908
                  // Simples nacional usa CST 61 no lugar do CSOSN
                  Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Clear;
                  Form1.spdNFCeDataSets1.Campo('CST_N12').AsString := '61';

                  {
                  if Form1.ibDataSet27.FieldByname('CSOSN').AsString <> Trim(Form1.spdNFCeDataSets1.Campo('orig_N11').Value) + Trim(Form1.spdNFCeDataSets1.Campo('CST_N12').AsString) then
                  begin
                    Form1.ibDataSet27.Edit;
                    Form1.ibDataSet27.FieldByname('CSOSN').Value := Trim(Form1.spdNFCeDataSets1.Campo('orig_N11').Value) + Trim(Form1.spdNFCeDataSets1.Campo('CST_N12').Value);
                  end;
                  }

                end;
                {Sandro Silva 2023-05-23 fim}

                {Sandro Silva 2021-11-05 inicio}
                // Ficha 5534
                // Implementar validção de CSOSN 101 neste local
                if Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value = '101' then
                begin
                  sLogErro := 'Corriga no Estoque o CSOSN do produto ' + Form1.spdNFCeDataSets1.Campo('cProd_I02').Value + ' - ' + Form1.spdNFCeDataSets1.Campo('xProd_I04').Value + ' -> CSOSN incompatível: ' + Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value + chr(10);
                  ConcatenaLog(sLogErroItens, sLogErro);
                end;
                {Sandro Silva 2021-11-05 fim}


                // Não é posssível informar CSOSN 61. Para CSOSN 61 será criado no grupo imposto a tag CST
                if (Form1.spdNFCeDataSets1.Campo('CST_N12').Value <> '61') and (Form1.ibDataSet27.FieldByname('CSOSN').AsString <> '') then // Não é posssível informar CSOSN 61. Para CSOSN 61 será criado no grupo imposto a tag CST
                begin

                  if Form1.ibDataSet27.FieldByname('CSOSN').AsString <> Trim(Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value) then // ALTERACA.CSOSN <> do XML
                  begin
                    Form1.ibDataSet27.Edit;
                    Form1.ibDataSet27.FieldByname('CSOSN').AsString := Trim(Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value); // Repassa para ALTERACA.CSOSN o valor atribuido ao XML

                    {Sandro Silva 2021-01-13 inicio
                    if (Trim(Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value) = '102') or (Trim(Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value) = '103') or (Trim(Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value) = '300') then
                      Form1.ibDataSet27.FieldByname('ALIQUICM').Value := 'I';
                    if Trim(Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value) = '400' then
                      Form1.ibDataSet27.FieldByname('ALIQUICM').Value := 'N';
                    if Trim(Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value) = '500' then
                      Form1.ibDataSet27.FieldByname('ALIQUICM').Value := 'F';
                    {Sandro Silva 2021-01-13 fim}

                  end;

                end;

                // Sandro Silva 2023-05-23 if Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value = '' then
                if (Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value = '')
                  and (Form1.spdNFCeDataSets1.Campo('CST_N12').AsString = '') // // Simples nacional usa CST 61 no lugar do CSOSN
                then
                begin
                  sStatus := 'Configure no Estoque, o CSOSN para o produto: '+Form1.spdNFCeDataSets1.Campo('cProd_I02').Value+' '+Form1.spdNFCeDataSets1.Campo('xProd_I04').Value;// Sandro Silva 2018-04-11  sStatus := 'CSOSN não configurado para o produto: '+Form1.spdNFCeDataSets1.Campo('cProd_I02').Value+' '+Form1.spdNFCeDataSets1.Campo('xProd_I04').Value;
                  sLogErro := sLogErroCredenciadoraCartao + 'Erro:22' + Chr(10) + sStatus +chr(10);   // Sandro Silva 2017-08-16  +chr(10)+'Leia atentamente a mensagem acima e tente resolver o problema.'+chr(10)+'Considere pedir ajuda ao seu contador para o preenchimento correto da NFC-e.';
                  ConcatenaLog(sLogErroItens, sLogErro); // Sandro Silva 2018-07-20 sLogErroItens := sLogErroItens + Chr(10) + sLogErro;
                end;

              end; /// if Tipo CRT (1;2;3)
              //
              dpRedBC_N14 := 0.00;
              _ecf65_IdentificaPercentuaisBaseICMS(dpRedBC_N14);

              dvBC_N15 := (dvProd_I11 - fDescontoTotalRateado + dRateioAcrescimoItem); // BC // Sandro Silva 2019-08-29
              if (Pos('|' + Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring + '|', '|61|') > 0) or
                 (Pos('|' + Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').AsString + '|', '|61|') > 0) then
                dvBC_N15 := 0.00;

              if (LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString) <> '1') then
              begin
                 //Cálculo da desoneração
                _ecf65_CalculaDesoneracao(Form1.ibDataSet13.FieldByName('ESTADO').AsString,
                  Form1.ibDataSet4.FieldByName('ST').AsString,
                  LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString),
                  Form1.spdNFCeDataSets1.Campo('orig_N11').Value + Form1.spdNFCeDataSets1.Campo('CST_N12').AsString,
                  Form1.ibDataSet27.FieldByName('ALIQUICM').AsString,
                  dpRedBC_N14,
                  dvBC_N15,
                  Form1.ibDataSet14,
                  Form1.ibDataSet4,
                  dvICMSDeson_N28a,
                  dvICMS_N17
                  );
              end;

              if LimpaNumero(Form1.ibDataSet27.FieldByName('ALIQUICM').AsString) <> '' then
              begin
                //
                if (LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString) <> '1') then
                begin
                  //
                  // Só quando não é simples nacional
                  //
                  if Pos('|' + Form1.spdNFCeDataSets1.Campo('CST_N12').AsString + '|', '|20|90|') > 0 then // Se CST for 02=Com redução de base de cálculo; 90=Outros
                  begin
                    if dpRedBC_N14 = 0.00 then
                    begin
                      Form1.spdNFCeDataSets1.Campo('pRedBC_N14').Value := FormatFloatXML(dpRedBC_N14); // Sandro Silva 2019-03-11
                    end
                    else if dpRedBC_N14 = 100.00 then
                    begin
                      Form1.spdNFCeDataSets1.Campo('pRedBC_N14').Value := FormatFloatXML(dpRedBC_N14);// Percentual da Redução de BC. Calcula o percentual de redução da base. Ex.: No Estoque pRedBC=66,67, então o percentual de redução que irá para o xml será de 33,33 (100-66,67)
                      dvBC_N15 := 0.00;
                    end
                    else
                    begin
                      Form1.spdNFCeDataSets1.Campo('pRedBC_N14').Value := FormatFloatXML(100 - dpRedBC_N14);// Percentual da Redução de BC. Calcula o percentual de redução da base. Ex.: No Estoque pRedBC=66,67, então o percentual de redução que irá para o xml será de 33,33 (100-66,67)
                      if dpRedBC_N14 > 0 then
                        dvBC_N15 := StrToFloatDef(FormatFloat('0.00', dvBC_N15 * (dpRedBC_N14 / 100)), 0); // Aplica a redução na B.C.
                    end;
                  end;

                  Form1.spdNFCeDataSets1.Campo('vBC_N15').Value := FormatFloatXML(dvBC_N15); // BC // Sandro Silva 2019-02-08

                  dvICMS_N17 := 0.00;

                  // Diferente de 40=isenta;41=Não tributada; 50=Suspensão; 60=Tributação ICMS cobrado anteriormente por substituição tributária;61=Tributação monofásica sobre combustíveis cobrada anteriormente;
                  if Pos('|' + Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring + '|', '|40|41|50|60|61|') = 0 then // Sandro Silva 2023-05-19 if Pos('|' + Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring + '|', '|40|41|50|60|') = 0 then
                  begin
                    dvICMS_N17 := StrToFloat(FormatFloat('##0.00', (dvBC_N15 * (StrToIntDef(LimpaNumero(Form1.ibDataSet27.FieldByName('ALIQUICM').AsString), 0) / 10000))));// Sandro Silva 2018-02-19  dvICMS_N17 := StrToFloat(FormatFloat('##0.00', (dvProd_I11 - fDescontoTotalRateado + dRateioAcrescimoItem) * (StrToIntDef(LimpaNumero(Form1.ibDataSet27.FieldByName('ALIQUICM').AsString), 0) / 10000)));
                  end;
                  //
                  // Diferente de 40=Isenta; 41=Não tributada; 60=Tributação ICMS cobrado anteriormente por substituição tributária;61=Tributação monofásica sobre combustíveis cobrada anteriormente;
                  if Pos('|' + Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring + '|', '|40|41|60|61|') = 0 then // Sandro Silva 2023-05-19 if Pos('|' + Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring + '|', '|40|41|60|') = 0 then
                    rBaseICMS  := rBaseICMS + dvBC_N15;// Sandro Silva 2018-02-19  rBaseICMS  := rBaseICMS + (dvProd_I11 - fDescontoTotalRateado + dRateioAcrescimoItem);

                  if dvICMS_N17 > 0.00 then
                  begin
                    Form1.spdNFCeDataSets1.Campo('vICMS_N17').Value := FormatFloatXML(dvICMS_N17) // Valor do ICMS em Reais
                  end
                  else if Pos('|' + Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring + '|', '|40|41|60|61|') = 0 then // Sandro Silva 2023-05-19 else if Pos('|' + Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring + '|', '|40|41|60|') = 0 then
                  begin
                    Form1.spdNFCeDataSets1.Campo('vICMS_N17').Value := FormatFloatXML(dvICMS_N17); // Valor do ICMS em Reais
                  end;

                  rValorICMS := rValorICMS + dvICMS_N17; //(Form1.ibDataSet27.FieldByname('TOTAL').AsFloat-fDescontoTotalRateado)*(StrToInt('0'+LimpaNumero(Form1.ibDataSet27.FieldByName('ALIQUICM').AsString))/10000);

                  //
                  // Só quando não é simples nacional
                  //
                  //
                  // FCP
                  //
                  // Durante testes com ambiente homologação AM sempre retornou rejeição quando preenchidos campo pFCP e vFCP seguindo as orientações da NT 2016_002_v1.40
                  //
                  if RetornaValorDaTagNoCampo('FCP', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '' then // Sandro Silva 2019-05-13  if RetornaValorDaTagNoCampo('pFCP', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '' then // Sandro Silva 2018-10-09 if RetornaValorDaTagNoCampo('pFCP', Form1.ibDataSet4.FieldByname('OBS').AsString) <> '' then
                  begin

                    if (Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring = '00') then
                    begin
                      dvFCP_N17c := StrToFloat(FormatFloat('##0.00', (dvBC_N15 * StrToFloatDef(RetornaValorDaTagNoCampo('FCP', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0)) / 100));
                      dvFCP_W04h := dvFCP_W04h + dvFCP_N17c;
                      Form1.spdNFCeDataSets1.Campo('pFCP_N17b').Value := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('FCP', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0)); // Percentual do Fundo de Combate à Pobreza (FCP) E N17.1 N 1-1 3v2-4 Percentual relativo ao Fundo de Combate à Pobreza (FCP).
                      Form1.spdNFCeDataSets1.Campo('vFCP_N17c').Value := FormatFloatXML(dvFCP_N17c); // Valor do Fundo de Combate à Pobreza (FCP) E N17.1 N 1-1 13v2 Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP).

                      _ecf65_InfAddProdFCP(Form1.spdNFCeDataSets1, dvFCP_N17c, dvBC_N15);
                    end;

                    // “Tributação do ICMS=20 - Tributada com redução de base de cálculo”, “Tributação do ICMS=51 - Tributação com Diferimento” e “Tributação do ICMS=90 - Outros”
                    if Pos('|' + Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring + '|', '|20|51|90|') > 0 then
                    begin
                      dvFCP_N17c := StrToFloat(FormatFloat('##0.00', (dvBC_N15 * StrToFloatDef(RetornaValorDaTagNoCampo('FCP', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0)) / 100));
                      dvFCP_W04h := dvFCP_W04h + dvFCP_N17c;
                      Form1.spdNFCeDataSets1.Campo('vBCFCP_N17a').Value := FormatFloatXML(dvBC_N15); // Informar o valor da Base de Cálculo do FCP
                      Form1.spdNFCeDataSets1.Campo('pFCP_N17b').Value   := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('FCP', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0)); // Percentual do Fundo de Combate à Pobreza (FCP) E N17.1 N 1-1 3v2-4 Percentual relativo ao Fundo de Combate à Pobreza (FCP).
                      Form1.spdNFCeDataSets1.Campo('vFCP_N17c').Value   := FormatFloatXML(dvFCP_N17c); // Valor do Fundo de Combate à Pobreza (FCP) E N17.1 N 1-1 13v2 Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP).

                      _ecf65_InfAddProdFCP(Form1.spdNFCeDataSets1, dvFCP_N17c, dvBC_N15);
                    end;
                  end;
                end
                else
                begin //// SIMPLES NACIONAL

                  /////////////////////////////////////////////////////////////////////////////////

                  Form1.spdNFCeDataSets1.Campo('vBC_N15').Value := FormatFloatXML(dvBC_N15); // BC // Sandro Silva 2018-02-19

                  dvICMS_N17 := 0.00;

                  if Pos('|' + Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').AsString + '|', '|900|') > 0 then // Se CSOSN for 900=Tributação ICMS pelo Simples Nacional
                  begin
                    dvICMS_N17 := StrToFloat(FormatFloat('##0.00', (dvBC_N15 * (StrToIntDef(LimpaNumero(Form1.ibDataSet27.FieldByName('ALIQUICM').AsString), 0) / 10000))));// Sandro Silva 2018-02-19  dvICMS_N17 := StrToFloat(FormatFloat('##0.00', (dvProd_I11 - fDescontoTotalRateado + dRateioAcrescimoItem) * (StrToIntDef(LimpaNumero(Form1.ibDataSet27.FieldByName('ALIQUICM').AsString), 0) / 10000)));
                  end;

                  //
                  if Pos('|' + Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').AsString + '|', '|900|') > 0 then // Se CSOSN for 900=Tributação ICMS pelo Simples Nacional
                    rBaseICMS  := rBaseICMS + dvBC_N15;// Sandro Silva 2018-02-19  rBaseICMS  := rBaseICMS + (dvProd_I11 - fDescontoTotalRateado + dRateioAcrescimoItem);

                  if dvICMS_N17 > 0.00 then
                    Form1.spdNFCeDataSets1.Campo('vICMS_N17').Value := FormatFloatXML(dvICMS_N17); // Valor do ICMS em Reais

                  rValorICMS := rValorICMS + dvICMS_N17; //(Form1.ibDataSet27.FieldByname('TOTAL').AsFloat-fDescontoTotalRateado)*(StrToInt('0'+LimpaNumero(Form1.ibDataSet27.FieldByName('ALIQUICM').AsString))/10000);

                  //
                  // FCP
                  //
                  // Simples não gera FCP
                  //
                  if RetornaValorDaTagNoCampo('FCP', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '' then // Sandro Silva 2019-05-13  if RetornaValorDaTagNoCampo('pFCP', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '' then // Sandro Silva 2018-10-09 if RetornaValorDaTagNoCampo('pFCP', Form1.ibDataSet4.FieldByname('OBS').AsString) <> '' then
                  begin
                    // Se fo CSOSN=900 Tributação ICMS pelo Simples Nacional;
                    if (Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').AssTring = '900') then
                    begin
                      {Sandro Silva 2019-05-13 inicio
                      Não gerou as tags de fcp quanto CSOSN=900
                      dvFCP_N17c := StrToFloat(FormatFloat('##0.00', (dvBC_N15 * StrToFloatDef(RetornaValorDaTagNoCampo('FCP', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0)) / 100));
                      dvFCP_W04h := dvFCP_W04h + dvFCP_N17c;
                      Form1.spdNFCeDataSets1.Campo('pFCP_N17b').Value := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('FCP', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0)); // Percentual do Fundo de Combate à Pobreza (FCP) E N17.1 N 1-1 3v2-4 Percentual relativo ao Fundo de Combate à Pobreza (FCP).
                      Form1.spdNFCeDataSets1.Campo('vFCP_N17c').Value := FormatFloatXML(dvFCP_N17c); // Valor do Fundo de Combate à Pobreza (FCP) E N17.1 N 1-1 13v2 Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP).
                      {Sandro Silva 2019-05-13 fim}
                    end;

                  end; // if RetornaValorDaTagNoCampo('FCP', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '' then
                  ////////////////////////////////////////////////////////////////////////
                end; // if (LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString) <> '1') then
                //
              end else
              begin
                dvBC_N15 := 0.00;
                //
                // Sandro Silva 2023-05-23 Form1.spdNFCeDataSets1.Campo('vBC_N15').Value     := '0.00';  // BC
                Form1.spdNFCeDataSets1.Campo('vBC_N15').Value     := FormatFloatXML(dvBC_N15);  // BC

                //
                if (LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString) <> '1') then
                begin // NÃO É SIMPLES NACIONAL
                  if Pos('|' + Form1.spdNFCeDataSets1.Campo('CST_N12').AsString + '|', '|40|41|50|') = 0 then
                  begin
                    Form1.spdNFCeDataSets1.Campo('vICMS_N17').Value   := '0.00';  // Valor do ICMS em Reais
                  end;
                end;
                //
              end; // if LimpaNumero(Form1.ibDataSet27.FieldByName('ALIQUICM').AsString) <> '' then
              //

              {Sandro Silva 2023-05-17 inicio}
              //qBCMonoRet = será igual à quantidade do produto informado na nota
              //adRemICMSRet = buscar da tag adRemICMSRet do cadastro do produto
              //vICMSMonoRet = multiplicar o valor da tag qBCMonoRet pelo valor da tag adRemICMSRet

              // Não é posssível informar CSOSN 61. Para CSOSN 61 será criado no grupo imposto a tag CST
              if (Form1.spdNFCeDataSets1.Campo('CST_N12').AsString = '61') then
              begin

                sMensagemIcmMonofasicoSobreCombustiveis := 'ICMS monofásico sobre combustíveis cobrado anteriormente conforme Convênio ICMS 199/2022;'; // Sandro Silva 2023-09-05

                Form1.spdNFCeDataSets1.Campo('vBC_N15').Value     := FormatFloatXML(dvBC_N15);  // BC
                Form1.spdNFCeDataSets1.Campo('vICMS_N17').Value   := FormatFloatXML(dvICMS_N17);  // Valor do ICMS em Reais

                Form1.spdNFCeDataSets1.Campo('qBCMonoRet_N43a').Value  := Form1.spdNFCeDataSets1.Campo('qCom_I10').Value;
                dqBCMonoRet_N43aTotal := dqBCMonoRet_N43aTotal + XmlValueToFloat(Form1.spdNFCeDataSets1.Campo('qCom_I10').AsString);
                Form1.spdNFCeDataSets1.Campo('adRemICMSRet_N44').Value := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('adRemICMSRet', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0.00), 4);
                dvICMSMonoRet_N45      := XmlValueToFloat(Form1.spdNFCeDataSets1.Campo('qBCMonoRet_N43a').AsString) * XmlValueToFloat(Form1.spdNFCeDataSets1.Campo('adRemICMSRet_N44').AsString);
                // Sandro Silva 2023-09-05 dvICMSMonoRet_N45Total := dvICMSMonoRet_N45Total + dvICMSMonoRet_N45;

                Form1.spdNFCeDataSets1.Campo('vICMSMonoRet_N45').Value := FormatFloatXML(dvICMSMonoRet_N45);

                dvICMSMonoRet_N45Total := dvICMSMonoRet_N45Total + XmlValueToFloat(Form1.spdNFCeDataSets1.Campo('vICMSMonoRet_N45').Value); // Sandro Silva 2023-09-04

              end;
              {Sandro Silva 2023-05-17 fim}

              // Cálculo da desoneração
              if (RetornaValorDaTagNoCampo('motDesICMS', Form1.ibDataSet4.FieldByname('TAGS_').AsString) <> '') then
              begin
                Form1.spdNFCeDataSets1.Campo('motDesICMS_N28').Value  := RetornaValorDaTagNoCampo('motDesICMS', Form1.ibDataSet4.FieldByname('TAGS_').AsString);
                Form1.spdNFCeDataSets1.Campo('vICMSDeson_N28a').Value := FormatFloatXML(dvICMSDeson_N28a);
                dvICMSDeson_W04a := dvICMSDeson_W04a + dvICMSDeson_N28a;
              end;

              if LimpaNumero(Form1.ibDataSet4.FieldByname('CST_PIS_COFINS_SAIDA').AsString) <> '' then
              begin
                //PIS e COFINS
                sCSTPISCofins := Form1.ibDataSet4.FieldByname('CST_PIS_COFINS_SAIDA').AsString;
                Form1.ibDataSet27.Edit;
                Form1.ibDataSet27.FieldByname('CST_PIS_COFINS').Value := sCSTPISCofins;
                Form1.ibDataSet27.FieldByname('ALIQ_PIS').Value       := Form1.ibDataSet4.FieldByname('ALIQ_PIS_SAIDA').AsFloat;
                Form1.ibDataSet27.FieldByname('ALIQ_COFINS').Value    := Form1.ibDataSet4.FieldByname('ALIQ_COFINS_SAIDA').AsFloat;

                if (sCSTPISCofins = '01') or (sCSTPISCofins = '02') or (sCSTPISCofins = '49') or (sCSTPISCofins = '99') then
                begin
                  // Q02 PISAliq 01=Operação Tributável (base de cálculo = valor da operação alíquota normal (cumulativo/não cumulativo)); 02=Operação Tributável (base de cálculo = valor da operação (alíquota diferenciada));
                  // Q05 PISOutr 99=Outras Operações;
                  dvBCPIS_Q07 := dvProd_I11 - fDescontoTotalRateado + dRateioAcrescimoItem;
                  {Sandro Silva 2021-07-26 inicio}
                  if (LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString) <> '1') then
                  begin
                    if (Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring <> '60') then // CST 60 icms efetivo Sandro Silva 2021-08-04
                    begin
                      dvBCPIS_Q07 := dvBCPIS_Q07 - dvICMS_N17;
                      if dvBCPIS_Q07 < 0 then
                        dvBCPIS_Q07 := 0.00;
                    end;
                  end;
                  {Sandro Silva 2021-07-26 fim}

                  dvPIS_Q09 := StrToFloat(FormatFloat('##0.00', dvBCPIS_Q07 * (Form1.ibDataSet4.FieldByname('ALIQ_PIS_SAIDA').AsFloat / 100)));

                  dvPIS_W13 := dvPIS_W13 + dvPIS_Q09;
                  Form1.spdNFCeDataSets1.Campo('CST_Q06').Value  := sCSTPISCofins;
                  Form1.spdNFCeDataSets1.Campo('vBC_Q07').Value  := FormatFloatXML(dvBCPIS_Q07); // Sandro Silva 2017-04-24  FormatFloatXML(dvProd_I11 - fDescontoTotalRateado);
                  Form1.spdNFCeDataSets1.Campo('pPIS_Q08').Value := FormatFloatXML(Form1.ibDataSet4.FieldByname('ALIQ_PIS_SAIDA').AsFloat);
                  Form1.spdNFCeDataSets1.Campo('vPIS_Q09').Value := FormatFloatXML(dvPIS_Q09);

                  // S02 COFINSAliq 01=Operação Tributável (base de cálculo = valor da operação alíquota normal (cumulativo/não cumulativo)); 02=Operação Tributável (base de cálculo = valor da operação (alíquota diferenciada));
                  // S05 COFINSOutr 99=Outras Operações;

                  dvBCCofins_S07 := dvProd_I11 - fDescontoTotalRateado + dRateioAcrescimoItem;
                  {Sandro Silva 2021-07-26 inicio}
                  if (LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString) <> '1') then
                  begin
                    if (Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring <> '60') then // CST 60 icms efetivo Sandro Silva 2021-08-04
                    begin
                      dvBCCofins_S07 := dvBCCofins_S07 - dvICMS_N17;
                      if dvBCCofins_S07 < 0 then
                        dvBCCofins_S07 := 0.00;
                    end;
                  end;
                  {Sandro Silva 2021-07-26 fim}

                  dvCOFINS_S11 := StrToFloat(FormatFloat('##0.00', dvBCCofins_S07 * (Form1.ibDataSet4.FieldByname('ALIQ_COFINS_SAIDA').AsFloat / 100)));

                  dvCofins_W14 := dvCofins_W14 + dvCOFINS_S11;
                  Form1.spdNFCeDataSets1.Campo('CST_S06').Value     := sCSTPISCofins;
                  Form1.spdNFCeDataSets1.Campo('vBC_S07').Value     := FormatFloatXML(dvBCCofins_S07); // Sandro Silva 2017-04-24  FormatFloatXML(dvProd_I11 - fDescontoTotalRateado);
                  Form1.spdNFCeDataSets1.Campo('pCOFINS_S08').Value := FormatFloatXML(Form1.ibDataSet4.FieldByname('ALIQ_COFINS_SAIDA').AsFloat);
                  Form1.spdNFCeDataSets1.Campo('vCOFINS_S11').Value := FormatFloatXML(dvCOFINS_S11);
                end
                else if (sCSTPISCofins = '03') then
                begin
                  // Q03 PISQtde 03=Operação Tributável (base de cálculo = quantidade vendida x alíquota por unidade de produto);
                  dvPIS_Q09 := StrToFloat(FormatFloat('##0.00', Form1.ibDataSet4.FieldByname('ALIQ_PIS_SAIDA').AsFloat * StrToFloat(StringReplace(Form1.spdNFCeDataSets1.Campo('qCom_I10').Value, '.', ',',[rfReplaceAll]))));

                  dvPIS_W13 := dvPIS_W13 + dvPIS_Q09;
                  Form1.spdNFCeDataSets1.Campo('CST_Q06').Value       := sCSTPISCofins;
                  Form1.spdNFCeDataSets1.Campo('qBCProd_Q10').Value   := Form1.spdNFCeDataSets1.Campo('qCom_I10').Value;
                  Form1.spdNFCeDataSets1.Campo('vAliqProd_Q11').Value := FormatFloatXML(Form1.ibDataSet4.FieldByname('ALIQ_PIS_SAIDA').AsFloat);
                  Form1.spdNFCeDataSets1.Campo('vPIS_Q09').Value      := FormatFloatXML(dvPIS_Q09);

                  // S03 COFINSQtde 03=Operação Tributável (base de cálculo = quantidade vendida x alíquota por unidade de produto);
                  dvCOFINS_S11 := StrToFloat(FormatFloat('##0.00', Form1.ibDataSet4.FieldByname('ALIQ_COFINS_SAIDA').AsFloat * StrToFloat(StringReplace(Form1.spdNFCeDataSets1.Campo('qCom_I10').Value, '.', ',',[rfReplaceAll]))));
                  dvCofins_W14 := dvCofins_W14 + dvCOFINS_S11;
                  Form1.spdNFCeDataSets1.Campo('CST_S06').Value       := sCSTPISCofins;
                  Form1.spdNFCeDataSets1.Campo('qBCProd_S09').Value   := Form1.spdNFCeDataSets1.Campo('qCom_I10').Value;
                  Form1.spdNFCeDataSets1.Campo('vAliqProd_S10').Value := FormatFloatXML(Form1.ibDataSet4.FieldByname('ALIQ_COFINS_SAIDA').AsFloat);
                  Form1.spdNFCeDataSets1.Campo('vCOFINS_S11').Value   := FormatFloatXML(dvCOFINS_S11);
                end
                else
                if (sCSTPISCofins = '04') or (sCSTPISCofins = '05') or (sCSTPISCofins = '06') or (sCSTPISCofins = '07')
                  or (sCSTPISCofins = '08') or (sCSTPISCofins = '09') then
                begin
                  // Q04 PISNT 04=Operação Tributável (tributação monofásica (alíquota zero)); 05=Operação Tributável (Substituição Tributária); 06=Operação Tributável (alíquota zero); 07=Operação Isenta da Contribuição; 08=Operação Sem Incidência da Contribuição; 09=Operação com Suspensão da Contribuição;
                  Form1.spdNFCeDataSets1.Campo('CST_Q06').Value := sCSTPISCofins;

                  // S04 COFINSNT 04=Operação Tributável (tributação monofásica, alíquota zero); 05=Operação Tributável (Substituição Tributária); 06=Operação Tributável (alíquota zero); 07=Operação Isenta da Contribuição; 08=Operação Sem Incidência da Contribuição; 09=Operação com Suspensão da Contribuição;
                  Form1.spdNFCeDataSets1.Campo('CST_S06').Value := sCSTPISCofins;
                end;

              end; // if LimpaNumero(Form1.ibDataSet4.FieldByname('CST_PIS_COFINS_SAIDA').AsString) <> '' then

              if Form1.spdNFCeDataSets1.Campo('indFinal_B25a').Value = '1' then // Operação consumidor final
              begin

                if (Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring = '60') or (Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value = '500') then
                begin
                  dpICMSEfet_N36  := 0.00;
                  dpRedBCEfet_N34 := 0.00;
                  _ecf65_IdentificaPercentuaisICMSEfetivo(dpICMSEfet_N36, dpRedBCEfet_N34);
                  dvBCEfet_N35 := (dvProd_I11 - fDescontoTotalRateado + dRateioAcrescimoItem);
                  if dpRedBCEfet_N34 = 0.00 then
                  begin
                    Form1.spdNFCeDataSets1.Campo('pRedBCEfet_N34').Value := FormatFloatXML(dpRedBCEfet_N34); // Sandro Silva 2019-03-11
                  end
                  else if dpRedBCEfet_N34 = 100.00 then
                  begin
                    Form1.spdNFCeDataSets1.Campo('pRedBCEfet_N34').Value := FormatFloatXML(dpRedBCEfet_N34);// Percentual da Redução de BC. Calcula o percentual de redução da base. Ex.: No Estoque pRedBC=66,67, então o percentual de redução que irá para o xml será de 33,33 (100-66,67)
                    dvBCEfet_N35 := 0.00;
                  end
                  else
                  begin
                    Form1.spdNFCeDataSets1.Campo('pRedBCEfet_N34').Value := FormatFloatXML(100 - dpRedBCEfet_N34);// Percentual da Redução de BC. Calcula o percentual de redução da base. Ex.: No Estoque pRedBC=66,67, então o percentual de redução que irá para o xml será de 33,33 (100-66,67)
                    if dpRedBCEfet_N34 > 0 then
                      dvBCEfet_N35 := StrToFloatDef(FormatFloat('0.00', dvBCEfet_N35 * (dpRedBCEfet_N34 / 100)), 0); // Aplica a redução na B.C.
                  end;

                  // Percentual de redução da base de cálculo efetiva.   Calcula o percentual que foi reduzida a base de cálculo. No Estoque pRedBC=66,67, então no xml irá 33,33 (100-66,67)
                  Form1.spdNFCeDataSets1.Campo('vBCEfet_N35').Value    := FormatFloatXML(dvBCEfet_N35);// Valor da base de cálculo efetiva
                  Form1.spdNFCeDataSets1.Campo('pICMSEfet_N36').Value  := FormatFloatXML(dpICMSEfet_N36);// Alíquota do ICMS efetiva
                  Form1.spdNFCeDataSets1.Campo('vICMSEfet_N37').Value  := FormatFloatXML(dvBCEfet_N35 * dpICMSEfet_N36 / 100) ; // Valor do ICMS efetivo

                end;

              end;

            end; // if Servico then

            {Sandro Silva 2022-05-02 inicio}
            //Nota Técnica 2021.004
            //cProdANVISA_K01a
            //xMotivoIsencao_K01b
            //vPMC_K06
            if _ecf65_GerarcProdANVISA(Form1.ibDataSet4.FieldByname('TAGS_').AsString, Form1.spdNFCeDataSets1.Campo('NCM_I05').Value) then
            begin
              Form1.spdNFCeDataSets1.Campo('cProdANVISA_K01a').Value := AnsiUpperCase(RetornaValorDaTagNoCampo('cProdANVISA', Form1.ibDataSet4.FieldByname('TAGS_').AsString));

              if Form1.spdNFCeDataSets1.Campo('cProdANVISA_K01a').Value = 'ISENTO' then
                Form1.spdNFCeDataSets1.Campo('xMotivoIsencao_K01b').Value := Trim(ConverteAcentos2(RetornaValorDaTagNoCampo('xMotivoIsencao', Form1.ibDataSet4.FieldByname('TAGS_').AsString)));

              Form1.spdNFCeDataSets1.Campo('vPMC_K06').Value := FormatFloatXML(Form1.ibDataSet4.FieldByname('PRECO').AsFloat);
            end;
            {Sandro Silva 2022-05-02 fim}

            Form1.spdNFCeDataSets1.Campo('indTot_I17b').Value  := '1'; //Indica se valor do Item (vProd) entra no valor total da NFC-e (vProd)
            //
            // END TAGS
            //

            if Form1.spdNFCeDataSets1.Campo('NCM_I05').Value = '' then
            begin
              sLogErro := sLogErroCredenciadoraCartao + 'Erro:22' + Chr(10) + 'Configure no Estoque, o NCM para o produto: '+Form1.spdNFCeDataSets1.Campo('cProd_I02').Value+ ' ' +Form1.spdNFCeDataSets1.Campo('xProd_I04').Value+chr(10); // Sandro Silva 2018-04-11  sLogErro := 'Erro:22' + Chr(10) + 'NCM não preenchido' + Chr(10) + Chr(10)+'Ao salvar item código: '+Form1.spdNFCeDataSets1.Campo('cProd_I02').Value+chr(10)+Form1.spdNFCeDataSets1.Campo('xProd_I04').Value+chr(10);

              sStatus := 'NCM não preenchido' + ' ' + Form1.spdNFCeDataSets1.Campo('cProd_I02').Value+ ' ' +Form1.spdNFCeDataSets1.Campo('xProd_I04').Value;

              ConcatenaLog(sLogErroItens, sLogErro); // Sandro Silva 2018-07-20 sLogErroItens := sLogErroItens + Chr(10) + sLogErro;
            end;
          end;// if (Alltrim(Form1.ibDataSet4.FieldByName('CODIGO').AsString) = Alltrim(Form1.ibDAtaSet27.FieldByName('CODIGO').AsString)) and (Alltrim(Form1.ibDataSet4.FieldByName('CODIGO').AsString) <> '') then
        end; // if (Form1.ibDataSet27.FieldByName('TIPO').AsString = 'BALCAO') or (Form1.ibDataSet27.FieldByName('TIPO').AsString = 'LOKED') then // Apenas os itens não cancelados

        //
        try
          Form1.spdNFCeDataSets1.SalvarItem;
        except
          on E: Exception do
          begin

            if AnsiContainsText(sLogErroItens, E.Message) = False then
              sLogErroItens := sLogErroItens + Chr(10) + 'Erro:22' + Chr(10) + E.Message + Chr(10)+ chr(10) + 'Ao incluir item:';
            sLogErroItens := sLogErroItens + chr(10) + Form1.spdNFCeDataSets1.Campo('cProd_I02').Value + ' - ' + Form1.spdNFCeDataSets1.Campo('xProd_I04').Value + chr(10);

            sStatus := E.Message + ' ' + Form1.spdNFCeDataSets1.Campo('cProd_I02').Value + ' ' + Form1.spdNFCeDataSets1.Campo('xProd_I04').Value;

            Form1.spdNFCeDataSets1.Cancelar;

            {Sandro Silva 2021-02-23 inicio}
            try
              Audita('EMISSAO','FRENTE', '', 'Erro: 22 ' + Form1.spdNFCeDataSets1.Campo('cProd_I02').Value + ' ' + Form1.spdNFCeDataSets1.Campo('xProd_I04').Value,0,0); // Ato, Modulo, Usuário, Histórico, Valor
            except
            end;
            {Sandro Silva 2021-02-23 fim}

          end;
        end;
        //
        Form1.ibDataSet27.Next;
        //
      end; // while not Form1.ibDataSet27.Eof do

      try
        if Form1.ibDataSet27.State in [dsInsert, dsEdit] then
          Form1.ibDataSet27.Post;
      except

      end;

      //////////////////////////////////////////////////////////
      //
      // Fim Gerando Itens
      //
      //////////////////////////////////////////////////////////

      if sLogErroItens <> '' then
      begin
        if AnsiContainsText(sLogErroItens, sLogErro) then
          sLogErro := sLogErroItens
        else
          sLogErro := Chr(10) + sLogErroItens;

        if AnsiContainsText(sLogErro, 'Leia atentamente a mensagem acima e tente resolver o problema.'+chr(10)+'Considere pedir ajuda ao seu contador para o preenchimento correto da NFC-e.') = False then
          if AnsiContainsText(sLogErro, 'Erro:22') then // Alerta para tentar resolver problema sem acionar suporte Small
            sLogErro := sLogErro + chr(10)+'Leia atentamente a mensagem acima e tente resolver o problema.'+chr(10)+'Considere pedir ajuda ao seu contador para o preenchimento correto da NFC-e.';

        Exit;
      end;

      //
      // Totalizadores da NFe
      //
      Form1.spdNFCeDataSets1.Campo('vBC_W03').Value         := FormatFloatXML(rBaseICMS); // Base de Cálculo do ICMS
      Form1.spdNFCeDataSets1.Campo('vICMS_W04').Value       := FormatFloatXML(rValorICMS); // Valor Total do ICMS
      //
      Form1.spdNFCeDataSets1.Campo('vICMSDeson_W04a').Value := FormatFloatXML(dvICMSDeson_W04a); // Sandro Silva 2019-08-29 '0.00'; // Desonerado
      //
      Form1.spdNFCeDataSets1.Campo('vBCST_W05').Value       := '0.00'; // Base de Cálculo do ICMS Subst. Tributária
      Form1.spdNFCeDataSets1.Campo('vST_W06').Value         := '0.00'; // Valor Total do ICMS Sibst. Tributária

      {Sandro Silva 2023-09-04 inicio}
      Form1.spdNFCeDataSets1.Campo('qBCMonoRet_W06d1').Value  := FormatFloatXML(dqBCMonoRet_N43aTotal); //Valor total da quantidade tributada do ICMS monofásico retido anteriormente
      Form1.spdNFCeDataSets1.Campo('vICMSMonoRet_W06e').Value := FormatFloatXML(dvICMSMonoRet_N45Total); //Valor total do ICMS monofásico retido anteriormente
      {Sandro Silva 2023-09-04 fim}

      Form1.spdNFCeDataSets1.campo('vFCPUFDest_W04c').Value   := '0.00'; // Novo Sandro Silva 2018-03-28
      Form1.spdNFCeDataSets1.campo('vICMSUFDest_W04e').Value  := '0.00'; // Novo Sandro Silva 2018-03-28
      Form1.spdNFCeDataSets1.campo('vICMSUFRemet_W04g').Value := '0.00'; // Novo Sandro Silva 2018-03-28
      Form1.spdNFCeDataSets1.campo('vFCP_W04h').Value         := FormatFloatXML(dvFCP_W04h); // Novo Sandro Silva 2018-03-28
      Form1.spdNFCeDataSets1.campo('vFCPST_W06a').Value     := '0.00';//Novo
      Form1.spdNFCeDataSets1.campo('vFCPSTRet_W06b').Value  := '0.00';//Novo

      //
      Form1.spdNFCeDataSets1.Campo('vProd_W07').Value       := FormatFloatXML(fValorProdutos); // Valor Total de Produtos e Serviços
      Form1.spdNFCeDataSets1.Campo('vFrete_W08').Value      := '0.00'; // Valor Total do Frete
      Form1.spdNFCeDataSets1.Campo('vSeg_W09').Value        := '0.00'; // Valor Total do Seguro
      //
      if fDesconto > 0 then
      begin
        Form1.spdNFCeDataSets1.Campo('vDesc_W10').Value    := FormatFloatXML(fDesconto); // Valor Total de Desconto
      end
      else
      begin
        Form1.spdNFCeDataSets1.Campo('vDesc_W10').Value    := '0.00';
      end;

      if dvOutro_W15 > 0 then
      begin
        Form1.spdNFCeDataSets1.Campo('vOutro_W15').Value   := FormatFloatXML(dvOutro_W15); // Valor Total de Acrescimo
      end
      else
      begin
        Form1.spdNFCeDataSets1.Campo('vOutro_W15').Value   := '0.00';
      end;

      if dvServ_W18 > 0 then
      begin
        Form1.spdNFCeDataSets1.Campo('vServ_W18').Value   := FormatFloatXML(dvServ_W18); // Valor Total dos Serviços sob não-incidência ou não tributados pelo ICMS
        if dvBC_W19 > 0 then // 2016-01-14
          Form1.spdNFCeDataSets1.Campo('vBC_W19').Value   := FormatFloatXML(dvBC_W19); // Valor Total dos Serviços sob não-incidência ou não tributados pelo ICMS
        if dvISS_W20 > 0 then // 2016-01-14
          Form1.spdNFCeDataSets1.Campo('vISS_W20').Value    := FormatFloatXML(dvISS_W20); // Valor Total dos Serviços sob não-incidência ou não tributados pelo ICMS
        //Form1.spdNFCeDataSets1.Campo('vPIS_W21').Value    := StrTran(Alltrim(FormatFloat('##0.00', dvPIS_W21)), ',', '.'); // Valor Total dos Serviços sob não-incidência ou não tributados pelo ICMS
        //Form1.spdNFCeDataSets1.Campo('vCOFINS_W22').Value := StrTran(Alltrim(FormatFloat('##0.00', dvCOFINS_W22)), ',', '.'); // Valor Total dos Serviços sob não-incidência ou não tributados pelo ICMS
        Form1.spdNFCeDataSets1.Campo('dCompet_W22a').Value := FormatDateTime('yyyy-mm-dd', dtEnvio)// Data da prestação do serviço
      end;

      //
      Form1.spdNFCeDataSets1.Campo('vII_W11').Value        := '0.00'; // Valor Total do II
      Form1.spdNFCeDataSets1.Campo('vIPI_W12').Value       := '0.00'; // Valor Total do IPI

      Form1.spdNFCeDataSets1.campo('vIPIDevol_W12a').Value := '0.00';//Novo
      Form1.spdNFCeDataSets1.Campo('vPIS_W13').Value       := FormatFloatXML(dvPIS_W13); // Sandro Silva 2016-09-30  '0.00'; // Valor Toal do PIS
      Form1.spdNFCeDataSets1.Campo('vCOFINS_W14').Value    := FormatFloatXML(dvCofins_W14); // Sandro Silva 2016-09-30  '0.00'; // Valor Total do COFINS
      Form1.spdNFCeDataSets1.Campo('vNF_W16').Value        := StrTran(Alltrim(FormatFloat('##0.00',fValorProdutos + dvServ_W18 - fDesconto + dvOutro_W15)),',','.'); // Valor Total da NFe - Versão Trial só aceita NF até R$ 1.00
      Form1.spdNFCeDataSets1.Campo('modFrete_X02').Value   := '9'; //Modalidade do frete: 0- Por conta do emitente; 1- Por conta do destinatário/remetente; 2- Por conta de terceiros; 9- Sem frete.
      //
      // Valor Aproximado dos Tributos IIA Indicie de Imposto Aproximado
      //
      Form1.spdNFCeDataSets1.Campo('vTotTrib_W16a').Value  := FormatFloatXML(fTotalTributos); //
      //
      // Não pode sobrar troco para versão inferior 4.00
      //
      if Form1.ibDataSet25.FieldByName('ACUMULADO3').AsFloat > 0 then
      begin // Troco
        Form1.spdNFCeDataSets1.campo('vTroco_YA09').Value     := FormatFloatXML(Form1.ibDataSet25.FieldByName('ACUMULADO3').AsFloat);// Novo

        // Formas extras NÃO devem ser ajustadas como feito com Dinheiro e cheque.
        // Pode ser vale refeição, sai dinheiro do caixa e fica uma conta para receber da operadora. Mesma situação do cartão de débito/crédito
        // Emitente tira "dinheiro vivo" do caixa para ficar com uma dívida a receber

        if Form1.ibDataSet25.FieldByName('ACUMULADO2').AsFloat = 0.00 then //Dinheiro
        begin

          if Form1.ibDataSet25.FieldByName('VALOR01').AsFloat > 0 then
            Form1.ibDataSet25.FieldByName('VALOR01').AsFloat := Form1.ibDataSet25.FieldByName('VALOR01').AsFloat - Form1.ibDataSet25.FieldByName('ACUMULADO3').AsFloat;

          if Form1.ibDataSet25.FieldByName('VALOR02').AsFloat > 0 then
            Form1.ibDataSet25.FieldByName('VALOR02').AsFloat := Form1.ibDataSet25.FieldByName('VALOR02').AsFloat - Form1.ibDataSet25.FieldByName('ACUMULADO3').AsFloat;

          if Form1.ibDataSet25.FieldByName('VALOR03').AsFloat > 0 then
            Form1.ibDataSet25.FieldByName('VALOR03').AsFloat := Form1.ibDataSet25.FieldByName('VALOR03').AsFloat - Form1.ibDataSet25.FieldByName('ACUMULADO3').AsFloat;

          if Form1.ibDataSet25.FieldByName('VALOR04').AsFloat > 0 then
            Form1.ibDataSet25.FieldByName('VALOR04').AsFloat := Form1.ibDataSet25.FieldByName('VALOR04').AsFloat - Form1.ibDataSet25.FieldByName('ACUMULADO3').AsFloat;

          if Form1.ibDataSet25.FieldByName('VALOR05').AsFloat > 0 then
            Form1.ibDataSet25.FieldByName('VALOR05').AsFloat := Form1.ibDataSet25.FieldByName('VALOR05').AsFloat - Form1.ibDataSet25.FieldByName('ACUMULADO3').AsFloat;

          if Form1.ibDataSet25.FieldByName('VALOR06').AsFloat > 0 then
            Form1.ibDataSet25.FieldByName('VALOR06').AsFloat := Form1.ibDataSet25.FieldByName('VALOR06').AsFloat - Form1.ibDataSet25.FieldByName('ACUMULADO3').AsFloat;

          if Form1.ibDataSet25.FieldByName('VALOR07').AsFloat > 0 then
            Form1.ibDataSet25.FieldByName('VALOR07').AsFloat := Form1.ibDataSet25.FieldByName('VALOR07').AsFloat - Form1.ibDataSet25.FieldByName('ACUMULADO3').AsFloat;

          if Form1.ibDataSet25.FieldByName('VALOR08').AsFloat > 0 then
            Form1.ibDataSet25.FieldByName('VALOR08').AsFloat := Form1.ibDataSet25.FieldByName('VALOR08').AsFloat - Form1.ibDataSet25.FieldByName('ACUMULADO3').AsFloat;

        end; // if Form1.ibDataSet25ACUMULADO2.AsFloat = 0.00 then //Dinheiro

      end;

      //
      // Formas de pagamento
      //
      //
      if Form1.ibDataSet25ACUMULADO1.AsFloat > 0 then
      begin
        //
        // Cheque
        //
        Form1.spdNFCeDataSets1.IncluirPart('YA');
        Form1.spdNFCeDataSets1.Campo('tPag_YA02').Value := NFCE_FORMA_02_CHEQUE;// Sandro Silva 2017-06-15  '02'; //Forma de pagamento: 01- Dinheiro; 02 -Cheque; 03- Cartão de Crédito; 04- Cartão de Débito; 05- Crédito Loja; 10- Vale Alimentação; 11- Vale Refeição; 12- Vale Presente; 13- Vale Combustível; 99 – Outros.
        Form1.spdNFCeDataSets1.Campo('vPag_YA03').Value := FormatFloatXML(Form1.ibDataSet25ACUMULADO1.AsFloat); // Valor Líquido da Fatura
        Form1.spdNFCeDataSets1.SalvarPart('YA');
        //
      end;
      //
      if Form1.ibDataSet25DIFERENCA_.AsFloat > 0 then
      begin
        //
        // Prazo
        //
        Form1.spdNFCeDataSets1.IncluirPart('YA');
        Form1.spdNFCeDataSets1.Campo('tPag_YA02').Value := NFCE_FORMA_05_CREDITO_LOJA;// Sandro Silva 2017-06-15  '05'; //Forma de pagamento: 01- Dinheiro; 02 -Cheque; 03- Cartão de Crédito; 04- Cartão de Débito; 05- Crédito Loja; 10- Vale Alimentação; 11- Vale Refeição; 12- Vale Presente; 13- Vale Combustível; 99 – Outros.
        Form1.spdNFCeDataSets1.Campo('vPag_YA03').Value := FormatFloatXML(Form1.ibDataSet25DIFERENCA_.AsFloat); // Valor Líquido da Fatura
        Form1.spdNFCeDataSets1.SalvarPart('YA');
        //
      end;
      //
      if Form1.ibDataSet25ACUMULADO2.AsFloat > 0 then
      begin
        //
        // Dinheiro
        //
        Form1.spdNFCeDataSets1.IncluirPart('YA');
        Form1.spdNFCeDataSets1.Campo('tPag_YA02').Value := NFCE_FORMA_01_DINHEIRO;// Sandro Silva 2017-06-15  '01'; //Forma de pagamento: 01- Dinheiro; 02 -Cheque; 03- Cartão de Crédito; 04- Cartão de Débito; 05- Crédito Loja; 10- Vale Alimentação; 11- Vale Refeição; 12- Vale Presente; 13- Vale Combustível; 99 – Outros.
        Form1.spdNFCeDataSets1.Campo('vPag_YA03').Value := FormatFloatXML(Form1.ibDataSet25ACUMULADO2.AsFloat); //
        Form1.spdNFCeDataSets1.SalvarPart('YA');
        //
      end;
      //
      // Mover para cima antes das outras formas, depois que Tecnospeed corrigir problema de gerar tag <card> em todas formas quando uma forma for cartão
      if Form1.fTEFPago                      > 0 then
      begin
        //
        // Cartão TEF ou POS
        //
        // Dados Grupo de Cartões
        if (Form1.sTef = 'Sim') then
        begin

          for iTransacaoCartao := 0 to Form1.TransacoesCartao.Transacoes.Count -1 do
          begin

            Form1.sNomeRede := Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].NomeRede;
            //Localiza todos cadastros com OBS contendo o nome da rede ou que o relacionamento = credenciadora de cartão
            Form1.ibDataSet2.Close;
            Form1.ibDataSet2.SelectSQL.Clear;
            Form1.ibDataSet2.SelectSQL.Text :=
              'select * ' +
              'from CLIFOR ' +
              'where (OBS containing ' + QuotedStr(BandeiraSemCreditoDebito(Form1.sNomeRede)) + ' and coalesce(CLIFOR, '''') = ''Credenciadora de cartão'') or coalesce(CLIFOR, '''') = ''Credenciadora de cartão'' ';
            Form1.ibDataSet2.Open;

            sCNPJ_YA05 := SelecionaCNPJCredenciadora(Form1.ibDataSet2, BandeiraSemCreditoDebito(Form1.sNomeRede));

            {Sandro Silva 2023-10-26 inicio
            if AnsiContainsText(sLogErroCredenciadoraCartao, AlertaCredenciadoraCartao(Form1.sNomeRede)) = False then
              sLogErroCredenciadoraCartao := sLogErroCredenciadoraCartao + chr(10) + AlertaCredenciadoraCartao(Form1.sNomeRede) + Chr(10);
            }
            if Trim(sCNPJ_YA05) = '' then
            begin
              if AnsiContainsText(sLogErroCredenciadoraCartao, AlertaCredenciadoraCartao(Form1.sNomeRede)) = False then
                sLogErroCredenciadoraCartao := sLogErroCredenciadoraCartao + chr(10) + AlertaCredenciadoraCartao(Form1.sNomeRede) + Chr(10);
            end;
            {Sandro Silva 2023-10-26 fim}

            Form1.spdNFCeDataSets1.IncluirPart('YA');
            if Pos('CREDITO', Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].DebitoOuCredito) <> 0 then
              Form1.sDebitoOuCredito := 'CREDITO';
            if Pos('DEBITO', Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].DebitoOuCredito) <> 0 then
              Form1.sDebitoOuCredito := 'DEBITO';
            if AllTrim(Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].DebitoOuCredito) = '' then
              Form1.sDebitoOuCredito := 'DEBITO';
            //
            if Form1.sDebitoOuCredito = 'CREDITO' then
            begin
              Form1.spdNFCeDataSets1.Campo('tPag_YA02').Value := NFCE_FORMA_03_CARTAO_CREDITO;// Sandro Silva 2017-06-15  '03'; //Forma de pagamento: 01- Dinheiro; 02 -Cheque; 03- Cartão de Crédito; 04- Cartão de Débito; 05- Crédito Loja; 10- Vale Alimentação; 11- Vale Refeição; 12- Vale Presente; 13- Vale Combustível; 99 – Outros.
            end else
            begin
              Form1.spdNFCeDataSets1.Campo('tPag_YA02').Value := NFCE_FORMA_04_CARTAO_DEBITO;// Sandro Silva 2017-06-15  '04'; //Forma de pagamento: 01- Dinheiro; 02 -Cheque; 03- Cartão de Crédito; 04- Cartão de Débito; 05- Crédito Loja; 10- Vale Alimentação; 11- Vale Refeição; 12- Vale Presente; 13- Vale Combustível; 99 – Outros.
            end;

            {Sandro Silva 2021-07-07 inicio}
            if Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].Modalidade <> tModalidadeCartao then
            begin
              if Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].Modalidade = tModalidadeCarteiraDigital then
                Form1.spdNFCeDataSets1.Campo('tPag_YA02').Value := NFCE_FORMA_18_TRANSFERENCIA_BANCARIA_CARTEIRA_DIGITAL
              else
                if Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].Modalidade = tModalidadePIX then
                  Form1.spdNFCeDataSets1.Campo('tPag_YA02').Value := NFCE_FORMA_17_PAGAMENTO_INSTANTANEO_PIX_DINAMICO
                else
                begin
                  Form1.spdNFCeDataSets1.Campo('tPag_YA02').Value  := NFCE_FORMA_99_OUTROS;// Mudar quando entrar em vigor as novas formas NFCE_FORMA_18_TRANSFERENCIA_BANCARIA_CARTEIRA_DIGITAL;
                  Form1.spdNFCeDataSets1.Campo('xPag_YA02a').Value := ConverteAcentos2(_ecf65_DescricaoFormaExtra99);
                end;
            end;
            {Sandro Silva 2021-07-07 fim}
            //
            Form1.spdNFCeDataSets1.Campo('vPag_YA03').Value := FormatFloatXML(Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].ValorPago); // Valor Líquido da Fatura

            Form1.spdNFCeDataSets1.Campo('tpIntegra_YA04a').Value := '1'; // 1=Pagamento integrado com o sistema de automação da empresa (Ex.: equipamento TEF, Comércio Eletrônico);
            _ecf65_DadosCredenciadoraCartoes(Form1.spdNFCeDataSets1, sCNPJ_YA05, Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].NomeRede, Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].Transaca);

            Form1.spdNFCeDataSets1.SalvarPart('YA');

            // Para adicionar nas informações complementares
            AddDadosTransacaoEletronicaNoComplemento(Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].NomeRede, Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].Transaca, Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].ValorPago);

          end;
        end
        else
        begin

          for iTransacaoCartao := 0 to Form1.TransacoesCartao.Transacoes.Count -1 do
          begin

            Form1.sNomeRede := Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].NomeRede;
            //Localiza todos cadastros com OBS contendo o nome da rede ou que o relacionamento = credenciadora de cartão
            Form1.ibDataSet2.Close;
            Form1.ibDataSet2.SelectSQL.Text :=
              'select * ' +
              'from CLIFOR ' +
              'where (OBS containing ' + QuotedStr(BandeiraSemCreditoDebito(Form1.sNomeRede)) + ' and coalesce(CLIFOR, '''') = ''Credenciadora de cartão'') or coalesce(CLIFOR, '''') = ''Credenciadora de cartão'' ';
            Form1.ibDataSet2.Open;

            sCNPJ_YA05 := SelecionaCNPJCredenciadora(Form1.ibDataSet2, BandeiraSemCreditoDebito(Form1.sNomeRede));

            {Sandro Silva 2023-10-26 inicio
            if AnsiContainsText(sLogErroCredenciadoraCartao, AlertaCredenciadoraCartao(Form1.sNomeRede)) = False then
              sLogErroCredenciadoraCartao := sLogErroCredenciadoraCartao + chr(10) + AlertaCredenciadoraCartao(Form1.sNomeRede) + Chr(10);
            }
            if Trim(sCNPJ_YA05) = '' then
            begin
              if AnsiContainsText(sLogErroCredenciadoraCartao, AlertaCredenciadoraCartao(Form1.sNomeRede)) = False then
                sLogErroCredenciadoraCartao := sLogErroCredenciadoraCartao + Chr(10) + AlertaCredenciadoraCartao(Form1.sNomeRede) + Chr(10);
            end;
            {Sandro Silva 2023-10-26 fim}

            Form1.spdNFCeDataSets1.IncluirPart('YA');
            Form1.sDebitoOuCredito := Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].DebitoOuCredito;

            //
            if Form1.sDebitoOuCredito = 'CREDITO' then
            begin
              Form1.spdNFCeDataSets1.Campo('tPag_YA02').Value := NFCE_FORMA_03_CARTAO_CREDITO;// Sandro Silva 2017-06-15  '03'; //Forma de pagamento: 01- Dinheiro; 02 -Cheque; 03- Cartão de Crédito; 04- Cartão de Débito; 05- Crédito Loja; 10- Vale Alimentação; 11- Vale Refeição; 12- Vale Presente; 13- Vale Combustível; 99 – Outros.
            end else
            begin
              Form1.spdNFCeDataSets1.Campo('tPag_YA02').Value := NFCE_FORMA_04_CARTAO_DEBITO;// Sandro Silva 2017-06-15  '04'; //Forma de pagamento: 01- Dinheiro; 02 -Cheque; 03- Cartão de Crédito; 04- Cartão de Débito; 05- Crédito Loja; 10- Vale Alimentação; 11- Vale Refeição; 12- Vale Presente; 13- Vale Combustível; 99 – Outros.
            end;

            {Sandro Silva 2021-07-07 inicio}
            if Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].Modalidade <> tModalidadeCartao then
            begin
              if Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].Modalidade = tModalidadeCarteiraDigital then
                Form1.spdNFCeDataSets1.Campo('tPag_YA02').Value := NFCE_FORMA_18_TRANSFERENCIA_BANCARIA_CARTEIRA_DIGITAL
              else
                if Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].Modalidade = tModalidadePIX then
                  Form1.spdNFCeDataSets1.Campo('tPag_YA02').Value := NFCE_FORMA_17_PAGAMENTO_INSTANTANEO_PIX_DINAMICO
                else
                begin
                  Form1.spdNFCeDataSets1.Campo('tPag_YA02').Value  := NFCE_FORMA_99_OUTROS;// Mudar quando entrar em vigor as novas formas NFCE_FORMA_18_TRANSFERENCIA_BANCARIA_CARTEIRA_DIGITAL;
                  Form1.spdNFCeDataSets1.Campo('xPag_YA02a').Value := ConverteAcentos2(_ecf65_DescricaoFormaExtra99);
                end;
            end;
            {Sandro Silva 2021-07-07 fim}

            //
            Form1.spdNFCeDataSets1.Campo('vPag_YA03').Value := FormatFloatXML(Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].ValorPago); // Valor Líquido da Fatura

            Form1.spdNFCeDataSets1.Campo('tpIntegra_YA04a').Value := '2'; // 2= Pagamento não integrado com o sistema de automação da empresa (Ex.: equipamento POS);
            if (Form1.sIdentificaPOS = 'Sim') or (Form1.UsaIntegradorFiscal()) then // Sandro Silva 2018-08-06 if (Form1.sIdentificaPOS = 'Sim') then
              _ecf65_DadosCredenciadoraCartoes(Form1.spdNFCeDataSets1, sCNPJ_YA05, Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].NomeRede, Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].Transaca);

            Form1.spdNFCeDataSets1.SalvarPart('YA');

            // Para adicionar nas informações complementares
            AddDadosTransacaoEletronicaNoComplemento(Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].Bandeira, Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].Transaca, Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].ValorPago)
          end;

        end;

        if Trim(sLogErroCredenciadoraCartao) <> '' then
          sLogErroCredenciadoraCartao := sLogErroCredenciadoraCartao + Chr(10);

        //
      end; // if Form1.fTEFPago                      > 0 then

      Mais1ini  := TIniFile.Create('FRENTE.INI');
      if Mais1Ini.ReadString(SECAO_65, CHAVE_FORMAS_CONFIGURADAS, 'Não') = 'Sim' then
      begin

        if Form1.ibDataSet25.FieldByName('VALOR01').AsFloat    <> 0 then
        begin
          _ecf65_AcumulaFormaExtraNFCe(Form1.sOrdemExtraNFCe1, Form1.ibDataSet25.FieldByName('VALOR01').AsFloat, dvPag_YA03_10, dvPag_YA03_11, dvPag_YA03_12, dvPag_YA03_13, dvPag_YA03_16, dvPag_YA03_17, dvPag_YA03_18, dvPag_YA03_19, dvPag_YA03_20, dvPag_YA03_99);
        end;

        if Form1.ibDataSet25.FieldByName('VALOR02').AsFloat    <> 0 then
        begin
          _ecf65_AcumulaFormaExtraNFCe(Form1.sOrdemExtraNFCe2, Form1.ibDataSet25.FieldByName('VALOR02').AsFloat, dvPag_YA03_10, dvPag_YA03_11, dvPag_YA03_12, dvPag_YA03_13, dvPag_YA03_16, dvPag_YA03_17, dvPag_YA03_18, dvPag_YA03_19, dvPag_YA03_20, dvPag_YA03_99);
        end;

        if Form1.ibDataSet25.FieldByName('VALOR03').AsFloat    <> 0 then
        begin
          _ecf65_AcumulaFormaExtraNFCe(Form1.sOrdemExtraNFCe3, Form1.ibDataSet25.FieldByName('VALOR03').AsFloat, dvPag_YA03_10, dvPag_YA03_11, dvPag_YA03_12, dvPag_YA03_13, dvPag_YA03_16, dvPag_YA03_17, dvPag_YA03_18, dvPag_YA03_19, dvPag_YA03_20, dvPag_YA03_99);
        end;

        if Form1.ibDataSet25.FieldByName('VALOR04').AsFloat    <> 0 then
        begin
          _ecf65_AcumulaFormaExtraNFCe(Form1.sOrdemExtraNFCe4, Form1.ibDataSet25.FieldByName('VALOR04').AsFloat, dvPag_YA03_10, dvPag_YA03_11, dvPag_YA03_12, dvPag_YA03_13, dvPag_YA03_16, dvPag_YA03_17, dvPag_YA03_18, dvPag_YA03_19, dvPag_YA03_20, dvPag_YA03_99);
        end;

        if Form1.ibDataSet25.FieldByName('VALOR05').AsFloat    <> 0 then
        begin
          _ecf65_AcumulaFormaExtraNFCe(Form1.sOrdemExtraNFCe5, Form1.ibDataSet25.FieldByName('VALOR05').AsFloat, dvPag_YA03_10, dvPag_YA03_11, dvPag_YA03_12, dvPag_YA03_13, dvPag_YA03_16, dvPag_YA03_17, dvPag_YA03_18, dvPag_YA03_19, dvPag_YA03_20, dvPag_YA03_99);
        end;

        if Form1.ibDataSet25.FieldByName('VALOR06').AsFloat    <> 0 then
        begin
          _ecf65_AcumulaFormaExtraNFCe(Form1.sOrdemExtraNFCe6, Form1.ibDataSet25.FieldByName('VALOR06').AsFloat, dvPag_YA03_10, dvPag_YA03_11, dvPag_YA03_12, dvPag_YA03_13, dvPag_YA03_16, dvPag_YA03_17, dvPag_YA03_18, dvPag_YA03_19, dvPag_YA03_20, dvPag_YA03_99);
        end;

        if Form1.ibDataSet25.FieldByName('VALOR07').AsFloat    <> 0 then
        begin
          _ecf65_AcumulaFormaExtraNFCe(Form1.sOrdemExtraNFCe7, Form1.ibDataSet25.FieldByName('VALOR07').AsFloat, dvPag_YA03_10, dvPag_YA03_11, dvPag_YA03_12, dvPag_YA03_13, dvPag_YA03_16, dvPag_YA03_17, dvPag_YA03_18, dvPag_YA03_19, dvPag_YA03_20, dvPag_YA03_99);
        end;

        if Form1.ibDataSet25.FieldByName('VALOR08').AsFloat    <> 0 then
        begin
          _ecf65_AcumulaFormaExtraNFCe(Form1.sOrdemExtraNFCe8, Form1.ibDataSet25.FieldByName('VALOR08').AsFloat, dvPag_YA03_10, dvPag_YA03_11, dvPag_YA03_12, dvPag_YA03_13, dvPag_YA03_16, dvPag_YA03_17, dvPag_YA03_18, dvPag_YA03_19, dvPag_YA03_20, dvPag_YA03_99);
        end;

        if dvPag_YA03_10 > 0 then
          _ecf65_AdicionaPagamento(NFCE_FORMA_10_VALE_ALIMENTACAO, FormatFloatXML(dvPag_YA03_10)); // 10=Vale Alimentação

        if dvPag_YA03_11 > 0 then
          _ecf65_AdicionaPagamento(NFCE_FORMA_11_VALE_REFEICAO, FormatFloatXML(dvPag_YA03_11)); // 11=Vale Refeição

        if dvPag_YA03_12 > 0 then
          _ecf65_AdicionaPagamento(NFCE_FORMA_12_VALE_PRESENTE, FormatFloatXML(dvPag_YA03_12)); // 12=Vale Presente

        if dvPag_YA03_13 > 0 then
          _ecf65_AdicionaPagamento(NFCE_FORMA_13_VALE_COMBUSTIVEL, FormatFloatXML(dvPag_YA03_13)); // 13=Vale Combustível

        {Sandro Silva 2021-03-05 inicio}
        if dvPag_YA03_16 > 0 then
          _ecf65_AdicionaPagamento(NFCE_FORMA_16_DEPOSITO_BANCARIO, FormatFloatXML(dvPag_YA03_16)); // 16=Depósito Bancário

        if dvPag_YA03_17 > 0 then
        begin
          _ecf65_AdicionaPagamento(NFCE_FORMA_17_PAGAMENTO_INSTANTANEO_PIX_DINAMICO, FormatFloatXML(dvPag_YA03_17)); // 17=Pagamento Instantâneo (PIX)
        end;

        if dvPag_YA03_18 > 0 then
          _ecf65_AdicionaPagamento(NFCE_FORMA_18_TRANSFERENCIA_BANCARIA_CARTEIRA_DIGITAL, FormatFloatXML(dvPag_YA03_18)); // 18=Transferência bancária, Carteira Digital

        if dvPag_YA03_19 > 0 then
          _ecf65_AdicionaPagamento(NFCE_FORMA_19_PROGRAMA_FIDELIDADE_CASHBACK_CREDITO_VIRTUAL, FormatFloatXML(dvPag_YA03_19)); // 19=Programa de fidelidade, Cashback, Crédito Virtual
        {Sandro Silva 2021-03-05 fim}

        if dvPag_YA03_20 > 0 then
          _ecf65_AdicionaPagamento(NFCE_FORMA_20_PAGAMENTO_INSTANTANEO_PIX_ESTATICO, FormatFloatXML(dvPag_YA03_20)); // 20=Pagamento Instantâneo (PIX)

        if dvPag_YA03_99 > 0 then
          _ecf65_AdicionaPagamento(NFCE_FORMA_99_OUTROS, FormatFloatXML(dvPag_YA03_99)); // 99=Outros
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
          //
          Form1.spdNFCeDataSets1.IncluirPart('YA');
          Form1.spdNFCeDataSets1.Campo('tPag_YA02').Value := NFCE_FORMA_99_OUTROS;// Sandro Silva 2017-06-15  '99'; //Forma de pagamento: 01- Dinheiro; 02 -Cheque; 03- Cartão de Crédito; 04- Cartão de Débito; 05- Crédito Loja; 10- Vale Alimentação; 11- Vale Refeição; 12- Vale Presente; 13- Vale Combustível; 99 – Outros.
          Form1.spdNFCeDataSets1.Campo('vPag_YA03').Value := FormatFloatXML((Form1.ibDataSet25.FieldByName('VALOR01').AsFloat +
                                                                             Form1.ibDataSet25.FieldByName('VALOR02').AsFloat +
                                                                             Form1.ibDataSet25.FieldByName('VALOR03').AsFloat +
                                                                             Form1.ibDataSet25.FieldByName('VALOR04').AsFloat +
                                                                             Form1.ibDataSet25.FieldByName('VALOR05').AsFloat +
                                                                             Form1.ibDataSet25.FieldByName('VALOR06').AsFloat +
                                                                             Form1.ibDataSet25.FieldByName('VALOR07').AsFloat +
                                                                             Form1.ibDataSet25.FieldByName('VALOR08').AsFloat)); // Valor Líquido da Fatura
          //
          Form1.spdNFCeDataSets1.SalvarPart('YA');
          //
        end;
      end;

      if Form1.ibDataSet25.FieldByName('ACUMULADO3').AsFloat > 0 then // Troco
      begin
        Form1.spdNFCeDataSets1.IncluirPart('YA');
        Form1.spdNFCeDataSets1.Campo('vTroco_YA09').Value  := FormatFloatXML(Form1.ibDataSet25.FieldByName('ACUMULADO3').AsFloat); //
        Form1.spdNFCeDataSets1.SalvarPart('YA');
      end;

      Mais1ini.Free;
      //

      Form1.spdNFCeDataSets1.Campo('infAdFisco_Z02').Value := ''; // Dados Adicionais da NFe - Observações Interesse do Fisco

      if dvFCP_W04h > 0 then
        Form1.spdNFCeDataSets1.Campo('infAdFisco_Z02').Value := 'Total do FCP:R$' + FormatFloat('0.00', dvFCP_W04h);

      //
      Form1.spdNFCeDataSets1.Campo('infCpl_Z03').Value := AllTrim(StrTran(ConverteAcentosXML(Form1.sMensagemPromocional),Chr(10),'')); // Mensagem do interesce do consumidor // Sandro Silva 2016-05-24 ConverteAcentos2()

      if (Pos('pafnfce', AnsiLowerCase(ExtractFileName(Application.ExeName))) > 0) or (PAFNFCe) then // Sandro Silva 2021-06-10 if Pos('pafnfce', AnsiLowerCase(ExtractFileName(Application.ExeName))) > 0 then
      begin // ER 02.03 Requisito XXVIII, item 3.a)
        if Form1.List_paramentros.Count > 0 then
          Form1.spdNFCeDataSets1.Campo('infCpl_Z03').Value := Form1.spdNFCeDataSets1.Campo('infCpl_Z03').Value + '|' + ' - MD-5: ' + StringReplace(Form1.List_paramentros[0], 'URB', '', [rfIgnoreCase]);// Sandro Silva 2016-03-07 POLIMIG Não alterar prefixo 'URB'
      end;

      if Form1.ibDataSet25DIFERENCA_.AsFloat <> 0 then
        Form1.spdNFCeDataSets1.Campo('infCpl_Z03').Value := Form1.spdNFCeDataSets1.Campo('infCpl_Z03').Value + _ecf65_DadosCarneNoXML();// Pipe "|" faz quebra de linha Sandro Silva 2017-10-05  Form1.spdNFCeDataSets1.Campo('infCpl_Z03').Value := svNF_W16 + ' ' + sValorRecebido + ' ' + sValorTroco + ' ' + Form1.spdNFCeDataSets1.Campo('infCpl_Z03').Value;

      {Sandro Silva 2023-05-19 inicio
      Form1.spdNFCeDataSets1.Campo('infCpl_Z03').Value := Form1.spdNFCeDataSets1.Campo('infCpl_Z03').Value + '|' + sDadosTransacaoEletronicaNoComplemento; // Sandro Silva 2023-03-28
      }
      if Trim(sDadosTransacaoEletronicaNoComplemento) <> '' then
        Form1.spdNFCeDataSets1.Campo('infCpl_Z03').Value := Form1.spdNFCeDataSets1.Campo('infCpl_Z03').Value + '|' + sDadosTransacaoEletronicaNoComplemento; // Sandro Silva 2023-03-28

      {Sandro Silva 2023-09-05 inicio
      if dvICMSMonoRet_N45Total > 0.00 then
        Form1.spdNFCeDataSets1.Campo('infCpl_Z03').Value := Form1.spdNFCeDataSets1.Campo('infCpl_Z03').Value + '|' + 'ICMS monofásico sobre combustíveis cobrado anteriormente conforme Convênio ICMS 199/2022;';
      }
      if (sMensagemIcmMonofasicoSobreCombustiveis <> '') and (AnsiContainsText(Form1.spdNFCeDataSets1.Campo('infCpl_Z03').Value, sMensagemIcmMonofasicoSobreCombustiveis) = False) then
        Form1.spdNFCeDataSets1.Campo('infCpl_Z03').Value := Form1.spdNFCeDataSets1.Campo('infCpl_Z03').Value + '|' + sMensagemIcmMonofasicoSobreCombustiveis;
      {Sandro Silva 2023-09-05 fim}

      {Sandro Silva 2023-05-19 fim}

      //
      // SAIDA
      //
      if LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString) <> '' then
      begin
        Form1.spdNFCeDataSets1.Campo('CRT_C21').Value := LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString); // 1 - Simples nacional 2 - Simples Nacional excesso 3 - Regime normal
      end else
      begin
        Form1.spdNFCeDataSets1.Campo('CRT_C21').Value := '1'; // 1 - Simples nacional 2 - Simples Nacional excesso 3 - Regime normal
      end;
      //
      // Apenas configuração para servidor versão 3.10. O servidor 3.00 foi desativado
      Form1.spdNFCeDataSets1.Campo('versao_A02').Value := '4.00'; // Versão do Layout que está utilizando - Manual 4.0
      //
      // Salva DataSets e Converte em XML montando um LOTE de XMLS a ser assinados
      //
      try
        Form1.spdNFCeDataSets1.Salvar; // Salva DataSets e Converte em XML montando um LOTE de XMLS a ser assinados
      except
        on E: Exception do
        begin
          //
          sLogErro := sLogErroCredenciadoraCartao + 'Erro: 21' + Chr(10) + E.Message+chr(10)+
            chr(10)+'Leia atentamente a mensagem acima e tente resolver o problema. Considere pedir ajuda ao seu contador para o preenchimento correto da NFC-e.';

          sStatus := E.Message;
          Exit;
          //
        end;
      end;

      ////
      // Final geração do xml
      ////

      //
      // Assinando
      //
      try
        //
        fNFe := Form1.spdNFCeDataSets1.LoteNFCe.GetText;  //Copia XML que está Componente p/ Field fNFe
        //
      except
        //
        sLogErro := sLogErroCredenciadoraCartao + 'Erro ao gravar NFC-e';
        sStatus := sLogErro;
        Exit;
        //
      end;


      //validar se a soma dos pagamentos fecha com o total da nota menos o troco?

      //
      // Assinando
      //
      try
        //
        fNFe := Form1.spdNFCe1.AssinarNota(fNFe);
        wsNFCeAssinada := fNFe; // Sandro Silva 2015-03-31 XML assinado para gravar em NFCE.NFEXML se ocorrer rejeição;
        //
      except
        //
        sLogErro := sLogErroCredenciadoraCartao + 'Erro ao assinar NFC-e';
        sStatus := sLogErro;
        Exit;
        //
      end;
      //
      try
        if _ecf65_LoadXmlDestinatario(Form1.ibDataSet150.FieldByName('NFEID').AsString) <> '' then // Sandro Silva 2024-02-16 if _ecf65_LoadXmlDestinatario(PAnsiChar(Form1.ibDataSet150.FieldByName('NFEID').AsString)) <> '' then
        begin
          if (Form1.ibDataSet150.State in [dsEdit, dsInsert]) = False then
            Form1.ibDataSet150.Edit;
          Form1.ibDataSet150.FieldByName('NFEXML').AsString := _ecf65_LoadXmlDestinatario(Form1.ibDataSet150.FieldByName('NFEID').AsString); // Sandro Silva 2024-02-16 Form1.ibDataSet150.FieldByName('NFEXML').AsString := _ecf65_LoadXmlDestinatario(PAnsiChar(Form1.ibDataSet150.FieldByName('NFEID').AsString));
        end;
      except
      end;
      //
      sLote := FormataNumeroDoCupom(Form1.iCupom); 
      //
      try
        if Form1.DANFCEdetalhado1.Checked then
          Form1.spdNFCe1.DanfceSettings.ExibirDetalhamento := True
        else
          Form1.spdNFCe1.DanfceSettings.ExibirDetalhamento := False;
      except
        on E: Exception do
        begin
          sLogErro := E.Message+chr(10)+chr(10)+'Ao configurar a exibição do detalhamento';
        end;
      end;

      //
      if not Form1.NFCeemContingncia1.Checked then // SERVIÇO ONLINE   não é contingência
      begin
        //
        // Transmitindo
        //

        try
          _ecf65_NumeroSessaoIntegradorFiscal; // Sandro Silva 2018-04-23

          try // Sandro Silva 2021-09-13
            sRetorno := Form1.spdNFCe1.EnviarNFSincrono(sLote, fNFe, False); /// TRANSMITE NFC-E
          except
            on E: Exception do
            begin
              sLogErro := E.Message+chr(10)+chr(10)+'Ao enviar sincrono';
              sStatus := sLogErro;
              Exit; // Sandro Silva 2021-11-05

            end;
          end;

          sRetorno := _ecf65_CorrigePadraoRespostaSefaz(sRetorno);

          {Sandro Silva 2021-12-02 inicio}

          if (Trim(sRetorno) = '') or (AnsiContainsText(Trim(sRetorno), '<cStat>') = False) then  // Sem Retorno ou sem cStat
          begin
            // Não retornando nada da SEFAZ (caso de MG) faz 3 tentativas de consultar e enviar antes de entrar no fluxo de emissão de contingência para cancelamento por substituição
            for iTentaConsulta := 1 to 3 do
            begin

              Form1.Display('Aguarde! Consultando NFC-e na SEFAZ', 'Aguarde! Consultando NFC-e na SEFAZ. Tentativa ' + IntToStr(iTentaConsulta) + ' de 3...');

              Application.ProcessMessages; // Somente aqui para atualizar mensagem
              sRetorno := _ecf65_ConsultaIdNFCeEnviadaSemRespostaFazendoReenvio(Form1.spdNFCe1, sLote, fNFe);
              if Trim(sRetorno) <> '' then
                Break;
            end;

            Form1.OcultaPanelMensagem;
          end;
          {Sandro Silva 2021-12-02 fim}
          Sleep(100);
          //
          // Permite simular a situação que não há retorno da Sefaz para o método de envio
          sRetorno := _ecf65_SimulaSemRetornoSefaz(sRetorno); // Sandro Silva 2020-06-25

          // Permite simular a situação de uso denegado
          sRetorno := _ecf65_SimulaRetornoUsoDenegado(sRetorno); // Sandro Silva 2020-05-13
          //
          ////////////////////////////

          if (Trim(sRetorno) = '') or (AnsiContainsText(Trim(sRetorno), '<cStat>') = False) then  // Sem Retorno ou sem cStat
          begin
            sRetorno := NFCE_NAO_HOUVE_RETORNO_SERVIDOR;

            {Sandro Silva 2022-07-14 inicio}
            try
              Audita('EMISSAO','FRENTE', '', ' Sem retorno ' + ExtractFileName(Application.ExeName) + ' ' + LimpaNumero(Form22.sBuild) + ' ' + StrZero(Form1.iCupom,6,0) + ' ' + Form1.sCaixa,0,0); // Ato, Modulo, Usuário, Histórico, Valor // Sandro Silva 2019-03-06
            except

            end;
            {Sandro Silva 2022-07-14 fim}

          end;

        except
          on E: Exception do
          begin
            sLogErro := E.Message+chr(10)+chr(10)+'Ao enviar sincrono';
          end;
        end;
        //
        Sleep(100);
        {
        //
        // Permite simular a situação que não há retorno da Sefaz para o método de envio
        sRetorno := _ecf65_SimulaSemRetornoSefaz(sRetorno); // Sandro Silva 2020-06-25

        sRetorno := _ecf65_SimulaRetornoUsoDenegado(sRetorno); // Sandro Silva 2020-05-13
        //
        ////////////////////////////
        }

        // Sandro Silva 2022-04-12 if ((Pos('<cStat>100</cStat>',sRetorno) <> 0) or (Pos('<cStat>150</cStat>',sRetorno) <> 0)) // Sandro Silva 2018-08-10
        if _ecf65_xmlAutorizado(sRetorno)
          and (xmlNodeValue(sRetorno, '//infProt/digVal') = xmlNodeValue(fNFe, '//DigestValue')) then // 100|Autorizado o uso da NF-e ou 150|Autorizado o uso da NF-e, autorização fora de prazo; e o DIGEST autorizado é o mesmo dos dados enviados
        begin
          //
          Sleep(100);// Aguarda tempo do sistema operacional gravar o arquivo na pasta xmldestinatario
          sID  := Copy(Form1.spdNFCeDataSets1.Campo('Id_A03').AsString,4,44);

          fNFE := _ecf65_LoadXmlDestinatario(sID);

          {Sandro Silva 2021-06-09 inicio}
          if AnsiUpperCase(Form1.ibDataSet13.FieldByName('ESTADO').AsString) = 'MG' then
          begin
            if Pos('<?xml', String(fNFe)) = 0 then
              fNFE := '<?xml version="1.0" encoding="UTF-8"?>' + fNFe;
          end;
          {Sandro Silva 2021-06-09 fim}

          //
          // Sandro Silva 2022-04-12 if (Pos('<cStat>100</cStat>',fNFE) <> 0) or (Pos('<cStat>150</cStat>',fNFE) <> 0) then // 100|Autorizado o uso da NF-e ou 150|Autorizado o uso da NF-e, autorização fora de prazo Sandro Silva 2018-08-10
          if _ecf65_xmlAutorizado(fNFE) then
          begin
            if Form1.spdNFCe1.Ambiente = akHomologacao then
            begin
              sStatus := NFCE_STATUS_AUTORIZADO_USO_EM_HOMOLOGACAO;// 'Autorizado o uso da NFC-e em ambiente de homologação';
            end else
            begin
              sStatus := NFCE_STATUS_AUTORIZADO_USO_EM_PRODUCAO;// 'Autorizado o uso da NFC-e';
            end;
          end;
          //
        end else
        begin
          //e se no retorno tiver cstat 100 de outro digest?
          //
          //
          if (Pos('<cStat>204</cStat>',sRetorno) <> 0) or (Pos('<cStat>539</cStat>',sRetorno) <> 0) // Duplicidade
             or
             (Pos('<cStat>206</cStat>',sRetorno) <> 0) or (Pos('<cStat>256</cStat>',sRetorno) <> 0) // Inutilizada
             or
              _ecf65_UsoDenegado(sRetorno)// Sandro Silva 2020-05-13
          then
          begin
            //
            if (Form1.ClienteSmallMobile.sVendaImportando <> '') then
            begin
              if AnsiContainsText(xmlNodeValue(sRetorno, '//infProt/xMotivo'), 'inutilizada') then
                sLogErro := 'Esta numeração já foi inutilizada.' + #13 + xmlNodeValue(sRetorno, '//infProt/xMotivo')
              else
                if AnsiContainsText(xmlNodeValue(sRetorno, '//infProt/xMotivo'), 'duplicidade') then
                  sLogErro := 'Esta numeração já foi utilizada.' + #13 + xmlNodeValue(sRetorno, '//infProt/xMotivo')
                else
                  if _ecf65_UsoDenegado(sRetorno) then // Sandro Silva 2020-05-13
                    sLogErro := 'Uso denegado.' + #13 + xmlNodeValue(sRetorno, '//infProt/xMotivo')
                  else
                    sLogErro := xmlNodeValue(sRetorno, '//infProt/xMotivo');

              // Sandro Silva 2016-04-29 Aqui mudar para excluir a nota apenas se não conseguir consultar a chave
              // e não encontrar o xml de envio com mesmo digest da autorização retornado na consulta

              try
                Form1.ibDataset150.Close;
                Form1.ibDataset150.SelectSql.Clear;
                Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF='+QuotedStr(FormataNumeroDoCupom(Form1.iCupom)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa) + ' and MODELO = ' + QuotedStr('65')); // Sandro Silva 2021-11-29 Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF='+QuotedStr(StrZero(Form1.iCupom,6,0)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa) + ' and MODELO = ' + QuotedStr('65'));
                Form1.ibDataset150.Open;
                {Sandro Silva 2023-07-20 inicio}
                sNumeroGerencialConvertido := Form1.ibDataset150.FieldByName('GERENCIAL').AsString; //  Recupera o número da venda gerencial, caso tenha sido importada
                {Sandro Silva 2023-07-20 fim}
                Form1.ibDataset150.Delete;

                Form1.ibDataset150.Close;
                Form1.ibDataset150.SelectSql.Clear;
                Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF=' + QuotedStr(FormataNumeroDoCupom(0)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa)); // Sandro Silva 2021-12-02 Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF=''000000'' and CAIXA = ' + QuotedStr(Form1.sCaixa));
                Form1.ibDataset150.Open;

                Form1.IBDataSet150.Append;
                {Sandro Silva 2023-07-20 inicio}
                if sNumeroGerencialConvertido <> '' then
                  Form1.IBDataSet150.FieldByName('GERENCIAL').AsString := sNumeroGerencialConvertido;
                {Sandro Silva 2023-07-20 fim}

                if Pos(TIPOCONTINGENCIA, Form1.ClienteSmallMobile.sVendaImportando) > 0 then
                  Form1.IBDataSet150.FieldByName('NFEXML').AsString := fNFE //  Tentando transmitir contingência com falha de schema
                else
                  Form1.IBDataSet150.FieldByName('NFEXML').AsString := sRetorno;
                Form1.IBDataSet150.FieldByName('STATUS').AsString   := Copy(xmlNodeValue(sRetorno, '//infProt/xMotivo'),1,Form1.IBDataSet150.FieldByName('STATUS').Size);
                Form1.IBDataSet150.FieldByName('NUMERONF').AsString := FormataNumeroDoCupom(Form1.iCupom); // Sandro Silva 2021-11-29 Form1.IBDataSet150.FieldByName('NUMERONF').AsString := StrZero(Form1.iCupom,6,0);
                Form1.IBDataSet150.FieldByName('DATA').AsDateTime   := dtEnvio;
                Form1.IBDataSet150.FieldByName('CAIXA').AsString    := Form1.sCaixa;
                Form1.IBDataSet150.FieldByName('MODELO').AsString   := '65';
                if xmlNodeValue(sRetorno, '//vNF') <> '' then
                  Form1.IBDataSet150.FieldByName('TOTAL').AsFloat   := xmlNodeValueToFloat(sRetorno, '//vNF'); // Ficha 4302 Sandro Silva 2018-12-05
                Form1.IBDataSet150.Post;

                // Troca ALTERACA.DATA
                Form1.ibDataSet27.First;
                while Form1.ibDataSet27.Eof = False do
                begin

                  try
                    Form1.ibDataSet27.Edit;
                    Form1.ibDataSet27.FieldByName('DATA').AsDateTime := dtEnvio;
                    Form1.ibDataSet27.Post;
                  except
                  end;

                  Form1.ibDataSet27.Next;
                end;

                // Troca PAGAMENT.DATA
                Form1.IBDataSet28.First;
                while Form1.IBDataSet28.Eof = False do
                begin

                  try
                    Form1.IBDataSet28.Edit;
                    Form1.IBDataSet28.FieldByName('DATA').AsDateTime := dtEnvio;
                    Form1.IBDataSet28.Post;
                  except
                  end;

                  Form1.IBDataSet28.Next;
                end;

                // Troca RECEBER.EMISSAO
                Form1.ibDataSet7.First;
                while Form1.ibDataSet7.Eof = False do
                begin
                  if (Form1.ibDataSet7.FieldByName('NUMERONF').AsString = FormataNumeroDoCupom(Form1.icupom)+Copy(Form1.sCaixa, 1, 3)) then // Sandro Silva 2021-11-29 if (Form1.ibDataSet7.FieldByName('NUMERONF').AsString = StrZero(Form1.icupom,6,0)+Copy(Form1.sCaixa, 1, 3)) then
                  begin

                    try
                      Form1.ibDataSet7.Edit;
                      Form1.ibDataSet7.FieldByName('NUMERONF').AsString  := FormataNumeroDoCupom(Form1.iCupom) + Copy(Form1.sCaixa, 1, 3); // Sandro Silva 2021-11-29 Form1.ibDataSet7.FieldByName('NUMERONF').AsString  := StrZero(Form1.iCupom, 6, 0) + Copy(Form1.sCaixa, 1, 3);
                      Form1.ibDataSet7.FieldByName('DOCUMENTO').AsString := Form1.sCaixa + FormataNumeroDoCupom(Form1.iCupom) + RightStr(Form1.ibDataSet7.FieldByName('DOCUMENTO').AsString, 1); // Sandro Silva 2021-11-29 Form1.ibDataSet7.FieldByName('DOCUMENTO').AsString := Form1.sCaixa + StrZero(Form1.iCupom, 6, 0) + RightStr(Form1.ibDataSet7.FieldByName('DOCUMENTO').AsString, 1);
                      Form1.ibDataSet7.FieldByName('EMISSAO').AsDateTime := dtEnvio; // Sandro Silva 2016-04-27
                      Form1.ibDataSet7.Post;
                    except
                    end;

                  end;
                  Form1.ibDataSet7.Next;
                end;

              except

              end;

              Exit;

            end
            else
            begin
              if (Pos('<cStat>206</cStat>', sRetorno) <> 0) or (Pos('<cStat>256</cStat>', sRetorno) <> 0) then // Sandro Silva 2018-03-28
              begin
                bButton := Application.MessageBox(PChar('Esta numeração foi inutilizada .' + chr(10) + chr(10) + 'Definir um novo número para esta NFC-e?'), 'Atenção NFC-e Inutilizada ', mb_YesNo + mb_DefButton1 + MB_ICONWARNING)
              end
              else
              begin
                if _ecf65_UsoDenegado(sRetorno) then // Sandro Silva 2020-05-13
                begin

                  sMensagemAlertaUsoDenegado := 'Esta numeração teve uso denegado.' + chr(10) + chr(10) + xmlNodeValue(sRetorno, '//xMotivo');

                  if xmlNodeValue(sRetorno, '// infProt/cStat') = '301' then // 301 Uso Denegado: Irregularidade fiscal do emitente
                    sMensagemAlertaUsoDenegado := sMensagemAlertaUsoDenegado + chr(10) + chr(10) + 'Considere resolver a irregularidade junto ao Fisco';

                  if (xmlNodeValue(sRetorno, '// infProt/cStat') = '302')   // 302 Uso Denegado: Irregularidade fiscal do destinatário
                   or (xmlNodeValue(sRetorno, '// infProt/cStat') = '303')  // 303 Uso Denegado: Destinatário não habilitado a operar na UF
                  then
                    sMensagemAlertaUsoDenegado := sMensagemAlertaUsoDenegado + chr(10) + chr(10) + 'Considere escolher outro destinatário';

                  sMensagemAlertaUsoDenegado := sMensagemAlertaUsoDenegado + chr(10) + chr(10) + 'Clique Não: Para cancelar a venda e voltar os produtos para o estoque' +
                                                                             chr(10) + chr(10) + 'Clique Sim: Para definir um novo número para esta NFC-e?';

                  bButton := Application.MessageBox(PChar(sMensagemAlertaUsoDenegado), 'Atenção NFC-e com Uso Denegado', mb_YesNo + mb_DefButton1 + MB_ICONWARNING)

                end
                else
                  bButton := Application.MessageBox(PChar('Esta numeração já foi utilizada.' + chr(10) + chr(10) + 'Definir um novo número para esta NFC-e?'), 'Atenção Duplicidade de NFC-e', mb_YesNo + mb_DefButton1 + MB_ICONWARNING);
              end;

            end;// if (Form1.ClienteSmallMobile.sVendaImportando <> '') then

            //
            if bButton = IDYES then
            begin
              try
                sNovoNumero := FormataNumeroDoCupom(0); // Sandro Silva 2021-12-02 sNovoNumero := '000000';
                while Form1.iCupom >= StrToInt(sNovoNumero) do
                begin
                  sNovoNumero := FormataNumeroDoCupom(IncrementaGenerator('G_NUMERONFCE', 1)); // Sandro Silva 2021-12-02 sNovoNumero := StrZero(IncrementaGenerator('G_NUMERONFCE', 1), 6, 0);
                  Sleep(10); // Sandro Silva 2020-05-20
                end;

                sDAV     := '';
                sTIPODAV := '';

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

                // Não precisa selecionar novamente. Os itens já estão selecionados

                Form1.ibDataSet27.First;

                while Form1.ibDataSet27.Eof = False do
                begin

                  if (sDAV = '')
                    and (Form1.ibDataSet27.FieldByName('DAV').AsString <> '')
                    and (Form1.ibDataSet27.FieldByName('TIPODAV').AsString <> '') then
                  begin
                    // Identifica o primeiro DAV que encontrar nos itens da venda
                    sDAV     := Form1.ibDataSet27.FieldByName('DAV').AsString;
                    sTIPODAV := Form1.ibDataSet27.FieldByName('TIPODAV').AsString;
                    Break;
                  end;

                  Form1.ibDataSet27.Next;

                end;

                // Em outro dataset da conflito
                try
                  // Precisa assinar o registro depois de atualizado. BeforePost faz isso
                  Form1.ibDataSet27.First;
                  while Form1.ibDataSet27.Eof = False do
                  begin

                    try
                      Form1.ibDataSet27.Edit;
                      Form1.ibDataSet27.FieldByName('PEDIDO').AsString := sNovoNumero;
                      Form1.ibDataSet27.FieldByName('COO').Clear; // Sandro Silva 2017-09-14
                      Form1.ibDataSet27.FieldByName('CCF').Clear; // Sandro Silva 2017-09-14 CCF preenchido após autorizada
                      Form1.ibDataSet27.Post;
                    except
                    end;

                    Form1.ibDataSet27.Next;
                  end;
                except

                end;

                // Pagament
                Form1.IBDataSet28.First;
                while Form1.IBDataSet28.Eof = False do
                begin

                  try
                    Form1.IBDataSet28.Edit;
                    Form1.IBDataSet28.FieldByName('CAIXA').AsString  := Form1.sCaixa;
                    Form1.IBDataSet28.FieldByName('PEDIDO').AsString := sNovoNumero;
                    Form1.IBDataSet28.FieldByName('COO').AsString    := sNovoNumero;
                    Form1.IBDataSet28.FieldByName('CCF').AsString    := sNovoNumero;
                    Form1.IBDataSet28.Post;
                  except
                  end;

                  Form1.IBDataSet28.Next;
                end;

                // Receber
                Form1.ibDataSet7.First;
                while Form1.ibDataSet7.Eof = False do
                begin
                  if (Form1.ibDataSet7.FieldByName('NUMERONF').AsString = FormataNumeroDoCupom(Form1.icupom)+Copy(Form1.sCaixa, 1, 3)) then // Sandro Silva 2021-11-29 if (Form1.ibDataSet7.FieldByName('NUMERONF').AsString = StrZero(Form1.icupom,6,0)+Copy(Form1.sCaixa, 1, 3)) then
                  begin

                    try
                      Form1.ibDataSet7.Edit;
                      Form1.ibDataSet7.FieldByName('NUMERONF').AsString  := FormataNumeroDoCupom(StrToInt(sNovoNumero)) + Copy(Form1.sCaixa, 1, 3); // Sandro Silva 2021-11-29 Form1.ibDataSet7.FieldByName('NUMERONF').AsString  := StrZero(StrToInt(sNovoNumero), 6, 0) + Copy(Form1.sCaixa, 1, 3);
                      Form1.ibDataSet7.FieldByName('HISTORICO').AsString := StringReplace(Form1.ibDataSet7.FieldByName('HISTORICO').AsString, FormataNumeroDoCupom(Form1.icupom), FormataNumeroDoCupom(StrToInt(sNovoNumero)), [rfReplaceAll]); // Sandro Silva 2021-11-29 Form1.ibDataSet7.FieldByName('HISTORICO').AsString := StringReplace(Form1.ibDataSet7.FieldByName('HISTORICO').AsString, StrZero(Form1.icupom, 6, 0), StrZero(StrToInt(sNovoNumero), 5, 0), [rfReplaceAll]);
                      Form1.ibDataSet7.FieldByName('DOCUMENTO').AsString := Form1.sCaixa + FormataNumeroDoCupom(StrToInt(sNovoNumero)) + RightStr(Form1.ibDataSet7.FieldByName('DOCUMENTO').AsString, 1); // Sandro Silva 2021-11-29 Form1.ibDataSet7.FieldByName('DOCUMENTO').AsString := Form1.sCaixa + StrZero(StrToInt(sNovoNumero),6,0) + RightStr(Form1.ibDataSet7.FieldByName('DOCUMENTO').AsString, 1);
                      Form1.ibDataSet7.Post;
                    except
                    end;
                  end;

                  Form1.ibDataSet7.Next;
                end;

                Form1.ibDataset150.Close;
                Form1.ibDataset150.SelectSql.Clear;
                Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF='+QuotedStr(FormataNumeroDoCupom(Form1.iCupom)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa) + ' and MODELO = ' + QuotedStr('65'));
                Form1.ibDataset150.Open;

                if _ecf65_UsoDenegado(sRetorno) then // Sandro Silva 2020-05-13
                begin
                  // Retornou uso denegado e escolheu nova numeração salva a nota atual com informações de uso denegado

                  Form1.IBDataSet150.Edit;
                  Form1.IBDataSet150.FieldByName('NFEXML').AsString := sRetorno;
                  Form1.IBDataSet150.FieldByName('NFEID').AsString  := xmlNodeValue(sRetorno, '//chNFe');
                  Form1.IBDataSet150.FieldByName('STATUS').AsString := Copy(xmlNodeValue(sRetorno, '//infProt/xMotivo'),1,Form1.IBDataSet150.FieldByName('STATUS').Size);
                  Form1.IBDataSet150.FieldByName('DATA').AsDateTime := dtEnvio;
                  Form1.IBDataSet150.FieldByName('CAIXA').AsString  := Form1.sCaixa;
                  Form1.IBDataSet150.FieldByName('TOTAL').AsFloat   := 0.00;
                  Form1.IBDataSet150.Post;

                end
                else
                begin

                  try
                    if Form1.ibDataset150.FieldByName('NUMERONF').AsString = FormataNumeroDoCupom(Form1.iCupom) then // Sandro Silva 2021-11-29 if Form1.ibDataset150.FieldByName('NUMERONF').AsString = StrZero(Form1.iCupom,6,0) then
                    begin
                      {Sandro Silva 2023-07-20 inicio}
                      sNumeroGerencialConvertido := Form1.ibDataset150.FieldByName('GERENCIAL').AsString; //  Recupera o número da venda gerencial, caso tenha sido importada
                      {Sandro Silva 2023-07-20 fim}
                      Form1.ibDataset150.Delete;
                    end;
                  except
                  end;

                end; // if _ecf65_UsoDenegado(sRetorno) then // Sandro Silva 2020-05-13

                //
                Form1.ibDataset150.Close;
                Form1.ibDataset150.SelectSql.Clear;
                Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF=' + QuotedStr(FormataNumeroDoCupom(0)) +' and CAIXA = ' + QuotedStr(Form1.sCaixa)); // Sandro Silva 2021-12-02 Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF=''000000'' and CAIXA = ' + QuotedStr(Form1.sCaixa));
                Form1.ibDataset150.Open;
                //
                Form1.IBDataSet150.Append;

                {Sandro Silva 2023-07-20 inicio}
                if sNumeroGerencialConvertido <> '' then
                  Form1.IBDataSet150.FieldByName('GERENCIAL').AsString := sNumeroGerencialConvertido;
                {Sandro Silva 2023-07-20 fim}

                if _ecf65_UsoDenegado(sRetorno) then // Sandro Silva 2020-05-13
                begin
                  Form1.IBDataSet150.FieldByName('NFEXML').Clear;
                  Form1.IBDataSet150.FieldByName('STATUS').Clear;
                  Form1.IBDataSet150.FieldByName('TOTAL').Clear;
                end
                else
                begin
                  if Pos(TIPOCONTINGENCIA, Form1.ClienteSmallMobile.sVendaImportando) > 0 then
                    Form1.IBDataSet150.FieldByName('NFEXML').AsString := fNFE //  Tentando transmitir contingência com falha de schema
                  else
                    Form1.IBDataSet150.FieldByName('NFEXML').AsString := sRetorno;
                  Form1.IBDataSet150.FieldByName('STATUS').AsString   := Copy(xmlNodeValue(sRetorno, '//infProt/xMotivo'),1,Form1.IBDataSet150.FieldByName('STATUS').Size);
                  if xmlNodeValue(sRetorno, '//vNF') <> '' then
                    Form1.IBDataSet150.FieldByName('TOTAL').AsFloat   := xmlNodeValueToFloat(sRetorno, '//vNF'); // Ficha 4302 Sandro Silva 2018-12-05
                end; //if _ecf65_UsoDenegado(sRetorno) then // Sandro Silva 2020-05-13
                Form1.IBDataSet150.FieldByName('NUMERONF').AsString := sNovoNumero;
                Form1.IBDataSet150.FieldByName('DATA').AsDateTime   := dtEnvio;
                Form1.IBDataSet150.FieldByName('CAIXA').AsString    := Form1.sCaixa;
                Form1.IBDataSet150.FieldByName('MODELO').AsString   := '65';
                Form1.IBDataSet150.Post;

                {Sandro Silva 2023-08-22 inicio
                Mais1ini  := TIniFile.Create('FRENTE.INI');
                Mais1Ini.WriteString('NFCE', 'CUPOM', sNovoNumero);
                Mais1Ini.Free;
                }
                GravaNumeroCupomFrenteINI(sNovoNumero, '65');
                {Sandro Silva 2023-08-22 fim}


                Form1.AtualizaDetalhe(Form1.IBQuery65.Transaction, sTIPODAV, sDAV, Form1.sCaixa, Form1.sCaixa, sNovoNumero, 'Fechada');

                //
                if FormataNumeroDoCupom(Form1.iCupom) <> sNovoNumero then // Sandro Silva 2021-11-29 if StrZero(Form1.iCupom,6,0) <> sNovoNumero then
                begin
                  Form1.Memo1.Text := StrTran(Form1.Memo1.Text,FormataNumeroDoCupom(form1.iCupom),sNovoNumero); // Sandro Silva 2021-11-29 Form1.Memo1.Text := StrTran(Form1.Memo1.Text,StrZero(form1.iCupom,6,0),sNovoNumero);
                  Form1.Memo1.Update;
                end;
                //
                Form1.iCupom := StrToInt(sNovoNumero);

                sLogErro := 'Tente novamente.';
                //
              except
                on E: Exception do
                begin
                  sLogErro := E.Message;
                end;
              end;  
              //
            end
            else
            begin
              // Escolheu não gerar novo número 
              if _ecf65_UsoDenegado(sRetorno) then // Sandro Silva 2020-05-13
              begin

                Form1.ibDataset150.Close;
                Form1.ibDataset150.SelectSql.Clear;
                Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF='+QuotedStr(FormataNumeroDoCupom(Form1.iCupom)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa) + ' and MODELO = ' + QuotedStr('65')); // Sandro Silva 2021-11-29 Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF='+QuotedStr(StrZero(Form1.iCupom,6,0)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa) + ' and MODELO = ' + QuotedStr('65'));
                Form1.ibDataset150.Open;

                Form1.ibDataset150.Edit;
                Form1.IBDataSet150.FieldByName('NFEXML').AsString := sRetorno;
                Form1.IBDataSet150.FieldByName('NFEID').AsString  := xmlNodeValue(sRetorno, '//chNFe');
                Form1.IBDataSet150.FieldByName('STATUS').AsString := Copy(xmlNodeValue(sRetorno, '//infProt/xMotivo'),1,Form1.IBDataSet150.FieldByName('STATUS').Size);
                Form1.IBDataSet150.FieldByName('DATA').AsDateTime := dtEnvio;
                Form1.IBDataSet150.FieldByName('TOTAL').AsFloat   := 0.00;
                Form1.IBDataSet150.Post;

                Result := True;
              end;
            end; // if bButton = IDYES then
            //
            Exit;
            //
          end; // if (Pos('<cStat>204</cStat>',sRetorno) <> 0) or (Pos('<cStat>539</cStat>',sRetorno) <> 0) then

          ////////////////////////////////
          ///
          /// Aqui tratar denegadas?
          /// 110-Uso Denegado;
          /// 205 NF-e está denegada na base de dados da SEFAZ;
          /// 301 Uso Denegado: Irregularidade fiscal do emitente;
          /// 302 Uso Denegado: Irregularidade fiscal do destinatário;
          /// 303 Uso Denegado: Destinatário não habilitado a operar na UF
          ///
          ////////////////////////////////

          //
          if (Trim(sRetorno) <> '') and (Trim(sRetorno) <> NFCE_NAO_HOUVE_RETORNO_SERVIDOR) then // Sandro Silva 2021-09-14 if Trim(sRetorno) <> '' then
          begin

            sStatus := '';
            while sRetorno <> '' do
            begin
              if Copy(sRetorno,1,9)='<xMotivo>' then
              begin
                sStatus  := Copy(sRetorno,10,Pos('</xMotivo>',sRetorno)-10);
                sRetorno := Copy(sRetorno,9,Length(sRetorno)-10);
              end else
              begin
                sRetorno := Copy(sRetorno,2,Length(sRetorno)-1);
              end;
            end;
            //
            if AllTrim(sStatus) = '' then
              sStatus := 'Retorno inválido recebido do Servidor da SEFAZ/' + UpperCase(Form1.ibDataSet13.FieldByname('ESTADO').AsString) + #13 + #13 + '"' + sRetorno + '"'; // Sandro Silva 2016-05-03  fNFE;
            if (Pos('Invalid', sStatus) > 0) and (Pos('infNFeSupl', sStatus) > 0) and (Form1.ClienteSmallMobile.sVendaImportando = '') then
            begin
              // Ficha 4077: O item com problema corresponde a relação de itens do XML, na tela podem ter sido lançados e cancelados outros itens antes, fazendo com que a sequência não seja a mesma
              sLogErro := 'Erro: 19' + Chr(10);
              if Trim(Copy(sStatus, 1, Pos('[nitem:', AnsiLowerCase(sStatus)) - 1)) <> '' then
                sLogErro := sLogErro + Trim(Copy(sStatus, 1, Pos('[nitem:', AnsiLowerCase(sStatus)) - 1)) + '. '
                + EncontraItemDataSet(ItemRejeicao(sStatus, wsNFCeAssinada))
                + ' ' + ItemRejeicao(sStatus, wsNFCeAssinada) // Sandro Silva 2018-02-19
              else
                sLogErro := sLogErro + sStatus;
              sLogErro := sLogErro
                + chr(10)+
                #13 + #13 +
                'Acesse F10 Menu/NFC-e/Versão do Schema da NFC-e, altere a versão do Schema e tente transmitir novamente' + #13;
            end
            else
              // Ficha 4077: O item com problema corresponde a relação de itens do XML, na tela podem ter sido lançados e cancelados outros itens antes, fazendo com que a sequência não seja a mesma
              sLogErro := 'Erro: 19' + Chr(10);
              if Trim(Copy(sStatus, 1, Pos('[nitem:', AnsiLowerCase(sStatus)) - 1)) <> '' then
                sLogErro := sLogErro + Trim(Copy(sStatus, 1, Pos('[nitem:', AnsiLowerCase(sStatus)) - 1)) + '. ' // Sandro Silva 2018-06-27  sStatus
                + EncontraItemDataSet(ItemRejeicao(sStatus, wsNFCeAssinada))
                + ' ' + ItemRejeicao(sStatus, wsNFCeAssinada) // Sandro Silva 2018-02-19
                + chr(10)
              else
                sLogErro := sLogErro + sStatus
                + chr(10);
          end
          else
          begin
            // sRetorno está vazio

            LogFrente('5102 Sem retorno sefaz ' + xmlNodeValue(fNFE, '//infNFe/@Id')); // Sandro Silva 2023-12-07

            if Trim(sLogErro) = '' then
            begin
              sLogErro := 'Erro: 20.1' + Chr(10) + NFCE_NAO_HOUVE_RETORNO_SERVIDOR + '/' + UpperCase(Form1.ibDataSet13.FieldByname('ESTADO').AsString) + #10; // Sandro Silva 2019-07-22 sLogErro := 'Erro: 20.1' + Chr(10) + 'Não houve retorno do Servidor da SEFAZ/' + UpperCase(Form1.ibDataSet13.FieldByname('ESTADO').AsString) + #10
              sStatus := NFCE_NAO_HOUVE_RETORNO_SERVIDOR; // Sandro Silva 2019-08-16
            end
            else
              sLogErro := 'Erro: 20.2' + Chr(10) + sLogErro + chr(10);
          end;

          if sLogErro <> '' then
          begin
            if (Form1.ClienteSmallMobile.sVendaImportando = '') then
              sLogErro := sLogErro + chr(10) + 'Leia atentamente a mensagem acima e tente resolver o problema. Considere pedir ajuda ao seu contador para o preenchimento correto da NFC-e.'
            else
              sLogErro := sLogErro + chr(10) + 'Informe o texto da mensagem acima ao operador do PDV antes de realizar nova venda.';
            sLogErro := sLogErroCredenciadoraCartao + sLogErro; // Sandro Silva 2020-10-21
          end;

          //
          if (Pos('<nfeProc', Form1.ibDataSet150NFEXML.AsString) = 0) and (Pos('<xEvento>Cancelamento</xEvento>', Form1.ibDataSet150NFEXML.AsString) = 0) then
          begin
            //
            fNFe := wsNFCeAssinada;
            //
          end;
          //
          Exit;
          //
        end;
        //
      end else
      begin
        //
        sStatus := NFCE_EMITIDA_EM_CONTINGENCIA; // Sandro Silva 2019-07-22  'NFC-e emitida em modo de contingência';
        //
      end;

      Result := True;

      if (Form1.ClienteSmallMobile.sVendaImportando = '') then
      begin
        // Não retornar False se não imprimir ou enviar o email
        // False apenas se não conseguir gerar CF-e-SAT

        if AnsiContainsText(sStatus, 'Autoriza') or AnsiContainsText(sStatus, NFCE_EMITIDA_EM_CONTINGENCIA) then // Sandro Silva 2019-07-22
        begin

          LogFrente('5151 autorizada ' + xmlNodeValue(fNFE, '//infNFe/@Id')); // Sandro Silva 2023-12-07

          {Sandro Silva 2023-12-06 inicio
          if AnsiContainsText(sStatus, 'conting') then
          begin
            Form1.spdNFCe1.DanfceSettings.ExibirDetalhamento := True;
            Form1.spdNFCe1.DanfceSettings.ParamsAvancados    := 'IdentificacaoVia=Via Estabelecimento';
          end;

          if Form1.VisualizarDANFCE1.Checked then
            _ecf65_Visualiza_DANFECE(sLote, fNFE);

          if Form1.ImprimirDANFCE1.Checked then
            _ecf65_Imprime_DANFECE(sLote, fNFE);

          if Form1.PosElginPay.Transacao.ImprimirComprovanteVenda then
            Form1.PosElginPay.ImpressaoComprovanteVenda(fNFE);

          if AnsiContainsText(sStatus, 'conting') then
          begin
            // Contingência 2 vias
            if Form1.ImprimirDANFCE1.Checked = False then
              _ecf65_Imprime_DANFECE(sLote, fNFE);

            Form1.spdNFCe1.DanfceSettings.ParamsAvancados := 'IdentificacaoVia=Via Consumidor';
            _ecf65_Imprime_DANFECE(sLote, fNFE);
          end;
          Form1.spdNFCe1.DanfceSettings.ParamsAvancados := '';

          if Form1.EnviaremailcomXMLePDFacadavenda1.Checked then // Ficha 4736 Sandro Silva 2019-08-02
            _ecf65_Email_DANFECE(sLote, fNFE);
          }
          bDisponibilizarDANFCe := True; // Sandro Silva 2023-12-05
          {Sandro Silva 2023-12-06 fim}
        end; // if Result then
      end
      else
      begin
        if Form1.ClienteSmallMobile.ImportandoMobile then // Sandro Silva 2022-08-08 if ImportandoMobile then
        begin
          if AnsiContainsText(sStatus, 'Autorizado') or AnsiContainsText(sStatus, 'NFC-e emitida') then
          begin

            // Primeiro envia danfce para mobile
            try
              if DirectoryExists(Form1.sAtual + '\mobile') = False then
                ForceDirectories(Form1.sAtual + '\mobile');
              if sPdfMobile <> '' then
              begin

                Form1.spdNFCe1.ExportarDanfce(sLote, fNFe, _ecf65_ArquivoRTM, 1, sPdfMobile);

                Sleep(1000);
                if FileExists(sPdfMobile) then
                begin
                  // upload pdf
                  // Sandro Silva 2022-08-08 UploadMobile(
                  Form1.ClienteSmallMobile.UploadMobile(sPdfMobile);
                  Sleep(1000);
                  // Após upload exclui o arquivo
                  DeleteFile(sPdfMobile);
                end;
              end;
            except
              on E: Exception do
              begin
                sLogErro := E.Message;
              end;
            end;

            if ((Form1.ibDataSet27.FieldByName('CLIFOR').AsString = Form1.ibDataSet2.FieldByName('NOME').AsString) and (Alltrim(Form1.ibDataSet27.FieldByName('CLIFOR').AsString)<>''))
              or (Form2.Edit10.Text <> '') then
            begin
              if ((Form1.ibDataSet27.FieldByName('CLIFOR').AsString = Form1.ibDataSet2.FieldByName('NOME').AsString) and (Alltrim(Form1.ibDataSet27.FieldByName('CLIFOR').AsString)<>'')) then
                Form2.Edit10.Text := Form1.ibDataSet2.FieldByName('EMAIL').AsString;

              if Form1.EnviaremailcomXMLePDFacadavenda1.Checked then // Ficha 4736 Sandro Silva 2019-08-02
                _ecf65_Email_DANFECE(sLote, fNFE);
            end;
            try

              if Form1.ImprimirDANFCE1.Checked then
                _ecf65_Imprime_DANFECE(sLote, fNFE)

            except
            end;

          end;
        end; // Não é contingência
      end; // if (Form1.ClienteSmallMobile.sVendaImportando = '') then
      //
    except
      //
      on E: Exception do
      begin

        sLogErro := sLogErroCredenciadoraCartao + sLogErro; // Sandro Silva 2020-10-21

        if sLogErro <> '' then
          sLogErro := sLogErro + Chr(10);
        if E.Message <> 'Operation aborted' then // 2015-07-06
          sLogErro := sLogErro + 'Erro! '+E.Message;
        Result := False;

        LogFrente('5255 ' + FormataNumeroDoCupom(Form1.icupom) + ' ' + sLogErro); // Sandro Silva 2023-12-07

        Exit;
      end;
      //
      // aqui volta na venda
      //
    end;
    //
    Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible  := False;
    if sLogErro = '' then
    begin
      //aqui deve continuar próximo, qdo erro na importação quando um pedido estiver com problema?
      //
      try
        //
        try
          Form1.ibDataset150.Close;
          Form1.ibDataset150.SelectSql.Clear;
          Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF='+QuotedStr(FormataNumeroDoCupom(Form1.iCupom)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa) + ' and MODELO = ' + QuotedStr('65')); // Sandro Silva 2021-11-29 Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF='+QuotedStr(StrZero(Form1.iCupom,6,0)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa) + ' and MODELO = ' + QuotedStr('65'));
          Form1.ibDataset150.Open;
          if Form1.ibDataset150.FieldByName('NUMERONF').AsString = FormataNumeroDoCupom(Form1.iCupom) then // Sandro Silva 2021-11-29 if Form1.ibDataset150.FieldByName('NUMERONF').AsString = StrZero(Form1.iCupom,6,0) then
          begin
            {Sandro Silva 2023-07-20 inicio}
            sNumeroGerencialConvertido := Form1.ibDataset150.FieldByName('GERENCIAL').AsString; //  Recupera o número da venda gerencial, caso tenha sido importada
            {Sandro Silva 2023-07-20 fim}

            Form1.ibDataset150.Delete;
          end;
        except
        end;

        //
        Form1.ibDataset150.Close;
        Form1.ibDataset150.SelectSql.Clear;
        Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF=' + QuotedStr(FormataNumeroDoCupom(0)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa)); // Sandro Silva 2021-12-02 Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF=''000000'' and CAIXA = ' + QuotedStr(Form1.sCaixa));
        Form1.ibDataset150.Open;
        //
        Form1.IBDataSet150.Append;

        {Sandro Silva 2023-07-20 inicio}
        if sNumeroGerencialConvertido <> '' then
          Form1.IBDataSet150.FieldByName('GERENCIAL').AsString := sNumeroGerencialConvertido;
        {Sandro Silva 2023-07-20 fim}

        Form1.IBDataSet150.FieldByName('NFEID').AsString    := sID;
        if Pos('<nNF>'+IntToStr(Form1.iCupom)+'</nNF>', String(fNFe)) <> 0 then
          Form1.IBDataSet150.FieldByName('NFEXML').AsString := fNFe;
        Form1.IBDataSet150.FieldByName('STATUS').AsString   := AllTrim(Copy(sStatus + Replicate(' ', 50), 1, Form1.IBDataSet150.FieldByName('STATUS').Size));
        Form1.IBDataSet150.FieldByName('NUMERONF').AsString := FormataNumeroDoCupom(Form1.iCupom); // Sandro Silva 2021-11-29 Form1.IBDataSet150.FieldByName('NUMERONF').AsString := StrZero(Form1.iCupom,6,0);
        Form1.IBDataSet150.FieldByName('DATA').AsDateTime   := dtEnvio;
        Form1.IBDataSet150.FieldByName('CAIXA').AsString    := Form1.sCaixa;
        Form1.IBDataSet150.FieldByName('MODELO').AsString   := '65';
        if xmlNodeValue(fNFe, '//vNF') <> '' then
          Form1.IBDataSet150.FieldByName('TOTAL').AsFloat   := xmlNodeValueToFloat(fNFe, '//vNF'); // Ficha 4302 Sandro Silva 2018-12-05

        Form1.IBDataSet150.Post;

        LogFrente('5313 ' + xmlNodeValue(fNFE, '//infNFe/@Id')); // Sandro Silva 2023-12-07

        // Sandro Silva 2015-03-30 Mantem ALTERACA.DATA = NFCE.DATA
        Form1.ibDataSet27.First;
        try

          if Form1.ibDataSet27.FieldByName('DATA').AsDateTime <> Form1.IBDataSet150.FieldByName('DATA').AsDateTime then
          begin // Primeiro item está com data diferente no banco

            hrEnvio := xmlNodeValue(fNFe, '//ide/dhEmi');
            hrEnvio := Copy(hrEnvio, 12, 8); // 2015-04-06T09:10:59-03:00
            try
              // Valida hora
              hrEnvio := FormatDateTime('HH:nn:ss', StrToTime(hrEnvio));
            except
              hrEnvio := '';
            end;

            while Form1.ibDataSet27.Eof = False do
            begin
              // Passa todos itens da nota atualizando data e hora

              if (Form1.ibDataSet27.FieldByName('CAIXA').AsString = Form1.sCaixa)
                and (Form1.ibDataSet27.FieldByName('PEDIDO').AsString = FormataNumeroDoCupom(Form1.icupom)) then // Sandro Silva 2021-11-29 and (Form1.ibDataSet27.FieldByName('PEDIDO').AsString = StrZero(Form1.icupom,6,0)) then
              begin
                try
                  // Sandro Silva 2015-03-30 Mantem ALTERACA.DATA = NFCE.DATA
                  if Form1.ibDataSet27.FieldByName('DATA').AsDateTime <> Form1.IBDataSet150.FieldByName('DATA').AsDateTime then
                  begin
                    Form1.ibDataSet27.Edit;
                    Form1.ibDataSet27.FieldByName('DATA').AsDateTime := dtEnvio;
                    {Sandro Silva 2022-08-26 inicio
                    Manter a hora que inseriu o registro na tabela
                    if hrEnvio <> '' then
                      Form1.ibDataSet27.FieldByName('HORA').AsString := hrEnvio;
                    }
                    Form1.ibDataSet27.Post;
                  end;
                except
                end;
              end;
              Form1.ibDataSet27.Next;
            end; // while
          end;

          if AnsiContainsText(Form1.IBDataSet150.FieldByName('STATUS').AsString, 'Autoriza') then
          begin
            Form1.ibDataSet27.First;
            while Form1.ibDataSet27.Eof = False do
            begin

              try
                Form1.ibDataSet27.Edit;
                Form1.ibDataSet27.FieldByName('COO').AsString := Form1.IBDataSet150.FieldByName('NUMERONF').AsString;
                if AnsiContainsText(Form1.IBDataSet150.FieldByName('STATUS').AsString, 'conting') = False then //não é contingênica
                  Form1.ibDataSet27.FieldByName('CCF').AsString := Form1.IBDataSet150.FieldByName('NUMERONF').AsString; // Autorizada
                Form1.ibDataSet27.Post;
              except
              end;

              Form1.ibDataSet27.Next;
            end;
          end;

        except

        end;
        //
        Form1.ibDataset150.Close;
        //
      except
      end;
    end;
    //
    DecodeTime((Time - tInicio), Hora, Min, Seg, cent);
    //Ativar para medir tempo Form1.Label_7.Hint := Form1.Label_7.Hint + #13 + 'Tempo de envio e impressão: '+' '+StrZero(Hora,2,0)+':'+StrZero(Min,2,0)+':'+StrZero(Seg,2,0)+':'+StrZero(cent,3,0)+' ';    // Sandro Silva 2018-04-24  Form1.Label_7.Hint := 'Tempo de envio e impressão: '+' '+StrZero(Hora,2,0)+':'+StrZero(Min,2,0)+':'+StrZero(Seg,2,0)+':'+StrZero(cent,3,0)+' ';
    //
    if sLogErro = '' then
      bOk := True;
  finally
    (* 2024-03-27
    {Sandro Silva 2023-12-06 inicio}
    if bDisponibilizarDANFCe then
    begin
      LogFrente('5396 vai imprimir' + xmlNodeValue(fNFE, '//infNFe/@Id')); // Sandro Silva 2023-12-07
      _ecf65_DisponibilizarDANFCe(sStatus, sLote, fNFe);

      LogFrente('5399 imprimiu ' + xmlNodeValue(fNFE, '//infNFe/@Id')); // Sandro Silva 2023-12-07

    end;
    {Sandro Silva 2023-12-06 fim}
    *)

    if bOk = False then
    begin

      LogFrente('5408 algo falhou ' + FormataNumeroDoCupom(Form1.icupom) + ' ' + sLogErro); // Sandro Silva 2023-12-07

      // Gera resposta para Small Mobile em .pdf com erro;
      if Form1.Panel3.Visible then
        Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible  := False;

      if (Form1.ClienteSmallMobile.sVendaImportando = '') then
      begin
        if Screen.Cursor <> crDefault then
          Screen.Cursor := crDefault;
        if sLogErro <> '' then
        begin
          if AnsiContainsText(sLogErro, NFCE_NAO_HOUVE_RETORNO_SERVIDOR)
            and (Form1.UsaIntegradorFiscal() = False) and (AnsiUpperCase(Form1.ibDataSet13.FieldByName('ESTADO').AsString) <> 'SC')  // Sandro Silva 2019-10-16
          then
          begin
            Form1.ExibePanelMensagem('Atenção! ' + NFCE_NAO_HOUVE_RETORNO_SERVIDOR + Chr(10) + 'Será gerada uma nova NFC-e em contingência');  // Sandro Silva 2018-08-23
          end
          else
            SmallMsg('Small - NFC-e ' + ' - ' + FormatDateTime('dd/mm/yyyy HH:nn:ss', Now) + ' ' + Form22.sBuild + Chr(10) + Chr(10) + sLogErro);
        end;
      end
      else
      begin

        // Alerta que falhou a geração da nfc-e das vendas pelo mobile
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
        Mais1ini := TIniFile.Create('FRENTE.INI');
        Mais1Ini.WriteString('NFCE','CUPOM', FormataNumeroDoCupom(0));
        Mais1ini.Free;
        }
        GravaNumeroCupomFrenteINI(FormataNumeroDoCupom(0), '65'); // Sandro Silva 2023-08-22
        {Sandro Silva 2023-08-22 fim}


        Form1.IBDataSet150.Close;

        if DirectoryExists(Form1.sAtual + '\mobile') = False then
          ForceDirectories(Form1.sAtual + '\mobile');

        if Form1.ClienteSmallMobile.ImportandoMobile then // Sandro Silva 2022-08-08 if ImportandoMobile then
        begin
          Form1.ClienteSmallMobile.LogRetornoMobile(sLogErro); // Sandro Silva 2022-08-08 LogRetornoMobile(sLogErro); // No processamento da fila de vendas mobile será retornado para o smallmobile o log
        end;
      end; // if Form1.bImportandoMobile = False then

      if sLogErro <> '' then
      begin
        try
          Form1.ibDataset150.Close;
          Form1.ibDataset150.SelectSql.Clear;
          Form1.ibDataset150.SelectSQL.Add(
            'select * ' +
            'from NFCE ' +
            'where NUMERONF = ' + QuotedStr(FormataNumeroDoCupom(Form1.iCupom)) + // Sandro Silva 2021-11-29 'where NUMERONF = ' + QuotedStr(StrZero(Form1.iCupom,6,0)) +
            ' and CAIXA = ' + QuotedStr(Form1.sCaixa) +
            ' and MODELO = ' + QuotedStr('65') +
            ' and (coalesce(STATUS, '''') not containing ''Autoriza'') ' +
            ' and (coalesce(STATUS, '''') not containing ''Cancela'') ' +
            ' and (coalesce(STATUS, '''') not containing ''conting'') '
            );
          Form1.ibDataset150.Open;
          //
          if Form1.ibDataset150.FieldByName('NUMERONF').AsString = FormataNumeroDoCupom(Form1.iCupom) then // Sandro Silva 2021-11-29 if Form1.ibDataset150.FieldByName('NUMERONF').AsString = StrZero(Form1.iCupom,6,0) then
          begin
            Form1.IBDataSet150.Edit;
            if sStatus <> '' then
              Form1.IBDataSet150.FieldByName('STATUS').AsString := Copy(Trim(sStatus), 1, Form1.IBDataSet150.FieldByName('STATUS').Size)
            else
              Form1.IBDataSet150.FieldByName('STATUS').AsString := Copy(Trim(StringReplace(sLogErro, #10, ' ', [rfReplaceAll])), 1, Form1.IBDataSet150.FieldByName('STATUS').Size);

            if _ecf65_UsoDenegado(sRetorno) = False then
            begin
              if Trim(fNFe) <> '' then
                Form1.IBDataSet150.FieldByName('NFEXML').AsString := fNFe // Se obteve retorno da sefaz informando erro de schema
              else
                Form1.IBDataSet150.FieldByName('NFEXML').AsString := Form1.spdNFCeDataSets1.LoteNFCe.GetText; // Se o componente encontrou erro ao validar dados antes de enviar

              if (AnsiContainsText(Form1.IBDataSet150.FieldByName('STATUS').AsString, NFCE_NAO_HOUVE_RETORNO_SERVIDOR) or AnsiContainsText(Form1.IBDataSet150.FieldByName('STATUS').AsString, 'tempo limite da operação foi atingido')) // Sandro Silva 2021-09-13 if AnsiContainsText(Form1.IBDataSet150.FieldByName('STATUS').AsString, NFCE_NAO_HOUVE_RETORNO_SERVIDOR)
                and (AnsiUpperCase(Form1.ibDataSet13.FieldByName('ESTADO').AsString) <> 'CE') and (AnsiUpperCase(Form1.ibDataSet13.FieldByName('ESTADO').AsString) <> 'SC') // Sandro Silva 2019-10-16
              then
              begin
                if LimpaNumero(xmlNodeValue(IfThen(Trim(fNFe) <> '', fNFE, Form1.spdNFCeDataSets1.LoteNFCe.GetText), '//infNFe/@Id')) <> '' then
                  Form1.IBDataSet150.FieldByName('NFEID').AsString := LimpaNumero(xmlNodeValue(IfThen(Trim(fNFe) <> '', fNFE, Form1.spdNFCeDataSets1.LoteNFCe.GetText), '//infNFe/@Id'));
              end;

            end;

            Form1.IBDataSet150.Post;
          end;

          if AnsiContainsText(sStatus, NFCE_NAO_HOUVE_RETORNO_SERVIDOR) then
          begin

            ////////////////////////////////////////////
            //
            // Início do procedimento de geração de nova NFC-e para ser finalizada em contingência
            //
            ////////////////////////////////////////////

            sXmlNFCeSubstituida := IfThen(Trim(fNFe) <> '', fNFE, Form1.spdNFCeDataSets1.LoteNFCe.GetText); // Extrai o xml

            if _ecf65_JaTemContingenciaPorSubstituicao(Form1.ibDataSet27.Transaction, LimpaNumero(xmlNodeValue(sXmlNFCeSubstituida, '//infNFe/@Id'))) = False then
            begin

              // Esse if precisa ser revisto se não há algum problema em ocorrer cancelamento por substituição nestas 2 UFs
              if (AnsiUpperCase(Form1.ibDataSet13.FieldByName('ESTADO').AsString) <> 'CE') and (AnsiUpperCase(Form1.ibDataSet13.FieldByName('ESTADO').AsString) <> 'SC') then
              begin

                if sXmlNFCeSubstituida <> '' then
                begin

                  _ecf65_sDataHoraNFCeSubstituida := xmlNodeValue(sXmlNFCeSubstituida, '//ide/dhEmi'); // Sandro Silva 2019-08-27

                  // Lança mesmas informações da venda em outra NFC-e
                  if _ecf65_GeraContingenciaParaCancelamentoPorSubstituicao(FormataNumeroDoCupom(Form1.iCupom), Form1.sCaixa, dtEnvio, sXmlNFCeSubstituida, Form1.sOrcame, Form1.sOs) then // Sandro Silva 2021-11-29 if _ecf65_GeraContingenciaParaCancelamentoPorSubstituicao(StrZero(Form1.iCupom,6,0), Form1.sCaixa, dtEnvio, sXmlNFCeSubstituida, Form1.sOrcame, Form1.sOs) then
                  begin

                    //Ativa a Contingência temporariamente, se ainda não estiver
                    try
                      if Form1.NFCeemContingncia1.Checked = False then
                      begin
                        bEstaEmContingencia              := Form1.NFCeemContingncia1.Checked;
                        Form1.NFCeemContingncia1.Checked := True;
                        Form1.sMotivoContingencia        := NFCE_XJUST_CONTINGENCIA_AUTOMATICA;
                      end;

                      LogFrente('5547 gerou contigencia para cancelamento por substituição ' + FormataNumeroDoCupom(Form1.icupom)); // Sandro Silva 2023-12-07

                      Result := _ecf65_EnviarNFCe(True); // Usa princípio da recursividade, o método chama a sí mesmo

                      _ecf65_sDataHoraNFCeSubstituida := ''; // Sandro Silva 2019-08-27

                      if Result then
                      begin
                        try
                          // Tudo certo na emissão em contingência para substituir a NFC-e sem resposta do envio de autorização
                          // Salva o id da NFC-e em contingência no registro da NFC-e a ser substituída

                          // Seleciona o ID da NFC-e em contingência que substituirá a outra NFC-e
                          Form1.ibDataset150.Close;
                          Form1.ibDataset150.SelectSql.Clear;
                          Form1.ibDataset150.SelectSQL.Add(
                            'select * ' +
                            'from NFCE ' +
                            'where NUMERONF = ' + QuotedStr(FormataNumeroDoCupom(Form1.iCupom)) + // Sandro Silva 2021-11-29 'where NUMERONF = ' + QuotedStr(StrZero(Form1.iCupom,6,0)) +
                            ' and CAIXA = ' + QuotedStr(Form1.sCaixa) +
                            ' and MODELO = ' + QuotedStr('65')
                            );
                          Form1.ibDataset150.Open;

                          sNfeIdSubstituta := LimpaNumero(xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//infNFe/@Id'));

                          try
                            if Form1.IBDataSet150.FieldByName('REGISTRO').AsString <> '' then
                            begin
                              Form1.IBDataSet150.Edit;
                              Form1.IBDataSet150.FieldByName('STATUS').AsString := Copy(Form1.IBDataSet150.FieldByName('STATUS').AsString + ' para substituição', 1, Form1.IBDataSet150.FieldByName('STATUS').Size);
                              Form1.IBDataSet150.Post;
                            end;
                          except
                          end;

                          //Seleciona a NFC-e a ser substituída e salva o ID da NFC-e substituta
                          Form1.ibDataset150.Close;
                          Form1.ibDataset150.SelectSql.Clear;
                          Form1.ibDataset150.SelectSQL.Add(
                            'select * ' +
                            'from NFCE ' +
                            'where NFEID = ' + QuotedStr(LimpaNumero(xmlNodeValue(sXmlNFCeSubstituida, '//infNFe/@Id'))) +
                            ' and CAIXA = ' + QuotedStr(Form1.sCaixa) +
                            ' and MODELO = ' + QuotedStr('65') +
                            ' and (coalesce(STATUS, '''') containing ' + QuotedStr(NFCE_NAO_HOUVE_RETORNO_SERVIDOR) + ') '
                            );
                          Form1.ibDataset150.Open;

                          if Form1.IBDataSet150.FieldByName('NFEID').AsString <> '' then
                          begin
                            Form1.IBDataSet150.Edit;
                            Form1.IBDataSet150.FieldByName('NFEIDSUBSTITUTO').AsString := sNfeIdSubstituta; // ID da NFC-e em contingência que substituiu a primeira NFC-e
                            Form1.IBDataSet150.Post;
                          end;

                        except

                        end;

                      end;
                    finally
                      // Desativa a contingência
                      if bEstaEmContingencia = False then
                      begin
                        Form1.NFCeemContingncia1.Checked := False;
                        Form1.sMotivoContingencia        := '';
                      end;
                    end;
                  end
                  else
                  begin
                    {Sandro Silva 2021-11-01 inicio}
                    // Não gerou cancelamento por substituição
                    // Valida se todos itens da nota estão cancelados
                    if _ecf65_TodosItensCancelados(Form1.ibDataSet27.Transaction, FormataNumeroDoCupom(Form1.iCupom), Form1.sCaixa) then // Sandro Silva 2021-11-29 if _ecf65_TodosItensCancelados(Form1.ibDataSet27.Transaction, StrZero(Form1.iCupom,6,0), Form1.sCaixa) then
                    begin

                      Form1.ibDataset150.Close;
                      Form1.ibDataset150.SelectSql.Text :=
                        'select * ' +
                        'from NFCE ' +
                        'where NUMERONF = ' + QuotedStr(FormataNumeroDoCupom(Form1.icupom)) + // Sandro Silva 2021-11-29 'where NUMERONF = ' + QuotedStr(StrZero(Form1.iCupom,6,0)) +
                        ' and CAIXA = ' + QuotedStr(Form1.sCaixa) +
                        ' and MODELO = ' + QuotedStr('65');
                      Form1.ibDataset150.Open;

                      if (AnsiContainsText(Form1.ibDataset150.FieldByName('STATUS').AsString, 'Autorizad') = False) and
                        (AnsiContainsText(Form1.ibDataset150.FieldByName('STATUS').AsString, 'Cancela') = False) then
                      begin
                        //Limpa os campos NFEXML, NFEID, NFEIDSUBSTITUTO e STATUS
                        Form1.ibDataset150.Edit;
                        Form1.ibDataset150.FieldByName('NFEXML').AsString          := '';
                        Form1.IBDataSet150.FieldByName('NFEID').AsString           := '';
                        Form1.IBDataSet150.FieldByName('NFEIDSUBSTITUTO').AsString := '';
                        Form1.IBDataSet150.FieldByName('STATUS').AsString          := '';
                        Form1.IBDataSet150.Post;
                      end;

                    end;
                    {Sandro Silva 2021-11-01 fim}

                  end; // if gerou nfce cancelamento por substituição

                end; //if sXmlNFCeSubstituida <> '' then

              end; // if AnsiUpperCase(Form1.ibDataSet13.FieldByName('ESTADO').AsString <> 'CE' then

            end; // if JaTemContingenciaPorSubstituicao = False then

            ////////////////////////////////////////////
            //
            // Fim do procedimento de geração de nova NFC-e para ser finalizada em contingência
            //
            ////////////////////////////////////////////

          end;// if AnsiContainsText(sStatus, NFCE_NAO_HOUVE_RETORNO_SERVIDOR) then

          Form1.ibDataset150.Close;

        except
        end;
      end; // if sLogErro <> '' then
    end; // if bOk = False then
  end; // try
  FreeAndNil(IBQALTERACA); // Sandro Silva 2019-08-05
  ChDir(Form1.sAtual); // Sandro Silva 2017-03-31

  LogFrente('5673 concluiu metodo enviarnfce ' + FormataNumeroDoCupom(Form1.icupom)); // Sandro Silva 2023-12-07
end;

function _ecf65_Visualiza_DANFECE(pSLote: String; pFNFe : WideString): Boolean;
begin
  //
  Result := True;
  //
  //if FunctionDetect('USER32.DLL','BlockInput',@xBlockInput) then xBlockInput(False);  // Enable  Keyboard & mouse
  //
  try
    //Sandro Silva 2015-05-08 Precisa definir aqui antes de imprimir
    if Form1.DANFCEdetalhado1.Checked then
      Form1.spdNFCe1.DanfceSettings.ExibirDetalhamento := True
    else
      Form1.spdNFCe1.DanfceSettings.ExibirDetalhamento := False;

    Form1.spdNFCe1.VisualizarDanfce(psLote, pfNFe, _ecf65_ArquivoRTM);

  except
    on E: Exception do
    begin
      Application.MessageBox(PChar(E.Message+chr(10)+chr(10)+'Ao visualizar o DANFCE'),'Atenção',mb_Ok + MB_ICONWARNING); // Sandro Silva 2020-09-03 Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+'Ao visualizar o DANFCE'),'Atenção',mb_Ok + MB_ICONWARNING);
      Result := False;
    end;
  end;
end;

function _ecf65_Imprime_DANFECE(pSLote: String; pFNFe : WideString): Boolean;
var
  Device  : array[0..255] of char;
  Driver  : array[0..255] of char;
  Port    : array[0..255] of char;
  hDMode  : THandle;
  sTamanhoPapelOld: String; // Sandro Silva 2023-10-10
  sCaminhoZPOS: String; // Sandro Silva 2023-10-11
  sChaveNFCE : string;
  sXML : TStringList;
begin
  Result := True;

  Form1.Display('Aguarde, imprimindo DANFCE...', 'Aguarde, imprimindo DANFCE...');
  // Sandro Silva 2021-11-05 Form1.ExibePanelMensagem('Aguarde, imprimindo DANFCE...');
  if Printer.Printers.Count > 0 then // Sandro Silva 2018-06-13
  begin
    try
      Printer.PrinterIndex := Printer.Printers.IndexOf(Form1.sImpressoraPadraoWindows);
      if Trim(Form1.sImpressoraDestino) <> '' then
        Printer.PrinterIndex := Printer.Printers.IndexOf(Form1.sImpressoraDestino);

      Printer.GetPrinter(Device, Driver, Port, hDMode);

      if Form1.DANFCEdetalhado1.Checked then
        Form1.spdNFCe1.DanfceSettings.ExibirDetalhamento := True
      else
        Form1.spdNFCe1.DanfceSettings.ExibirDetalhamento := False;
      //
      {Sandro Silva 2023-10-10 inicio
      Form1.spdNFCe1.ImprimirDanfce(psLote, pfNFe, _ecf65_ArquivoRTM, Device);
      }

      if Pos('ZPOS', String(pfNFe)) > 0 then
      begin
        {Mauricio Parizotto 2024-07-09 Inicio
        try
          sCaminhoZPOS := 'c:\' + LerParametroIni(FRENTE_INI, 'ZPOS', 'PASTA', '') + '\' + LerParametroIni(FRENTE_INI, 'ZPOS', 'REQ', '');

          DeleteFile(sCaminhoZPOS + '\danfce.pdf');

          sTamanhoPapelOld := Form1.sTamanhoPapel;
          Form1.sTamanhoPapel := '58';
          Form1.spdNFCe1.ExportarDanfce(psLote, pfNFe, _ecf65_ArquivoRTM, 1, sCaminhoZPOS + '\danfce.tmp');

          Sleep(200);

          RenameFile(sCaminhoZPOS + '\danfce.tmp', sCaminhoZPOS + '\danfce.pdf');

        finally
          Form1.sTamanhoPapel := sTamanhoPapelOld;
        end;
        }
        try
          sChaveNFCE := xmlNodeValue(pFNFe, '//infNFe/@Id');

          sCaminhoZPOS := 'c:\' + LerParametroIni(FRENTE_INI, 'ZPOS', 'PASTA', '') + '\' + LerParametroIni(FRENTE_INI, 'ZPOS', 'REQ', '');

          DeleteFile(sCaminhoZPOS + '\'+sChaveNFCE+'.xml');

          sXML := TStringList.Create;
          sXML.Text := pfNFe;
          sXML.SaveToFile(sCaminhoZPOS + '\'+sChaveNFCE+'.tmp');

          Sleep(200);

          RenameFile(sCaminhoZPOS + '\'+sChaveNFCE+'.tmp', sCaminhoZPOS + '\'+sChaveNFCE+'.xml');
        finally
          FreeAndNil(sXML);
        end;
        {Mauricio Parizotto 2024-07-09 Fim}
      end
      else
        Form1.spdNFCe1.ImprimirDanfce(psLote, pfNFe, _ecf65_ArquivoRTM, Device);
      {Sandro Silva 2023-10-10 fim}
      //        sLeep(5000);
      //        sleep(I*400);
    except
      on E: Exception do
      begin
        Application.MessageBox(PChar(E.Message+chr(10)+chr(10)+'Ao imprimir o DANFCE'),'Atenção',mb_Ok + MB_ICONWARNING); // Sandro Silva 2020-09-03 Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+'Ao imprimir o DANFCE'),'Atenção',mb_Ok + MB_ICONWARNING);
        Result := False;
      end;
    end;
  end
  else
    ShowMessage('Instale uma impressora no Windows');

  Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible  := False;
end;

function _ecf65_Email_DANFECE(pSLote: String; pFNFe : WideString): Boolean;
var
  sEmail : String;
  sZipFile: String;
  sIDNFCe: String;
  sPDFFile: String;
  sXMLFile: String;
  sTextoCorpoEmail: String;
  function Compactar(sZipFile: String): Boolean;
  begin
    if FileExists(sZipFile) then
      DeleteFile(sZipFile); // Sandro Silva 2020-09-03 DeleteFile(PChar(sZipFile));

    if FileExists('szip.exe') then
    begin
      if FileExists(sPDFFile) then
        ShellExecute(Application.Handle, PChar('Open'), PChar('szip.exe'), PChar('backup "' + Alltrim(sPDFFile) + '" "' + sZipFile + '"'), PChar(''), SW_SHOWMAXIMIZED);

      while ConsultaProcesso('szip.exe') do
      begin
        // Sandro Silva 2016-05-23  Application.ProcessMessages;
        Sleep(100);
      end;

      if FileExists(sXMLFile) then
        ShellExecute(Application.Handle, PChar('Open'), PChar('szip.exe'), PChar('backup "'+Alltrim(sXMLFile)+'" "'+ sZipFile + '"'), PChar(''), SW_SHOWMAXIMIZED);

      //
      while ConsultaProcesso('szip.exe') do
      begin
        // Sandro Silva 2016-05-23  Application.ProcessMessages;
        Sleep(100);
      end;
      //
      while not FileExists(sZipFile) do
      begin
        Sleep(100);
      end;
      //
      while FileExists(sPDFFile) do
      begin
        DeleteFile(sPDFFile);
        Sleep(100);
      end;

      while FileExists(sXMLFile) do
      begin
        DeleteFile(sXMLFile);
        Sleep(100);
      end;

    end;
    Result := True;
  end;
begin
  //
  sEmail    := AllTrim(Copy(StrTran(AllTrim(Form2.Edit10.Text),';',Replicate(' ',512))+Replicate(' ',265),1,256)); // Fica somente um e-mail
  //
  if ValidaEmail(sEmail) then
  begin

    {Sandro Silva 2022-09-02 inicio
    sIDNFCe := xmlNodeValue(pFNFe, '//infNFe/@Id');
    sPDFFile := 'danfce_NFCe' + LimpaNumero(sIDNFCe) + '.pdf';
    sXMLFile := 'NFCe' + LimpaNumero(sIDNFCe) + '.xml';
    }
    ChDir(ExtractFilePath(Application.ExeName));
    CreateDir('email');

    sIDNFCe := xmlNodeValue(pFNFe, '//infNFe/@Id');
    sPDFFile := ExtractFilePath(Application.ExeName) + 'email\danfce_NFCe' + LimpaNumero(sIDNFCe) + '.pdf'; // Sandro Silva 2022-09-02 sPDFFile := 'danfce_NFCe' + LimpaNumero(sIDNFCe) + '.pdf';
    sXMLFile := ExtractFilePath(Application.ExeName) + 'email\NFCe' + LimpaNumero(sIDNFCe) + '.xml'; // Sandro Silva 2022-09-02 sXMLFile := 'NFCe' + LimpaNumero(sIDNFCe) + '.xml';
    sZipFile := ExtractFilePath(Application.ExeName) + 'email\danfce_xml' + LimpaNumero(sIDNFCe) + '.zip'; // Sandro Silva 2022-09-02
    {Sandro Silva 2022-09-02 fim}

    //
    while FileExists(sPDFFile) do // Sandro Silva 2020-09-03 while FileExists(pChar(sPDFFile)) do
    begin
      DeleteFile(sPDFFile); // Sandro Silva 2020-09-03 DeleteFile(pChar(sPDFFile));
      Sleep(100);
    end;
    //
    try
      if Form1.DANFCEdetalhado1.Checked then
        Form1.spdNFCe1.DanfceSettings.ExibirDetalhamento := True
      else
        Form1.spdNFCe1.DanfceSettings.ExibirDetalhamento := False;
    except

    end;

    Form1.spdNFCe1.ExportarDanfce(psLote, pfNFe, _ecf65_ArquivoRTM, 1, sPDFFile); // Sandro Silva 2022-09-02 Form1.spdNFCe1.ExportarDanfce(psLote, pfNFe, _ecf65_ArquivoRTM, 1, Form1.sAtual + '\' + sPDFFile);

    Sleep(250); // Sandro Silva 2022-09-02 Aguardar salvar em disco

    while FileExists(sXMLFile) do // Sandro Silva 2020-09-03 while FileExists(pChar(sXMLFile)) do
    begin
      DeleteFile(sXMLFile); // Sandro Silva 2020-09-03 DeleteFile(pChar(sXMLFile));
      Sleep(100);
    end;

    with TRichEdit.Create(Application) do
    begin
      Visible   := False;
      Parent    := Application.MainForm;
      PlainText := True;
      Text      := pFNFe;
      Lines.SaveToFile(sXMLFile);
      Free;
    end;

    if Form1.EnviarDANFCEeXMLcompactado1.Checked = False then
    begin
      //
      if FileExists(sXMLFile) then // Sandro Silva 2020-09-03 if FileExists(pChar(sXMLFile)) then
      begin

        sTextoCorpoEmail := 'Segue em anexo seu XML da NFC-e.'+chr(10);
        if Form1.sPropaganda <> '' then
          sTextoCorpoEmail := sTextoCorpoEmail + Form1.sPropaganda + Chr(10);
        sTextoCorpoEmail := sTextoCorpoEmail + 'Este e-mail foi enviado automaticamente pelo sistema Small.'+chr(10)+'www.smallsoft.com.br';

        _ecf65_EnviarEMail('', sEmail, '', 'XML da NFC-e', PChar(sTextoCorpoEmail), PChar(sXMLFile), False);
      end;

      if FileExists(sPDFFile) then // Sandro Silva 2020-09-03 if FileExists(pChar(sPDFFile)) then
      begin
        sTextoCorpoEmail := 'Segue em anexo seu DANFCE em arquivo PDF.'+chr(10);
        if Form1.sPropaganda <> '' then
          sTextoCorpoEmail := sTextoCorpoEmail + Form1.sPropaganda + Chr(10);
        sTextoCorpoEmail := sTextoCorpoEmail + 'Este e-mail foi enviado automaticamente pelo sistema Small.'+chr(10)+'www.smallsoft.com.br';

        _ecf65_EnviarEMail('', sEmail, '', 'DANFCE (Documento Auxiliar da NFC-e)', PChar(sTextoCorpoEmail), PChar(sPDFFile), False);
      end;

    end
    else
    begin

      //sZipFile := ExtractFilePath(Application.ExeName) + 'email\danfce_xml_' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzzz', Now) + '.zip'; // Sandro Silva 2022-09-02 sZipFile := 'danfce_xml.zip';
      //sZipFile := ChangeFileExt(sPDFFile, 'zip');
      Compactar(sZipFile);
      if FileExists(sZipFile) then // Sandro Silva 2020-09-03 if FileExists(pChar(sZipFile)) then
      begin
        sTextoCorpoEmail := 'Segue em anexo seu XML e DANFCE da NFC-e.'+chr(10);
        if Form1.sPropaganda <> '' then
          sTextoCorpoEmail := sTextoCorpoEmail + Form1.sPropaganda + Chr(10);
        sTextoCorpoEmail := sTextoCorpoEmail + 'Este e-mail foi enviado automaticamente pelo sistema Small.'+chr(10)+'www.smallsoft.com.br';

        _ecf65_EnviarEMail('', sEmail, '', 'DANFCE (Documento Auxiliar da NFC-e) e XML', PChar(sTextoCorpoEmail), PChar(sZipFile), False);
      end;

    end;
  end;
  //
  Form2.Edit10.Text := ''; // 2015-12-10 Depois de enviar limpa o campo;
  Result := True;
  //
  ChDir(Form1.sAtual); // Sandro Silva 2017-03-31
end;

function _ecf65_ConsultarStatusServico(bExibirMensagem: Boolean = True): String;
var
  Cursor: TCursor;
  sRetorno: WideString;
  sStatus: String;
  sException: String;
  //bContingencia: Boolean;
begin
  Cursor := Screen.Cursor;
  Result := '';
  try
    //bContingencia := Form1.NFCeemContingncia1.Checked;
    //Form1.NFCeemContingncia1.Checked := False;
    Screen.Cursor := crHourGlass;

    ConfiguraNFCE(True); //_ecf65_ConsultarStatusServico()

    try

      _ecf65_NumeroSessaoIntegradorFiscal; // Sandro Silva 2018-04-23

      {Sandro Silva 2020-06-23 inicio
      sRetorno := Form1.spdNFCe1.StatusDoServico;
      }
      try
        Form1.spdNFCe1.TimeOut := _ecf65_TimeOutPadraoConsultaStatusServicoNFCe; // Muda timeout para valor padrão, mais baixo que usado no envio de NFC-e
        sRetorno := Form1.spdNFCe1.StatusDoServico;
      except
      end;

      Form1.spdNFCe1.TimeOut := _ecf65_TimeOutComunicacaoSefaz; // Retorna o timeout configurado para comunicação com Sefaz
      {Sandro Silva 2020-06-23 fim}


      {Sandro Silva 2019-09-30 inicio}
      sRetorno := _ecf65_CorrigePadraoRespostaSefaz(sRetorno);
      {Sandro Silva 2019-09-30 fim}

      // Permitir simular que não ocorre retorno da sefaz
      sRetorno := _ecf65_SimulaSemRetornoSefaz(sRetorno); // Sandro Silva 2020-06-25

      //SmallMsg('Teste 01 consultou status 2986');
    except
      on E: Exception do
      begin
        if Form1.UsaIntegradorFiscal() = False then // Limpa sRetorno se não usar integrador fiscal Sandro Silva 2019-11-19
          sRetorno := '';
        sException := E.Message;
        //SmallMsg('Teste 01 consultou status 2992');
      end;
    end;
    sStatus :=  xmlNodeValue(sRetorno, '//cStat');
    Result   := xmlNodeValue(sRetorno, '//xMotivo');

    {Sandro Silva 2023-06-14 inicio
    if Form1.UsaIntegradorFiscal() then
    begin
      // '<Integrador><Identificador><Valor>112954021</Valor></Identificador><IntegradorResposta><Codigo>AP</Codigo><Valor>NFCE HABILITADA</Valor></IntegradorResposta><Resposta><retorno>112954021|000000|Impossível conectar-se ao servidor remoto||</retorno></Resposta></Integrador>'
      if sStatus = '' then
        sException := 'Integrador Fiscal retornou:' + #13 + Copy(sRetorno+'   ',Pos('<retorno>',sRetorno)+9,Pos('</retorno>',sRetorno)-Pos('<retorno>',sRetorno)-9) + #13 + sException;
    end;
    }

    if sStatus = '109' then
    begin
      //
      if bExibirMensagem then
        Application.MessageBox(PChar(Chr(13) + 'Aguarde, não é possível enviar esta NFC-e no momento.' + Chr(13) +
        Chr(13) +
        'Serviço Paralisado sem Previsão.' +
        IfThen(xmlNodeValue(sRetorno, '//xObs') <> '', Chr(13) + xmlNodeValue(sRetorno, '//xObs') + '.', '')),
        'Atenção', mb_Ok + MB_ICONWARNING);
      //
    end
    else if sStatus = '108' then
    begin
      //
      if bExibirMensagem then
        Application.MessageBox(PChar(chr(13) +'Aguarde, não é possível enviar esta NFC-e no momento.'+Chr(13)+
        Chr(13)+
        'Serviço Paralisado Momentaneamente (curto prazo).'+
        IfThen(xmlNodeValue(sRetorno, '//xObs') <> '', Chr(13)+xmlNodeValue(sRetorno, '//xObs') + '.', '')),
        'Atenção', mb_Ok + MB_ICONWARNING);
      //
    end
    else
    begin
      //
      if sStatus <> '107' then
      begin
        //
        if sStatus = '' then
        begin
          // Exibir erro de certificado digital (canais seguros)
          if Pos('CERTIFICADO',Uppercase(sException)) <> 0 then
          begin
            //
            if bExibirMensagem then
              Application.MessageBox(
              PChar(
              chr(10) +'Erro:'
              +Chr(10)
              +Chr(10)+sException
              +Chr(10)
              +chr(10)+'1 - Verifique se o seu certificado está instalado'
              +chr(10)+'2 - Verifique se o seu certificado está selecionado (F10 Menu/NFC-e/Selecionar Certificado Digital...)'
              +chr(10)+'3 - Seu certificado pode estar vencido'
              +chr(10)+'4 - Seu certificado pode ser inválido'
              + chr(10)
              +chr(10)+'Certificados recomendados' // Sandro Silva 2022-12-02 Unochapeco +chr(10)+'Certificados recomendados pela Smallsoft®'
              +chr(10)+''
              +chr(10)+'1. Certificados SERASA'
              +chr(10)+'    * A1'
              +chr(10)+'    * SmartCard'
              +chr(10)+'    * E-CNPJ'
              +chr(10)+'2. Certificados Certisign A1 e A3'
              +chr(10)+'3. Certificados dos Correios A1 e A3'
              +chr(10)+'4. Certificados A3 PRONOVA ACOS5.'),
              'Atenção',mb_Ok + MB_ICONWARNING);
            //
          end else
          begin
            //
            if bExibirMensagem then
              Application.MessageBox(
              PChar(
              chr(10) +'Erro:'
              +Chr(10)
              +Chr(10)+sException
              +Chr(10)
              +chr(10) +'Não foi possível acessar o servidor da receita.'
              +Chr(10)
              +chr(10)+'1 - Verifique sua conexão de internet'
              +chr(10)+'2 - Verifique a disponibilidade dos serviços (F10 Menu/NFC-e/Consultar Status do Serviço...).'),
              'Atenção',mb_Ok + MB_ICONWARNING);
            //
          end; // if Pos('CERTIFICADO',Uppercase(sException)) <> 0 then
          {Sandro Silva 2016-03-10 final}
        end else
        begin
          if bExibirMensagem then
            SmallMsg(Copy(sRetorno+'   ',Pos('<xMotivo>', String(sRetorno))+9,Pos('</xMotivo>', String(sRetorno)) - Pos('<xMotivo>', String(sRetorno)) - 9) +
              IfThen(xmlNodeValue(sRetorno, '//xObs') <> '', xmlNodeValue(sRetorno, '//xObs') + Chr(13), '')  // Sandro Silva 2019-08-09
              );
        end; // if sStatus = '' then
        //
        
        if bExibirMensagem then // Sandro Silva 2019-08-09
          Form1.sStatusECF := 'NFC-e Sem serviço';
        Form1.bStatusECF := False; // Desliga botão ECF
      end else
      begin
        //Result := True;
        if bExibirMensagem then // Sandro Silva 2019-08-09
          Form1.sStatusECF := 'Serviço de NFC-e em operação';

        Form1.bStatusECF := True; // Desliga botão ECF

      end; // if sStatus <> '107' then
    end;

    StatusECF(Form1.bStatusECF, 10);

    if bExibirMensagem then // Sandro Silva 2019-08-09
      Form1.Display(Form1.sStatusECF, Form1.sF);

    if bExibirMensagem then
    begin

      if Form1.bStatusECF = False then // Só exibe caixa mensagem quando sem serviço Sandro Silva 2021-11-03
      begin
        if Result = '' then
          Application.MessageBox(PChar(Form1.sStatusECF), 'Status do Serviço', MB_ICONINFORMATION + MB_OK)
        else
          Application.MessageBox(PChar(Result), 'Status do Serviço', MB_ICONINFORMATION + MB_OK);
      end;

    end;

    if Form1.NFCeemContingncia1.Checked = False then // Ocultar botoes apenas se não estiver em contingência
      Form1.Teclas_touch(True);
  finally
    //Form1.NFCeemContingncia1.Checked := bContingencia;
    Screen.Cursor := Cursor;
  end;

  //SmallMsg('Teste 01 consulta fim 3124');
end;

function _ecf65_InutilizacaoNFCe: String;
var
  sID, sRetorno, aAno, aModelo, aSerie, aIni, aFim, txtJustificativa: string;
begin
  //
  // Sandro Silva 2021-10-04 ConfiguraNFCE(True);
  //
  aAno := Form1.Small_InputBox('NFC-e', 'Insira o ano da NFC-e a ser inutilizada. Deixe vazio para cancelar a operação', FormatDateTime('yy', Date));

  if aAno <> '' then
  begin
    //
    aModelo := '65';// NFC-e é 65, não precisa solicitar ao usuário Sandro Silva 2018-03-28  aModelo := InputBox('NFC-e', 'Insira o modelo da NFC-e a ser inutilizada', '65');

    if aModelo <> '' then
    begin
      //
      // Sandro Silva 2019-05-10  aSerie := InputBox('NFC-e', 'Insira a série da NFC-e a ser inutilizada', '1');
      aSerie := Form1.Small_InputBox('NFC-e', 'Insira a série da NFC-e a ser inutilizada. Deixe vazio para cancelar a operação', '1');

      if aSerie <> '' then
      begin
        //
        // Sandro Silva 2019-05-10  aIni := InputBox('NFC-e', 'Insira o número da NFC-e inicial a ser inutilizada', '');
        aIni := Form1.Small_InputBox('NFC-e', 'Insira o número da NFC-e inicial a ser inutilizada. Deixe vazio para cancelar a operação', '');

        if aIni <> '' then
        begin

          //
          // Sandro Silva 2019-05-10  aFim := InputBox('NFC-e', 'Insira o número da NFC-e final a ser inutilizada', '');
          aFim := Form1.Small_InputBox('NFC-e', 'Insira o número da NFC-e final a ser inutilizada. Deixe vazio para cancelar a operação', '');
          if aFim <> '' then
          begin
            //
            //
            // Sandro Silva 2019-05-10  txtJustificativa := ConverteAcentos(InputBox('NFC-e', 'Insira a justificativa (min. 15 caracteres)', 'Exemplo de inutilizacao da NFC-e'));
            while True do
            begin
              txtJustificativa := ConverteAcentos(Trim(Form1.Small_InputBox('NFC-e', 'Insira a justificativa (min. 15 caracteres). Deixe vazio para cancelar a operação', 'Exemplo de inutilizacao da NFC-e')));
              if (txtJustificativa = '') or (Length(txtJustificativa) >= 15) then
                Break;
              if (Length(txtJustificativa) < 15) then
                SmallMsgBox(PChar('Justificativa informada com menos de 15 caracteres' + #13 + #13 + 'A justificativa deve ter no mínimo 15 caracteres'), 'Justificativa incorreta', MB_OK);
            end;

            if Trim(txtJustificativa) <> '' then // Sandro Silva 2019-05-10
            begin
              //
              sRetorno := _ecf65_InutilizacaoNFCe(sID, aAno, aModelo, aSerie, aIni, aFim, txtJustificativa);
              Commitatudo(True); // Inutilização NFC-e Sandro Silva 2019-05-28
              SmallMsg(sRetorno);
            end; // if Trim(txtJustificativa) <> '' then

          end; // if aFim <> '' then

        end; // if aIni <> '' then

      end; // if aSerie <> '' then

    end; // if aModelo <> '' then

  end; // if aAno <> '' then
  //
  Screen.Cursor            := crDefault;
  //
  Result := sRetorno;
end;

function _ecf65_InutilizacaoNFCe(sID, aAno, aModelo, aSerie, aIni, aFim, txtJustificativa: string): String;
var
  sRetorno: String;
  IBQINUTILIZA: TIBQuery;
begin
  //
  ConfiguraNFCE(True); // _ecf65_InutilizacaoNFCe()
  //
  //
  try
    Screen.Cursor := crHourGlass; // Cursor de Aguardo

    Form1.ExibePanelMensagem('Requisitando inutilização...'); // Sandro Silva 2019-05-28

    IBQINUTILIZA := CriaIBQuery(Form1.IBQuery65.Transaction);

    IBQINUTILIZA.Close;
    IBQINUTILIZA.SQL.Text :=
      'select * from MUNICIPIOS where NOME='+QuotedStr(Form1.ibDataSet13.FieldByName('MUNICIPIO').AsString)+' '+' and UF='+QuotedStr(UpperCase(Form1.ibDataSet13.FieldByName('ESTADO').AsString));
    IBQINUTILIZA.Open;
    //
    sID := Copy(IBQINUTILIZA.FieldByName('CODIGO').AsString,1,2) + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString) + aModelo + StrZero(StrToInt(aSerie),3,0) + StrZero(StrToInt(aIni),9,0) + StrZero(StrToInt(aFim),9,0);

    //
    _ecf65_NumeroSessaoIntegradorFiscal; // Sandro Silva 2018-04-23

    aSerie := IntToStr(StrToInt(aSerie)); // Sandro Silva 2021-10-05
    aIni   := IntToStr(StrToInt(aIni)); // Sandro Silva 2021-10-05
    aFim   := IntToStr(StrToInt(aFim)); // Sandro Silva 2021-10-05

    sRetorno := Form1.spdNFce1.InutilizarNF(sId, aAno, LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), aModelo, aSerie, aIni, aFim, txtJustificativa);

    {Sandro Silva 2019-09-30 inicio}
    sRetorno := _ecf65_CorrigePadraoRespostaSefaz(sRetorno);
    {Sandro Silva 2019-09-30 fim}

    {Sandro Silva 2019-05-28 inicio}
    if CampoExisteFB(Form1.IBDatabase1, 'INUTILIZACAO', 'REGISTRO') then
    begin

      if xmlNodeValue(sRetorno, '//infInut/cStat') = '102' then
      begin
        sID := Copy(IBQINUTILIZA.FieldByName('CODIGO').AsString,1,2) + aAno + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString) + aModelo + Right('000' + aSerie, 3) + Right('000000000' + aIni, 9) + Right('000000000' + aFim, 9);
        if FileExists(PChar(StringReplace(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + sID + '-inut.xml', '\\', '\', [rfReplaceAll]))) then
        begin

          with TStringList.Create do
          begin
            LoadFromFile(StringReplace(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + sID + '-inut.xml', '\\', '\', [rfReplaceAll])); // Carrega xml para stringlist

            // Sandro Silva 2021-10-04 _ecf65_GravarInutilizacao(Text, Form1.IBQuery65); //Passa stringlist.text para ser importado
            _ecf65_GravarInutilizacao(Text, IBQINUTILIZA); //Passa stringlist.text para ser importado

            Free;// Tira TStringList da memória
          end;
        end;

      end;

    end;
    {Sandro Silva 2019-05-28 fim}

    FreeAndNil(IBQINUTILIZA);

    Form1.OcultaPanelMensagem; // Sandro Silva 2019-05-28
    //
    Screen.Cursor := crDefault;
    sRetorno := Copy(sRetorno+'   ',Pos('<xMotivo>',sRetorno)+9,Pos('</xMotivo>',sRetorno)-Pos('<xMotivo>',sRetorno)-9);
    //
  except
    on E: Exception do
    begin
      //
      Application.MessageBox(PChar(E.Message+chr(10)+
                              chr(10)+'Leia atentamente a mensagem acima.'+char(10)+'Informe novamente os dados para inutilização da NFC-e.'
                              ),'Atenção Erro: 2321',mb_Ok + MB_ICONWARNING);
      Screen.Cursor            := crDefault;
      Abort;
      //
    end;
  end;
  //
  Screen.Cursor            := crDefault;
  //
  Result := sRetorno;
end;

// ---------------------------------- //
// Tratamento de erros da IF BEMATECH //
// ---------------------------------- //
function _ecf65_CodeErro(Pp1: Integer):Integer;
begin
  Result := 0;
end;

// ----------------------------//
// Detecta qual a porta que    //
// a impressora está conectada //
// IF BEMATECH MP20 FI         //
// --------------------------- //
function _ecf65_Inicializa(Pp1: String):Boolean;
var
  sStatus, sRetorno : String;
begin
  //
  Screen.Cursor := crHourGlass;
  //
  try
    if Mobile_65 = nil then
      Mobile_65 := TMobile.Create(nil);

    Application.Title    := 'Aplicativo Emissor de NFC-e';

    //SmallMsg('Teste 01 3165');
    //
    ConfiguraNFCE(True); //_ecf65_Inicializa()
    //
    if Form1.sModeloECF = '65' then
    begin


      {Sandro Silva 2022-05-02 inicio}
      // Tenta recuperar o ID CSC e o CSC salvos no nfe.ini
      if LerParametroIni(ExtractFilePath(Application.ExeName) + 'NFE.INI', 'NFCE', 'ID Token NFCE', '') = '' then
        GravarParametroIni(ExtractFilePath(Application.ExeName) + 'NFE.INI', 'NFCE', 'ID Token NFCE', Form1.spdNFCe1.DanfceSettings.IdTokenNFCe);

      if LerParametroIni(ExtractFilePath(Application.ExeName) + 'NFE.INI', 'NFCE', 'Número do Token NFCE', '') = '' then
        GravarParametroIni(ExtractFilePath(Application.ExeName) + 'NFE.INI', 'NFCE', 'Número do Token NFCE', Form1.spdNFCe1.DanfceSettings.TokenNFCe);
      {Sandro Silva 2022-05-02 fim}

      {Sandro Silva 2023-06-14 inicio 
      if Form1.UsaIntegradorFiscal() then
      begin

        Form22.Label6.Caption := 'Verificando se o Integrador Fiscal está em execução';
        Form22.Label6.Repaint;

        if InicializaIntegradorFiscal(Form22.Label6) = False then
         Abort;

        if Trim(LerParametroIni(FRENTE_INI, SECAO_MFE, CHAVE_VENDA_NO_CARTAO, '')) = '' then
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

        if Form1.sUltimaAdquirenteUsada = '' then
          Form1.sUltimaAdquirenteUsada := AdquirentePadrao;

      end; // if Form1.UsaIntegradorFiscal() then
      }
    end; // if Form1.sModeloECF = '65' then

    if Form1.sStatusECF <> TEXTO_CAIXA_LIVRE then  // Sandro Silva 2024-04-04 if Form1.sStatusECF <> 'CAIXA LIVRE' then
    begin
      //
      if (Form1.bBalancaAutonoma = False) then // Sandro Silva 2019-01-23
      begin
        if not Form1.NFCeemContingncia1.Checked then
        begin
          //
          Result   := False;
          //
          try
            //
            _ecf65_NumeroSessaoIntegradorFiscal; // Sandro Silva 2018-04-23

            if Form1.spdNFCe1.NomeCertificado.Text <> '' then // Somente após selecionar um certificado Sandro Silva 2018-12-03
            begin

              try
                Form1.spdNFCe1.TimeOut := _ecf65_TimeOutPadraoConsultaStatusServicoNFCe; // Muda timeout para valor padrão, mais baixo que usado no envio de NFC-e
                sRetorno := Form1.spdNFCe1.StatusDoServico;
              except
              end;
              Form1.spdNFCe1.TimeOut := _ecf65_TimeOutComunicacaoSefaz;  // Retorna o timeout configurado para comunicação com Sefaz

              sRetorno := _ecf65_CorrigePadraoRespostaSefaz(sRetorno);

              sRetorno := _ecf65_SimulaSemRetornoSefaz(sRetorno); // Sandro Silva 2020-06-25
                            
            end;

            //SmallMsg('Teste 01 3181' + #13 + sRetorno);
            //
            //
          except
            on E: Exception do
            begin

              //SmallMsg('Teste 01 3188' + #13 + sRetorno);

              //
              if Pos('CERTIFICADO',UpperCase(E.Message)) <> 0 then
              begin
                Application.ProcessMessages;
                Application.BringToFront;

                //
                Application.MessageBox(
                  PChar(
                  chr(10) +'Erro:'
                  +Chr(10)
                  +Chr(10)+E.Message
                  +Chr(10)
                  +chr(10)+'1 - Verifique se o seu certificado está instalado'
                  +chr(10)+'2 - Verifique se o seu certificado está selecionado'
                  +chr(10)+'3 - Seu certificado pode estar vencido'
                  +chr(10)+'4 - Seu certificado pode ser inválido'
                  + chr(10)
                  +chr(10)+'Certificados recomendados' // Sandro Silva 2022-12-02 Unochapeco +chr(10)+'Certificados recomendados pela Smallsoft®'
                  +chr(10)+''
                  +chr(10)+'1. Certificados SERASA'
                  +chr(10)+'    * A1'
                  +chr(10)+'    * SmartCard'
                  +chr(10)+'    * E-CNPJ'
                  +chr(10)+'2. Certificados Certisign A1 e A3'
                  +chr(10)+'3. Certificados dos Correios A1 e A3'
                  +chr(10)+'4. Certificados A3 PRONOVA ACOS5.'),
                  'Atenção',mb_Ok + MB_ICONWARNING);
                //
                Abort;
                //
              end else
              begin
                Application.ProcessMessages;
                Application.BringToFront;

                //
                Application.MessageBox(
                PChar(
                chr(10) +'Erro:'
                +Chr(10)
                +Chr(10)+E.Message
                +Chr(10)
                +chr(10) +'Não foi possível acessar o servidor da receita.'
                +Chr(10)
                +chr(10)+'1 - Verifique sua conexão de internet'
                +chr(10)+'2 - Verifique a disponibilidade dos serviços (F10 Menu/NFC-e/Consultar Status do Serviço...)'
                +chr(10)+'3 - Verifique seu certificado digital.'),
                'Atenção',mb_Ok + MB_ICONWARNING);
                //
              end;
              //
            end;
          end;
          //
          try
            //
            if Pos('<cStat>',sRetorno) <> 0 then
            begin
              sStatus := Alltrim(Copy(sRetorno+'   ',Pos('<cStat>',sRetorno)+7,Pos('</cStat>',sRetorno)-Pos('<cStat>',sRetorno)-7));
            end else sStatus := '';

            {Sandro Silva 2023-06-14 inicio
            if Form1.UsaIntegradorFiscal() then
            begin
              if sStatus = '' then
                sStatus := sRetorno;
            end;
            }

            //
        //    if sStatus <> '239' then // Verção do XML do cabeçalho não suportada
            if True then
            begin
              //
              if sStatus = '109' then
              begin
                Application.ProcessMessages;
                Application.BringToFront;

                //
                Application.MessageBox(PChar(chr(13) + 'Aguarde, não é possível enviar esta NFC-e no momento.' + Chr(13) +
                  Chr(13) +
                  'Serviço Paralisado sem Previsão.'),
                  'Atenção',mb_Ok + MB_ICONWARNING);
                //
              end
              else if sStatus = '108' then
              begin
                Application.ProcessMessages;
                Application.BringToFront;

                //
                Application.MessageBox(PChar(chr(13) + 'Aguarde, não é possível enviar esta NFC-e no momento.' + Chr(13) +
                  Chr(13)+
                  'Serviço Paralisado Momentaneamente (curto prazo).'),
                  'Atenção',mb_Ok + MB_ICONWARNING);
                //
              end
              else
              begin
                if sStatus <> '107' then
                begin
                  //
                  if sStatus = '' then
                  begin
                    Application.ProcessMessages;
                    Application.BringToFront;

                    //
                    Application.MessageBox(
                      PChar(
                      chr(10) +'Erro:' + IfThen(Form1.spdNFCe1.NomeCertificado.Text = '', chr(10)+'Nenhum certificado selecionado', '')
                      +Chr(10)
                      +chr(10) +'Não foi possível acessar o servidor da receita.'
                      +Chr(10)
                      +chr(10)+'1 - Verifique sua conexão de internet'
                      +chr(10)+'2 - Verifique a disponibilidade dos serviços (F10 Menu/NFC-e/Consultar Status do Serviço...)'
                      +chr(10)+'3 - Verifique seu certificado digital'
                      + IfThen(Form1.spdNFCe1.NomeCertificado.Text = '', chr(10)+'4 - Selecione o certificado digital.', '.')),
                      'Atenção',mb_Ok + MB_ICONWARNING);
                   end else
                   begin
                     Application.ProcessMessages;
                     Application.BringToFront;

                     {Sandro Silva 2023-06-14 inicio
                     if Form1.UsaIntegradorFiscal() then
                     begin
                       SmallMsg('Integrador Fiscal retornou:' + #13 + Copy(sRetorno+'   ',Pos('<retorno>',sRetorno)+9,Pos('</retorno>',sRetorno)-Pos('<retorno>',sRetorno)-9));
                     end
                     else
                     begin
                     }
                       SmallMsg(Copy(sRetorno+'   ',Pos('<xMotivo>',sRetorno)+9,Pos('</xMotivo>',sRetorno)-Pos('<xMotivo>',sRetorno)-9));
                     //end;

                   end;
                   //
                end else
                begin
                  Result := True;
                end;
              end;
            end else
            begin
              Result := True;
            end;
            //
          except
            //
            on E: Exception do
            begin
              //
              if Pos('CERTIFICADO',Uppercase(e.Message)) <> 0 then
              begin
                Application.ProcessMessages;
                Application.BringToFront;

                //
                Application.MessageBox(
                  PChar(
                  chr(10) +'Erro:'
                  +Chr(10)
                  +Chr(10)+E.Message
                  +Chr(10)
                  +chr(10)+'1 - Verifique se o seu certificado está instalado'
                  +chr(10)+'2 - Verifique se o seu certificado está selecionado'
                  +chr(10)+'3 - Seu certificado pode estar vencido'
                  +chr(10)+'4 - Seu certificado pode ser inválido'
                  + chr(10)
                  +chr(10)+'Certificados recomendados' // Sandro Silva 2022-12-02 Unochapeco +chr(10)+'Certificados recomendados pela Smallsoft®'
                  +chr(10)+''
                  +chr(10)+'1. Certificados SERASA'
                  +chr(10)+'    * A1'
                  +chr(10)+'    * SmartCard'
                  +chr(10)+'    * E-CNPJ'
                  +chr(10)+'2. Certificados Certisign A1 e A3'
                  +chr(10)+'3. Certificados dos Correios A1 e A3'
                  +chr(10)+'4. Certificados A3 PRONOVA ACOS5.'),
                  'Atenção',mb_Ok + MB_ICONWARNING);
                //
                Abort;
                //
              end else
              begin
                Application.ProcessMessages;
                Application.BringToFront;

                //
                Application.MessageBox(
                  PChar(
                  chr(10) +'Erro:'
                  +Chr(10)
                  +Chr(10)+'E1: '+E.Message
                  +Chr(10)
                  +chr(10) +'Não foi possível acessar o servidor da receita.'
                  +Chr(10)
                  +chr(10)+'1 - Verifique sua conexão de internet'
                  +chr(10)+'2 - Verifique a disponibilidade dos serviços (F10 Menu/NFC-e/Consultar Status do Serviço...)'
                  +chr(10)+'3 - Verifique seu certificado digital.'),
                  'Atenção',mb_Ok + MB_ICONWARNING);
                //
              end;
            end;
          end;

        end else
        begin
          Result := True;
        end;
      end
      else
      begin
        Result := True;
      end;
    end else
    begin
      Result := True;
    end;
    //
  except
    //
    on E: Exception do
    begin
      Application.ProcessMessages;
      Application.BringToFront;

        Application.MessageBox(
          PChar(
          chr(10) +'Erro:'
          +Chr(10)
          +Chr(10)+E.Message
          +Chr(10)),
          'Atenção',mb_Ok + MB_ICONWARNING);
        Result := False;
    end;
    // SmallMsg('Atualize a pasta NFCE');
    //
    //
  end;
  //
  FormatSettings.DecimalSeparator := ',';
  FormatSettings.DateSeparator    := '/';
  //
  Screen.Cursor            := crDefault;
  //
end;

// ------------------------------ //
// Fecha o cupom que está sendo   //
// emitido                        //
// IF BEMATECH MP20 FI            //
// ------------------------------ //
function _ecf65_FechaCupom(Pp1: Boolean):Boolean;
begin
  // -------------------- //
  // Fecha o cupom fiscal //
  // -------------------- //
  Result := True;
  //
end;

// ------------------------------ //
// Fecha o cupom que está sendo   //
// emitido                        //
// IF BEMATECH MP20 FI            //
// ------------------------------ //
function _ecf65_Pagamento(Pp1: Boolean):Boolean;
begin
  Result := _ecf65_EnviarNFCe(True);
end;

// ------------------------------ //
// Cancela o último cupom emitido //
// IF BEMATECH MP20 FI            //
// ------------------------------ //
function _ecf65_CancelaUltimoItem(Pp1: Boolean):Boolean;
begin
  Result := True;
end;

function _ecf65_CancelaUltimoCupom(Pp1: Boolean):Boolean;
begin
  Result := _ecf65_CancelaNFCe(True);
end;

function _ecf65_SubTotal(Pp1: Boolean):Real;
begin
  //
  Form1.fTotal := Form1.SubTotalAlteraca(Form1.sModeloECF, Form1.icupom, Form1.sCaixa, Form1.fTotal); // Sandro Silva 2019-04-30 Form1.fTotal := Form1.SubTotalAlteraca;
  Result := Form1.fTotal;
  //
  // SmallMsg(FloatToStr(Form1.fTotal)+chr(10)+'Casas decimais: '+Form1.ConfPreco);
  //
end;

function _ecf65_AbreNovoCupom(Pp1: Boolean):Boolean;
begin
  Form1.bCupomAberto := _ecf65_CupomAberto(True); // Sandro Silva 2018-08-01
  Result := True;
end;

// -------------------------------- //
// Retorna o número do Cupom        //
//                                  //
// -------------------------------- //
function _ecf65_NumeroDoCupom(Pp1: Boolean):String;
var
  Mais1Ini : tIniFile;
begin
  //
  try
    //
    Mais1ini  := TIniFile.Create('FRENTE.INI');
    //
    if _ecf65_CupomAberto(True) then
      Pp1 := False;
    //

    if pP1 then
    begin
      //
      while True do
      begin

        Result := FormataNumeroDoCupom(IncrementaGenerator('G_NUMERONFCE', 1));

        Form1.ibQuery65.Close;
        Form1.ibQuery65.SQL.Text :=
          'select CAIXA, MODELO, REGISTRO, NUMERONF ' +
          ', NFEID ' +
          'from NFCE ' +
          'where MODELO = ''65''' +
          ' and NUMERONF = ' + QuotedStr(Result);
        Form1.ibQuery65.Open;
        if (Form1.ibQuery65.FieldByName('NUMERONF').AsString = '') or (Copy(Form1.ibQuery65.FieldByName('NFEID').AsString, 23, 3) <> RightStr('000' + _ECF65_SerieAtual(Form1.IBQuery65.Transaction), 3)) then
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
          ' and MODELO = ' + QuotedStr('65');
        Form1.ibDataset150.Open;
        //
        Form1.IBDataSet150.Append;

        Form1.IBDataSet150.FieldByName('NUMERONF').AsString := Result;
        Form1.IBDataSet150.FieldByName('DATA').AsDateTime   := Date;
        Form1.IBDataSet150.FieldByName('CAIXA').AsString    := Form1.sCaixa;
        Form1.IBDataSet150.FieldByName('MODELO').AsString   := '65';

        Form1.IBDataSet150.Post;

        {Sandro Silva 2023-08-22 inicio
        Mais1Ini.WriteString('NFCE','CUPOM',Result);
        }
        GravaNumeroCupomFrenteINI(Result, '65'); // Sandro Silva 2023-08-22
        {Sandro Silva 2023-08-22 fim}

      except end;
    end else
    begin
      {Sandro Silva 2023-08-22 inicio
      try
        Result := FormataNumeroDoCupom(StrToInt(Mais1Ini.ReadString('NFCE','CUPOM',FormataNumeroDoCupom(1))));
      except
        Result := FormataNumeroDoCupom(0); // Sandro Silva 2021-12-02 Result := '000000';
      end;
      }
      try
        Result := FormataNumeroDoCupom(StrToInt(LeNumeroCupomFrenteINI('65', FormataNumeroDoCupom(1))));
      except
        Result := FormataNumeroDoCupom(0); // Sandro Silva 2021-12-02 Result := '000000';
      end;
      {Sandro Silva 2023-08-22 fim}
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
  if StrToInt('0'+LimpaNumero(Result))=0 then
    Result := '000001';
  //
  try
    Result := FormataNumeroDoCupom(StrToInt(Result)); // Sandro Silva 2021-12-01
  except
  end;
end;

// ------------------------------ //
// Cancela um item N              //
// IF BEMATECH MP20 FI            //
// ------------------------------ //
function _ecf65_CancelaItemN(pP1, pP2 : String):Boolean;
begin
  //
  Result := True;
  //
end;

// -------------------------------- //
// Abre a gaveta                    //
// IF BEMATECH MP20 FI              //
// -------------------------------- //
function _ecf65_AbreGaveta(Pp1: Boolean):Boolean;
var
  FLocal : TextFile;
  Mais1ini : TiniFile;
begin
  // ------------- //
  // Abre a gaveta //
  // ------------- //
  if Pp1 then
  begin
    Mais1ini  := TIniFile.Create('FRENTE.INI');
    if Mais1Ini.ReadString('Frente de Caixa','Gaveta','0') <> '0' then
    begin
      Mais1ini  := TIniFile.Create('FRENTE.INI');
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
    Mais1ini  := TIniFile.Create('FRENTE.INI');
    if Mais1Ini.ReadString('Frente de Caixa','Gaveta','0') <> '0' then
    begin
      try
         Writeln(Form1.fCupom,Chr(StrToInt(Copy(Mais1Ini.ReadString('Frente de Caixa','Abre Gaveta','027,118,140'),1,3)))
                      + Chr(StrToInt(Copy(Mais1Ini.ReadString('Frente de Caixa','Abre Gaveta','027,118,140'),5,3)))
                      + Chr(StrToInt(Copy(Mais1Ini.ReadString('Frente de Caixa','Abre Gaveta','027,118,140'),9,3))));
      except SmallMsg('Dados inválidos na chave "Abre Gaveta".') end;
    end;
  end;
  //
  Result := True;
  //
end;

// -------------------------------- //
// Status da gaveta                 //
// IF BEMATECH MP20 FI              //
// -------------------------------- //
function _ecf65_StatusGaveta(Pp1: Boolean):String;
begin
  Result := '255';
end;

// -------------------------------- //
// SAngria                          //
// IF BEMATECH MP20 FI              //
// -------------------------------- //
function _ecf65_Sangria(Pp1: Real):Boolean;
begin
  // 2015-03-30 Result := True;
  Result := _ecf65_SangriaSuprimento(Pp1, 'Sangria');
end;

// -------------------------------- //
// Suprimento                       //
// IF BEMATECH MP20 FI              //
// -------------------------------- //
function _ecf65_Suprimento(Pp1: Real):Boolean;
begin
  // 2015-03-30 Result := True;
  Result := _ecf65_SangriaSuprimento(Pp1, 'Suprimento');
end;

// -------------------------------- //
// REducao Z                        //
// IF BEMATECH MP20 FI              //
// -------------------------------- //
function _ecf65_NovaAliquota(Pp1: String):Boolean;
begin
  Result := True;
end;

function _ecf65_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
begin
  SmallMsg('Função não suportada pelo modelo de ECF utilizado.');
  Result := True;
end;

function _ecf65_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
begin
  SmallMsg('Função não suportada pelo modelo de ECF utilizado.');
  Result := True;
end;

// -------------------------------- //
// Venda do Item                    //
// IF BEMATECH MP20 FI              //
// -------------------------------- //
function _ecf65_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
begin
  // --------------------- //
  //  Retorno do Subtotal  //
  // --------------------- //
  if Form1.fTotal > 999999.98 then Form1.fTotal := 0;

  Form1.fTotal := Form1.fTotal + TruncaDecimal((TruncaDecimal(Form1.ibDataSet27.FieldByName('TOTAL').AsFloat,Form1.iTrunca)),Form1.iTrunca);
  Result := True;
  //
end;

// -------------------------------- //
// Reducao Z                        //
// IF BEMATECH MP20 FI              //
// -------------------------------- //
function _ecf65_ReducaoZ(pP1: Boolean):Boolean;
begin
  SmallMsg('Função não suportada pelo modelo de ECF utilizado.');
  Result := True;
end;

// -------------------------------- //
// Leitura X                        //
// IF BEMATECH MP20 FI              //
// -------------------------------- //
function _ecf65_LeituraX(pP1: Boolean):Boolean;
begin
  SmallMsg('Função não suportada pelo modelo de ECF utilizado.');
  Result := True;
end;

// ---------------------------------------------- //
// Retorna se o horario de verão está selecionado //
// IF BEMATECH MP20 FI                            //
// ---------------------------------------------- //
function _ecf65_RetornaVerao(pP1: Boolean):Boolean;
begin
  Result := False;
end;

// -------------------------------- //
// Liga ou desliga horário de verao //
// IF BEMATECH MP20 FI              //
// -------------------------------- //
function _ecf65_LigaDesLigaVerao(pP1: Boolean):Boolean;
begin
  Result := True;
end;

// -------------------------------- //
// Retorna a versão do firmware     //
// IF BEMATECH MP20 FI              //
// -------------------------------- //
function _ecf65_VersodoFirmware(pP1: Boolean): String;
begin
  Result := 'NFC-e';
end;

// -------------------------------- //
// Retorna o número de série        //
// IF BEMATECH MP20 FI              //
// -------------------------------- //
function _ecf65_NmerodeSrie(pP1: Boolean): String;
begin
  // Retorna "65" + nome do computador + 0 até completar 20 posições
  // Ex.: "65" + "PDV01" + "0000000000" = "NFC-ePDV010000000000"
  Result := '65' + Copy(AnsiUpperCase(GetComputerNameFunc) + DupeString('0', 20), 1, 18); //   Result := '65' + Copy(AnsiUpperCase(GetComputerNameFunc) + DupeString('0', 20), 1, 18);
end;

// -------------------------------- //
// Retorna o CGC e IE               //
// IF BEMATECH MP20 FI              //
// -------------------------------- //
function _ecf65_CGCIE(pP1: Boolean): String;
begin
  Result := Form1.ibDataSet13.FieldByname('CGC').AsString+Chr(10)+Form1.ibDataSet13.FieldByname('IE').AsString;
end;

// --------------------------------- //
// Retorna o número de cancelamentos //
// IF BEMATECH MP20 FI               //
// --------------------------------- //
function _ecf65_Cancelamentos(pP1: Boolean): String;
begin
  Result := '0';
end; 

// -------------------------------- //
// Retorna o valor de descontos     //
// IF BEMATECH MP20 FI              //
// -------------------------------- //
function _ecf65_Descontos(pP1: Boolean): String;
begin
  Result := '0';
end;

// -------------------------------- //
// Retorna o contados sequencial    //
// IF BEMATECH MP20 FI              //
// -------------------------------- //
function _ecf65_ContadorSeqencial(pP1: Boolean): String;
begin
  Result := '0';
end;

// -------------------------------- //
// Retorna o número de operações    //
// não fiscais acumuladas           //
// IF BEMATECH MP20 FI              //
// -------------------------------- //
function _ecf65_Nmdeoperaesnofiscais(pP1: Boolean): String;
begin
  Result := '0';
end;

function _ecf65_NmdeCuponscancelados(pP1: Boolean): String;
begin
  Result := '0';
end;

function _ecf65_NmdeRedues(pP1: Boolean): String;
begin
  Result := '0';
end;

function _ecf65_Nmdeintervenestcnicas(pP1: Boolean): String;
begin
  Result := '0';
end;

function _ecf65_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
begin
  Result := '0';
end;

function _ecf65_Clichdoproprietrio(pP1: Boolean): String;
begin
  Result := Form1.ibDataSet13.FieldByname('NOME').AsString+Chr(10)+
            Form1.ibDataSet13.FieldByname('CGC').AsString+Chr(10)+
            AllTrim(Form1.ibDataSet2.FieldByname('ENDERE').AsString)+' '+AllTrim(Form1.ibDataSet2.FieldByname('COMPLE').AsString)+Chr(10)+
            Form1.ibDataSet13.FieldByname('CEP').AsString+Form1.ibDataSet13.FieldByname('CIDADE').AsString+' - '+Form1.ibDataSet13.FieldByname('ESTADO').AsString+Chr(10);
end;

// ------------------------------------ //
// Importante retornar apenas 3 dígitos //
// Ex: 001                              //
// IF BEMATECH MP20 FI                  //
// ------------------------------------ //
function _ecf65_NmdoCaixa(pP1: Boolean): String;
begin
  Result := Form1.GetNumeroCaixa('65', _ecf65_NmerodeSrie(True));
end;

function _ecf65_Nmdaloja(pP1: Boolean): String;
begin
  Result := '065';
end;

function _ecf65_Moeda(pP1: Boolean): String;
begin
  Result := Copy(FormatSettings.CurrencyString,1,1);
end;

function _ecf65_Dataehoradaimpressora(pP1: Boolean): String;
begin
  FormatSettings.ShortDateFormat := 'dd/mm/yy';   {Bug 2001 free}
  Result := StrTran(StrTran(Copy(DateToStr(Date),1,8)+TimeToStr(Time),'/',''),':','');
  FormatSettings.ShortDateFormat := 'dd/mm/yyyy';   {Bug 2001 free}
end;

function _ecf65_Datadaultimareduo(pP1: Boolean): String;
begin
  Result := '00/00/0000';
end;

function _ecf65_Datadomovimento(pP1: Boolean): String;
begin
  Result := '00/00/0000';
end;

function _ecf65_Tipodaimpressora(pP1: Boolean): String;
begin
  Result := 'NFC-e';
end;

// Deve retornar uma String com:                                          //
// Os 2 primeiros dígitos são o número de aliquotas gravadas: Ex 16       //
// os póximos de 4 em 4 são as aliquotas Ex: 1800                         //
// Ex: 161800120005000000000000000000000000000000000000000000000000000000 //
function _ecf65_RetornaAliquotas(pP1: Boolean): String;
begin
  Result := Replicate('0',72);
end;

function _ecf65_Vincula(pP1: String): Boolean;
begin
  Result := False;
end;  

function _ecf65_FlagsDeISS(pP1: Boolean): String;
begin
  Result := chr(0)+chr(0);
end;

function _ecf65_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
begin
  Result := True;
end;

function _ecf65_MudaMoeda(pP1: String): Boolean;
begin
  Result := True;
end;

function _ecf65_MostraDisplay(pP1: String): Boolean;
begin
  Result := True;
end;

function _ecf65_leituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
begin
  Result := True;
end;

function _ecf65_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean;
begin
  _ecf65_ImpressaoNaoSujeitoaoICMS(sP1);
  Result := True;
end;

function _ecf65_ImpressaoNaoSujeitoaoICMS(sP1: String; bPDF: Boolean = False; LarguraPapel: Integer = 640): Boolean; // Sandro Silva 2018-11-20 function _ecf65_ImpressaoNaoSujeitoaoICMS(sP1: String; bPDF: Boolean = False): Boolean;
begin
  Result := Form1.ImpressaoNaoSujeitoaoICMS(sP1, bPDF, LarguraPapel); // Sandro Silva 2018-11-20 Result := Form1.ImpressaoNaoSujeitoaoICMS(sP1, bPDF);
end;

function _ecf65_FechaCupom2(sP1: Boolean): Boolean;
begin
  Result := True;
end;

function _ecf65_ImprimeCheque(rP1: Real; sP2: String): Boolean;
begin
  Result := False;
end;

function _ecf65_MapaResumo(sP1: Boolean): Boolean;
begin
  Result := True;
end;

function _ecf65_FormataTx(sP1: String): Integer;
begin
  Result := 0;
end;

function _ecf65_GrandeTotal(sP1: Boolean): String;
begin
  //
  Result := Replicate('0',18);
  //
end;

function _ecf65_TotalizadoresDasAliquotas(sP1: Boolean): String;
begin
  Result := Replicate('0',438);
end;  

function _ecf65_CupomAberto(sP1: Boolean): boolean;
var
  Mais1Ini : tIniFile;
  sCupom   : String;
begin
  Result := False;// Sempre começa como falso. Verdadeiro somente se encontrar pendente
  {Sandro Silva 2023-08-22 inicio
  Mais1ini  := TIniFile.Create('FRENTE.INI');
  //
  try
    sCupom := FormataNumeroDoCupom(StrToInt(Mais1Ini.ReadString('NFCE','CUPOM','000001')));
  except
    sCupom := FormataNumeroDoCupom(0); // Sandro Silva 2021-12-02 sCupom := '000000';
  end;
  //
  Mais1Ini.Free;
  }
  try
    sCupom := FormataNumeroDoCupom(StrToInt(LeNumeroCupomFrenteINI('65', '000001')));
  except
    sCupom := FormataNumeroDoCupom(0);
  end;
  {Sandro Silva 2023-08-22 fim}

  sCupom := FormataNumeroDoCupom(StrToInt(sCupom)); // Sandro Silva 2021-12-01
  //
  Form1.ibQuery65.Close;
  Form1.ibQuery65.SQL.Clear;
  Form1.ibQuery65.SQL.Text := 'select * from NFCE where NUMERONF='+QuotedStr(sCupom)+' and CAIXA = ' + QuotedStr(Form1.sCaixa);
  Form1.ibQuery65.Open;
  //
  // SmallMsg(Form1.ibQuery65.FieldByname('NUMERONF').AsString+chr(10)+sCupom);
  //
  if Form1.ibQuery65.FieldByname('NUMERONF').AsString=sCupom then
  begin
    if (
        (_ecf65_xmlAutorizado(Form1.ibQuery65.FieldByname('NFEXML').AsString) = False) and
        (Pos('<xEvento>Cancelamento</xEvento>', Form1.ibQuery65.FieldByname('NFEXML').AsString) = 0) and
        (Pos('<descEvento>Cancelamento', Form1.ibQuery65.FieldByname('NFEXML').AsString) = 0) and
        (_ecf65_UsoDenegado(Form1.ibQuery65.FieldByname('NFEXML').AsString) = False) and
        ((Pos('contingência', Form1.ibQuery65.FieldByname('STATUS').AsString) = 0) and (Pos('<tpEmis>9</tpEmis>', Form1.ibQuery65.FieldByname('NFEXML').AsString) = 0))) // Não abrir NFCE.exe com a última contingência pendente
        or (Pos(TIPOCONTINGENCIA, Form1.ClienteSmallMobile.sVendaImportando) > 0)
         then
    begin
      // 2015-07-09 if Form1.bImportando = False then
      if (Form1.ClienteSmallMobile.sVendaImportando = '')
        or (Pos(TIPOCONTINGENCIA, Form1.ClienteSmallMobile.sVendaImportando) > 0)
      then
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

function _ecf65_FaltaPagamento(sP1: Boolean): boolean;
begin
  Result := False;
end;

function _ecf65_EnviarNFCeContingencia(dtData: TDate; sNumeroNF: String;
  sCaixa: String): Boolean;
var
  sRetorno: String;
  sRetornoConsultaRecibo: String;
  sLote: String;
  fNFe1: String;
  sLogErro: String;
  sID: String;
  sStatus: String;
  sArquivoXMLAutorizado: String;
  sArquivoLogContingencia: String;
  slNFCeAutorizada: TStringList; // Sandro Silva 2019-07-23
  re: TRichEdit; // Sandro Silva 2019-07-23
  sNfceIdSubstituido: String; // Sandro Silva 2019-07-25
  sNfceIdSubstituto: String; // Sandro Silva 2019-07-30
  sCondicaoNFCeTransmite: String; // Sandro Silva 2019-07-25
  sLogErroEnvio: String; // Sandro Silva 2019-08-09
  bProcessouNFCeSubstituidaNaoConstaNaSefaz: Boolean; // Sandro Silva 2021-10-04
  bTransmitiuContingencia: Boolean; // Sandro Silva 2022-11-04
  function SalvaXMLAutorizado(sXMLEnviado: String; sRetorno: String): String;
  var
    sXMLConsulta: String;
    sDigestValue: String;
    sArqPrimeiroEnvio: String;
    sArqRetSituacao: String;
    schNFe: String;
    sXMLRecuperado: String;
  begin
    schNFe := xmlNodeValue(sRetorno, '//protNFe/infProt/chNFe');

    sXMLConsulta := sRetorno; //Form1.spdNFCe1.ConsultarNF(schNFe);
    sDigestValue := xmlNodeValue(sXMLConsulta, '//protNFe/infProt/digVal');

    if sXMLConsulta <> '' then
    begin

      sArqPrimeiroEnvio := Form1.spdNFCe1.DiretorioLog + '\' + SelecionaXmlEnvio(Form1.spdNFCe1.DiretorioLog + '\*' + schNFe + '-env-sinc-lot.xml', sDigestValue, '//DigestValue');
      sArqRetSituacao   := Form1.spdNFCe1.DiretorioLog + '\' + SelecionaXmlEnvio(Form1.spdNFCe1.DiretorioLog + '\*' + schNFe + '-env-sinc-ret.xml', sDigestValue, '//digVal');

      if (FileExists(sArqPrimeiroEnvio)) and (FileExists(sArqRetSituacao)) then
      begin
        Form1.spdNFCe1.GerarXMLEnvioDestinatario(
          schNFe, //edtId.Text,
          sArqPrimeiroEnvio, // _LogEnv,
          sArqRetSituacao, // _LogRetCons,
          Form1.spdNFCe1.DiretorioLog + '\' + schNFe + '-recuperada-nfce.xml'); // Gerar pelo XML em tempo carregado.

        // Não existindo arquivo aguarda se componente está terminando de salvar
        if FileExists(PChar(Form1.spdNFCe1.DiretorioLog + '\' + schNFe + '-recuperada-nfce.xml')) = False then // Sandro Silva 2021-06-11
          Sleep(150);

        if FileExists(PChar(Form1.spdNFCe1.DiretorioLog + '\' + schNFe + '-recuperada-nfce.xml')) then
        begin
          sXMLRecuperado := _ecf65_LoadXmlRecuperado(schNFe);
          if (xmlNodeValue(sXMLEnviado, '//SignatureValue') = xmlNodeValue(sXMLRecuperado, '//SignatureValue')) then
          begin
            if MoveFile(PChar(Form1.spdNFCe1.DiretorioLog + '\' + schNFe + '-recuperada-nfce.xml'), PChar(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + schNFe + '-nfce.xml')) then
            begin
              if FileExists(PChar(Form1.spdNFCe1.DiretorioXmlDestinatario + schNFe + '-nfce.xml')) then
                Result := Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + schNFe + '-nfce.xml';
            end;
          end;
        end;
      end;
      
    end; // if sXMLConsulta <> '' then
  end;

  function AdicionaLogCDS(bDuplicarLog: Boolean; sRegistro: String;
    sMensagemLog: String; sData: String; sNumeroNF: String;
    sCaixa: String): Boolean;
  var
    bErroProcessado: Boolean; // Sandro Silva 2017-08-23
  begin
    Result := False;
    bErroProcessado := False;

    if bDuplicarLog = False then
    begin
      Form1.ClientDataSet1.Filtered := False;
      Form1.ClientDataSet1.Filter   := '(NUMERONF = ' +  QuotedStr(sNumeroNF) + ' and CAIXA = ' + QuotedStr(sCaixa) + ')'; // Sandro Silva 2019-08-14 Form1.ClientDataSet1.Filter   := '(REGISTRO = ' + QuotedStr(sRegistro) + ') or (NUMERONF = ' +  QuotedStr(sNumeroNF) + ' and CAIXA = ' + QuotedStr(sCaixa) + ')'; // Sandro Silva 2019-08-09 Form1.ClientDataSet1.Filter   := 'REGISTRO = ' + QuotedStr(sRegistro);
      Form1.ClientDataSet1.Filtered := True;
      Form1.ClientDataSet1.First;

      while Form1.ClientDataSet1.Eof = False do
      begin
        if Form1.ClientDataSet1.FieldByName('LOG').AsString = sMensagemLog then
        begin
          bErroProcessado := True;
          // Sandro Silva 2019-08-09  Form1.ClientDataSet1.Filtered := False;
          Break;
        end;
        Form1.ClientDataSet1.Next;
      end;

     Form1.ClientDataSet1.Filtered := False;
    end;

    if bErroProcessado = False then
    begin
      Form1.ClientDataSet1.Append;
      Form1.ClientDataSet1.FieldByName('REGISTRO').AsString   := sRegistro;
      Form1.ClientDataSet1.FieldByName('DATA').AsString       := sData;
      Form1.ClientDataSet1.FieldByName('NUMERONF').AsString   := sNUMERONF;
      Form1.ClientDataSet1.FieldByName('CAIXA').AsString      := sCaixa;
      Form1.ClientDataSet1.FieldByName('LOG').AsString        := sMensagemLog; //Copy(sMensagemLog, 1, Form1.ClientDataSet1.FieldByName('LOG').Size); // Sandro Silva 2019-06-28 sMensagemLog
      Form1.ClientDataSet1.Post;

    end; // if bErroProcessado = False then

  end;

  procedure AtualizarDadosRelacionadosComNFCeCancelada(sNumero: String; sCaixa: String);
  // Cancela a nfc-e transmitida pela rotina _ecf65_EnviarNFCeContingencia()
  var
    iCupomOld: Integer;
    sCaixaOld: String;
  begin
    iCupomOld := Form1.iCupom;
    sCaixaOld := Form1.sCaixa;

    Form1.iCupom := StrToInt(sNumero);
    Form1.sCaixa := Right('000' + sCaixa, 3);

    try
      Audita('CANCELA','FRENTE', '', 'Cancelamento NFC-e ' + sNumero + ' CX ' + sCaixa + ' #7225', 0,0); // Ato, Modulo, Usuário, Histórico, Valor
    except

    end;

    Form1.Button4Click(Form1.Button4);

    Form1.iCupom := iCupomOld;
    Form1.sCaixa := sCaixaOld;
  end;
begin
  if ValidaRecursos.ValidaQtdDocumentoFrente(ValidaRecursos.DataDoServidor, tmdTransmitindo) = False then
  begin
    Form1.MensagemAlertaLimiteDocumentosEmitidos;
  end
  else
  begin

    bTransmitiuContingencia := False; // Sandro Silva 2022-11-04

    bProcessouNFCeSubstituidaNaoConstaNaSefaz := False; // Torna-se True quando identificado que é NFC-e para ser substituída e não conta na base da sefaz. Não precisa transmitir, faz inutilização do número

    sArquivoLogContingencia := Form1.spdNFCe1.DiretorioLog + '\log_transmissao_contingencia_' + Form1.sCaixa + '_' + FormatDateTime('yyyymmddHHnnsszzz', Now) + '.html';

    DeleteFile(PChar(sArquivoLogContingencia));

    _ecf65_ConsultarStatusServico(False);

    if (Form1.bStatusRede) and (Form1.NFCeemContingncia1.Checked = False) and (Pos('sem serviço', AnsiLowerCase(Form1.sStatusECF)) = 0) and (Form1.bStatusECF) then
    begin

      Form1.Timer2.Enabled := False;
      Screen.Cursor := crHourGlass;

      sLogErro := '';

      try
        _ecf65_bTransmitindoContingenciaNFCe := True; // Usado na rotinas de baixa/retorno no estoque para identificar qual ação disparou a movimentação Sandro Silva 2019-07-25

        Commitatudo(True); // _ecf65_EnviarNFCeContingencia()

        // Trata as NFC-e em contingência com Rejeição 562: Código Numérico informado na Chave de Acesso difere do Código Numérico da NF-e
        Form1.IBQuery65.Close;
        Form1.IBQuery65.SQL.Text :=
          'select * ' +
          'from NFCE ' +
          'where (coalesce(STATUS, '''') containing ''Duplicidade'' and coalesce(STATUS, '''') containing ''[chNFe'' ' + // Duplicidade com diferença na chave de acesso do xml com a chave na Sefaz e sem chave salva no campo NFEID
          'or coalesce(STATUS, '''') containing ''Rejeição: Duplicidade de NF-e, com diferença na Chave de Acesso'') ' +
          ' and DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtData));
        Form1.IBQuery65.Open;
        while Form1.IBQuery65.Eof = False do
        begin

          _ecf65_CorrigeRejeicaoChaveDeAcessoDifere(Form1.IBQuery65.FieldByName('NUMERONF').AsString, Form1.IBQuery65.FieldByName('CAIXA').AsString, False);

          Form1.IBQuery65.Next;
        end;

        Commitatudo(True); // _ecf65_EnviarNFCeContingencia()
            
        Form1.IBQuery65.Close;
        if sNumeroNF <> '' then
          sCondicaoNFCeTransmite := // Uma nota
            ' and NUMERONF = ' + QuotedStr(sNumeroNF) +
            ' and CAIXA = ' + QuotedStr(sCaixa) +
            ' and coalesce(STATUS, '''') not containing ''autorizad'' '
        else
          sCondicaoNFCeTransmite := // todas notas do dia em contingência ou com cancelamento por substituição
            ' and ((coalesce(STATUS, '''') containing ''contingência'' or (coalesce(NFEXML, '''') containing ''<tpEmis>9</tpEmis>'' and coalesce(STATUS, '''') not containing ''autorizad'')) ' +
                   'or (coalesce(NFEIDSUBSTITUTO, '''') <> '''' and coalesce(STATUS, '''') not containing ''cancela'')) '
            ;

        Form1.IBQuery65.SQL.Text :=
          'select * ' +
          'from NFCE ' +
          'where MODELO = ''65'' ' +
          ' and DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtData)) +
          ' and coalesce(STATUS, '''') not containing ''deneg'' ' + // Sandro Silva 2020-05-14
          sCondicaoNFCeTransmite +
          ' order by NFEIDSUBSTITUTO, DATA, NUMERONF, CAIXA '; // Ordenar para que as NFC-E com ID de substituição fiquem por último
        Form1.IBQuery65.Open;

        if Form1.IBQuery65.FieldByName('REGISTRO').AsString <> '' then
        begin
          Form1.ClientDataSet1.Close;
          Form1.ClientDataSet1.FileName := 'LogContingencia' + Form1.sCaixa + '.cds';
          Form1.ClientDataSet1.CreateDataSet;
        end;

        while Form1.IBQuery65.Eof = False do
        begin
          try
            sRetorno := ''; // Sandro Silva 2018-08-06
            sArquivoXMLAutorizado := ''; // Sandro Silva 2018-08-06

            if Form1.bStatusRede = False then
              Break;

            if (xmlNodeValue(Form1.IBQuery65.FieldByName('NFEXML').AsString, '//emit/CNPJ') = LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString))
              or (LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString) = LimpaNumero(CNPJ_SOFTWARE_HOUSE_PAF)) // Para poder testar com bancos de clientes
            then
            begin

              bTransmitiuContingencia := True; // Sandro Silva 2022-11-04

              Form1.IBDataSet150.Close;
              Form1.IBDataSet150.SelectSQL.Text :=
                'select * ' +
                'from NFCE ' +
                'where MODELO = ''65'' ' +
                ' and NUMERONF = ' + QuotedStr(Form1.IBQuery65.FieldByName('NUMERONF').AsString) +
                ' and CAIXA = ' + QuotedStr(Form1.IBQuery65.FieldByName('CAIXA').AsString);
              Form1.IBDataSet150.Open;

              if ((xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//ide/tpEmis') <> TPEMIS_NFCE_NORMAL) // Não é emissão normal
                  and (Trim(Form1.IBDataSet150.FieldByName('NFEXML').AsString) <> '')) // tem xml
                 or ((AnsiContainsText('|' + xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//infProt/cStat') + '|', '|100|150|') = False) // sem cstat autorizado
                     and (Form1.IBDataSet150.FieldByName('NFEXML').AsString <> '')
                     )
                then
              begin

                Form1.ExibePanelMensagem('Aguarde. Transmitindo notas do Caixa ' + Form1.IBQuery65.FieldByName('CAIXA').AsString + ', NFC-e: '  + Form1.IBQuery65.FieldByName('NUMERONF').AsString + '...');

                sLote := Form1.IBQuery65.FieldByName('NUMERONF').AsString;
                fNFe1 := Form1.IBQuery65.FieldByName('NFEXML').AsString;

                sArquivoXMLAutorizado := '';

                try
                  //Não assinar porque muda o digest value fNFe1 := Form1.spdNFCe1.AssinarNota(fNFe1); // Caso certificado foi renovado depois de ter gerado a nfce

                  _ecf65_NumeroSessaoIntegradorFiscal; // Sandro Silva 2018-04-23

                  if Copy(LimpaNumero(xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//infNFe/@Id')), 35, 1) = TPEMIS_NFCE_NORMAL then  // Tipo emissão normal
                  begin
                    try // Sandro Silva 2021-09-13
                      sRetorno := Form1.spdNFCe1.ConsultarNF(LimpaNumero(xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//infNFe/@Id')));
                    except

                    end;

                    sRetorno := _ecf65_CorrigePadraoRespostaSefaz(sRetorno);

                    if Pos('<cStat>217</cStat>', sRetorno) > 0 then // Rejeição: NF-e não consta na base de dados da SEFAZ
                    begin

                      //valida se NFC-e tem NFEIDSUBSTITUTO preenchido, indicando que deve ser cancelada por substituição
                      // Nesse caso se obteve rejeição 217 - Não consta na base, não precisa transmitir, basta excluir do banco e depois realizar a inutilização do número
                      if Form1.IBDataSet150.FieldByName('NFEIDSUBSTITUTO').AsString <> '' then
                      begin

                        {Sandro Silva 2021-10-04 inicio}
                        bProcessouNFCeSubstituidaNaoConstaNaSefaz := True;

                        try
                          // Faz inutilização da numeração da NFC-e
                          if AnsiContainsText(Trim(ConverteAcentos2(_ecf65_InutilizacaoNFCe(
                                                                      Form1.IBDataSet150.FieldByName('NFEID').AsString,             // ID
                                                                      Copy(Form1.IBDataSet150.FieldByName('NFEID').AsString, 3, 2), // Ano
                                                                      '65',                                                         // Modelo
                                                                      Copy(Form1.IBDataSet150.FieldByName('NFEID').AsString, 23, 3),// Série
                                                                      Form1.IBDataSet150.FieldByName('NUMERONF').AsString,          // Numeração inicial
                                                                      Form1.IBDataSet150.FieldByName('NUMERONF').AsString,          // Numeração final
                                                                      Trim(ConverteAcentos2('Numeração não utilizada'))             // Justificativa
                            ))), 'Rejeicao') = False then
                          begin

                            // Exclui os itens lançados
                            Form1.ibDataSet27.Close;
                            Form1.ibDataSet27.SelectSQL.Text :=
                              'select * ' +
                              'from ALTERACA ' +
                              'where PEDIDO = ' + QuotedStr(Form1.IBDataSet150.FieldByName('NUMERONF').AsString) +
                              ' and CAIXA = ' + QuotedStr(Form1.IBDataSet150.FieldByName('CAIXA').AsString);
                            Form1.ibDataSet27.Open;

                            while Form1.ibDataSet27.Eof = False do
                            begin
                              Form1.ibDataSet27.Delete;
                            end;

                            // Exclui as formas de pagamento
                            Form1.ibDataSet28.Close;
                            Form1.ibDataSet28.SelectSQL.Text :=
                              'select * ' +
                              'from PAGAMENT ' +
                              'where PEDIDO = ' + QuotedStr(Form1.IBDataSet150.FieldByName('NUMERONF').AsString) +
                              ' and CAIXA = ' + QuotedStr(Form1.IBDataSet150.FieldByName('CAIXA').AsString);
                            Form1.ibDataSet28.Open;

                            while Form1.ibDataSet28.Eof = False do
                            begin
                              Form1.ibDataSet28.Delete;
                            end;

                            {Sandro Silva 2021-11-03 inicio}
                            //Exclui RECEBER
                            Form1.ibDataSet7.Close;
                            Form1.ibDataSet7.SelectSQL.Text :=
                              'select * ' +
                              'from RECEBER ' +
                              'where NUMERONF='+QuotedStr(Form1.IBDataSet150.FieldByName('NUMERONF').AsString + Form1.IBDataSet150.FieldByName('CAIXA').AsString) +
                              ' order by REGISTRO';
                            Form1.ibDataSet7.Open;
                            while Form1.ibDataSet7.Eof = False do
                            begin
                              Form1.ibDataSet7.Delete;
                            end;
                            {Sandro Silva 2021-11-03 fim}

                            //Exclui a NFC-e
                            Form1.IBDataSet150.Delete;
                          end;

                        except
                        end;
                        {Sandro Silva 2021-10-04 fim}
                      end
                      else
                      begin

                        // NCF-e não consta na SEFAZ. Transmite e cancela em seguida

                        sRetorno := Form1.spdNFCe1.EnviarNFSincrono(sLote, Form1.IBDataSet150.FieldByName('NFEXML').AsString, False); // Transmitindo a NFC-e que não conseguiu transmitir durante a venda

                        sRetorno := _ecf65_CorrigePadraoRespostaSefaz(sRetorno);

                        if _ecf65_xmlAutorizado(sRetorno) then // Autorizado
                        begin

                          if Form1.IBDataSet150.FieldByName('NFEIDSUBSTITUTO').AsString <> '' then
                          begin

                            {Sandro Silva 2021-06-11 inicio}
                            try
                              Audita('EMISSAO','FRENTE', '', 'Contingencia Erro: 7844 ' + Form1.IBDataSet150.FieldByName('NUMERONF').AsString + ' ' + Form1.IBDataSet150.FieldByName('CAIXA').AsString, 0, 0); // Ato, Modulo, Usuário, Histórico, Valor
                            except
                            end;
                            {Sandro Silva 2021-06-11 fim}

                            Form1.ExibePanelMensagem('Enviando Contingência. Aguardando tempo limite para cancelamento da NFC-e substituída'); // Sandro Silva 2021-06-16

                            SmallMsgBox(PChar('NFC-e em duplicidade: ' + #13 + Form1.IBDataSet150.FieldByName('NFEID').AsString + #13 + Form1.IBDataSet150.FieldByName('NFEIDSUBSTITUTO').AsString +
                                                  #13 + #13 + 'Será cancelada a NFC-e ' + Form1.IBDataSet150.FieldByName('NFEID').AsString), 'Atenção', MB_OK + MB_ICONWARNING);

                            Sleep(120000); // Aguarda 2 minutos para fazer o cancelamento em sequência. Algumas UF não permitem intervalo de tempo pequenos entre autorização e cancelamento

                            Form1.CancelaraNFCe1Click(Form1.CancelaraNFCe1);

                            Form1.IBDataSet150.Close;
                            Form1.IBDataSet150.SelectSQL.Text :=
                              'select * ' +
                              'from NFCE ' +
                              'where MODELO = ''65'' ' +
                              ' and NUMERONF = ' + QuotedStr(Form1.IBQuery65.FieldByName('NUMERONF').AsString) +
                              ' and CAIXA = ' + QuotedStr(Form1.IBQuery65.FieldByName('CAIXA').AsString);
                            Form1.IBDataSet150.Open;

                            try
                              sRetorno := Form1.spdNFCe1.ConsultarNF(LimpaNumero(xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//infNFe/@Id')));
                            except
                            end;

                            sRetorno := _ecf65_CorrigePadraoRespostaSefaz(sRetorno);

                          end;
                        end; // if ((Pos('<cStat>100</cStat>',sRetorno) <> 0) or (Pos('<cStat>150</cStat>',sRetorno) <> 0))) // Autorizado

                      end; // if Form1.IBDataSet150.FieldByName('NFEIDSUBSTITUTO').AsString <> '' then

                    end; // if Pos('<cStat>217</cStat>', sRetorno) > 0 then // Rejeição: NF-e não consta na base de dados da SEFAZ

                  end
                  else
                  begin
                    // Tipo Emissão contingência

                    {Sandro Silva 2021-11-03 inicio}
                    // Validar se tem itens vendidos. Caso não tiver exclui a venda e inutiliza a numeração
                    if _ecf65_TodosItensCancelados(Form1.ibDataSet27.Transaction, Form1.IBDataSet150.FieldByName('NUMERONF').AsString, Form1.IBDataSet150.FieldByName('CAIXA').AsString) then
                    begin

                      bProcessouNFCeSubstituidaNaoConstaNaSefaz := True;

                      sID := Form1.IBDataSet150.FieldByName('NFEID').AsString;
                      if LimpaNumero(sID) = '' then
                        sID := LimpaNumero(xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//infNFe/@Id'));
                      if LimpaNumero(sID) <> '' then
                      begin

                        try
                          // Faz inutilização da numeração da NFC-e

                          sRetorno := _ecf65_InutilizacaoNFCe(
                                                              sID,                                                          // ID
                                                              Copy(sID, 3, 2),                                              // Ano
                                                              '65',                                                         // Modelo
                                                              Copy(sID, 23, 3),                                             // Série
                                                              Form1.IBDataSet150.FieldByName('NUMERONF').AsString,          // Numeração inicial
                                                              Form1.IBDataSet150.FieldByName('NUMERONF').AsString,          // Numeração final
                                                              Trim(ConverteAcentos2('Numeração não utilizada'))             // Justificativa
                                                             );

                          sRetorno := _ecf65_CorrigePadraoRespostaSefaz(sRetorno);

                          if AnsiContainsText(Trim(ConverteAcentos2(sRetorno)), 'Rejeicao') = False then
                          begin

                            // Exclui os itens lançados
                            Form1.ibDataSet27.Close;
                            Form1.ibDataSet27.SelectSQL.Text :=
                              'select * ' +
                              'from ALTERACA ' +
                              'where PEDIDO = ' + QuotedStr(Form1.IBDataSet150.FieldByName('NUMERONF').AsString) +
                              ' and CAIXA = ' + QuotedStr(Form1.IBDataSet150.FieldByName('CAIXA').AsString);
                            Form1.ibDataSet27.Open;

                            while Form1.ibDataSet27.Eof = False do
                            begin
                              Form1.ibDataSet27.Delete;
                            end;

                            // Exclui as formas de pagamento
                            Form1.ibDataSet28.Close;
                            Form1.ibDataSet28.SelectSQL.Text :=
                              'select * ' +
                              'from PAGAMENT ' +
                              'where PEDIDO = ' + QuotedStr(Form1.IBDataSet150.FieldByName('NUMERONF').AsString) +
                              ' and CAIXA = ' + QuotedStr(Form1.IBDataSet150.FieldByName('CAIXA').AsString);
                            Form1.ibDataSet28.Open;

                            while Form1.ibDataSet28.Eof = False do
                            begin

                              Form1.ibDataSet28.Delete;
                            end;

                            //Exclui a NFC-e
                            Form1.IBDataSet150.Delete;
                          end
                          else
                          begin

                            AdicionaLogCDS(False,
                                           Form1.IBDataSet150.FieldByName('REGISTRO').AsString,
                                           sRetorno,
                                           Form1.IBDataSet150.FieldByName('DATA').AsString,
                                           Form1.IBDataSet150.FieldByName('NUMERONF').AsString,
                                           Form1.IBDataSet150.FieldByName('CAIXA').AsString
                                           );

                          end;

                        except
                        end;

                      end;// if LimpaNumero(sID) = '' then

                    end // if _ecf65_TodosItensCancelados(Form1.ibDataSet27.Transaction, Form1.IBDataSet150.FieldByName('NUMERONF').AsString, Form1.IBDataSet150.FieldByName('CAIXA').AsString) then
                    {Sandro Silva 2021-11-03 fim}
                    else
                    begin
                      try
                        sRetorno := Form1.spdNFCe1.EnviarNFSincrono(sLote, fNFe1, False); // Transmitindo contingência

                        sRetorno := _ecf65_CorrigePadraoRespostaSefaz(sRetorno);

                      except
                        on E: Exception do
                        begin

                          AdicionaLogCDS(False,
                                         Form1.IBDataSet150.FieldByName('REGISTRO').AsString,
                                         E.Message,
                                         Form1.IBDataSet150.FieldByName('DATA').AsString,
                                         Form1.IBDataSet150.FieldByName('NUMERONF').AsString,
                                         Form1.IBDataSet150.FieldByName('CAIXA').AsString
                                         );

                        end; // on E: Exception do
                      end; // try

                    end; // if _ecf65_TodosItensCancelados(Form1.ibDataSet27.Transaction, Form1.IBDataSet150.FieldByName('NUMERONF').AsString, Form1.IBDataSet150.FieldByName('CAIXA').AsString) then

                  end;

                  //consultar id qdo sem retorno?
                  if (
                       (AnsiContainsText(sRetorno, 'Duplicidade') and (AnsiContainsText(sRetorno, '<cStat>204</cStat>'))) // Duplicidade
                       or (_ecf65_xmlAutorizado(sRetorno))
                     )
                    and (_ecf65_XmlNfceCancelado(sRetorno) = False) // Sandro Silva 2019-07-31
                    then
                  begin// Copiar recibo, consultar recibo e id, ver o que retornar e analisar como identificar se mesmo xml enviado anteriormente está em xmldestinatario

                    try
                      // Sandro Silva 2022-04-12 if ((Pos('<cStat>100</cStat>',sRetorno) <> 0) or (Pos('<cStat>150</cStat>',sRetorno) <> 0)) then // Autorizado
                      if (_ecf65_xmlAutorizado(sRetorno)) then // Autorizado
                      begin
                        sRetornoConsultaRecibo := sRetorno
                      end
                      else
                      begin
                        try
                          sRetornoConsultaRecibo := Form1.spdNFCe1.ConsultarNF(LimpaNumero(xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//infNFe/@Id')));
                        except

                        end;

                        sRetornoConsultaRecibo := _ecf65_CorrigePadraoRespostaSefaz(sRetornoConsultaRecibo);

                      end;

                      if (_ecf65_xmlAutorizado(sRetornoConsultaRecibo))
                        and (_ecf65_XmlNfceCancelado(sRetornoConsultaRecibo) = False) then
                      begin
                        // Se foi autorizada faz a montagem do xml assinado com os dados da autorização
                        if xmlNodeXML(sRetornoConsultaRecibo, '//protNFe') <> '' then
                        begin

                          //conferir o digestvalue do retorno com o digest da nota enviada
                          if xmlNodeValue(sRetornoConsultaRecibo, '//infProt/digVal') = xmlNodeValue(fNFe1, '//DigestValue') then
                          begin

                            if xmlNodeValue(fNFe1, '//infProt/digVal') = '' then // No xml lido do banco ainda não tem as tags de autorização. Caso consulte 2x a mesma chave
                            begin
                              sRetornoConsultaRecibo := ConcatencaNodeNFeComProtNFe(fNFe1, sRetornoConsultaRecibo);
                            end
                            else
                            begin
                              sRetornoConsultaRecibo := fNFe1; // XML lido do banco já tem as tags de autorização
                            end;

                            slNFCeAutorizada := TStringList.Create;
                            slNFCeAutorizada.Text := sRetornoConsultaRecibo;
                            slNFCeAutorizada.SaveToFile(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + LimpaNumero(xmlNodeValue(sRetornoConsultaRecibo, '//infNFe/@Id')) + '-nfce.xml');
                            Sleep(100); // Sandro Silva 2021-11-03
                            FreeAndNil(slNFCeAutorizada);

                            sRetorno := sRetornoConsultaRecibo;
                          end;

                        end; // if xmlNodeXML(sRetornoConsultaRecibo, '//protNFe') <> '' then

                      end; // if (Pos('<cStat>100</cStat>',sRetornoConsultaRecibo) <> 0) or (Pos('<cStat>150</cStat>',sRetornoConsultaRecibo) <> 0) then

                    except

                    end;

                  end; // if AnsiContainsText(sRetorno, 'Duplicidade') and (AnsiContainsText(sRetorno, '<cStat>204</cStat>')) then

                except
                  on E: Exception do
                  begin

                    AdicionaLogCDS(False,
                                   Form1.IBDataSet150.FieldByName('REGISTRO').AsString,
                                   E.Message,
                                   Form1.IBDataSet150.FieldByName('DATA').AsString,
                                   Form1.IBDataSet150.FieldByName('NUMERONF').AsString,
                                   Form1.IBDataSet150.FieldByName('CAIXA').AsString);

                  end; // on E: Exception do
                end; // try

                Form1.ClientDataSet1.Filtered := False;

                if bProcessouNFCeSubstituidaNaoConstaNaSefaz = False then // Sandro Silva 2021-10-04
                begin

                  if (_ecf65_xmlAutorizado(sRetorno)) // 100|Autorizado o uso da NF-e ou 150|Autorizado o uso da NF-e, autorização fora de prazo
                    and (_ecf65_XmlNfceCancelado(sRetorno) = False) then
                  begin // Autorizada
                    //
                    sID   := xmlNodeValue(sRetorno, '//chNFe'); // Copia o ID da NFe p/ o Edit
                    fNFe1 := _ecf65_LoadXmlDestinatario(sID);
                    //
                    try
                      Form1.ibDataSet27.Close;
                      Form1.ibDataSet27.SelectSQL.Text :=
                        'select * ' +
                        'from ALTERACA ' +
                        'where PEDIDO = ' + QuotedStr(Form1.IBDataSet150.FieldByName('NUMERONF').AsString) +
                        ' and CAIXA = ' + QuotedStr(Form1.IBDataSet150.FieldByName('CAIXA').AsString);
                      Form1.ibDataSet27.Open;
                      while Form1.ibDataSet27.Eof = False do
                      begin

                        try
                          Form1.ibDataSet27.Edit;
                          Form1.ibDataSet27.FieldByName('COO').AsString := Form1.IBDataSet150.FieldByName('NUMERONF').AsString;
                          Form1.ibDataSet27.FieldByName('CCF').AsString := Form1.IBDataSet150.FieldByName('NUMERONF').AsString;
                          Form1.ibDataSet27.Post;
                        except
                        end;

                        Form1.ibDataSet27.Next;
                      end;
                    except
                      on E: Exception do
                      begin

                      end;
                    end;

                    sArquivoXMLAutorizado := fNFe1;

                  end
                  else
                  begin  // cStat diferente de autorizado
                    if _ecf65_XmlNfceCancelado(sRetorno) = False then
                    begin
                      if (xmlNodeValue(sRetorno, '//infProt/xMotivo') <> '')
                        or (xmlNodeValue(sRetorno, '//retEnviNFe/xMotivo') <> '') then
                      begin
                        try
                          Form1.IBDataSet150.Edit;
                          if xmlNodeValue(sRetorno, '//infProt/xMotivo') = '' then
                          begin
                            Form1.IBDataSet150.FieldByName('STATUS').AsString := Copy(xmlNodeValue(sRetorno, '//retEnviNFe/xMotivo'), 1, Form1.IBDataSet150.FieldByName('STATUS').Size);
                          end
                          else
                          begin
                            Form1.IBDataSet150.FieldByName('STATUS').AsString := Copy(xmlNodeValue(sRetorno, '//infProt/xMotivo'), 1, Form1.IBDataSet150.FieldByName('STATUS').Size);
                          end;
                          Form1.IBDataSet150.Post;

                        except

                        end;
                      end;

                      if xmlNodeValue(sRetorno, '//xMotivo') <> '' then
                      begin
                        AdicionaLogCDS(False, // Sandro Silva 2019-08-09  True,
                                       Form1.IBDataSet150.FieldByName('REGISTRO').AsString,
                                       xmlNodeValue(sRetorno, '//xMotivo'),
                                       Form1.IBQuery65.FieldByName('DATA').AsString,
                                       Form1.IBQuery65.FieldByName('NUMERONF').AsString,
                                       Form1.IBQuery65.FieldByName('CAIXA').AsString)
                      end;

                    end; // if _ecf65_XmlNfceCancelado(sRetorno) then

                  end; // if (Pos('<cStat>100</cStat>', sRetorno) <> 0) or (Pos('<cStat>150</cStat>', sRetorno) <> 0) then // 100|Autorizado o uso da NF-e ou 150|Autorizado o uso da NF-e, autorização fora de prazo

                  {Sandro Silva 2019-07-25 inicio}
                  if Trim(sRetorno) = '' then
                  begin
                    AdicionaLogCDS(False,
                                   Form1.IBDataSet150.FieldByName('REGISTRO').AsString,
                                   NFCE_NAO_HOUVE_RETORNO_SERVIDOR,
                                   Form1.IBDataSet150.FieldByName('DATA').AsString,
                                   Form1.IBDataSet150.FieldByName('NUMERONF').AsString,
                                   Form1.IBDataSet150.FieldByName('CAIXA').AsString
                                   );
                  end;
                  {Sandro Silva 2019-07-25 fim}

                  if sArquivoXMLAutorizado <> '' then
                  begin
                    if _ecf65_LoadXmlDestinatario(LimpaNumero(xmlNodeValue(fNFe1, '//infNFe/@Id'))) <> '' then
                    begin
                      // Autorizou NFC-e
                      // Atualiza dados da venda no banco
                      try

                        {Sandro Silva 2021-11-19 inicio} 
                        Form1.IBDataSet150.Close;
                        Form1.IBDataSet150.SelectSQL.Text :=
                          'select * ' +
                          'from NFCE ' +
                          'where MODELO = ''65'' ' +
                          ' and NUMERONF = ' + QuotedStr(Form1.IBQuery65.FieldByName('NUMERONF').AsString) +
                          ' and CAIXA = ' + QuotedStr(Form1.IBQuery65.FieldByName('CAIXA').AsString);
                        Form1.IBDataSet150.Open;
                        {Sandro Silva 2021-11-19 fim}

                        Form1.IBDataSet150.Edit;
                        Form1.IBDataSet150.FieldByName('NFEXML').AsString := _ecf65_LoadXmlDestinatario(LimpaNumero(xmlNodeValue(fNFe1, '//infNFe/@Id')));
                        if xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//ide/tpAmb') = TPAMB_HOMOLOGACAO then
                          sStatus := NFCE_STATUS_AUTORIZADO_USO_EM_HOMOLOGACAO// 'Autorizado o uso da NFC-e em ambiente de homologação';
                        else
                          sStatus := NFCE_STATUS_AUTORIZADO_USO_EM_PRODUCAO;// 'Autorizado o uso da NFC-e';

                        if xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//infProt/chNFe') <> '' then
                          Form1.IBDataSet150.FieldByName('NFEID').AsString := xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//infProt/chNFe'); // Só terá o ID preenchido depois de transmitida
                        Form1.IBDataSet150.FieldByName('STATUS').AsString := sStatus;
                        if xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//vNF') <> '' then
                          Form1.IBDataSet150.FieldByName('TOTAL').AsFloat   := xmlNodeValueToFloat(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//vNF'); // Ficha 4302 Sandro Silva 2018-12-05
                        Form1.IBDataSet150.Post;

                      except

                      end;

                      // Seleciona novamente os dados da NFC-e porque o campo CAIXA estava ficando vazio depois do post acima
                      Form1.IBDataSet150.Close;
                      Form1.IBDataSet150.SelectSQL.Text :=
                        'select * ' +
                        'from NFCE ' +
                        'where MODELO = ''65'' ' +
                        ' and NUMERONF = ' + QuotedStr(Form1.IBQuery65.FieldByName('NUMERONF').AsString) +
                        ' and CAIXA = ' + QuotedStr(Form1.IBQuery65.FieldByName('CAIXA').AsString);
                      Form1.IBDataSet150.Open;
                      sNfceIdSubstituto  := Form1.IBDataSet150.FieldByName('NFEIDSUBSTITUTO').AsString;
                      sNfceIdSubstituido := Form1.IBDataSet150.FieldByName('NFEID').AsString;

                      if (sNfceIdSubstituido <> '') and (sNfceIdSubstituto <> '') then // Está substituindo outra NFC-e   // Sandro Silva 2019-07-31 if sNfceIdSubstituido <> '' then // Está substituindo outra NFC-e
                      begin

                        // Faz o cancelamento por substituição
                        if _ecf65_CancelaNFCePorSubstituicao(
                              sNfceIdSubstituido,
                              'Nenhum retorno do Servidor da SEFAZ na transmissao da autorizacao de emissao do documento',
                              sNfceIdSubstituto, //ID o substituto (contingência)
                              sRetorno // Recebe o retorno do cancelamento para usar abaixo
                              ) = False then
                        begin
                          try
                            // Seleciona os dados da NFC-e a ser substituída
                            Form1.IBDataSet150.Close;
                            Form1.IBDataSet150.SelectSQL.Text :=
                              'select * ' +
                              'from NFCE ' +
                              'where NFEID = ' + QuotedStr(sNfceIdSubstituido);
                            Form1.IBDataSet150.Open;

                            if (Pos('<cStat>501</cStat>', sRetorno) > 0)   // Rejeição: Prazo de cancelamento superior ao previsto na Legislação
                              or (Pos('<cStat>913</cStat>', sRetorno) > 0) //  Rejeição: NF-e Substituta Denegada ou Cancelada
                              or (Pos('<cStat>914</cStat>', sRetorno) > 0) // Rejeição: Data de emissão da NF-e Substituta maior que 2 horas da data de emissão da NF-e a ser cancelada
                              or (Pos('<cStat>915</cStat>', sRetorno) > 0) //  Rejeição: Valor total da NF-e Substituta difere do valor da NF-e a ser cancelada
                              or (Pos('<cStat>916</cStat>', sRetorno) > 0) //  Rejeição: Valor total do ICMS da NF-e Substituta difere do valor da NF-e a ser cancelada
                              or (Pos('<cStat>917</cStat>', sRetorno) > 0) //  Rejeição: Identificação do destinatário da NF-e Substituta difere da identificação do destinatário da NF-e a ser cancelada.
                              or (Pos('<cStat>918</cStat>', sRetorno) > 0) //  Rejeição: Quantidade de itens da NF-e Substituta difere da quantidade de itens da NF-e a ser cancelada.
                              or (Pos('<cStat>919</cStat>', sRetorno) > 0) //  Rejeição: Item da NF-e Substituta difere do mesmo item da NF-e a ser cancelada.
                              or (Pos('<cStat>920</cStat>', sRetorno) > 0) //  Rejeição: Tipo de Emissão inválido no Cancelamento por Substituição
                              then // Sandro Silva 2019-08-14 if (Pos('<cStat>501</cStat>', sRetorno) > 0)
                              sLogErroEnvio := 'Cancelamento da NFC-e ' + sNfceIdSubstituido + ' por substituição não realizado. Considere emitir um NF-e de devolução: ' + xmlNodeValue(sRetorno, '//xMotivo')
                            else
                              sLogErroEnvio := 'Tente novamente mais tarde. Cancelamento da NFC-e ' + sNfceIdSubstituido + ' por substituição não realizado: ' + xmlNodeValue(sRetorno, '//xMotivo');

                            AdicionaLogCDS(False, // Sandro Silva 2019-08-09  True,
                                           Form1.IBDataSet150.FieldByName('REGISTRO').AsString,
                                           sLogErroEnvio,
                                           Form1.IBQuery65.FieldByName('DATA').AsString,
                                           Form1.IBQuery65.FieldByName('NUMERONF').AsString,
                                           Form1.IBQuery65.FieldByName('CAIXA').AsString);

                          except

                          end;

                        end
                        else
                        begin
                          // Cancelamento foi aceito e registrado na SEFAZ
                          if _ecf65_XmlNfceCancelado(sRetorno) then
                          begin
                            // Cancelamento por substituição registrado e vinculado
                            // Atualiza dados de cancelamento da venda no banco
                            try
                              // Seleciona os dados da NFC-e substituida
                              Form1.IBDataSet150.Close;
                              Form1.IBDataSet150.SelectSQL.Text :=
                                'select * ' +
                                'from NFCE ' +
                                'where NFEID = ' + QuotedStr(sNfceIdSubstituido);
                              Form1.IBDataSet150.Open;

                              if (Form1.IBDataSet150.FieldByName('NFEID').AsString <> '') and (Form1.IBDataSet150.FieldByName('NFEID').AsString = sNfceIdSubstituido) then
                              begin

                                Form1.IBDataSet150.Edit;
                                Form1.IBDataSet150.FieldByName('NFEXML').AsString := sRetorno;
                                Form1.IBDataSet150.FieldByName('STATUS').AsString := NFCE_STATUS_CANCELAMENTO; // Sandro Silva 2021-12-07 'Cancelamento Registrado e vinculado a NFCe';
                                Form1.IBDataSet150.FieldByName('NFEIDSUBSTITUTO').Clear;
                                Form1.IBDataSet150.FieldByName('TOTAL').Clear;
                                Form1.IBDataSet150.Post;

                              end;

                            except

                            end;

                          end
                          else
                          begin // Retorno não de cancelamento

                            // Seleciona os dados da NFC-e a ser substituída
                            Form1.IBDataSet150.Close;
                            Form1.IBDataSet150.SelectSQL.Text :=
                              'select * ' +
                              'from NFCE ' +
                              'where NFEID = ' + QuotedStr(sNfceIdSubstituido);
                            Form1.IBDataSet150.Open;

                            if (Pos('<cStat>501</cStat>', sRetorno) > 0)   // Rejeição: Prazo de cancelamento superior ao previsto na Legislação
                              or (Pos('<cStat>913</cStat>', sRetorno) > 0) //  Rejeição: NF-e Substituta Denegada ou Cancelada
                              or (Pos('<cStat>914</cStat>', sRetorno) > 0) // Rejeição: Data de emissão da NF-e Substituta maior que 2 horas da data de emissão da NF-e a ser cancelada
                              or (Pos('<cStat>915</cStat>', sRetorno) > 0) //  Rejeição: Valor total da NF-e Substituta difere do valor da NF-e a ser cancelada
                              or (Pos('<cStat>916</cStat>', sRetorno) > 0) //  Rejeição: Valor total do ICMS da NF-e Substituta difere do valor da NF-e a ser cancelada
                              or (Pos('<cStat>917</cStat>', sRetorno) > 0) //  Rejeição: Identificação do destinatário da NF-e Substituta difere da identificação do destinatário da NF-e a ser cancelada.
                              or (Pos('<cStat>918</cStat>', sRetorno) > 0) //  Rejeição: Quantidade de itens da NF-e Substituta difere da quantidade de itens da NF-e a ser cancelada.
                              or (Pos('<cStat>919</cStat>', sRetorno) > 0) //  Rejeição: Item da NF-e Substituta difere do mesmo item da NF-e a ser cancelada.
                              or (Pos('<cStat>920</cStat>', sRetorno) > 0) //  Rejeição: Tipo de Emissão inválido no Cancelamento por Substituição
                              then // Sandro Silva 2019-08-14 if (Pos('<cStat>501</cStat>', sRetorno) > 0)
                              sLogErroEnvio := 'Cancelamento da NFC-e ' + sNfceIdSubstituido + ' por substituição não realizado. Considere emitir um NF-e de devolução: ' + xmlNodeValue(sRetorno, '//xMotivo')
                            else
                              sLogErroEnvio := 'Tente novamente mais tarde. Se o erro persistir, considere emitir NF-e de devolução. ' + IfThen(Trim(sRetorno) = '', NFCE_NAO_HOUVE_RETORNO_SERVIDOR, xmlNodeValue(sRetorno, '//xMotivo'));

                            AdicionaLogCDS(False, // Sandro Silva 2019-08-09  True,
                                           Form1.IBDataSet150.FieldByName('REGISTRO').AsString,
                                           sLogErroEnvio,
                                           Form1.IBQuery65.FieldByName('DATA').AsString,
                                           Form1.IBQuery65.FieldByName('NUMERONF').AsString,
                                           Form1.IBQuery65.FieldByName('CAIXA').AsString);

                          end; // if (Pos('<cStat>135</cStat>', sRetorno) > 0) and (Pos('<tpEvento>110112</tpEvento>', sRetorno) > 0) then

                        end; // if _ecf65_CancelaNFCePorSubstituicao()

                      end; // if Form1.IBDataSet150.FieldByName('NFEIDSUBSTITUTO').AsString <> '' then
                      {Sandro Silva 2019-07-24 fim}

                    end; // if _ecf65_LoadXmlDestinatario(LimpaNumero(xmlNodeValue(fNFe1, '//infNFe/@Id'))) <> '' then
                  end; // if Trim(sRetorno) = '' then

                  // Seleciona novamente os dados da NFC-e porque o campo CAIXA estava ficando vazio depois do post acima
                  Form1.IBDataSet150.Close;
                  Form1.IBDataSet150.SelectSQL.Text :=
                    'select * ' +
                    'from NFCE ' +
                    'where MODELO = ''65'' ' +
                    ' and NUMERONF = ' + QuotedStr(Form1.IBQuery65.FieldByName('NUMERONF').AsString) +
                    ' and CAIXA = ' + QuotedStr(Form1.IBQuery65.FieldByName('CAIXA').AsString);
                  Form1.IBDataSet150.Open;

                  // Grava as formas de pagamento contidas no xml ou exclui quando for cancelada
                  if xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//tPag') <> '' then
                    _ecf65_GravaPagamentFromXML(Form1.IBDataSet150.FieldByName('NFEXML').AsString, Form1.IBDataSet150.FieldByName('NUMERONF').AsString, Form1.IBDataSet150.FieldByName('CAIXA').AsString);

                  if _ecf65_XmlNfceCancelado(Form1.IBDataSet150.FieldByName('NFEXML').AsString) then
                    AtualizarDadosRelacionadosComNFCeCancelada(Form1.IBDataSet150.FieldByName('NUMERONF').AsString, Form1.IBDataSet150.FieldByName('CAIXA').AsString);

                end;//

                Commitatudo2(True); // Não pode ser commit de todas as tabelas porque fecha Form1.IBQuery65
              end; // if (xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//ide/tpEmis') <> '1')
            end; // if (xmlNodeValue(Form1.IBQuery65.FieldByName('NFEXML').AsString, '//emit/CNPJ') = LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString))
          except
          end;

          Form1.IBQuery65.Next;

          //
          // Aqui adicionar um Sleep para evitar Consumo Indevido - 656?
          // Ou adicionar Sleep(2000) a cada requisição realizada ao servidor?
          //

        end; // while Form1.IBQuery65.Eof = False do

        //Passa por todas NFCe identificadas com problema, gera novamente o xml e transmite
        if Form1.ClientDataSet1.IsEmpty = False then
        begin
          Form1.ClientDataSet1.First;
          while Form1.ClientDataSet1.Eof = False do
          begin

            sArquivoXMLAutorizado := ''; // Sandro Silva 2018-08-06
            sRetorno              := ''; // Sandro Silva 2018-08-06
            fNFe1                 := ''; // Sandro Silva 2018-08-06

            // Abrir e atualizar dados dos produtos apenas das NFC-e do caixa atual.
            // Não tem como tratar vendas de outros caixas, as funções levam em consideração o caixa atual
            // Sandro Silva 2018-03-07 Teste transmitir de todos caixas  if Form1.ClientDataSet1.FieldByName('CAIXA').AsString = Form1.sCaixa then
            begin
              Form1.IBDataSet150.Close;
              Form1.IBDataSet150.SelectSQL.Text :=
                'select * ' +
                'from NFCE ' +
                'where NUMERONF = ' + QuotedStr(Form1.ClientDataSet1.FieldByName('NUMERONF').AsString) +
                ' and CAIXA = ' + QuotedStr(Form1.ClientDataSet1.FieldByName('CAIXA').AsString) +
                ' and MODELO = ''65'' ';
              Form1.IBDataSet150.Open;
              if (Form1.IBDataSet150.FieldByName('NUMERONF').AsString = Form1.ClientDataSet1.FieldByName('NUMERONF').AsString) and (Form1.IBDataSet150.FieldByName('NFEIDSUBSTITUTO').AsString = '') then // Sandro Silva 2019-07-25 if Form1.IBDataSet150.FieldByName('NUMERONF').AsString = Form1.ClientDataSet1.FieldByName('NUMERONF').AsString then
              begin
                _ecf65_GeraXmlCorrigindoDados(StrToInt64Def(Form1.IBDataSet150.FieldByName('NUMERONF').AsString, 0), Form1.IBDataSet150.FieldByName('CAIXA').AsString);
                Commitatudo2(True); // Transmissão contingência NFC-e. Apenas Estoque e alteraca

                Form1.IBDataSet150.Close;
                Form1.IBDataSet150.SelectSQL.Text :=
                  'select * ' +
                  'from NFCE ' +
                  'where NUMERONF = ' + QuotedStr(Form1.ClientDataSet1.FieldByName('NUMERONF').AsString) +
                  ' and CAIXA = ' + QuotedStr(Form1.ClientDataSet1.FieldByName('CAIXA').AsString) +
                  ' and MODELO = ''65'' ';
                Form1.IBDataSet150.Open;

                // Transmite o xml corrigido
                try
                  fNFe1 := Form1.IBDataSet150.FieldByName('NFEXML').AsString;
                  fNFe1 := Form1.spdNFCe1.AssinarNota(fNFe1); // Caso certificado foi renovado depois de ter gerado a nfce

                  _ecf65_NumeroSessaoIntegradorFiscal; // Sandro Silva 2018-04-23

                  sRetorno := Form1.spdNFCe1.EnviarNFSincrono(sLote, fNFe1, False); // Transmitindo contingência

                  sRetorno := _ecf65_CorrigePadraoRespostaSefaz(sRetorno);

                except
                  on E: Exception do
                  begin

                    Form1.ClientDataSet1.Edit;
                    Form1.ClientDataSet1.FieldByName('LOG').AsString      := E.Message;
                    Form1.ClientDataSet1.Post;

                  end; // on E: Exception do
                end; // try

                // Sandro Silva 2022-04-12 if (Pos('<cStat>100</cStat>', sRetorno) <> 0) or (Pos('<cStat>150</cStat>', sRetorno) <> 0) then // 100|Autorizado o uso da NF-e ou 150|Autorizado o uso da NF-e, autorização fora de prazo
                if (_ecf65_xmlAutorizado(sRetorno)) then // 100|Autorizado o uso da NF-e ou 150|Autorizado o uso da NF-e, autorização fora de prazo
                begin
                  //
                  sID   := xmlNodeValue(sRetorno, '//chNFe'); // Copia o ID da NFe p/ o Edit
                  fNFe1 := _ecf65_LoadXmlDestinatario(sID);
                  //

                  Form1.ibDataSet27.Close;
                  Form1.ibDataSet27.SelectSQL.Text :=
                    'select * ' +
                    'from ALTERACA ' +
                    'where PEDIDO = ' + QuotedStr(Form1.IBDataSet150.FieldByName('NUMERONF').AsString) +
                    ' and CAIXA = ' + QuotedStr(Form1.IBDataSet150.FieldByName('CAIXA').AsString);
                  Form1.ibDataSet27.Open;
                  while Form1.ibDataSet27.Eof = False do
                  begin

                    try
                      Form1.ibDataSet27.Edit;
                      Form1.ibDataSet27.FieldByName('COO').AsString := Form1.IBDataSet150.FieldByName('NUMERONF').AsString;
                      Form1.ibDataSet27.FieldByName('CCF').AsString := Form1.IBDataSet150.FieldByName('NUMERONF').AsString;
                      Form1.ibDataSet27.Post;
                    except
                    end;

                    Form1.ibDataSet27.Next;
                  end;
                  sArquivoXMLAutorizado := fNFe1;

                  Form1.ClientDataSet1.Edit;
                  Form1.ClientDataSet1.FieldByName('AUTORIZADA').AsString := 'S';
                  Form1.ClientDataSet1.Post;

                end
                else
                begin  // cStat diferente de autorizado
                  {Sandro Silva 2018-08-10 inicio}
                  if AnsiContainsText(sRetorno, 'Duplicidade') and (AnsiContainsText(sRetorno, '<cStat>204</cStat>')) then
                  begin// Copiar recibo, consultar recibo e id, ver o que retornar e analisar como identificar se mesmo xml enviado anteriormente está em xmldestinatario
                    try
                      try // Sandro Silva 2021-09-13
                        sRetornoConsultaRecibo := Form1.spdNFCe1.ConsultarNF(LimpaNumero(xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//infNFe/@Id')));
                      except

                      end;

                      sRetornoConsultaRecibo := _ecf65_CorrigePadraoRespostaSefaz(sRetornoConsultaRecibo);

                      if (_ecf65_xmlAutorizado(sRetornoConsultaRecibo)) then // 100|Autorizado o uso da NF-e ou 150|Autorizado o uso da NF-e, autorização fora de prazo // Sandro Silva 2018-08-10
                      begin
                        // Se foi autorizada faz a montagem do xml assinado com os dados da autorização
                        if xmlNodeXML(sRetornoConsultaRecibo, '//protNFe') <> '' then
                        begin

                          fNFe1 := _ecf65_LoadXmlDestinatario(xmlNodeValue(sRetornoConsultaRecibo, '//infProt/chNFe')); // Lê o arquivo contendo o xml inicialmente autorizado

                          //conferir o digestvalue do retorno com a nota autorizada
                          if xmlNodeValue(sRetornoConsultaRecibo, '//infProt/digVal') = xmlNodeValue(fNFe1, '//DigestValue') then
                          begin

                            sRetorno := ConcatencaNodeNFeComProtNFe(fNFe1, sRetornoConsultaRecibo);

                            slNFCeAutorizada := TStringList.Create;
                            slNFCeAutorizada.Text := sRetorno;
                            slNFCeAutorizada.SaveToFile(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + Copy(Form1.spdNFCeDataSets1.Campo('Id_A03').AsString,4,44) + '-nfce.xml');
                            FreeAndNil(slNFCeAutorizada);

                            sArquivoXMLAutorizado := sRetorno;
                          end;

                        end;
                      end;
                    except

                    end;
                  end
                  else
                  begin
                    {Sandro Silva 2018-08-10 fim}
                    if (xmlNodeValue(sRetorno, '//infProt/xMotivo') <> '')
                      or (xmlNodeValue(sRetorno, '//retEnviNFe/xMotivo') <> '') then
                    begin
                      try
                        Form1.IBDataSet150.Edit;
                        if xmlNodeValue(sRetorno, '//infProt/xMotivo') = '' then
                        begin
                          Form1.IBDataSet150.FieldByName('STATUS').AsString := Copy(xmlNodeValue(sRetorno, '//retEnviNFe/xMotivo'), 1, Form1.IBDataSet150.FieldByName('STATUS').Size);
                        end
                        else
                        begin
                          Form1.IBDataSet150.FieldByName('STATUS').AsString := Copy(xmlNodeValue(sRetorno, '//infProt/xMotivo'), 1, Form1.IBDataSet150.FieldByName('STATUS').Size);
                        end;
                        Form1.IBDataSet150.Post;

                      except

                      end;
                    end;
                  end;
                  if xmlNodeValue(sRetorno, '//xMotivo') <> '' then
                  begin
                    Form1.ClientDataSet1.Edit;
                    Form1.ClientDataSet1.FieldByName('LOG').AsString      := xmlNodeValue(sRetorno, '//xMotivo');
                    Form1.ClientDataSet1.Post;
                  end;
                end; // if (Pos('<cStat>100</cStat>', sRetorno) <> 0) or (Pos('<cStat>150</cStat>', sRetorno) <> 0) then // 100|Autorizado o uso da NF-e ou 150|Autorizado o uso da NF-e, autorização fora de prazo

                if sArquivoXMLAutorizado <> '' then
                begin
                  if _ecf65_LoadXmlDestinatario(LimpaNumero(xmlNodeValue(fNFe1, '//infNFe/@Id'))) <> '' then
                  begin
                    // Atualiza dados da venda no banco
                    try
                      if xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//ide/tpAmb') = TPAMB_HOMOLOGACAO then
                        sStatus := NFCE_STATUS_AUTORIZADO_USO_EM_HOMOLOGACAO// 'Autorizado o uso da NFC-e em ambiente de homologação'
                      else
                        sStatus := NFCE_STATUS_AUTORIZADO_USO_EM_PRODUCAO;// 'Autorizado o uso da NFC-e';

                      Form1.IBDataSet150.Edit;
                      Form1.IBDataSet150.FieldByName('NFEXML').AsString := _ecf65_LoadXmlDestinatario(LimpaNumero(xmlNodeValue(fNFe1, '//infNFe/@Id')));
                      if xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//infProt/chNFe') <> '' then
                        Form1.IBDataSet150.FieldByName('NFEID').AsString := xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//infProt/chNFe');
                      Form1.IBDataSet150.FieldByName('STATUS').AsString := sStatus;
                      if xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//vNF') <> '' then
                        Form1.IBDataSet150.FieldByName('TOTAL').AsFloat  := xmlNodeValueToFloat(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//vNF'); // Ficha 4302 Sandro Silva 2018-12-05
                      Form1.IBDataSet150.Post;

                      {Sandro Silva 2022-06-02 inicio}
                      // Grava as formas de pagamento contidas no xml ou exclui quando for cancelada
                      if xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//tPag') <> '' then
                        _ecf65_GravaPagamentFromXML(Form1.IBDataSet150.FieldByName('NFEXML').AsString, Form1.IBDataSet150.FieldByName('NUMERONF').AsString, Form1.IBDataSet150.FieldByName('CAIXA').AsString);

                      if _ecf65_XmlNfceCancelado(Form1.IBDataSet150.FieldByName('NFEXML').AsString) then
                        AtualizarDadosRelacionadosComNFCeCancelada(Form1.IBDataSet150.FieldByName('NUMERONF').AsString, Form1.IBDataSet150.FieldByName('CAIXA').AsString);
                      {Sandro Silva 2022-06-02 fim}

                      Form1.ClientDataSet1.Edit;
                      Form1.ClientDataSet1.FieldByName('AUTORIZADA').AsString := 'S';
                      Form1.ClientDataSet1.Post;

                    except

                    end;
                  end;
                end;
                Commitatudo2(True);

                ///////////////////////////////////////////////////////////////////////////
              end;
            end;
            Form1.ClientDataSet1.Next;
          end;

        end;

      finally
        _ecf65_bTransmitindoContingenciaNFCe := False; // Sandro Silva 2019-07-25

        sLogErro := '';
        if Form1.ClientDataSet1.IsEmpty = False then
        begin
          if sNumeroNF <> '' then
          begin
            if Form1.ClientDataSet1.FieldByName('AUTORIZADA').AsString <> 'S' then
            begin
              Application.MessageBox(PChar('Data: ' + Form1.ClientDataSet1.FieldByName('DATA').AsString + #13 +
                                               'Numero: ' + Form1.ClientDataSet1.FieldByName('NUMERONF').AsString + #13 +
                                               'Caixa: ' + Form1.ClientDataSet1.FieldByName('CAIXA').AsString + #13 +
                                               'Alerta: ' + Form1.ClientDataSet1.FieldByName('LOG').AsString), 'Atenção', MB_OK + MB_ICONWARNING);
            end;
          end
          else
          begin
            Form1.ClientDataSet1.First;

            while Form1.ClientDataSet1.Eof = False do
            begin
              if Form1.ClientDataSet1.FieldByName('AUTORIZADA').AsString <> 'S' then
              begin
                sLogErro := sLogErro + '<tr>';
                sLogErro := sLogErro + '<td>' + Form1.ClientDataSet1.FieldByName('DATA').AsString + '</td>' +
                                       '<td>' + Form1.ClientDataSet1.FieldByName('NUMERONF').AsString + '</td>' +
                                       '<td>' + Form1.ClientDataSet1.FieldByName('CAIXA').AsString + '</td>' +
                                       '<td>' + Form1.ClientDataSet1.FieldByName('LOG').AsString + '</td>';
                sLogErro := sLogErro + '</tr>';
              end;

              Form1.ClientDataSet1.Next;
            end;
            if sLogErro <> '' then
            begin
              sLogErro := '<html><head><title>' + Form1.ibDataSet13.FieldByName('NOME').AsString + '</title></head>' +
                            '<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="0"><center> ' +
                              '<img src="logotip.jpg"> ' +
                              '<br><font face="Microsoft Sans Serif" size=2><b>' + Form1.ibDataSet13.FieldByName('NOME').AsString + '</b></font> '+
                              '<br><font face="Microsoft Sans Serif" size=2><b><p>Log da Transmissão de NFC-e<p></b></font> ' +
                              '<table width="100%" border="1" style="border-collapse:collapse">' +
                                '<tr style="font">' +
                                  '<th>Data</th>' +
                                  '<th>Número</th>' +
                                  '<th>Caixa</th>' +
                                  '<th>Log</th>' +
                                '</tr>' +
                                sLogErro +
                              '</table>' +
                              '<br><font face="Microsoft Sans Serif" size=2><b><p>Small - NFC-e ' + ' - ' + FormatDateTime('dd/mm/yyyy HH:nn:ss', Now) + ' ' + Form22.sBuild + '<p></b></font> ' + // Sandro Silva 2018-04-24
                            '</body>' +
                          '</html>';

              re := TRichEdit.Create(Application);
              re.Visible    := False;
              re.Parent     := Form1;
              re.PlainText  := True;
              re.WordWrap   := False;
              re.ScrollBars := ssBoth;
              re.Clear;
              re.Lines.Add(sLogErro);
              re.Lines.SaveToFile(sArquivoLogContingencia);
              Sleep(250);
              FreeAndNil(re);
            end;
          end;
        end;

        if Form1.ImportarvendasdoSmallMobile1.Checked then // Sandro Silva 2016-03-23
          Form1.Timer2.Enabled := True;

        Screen.Cursor := crDefault;
      end; // try/finally




    end
    else
    begin
      if (Form1.NFCeemContingncia1.Checked) and ((Pos('sem serviço', AnsiLowerCase(Form1.sStatusECF)) > 0) or (Form1.bStatusECF = False)) then // Sandro Silva 2020-06-25 if (Form1.NFCeemContingncia1.Checked) and (Pos('sem serviço', AnsiLowerCase(Form1.sStatusECF)) > 0) then
        Application.MessageBox('Não é possível transmitir NFC-e estando em modo contingência', 'Atenção', MB_ICONWARNING + MB_OK)
      else
        Application.MessageBox('Não é possível gerar NFC-e em modo Off-line', 'Atenção', MB_ICONWARNING + MB_OK);
    end; // if (Form1.bStatusRede) and (Form1.NFCeemContingncia1.Checked = False) and (Pos('sem serviço', AnsiLowerCase(Form1.sStatusECF)) = 0) and (Form1.bStatusECF) then

    {Sandro Silva 2022-11-04 inicio}
    try
      if bTransmitiuContingencia then
        Audita('CANCELA','FRENTE', '', 'Transmissão contingência NFC-e ' + Form1.sCaixa, 0,0); // Ato, Modulo, Usuário, Histórico, Valor
    except

    end;
    {Sandro Silva 2022-11-04 fim}

  end;

  Form1.ClientDataSet1.Close;
  CommitaTudo(True); // _ecf65_EnviarNFCeContingencia()

  Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible := False; // Sandro Silva 2017-08-22

  if FileExists(PChar(sArquivoLogContingencia)) then
  begin
    Application.ProcessMessages;
    Application.BringToFront;

    Application.MessageBox(PChar('Será aberto o arquivo de log gerado pela transmissão' + #13 +
                                 'Faça a transmissão a partir do caixa informado no log'), 'Atenção', MB_ICONWARNING + MB_OK);
    ShellExecute(0, 'open', PChar('"' + sArquivoLogContingencia + '"'), '', '', SW_RESTORE);

  end;
  Result := True;

  ChDir(Form1.sAtual);  // Sandro Silva 2017-05-20
end; // Fim EnviarNFCeContingencia

procedure _ecf65_NumeroSessaoIntegradorFiscal;
begin
  {Sandro Silva 2023-06-14 inicio
  if Form1.UsaIntegradorFiscal() then
  begin
    Form1.spdNFCe1.Integrador.NumeroSessao := StrToInt(FormatDateTime('HHnnsszzz', Time));
  end;
  }
end;

procedure _ecf65_RateioAcrescimo(dTotalVenda: Double; dAcrescimoTotal: Double;
  iCupom: Integer; sCaixa: String);
var
  IBQITENS: TIBQuery;
  dAcumulado: Double;
  dDiferenca: Double;
  iItem: Integer;
begin
  SetLength(aAcrescimoItem, 0);
  IBQITENS := CriaIBQuery(FORM1.ibDataSet27.Transaction);
  try
    if dAcrescimoTotal > 0 then
    begin
      IBQITENS.Close;
      IBQITENS.SQL.Text :=
        'select A.TOTAL, coalesce((select A1.TOTAL from ALTERACA A1 where A1.PEDIDO = A.PEDIDO and A1.ITEM = A.ITEM and A1.CAIXA = A.CAIXA and A1.DATA = A.DATA and A1.DESCRICAO = ''Desconto'' ), 0) as DESCONTOITEM ' +
        'from ALTERACA A ' +
        'where A.PEDIDO = ' + QuotedStr(FormataNumeroDoCupom(icupom)) + // Sandro Silva 2021-11-29 'where A.PEDIDO = ' + QuotedStr(strZero(icupom,6,0)) +
        ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
        ' and A.CAIXA = ' + QuotedStr(sCaixa) +
        ' and (A.DESCRICAO <> ''<CANCELADO>'' ' +
        ' and A.DESCRICAO <> ''Desconto'' ' +
        ' and A.DESCRICAO <> ''Acréscimo'') ' +
        ' and coalesce(A.ITEM, '''') <> '''' ' + // Que tenha número do item informado no campo ALTERACA.ITEM
        ' order by ITEM'; // Mesma ordem que estão sendo gerados os itens no xml Sandro Silva 2021-08-13
      IBQITENS.Open;

      dAcumulado := 0.00;
      while IBQITENS.Eof = False do
      begin
        SetLength(aAcrescimoItem, Length(aAcrescimoItem) + 1);
        aAcrescimoItem[Length(aAcrescimoItem) - 1] := StrToFloat(StrZero(((dAcrescimoTotal / dTotalVenda) * (IBQITENS.FieldByName('TOTAL').AsFloat - Abs(IBQITENS.FieldByName('DESCONTOITEM').AsFloat))), 0, 2)); // REGRA DE TRÊS rateando o valor do Acréscimo

        dAcumulado := dAcumulado + aAcrescimoItem[Length(aAcrescimoItem) - 1];
        IBQITENS.Next;
      end;

      // Formata 2 casas decimais para evitar problema de dízima
      dDiferenca := StrToCurr(FormatFloat('0.00', dAcumulado - dAcrescimoTotal));

      if dDiferenca <> 0 then
      begin
        for iItem := 0 to Length(aAcrescimoItem) - 1 do
        begin
          if StrToCurr(FormatFloat('0.00', aAcrescimoItem[iItem] - dDiferenca)) >= 0 then
          begin
            aAcrescimoItem[iItem] := StrToCurr(FormatFloat('0.00', aAcrescimoItem[iItem] - dDiferenca));
            Break;
          end
          else
          begin
            dDiferenca := StrToCurr(FormatFloat('0.00', dDiferenca - aAcrescimoItem[iItem]));
            aAcrescimoItem[iItem] := 0.00;
          end;
          if dDiferenca = 0 then
            Break;
        end;

      end; // if dDiferenca <> 0 then
      {Sandro Silva 2019-09-30 fim}
    end; // if dAcrescimoTotal > 0 then
  finally
    FreeAndNil(IBQITENS);
  end;
end;

procedure _ecf65_RateioDesconto(dTotalVenda: Double; dDescontoTotal: Double;
  iCupom: Integer; sCaixa: String);
var
  IBQITENS: TIBQuery;
  dAcumulado: Double;
  dDiferenca: Double;
  iItem: Integer;
begin
  SetLength(aDescontoItem, 0);
  IBQITENS := CriaIBQuery(FORM1.ibDataSet27.Transaction);
  try
    if dDescontoTotal > 0 then
    begin
      IBQITENS.Close;
      IBQITENS.SQL.Text :=
        'select A.TOTAL, coalesce((select A1.TOTAL from ALTERACA A1 where A1.PEDIDO = A.PEDIDO and A1.ITEM = A.ITEM and A1.CAIXA = A.CAIXA and A1.DATA = A.DATA and A1.DESCRICAO = ''Desconto'' ), 0) as DESCONTOITEM ' +
        'from ALTERACA A ' +
        'where A.PEDIDO = ' + QuotedStr(FormataNumeroDoCupom(iCupom)) + // Sandro Silva 2021-11-29 'where A.PEDIDO = ' + QuotedStr(strZero(iCupom,6,0)) +
        ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
        ' and A.CAIXA = ' + QuotedStr(sCaixa) +
        ' and (A.DESCRICAO <> ''<CANCELADO>'' ' +
        ' and A.DESCRICAO <> ''Desconto'' ' +
        ' and A.DESCRICAO <> ''Acréscimo'') ' +
        ' and coalesce(A.ITEM, '''') <> '''' ' + // Que tenha número do item informado no campo ALTERACA.ITEM
        ' order by ITEM'; // Mesma ordem que estão sendo gerados os itens no xml Sandro Silva 2021-08-13
      IBQITENS.Open;

      dAcumulado := 0.00;// Sandro Silva 2016-04-01
      while IBQITENS.Eof = False do
      begin
        SetLength(aDescontoItem, Length(aDescontoItem) + 1);
        aDescontoItem[Length(aDescontoItem) - 1] := StrToFloat(StrZero(((dDescontoTotal / (dTotalVenda)) * (IBQITENS.FieldByName('TOTAL').AsFloat - Abs(IBQITENS.FieldByName('DESCONTOITEM').AsFloat))), 0, 2)); // REGRA DE TRÊS rateando o valor do Desconto
        dAcumulado := dAcumulado + aDescontoItem[Length(aDescontoItem) - 1];
        IBQITENS.Next;
      end;

      // Formata 2 casas decimais para evitar problema de dízima
      dDiferenca := StrToCurr(FormatFloat('0.00', dAcumulado - dDescontoTotal));

      if dDiferenca <> 0 then
      begin
        for iItem := 0 to Length(aDescontoItem) - 1 do
        begin
          if StrToCurr(FormatFloat('0.00', aDescontoItem[iItem] - dDiferenca)) >= 0 then
          begin
            aDescontoItem[iItem] := StrToCurr(FormatFloat('0.00', aDescontoItem[iItem] - dDiferenca));
            Break;
          end
          else
          begin
            dDiferenca := StrToCurr(FormatFloat('0.00', dDiferenca - aDescontoItem[iItem]));
            aDescontoItem[iItem] := 0.00;
          end;
          if dDiferenca = 0 then
            Break;
        end;
      end; // if dDiferenca <> 0 then
      {Sandro Silva 2019-09-30 fim}
    end; // if dAcrescimoTotal > 0 then
  finally
    FreeAndNil(IBQITENS);
  end;
end;

function ConverteAcentosXML(pP1: String): String;
// Sandro Silva 2016-07-14 Para substituir onde usa ConverteAcentos2. Permite caractere cifrão $ e |
var
  I:Integer;
begin
  pP1 := ConverteAcentos(pP1);
  Result := '';
  for I := 1 to length(pP1) do
  begin
    if Pos(AnsiUpperCase(Copy(pP1, I, 1)), '1234567890ABCDEFGHIJKLMNOPQRSTUVXYZW,/.-()%$|') > 0 then
      Result := Result + Copy(pP1, I, 1) else Result := Result + ' ';
  end;
end;

procedure _ecf65_AdicionaPagamento(tPag_YA02: String; vPag_YA03: String);
begin
  Form1.spdNFCeDataSets1.IncluirPart('YA');
  Form1.spdNFCeDataSets1.Campo('tPag_YA02').Value := StrZero(StrToIntDef(Copy(tPag_YA02, 1, 2), 99), 2, 0); //Forma de pagamento: 01- Dinheiro; 02 -Cheque; 03- Cartão de Crédito; 04- Cartão de Débito; 05- Crédito Loja; 10- Vale Alimentação; 11- Vale Refeição; 12- Vale Presente; 13- Vale Combustível; 99 – Outros.
  Form1.spdNFCeDataSets1.Campo('vPag_YA03').Value := vPag_YA03;

  {Sandro Silva 2021-08-16 inicio}
  // Quando o código do meio de pagamento (tag: tPag) for preenchido com o código 99-outros, obrigatório o preenchimento da descrição do meio de pagamento (tag: xPag)
  // Sandro Silva 2021-09-03 if LerParametroIni(FRENTE_INI, SECAO_65, 'xPag', 'Sim') = 'Sim' then // Sandro Silva 2021-09-02 if LerParametroIni(FRENTE_INI, SECAO_65, 'xPag', 'Não') = 'Sim' then
  //begin
    if Form1.spdNFCeDataSets1.Campo('tPag_YA02').Value = NFCE_FORMA_99_OUTROS then
    begin
      if AnsiContainsText(AnsiUpperCase(ConverteAcentos2(_ecf65_DescricaoFormaExtra99)), 'CARTAO') or (AnsiUpperCase(ConverteAcentos2(_ecf65_DescricaoFormaExtra99)) = 'POS') then
        Form1.spdNFCeDataSets1.Campo('xPag_YA02a').Value := 'Outras Formas'
      else
        Form1.spdNFCeDataSets1.Campo('xPag_YA02a').Value := ConverteAcentos2(_ecf65_DescricaoFormaExtra99);
    end;
  //end;
  {Sandro Silva 2021-08-16 fim}

  //Mauricio Parizotto 2024-07-03
  //Pagamento PIX
  if tPag_YA02 = NFCE_FORMA_17_PAGAMENTO_INSTANTANEO_PIX_DINAMICO then
  begin
    if Form1.sTipoPix = _PixDinamico then
    begin
      Form1.spdNFCeDataSets1.Campo('tpIntegra_YA04a').Value := '1';
      _ecf65_DadosAutorizacaoPix(Form1.spdNFCeDataSets1, Form1.sCodigoAutorizacaoPIX, Form1.sCNPJInstituicaoPIX);
    end else
    begin
      Form1.spdNFCeDataSets1.Campo('tpIntegra_YA04a').Value := '2';
    end;
  end;

  Form1.spdNFCeDataSets1.SalvarPart('YA');
end;

procedure _ecf65_AcumulaFormaExtraNFCe(sOrdemExtra: String; dValor: Double;
  var dvPag_YA03_10: Double; var dvPag_YA03_11: Double;
  var dvPag_YA03_12: Double; var dvPag_YA03_13: Double;
  var dvPag_YA03_16: Double; var dvPag_YA03_17: Double;
  var dvPag_YA03_18: Double; var dvPag_YA03_19: Double;
  var dvPag_YA03_20: Double;
  var dvPag_YA03_99: Double);
begin
  if sOrdemExtra = NFCE_FORMA_10_VALE_ALIMENTACAO then
    dvPag_YA03_10 := dvPag_YA03_10 + dValor;

  if sOrdemExtra = NFCE_FORMA_11_VALE_REFEICAO then
    dvPag_YA03_11 := dvPag_YA03_11 + dValor;

  if sOrdemExtra = NFCE_FORMA_12_VALE_PRESENTE then
    dvPag_YA03_12 := dvPag_YA03_12 + dValor;

  if sOrdemExtra = NFCE_FORMA_13_VALE_COMBUSTIVEL then
    dvPag_YA03_13 := dvPag_YA03_13 + dValor;

  if sOrdemExtra = NFCE_FORMA_16_DEPOSITO_BANCARIO then
    dvPag_YA03_16 := dvPag_YA03_16 + dValor;

  if sOrdemExtra = NFCE_FORMA_17_PAGAMENTO_INSTANTANEO_PIX_DINAMICO then
    dvPag_YA03_17 := dvPag_YA03_17 + dValor;

  if sOrdemExtra = NFCE_FORMA_18_TRANSFERENCIA_BANCARIA_CARTEIRA_DIGITAL then
    dvPag_YA03_18 := dvPag_YA03_18 + dValor;

  if sOrdemExtra = NFCE_FORMA_19_PROGRAMA_FIDELIDADE_CASHBACK_CREDITO_VIRTUAL then
    dvPag_YA03_19 := dvPag_YA03_19 + dValor;

  if sOrdemExtra = NFCE_FORMA_20_PAGAMENTO_INSTANTANEO_PIX_ESTATICO then
    dvPag_YA03_20 := dvPag_YA03_20 + dValor;

  if sOrdemExtra = NFCE_FORMA_99_OUTROS then
    dvPag_YA03_99 := dvPag_YA03_99 + dValor;
end;

procedure _ecf65_DadosCredenciadoraCartoes(spdNFCeDataSets: TspdNFCeDataSets;
  sCNPJ_YA05: String; NomeRede: String; NumeroAutorizacao: String);
var
  stBand_YA06: String; // Sandro Silva 2016-03-21
begin
  NomeRede := AnsiUpperCase(NomeRede);
  stBand_YA06 := '99'; // Começa como outros
  if Pos('VISA', NomeRede) > 0 then
    stBand_YA06 := '01';
  if Pos('MASTERCARD', NomeRede) > 0 then
    stBand_YA06 := '02';
  if Pos('AMERICAN EXPRESS', NomeRede) > 0 then
    stBand_YA06 := '03';
  if Pos('SOROCRED', NomeRede) > 0 then
    stBand_YA06 := '04';
  if Pos('DINERS', NomeRede) > 0 then
    stBand_YA06 := '05';
  if Pos('ELO', NomeRede) > 0 then
    stBand_YA06 := '06';
  if Pos('HIPERCARD', NomeRede) > 0 then
    stBand_YA06 := '07';
  if Pos('AURA', NomeRede) > 0 then
    stBand_YA06 := '08';
  if Pos('CABAL', NomeRede) > 0 then
    stBand_YA06 := '09';
  if Pos('ALELO', NomeRede) > 0 then
    stBand_YA06 := '10';
  if Pos('BANES CARD', NomeRede) > 0 then
    stBand_YA06 := '11';
  if Pos('CALCARD', NomeRede) > 0 then
    stBand_YA06 := '12';
  if Pos('CREDZ', NomeRede) > 0 then
    stBand_YA06 := '13';
  if Pos('DISCOVER', NomeRede) > 0 then
    stBand_YA06 := '14';
  if Pos('GOODCARD', NomeRede) > 0 then
    stBand_YA06 := '15';
  if Pos('GREENCARD', NomeRede) > 0 then
    stBand_YA06 := '16';
  if (Pos('HIPER', NomeRede) > 0) and (Pos('HIPERCARD', NomeRede) = 0) then
    stBand_YA06 := '17';
  if Pos('JCB', NomeRede) > 0 then
    stBand_YA06 := '18';
  if Pos('MAIS', NomeRede) > 0 then
    stBand_YA06 := '19';
  if Pos('MAXVAN', NomeRede) > 0 then
    stBand_YA06 := '20';
  if Pos('POLICARD', NomeRede) > 0 then
    stBand_YA06 := '21';
  if Pos('REDECOMPRAS', NomeRede) > 0 then
    stBand_YA06 := '22';
  if Pos('SODEXO', NomeRede) > 0 then
    stBand_YA06 := '23';
  if Pos('VALECARD', NomeRede) > 0 then
    stBand_YA06 := '24';
  if Pos('VEROCHEQUE', NomeRede) > 0 then
    stBand_YA06 := '25';
  if Pos('VR', NomeRede) > 0 then
    stBand_YA06 := '26';
  if Pos('TICKET', NomeRede) > 0 then
    stBand_YA06 := '27';

  spdNFCeDataSets.Campo('CNPJ_YA05').Value  := sCNPJ_YA05; //CNPJ da Credenciadora de cartão de crédito e/ou débito
  spdNFCeDataSets.Campo('tBand_YA06').Value := stBand_YA06; // Bandeira da operadora de cartão de crédito e/ou débito 01=Visa; 02=Mastercard; 03=American Express; 04=Sorocred; 99=Outros;
  spdNFCeDataSets.Campo('cAut_YA07').Value  := NumeroAutorizacao; // Número de autorização da operação cartão de crédito e/ou débito

end;

procedure _ecf65_DadosAutorizacaoPix(spdNFCeDataSets: TspdNFCeDataSets; sCodigoAutorizacao, sCNPJInstituicaoPIX : string);
begin
  spdNFCeDataSets.Campo('CNPJ_YA05').Value  := LimpaNumero(sCNPJInstituicaoPIX); //CNPJ da Instituição Financeira
  spdNFCeDataSets.Campo('cAut_YA07').Value  := sCodigoAutorizacao; // Número de autorização da operação
end;


function _ecf65_DescricaoFormaExtra99: String;
// Identifica a primeira forma extra que estiver configurada com código 99-Outros
var
  iForma: Integer;
  sForma: String;
begin
  sForma := 'Outras formas';
  try
    for iForma := 1 to 8 do
    begin
      if LerParametroIni('FRENTE.INI', 'NFCE', 'Ordem forma extra ' + IntToStr(iForma), '') = '99' then
      begin
        sForma := LerParametroIni('FRENTE.INI', 'NFCE', 'Forma extra ' + IntToStr(iForma), 'Outras formas');
        Break;
      end;
    end;
  except
  end;
  Result := Trim(sForma);
end;

function _ecf65_DadosCarneNoXML: String;
begin
  Result := '';

  if Form1.ClienteSmallMobile.ImportandoMobile then // Sandro Silva 2022-08-08 if ImportandoMobile then
  begin

    Result := 'Documento    Vencimento     Valor R$' + '|';

    Form1.ibDataSet7.First;
    while Form1.ibDataSet7.Eof = False do
    begin
      //
      Result := Result + Form1.ibDataSet7.FieldByName('DOCUMENTO').AsString + '  ' +
                         FormatDateTime('dd/mm/yyyy', Form1.ibDataSet7.FieldByName('VENCIMENTO').AsDateTime) + '  ' +
                         Format('%10.2n',[Form1.ibDataSet7.FieldByName('VALOR_DUPL').AsFloat]) + '|';
      //
      Form1.ibDataSet7.Next;
    end;

    Result := '|' + Replicate('_',40) + '|' +
               'Small Mobile - Dados do Parcelamento' + '|' +
               Form1.ibDataSet2.FieldByName('NOME').AsString + ' ' + Form1.ibDataSet2.FieldByName('CGC').AsString + '|' +
               Form1.ibDataSet2.FieldByName('ENDERE').AsString + ', ' +
               AllTrim(Form1.ibDataSet2.FieldByName('CEP').AsString)
               +' - ' + AllTrim(Form1.ibDataSet2.FieldByName('CIDADE').AsString)
               + ', ' + AllTrim(Form1.ibDataSet2.FieldByName('ESTADO').AsString) + '|' +
               ' |' + Result +
               Replicate('_',40);
  end;

end;

function _ecf65_CNPJAdministradoraCartao(xml: String): String;
var
  XMLNFE: IXMLDOMDocument;
  xNodePag: IXMLDOMNodeList;
  iNode: Integer;
begin
  XMLNFE := CoDOMDocument.Create;

  try
    XMLNFE.loadXML(xml);
    xNodePag := XMLNFE.selectNodes('//detPag[tPag=''03'' or tPag=''04'']/card/CNPJ'); // Pode ter mais que 1 tag dhRecbto no xml
    for iNode := 0 to xNodePag.length -1 do
    begin
      if xmlNodeValue(xNodePag.item[iNode].xml, '//CNPJ') <> '' then
      begin
        Result := xmlNodeValue(xNodePag.item[iNode].xml, '//CNPJ');
        Break;
      end
    end;
  except
  end;
  XMLNFE := nil;
end;

function _ecf65_GravaPagamentFromXML(sXML: String; sPedido: String;
    sCaixa: String): Boolean;
// Usado para gravar formas de pagamento nos casos do usuário fechar frente durante finalização da venda
// e a venda ficar sem os registros de pagamento
// As informações são extraídas do xml da NFC-e
// Não deve ser usado commit dentro desta função
// Usar Form1.IBDataSet28 porque nele estão os controles para encriptahash
var
  //XMLNFE: IXMLDOMDocument;
  dtData: TDate;
  sCOO: String;
  sCCF: String;
  sClifor: String;
  sVendedor: String;
  // Sandro Silva 2019-07-24  sForma: String;
  sDataEmitidaXMLRecuperado: String;
  sHoraEmitida: String;
  dTotal: Double;
  dTroco: Double;
  IBQALTERACA: TIBQuery;

  function ValortPag(sXML: String; tPag: String): Double;
  begin // Definição das tag é diferente nas versões de layout da NFC-e
    if xmlNodeValue(sXML, '//infNFe/@versao') = '3.10' then
      Result := xmlNodeValueToFloat(sXML, '//pag[tPag = ' + QuotedStr(tPag) + ']/vPag')
    else
      Result := xmlNodeValueToFloat(sXML, '//detPag[tPag = ' + QuotedStr(tPag) + ']/vPag');
  end;

  function PostPagament(Data: TDate; sCOO: String; sCCF: String;
    sPedido: String; sCaixa: String; sClifor: String; sVendedor: String;
    sForma: String; dValor: Double; sHora: String): Boolean;
  begin
    Result := False;
    try

      Form1.ibDataSet28.Append;
      Form1.ibDataSet28.FieldByName('DATA').AsDateTime   := Data;
      Form1.ibDataSet28.FieldByName('COO').AsString      := sCOO;
      Form1.ibDataSet28.FieldByName('CCF').AsString      := sCCF;
      Form1.ibDataSet28.FieldByName('PEDIDO').AsString   := sPedido;
      Form1.ibDataSet28.FieldByName('CAIXA').AsString    := sCaixa;
      Form1.ibDataSet28.FieldByName('CLIFOR').AsString   := sClifor;
      Form1.ibDataSet28.FieldByName('VENDEDOR').AsString := sVendedor;
      Form1.ibDataSet28.FieldByName('FORMA').AsString    := Copy(sForma, 1, Form1.ibDataSet28.FieldByName('FORMA').Size);
      Form1.ibDataSet28.FieldByName('VALOR').AsFloat     := dValor;
      Form1.ibDataSet28.FieldByName('HORA').AsString     := sHora; // Sandro Silva 2018-11-30
      if Copy(Form1.ibDataSet28.FieldByName('FORMA').AsString, 1, 2) = '13' then // Troco
      begin
        if Form1.ibDataSet28.FieldByName('VALOR').AsFloat = 0.00 then
          Form1.ibDataSet28.FieldByName('VALOR').Clear;
      end;

      {Sandro Silva 2020-10-20 inicio} 
      if (Copy(Form1.ibDataSet28.FieldByName('FORMA').AsString, 1, 2) = '01') // Cheque
        or (Copy(Form1.ibDataSet28.FieldByName('FORMA').AsString, 1, 2) = '03') // Cartão Crédito/Débito
        or (Copy(Form1.ibDataSet28.FieldByName('FORMA').AsString, 1, 2) = '04') // Prazo
      then
      begin
        Form1.ibDataSet28.FieldByName('GNF').AsString   := sPedido;
      end;
      {Sandro Silva 2020-10-20 fim}

      Form1.ibDataSet28.Post;
      Result := True;
    except
    end;
  end;

  function TPagDescToFormaExtra(tPag: String): String;
  var
    iExtra: Integer;
  begin // Identifica no frente qual a forma de pagamento equivalente da NFC-e
    Result := '';
    for iExtra := 1 to 8 do
    begin
      try      
        if LerParametroIni('FRENTE.INI', SECAO_65, 'Ordem forma extra ' + IntToStr(iExtra), '') = tPag then
        begin
          if LerParametroIni('FRENTE.INI', SECAO_65, 'Forma extra ' + IntToStr(iExtra), '') <> '' then
            Result := FormatFloat('00', iExtra + 4) + ' ' + LerParametroIni('FRENTE.INI', SECAO_65, 'Forma extra ' + IntToStr(iExtra), ''); // iExtra + 4 porque a última forma fixa do frente é 04 A prazo
        end;
      except

      end;
    end;
  end;
begin
  Result := False;
  IBQALTERACA := CriaIBQuery(Form1.ibDataSet27.Transaction);  // Manter mesma transação
  IBQALTERACA.Close;
  IBQALTERACA.SQL.Text :=
    'select * ' +
    'from ALTERACA ' +
    'where PEDIDO = ' + QuotedStr(sPedido) +
    ' and CAIXA = ' + QuotedStr(sCaixa);
  IBQALTERACA.Open;

  dTotal := 0.00;
  while IBQALTERACA.Eof = False do
  begin
    if IBQALTERACA.FieldByName('CLIFOR').AsString <> '' then
      sClifor := IBQALTERACA.FieldByName('CLIFOR').AsString;
    if IBQALTERACA.FieldByName('VENDEDOR').AsString <> '' then
      sVendedor := IBQALTERACA.FieldByName('VENDEDOR').AsString; // Sandro Silva 2020-10-20 sVendedor := IBQALTERACA.FieldByName('CLIFOR').AsString;

    if (IBQALTERACA.FieldByName('TIPO').AsString = 'BALCAO') or (IBQALTERACA.FieldByName('TIPO').AsString = 'LOKED') then
      dTotal := dTotal + IBQALTERACA.FieldByName('TOTAL').AsFloat;

    {Sandro Silva 2022-08-26 inicio
    Manter a hora que inseriu o registro na tabela}
    if IBQALTERACA.FieldByName('HORA').AsString <> '' then
      sHoraEmitida := IBQALTERACA.FieldByName('HORA').AsString;

    IBQALTERACA.Next;
  end;


  sDataEmitidaXMLRecuperado := xmlNodeValue(sXML, '//ide/dhEmi');
  // Salva a hora do último registro no alteraca Sandro Silva 2022-08-26 sHoraEmitida              := Copy(sDataEmitidaXMLRecuperado, 12, 8);// Sandro Silva 2018-11-30
  sDataEmitidaXMLRecuperado := Copy(sDataEmitidaXMLRecuperado, 9, 2) + '/' + Copy(sDataEmitidaXMLRecuperado, 6, 2) + '/' + Copy(sDataEmitidaXMLRecuperado, 1, 4) + ' ' + Copy(sDataEmitidaXMLRecuperado, 12, 8);
  dtData                    := StrToDateTime(sDataEmitidaXMLRecuperado);
  sCOO                      := sPedido;
  sCCF                      := sPedido;

  //Lendo as formas de pagamento do xml em contingência e repassando para o novo

  try
    // Exclui os dados de pagamento que existe
    Form1.ibDataSet28.Close;
    Form1.ibDataSet28.Selectsql.Text := 'select * from PAGAMENT where (coalesce(CLIFOR, '''') <> ''Sangria'' and coalesce(CLIFOR, '''') <> ''Suprimento'') and CAIXA='+QuotedStr(sCaixa)+' and PEDIDO='+QuotedStr(sPedido);
    Form1.ibDataSet28.Open;
    Form1.ibDataSet28.First;
    while Form1.ibDataSet28.Eof = False do
    begin
      if (Form1.IBDataSet28.FieldByName('VENDEDOR').AsString <> '') and (sVendedor = '') then
        sVendedor := Form1.IBDataSet28.FieldByName('VENDEDOR').AsString;

      if (Form1.IBDataSet28.FieldByName('CLIFOR').AsString <> '') and (sClifor = '') then
        sClifor := Form1.IBDataSet28.FieldByName('CLIFOR').AsString; // Sandro Silva 2020-10-20 sClifor := Form1.IBDataSet28.FieldByName('VENDEDOR').AsString;

      Form1.ibDataSet28.Delete;
    end;

    // Valor Total
    PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, '00 Total', dTotal * (-1), sHoraEmitida); // Troco tem que ser gravado com valor negativo

    // Identifica se tem troco no xml
    dTroco := 0.00;
    if Form1.sVersaoLayoutNFCe = '3.1' then // Valor do Troco
    begin
      // Extrai o troco das observações da NFC-e. Busca o valor entre o texto 'TROCO R$' e o primeiro '|' depois da expressão 'TROCO R$'. Ex.: '|| Total R$1,00 Recebido R$100,00 TROCO R$99,00|| Trib aprox R$ 0,19 Federal 0,17 Estadual Fonte IBPT H4T2P7'
      if Pos('TROCO R$', xmlNodeValue(sXML, '//infCpl_Z03')) > 0 then
        dTroco := StrToFloatDef(Trim(Copy(xmlNodeValue(sXML, '//infCpl_Z03'), Pos('TROCO R$', xmlNodeValue(sXML, '//infCpl_Z03')) + 8,
                                          PosEx('|',
                                                xmlNodeValue(sXML, '//infCpl_Z03'),
                                                Pos('TROCO R$', xmlNodeValue(sXML, '//infCpl_Z03'))
                                               ) - (Pos('TROCO R$', xmlNodeValue(sXML, '//infCpl_Z03')) + 8)
                                         )
                                    ),
                                0);
    end
    else
      dTroco := xmlNodeValueToFloat(sXML, '//vTroco');

    if ValortPag(sXML, '02') > 0.00 then // Cheque
    begin
      PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, '01 Em cheque', ValortPag(sXML, '02'), sHoraEmitida);
    end;

    if ValortPag(sXML, '01') > 0.00 then // Dinheiro
    begin
      PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, '02 Dinheiro NFC-e', ValortPag(sXML, '01'), sHoraEmitida);
    end;

    if ValortPag(sXML, '03') > 0.00 then // Cartão Crédito
    begin
      PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, '03 Cartao CREDITO', ValortPag(sXML, '03'), sHoraEmitida);
    end;

    if ValortPag(sXML, '04') > 0.00 then // Cartão Débito
    begin
      PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, '03 Cartao DEBITO', ValortPag(sXML, '04'), sHoraEmitida);
    end;

    if ValortPag(sXML, '05') > 0.00 then // Prazo
    begin
      PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, '04 A prazo NFC-e', ValortPag(sXML, '05'), sHoraEmitida);
    end;

    // Formas extras
    if LerParametroIni('FRENTE.INI', SECAO_65, CHAVE_FORMAS_CONFIGURADAS, 'Não') = 'Sim' then
    begin
      // Busca no frente.ini a forma da NFC-e equivalente configurada para o frente caixa

      if ValortPag(sXML, '10') > 0.00 then // Forma extra equivalente a tpag 10-Vale Alimentação
      begin
        if TPagDescToFormaExtra('10') = '' then
          PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, '10-Vale Alimentaca' , ValortPag(sXML, '10'), sHoraEmitida)
        else
          PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, TPagDescToFormaExtra('10') , ValortPag(sXML, '10'), sHoraEmitida)
      end;

      if ValortPag(sXML, '11') > 0.00 then // Forma extra equivalente a tpag 11-Vale Refeição
      begin
        if TPagDescToFormaExtra('11') = '' then
          PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, '11-Vale Refeica' , ValortPag(sXML, '11'), sHoraEmitida)
        else
          PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, TPagDescToFormaExtra('11') , ValortPag(sXML, '11'), sHoraEmitida)
      end;

      if ValortPag(sXML, '12') > 0.00 then // Forma extra equivalente a tpag 12-Vale Presente
      begin
        if TPagDescToFormaExtra('12') = '' then
          PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, '12-Vale Presente' , ValortPag(sXML, '12'), sHoraEmitida)
        else
          PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, TPagDescToFormaExtra('12') , ValortPag(sXML, '12'), sHoraEmitida)
      end;

      if ValortPag(sXML, '13') > 0.00 then // Forma extra equivalente a tpag 13-Vale Combustível
      begin
        if TPagDescToFormaExtra('13') = '' then
          PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, '13-Vale Combusti' , ValortPag(sXML, '13'), sHoraEmitida)
        else
          PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, TPagDescToFormaExtra('13') , ValortPag(sXML, '13'), sHoraEmitida)
      end;

      {Sandro Silva 2021-03-05 inicio}       
      if ValortPag(sXML, '16') > 0.00 then // Forma extra equivalente a tpag 16-Depósito Bancário
      begin
        if TPagDescToFormaExtra('16') = '' then
          PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, '16-Deposito Bancario' , ValortPag(sXML, '16'), sHoraEmitida)
        else
          PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, TPagDescToFormaExtra('16') , ValortPag(sXML, '16'), sHoraEmitida)
      end;

      if ValortPag(sXML, '17') > 0.00 then // Forma extra equivalente a tpag 17=Pagamento Instantâneo (PIX) Dinâmico
      begin
        if TPagDescToFormaExtra('17') = '' then
          PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, '17 - Pagamento Instantâneo (PIX) Dinâmico' , ValortPag(sXML, '17'), sHoraEmitida)
        else
          PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, TPagDescToFormaExtra('17') , ValortPag(sXML, '17'), sHoraEmitida)
      end;

      if ValortPag(sXML, '18') > 0.00 then // Forma extra equivalente a tpag 18-Transferência bancária, Carteira Digit
      begin
        if TPagDescToFormaExtra('18') = '' then
          PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, '18-Transf.Banco, Cart.Digital' , ValortPag(sXML, '18'), sHoraEmitida)
        else
          PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, TPagDescToFormaExtra('18') , ValortPag(sXML, '18'), sHoraEmitida)
      end;

      if ValortPag(sXML, '19') > 0.00 then // Forma extra equivalente a tpag 19=Programa de fidelidade, Cashback, Crédito Virtual
      begin
        if TPagDescToFormaExtra('19') = '' then
          PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, '19-Progra Fidelidade,Cashback' , ValortPag(sXML, '19'), sHoraEmitida)
        else
          PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, TPagDescToFormaExtra('19') , ValortPag(sXML, '19'), sHoraEmitida)
      end;
      {Sandro Silva 2021-03-05 fim}

      if ValortPag(sXML, '20') > 0.00 then // Forma extra equivalente a tpag 17=Pagamento Instantâneo (PIX) Dinâmico
      begin
        if TPagDescToFormaExtra('20') = '' then
          PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, '20 - Pagamento Instantâneo (PIX) – Estático' , ValortPag(sXML, '20'), sHoraEmitida)
        else
          PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, TPagDescToFormaExtra('20') , ValortPag(sXML, '20'), sHoraEmitida)
      end;

      {Sandro Silva 2021-12-17 inicio}
      if ValortPag(sXML, '99') > 0.00 then // Outras formas
      begin
        if TPagDescToFormaExtra('99') = '' then
          PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, '99 Outros' , ValortPag(sXML, '99'), sHoraEmitida)
        else
          PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, TPagDescToFormaExtra('99') , ValortPag(sXML, '99'), sHoraEmitida)
      end;
      {Sandro Silva 2021-12-17 fim}

    end
    else
    begin

      {Sandro Silva 2021-12-17 inicio}
      if ValortPag(sXML, '99') > 0.00 then // Outras formas
      begin
        if TPagDescToFormaExtra('99') = '' then
          PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, '99 Outros' , ValortPag(sXML, '99'), sHoraEmitida)
        else
          PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, TPagDescToFormaExtra('99') , ValortPag(sXML, '99'), sHoraEmitida)
      end;
      {Sandro Silva 2021-12-17 fim}

    end; // if LerParametroIni('FRENTE.INI', SECAO_65, CHAVE_FORMAS_CONFIGURADAS, 'Não') = 'Sim' then

    //if dTroco > 0 then
    PostPagament(dtData, sCOO, sCCF, sPedido, sCaixa, sClifor, sVendedor, '13 Troco', dTroco, sHoraEmitida);

  except

  end;
  //XMLNFE := nil;
  FreeAndNil(IBQALTERACA); // Sandro Silva 2019-06-18

end;

procedure _ecf65_IdentificaPercentuaisBaseICMS(var dpRedBC_N14: Real);
begin

  if Pos('|' + Form1.spdNFCeDataSets1.Campo('CST_N12').AsString + '|', '|20|90|') > 0 then // Sandro Silva 2019-09-02 if (Form1.spdNFCeDataSets1.Campo('CST_N12').AsString = '20') then
  begin
    //
    // Quando CST 20, primeiro busca base da configuração do CIT
    //
    Form1.ibDataSet14.First;
    if (Form1.ibDataSet4.FieldByname('ST').AsString <> '') and (Form1.ibDataSet14.Locate('ST;CST', VarArrayOf([Form1.ibDataSet4.FieldByname('ST').AsString, Form1.spdNFCeDataSets1.Campo('orig_N11').Value + Form1.spdNFCeDataSets1.Campo('CST_N12').AsString]), [])) then // Localiza a Alíquota cadastrada na tabela ICM para o CIT e CST
    begin

      // Percentual de redução
      if Form1.ibDataSet14.FieldByName('BASE').AsString = '' then
        dpRedBC_N14 := 0.00 // Sandro Silva 2019-03-11
      else if Form1.ibDataSet14.FieldByName('BASE').AsFloat = 0.00 then
        dpRedBC_N14 := 100.00  // Sandro Silva 2019-03-11
      else if Form1.ibDataSet14.FieldByName('BASE').AsFloat = 100.00 then
        dpRedBC_N14 := 0.00  // Sandro Silva 2019-03-12
      else
        dpRedBC_N14 := Form1.ibDataSet14.FieldByName('BASE').AsFloat;  // Percentual de redução

    end
    else
    begin
      Form1.ibDataSet14.First;
      if (Form1.ibDataSet4.FieldByname('ST').AsString <> '') and (Form1.ibDataSet14.Locate('ST', Form1.ibDataSet4.FieldByname('ST').AsString, [])) then // Localiza a Alíquota cadastrada na tabela ICM para o CIT
      begin

        // Percentual de redução
        if Form1.ibDataSet14.FieldByName('BASE').AsString = '' then
          dpRedBC_N14 := 0.00 // Sandro Silva 2019-03-11
        else if Form1.ibDataSet14.FieldByName('BASE').AsFloat = 0.00 then
          dpRedBC_N14 := 100.00  // Sandro Silva 2019-03-11
        else if Form1.ibDataSet14.FieldByName('BASE').AsFloat = 100.00 then
          dpRedBC_N14 := 0.00  // Sandro Silva 2019-03-12
        else
          dpRedBC_N14 := Form1.ibDataSet14.FieldByName('BASE').AsFloat;

      end;
    end;

  end;

  if Form1.ibDataSet4.FieldByname('ALIQUOTA_NFCE').AsString <> '' then // Sandro Silva 2019-03-12 if Form1.ibDataSet4.FieldByname('ALIQUOTA_NFCE').AsFloat > 0.00 then
  begin

    if (Form1.spdNFCeDataSets1.Campo('CST_N12').AsString <> '40')// Sandro Silva 2019-08-29
      and (Form1.spdNFCeDataSets1.Campo('CST_N12').AsString <> '41') // Sandro Silva 2019-08-29
      and (Form1.spdNFCeDataSets1.Campo('CST_N12').AsString <> '60')
      and (Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value <> '500') then
    begin
      Form1.ibDataSet27.Edit;
      Form1.ibDataSet27.FieldByName('ALIQUICM').AsString := LimpaNumero(FormatFloat('00.00', Form1.ibDataSet4.FieldByName('ALIQUOTA_NFCE').AsFloat));
    end;
    //
    // Se tiver alíquota configurada no ESTOQUE considera a base da TAG
    //
    if Trim(RetornaValorDaTagNoCampo('pRedBC', Form1.ibDataSet4.FieldByname('TAGS_').AsString)) = '' then
      dpRedBC_N14 := 0.00  // Sandro Silva 2019-03-11
    else if StrToFloatDef(RetornaValorDaTagNoCampo('pRedBC', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0) = 0 then
      dpRedBC_N14 := 100.00 // Sandro Silva 2019-03-11
    else if StrToFloatDef(RetornaValorDaTagNoCampo('pRedBC', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0) = 100 then
      dpRedBC_N14 := 0.00 // Sandro Silva 2019-03-12
    else
      dpRedBC_N14 := StrToFloatDef(RetornaValorDaTagNoCampo('pRedBC', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0); // Percentual de redução configurado no estoque
      
  end;

  if Pos('|' + Form1.spdNFCeDataSets1.Campo('CST_N12').AsString + '|', '|00|20|90|') > 0 then // Se CST for 00=Tributado; 02=Com redução de base de cálculo; 90=Outros if Form1.spdNFCeDataSets1.Campo('CST_N12').AssTring = '00' then
  begin
    //
    Form1.spdNFCeDataSets1.Campo('modBC_N13').Value   := '3'; // Modalidade de determinação da Base de Cálculo - ver Manual
    //
    //não gravou a alíquota certa do icm conforme o CIT
    Form1.spdNFCeDataSets1.Campo('pICMS_N16').Value   := FormatFloatXML(StrToFloat('0'+LimpaNumero(Form1.ibDataSet27.FieldByname('ALIQUICM').AsString))/100); // Alíquota do ICMS em Percentual
  end;

  if Pos('|' + Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').AsString + '|', '|900|') > 0 then // Se CSOSN for 900=Tributação ICMS pelo Simples Nacional
  begin
    //
    Form1.spdNFCeDataSets1.Campo('modBC_N13').Value   := '3'; // Modalidade de determinação da Base de Cálculo - ver Manual
    //
    Form1.spdNFCeDataSets1.Campo('pICMS_N16').Value   := FormatFloatXML(StrToFloat('0'+LimpaNumero(Form1.ibDataSet27.FieldByname('ALIQUICM').AsString))/100); // Alíquota do ICMS em Percentual
  end;

end;

procedure _ecf65_IdentificaPercentuaisICMSEfetivo(var dpICMSEfet_N36: Double;
  var dpRedBCEfet_N34: Double);
// Identifica os percentuais usados para cálculo do ICMS efetivo
begin

  // Prioriza configuração feita no produto
  if Form1.ibDataSet4.FieldByname('ALIQUOTA_NFCE').AsString <> '' then // Sandro Silva 2019-03-12 if Form1.ibDataSet4.FieldByname('ALIQUOTA_NFCE').AsFloat > 0.00 then
  begin
    if Trim(RetornaValorDaTagNoCampo('pRedBC', Form1.ibDataSet4.FieldByname('TAGS_').AsString)) = '' then
      dpRedBCEfet_N34 := 0.00 // Sandro Silva 2019-03-11
    else if StrToFloatDef(RetornaValorDaTagNoCampo('pRedBC', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0) = 0.00 then
      dpRedBCEfet_N34 := 100.00 // Sandro Silva 2019-03-11
    else if StrToFloatDef(RetornaValorDaTagNoCampo('pRedBC', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0) = 100.00 then
      dpRedBCEfet_N34 := 0.00 // Sandro Silva 2019-03-12
    else
      dpRedBCEfet_N34 := StrToFloatDef(RetornaValorDaTagNoCampo('pRedBC', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0); // Percentual de redução configurado no Estoque
     dpICMSEfet_N36  := Form1.ibDataSet4.FieldByname('ALIQUOTA_NFCE').AsFloat;
  end
  else
  begin
    // Se não tiver a alíquota configurada no produto usa aquele que está cadastrada no CIT
    Form1.ibDataSet14.First;
    if (LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString) = '1') then
    begin
      //Primeiro, Simples nacional busca o CIT e o CSOSN
      if (Form1.ibDataSet4.FieldByname('ST').AsString <> '') and (Form1.ibDataSet14.Locate('ST;CSOSN', VarArrayOf([Form1.ibDataSet4.FieldByname('ST').AsString, Form1.spdNFCeDataSets1.Campo('CSOSN_N12a').Value]), [])) then // Localiza a Alíquota cadastrada na tabela ICM para o CIT e o CSOSN
      begin
        if Form1.ibDataSet14.FieldByName('BASE').AsString = '' then
          dpRedBCEfet_N34 := 0.00 // Sandro Silva 2019-03-11
        else if Form1.ibDataSet14.FieldByName('BASE').AsFloat = 0.00 then
          dpRedBCEfet_N34 := 100.00 // Sandro Silva 2019-03-11
        else if StrToFloatDef(RetornaValorDaTagNoCampo('pRedBC', Form1.ibDataSet4.FieldByname('TAGS_').AsString), 0) = 100.00 then
          dpRedBCEfet_N34 := 0.00 // Sandro Silva 2019-03-12
        else
          dpRedBCEfet_N34 := Form1.ibDataSet14.FieldByName('BASE').AsFloat;  // Percentual de redução
        dpICMSEfet_N36  := Form1.ibDataSet14.FieldByName(Form1.ibDataSet13.FieldByName('ESTADO').AsString+'_').AsFloat
      end
      else
      begin
        // Se não achou busca apenas pelo CIT
        Form1.ibDataSet14.First;
        if (Form1.ibDataSet4.FieldByname('ST').AsString <> '') and (Form1.ibDataSet14.Locate('ST', Form1.ibDataSet4.FieldByname('ST').AsString, [])) then // Localiza a Alíquota cadastrada na tabela ICM para CIT
        begin
          if Form1.ibDataSet14.FieldByName('BASE').AsString = '' then
            dpRedBCEfet_N34 := 0.00 // Sandro Silva 2019-03-11
          else if Form1.ibDataSet14.FieldByName('BASE').AsFloat = 0.00 then
            dpRedBCEfet_N34 := 100.00 // Sandro Silva 2019-03-11
          else if Form1.ibDataSet14.FieldByName('BASE').AsFloat = 100.00 then
            dpRedBCEfet_N34 := 0.00 // Sandro Silva 2019-03-12
          else
            dpRedBCEfet_N34 := Form1.ibDataSet14.FieldByName('BASE').AsFloat;  // Percentual de redução
          dpICMSEfet_N36  := Form1.ibDataSet14.FieldByName(Form1.ibDataSet13.FieldByName('ESTADO').AsString+'_').AsFloat
        end;
      end;
    end
    else
    begin
      // Primeiro, Regime Normal usa o CIT e o CST
      if (Form1.ibDataSet4.FieldByname('ST').AsString <> '') and (Form1.ibDataSet14.Locate('ST;CST', VarArrayOf([Form1.ibDataSet4.FieldByname('ST').AsString, Form1.spdNFCeDataSets1.Campo('orig_N11').Value + Form1.spdNFCeDataSets1.Campo('CST_N12').AsString]), [])) then // Localiza a Alíquota cadastrada na tabela ICM para o CIT e CST
      begin
        if Form1.ibDataSet14.FieldByName('BASE').AsString = '' then
          dpRedBCEfet_N34 := 0.00 // Sandro Silva 2019-03-11
        else if Form1.ibDataSet14.FieldByName('BASE').AsFloat = 0.00 then
          dpRedBCEfet_N34 := 100.00 // Sandro Silva 2019-03-11
        else if Form1.ibDataSet14.FieldByName('BASE').AsFloat = 100.00 then
          dpRedBCEfet_N34 := 0.00 // Sandro Silva 2019-03-12
        else
          dpRedBCEfet_N34 := Form1.ibDataSet14.FieldByName('BASE').AsFloat;  // Percentual de redução
        dpICMSEfet_N36  := Form1.ibDataSet14.FieldByName(Form1.ibDataSet13.FieldByName('ESTADO').AsString+'_').AsFloat;
      end
      else
      begin
        // Se não achou busca apenas pelo CIT
        Form1.ibDataSet14.First;
        if (Form1.ibDataSet4.FieldByname('ST').AsString <> '') and (Form1.ibDataSet14.Locate('ST', Form1.ibDataSet4.FieldByname('ST').AsString, [])) then // Localiza a Alíquota cadastrada na tabela ICM para o CIT
        begin
          if Form1.ibDataSet14.FieldByName('BASE').AsString = '' then
            dpRedBCEfet_N34 := 0.00 // Sandro Silva 2019-03-11
          else if Form1.ibDataSet14.FieldByName('BASE').AsFloat = 0.00 then
            dpRedBCEfet_N34 := 100.00 // Sandro Silva 2019-03-11
          else if Form1.ibDataSet14.FieldByName('BASE').AsFloat = 100.00 then
            dpRedBCEfet_N34 := 0.00 // Sandro Silva 2019-03-12
          else
            dpRedBCEfet_N34 := Form1.ibDataSet14.FieldByName('BASE').AsFloat;  // Percentual de redução
          dpICMSEfet_N36  := Form1.ibDataSet14.FieldByName(Form1.ibDataSet13.FieldByName('ESTADO').AsString+'_').AsFloat;
        end
      end;
    end;

  end; // if Form1.ibDataSet4.FieldByname('ALIQUOTA_NFCE').AsFloat > 0.00 then

end;


procedure _ecf65_CalculaDesoneracao(sUF: String; sCit: String; sCrt: String;
  sCst: String; sAliquota: String; dpRedBC: Double; dvBC: Double;
  DataSetICM: TDataSet; DataSetESTOQUE: TDataSet;
  var dvICMSDeson_N28a: Real; var dvICMS: Double);
var
  dvIcmsIntegral: Real;
begin
  //
  // Calcula valores para aplicar na desoneração
  //
  // Sandro Silva 2020-04-14  if Form1.sVersaoLayoutNFCe = '4.00' then // Sandro Silva 2018-02-14 4.0
  //begin

    if (LimpaNumero(sCrt) <> '1') then
    begin

      if DataSetEstoque.FieldByname('ALIQUOTA_NFCE').AsFloat > 0.00 then
      begin
        sAliquota := FormatFloat('0.00', DataSetEstoque.FieldByName('ALIQUOTA_NFCE').AsFloat);
      end
      else
      begin
        if LimpaNumero(sAliquota) = '' then
        begin
          DataSetICM.First;
          if (sCit <> '')
            //and (DataSetICM.Locate('ST;CST', VarArrayOf([sCit, sCSt]), [])) then // Localiza a Alíquota cadastrada na tabela ICM para o CIT e CST
            and (DataSetICM.Locate('ST', sCit, [])) then // Localiza a Alíquota cadastrada na tabela ICM para o CIT e CST
            sAliquota := FormatFloat('0.00', DataSetICM.FieldByName(sUF + '_').AsFloat);
        end;
      end;

      dvIcmsIntegral := StrToFloat(FormatFloat('##0.00', (dvBC * (StrToIntDef(LimpaNumero(sAliquota), 0) / 10000)))); // Cálculo do valor icms integral, sem redução na base

      if (dpRedBC > 0) and (dpRedBC <> 100) then // Reduz a base de cálculo
        dvBC := StrToFloatDef(FormatFloat('0.00', dvBC * (dpRedBC / 100)), 0); // Aplica a redução na B.C.

      dvICMS := StrToFloat(FormatFloat('##0.00', (dvBC * (StrToIntDef(LimpaNumero(sAliquota), 0) / 10000)))); // Cálculo do valor do icms com redução na base

      if Pos('|' + Form1.spdNFCeDataSets1.Campo('CST_N12').AsString + '|', '|20|90|') > 0 then // Se CST for 02=Com redução de base de cálculo; 90=Outros
      begin
        dvICMSDeson_N28a := dvIcmsIntegral - dvICMS;
      end;

      if Pos('|' + Right(sCst, 2) + '|', '|40|41|') > 0 then // if Pos('|' + Right(sCst, 2) + '|', '|40|41|50|60|') > 0 then
      begin
        dvICMSDeson_N28a := dvIcmsIntegral;
      end;

    end;

  //end;

end;

procedure _ecf65_IdentificacaoResponsavelTecnico(spdNFCeDataSets: TspdNFCeDataSets);
begin
  // Ficha 4578 // Sandro Silva 2019-04-11
  // Grupo Responsável técnico
  spdNFCeDataSets.Campo('CNPJ_ZD02').Value     := LimpaNumero(CNPJ_SOFTWARE_HOUSE_PAF); 	// Informar o CNPJ da pessoa jurídica responsável pelo sistema utilizado na emissão do documento fiscal eletrônico.
  spdNFCeDataSets.Campo('xContato_ZD04').Value := 'Alessio Mainardi'; // Sandro Silva 2022-12-02 Unochapeco 'Ronei Ivo Weber'; // 	Informar o nome da pessoa a ser contatada na empresa desenvolvedora do sistema utilizado na emissão do documento fiscal eletrônico.
  spdNFCeDataSets.Campo('email_ZD05').Value    := 'smallsoft@smallsoft.com.br';   //	Informar o e-mail da pessoa a ser contatada na empresa desenvolvedora do sistema.
  spdNFCeDataSets.Campo('fone_ZD06').Value     := '04934255800'; 	// Informar o telefone da pessoa a ser contatada na empresa desenvolvedora do sistema. Preencher com o Código DDD + número do telefone
end;

procedure _ecf65_ImportaXmlInutilizacao(sCaminhoXml: String);
var
  sl: TStringList;
  slXml: TStringList;
  sModelo: String;
  sSerie: String;
  sID: String;
  sXML: String;
  sNPROT: String;
  iInutil: Integer;
begin
  sl := TStringList.Create;
  slXml := TStringList.Create;

  _ecf65_SelecionaXmlInutilizacao(sl, sCaminhoXml + '*inu*.xml');

  for iInutil := 0 to sl.Count -1 do
  begin
    if sl.Strings[iInutil] <> '' then
    begin

      slXml.Clear;
      slXml.LoadFromFile(sCaminhoXml + sl.Strings[iInutil]);

      if xmlNodeValue(slXml.Text, '//infInut/cStat') = '102' then
      begin

        if (xmlNodeValue(slXml.Text, '//infInut/nNFIni') <> '') and (xmlNodeValue(slXml.Text, '//infInut/nNFFin') <> '') then
        begin

          sModelo := xmlNodeValue(slXml.Text, '//infInut/mod');
          sSerie  := xmlNodeValue(slXml.Text, '//infInut/serie');
          sID     := LimpaNumero(xmlNodeValue(slXml.Text, '//infInut/@Id'));
          sNPROT  := xmlNodeValue(slXml.Text, '//infInut/nProt');
          sXML    := slXml.Text;

          Form1.IBQuery65.Close;
          Form1.IBQuery65.SQL.Text :=
            'select REGISTRO ' +
            'from INUTILIZACAO ' +
            'where NPROT = ' + QuotedStr(sNPROT) +
            ' and MODELO = ' + QuotedStr(sMODELO);
          Form1.IBQuery65.Open;
          if Form1.IBQuery65.FieldByName('REGISTRO').AsString = '' then
            _ecf65_GravarInutilizacao(sXML, Form1.IBQuery65);

        end; // if (xmlNodeValue(slXml.Text, '//infInut/nNFIni') <> '') and (xmlNodeValue(slXml.Text, '//infInut/nNFFin') <> '') then

      end; // if xmlNodeValue(slXml.Text, '//infInut/cStat') = '102' then

    end; // if sl.Strings[iInutil] <> '' then

  end; // for iInutil := 0 to sl.Count -1 do

end;

function _ecf65_GravarInutilizacao(sXML: String; IBQuery: TIBQuery): Boolean;
var
  sModelo: String;
  sAno: String;
  sSerie: String;
  iNINI: Integer;
  iNFIN: Integer;
  sNPROT: String;
  sData: String;
begin
  Result := False;

  try

    if xmlNodeValue(sXML, '//infInut/cStat') = '102' then
    begin

      sModelo := xmlNodeValue(sXML, '//infInut/mod');
      sAno    := xmlNodeValue(sXML, '//infInut/ano');
      sSerie  := xmlNodeValue(sXML, '//infInut/serie');
      if sModelo = '57' then
      begin
        iNINI := StrToIntDef(xmlNodeValue(sXML, '//infInut/nCTIni'), 0);
        iNFIN := StrToIntDef(xmlNodeValue(sXML, '//infInut/nCTFin'), 0);
      end
      else
      begin
        iNINI := StrToIntDef(xmlNodeValue(sXML, '//infInut/nNFIni'), 0);
        iNFIN := StrToIntDef(xmlNodeValue(sXML, '//infInut/nNFFin'), 0);
      end;
      sNPROT := xmlNodeValue(sXML, '//infInut/nProt');
      sData  := Copy(xmlNodeValue(sXML, '//infInut/dhRecbto'), 1, 10);
      sData  := Copy(sData, 9, 2) + '/' + Copy(sData, 6, 2) + '/' + Copy(sData, 1, 4);
      if (iNINI > 0) and (iNFIN > 0) then
      begin

        IBQuery.Close;
        IBQuery.SQL.Text :=
          'insert into INUTILIZACAO (REGISTRO, MODELO, ANO, SERIE, NINI, NFIN, XML, NPROT, DATA) ' +
          'values (right(''0000000000''||gen_id(G_INUTILIZACAO, 1), 10), :MODELO, :ANO, :SERIE, :NINI, :NFIN, :XML, :NPROT, :DATA)';
        IBQuery.ParamByName('MODELO').AsString := sModelo;
        IBQuery.ParamByName('ANO').AsString    := sAno;
        IBQuery.ParamByName('SERIE').AsString  := sSerie;
        IBQuery.ParamByName('NINI').AsInteger  := iNINI;
        IBQuery.ParamByName('NFIN').AsInteger  := iNFIN;
        IBQuery.ParamByName('XML').AsString    := sXML;
        IBQuery.ParamByName('NPROT').AsString  := sNPROT;
        IBQuery.ParamByName('DATA').AsString   := sData;
        IBQuery.ExecSQL;
        Result := True
      end; // if (iNINI > 0) and (iNFIN > 0) then

    end; // if xmlNodeValue(sXML, '//infInut/cStat') = '102' then

  except
  end;
end;

function _ecf65_ValidaGtinNFCe(sEan: String): Boolean;
// Sandro Silva 2019-06-11
// Valida se o Gtin informado é válido, usando ValidaEAN() e comparando o prefixo
// Prefixo 781 e 792 indicam EAN de uso interno não registrado no GS1
begin
  Result := ValidaEAN13(LimpaNumero(sEan));
  if Result then
  begin
    if (Copy(LimpaNumero(sEan), 1, 3) = '781') or (Copy(LimpaNumero(sEan), 1, 3) = '792') then
      Result := False;
  end;
end;

procedure _ecf65_InfAddProdFCP(spdNFCeDataSets: TspdNFCeDataSets; dvFCP_N17c: Double;
  dvBC_N15: Double);
// Ficha 4681 Sandro Silva 2019-06-14 
begin
  if dvFCP_N17c > 0 then
  begin
    if spdNFCeDataSets.Campo('infAdProd_V01').AsString <> '' then
      spdNFCeDataSets.Campo('infAdProd_V01').AsString := spdNFCeDataSets.Campo('infAdProd_V01').AsString + ' ';
    spdNFCeDataSets.Campo('infAdProd_V01').AsString := spdNFCeDataSets.Campo('infAdProd_V01').AsString +
                                                       'vBCFCP=' + FormatFloat('0.00', dvBC_N15) +
                                                       ', pFCP=' + StringReplace(spdNFCeDataSets.Campo('pFCP_N17b').Value, '.', ',', [rfReplaceAll]) +
                                                       ', vFCP=' + FormatFloat('0.00', dvFCP_N17c);
  end;
end;

function _ecf65_GeraContingenciaParaCancelamentoPorSubstituicao(sNumeroNF: String;
  sCaixa: String; dtEnvio: TDate; sNFEXml: String; sNumeroOrcamento: String;
  sNumeroOs: String): Boolean;
// Método para utilizar quando precisa gerar uma NFC-e em contingência a partir dos dados de outra em emissão normal
// para posteriormente realizar o cancelamento por substituição da NFC-e de emissão normal
var
  iField: Integer;
  sNovoNumero: String;
  sDAV: String;
  sTIPODAV: String;
  Mais1ini: TIniFile;
  IBQALTERACA: TIBQuery;
  IBQPAGAMENT: TIBQuery;
  IBQRECEBER: TIBQuery;
//  slLog: TStringList;
begin
  Result := False;
  IBQALTERACA := CriaIBQuery(Form1.ibDataSet27.Transaction);
  IBQPAGAMENT := CriaIBQuery(Form1.IBDataSet28.Transaction);
  IBQRECEBER  := CriaIBQuery(Form1.ibDataSet7.Transaction);
//  slLog := TStringList.Create;

  if _ecf65_TodosItensCancelados(Form1.ibDataSet27.Transaction, sNumeroNF, sCaixa) = False then // Sandro Silva 2021-11-01
  begin

    try
      Audita('EMISSAO','FRENTE', '', 'Iniciou Contingência-' + ExtractFileName(Application.ExeName) + ' ' + LimpaNumero(Form22.sBuild) + ' ' + sNumeroNF + ' ' + Form1.sCaixa,0,0); // Ato, Modulo, Usuário, Histórico, Valor // Sandro Silva 2019-03-06
    except

    end;

    try

      try
        // Salva as formas de pagamento do cupom atual
        _ecf65_GravaPagamentFromXML(sNFEXml, sNumeroNF, sCaixa);
      except

      end;

      // Início seleção dos dados relacionado ao cupom atual
      IBQALTERACA.Close;
      IBQALTERACA.SQL.Text :=
        'select * ' +
        'from ALTERACA ' +
        'where PEDIDO = ' + QuotedStr(sNumeroNF) +
        ' and CAIXA = ' + QuotedStr(sCaixa);
      IBQALTERACA.Open;

      IBQPAGAMENT.Close;
      IBQPAGAMENT.SQL.Text := Form1.ibDataSet28.SelectSQL.Text;
      IBQPAGAMENT.Open;

      IBQRECEBER.Close;
      IBQRECEBER.SQL.Text := Form1.ibDataSet7.SelectSQL.Text;
      IBQRECEBER.Open;

      // Fim seleção dos dados relacionado ao cupom atual

      sNovoNumero := FormataNumeroDoCupom(0); // Sandro Silva 2021-12-02 sNovoNumero := '000000';
      //
      while Form1.iCupom >= StrToInt(sNovoNumero) do
      begin
        sNovoNumero := FormataNumeroDoCupom(IncrementaGenerator('G_NUMERONFCE', 1)); // Sandro Silva 2021-12-02 sNovoNumero := StrZero(IncrementaGenerator('G_NUMERONFCE', 1), 6, 0);
      end;

      try
        // Salva os dados dos itens com o novo cupom
        Form1.ibDataSet27.Close;
        Form1.ibDataSet27.SelectSQL.Text :=
          'select * ' +
          'from ALTERACA ' +
          'where PEDIDO = ' + QuotedStr(sNovoNumero) +
          ' and CAIXA = ' + QuotedStr(sCaixa);
        Form1.ibDataSet27.Open;

        IBQALTERACA.First;
        while IBQALTERACA.Eof = False do
        begin
          try
            Form1.ibDataSet27.Append;
            for iField := 0 to IBQALTERACA.Fields.Count - 1 do
            begin
              try
                // Repassa o conteúdo de cada campo da query para o campo do dataset
                if (AnsiUpperCase(IBQALTERACA.Fields[iField].FieldName) <> 'REGISTRO')
                  and (AnsiUpperCase(IBQALTERACA.Fields[iField].FieldName) <> 'ENCRYPTHASH') then
                begin
                  if AnsiUpperCase(IBQALTERACA.Fields[iField].FieldName) = 'PEDIDO' then
                    Form1.ibDataSet27.FieldByName(IBQALTERACA.Fields[iField].FieldName).Value := sNovoNumero
                  else if AnsiUpperCase(IBQALTERACA.Fields[iField].FieldName) = 'TIPO' then
                  begin
                    if (IBQALTERACA.FieldByName('TIPO').AsString = 'CANCEL')
                      or (IBQALTERACA.FieldByName('TIPO').AsString = 'CANLOK')
                      or (IBQALTERACA.FieldByName('TIPO').AsString = 'KOLNAC') then
                      Form1.ibDataSet27.FieldByName(IBQALTERACA.Fields[iField].FieldName).Value := 'CANCEL' //Todos as situações de cancelamento devem ficar como CANCEL, para não retornar 2x pro estoque
                    else
                      Form1.ibDataSet27.FieldByName(IBQALTERACA.Fields[iField].FieldName).Value := IBQALTERACA.Fields[iField].Value;      // TOTAL TFloatField DESCONTO TIBBCDField
                  end
                  else
                    Form1.ibDataSet27.FieldByName(IBQALTERACA.Fields[iField].FieldName).Value := IBQALTERACA.Fields[iField].Value;
                end; // if (AnsiUpperCase(IBQALTERACA.Fields[iField].FieldName) <> 'REGISTRO') and (AnsiUpperCase(IBQALTERACA.Fields[iField].FieldName) <> 'ENCRYPTHASH') then
              except
                on E: Exception do
                begin
                  //slLog.Add(IBQALTERACA.Fields[iField].FieldName ':' + E.Message);
                end;
              end;
            end; // for iField := 0 to IBQALTERACA.Fields.Count - 1 do

            // Baixar estoque
            try
              if (IBQALTERACA.FieldByName('CODIGO').AsString <> '') then // Tem que ter código
              begin
                if (IBQALTERACA.FieldByName('TIPO').AsString <> 'CANCEL')
                  and (IBQALTERACA.FieldByName('TIPO').AsString <> 'CANLOK')
                  and (IBQALTERACA.FieldByName('TIPO').AsString <> 'KOLNAC') then
                begin
                  // Não está cancelado, baixa o estoque

                  if (IBQALTERACA.FieldByName('TIPO').AsString = 'BALCAO') then // Tem que ser tipo "BALCAO". Se for "LOKED" será baixado posteriormente conforme rotina normal
                  begin

                    //
                    // Início da baixa do estoque
                    //
                    Form1.ibDataSet4.Close;
                    Form1.ibDataSet4.SelectSQL.Clear;
                    Form1.ibDataSet4.SelectSQL.Add('select * from ESTOQUE where CODIGO = ' + QuotedStr(Form1.ibDataSet27.FieldByName('CODIGO').AsString) + ' and coalesce(ATIVO, 0) = 0 ');
                    Form1.ibDAtaSet4.Open;

                    if Alltrim(Form1.ibDataSet4.FieldByName('DESCRICAO').AsString) = Alltrim(Form1.ibDataSet27.FieldByName('DESCRICAO').AsString) then
                    begin

                      if (Form1.ibDataSet4.FieldByName('TIPO_ITEM').AsString <> '09') then // serviços não atera a quantidade
                      begin
                        try
                          Form1.ibDataSet4.Edit; // altera a quantidade no estoque
                          Form1.ibDataSet4.FieldByName('QTD_ATUAL').AsFloat := (Form1.ibDataSet4.FieldByName('QTD_ATUAL').AsFloat - Form1.ibDataSet27.FieldByName('QUANTIDADE').AsFloat); // Quando gera contingência de uma NFC-e sem retorno da transmissão
                          Form1.ibDataSet4.Post;
                        except
                          Form1.ibDataSet27.FieldByName('TIPO').AsString := 'LOKED';// Baixa depois, registro travado por outra transação
                        end;
                      end; // if (Form1.ibDataSet4.FieldByName('TIPO_ITEM').AsString <> '09') then

                    end; // if Alltrim(Form1.ibDataSet4.FieldByName('DESCRICAO').AsString) = Alltrim(Form1.ibDataSet27.FieldByName('DESCRICAO').AsString) then

                    //
                    // Fim da baixa do estoque
                    //

                    /////////////////////////////////////////////////
                    //
                    // S E R I A L - Início do acerto do número do documento para os itens com número de série
                    //
                    /////////////////////////////////////////////////
                    if Form1.ibDataSet4.FieldByName('SERIE').Value = 1 then // Produto com controle de serial
                    begin

                      // Ajusta o controle por número de série
                      Form1.ibDataSet30.Close;
                      Form1.ibDataSet30.SelectSQL.Clear;
                      Form1.ibDataSet30.Selectsql.Add('select * from SERIE where CODIGO='+QuotedStr(Form1.ibDataSet4.FieldByName('CODIGO').AsString));
                      Form1.ibDataSet30.Open;
                      while not Form1.ibDataSet30.Eof do
                      begin
                        if Copy(Form1.ibDataset30.FieldByName('NFVENDA').AsString,1,6) = sNumeroNF then // valida se o serial foi vendido pela NFC-e que está sendo substituída
                        begin
                          try
                            Form1.ibDataset30.Edit;
                            Form1.ibDataset30.FieldByName('NFVENDA').AsString    := sNovoNumero;
                            Form1.ibDataset30.FieldByName('DATVENDA').AsDateTime := Form1.ibDataSet27.FieldByName('DATA').AsDateTime;
                            Form1.ibDataset30.Post; // Sandro Silva 2020-05-05
                          except

                          end;
                        end;
                        Form1.ibDataset30.Next;
                      end;
                    end;
                    /////////////////////////////////////////////////
                    //
                    // S E R I A L - final
                    //
                    /////////////////////////////////////////////////


                  end; // if (IBQALTERACA.FieldByName('TIPO').AsString = 'BALCAO') then

                end; // if (IBQALTERACA.FieldByName('TIPO').AsString <> 'CANCEL') and (IBQALTERACA.FieldByName('TIPO').AsString <> 'CANLOK') and (IBQALTERACA.FieldByName('TIPO').AsString <> 'KOLNAC') then

              end; // if (IBQALTERACA.FieldByName('CODIGO').AsString <> '') then
            except

            end;
            Form1.ibDataSet27.Post;
          except
            // Sandro Silva 2020-05-05
          end;
          IBQALTERACA.Next;
        end; // while IBQ.Eof = False do
      except

      end;

      try
        // Dados das formas de pagamento
        Form1.IBDataSet28.Close;
        Form1.IBDataSet28.SelectSQL.Text :=
          'select * from PAGAMENT ' +
          'where (coalesce(CLIFOR, '''') <> ''Sangria'' and coalesce(CLIFOR, '''') <> ''Suprimento'') ' +
          'and CAIXA='+QuotedStr(sCaixa)+' and PEDIDO='+QuotedStr(sNovoNumero) +
          ' order by REGISTRO';
        Form1.IBDataSet28.Open;

        IBQPAGAMENT.First;
        while IBQPAGAMENT.Eof = False do
        begin
          try
            Form1.IBDataSet28.Append;
            for iField := 0 to IBQPAGAMENT.Fields.Count - 1 do
            begin
              try
                if (AnsiUpperCase(IBQPAGAMENT.Fields[iField].FieldName) <> 'REGISTRO')
                  and (AnsiUpperCase(IBQPAGAMENT.Fields[iField].FieldName) <> 'ENCRYPTHASH') then
                begin

                  if AnsiUpperCase(IBQPAGAMENT.Fields[iField].FieldName) = 'PEDIDO' then
                    Form1.IBDataSet28.FieldByName(IBQPAGAMENT.Fields[iField].FieldName).Value := sNovoNumero
                  else
                    Form1.IBDataSet28.FieldByName(IBQPAGAMENT.Fields[iField].FieldName).Value := IBQPAGAMENT.Fields[iField].Value;

                end; // if (AnsiUpperCase(IBQPAGAMENT.Fields[iField].FieldName) <> 'REGISTRO') and (AnsiUpperCase(IBQPAGAMENT.Fields[iField].FieldName) <> 'ENCRYPTHASH') then
              except

              end;

            end;
            Form1.IBDataSet28.Post;
          except

          end;
          IBQPAGAMENT.Next;
        end; // while IBQ.Eof = False do
      except
      end;

      ///////////////////////////////////////////
      //
      // Início dados da tabela contas a receber
      //
      //////////////////////////////////////////

      try
        Form1.ibDataSet7.Close;
        Form1.ibDataSet7.SelectSQL.Text :=
          'select * from RECEBER where NUMERONF='+QuotedStr(FormataNumeroDoCupom(StrToInt(sNovoNumero)) + RightStr(sCaixa, 3)) + ' order by REGISTRO';
        Form1.ibDataSet7.Open;

        IBQRECEBER.First;
        while IBQRECEBER.Eof = False do
        begin
          try
            Form1.ibDataSet7.Append;
            for iField := 0 to IBQRECEBER.Fields.Count - 1 do
            begin
              if (AnsiUpperCase(IBQRECEBER.Fields[iField].FieldName) <> 'REGISTRO') then
              begin

                try
                  if AnsiUpperCase(IBQRECEBER.Fields[iField].FieldName) = 'NUMERONF' then
                    Form1.IBDataSet7.FieldByName(IBQRECEBER.Fields[iField].FieldName).Value := FormataNumeroDoCupom(StrToInt(sNovoNumero)) + Copy(sCaixa, 1, 3) // Sandro Silva 2021-12-02 Form1.IBDataSet7.FieldByName(IBQRECEBER.Fields[iField].FieldName).Value := StrZero(StrToInt(sNovoNumero), 6, 0) + Copy(sCaixa, 1, 3)
                  else if AnsiUpperCase(IBQRECEBER.Fields[iField].FieldName) = 'DOCUMENTO' then
                    Form1.IBDataSet7.FieldByName(IBQRECEBER.Fields[iField].FieldName).Value := sCaixa + FormataNumeroDoCupom(StrToInt(sNovoNumero)) + RightStr(IBQRECEBER.FieldByName('DOCUMENTO').AsString, 1) // Sandro Silva 2021-12-02 Form1.IBDataSet7.FieldByName(IBQRECEBER.Fields[iField].FieldName).Value := sCaixa + StrZero(StrToInt(sNovoNumero), 6, 0) + RightStr(IBQRECEBER.FieldByName('DOCUMENTO').AsString, 1)
                  else
                    Form1.IBDataSet7.FieldByName(IBQRECEBER.Fields[iField].FieldName).Value := IBQRECEBER.Fields[iField].Value;

                  // Acerta o número da nota no histórico
                  if AnsiUpperCase(IBQRECEBER.Fields[iField].FieldName) = 'HISTORICO' then
                  begin
                    if AnsiContainsText(Form1.IBDataSet7.FieldByName(IBQRECEBER.Fields[iField].FieldName).Value, 'Cupom: ') then
                      Form1.IBDataSet7.FieldByName(IBQRECEBER.Fields[iField].FieldName).Value := StringReplace(Form1.IBDataSet7.FieldByName(IBQRECEBER.Fields[iField].FieldName).Value, FormataNumeroDoCupom(StrToIntDef(sNumeroNF, 0)), FormataNumeroDoCupom(StrToIntDef(sNovoNumero, 0)), [rfReplaceAll]) // Sandro Silva 2021-12-02 Form1.IBDataSet7.FieldByName(IBQRECEBER.Fields[iField].FieldName).Value := StringReplace(Form1.IBDataSet7.FieldByName(IBQRECEBER.Fields[iField].FieldName).Value, StrZero(StrToIntDef(sNumeroNF, 0), 6, 0), StrZero(StrToIntDef(sNovoNumero, 0), 6, 0), [rfReplaceAll])
                  end;

                except

                end;

              end; // if (AnsiUpperCase(IBQRECEBER.Fields[iField].FieldName) <> 'REGISTRO') then

            end;
            Form1.ibDataSet7.Post;
          except
          end;
          IBQRECEBER.Next;
        end; // while IBQ.Eof = False do
      except

      end;
      ////////////////////////////////////////
      //
      // Fim dados da tabela contas a receber
      //
      ////////////////////////////////////////    

      try
        // Dados da tabela NFCE
        Form1.ibDataset150.Close;
        Form1.ibDataset150.SelectSql.Clear;
        Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF = ' + QuotedStr(FormataNumeroDoCupom(0)) + ' and CAIXA = ' + QuotedStr(sCaixa) + ' and MODELO = ''65'' '); // Sandro Silva 2021-12-02 Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF=''000000'' and CAIXA = ' + QuotedStr(sCaixa) + ' and MODELO = ''65'' ');
        Form1.ibDataset150.Open;
        //
        Form1.IBDataSet150.Append;
        Form1.IBDataSet150.FieldByName('NUMERONF').AsString := sNovoNumero;
        Form1.IBDataSet150.FieldByName('DATA').AsDateTime   := dtEnvio;
        Form1.IBDataSet150.FieldByName('CAIXA').AsString    := sCaixa;
        Form1.IBDataSet150.FieldByName('MODELO').AsString   := '65';
        Form1.IBDataSet150.Post;
      except

      end;

      {Sandro Silva 2021-11-03 inicio}
      try
        Audita('Substitui', 'FRENTE', '', 'Cancelamento por substituição ' + sNumeroNF + '->' + sNovoNumero, 0, 0); // Gera auditoria da nota substituida
      except
      end;
      {Sandro Silva 2021-11-03 fim}
      
      {Sandro Silva 2023-08-22 inicio
      Mais1ini  := TIniFile.Create('FRENTE.INI');
      Mais1Ini.WriteString('NFCE', 'CUPOM', sNovoNumero);
      Mais1Ini.Free;
      }
      GravaNumeroCupomFrenteINI(sNovoNumero, '65'); // Sandro Silva 2023-08-22
      {Sandro Silva 2023-08-22 fim}     

      if sNumeroOrcamento <> '' then
      begin
        sDAV     := sNumeroOrcamento;
        sTIPODAV := 'ORÇAMENTO';
      end;

      if sNumeroOs <> '' then
      begin
        sDAV     := sNumeroOs;
        sTIPODAV := 'OS';
      end;

      Form1.AtualizaDetalhe(Form1.IBQuery65.Transaction, sTIPODAV, sDAV, sCaixa, sCaixa, sNovoNumero, 'Fechada');

      //
      if FormataNumeroDoCupom(Form1.iCupom) <> sNovoNumero then // Sandro Silva 2021-11-29 if StrZero(Form1.iCupom,6,0) <> sNovoNumero then
      begin
        Form1.Memo1.Text := StrTran(Form1.Memo1.Text,FormataNumeroDoCupom(Form1.iCupom),sNovoNumero); // Sandro Silva 2021-11-29 Form1.Memo1.Text := StrTran(Form1.Memo1.Text,StrZero(Form1.iCupom,6,0),sNovoNumero);
        Form1.Memo1.Update;
      end;
      //
      Form1.iCupom := StrToInt(sNovoNumero);

    except

    end;

    Result := True;

  end; // if _ecf65_TodosItensCancelados = False then

  Commitatudo2(True); // Gera novo nfc-e a partir de outra

  FreeAndNil(IBQRECEBER);
  FreeAndNil(IBQPAGAMENT);
  FreeAndNil(IBQALTERACA);
end;

function _ecf65_XmlNfceCancelado(sXml: String): Boolean;
begin
  Result := False;
  if (Pos('<cStat>135</cStat>', sXml) > 0) and ((Pos('<tpEvento>110112</tpEvento>', sXml) > 0) or (Pos('<tpEvento>110111</tpEvento>', sXml) > 0)) then
    Result := True;
end;

function _ecf65_ConsultaChaveNFCe: Boolean;
var
  sRetorno: String;
  sNfeId: String;
  sXmlEnvio: String;
  sXmlAutorizado: String;
  sArquivoEnvio: String;
  slArquivoEnvio: TStringList;
  sNumeroNF: String;
  sCaixaNF: String;
  sStatus: String;
begin
  // Se a nota não estiver autorizada faz a Consulta pela chave
  // Se retornar autorizada procura o arquivo com xml autorizado na pasta xmldestinatario ou o xml de envio na pasta log e grava no banco
  Result := True;
  slArquivoEnvio := TStringList.Create;
  if RightStr('000000000' + Form1.IBDataSet150.FieldByName('NUMERONF').AsString, 9) = _ecf65_NumeroNfFromChave(LimpaNumero(xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//infNFe/@Id'))) then
    sNfeId := LimpaNumero(xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//infNFe/@Id'));
  if sNfeId = '' then
  begin
    if RightStr('000000000' + Form1.IBDataSet150.FieldByName('NUMERONF').AsString, 9) = _ecf65_NumeroNfFromChave(LimpaNumero(Form1.IBDataSet150.FieldByName('NFEID').AsString)) then
      sNfeId := LimpaNumero(Form1.IBDataSet150.FieldByName('NFEID').AsString);
  end;
  
  sNumeroNF := Form1.IBDataSet150.FieldByName('NUMERONF').AsString;
  sCaixaNF  := Form1.IBDataSet150.FieldByName('CAIXA').AsString;

  Form1.ExibePanelMensagem('Aguarde... Consultando o documento ' + sNumeroNF + ' - Caixa ' + sCaixaNF); // Sandro Silva 2017-06-22

  if (sNfeId <> '') then // Sandro Silva 2019-08-13 if (sNfeId <> '') and (AnsiContainsText(Form1.IBDataSet150.FieldByName('STATUS').AsString, 'autoriza') = False) then
  begin

    try // Sandro Silva 2021-09-13
      sRetorno := Form1.spdNFCe1.ConsultarNF(sNfeId);
    except
    end;

    sRetorno := _ecf65_CorrigePadraoRespostaSefaz(sRetorno);

    // Sandro Silva 2022-04-12 if ((Pos('<cStat>100</cStat>', sRetorno) <> 0) or (Pos('<cStat>150</cStat>', sRetorno) <> 0)) // 100|Autorizado o uso da NF-e ou 150|Autorizado o uso da NF-e, autorização fora de prazo // Sandro Silva 2018-08-10
    if (_ecf65_xmlAutorizado(sRetorno)) // 100|Autorizado o uso da NF-e ou 150|Autorizado o uso da NF-e, autorização fora de prazo // Sandro Silva 2018-08-10
      and (_ecf65_XmlNfceCancelado(sRetorno) = False)
      and (_ecf65_UsoDenegado(sRetorno) = False) // Sandro Silva 2020-05-14
    then
    begin

      // Procura na pasta dos xml autorizados
      sXmlAutorizado := _ecf65_LoadXmlDestinatario(xmlNodeValue(sRetorno, '//infProt/chNFe'));

      sXmlAutorizado := _ecf65_CorrigePadraoRespostaSefaz(sXmlAutorizado);

      if sXmlAutorizado = '' then
      begin
        // Não encontrou na pasta de xml autorizados
        // Procura na pasta log o xml do lote de envio

        sArquivoEnvio := Form1.spdNFCe1.DiretorioLog + '\' + SelecionaXmlEnvio(Form1.spdNFCe1.DiretorioLog + '\*' + xmlNodeValue(sRetorno, '//infProt/chNFe') + '-env-sinc-lot.xml', xmlNodeValue(sRetorno, '//protNFe/infProt/digVal'), '//DigestValue');

        if FileExists(PChar(sArquivoEnvio)) then
        begin
          slArquivoEnvio.LoadFromFile(sArquivoEnvio);
          sXmlEnvio := slArquivoEnvio.Text;
          if xmlNodeValue(sRetorno, '//protNFe/infProt/digVal') = xmlNodeValue(sXmlEnvio, '//DigestValue') then
          begin
            slArquivoEnvio.Clear;
            slArquivoEnvio.Text := ConcatencaNodeNFeComProtNFe(sXmlEnvio, sRetorno);
            slArquivoEnvio.SaveToFile(StringReplace(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + xmlNodeValue(sRetorno, '//infProt/chNFe') + '-nfce.xml', '\\', '\', [rfReplaceAll]));

            sXmlAutorizado := slArquivoEnvio.Text;

          end;
        end;

      end; // if sXmlAutorizado = '' then

      // Ter certeza que está com xml válido
      if (xmlNodeXml(sXmlAutorizado, '//NFe') <> '') and (xmlNodeXml(sXmlAutorizado, '//protNFe') <> '') then
      begin
        // xml assinado e autorizado

        if Pos('<tpAmb>2</tpAmb>', sXmlAutorizado) > 0  then
        begin
          sStatus := NFCE_STATUS_AUTORIZADO_USO_EM_HOMOLOGACAO;// 'Autorizado o uso da NFC-e em ambiente de homologação';
        end else
        begin
          sStatus := NFCE_STATUS_AUTORIZADO_USO_EM_PRODUCAO;// 'Autorizado o uso da NFC-e';
        end;

        // Sandro Silva 2021-11-17 Validar que xml pertence a nfce selecionada
        if (RightStr('000' + sNumeroNF, 9) = _ecf65_NumeroNfFromChave(xmlNodeValue(sXmlAutorizado, '//chNFe')))
          and (Form1.IBDataSet150.FieldByName('NUMERONF').AsString = sNumeroNF)
          and (Form1.IBDataSet150.FieldByName('CAIXA').AsString = sCaixaNF) then
        begin

          try

            Form1.IBDataSet150.Edit;
            Form1.IBDataSet150.FieldByName('NFEXML').AsString := sXmlAutorizado;
            Form1.IBDataSet150.FieldByName('STATUS').AsString := sStatus;
            if Trim(Form1.IBDataSet150.FieldByName('NFEID').AsString) = '' then
            begin
              Form1.IBDataSet150.FieldByName('NFEID').AsString := xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//chNFe');
            end;
            if Form1.IBDataSet150.FieldByName('TOTAL').AsFloat = 0.00 then
            begin
              Form1.IBDataSet150.FieldByName('TOTAL').AsFloat := xmlNodeValueToFloat(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//vNF');
            end;
            Form1.IBDataSet150.Post;

          except
          end;

          if xmlNodeXml(sXmlAutorizado, '//pag') <> '' then
            _ecf65_GravaPagamentFromXML(sXmlAutorizado, sNumeroNF, sCaixaNF);

        end;

        Commitatudo(True);  // TForm1.ConsultaChaveNFCe1Click()

        Form1.DateTimePicker1Change(Form1.DateTimePicker1);

        if (FormataNumeroDoCupom(Form1.icupom) = sNumeroNF) and (Form1.sCaixa = sCaixaNF) then // Sandro Silva 2021-11-29 if (StrZero(Form1.icupom, 6, 0) = sNumeroNF) and (Form1.sCaixa = sCaixaNF) then
        begin
          SmallMsg('Abra novamente a aplicação com as informações atualizadas.');

          FecharAplicacao(ExtractFileName(Application.ExeName));
        end;
      end;

    end; // xml autorizado

    if _ecf65_XmlNfceCancelado(sRetorno) then
    begin

      Form1.OcultaPanelMensagem;
      SmallMsgBox(PChar('A NFC-e ' + sNumeroNF + ' está cancelada na SEFAZ' + #13 + 'e será cancelada no SMALL'), 'Atenção', MB_OK + MB_ICONWARNING);

      // Sandro Silva 2021-11-17 Validar que xml pertence a nfce selecionada
      if (RightStr('000' + sNumeroNF, 9) = _ecf65_NumeroNfFromChave(xmlNodeValue(sRetorno, '//chNFe')))
        and (Form1.IBDataSet150.FieldByName('NUMERONF').AsString = sNumeroNF)
        and (Form1.IBDataSet150.FieldByName('CAIXA').AsString = sCaixaNF) then
      begin

        try
          Form1.IBDataSet150.Edit;
          Form1.IBDataSet150.FieldByName('NFEXML').AsString := sRetorno;
          Form1.IBDataSet150.FieldByName('STATUS').AsString := NFCE_STATUS_CANCELAMENTO; // Sandro Silva 2021-12-07 'Cancelamento Registrado e vinculado a NFCe';
          Form1.IBDataSet150.FieldByName('NFEIDSUBSTITUTO').Clear;
          Form1.IBDataSet150.Post;

          // Precisa selecionar novamente os dados. Post está influenciando e deixando Dataset com campos vazios (?)
          Form1.IBDataSet150.Close;
          Form1.IBDataSet150.SelectSQL.Text :=
            'select * ' +
            'from NFCE ' +
            'where NUMERONF = ' + QuotedStr(sNumeroNF) +
            ' and CAIXA = ' + QuotedStr(sCaixaNF);
          Form1.IBDataSet150.Open;

        except
        end;

        Form1.CancelaraNFCe1Click(Form1.CancelaraNFCe1);
      end;

      Commitatudo(True);  // TForm1.ConsultaChaveNFCe1Click()

      Form1.DateTimePicker1Change(Form1.DateTimePicker1);

      if (FormataNumeroDoCupom(Form1.icupom) = sNumeroNF) and (Form1.sCaixa = sCaixaNF) then // Sandro Silva 2021-11-29 if (StrZero(Form1.icupom, 6, 0) = sNumeroNF) and (Form1.sCaixa = sCaixaNF) then
      begin
        SmallMsg('Abra novamente a aplicação com as informações atualizadas.');

        FecharAplicacao(ExtractFileName(Application.ExeName));
      end;

    end;

       //Chave de Acesso difere da existente em BD    <cStat>613
    if (
          AnsiContainsText(sRetorno, '<cStat>613') // Rejeicao: Chave de Acesso difere da existente em BD
       or AnsiContainsText(sRetorno, '<cStat>562</cStat>') // Rejeição 562: Código Numérico informado na Chave de Acesso difere do Código Numérico da NF-e
        )
      and (_ecf65_XmlNfceCancelado(sRetorno) = False) then
    begin
      _ecf65_CorrigeRejeicaoChaveDeAcessoDifere(sNumeroNF, sCaixaNF);

      Form1.DateTimePicker1Change(Form1.DateTimePicker1);

      if (FormataNumeroDoCupom(Form1.icupom) = sNumeroNF) and (Form1.sCaixa = sCaixaNF) then // Sandro Silva 2021-11-29 if (StrZero(Form1.icupom, 6, 0) = sNumeroNF) and (Form1.sCaixa = sCaixaNF) then
      begin
        SmallMsg('Abra novamente a aplicação com as informações atualizadas.');

        FecharAplicacao(ExtractFileName(Application.ExeName));
      end;

    end;
    
  end;
  FreeAndNil(slArquivoEnvio);
  Sleep(2000);
  Form1.OcultaPanelMensagem;
end;

function _ecf65_VerificaContingenciaPendentedeTransmissao(
  dtDataIni: TDate; dtDataFim: TDate; sCaixa: String): Boolean;
var
  IBQCONTINGENCIA: TIBQuery;
  sWhereCaixa: String;
begin
  Result := False;

  if Form1.UsaIntegradorFiscal = False then // Sandro Silva 2019-10-16
  begin
    IBQCONTINGENCIA := CriaIBQuery(Form1.ibDataSet27.Transaction);
    try
      sWhereCaixa := '';
      if Trim(sCaixa) <> '' then
        sWhereCaixa := ' and CAIXA = ' + QuotedStr(sCaixa);

      IBQCONTINGENCIA.Close;
      // todas notas do dia, em contingência ou com cancelamento por substituição
      IBQCONTINGENCIA.SQL.Text :=
        'select first 1 * ' +
        'from NFCE ' +
        'where MODELO = ''65'' ' +
        sWhereCaixa +
        ' and DATA between :DATAINI and :DATAFIM ' +  // Sandro Silva 2022-04-12 ' and DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtDataIni)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtDataFim)) +
        ' and (((STATUS containing ''contingência'') or (NFEXML containing ''<tpEmis>9</tpEmis>'' and coalesce(STATUS, '''') not containing ''autorizad'')) ' + // em contingência
          ' or (coalesce(NFEIDSUBSTITUTO, '''') <> '''')) ' +                                                                                                 // para cancelar por substituição
        ' and (coalesce(STATUS, '''') not containing ''denegad'') ' + // Desconsiderar Uso Denegado Sandro Silva 2020-02-18
        ' order by NFEIDSUBSTITUTO, DATA, NUMERONF, CAIXA '; // Ordenar para que as NFC-E com ID de substituição fiquem por último
      IBQCONTINGENCIA.ParamByName('DATAINI').AsDate := dtDataIni;
      IBQCONTINGENCIA.ParamByName('DATAFIM').AsDate := dtDataFim;
      IBQCONTINGENCIA.Open;

      Form1.ContingenciaPendente.sdtPendente := '';
      if IBQCONTINGENCIA.FieldByName('REGISTRO').AsString <> '' then
      begin
        Result := True;
        Form1.ContingenciaPendente.sdtPendente := FormatDateTime('dd/mm/yyyy', IBQCONTINGENCIA.FieldByName('DATA').AsDateTime)
      end;
    except
    end;
    FreeAndNil(IBQCONTINGENCIA);
  end;
  Form1.ContingenciaPendente.bTransmissaoPendente := Result;
end;

function _ecf65_CorrigePadraoRespostaSefaz(sResposta: String): String;
// Sefaz de MG retorna aleatoriamente xml fora do padrão, com name space em node que não deveriam ter
begin

  sResposta := StringReplace(sResposta, '<protNFe xmlns="http://www.portalfiscal.inf.br/nfe"',   '<protNFe', [rfReplaceAll]);
  sResposta := StringReplace(sResposta, '<infProt xmlns="http://www.portalfiscal.inf.br/nfe"',   '<infProt', [rfReplaceAll]);
  sResposta := StringReplace(sResposta, '<tpAmb xmlns="http://www.portalfiscal.inf.br/nfe"',     '<tpAmb', [rfReplaceAll]);
  sResposta := StringReplace(sResposta, '<verAplic xmlns="http://www.portalfiscal.inf.br/nfe"',  '<verAplic', [rfReplaceAll]);
  sResposta := StringReplace(sResposta, '<cUF xmlns="http://www.portalfiscal.inf.br/nfe"',       '<cUF', [rfReplaceAll]);
  sResposta := StringReplace(sResposta, '<chNFe xmlns="http://www.portalfiscal.inf.br/nfe"',     '<chNFe', [rfReplaceAll]);
  sResposta := StringReplace(sResposta, '<dhRecbto xmlns="http://www.portalfiscal.inf.br/nfe"',  '<dhRecbto', [rfReplaceAll]);
  sResposta := StringReplace(sResposta, '<nProt xmlns="http://www.portalfiscal.inf.br/nfe"',     '<nProt', [rfReplaceAll]);
  sResposta := StringReplace(sResposta, '<digVal xmlns="http://www.portalfiscal.inf.br/nfe"',    '<digVal', [rfReplaceAll]);
  sResposta := StringReplace(sResposta, '<cStat xmlns="http://www.portalfiscal.inf.br/nfe"',     '<cStat', [rfReplaceAll]);
  sResposta := StringReplace(sResposta, '<xMotivo xmlns="http://www.portalfiscal.inf.br/nfe"',   '<xMotivo', [rfReplaceAll]);
  sResposta := StringReplace(sResposta, '<dhRetorno xmlns="http://www.portalfiscal.inf.br/nfe"', '<dhRetorno', [rfReplaceAll]);
  sResposta := StringReplace(sResposta, '<tMed xmlns="http://www.portalfiscal.inf.br/nfe"',      '<tMed', [rfReplaceAll]);
  sResposta := StringReplace(sResposta, '<tpEvento xmlns="http://www.portalfiscal.inf.br/nfe"',  '<tpEvento', [rfReplaceAll]);
  sResposta := StringReplace(sResposta, '<xEvento xmlns="http://www.portalfiscal.inf.br/nfe"',   '<xEvento', [rfReplaceAll]);
  sResposta := StringReplace(sResposta, '<descEvento xmlns="http://www.portalfiscal.inf.br/nfe"','<descEvento', [rfReplaceAll]);
  sResposta := StringReplace(sResposta, '<tpEmis xmlns="http://www.portalfiscal.inf.br/nfe"',    '<tpEmis', [rfReplaceAll]);
  Result := sResposta;
end;

procedure _ecf65_CorrigeXmlNoBanco;
// Algumas Sefaz retornaram xml fora do padrão, causando problemas no processamento da resposta
// Alguns retornos não foram tratados e vendas ficaram sem os xml autorizado
// Outros xml foram gravado com estrutura errada
// Processa as notas dos últimos 15 dias
const CondicaoCabecalhoXml = 'and not (nfexml starting ''<?xml version="1.0" encoding="UTF-8"?>'' or nfexml starting ''<?xml version="1.0"?>'')'; // assim para não ficar lento nos clientes de MG
//const CondicaoPeriodo = ' and DATA between current_date - 15 and current_date ';
function CondicaoPeriodo(DataFinal: TDate): String;
begin
  Result := ' and DATA between '  + QuotedStr(FormatDateTime('yyyy-mm-dd', DataFinal - 15)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', DataFinal));
end;
var
  sArquivoEnvio: String;
  sXml: WideString;
  IBTSALVA: TIBTransaction;
  IBQCONSULTA: TIBQuery;
  IBQSALVA: TIBQuery;
  sRetorno: String;
  sNFEid: String;
  slArquivoEnvio: TStringList;
  sXmlAutorizado: String;
  sXmlEnvio: String;
  sStatus: String;
  sNumeroNF: String;
  sCaixaNF: String;
  slListaXml: TStringList;
  iArquivoEnvio: Integer;
  sUFEmitente: String;
  ArquivoXml: TArquivo; // Sandro Silva 2020-06-16
  dtUltimaNFCeEmitida: TDate; // Sandro Silva 2023-03-22
begin

  // Fez o processamento e a data do processamento é igual da data atual, não faz o processamento
  // Para fazer uma vez por dia
//  if (LerParametroIni(Form1.sAtual + '\NFE.INI', 'NFCE', 'Analise NFCe', '') <> '') and (StrToDate(LerParametroIni(Form1.sAtual + '\NFE.INI', 'NFCE', 'Analise NFCe', FormatDateTime('dd/mm/yyyy', Date))) = Date) then
  if (StrToDate(LerParametroIni(Form1.sAtual + '\NFE.INI', 'NFCE', 'Analise NFCe', FormatDateTime('dd/mm/yyyy', Date -1))) = Date) then
    Exit;

  LogFrente('Iniciando CorrigeXmlNoBanco'); // Sandro Silva 2023-03-21

  slArquivoEnvio := TStringList.Create;
  slListaXml     := TStringList.Create;

  IBTSALVA := CriaIBTransaction(Form1.IBDatabase1);

  IBQCONSULTA := CriaIBQuery(IBTSALVA);
  IBQSALVA := CriaIBQuery(IBTSALVA);

  IBQCONSULTA.Close;
  IBQCONSULTA.SQL.Text := 'select ESTADO from EMITENTE';
  IBQCONSULTA.Open;

  {Sandro Silva 2020-02-13 inicio}
  sUFEmitente := AnsiUpperCase(IBQCONSULTA.FieldByName('ESTADO').AsString);

  IBQCONSULTA.Close;
  IBQCONSULTA.SQL.Text := 'select max(DATA) as ULTIMANFCE from NFCE';
  IBQCONSULTA.Open;

  dtUltimaNFCeEmitida := Date;
  if IBQCONSULTA.FieldByName('ULTIMANFCE').AsString <> '' then
    dtUltimaNFCeEmitida := IBQCONSULTA.FieldByName('ULTIMANFCE').AsDateTime;


  // Corrigir problema causado pelos retornos fora do padrão do servidor NFC-e
  //NFC-e autorizadas sem ID
  IBQCONSULTA.Close;
  IBQCONSULTA.SQL.Text :=
    'select * ' +
    'from NFCE ' +
    'where MODELO = ''65'' ' +
    CondicaoPeriodo(dtUltimaNFCeEmitida) +
    ' and (((((coalesce(STATUS, '''') containing ''Autorizado o uso da NFC-e'' and coalesce(NFEID, '''') <> '''') or (coalesce(NFEXML, '''') containing ''<cStat>100</cStat>'') ) ' +  // autorizado sem ID // Sandro Silva 2020-06-05 'where (STATUS containing ''Autorizado o uso da NFC-e'' and coalesce(NFEID, '''') <> '''' ' +  // autorizado sem ID
    ' and (coalesce(NFEXML, '''') starting :NFEXML1 or coalesce(NFEXML, '''') starting :NFEXML2))) ' +
    ' or (coalesce(STATUS, '''') containing ''Autorizado o uso da NFC-e'' and coalesce(NFEID, '''') <> '''' ' + CondicaoCabecalhoXml +
    //' and (coalesce(NFEXML, '''') containing ''<?xml version="1.0" encoding="UTF-8"?>'' or coalesce(NFEXML, '''') containing ''<?xml version="1.0"'') ' + // Sandro Silva 2021-06-09
    ') ' + // Autorizada sem atualizar o nfce.nfexml com xml autorizado
    ')';
  IBQCONSULTA.ParamByName('NFEXML1').AsString := '<?xml version="1.0" encoding="UTF-8"?><nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00"><?xml version="1.0" encoding="UTF-8"?><nfeProc versao="4.00" xmlns="http://www.portalfiscal.inf.br/nfe"><NFe';
  IBQCONSULTA.ParamByName('NFEXML2').AsString := '<?xml version="1.0" encoding="UTF-8"?><nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00"><?xml version="1.0" encoding="UTF-8"?><nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00"><NFe';
  IBQCONSULTA.Open;

  LogFrente('Executou query ' + IBQCONSULTA.SQL.Text); // Sandro Silva 2023-03-21

  if (IBQCONSULTA.IsEmpty = False) then // Sandro Silva 2023-03-21   if (IBQCONSULTA.IsEmpty = False) or (sUFEmitente = 'MG') then
  begin
    if (IBQCONSULTA.IsEmpty = False) then
    begin

  {Sandro Silva 2020-02-17 fim}
      while IBQCONSULTA.Eof = False do
      begin
        if Trim(IBQCONSULTA.FieldByName('NFEXML').AsString) <> '' then
        begin

          sXml := IBQCONSULTA.FieldByName('NFEXML').AsString;

          if AnsiContainsText(sXml, '<?xml version="1.0" encoding="UTF-8"?><nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00"><?xml version="1.0" encoding="UTF-8"?><nfeProc versao="4.00" xmlns="http://www.portalfiscal.inf.br/nfe"><NFe') then
          begin
            sXml := StringReplace(sXml, '<?xml version="1.0" encoding="UTF-8"?><nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00"><?xml version="1.0" encoding="UTF-8"?><nfeProc versao="4.00" xmlns="http://www.portalfiscal.inf.br/nfe"><NFe', '<?xml version="1.0" encoding="UTF-8"?><nfeProc versao="4.00" xmlns="http://www.portalfiscal.inf.br/nfe"><NFe', [rfIgnoreCase]);
          end;
          {Sandro Silva 2020-06-05 inicio}
          if AnsiContainsText(sXml, '<?xml version="1.0" encoding="UTF-8"?><nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00"><?xml version="1.0" encoding="UTF-8"?><nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00"><NFe') then
          begin
            sXml := StringReplace(sXml, '<?xml version="1.0" encoding="UTF-8"?><nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00"><?xml version="1.0" encoding="UTF-8"?><nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00"><NFe', '<?xml version="1.0" encoding="UTF-8"?><nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00"><NFe', [rfIgnoreCase]);
          end;
          {Sandro Silva 2020-06-05 fim}

          if Pos('</nfeProc', AnsiLowerCase(sXml)) <> Pos('</nfeProc', AnsiLowerCase(IBQCONSULTA.FieldByName('NFEXML').AsString)) then // Usando comparação direta (sXml <> IBQCONSULTA.FieldByName('NFEXML').AsString) sempre retorna verdadeiro, mesmo variável sendo igual o FieldByName(). Estranho!?
          begin
            sXML := Copy(sXml, 1, Pos('</nfeProc>', String(sXml)) + 10);// Extrai somente o grupo nfeProc
            if Pos('<?xml', String(sXml)) > 0 then // Sandro Silva 2021-06-10
              sXML := Copy(sXml, Pos('<?xml', String(sXml)), Length(sXml)); // Extrai o conteúdo do xml a partir do cabeço <?xml....
          end;

          // Sandro Silva 2021-06-10 if sXML <> IBQCONSULTA.FieldByName('NFEXML').AsString then
          if Pos('</nfeProc', AnsiLowerCase(sXml)) <> Pos('</nfeProc', AnsiLowerCase(IBQCONSULTA.FieldByName('NFEXML').AsString)) then // Usando comparação direta (sXml <> IBQCONSULTA.FieldByName('NFEXML').AsString) sempre retorna verdadeiro, mesmo variável sendo igual o FieldByName(). Estranho!?
          begin

            if xmlNodeValue(sXml, '//protNFe/infProt/chNFe') <> '' then // Sandro Silva 2020-06-05
            begin
              try
                Form1.IBDataSet150.Close;
                Form1.IBDataSet150.SelectSQL.Text :=
                  'select * ' +
                  'from NFCE ' +
                  // Sandro Silva 2021-11-17 'where REGISTRO = ' + QuotedStr(IBQCONSULTA.FieldByName('REGISTRO').AsString);
                  'where MODELO = ''65'' ' +
                  ' and NUMERONF = ' + QuotedStr(IBQCONSULTA.FieldByName('NUMERONF').AsString) +
                  ' and CAIXA = ' + QuotedStr(IBQCONSULTA.FieldByName('CAIXA').AsString);
                Form1.IBDataSet150.Open;

                // Sandro Silva 2021-11-17 Validar que xml pertence a nfce selecionada
                if RightStr('000' + Form1.IBDataSet150.FieldByName('NUMERONF').AsString, 9) = _ecf65_NumeroNfFromChave(xmlNodeValue(sXml, '//protNFe/infProt/chNFe')) then
                begin

                  Form1.IBDataSet150.Edit;
                  Form1.IBDataSet150.FieldByName('STATUS').AsString := 'Autorizado o uso da NFC-e';
                  Form1.IBDataSet150.FieldByName('NFEXML').AsString := sXml;
                  Form1.IBDataSet150.FieldByName('NFEID').AsString  := xmlNodeValue(sXml, '//protNFe/infProt/chNFe');
                  Form1.IBDataSet150.Post;

                  if xmlNodeXml(sXml, '//pag') <> '' then
                    _ecf65_GravaPagamentFromXML(sXml, IBQCONSULTA.FieldByName('NUMERONF').AsString, IBQCONSULTA.FieldByName('CAIXA').AsString); // Sandro Silva 2021-11-17 _ecf65_GravaPagamentFromXML(sXmlAutorizado, sNumeroNF, sCaixaNF);

                end;

                Commitatudo(True);  // TForm1.ConsultaChaveNFCe1Click()

                ArquivoXml := TArquivo.Create;
                ArquivoXml.Texto := sXml;
                ArquivoXml.SalvarArquivo(Form1.sAtual + '\XmlDestinatario\NFCE\' + xmlNodeValue(sXml, '//protNFe/infProt/chNFe') + '-nfce.xml');
                FreeAndNil(ArquivoXml);

                LogFrente('Atualizou ' + xmlNodeValue(sXml, '//protNFe/infProt/chNFe'));// Sandro Silva 2023-03-21

              except

              end;
            end; // if xmlNodeValue(sXml, '//protNFe/infProt/chNFe') <> '' then // Sandro Silva 2020-06-05
          end; // if sXML <> IBQCONSULTA.FieldByName('NFEXML').AsString then
        end; // if Trim(IBQCONSULTA.FieldByName('NFEXML').AsString) <> '' then

        IBQCONSULTA.Next;
      end; // while IBQCONSULTA.Eof = False do

    end; //   if (IBQCONSULTA.IsEmpty = False) or (sUFEmitente = 'MG') then
    {Sandro Silva 2020-02-13 fim}

    if (sUFEmitente = 'GO') or (sUFEmitente = 'MG') then // Sandro Silva 2020-06-05 if sUFEmitente = 'MG' then
    begin

      // Corrigir problema causado pelos retornos fora do padrão do servidor NFC-e
      //NFC-e autorizadas sem ID
      IBQCONSULTA.Close;
      IBQCONSULTA.SQL.Text :=
        'select * ' +
        'from NFCE ' +
        'where MODELO = ''65'' ' +
        CondicaoPeriodo(dtUltimaNFCeEmitida) +
        ' and ((coalesce(STATUS, '''') containing ''Autorizado o uso da NFC-e'' and coalesce(NFEID, '''') = '''') ' +  // autorizado sem ID
        ' or (coalesce(STATUS, '''') containing ''Autorizado o uso da NFC-e'' and coalesce(NFEID, '''') <> '''' ' + CondicaoCabecalhoXml + ') ' +
        ' or (coalesce(STATUS, '''') containing ''Autorizado o uso da NFC-e'' and coalesce(NFEID, '''') <> '''' and (coalesce(NFEXML, '''') starting ''<nfeProc'' and coalesce(NFEXML, '''') containing ''<?xml version='')) ' +  // autoriza com id e com xml mal formado
        ')';
      IBQCONSULTA.Open;

      LogFrente('Executou query ' + IBQCONSULTA.SQL.Text);// Sandro Silva 2023-03-21

      while IBQCONSULTA.Eof = False do
      begin

        if Trim(IBQCONSULTA.FieldByName('NFEXML').AsString) <> '' then
        begin

          sXml := IBQCONSULTA.FieldByName('NFEXML').AsString;

          if AnsiContainsText(sXml, '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00"><?xml version="1.0" encoding="UTF-8"?>') then
          begin
            sXml := StringReplace(sXml, '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00"><?xml version="1.0" encoding="UTF-8"?>', '<?xml version="1.0" encoding="UTF-8"?>', [rfIgnoreCase]);
          // Sandro Silva 2021-06-09 end;

            sXML := Copy(sXml, 1, Pos('</nfeProc>', String(sXml)) + 10);// Extrai somente o grupo nfeProc
            sXML := Copy(sXml, Pos('<?xml', String(sXml)), Length(sXml)); // Extrai o conteúdo do xml a partir do cabeço <?xml....

            if sXML <> IBQCONSULTA.FieldByName('NFEXML').AsString then
            begin

              if xmlNodeValue(sXml, '//protNFe/infProt/chNFe') <> '' then // Sandro Silva 2020-06-05
              begin

                try

                  Form1.IBDataSet150.Close;
                  Form1.IBDataSet150.SelectSQL.Text :=
                    'select * ' +
                    'from NFCE ' +
                    // Sandro Silva 2021-11-17 'where REGISTRO = ' + QuotedStr(IBQCONSULTA.FieldByName('REGISTRO').AsString);
                    'where MODELO = ''65'' ' +
                    ' and NUMERONF = ' + QuotedStr(IBQCONSULTA.FieldByName('NUMERONF').AsString) +
                    ' and CAIXA = ' + QuotedStr(IBQCONSULTA.FieldByName('CAIXA').AsString);
                  Form1.IBDataSet150.Open;

                  // Sandro Silva 2021-11-17 Validar que xml pertence a nfce selecionada
                  if RightStr('000' + Form1.IBDataSet150.FieldByName('NUMERONF').AsString, 9) = _ecf65_NumeroNfFromChave(xmlNodeValue(sXml, '//chNFe')) then
                  begin

                    Form1.IBDataSet150.Edit;
                    Form1.IBDataSet150.FieldByName('NFEXML').AsString := sXml;
                    Form1.IBDataSet150.FieldByName('NFEID').AsString  := xmlNodeValue(sXml, '//protNFe/infProt/chNFe');
                    Form1.IBDataSet150.Post;

                    {Sandro Silva 2022-06-02 inicio}
                    Audita('RECUPERA1','FRENTE', '', 'Recuperou XML NFC-e: ' + xmlNodeValue(sXml, '//protNFe/infProt/chNFe'), 0, 0); // Ato, Modulo, Usuário, Histórico, Valor
                    {Sandro Silva 2022-06-02 fim}

                    LogFrente('Recupera1 NFC-e ' + xmlNodeValue(sXml, '//protNFe/infProt/chNFe'));// Sandro Silva 2023-03-21

                  end;

                except

                end;

              end; // if xmlNodeValue(sXml, '//protNFe/infProt/chNFe') <> '' then // Sandro Silva 2020-06-05

            end; // if sXML <> IBQCONSULTA.FieldByName('NFEXML').AsString then

          end;
        end; // if Trim(IBQCONSULTA.FieldByName('NFEXML').AsString) <> '' then
        IBQCONSULTA.Next;
      end; // while IBQCONSULTA.Eof = False do

      //NFC-e com xml sem cabeçalho padrão <?xml version="1.0" encoding="UTF-8"?>
      IBQCONSULTA.Close;
      IBQCONSULTA.SQL.Text :=
        'select * ' +
        'from NFCE ' +
        'where MODELO = ''65'' ' +
        CondicaoPeriodo(dtUltimaNFCeEmitida) +
        ' and coalesce(STATUS, '''') containing ''Autorizado o uso da NFC-e'' and coalesce(NFEID, '''') <> '''' ' +
        ' and (coalesce(NFEXML, '''') starting ''<nfeProc'' and coalesce(NFEXML, '''') not containing ''<?xml version='')';
      IBQCONSULTA.Open;

      LogFrente('Executou query ' + IBQCONSULTA.SQL.Text); // Sandro Silva 2023-03-21

      while IBQCONSULTA.Eof = False do
      begin
        if Trim(IBQCONSULTA.FieldByName('NFEXML').AsString) <> '' then
        begin
          sXml := IBQCONSULTA.FieldByName('NFEXML').AsString;
          if AnsiContainsText(sXml, '<?xml version="1.0" encoding="UTF-8"?>') = False then
          begin
            sXml := '<?xml version="1.0" encoding="UTF-8"?>' + sXml;
            try

              Form1.IBDataSet150.Close;
              Form1.IBDataSet150.SelectSQL.Text :=
                'select * ' +
                'from NFCE ' +
                // Sandro Silva 2021-11-17 'where REGISTRO = ' + QuotedStr(IBQCONSULTA.FieldByName('REGISTRO').AsString);
                'where MODELO = ''65'' ' +
                ' and NUMERONF = ' + QuotedStr(IBQCONSULTA.FieldByName('NUMERONF').AsString) +
                ' and CAIXA = ' + QuotedStr(IBQCONSULTA.FieldByName('CAIXA').AsString);
              Form1.IBDataSet150.Open;

              Form1.IBDataSet150.Edit;
              Form1.IBDataSet150.FieldByName('NFEXML').AsString := sXml;
              Form1.IBDataSet150.Post;

              {Sandro Silva 2022-06-02 inicio}
              Audita('RECUPERA2','FRENTE', '', 'Corrigiu cabeçalho XML: ' + xmlNodeValue(sXml, '//protNFe/infProt/chNFe'), 0, 0); // Ato, Modulo, Usuário, Histórico, Valor
              {Sandro Silva 2022-06-02 fim}

              LogFrente('Recupera2 NFC-e ' + xmlNodeValue(sXml, '//protNFe/infProt/chNFe'));

            except

            end;
          end;
        end;

        IBQCONSULTA.Next;
      end; // while IBQCONSULTA.Eof = False do

      //NFC-e sem xml e id
      IBQCONSULTA.Close;
      IBQCONSULTA.SQL.Text :=
        'select * ' +
        'from NFCE ' +
        'where MODELO = ''65'' ' +
        CondicaoPeriodo(dtUltimaNFCeEmitida) +
        ' and ((coalesce(STATUS, '''') = '''' and coalesce(NFEID, '''') = '''' and coalesce(NFEXML, '''') = '''') ' +
        ' or (coalesce(STATUS, '''') containing ''Autorizado o uso da NFC-e'' and coalesce(NFEID, '''') <> '''' ' + CondicaoCabecalhoXml + ') ' + // Autorizada sem atualizar o nfce.nfexml com xml autorizado // Sandro Silva 2020-06-05
        ' or (coalesce(STATUS, '''') = ''Autorizado o uso da NFC-e'' and coalesce(NFEID, '''') = '''' and coalesce(NFEXML, '''') containing ''9</tpEmis>'')' +  // Contingência com status errado
        ')';
      IBQCONSULTA.Open;

      LogFrente('Executou sql ' + IBQCONSULTA.SQL.Text); // Sandro Silva 2023-03-21

      while IBQCONSULTA.Eof = False do
      begin
        try
          sNumeroNF := IBQCONSULTA.FieldByName('NUMERONF').AsString;
          sCaixaNF  := IBQCONSULTA.FieldByName('CAIXA').AsString;
          sXmlAutorizado := '';

          if (Trim(IBQCONSULTA.FieldByName('NFEXML').AsString) = '') or ((Trim(IBQCONSULTA.FieldByName('NFEXML').AsString) <> '') and (Trim(IBQCONSULTA.FieldByName('STATUS').AsString) = 'Autorizado o uso da NFC-e') and (Trim(IBQCONSULTA.FieldByName('NFEID').AsString) = ''))  // Sandro Silva 2019-10-05 if Trim(IBQCONSULTA.FieldByName('NFEXML').AsString) = '' then
            or ((Trim(IBQCONSULTA.FieldByName('NFEXML').AsString) <> '') and (Trim(IBQCONSULTA.FieldByName('STATUS').AsString) = 'Autorizado o uso da NFC-e') and (Trim(IBQCONSULTA.FieldByName('NFEID').AsString) <> '')) // Sandro Silva 2020-06-05
          then
          begin
            // Procura o xml autorizado na pasta xmldestinatario                                                                                                                                           //MODELO+CAIXA
            sArquivoEnvio := StringReplace(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + SelecionaXmlEnvio(Form1.spdNFCe1.DiretorioXmlDestinatario + '\*' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString) + '65001' + RightStr('000000000' + IBQCONSULTA.FieldByName('NUMERONF').AsString, 9) + '*-nfce.xml', '', ''), '\\', '\', [rfReplaceAll]);

            slListaXml.Clear;

            if FileExists(PChar(sArquivoEnvio)) = False then // Se não encontrar o xml autorizado
            begin

              //Seleciona todos os xml                                                                                                          //MODELO+SERIE
              // Sandro Silva 2021-11-17 _ecf65_ListaArquivos(StringReplace(Form1.spdNFCe1.DiretorioLog + '\*' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString) + '65001' + RightStr('000000000' + IBQCONSULTA.FieldByName('NUMERONF').AsString, 9) + '*-env-sinc-lot.xml', '\\', '\', [rfReplaceAll]));
              _ecf65_ListaArquivos(StringReplace(Form1.spdNFCe1.DiretorioLog + '\*' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString) + '65' + RightStr('00' + _ecf65_SerieAtual(IBQCONSULTA.Transaction), 3) + RightStr('000000000' + IBQCONSULTA.FieldByName('NUMERONF').AsString, 9) + '*-env-sinc-lot.xml', '\\', '\', [rfReplaceAll]));

              if FileExists(PChar(Form1.sAtual + '\arq_.txt')) then
              begin
                slListaXml.LoadFromFile(Form1.sAtual + '\arq_.txt');

                sRetorno := ''; // Começa vazio Sandro Silva 2020-06-05

                LogFrente('Localizou ' + IntToStr(slListaXml.Count) + ' xml da nota ' + sNumeroNF);// Sandro Silva 2023-03-21

                for iArquivoEnvio := 0 to slListaXml.Count - 1 do
                begin
                  // Procura o xml do lote de envio
                  sArquivoEnvio := slListaXml.Strings[iArquivoEnvio];

                  if FileExists(PChar(sArquivoEnvio)) then // se achou o lote de envio
                  begin

                    slArquivoEnvio.Clear;
                    slArquivoEnvio.LoadFromFile(sArquivoEnvio);

                    sNfeId := LimpaNumero(xmlNodeValue(slArquivoEnvio.Text, '//infNFe/@Id'));

                    // segurança valida se o cnpj do emitente do small está no id do xml lido (31190911318928000135650010000051079074265980)
                    if Copy(sNFEid, 7, 14) = LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString) then // Sandro Silva 2020-06-05 if Copy(sNFEid, 6, 14) = LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString) then
                    begin

                      if (xmlNodeValue(sRetorno, '//infProt/chNFe') <> LimpaNumero(sNFEid)) then // Sandro Silva 2020-06-05
                      begin // Valida se já tem retorno com resultado da consulta
                        // Consulta o ID do lote de envio
                        try
                          sRetorno := Form1.spdNFCe1.ConsultarNF(sNfeId);
                        except
                          on E: exception do
                          begin
                            sRetorno := '';
                            Break;
                          end;
                        end;
                      end;

                      {Sandro Silva 2019-09-30 inicio}
                      sRetorno := _ecf65_CorrigePadraoRespostaSefaz(sRetorno);
                      {Sandro Silva 2019-09-30 fim}

                      // Sandro Silva 2022-04-12 if ((Pos('<cStat>100</cStat>', sRetorno) <> 0) or (Pos('<cStat>150</cStat>', sRetorno) <> 0)) // 100|Autorizado o uso da NF-e ou 150|Autorizado o uso da NF-e, autorização fora de prazo // Sandro Silva 2018-08-10
                      if (_ecf65_xmlAutorizado(sRetorno))
                        and (_ecf65_XmlNfceCancelado(sRetorno) = False) then
                      begin

                        slArquivoEnvio.LoadFromFile(sArquivoEnvio);
                        sXmlEnvio := slArquivoEnvio.Text;
                        if xmlNodeValue(sRetorno, '//protNFe/infProt/digVal') = xmlNodeValue(sXmlEnvio, '//DigestValue') then
                        begin
                          slArquivoEnvio.Clear;
                          slArquivoEnvio.Text := ConcatencaNodeNFeComProtNFe(sXmlEnvio, sRetorno);
                          slArquivoEnvio.SaveToFile(StringReplace(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + xmlNodeValue(sRetorno, '//infProt/chNFe') + '-nfce.xml', '\\', '\', [rfReplaceAll]));

                          sXmlAutorizado := slArquivoEnvio.Text;
                          Break;
                        end;
                      end;

                      // Valida se o retorno foi de Não consta na base da sefaz
                      if ((Trim(sRetorno) = '') or AnsiContainsText(ConverteAcentosXML(sRetorno), ConverteAcentosXML('não consta na base de dados da SEFAZ'))) // Sem retorno ou não encontrado na sefaz
                        and (Copy(sNfeId, 35, 1) = TPEMIS_NFCE_CONTINGENCIA_OFFLINE) // tpEmis da Chave = 9 - contingencia offline
                      then
                      begin
                        Break;
                      end;
                    end; // ID pertence ao emitente do small
                  end;
                end; // for na lista de arquivo para consultar na sefaz
              end; // Exite arquivo com lista para consultar na sefaz
            end
            else
            begin
              slArquivoEnvio.LoadFromFile(sArquivoEnvio);
              sXmlEnvio := slArquivoEnvio.Text;
              sXmlAutorizado := slArquivoEnvio.Text;
            end;

            if Pos(#$C'Àþ'#9, sXmlAutorizado) > 0 then
              sXmlAutorizado := StringReplace(sXmlAutorizado, #$C'Àþ'#9, '<?xm',[rfReplaceAll]);


            // Ter certeza que está com xml válido  e o digest do xml enviado é igual ao digest da autorização
            if (xmlNodeXml(sXmlAutorizado, '//NFe') <> '') and (xmlNodeXml(sXmlAutorizado, '//protNFe') <> '') and (xmlNodeValue(sXmlAutorizado, '//DigestValue') = xmlNodeValue(sXmlAutorizado, '//digVal')) then
            begin
              // xml assinado e autorizado

              if Pos('<tpAmb>2</tpAmb>', sXmlAutorizado) > 0  then
              begin
                sStatus := NFCE_STATUS_AUTORIZADO_USO_EM_HOMOLOGACAO;// 'Autorizado o uso da NFC-e em ambiente de homologação';
              end else
              begin
                sStatus := NFCE_STATUS_AUTORIZADO_USO_EM_PRODUCAO;// 'Autorizado o uso da NFC-e';
              end;

              try

                Form1.IBDataSet150.Close;
                Form1.IBDataSet150.SelectSQL.Text :=
                  'select * ' +
                  'from NFCE ' +
                  // Sandro Silva 2021-11-17 'where REGISTRO = ' + QuotedStr(IBQCONSULTA.FieldByName('REGISTRO').AsString);
                  'where MODELO = ''65'' ' +
                  ' and NUMERONF = ' + QuotedStr(sNumeroNF) +
                  ' and CAIXA = ' + QuotedStr(sCaixaNF);
                Form1.IBDataSet150.Open;

                // Sandro Silva 2021-11-17 Validar que xml pertence a nfce selecionada
                if RightStr('000' + Form1.IBDataSet150.FieldByName('NUMERONF').AsString, 9) = _ecf65_NumeroNfFromChave(xmlNodeValue(sXmlAutorizado, '//protNFe/infProt/chNFe')) then
                begin

                  Form1.IBDataSet150.Edit;
                  Form1.IBDataSet150.FieldByName('NFEXML').AsString := sXmlAutorizado;
                  Form1.IBDataSet150.FieldByName('NFEID').AsString  := LimpaNumero(xmlNodeValue(sXmlAutorizado, '//protNFe/infProt/chNFe'));
                  // Sandro Silva 2023-03-17 Form1.IBDataSet150.FieldByName('TOTAL').AsFloat   := xmlNodeValueToFloat(IBQSALVA.ParamByName('NFEXML').AsString, '//vNF'); // Sandro Silva 2019-12-04
                  Form1.IBDataSet150.FieldByName('TOTAL').AsFloat   := xmlNodeValueToFloat(sXmlAutorizado, '//vNF'); // Sandro Silva 2019-12-04
                  Form1.IBDataSet150.FieldByName('STATUS').AsString := sStatus;
                  Form1.IBDataSet150.Post;

                  if xmlNodeXml(sXmlAutorizado, '//pag') <> '' then
                    _ecf65_GravaPagamentFromXML(sXmlAutorizado, sNumeroNF, sCaixaNF);

                  {Sandro Silva 2022-06-02 inicio}
                  Audita('RECUPERA3','FRENTE', '', 'Recuperou XML NFC-e: ' + xmlNodeValue(sXmlAutorizado, '//protNFe/infProt/chNFe'), 0, 0); // Ato, Modulo, Usuário, Histórico, Valor
                  {Sandro Silva 2022-06-02 fim}

                  LogFrente('Recuper3 NFC-e ' + xmlNodeValue(sXmlAutorizado, '//protNFe/infProt/chNFe')); // Sandro Silva 2023-03-21

                end;
              except

              end;

              Commitatudo(True);  // TForm1.ConsultaChaveNFCe1Click()

            end
            else
            begin // Não autorizado
              if slListaXml.Count > 0 then
              begin
                slArquivoEnvio.LoadFromFile(slListaXml.Strings[0]);

                sNfeId := LimpaNumero(xmlNodeValue(slArquivoEnvio.Text, '//infNFe/@Id'));

                // segurança valida se o cnpj do emitente do small está no id do xml lido (31190911318928000135650010000051079074265980)
                if Copy(sNFEid, 6, 14) = LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString) then
                begin
                  if ((Trim(sRetorno) = '') or AnsiContainsText(ConverteAcentosXML(sRetorno), ConverteAcentosXML('não consta na base de dados da SEFAZ'))) // Sem retorno ou não encontrado na sefaz
                    and (Copy(LimpaNumero(xmlNodeValue(slArquivoEnvio.Text, '//infNFe/@Id')), 35, 1) = TPEMIS_NFCE_CONTINGENCIA_OFFLINE) // tpEmis da Chave = 9 - contingencia
                  then
                  begin
                    sXmlEnvio := xmlNodeXml(slArquivoEnvio.Text, '//NFe');//   node -//NFe
                    //salva o xml de contingencia para transmitir

                    sStatus := NFCE_EMITIDA_EM_CONTINGENCIA;

                    try
                      Form1.IBDataSet150.Close;
                      Form1.IBDataSet150.SelectSQL.Text :=
                        'select * ' +
                        'from NFCE ' +
                        // Sandro Silva 2021-11-17 'where REGISTRO = ' + QuotedStr(IBQCONSULTA.FieldByName('REGISTRO').AsString);
                        'where MODELO = ''65'' ' +
                        ' and NUMERONF = ' + QuotedStr(sNumeroNF) +
                        ' and CAIXA = ' + QuotedStr(sCaixaNF);
                      Form1.IBDataSet150.Open;

                      // Sandro Silva 2021-11-17 Validar que xml pertence a nfce selecionada
                      if RightStr('000' + Form1.IBDataSet150.FieldByName('NUMERONF').AsString, 9) = _ecf65_NumeroNfFromChave(xmlNodeValue(sXmlEnvio, '//infNFe/@Id')) then
                      begin

                        Form1.IBDataSet150.Edit;
                        Form1.IBDataSet150.FieldByName('NFEXML').AsString := sXmlEnvio;
                        Form1.IBDataSet150.FieldByName('STATUS').AsString := sStatus;
                        Form1.IBDataSet150.FieldByName('TOTAL').AsFloat   := xmlNodeValueToFloat(IBQSALVA.ParamByName('NFEXML').AsString, '//vNF'); // Sandro Silva 2019-12-04
                        Form1.IBDataSet150.Post;

                        if xmlNodeXml(sXmlEnvio, '//pag') <> '' then
                          _ecf65_GravaPagamentFromXML(sXmlEnvio, sNumeroNF, sCaixaNF);

                        {Sandro Silva 2022-06-02 inicio}
                        Audita('RECUPERA4','FRENTE', '', 'Recuperou XML NFC-e: ' + xmlNodeValue(sXmlEnvio, '//protNFe/infProt/chNFe'), 0, 0); // Ato, Modulo, Usuário, Histórico, Valor
                        {Sandro Silva 2022-06-02 fim}

                        LogFrente('Recupera4 NFC-e ' + xmlNodeValue(sXmlEnvio, '//protNFe/infProt/chNFe'));
                      end;

                    except

                    end;

                    Commitatudo(True);  // TForm1.ConsultaChaveNFCe1Click()

                  end;

                end;// if do cnpj do emitente do small está no id do xml lido

              end;// Tem arquivo de lote transmitido

            end;// xml autorizado

          end; // if (Trim(IBQCONSULTA.FieldByName('NFEXML').AsString) = '') or ((Trim(IBQCONSULTA.FieldByName('NFEXML').AsString) <> '') and (Trim(IBQCONSULTA.FieldByName('STATUS').AsString) = 'Autorizado o uso da NFC-e') and (Trim(IBQCONSULTA.FieldByName('NFEID').AsString) = '')) then // Sandro Silva 2019-10-05 if Trim(IBQCONSULTA.FieldByName('NFEXML').AsString) = '' then

        except

        end;
        IBQCONSULTA.Next;
      end; // while IBQCONSULTA.Eof = False do
    end; // if sUFEmitente = 'MG' then

    try
      IBQSALVA.Transaction.Commit;
    except
      IBQSALVA.Transaction.Rollback;
    end;
    Commitatudo(True);  // TForm1.ConsultaChaveNFCe1Click()

  end; // if (sUFEmitente = 'BA') or (sUFEmitente = 'MG') then

  DeleteFile(PChar(Form1.sAtual + '\arq_.tmp'));
  DeleteFile(PChar(Form1.sAtual + '\arq_.txt'));

  FreeAndNil(IBQCONSULTA);
  FreeAndNil(IBQSALVA);
  FreeAndNil(IBTSALVA);
  FreeAndNil(slArquivoEnvio);
  FreeAndNil(slListaXml);

  LogFrente('Finalizando CorrigeXmlNoBanco'); // Sandro Silva 2023-03-21

  GravarParametroIni(Form1.sAtual + '\NFE.INI', 'NFCE', 'Analise NFCe', FormatDateTime('dd/mm/yyyy', Date));  
end;

procedure _ecf65_CorrigeRejeicaoChaveDeAcessoDifere(sNumeroNF: String;
  sCaixaNF: String; bCommitarTudoNoFinal: Boolean = True);
// Casos que a chave de acesso local difere com a chave de acesso salva na Sefaz
// Procura xml enviado que possua a chave de acesso igual aquela que está na Sefaz
var
  sArquivoEnvio: String;
  // Sandro Silva 2020-02-13  sXml: String;
  IBTSALVA: TIBTransaction;
  IBQCONSULTA: TIBQuery;
  IBQSALVA: TIBQuery;
  sRetorno: String;
  sNFEid: String;
  slArquivoEnvio: TStringList;
  sXmlAutorizado: String;
  sXmlEnvio: String;
  sStatus: String;
  slListaXml: TStringList;
  iArquivoEnvio: Integer;
begin
  slArquivoEnvio := TStringList.Create;
  slListaXml     := TStringList.Create;

  IBTSALVA := CriaIBTransaction(Form1.IBDatabase1);

  IBQCONSULTA := CriaIBQuery(IBTSALVA);
  IBQSALVA := CriaIBQuery(IBTSALVA);

  //NFC-e autorizadas sem ID
  IBQCONSULTA.Close;
  IBQCONSULTA.SQL.Text :=
    'select * ' +
    'from NFCE ' +
    'where (coalesce(STATUS, '''') containing ''Duplicidade'' and coalesce(STATUS, '''') containing ''[chNFe'' ' + // Duplicidade com diferença na chave de acesso do xml com a chave na Sefaz e sem chave salva no campo NFEID
        'or coalesce(STATUS, '''') containing ''Rejeição: Duplicidade de NF-e, com diferença na Chave de Acesso'') ' +
    ' and CAIXA = ' + QuotedStr(sCaixaNF)  +
    ' and NUMERONF = ' + QuotedStr(sNumeroNF);
  IBQCONSULTA.Open;

  while IBQCONSULTA.Eof = False do
  begin
    try
      sNumeroNF := IBQCONSULTA.FieldByName('NUMERONF').AsString;
      sCaixaNF  := IBQCONSULTA.FieldByName('CAIXA').AsString;
      sXmlAutorizado := '';

      sNFEid := LimpaNumero(Copy(IBQCONSULTA.FieldByName('STATUS').AsString, Pos('[chNFe', IBQCONSULTA.FieldByName('STATUS').AsString), 52)); // Extrai a chave do status [chNFe:25191205859943000198650010000214361074265980]

      {Sandro Silva 2020-06-05 inicio}
      if LimpaNumero(sNFEid) = '' then
      begin

        try // Sandro Silva 2021-09-13
          sRetorno := Form1.spdNFCe1.ConsultarNF(LimpaNumero(xmlNodeValue(IBQCONSULTA.FieldByName('NFEXML').AsString, '//infNFe/@Id')));
        except
        end;

        if AnsiContainsText(sRetorno, '<cStat>562</cStat>') then
        begin
          sNFEid := LimpaNumero(Copy(xmlNodeValue(sRetorno, '//xMotivo'), Pos('[chNFe', xmlNodeValue(sRetorno, '//xMotivo')), 52)); //Copy(xmlNodeValue(sRetorno, '//xMotivo'), Pos('chNFe:', xmlNodeValue(sRetorno, '//xMotivo')) + 6, 44)
        end;

      end;
      {Sandro Silva 2020-06-05 fim}

      if (Trim(sNFEid) <> '') then
      begin

        try  // Sandro Silva 2021-09-13
          sRetorno := Form1.spdNFCe1.ConsultarNF(LimpaNumero(sNFEid));
        except
        end;

        sRetorno := _ecf65_CorrigePadraoRespostaSefaz(sRetorno);       

        // Sandro Silva 2022-04-12 if ((Pos('<cStat>100</cStat>', sRetorno) <> 0) or (Pos('<cStat>150</cStat>', sRetorno) <> 0)) and (_ecf65_XmlNfceCancelado(sRetorno) = False) then
        if (_ecf65_xmlAutorizado(sRetorno)) and (_ecf65_XmlNfceCancelado(sRetorno) = False) then
        begin

          // Procura o xml autorizado na pasta xmldestinatario                                                                                                                                           //MODELO+CAIXA
          // Sandro Silva 2021-11-17 sArquivoEnvio := StringReplace(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + SelecionaXmlEnvio(Form1.spdNFCe1.DiretorioXmlDestinatario + '\*' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString) + '65001' + RightStr('000000000' + IBQCONSULTA.FieldByName('NUMERONF').AsString, 9) + '*-nfce.xml', '', ''), '\\', '\', [rfReplaceAll]);
          sArquivoEnvio := StringReplace(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + SelecionaXmlEnvio(Form1.spdNFCe1.DiretorioXmlDestinatario + '\*' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString) + '65' + RightStr('00' + _ecf65_SerieAtual(IBQCONSULTA.Transaction), 3) + RightStr('000000000' + IBQCONSULTA.FieldByName('NUMERONF').AsString, 9) + '*-nfce.xml', '', ''), '\\', '\', [rfReplaceAll]);

          slListaXml.Clear;

          if FileExists(PChar(sArquivoEnvio)) = False then // Se não encontrar o xml autorizado
          begin

            //Seleciona todos os xml                                                                                                          //MODELO+SERIE
            // Sandro Silva 2021-11-17 _ecf65_ListaArquivos(StringReplace(Form1.spdNFCe1.DiretorioLog + '\*' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString) + '65001' + RightStr('000000000' + IBQCONSULTA.FieldByName('NUMERONF').AsString, 9) + '*-env-sinc-lot.xml', '\\', '\', [rfReplaceAll]));
            _ecf65_ListaArquivos(StringReplace(Form1.spdNFCe1.DiretorioLog + '\*' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString) + '65' + RightStr('00' + _ecf65_SerieAtual(IBQCONSULTA.Transaction), 3) + RightStr('000000000' + IBQCONSULTA.FieldByName('NUMERONF').AsString, 9) + '*-env-sinc-lot.xml', '\\', '\', [rfReplaceAll]));

            if FileExists(PChar(Form1.sAtual + '\arq_.txt')) then
            begin
              slListaXml.LoadFromFile(Form1.sAtual + '\arq_.txt');

              for iArquivoEnvio := 0 to slListaXml.Count - 1 do
              begin
                // Procura o xml do lote de envio
                //sArquivoEnvio := Form1.spdNFCe1.DiretorioLog + '\' + SelecionaXmlEnvio(Form1.spdNFCe1.DiretorioLog + '\*001' + RightStr('000000000' + IBQCONSULTA.FieldByName('NUMERONF').AsString, 9) + '*-env-sinc-lot.xml', '', '');
                sArquivoEnvio := slListaXml.Strings[iArquivoEnvio];

                if FileExists(PChar(sArquivoEnvio)) then // se achou o lote de envio
                begin

                  slArquivoEnvio.Clear;
                  slArquivoEnvio.LoadFromFile(sArquivoEnvio);

                  if sNFEid = LimpaNumero(xmlNodeValue(slArquivoEnvio.Text, '//infNFe/@Id')) then
                  begin

                    slArquivoEnvio.LoadFromFile(sArquivoEnvio);
                    sXmlEnvio := slArquivoEnvio.Text;
                    if xmlNodeValue(sRetorno, '//protNFe/infProt/digVal') = xmlNodeValue(sXmlEnvio, '//DigestValue') then
                    begin
                      slArquivoEnvio.Clear;
                      slArquivoEnvio.Text := ConcatencaNodeNFeComProtNFe(sXmlEnvio, sRetorno);
                      slArquivoEnvio.SaveToFile(StringReplace(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + xmlNodeValue(sRetorno, '//infProt/chNFe') + '-nfce.xml', '\\', '\', [rfReplaceAll]));

                      sXmlAutorizado := slArquivoEnvio.Text;
                      Break;
                    end;

                    // Valida se o retorno foi de Não consta na base da sefaz
                    if ((Trim(sRetorno) = '') or AnsiContainsText(ConverteAcentosXML(sRetorno), ConverteAcentosXML('não consta na base de dados da SEFAZ'))) // Sem retorno ou não encontrado na sefaz
                      and (Copy(sNfeId, 35, 1) = TPEMIS_NFCE_CONTINGENCIA_OFFLINE) // tpEmis da Chave = 9 - contingencia offline
                    then
                    begin
                      Break;
                    end;
                  end; // ID pertence ao emitente do small
                end;
              end; // for na lista de arquivo para consultar na sefaz
            end; // Exite arquivo com lista para consultar na sefaz
          end
          else
          begin
            slArquivoEnvio.LoadFromFile(sArquivoEnvio);
            sXmlEnvio := slArquivoEnvio.Text;
            sXmlAutorizado := slArquivoEnvio.Text;
          end;

          // Ter certeza que está com xml válido  e o digest do xml enviado é igual ao digest da autorização
          if (xmlNodeXml(sXmlAutorizado, '//NFe') <> '') and (xmlNodeXml(sXmlAutorizado, '//protNFe') <> '') and (xmlNodeValue(sXmlAutorizado, '//DigestValue') = xmlNodeValue(sXmlAutorizado, '//digVal')) then
          begin
            // xml assinado e autorizado

            if Pos('<tpAmb>2</tpAmb>', sXmlAutorizado) > 0  then
            begin
              sStatus := NFCE_STATUS_AUTORIZADO_USO_EM_HOMOLOGACAO;// 'Autorizado o uso da NFC-e em ambiente de homologação';
            end else
            begin
              sStatus := NFCE_STATUS_AUTORIZADO_USO_EM_PRODUCAO;// 'Autorizado o uso da NFC-e';
            end;

            try

              Form1.IBDataSet150.Close;
              Form1.IBDataSet150.SelectSQL.Text :=
                'select * ' +
                'from NFCE ' +
                // Sandro Silva 2021-11-17 'where REGISTRO = ' + QuotedStr(IBQCONSULTA.FieldByName('REGISTRO').AsString);
                'where MODELO = ''65'' ' +
                ' and NUMERONF = ' + QuotedStr(IBQCONSULTA.FieldByName('NUMERONF').AsString) +
                ' and CAIXA = ' + QuotedStr(IBQCONSULTA.FieldByName('CAIXA').AsString);
              Form1.IBDataSet150.Open;

              // Sandro Silva 2021-11-17 Validar que xml pertence a nfce selecionada
              if RightStr('000' + Form1.IBDataSet150.FieldByName('NUMERONF').AsString, 9) = _ecf65_NumeroNfFromChave(LimpaNumero(xmlNodeValue(sXmlAutorizado, '//protNFe/infProt/chNFe'))) then
              begin

                Form1.IBDataSet150.Edit;
                Form1.IBDataSet150.FieldByName('NFEXML').AsString := sXmlAutorizado;
                Form1.IBDataSet150.FieldByName('NFEID').AsString  := LimpaNumero(xmlNodeValue(sXmlAutorizado, '//protNFe/infProt/chNFe'));
                Form1.IBDataSet150.FieldByName('TOTAL').AsFloat   := xmlNodeValueToFloat(IBQSALVA.ParamByName('NFEXML').AsString, '//vNF'); // Sandro Silva 2019-12-04
                Form1.IBDataSet150.FieldByName('STATUS').AsString := sStatus;
                Form1.IBDataSet150.Post;

                if xmlNodeXml(sXmlAutorizado, '//pag') <> '' then
                  _ecf65_GravaPagamentFromXML(sXmlAutorizado, IBQCONSULTA.FieldByName('NUMERONF').AsString, IBQCONSULTA.FieldByName('CAIXA').AsString);

                {Sandro Silva 2022-06-02 inicio}
                Audita('CORRIGE','FRENTE', '', 'Rejeição chave duplicada: ' + xmlNodeValue(sXmlAutorizado, '//protNFe/infProt/chNFe'), 0, 0); // Ato, Modulo, Usuário, Histórico, Valor
                {Sandro Silva 2022-06-02 fim}

              end;

            except

            end;

            if bCommitarTudoNoFinal then
              Commitatudo(True);  // TForm1.ConsultaChaveNFCe1Click()

          end;// xml autorizado

        end // if ((Pos('<cStat>100</cStat>', sRetorno) <> 0) or (Pos('<cStat>150</cStat>', sRetorno) <> 0)) and (_ecf65_XmlNfceCancelado(sRetorno) = False) then

      end;// if (Trim(sNFEid) <> '') then

    except

    end;
    IBQCONSULTA.Next;
  end; // while IBQCONSULTA.Eof = False do

  try
    IBQSALVA.Transaction.Commit;
  except
    IBQSALVA.Transaction.Rollback;
  end;

  if bCommitarTudoNoFinal then
    Commitatudo(True);  // TForm1.ConsultaChaveNFCe1Click()

  DeleteFile(PChar(Form1.sAtual + '\arq_.tmp'));
  DeleteFile(PChar(Form1.sAtual + '\arq_.txt'));

  FreeAndNil(IBQCONSULTA);
  FreeAndNil(IBQSALVA);
  FreeAndNil(IBTSALVA);
  FreeAndNil(slArquivoEnvio);
  FreeAndNil(slListaXml);
end;

procedure _ecf65_ListaArquivos(sArquivo: String);
begin
  DeleteFile(PChar(Form1.sAtual + '\arq_.tmp'));
  DeleteFile(PChar(Form1.sAtual + '\arq_.txt'));

  ShellExecute(Application.Handle, 'runas', 'cmd.exe', PChar('/C dir "' + sArquivo + '" /s/B > "' + Form1.sAtual + '\arq_.tmp"'), nil, SW_HIDE);

  while RenameFile(PChar(Form1.sAtual + '\arq_.tmp'), PChar(Form1.sAtual + '\arq_.txt')) = False do
  begin
    Sleep(250);
    Application.ProcessMessages;
  end;
end;

function _ecf65_UsoDenegado(sXmlRetorno: String): Boolean;
// Retorna True quando o cStat em sXMlRetorno conter código de uso denegado listado no manual do contribuinte
/// 110-Uso Denegado;
/// 205 NF-e está denegada na base de dados da SEFAZ;
/// 301 Uso Denegado: Irregularidade fiscal do emitente;
/// 302 Uso Denegado: Irregularidade fiscal do destinatário;
/// 303 Uso Denegado: Destinatário não habilitado a operar na UF
begin
  Result := False;
  if (Pos('<cStat>110</cStat>', sXmlRetorno) <> 0) /// 110-Uso Denegado;
  or (Pos('<cStat>205</cStat>', sXmlRetorno) <> 0) /// 205 NF-e está denegada na base de dados da SEFAZ;
  or (Pos('<cStat>301</cStat>', sXmlRetorno) <> 0) /// 301 Uso Denegado: Irregularidade fiscal do emitente;
  or (Pos('<cStat>302</cStat>', sXmlRetorno) <> 0) /// 302 Uso Denegado: Irregularidade fiscal do destinatário;
  or (Pos('<cStat>303</cStat>', sXmlRetorno) <> 0) /// 303 Uso Denegado: Destinatário não habilitado a operar na UF
  then
    Result := True;
end;

function _ecf65_SimulaRetornoUsoDenegado(Value: String): String;
// Simula retorno de uso denegado. Para poder testar comportamento da aplicação quando ocorre essa situação
var
  scStat: String;
  sxMotivo: String;
begin
  Result := Value;
  //if (LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString) = '07426598000124') and (LerParametroIni('FRENTE.INI', 'NFCE', 'Retorno Denegado', '') = 'Sim') then
  if (LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString) = LimpaNumero(CNPJ_SOFTWARE_HOUSE_PAF)) and (LerParametroIni('FRENTE.INI', 'NFCE', 'Retorno Denegado', '') <> '') then
  begin
    scStat := LerParametroIni('FRENTE.INI', 'NFCE', 'Retorno Denegado', '');
    if StrToIntDef(scStat, 0) = 0 then
      scStat := '110';
    if scStat = '110' then sxMotivo := 'Uso Denegado'
    else if scStat = '205' then sxMotivo := 'NF-e está denegada na base de dados da SEFAZ'
    else if scStat = '301' then sxMotivo := 'Uso Denegado: Irregularidade fiscal do emitente'
    else if scStat = '302' then sxMotivo := 'Uso Denegado: Irregularidade fiscal do destinatário'
    else if scStat = '303' then sxMotivo := 'Uso Denegado: Destinatário não habilitado a operar na UF';

    Result :=
      '<nfeResultMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4">' +
        '<retEnviNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00">' +
          '<tpAmb>2</tpAmb>' +
          '<verAplic>AM3.10-4.00</verAplic>' +
          '<cStat>104</cStat>' +
          '<xMotivo>Lote processado</xMotivo>' +
          '<cUF>13</cUF>' +
          '<dhRecbto>' + xmlNodeValue(Value, '//dhRecbto') + '</dhRecbto>' +
          '<protNFe versao="4.00">' +
            '<infProt>' +
              '<tpAmb>2</tpAmb>' +
              '<verAplic>AM3.10-4.00</verAplic>' +
              '<chNFe>' + xmlNodeValue(Value, '//chNFe') + '</chNFe>' +
              '<dhRecbto>' + xmlNodeValue(Value, '//dhRecbto') + '</dhRecbto>' +
              '<nProt>' + xmlNodeValue(Value, '//nProt') + '</nProt>' +
              '<digVal>' + xmlNodeValue(Value, '//digVal') + '</digVal>' +
              '<cStat>' + scStat + '</cStat>' +
              '<xMotivo>' + sxMotivo + '</xMotivo>' +
            '</infProt>' +
          '</protNFe>' +
        '</retEnviNFe>' +
      '</nfeResultMsg>';
  end;

end;

function _ecf65_SimulaSemRetornoSefaz(Value: String): String;
// Simular situação que não obtem retorno do servidor da Sefaz. Para poder testar comportamento da aplicação quando ocorre essa situação
begin
  Result := Value;
  if (LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString) = LimpaNumero(CNPJ_SOFTWARE_HOUSE_PAF)) and (LerParametroIni('FRENTE.INI', 'NFCE', 'Retorno', '') = 'Não') then
    Result := '';
end;

function _ecf65_TimeOutComunicacaoSefaz: Integer;
// Retorna o TimeOut configurado, já convertido para milisegundos para usar com componente Tecnospeed
begin
  Result := StrToIntDef(LerParametroIni('FRENTE.INI', 'NFCE', 'Timeout', IntToStr(TIMEOUT_NFCE)), TIMEOUT_NFCE) * 1000;
  if Result < 20000 then
    Result := 20000;
end;

function _ecf65_TimeOutPadraoConsultaStatusServicoNFCe: Integer;
// Retorna timeout padrão para uso na consulta de status do serviço da NFC-e
begin
  Result := 20 * 1000; // 20 Segundos retornado em milisegundos
  //Result := StrToIntDef(LerParametroIni('FRENTE.INI', 'NFCE', 'Timeout', IntToStr(TIMEOUT_NFCE)), TIMEOUT_NFCE) * 1000;
end;

function _ecf65_ContadorGRG(IBDataBase: TIBDatabase;
  sCaixa: String; Incrementa: Integer): String;
// Retorna o número do contador geral de relatórios gerenciais usados no PAFNFC-e   
var
  iContador: Integer;
  IBTTEMP: TIBTransaction;
  IBQTEMP: TIBQuery;
begin

  IBTTEMP := CriaIBTransaction(IBDataBase);
  IBQTEMP := CriaIBQuery(IBTTEMP);

  try
    IBQTEMP.Close;
    IBQTEMP.SQL.Text :=
      'select trim(RDB$GENERATOR_NAME) as GENERATOR_NAME ' +
      'from RDB$GENERATORS ' +
      'where RDB$GENERATOR_NAME = ' + QuotedStr('G_NFCE_CONTADORRG_' + sCaixa);
    IBQTEMP.Open;

    if IBQTEMP.FieldByName('GENERATOR_NAME').AsString = '' then
    begin
      IBQTEMP.Close;
      IBQTEMP.SQL.Text :=
        'create sequence G_NFCE_CONTADORRG_' + sCaixa;
      IBQTEMP.ExecSQL;

      IBQTEMP.Transaction.Commit;

   end;

    iContador := StrToInt64Def(IncGenerator(IBDataBase, 'G_NFCE_CONTADORRG_' + SCAIXA, Incrementa), 0);

  except

    iContador := 0;

  end;
  Result := FormataNumeroDoCupom(iContador);

  FreeAndNil(IBQTEMP);
  FreeAndNil(IBTTEMP);
end;

function _ecf65_HabilitarGerarindIntermed(bHabilitar: Boolean): Boolean;
// Habilita ou desabilita a geração da tag indIntermed
begin
  try
    GravarParametroIni(FRENTE_INI, SECAO_65, 'indIntermed', IfThen(bHabilitar, 'Sim', 'Não'));
    Result := True;
  except
    Result := False;
  end;
end;

procedure _ecf65_ValidaNFCe_Setup;
begin
  if Form1.sModeloECF = '65' then
  begin
    if FileExists('nfce_setup.exe') then
    begin
      if LerParametroIni('FRENTE.INI', 'NFCE', 'BUILD', '') <> Build then
      begin
        Form22.Label6.Caption := 'Instalando dependências para NFC-e';
        Form22.Label6.Repaint;

        SalvarConfiguracao('FRENTE.INI', 'NFCE', 'BUILD', Build);
        ShellExecute( 0, 'Open', 'nfce_setup.exe /verysilent', '', '', SW_HIDE);
        while ConsultaProcesso('nfce_setup.exe') do
        begin
          Sleep(2000);
        end;

        Form22.Label6.Caption := '';
        Form22.Label6.Repaint;
      end;
    end;
  end;

end;

procedure _ecf65_AdicionaCNPJCOntabilidade(spdNFCeDataSets: TspdNFCeDataSets); // Sandro Silva 2020-09-01
var
  sCnpjCpfContabilidade: String;
begin
  sCnpjCpfContabilidade := LimpaNumero(LerParametroIni(Form1.sAtual + '\nfe.ini', 'XML', 'CNPJ da Contabilidade', ''));
  if CpfCgc(sCnpjCpfContabilidade) and (Trim(sCnpjCpfContabilidade) <> '') then
  begin
    if Length(sCnpjCpfContabilidade) = 11 then
    begin
      spdNFCeDataSets.Campo('CPF_GA03').Value := sCnpjCpfContabilidade;
    end;

    if Length(sCnpjCpfContabilidade) = 14 then
    begin
      spdNFCeDataSets.Campo('CNPJ_GA02').Value := sCnpjCpfContabilidade;
    end;
  end;
end;

procedure _ecf65_ImportaCertificadoNFe(ArquivoNFeIni: String);
// Valida se ainda não foi selecionado o certificado para NFC-e e importa o certificado configurado no NFE.INI
begin
  try
    if LerParametroIni('FRENTE.INI', 'NFCE', 'Certificado', '') = '' then
    begin
      if FileExists(ArquivoNFeIni) then
      begin
        if LerParametroIni(ArquivoNFeIni, 'NFE', 'Certificado', '') <> '' then
          GravarParametroIni('FRENTE.INI', 'NFCE', 'Certificado', LerParametroIni(ArquivoNFeIni, 'NFE', 'Certificado', ''));
      end;
    end;
  except

  end;
end;

function _ecf65_tpEmisFromChave(sChave: String): String;
begin
  Result := Copy(sChave, 35, 1)
end;

function _ecf65_JaTemContingenciaPorSubstituicao(Transaction: TIBTransaction; sIDNFCe: String): Boolean;
// Valida se a NFC-e já está atrelada a uma Contingência por substituição
var
  IBQSUBTITUI: TIBQuery;
begin
  Result := False;
  try
    IBQSUBTITUI := CriaIBQuery(Transaction);

    if _ecf65_tpEmisFromChave(sIDNFCe) = TPEMIS_NFCE_CONTINGENCIA_OFFLINE then
    begin // Se ID NFC-e for de contingência 13190707426598000124650010001199739074265985
      Result := True;
    end
    else
    begin
      // Pesquisa se A NFC-e tem ID Substituto
      IBQSUBTITUI.Close;
      IBQSUBTITUI.SQL.Text :=
        'select NFEIDSUBSTITUTO ' +
        'from NFCE ' +
        'where NFEID = :ID ';
      IBQSUBTITUI.ParamByName('ID').AsString := sIDNFCe;
      IBQSUBTITUI.Open;
      if _ecf65_tpEmisFromChave(IBQSUBTITUI.FieldByName('NFEIDSUBSTITUTO').AsString) = TPEMIS_NFCE_CONTINGENCIA_OFFLINE then
        Result := True;

    end;
    FreeAndNil(IBQSUBTITUI);
  except
  end;
end;

function _ecf65_TodosItensCancelados(IBTransaction: TIBTransaction; Pedido: String; Caixa: String): Boolean; // Sandro Silva 2021-11-01
// Valida se todos os itens da venda estão cancelados, retornando True ou retorna false quando encontrar algum item vendido
var
  IBQALTERACA: TIBQuery;
begin
  Result := True; // Começa considerando que todos itens estão cancelados
  IBQALTERACA := CriaIBQuery(IBTransaction);

  try
    IBQALTERACA.Close;
    IBQALTERACA.SQL.Text :=
      'select CODIGO ' +
      'from ALTERACA ' +
      'where PEDIDO = ' + QuotedStr(Pedido) +
      ' and CAIXA = ' + QuotedStr(Caixa) +
      ' and (TIPO = ''BALCAO'' or TIPO = ''LOKED'') ' +
      ' and DESCRICAO <> ''Desconto'' ' +
      ' and DESCRICAO <> ''Acréscimo'' ';
    IBQALTERACA.Open;

    if IBQALTERACA.FieldByName('CODIGO').AsString <> '' then
    begin
      // Encontrou item vendido
      //Se retornar registro com código preenchido retorna False
      Result := False;
    end;

  except
  end;

  FreeAndNil(IBQALTERACA);
end;

function _ecf65_SerieAtual(IBTransaction: TIBTransaction): String; // Sandro Silva 2021-11-12
var
  IBQSERIE: TIBQuery;
begin
  IBQSERIE := CriaIBQuery(IBTransaction);
  try
    IBQSERIE.Close;
    IBQSERIE.SQL.Text :=
      'select gen_id(G_SERIENFCE, 0) AS SERIE from RDB$DATABASE';
    IBQSERIE.Open;

    Result := IBQSERIE.FieldByName('SERIE').AsString;

  except
    Result := '1';
  end;
  FreeAndNil(IBQSERIE);

end;

function _ecf65_NumeroNfFromChave(sChave: String): String;
begin
  Result := Copy(LimpaNumero(sChave), 26, 9);
end;

function _ecf65_ConsultaIdNFCeEnviadaSemRespostaFazendoReenvio(spdNFCe: TspdNFCe;
  sLote: String; xmlEnvio: String): String;
var
  sRetorno: String;
  iTentaConsulta: Integer;
begin
  Result := '';
  try
    Audita('EMISSAO','FRENTE', '', 'Envio sem retorno ' + ExtractFileName(Application.ExeName) + ' ' + LimpaNumero(Form22.sBuild) + ' ' + FormataNumeroDoCupom(Form1.iCupom) + ' ' + Form1.sCaixa,0,0); // Ato, Modulo, Usuário, Histórico, Valor
  except

  end;

  Sleep(2000);

  for iTentaConsulta := 1 to 3 do // Realiza 3 até tentativas
  begin

    try
      Audita('EMISSAO','FRENTE', '', 'Tentativa ' + IntToStr(iTentaConsulta) + ' Consulta NFC-e ' + ExtractFileName(Application.ExeName) + ' ' + LimpaNumero(Form22.sBuild) + ' ' + FormataNumeroDoCupom(Form1.iCupom) + ' ' + Form1.sCaixa,0,0); // Ato, Modulo, Usuário, Histórico, Valor
    except

    end;

    _ecf65_NumeroSessaoIntegradorFiscal;

    try

      // Inicia consultando o ID
      sRetorno := spdNFCe.ConsultarNF(LimpaNumero(xmlNodeValue(xmlEnvio, '//@Id')));

      // Valida se na resposta está rejeição de que não consta na SEFAZ
      if AnsiContainsText(sRetorno, '<cStat>217</cStat>') or AnsiContainsText(ConverteAcentos2(sRetorno), 'nao consta na base de dados da SEFAZ') then
      begin

        Sleep(2000);

        try

          // Não encontrou, faz o envio
          sRetorno := spdNFCe.EnviarNFSincrono(sLote, xmlEnvio, False); /// TRANSMITE NFC-E

        except
          sRetorno := ''; // Se der erro fica no For para tentar novamente o envio
        end;

      end;

    except
    end;

    sRetorno := _ecf65_CorrigePadraoRespostaSefaz(sRetorno);

    if sRetorno <> '' then
      Break; // Sai do for iTentaConsulta := 1 to 3 do

    Sleep(3000); // Aguarda servidor processar o envio. Evitar bloqueio na Sefaz por consumo indevido

  end; // for iTentaConsulta := 1 to 3 do

  // Sandro Silva 2022-04-12 if (Pos('<cStat>100</cStat>',sRetorno) <> 0) or (Pos('<cStat>150</cStat>',sRetorno) <> 0) then // 100|Autorizado o uso da NF-e ou 150|Autorizado o uso da NF-e, autorização fora de prazo // Sandro Silva 2018-08-10
  if (_ecf65_xmlAutorizado(sRetorno)) then // 100|Autorizado o uso da NF-e ou 150|Autorizado o uso da NF-e, autorização fora de prazo // Sandro Silva 2018-08-10
  begin

    // Se foi autorizada concatena xml assinado com os dados da autorização

    if xmlNodeXML(sRetorno, '//protNFe') <> '' then
    begin

      //conferir o digestvalue do retorno com o da nota enviada
      if xmlNodeValue(sRetorno, '//infProt/digVal') = xmlNodeValue(xmlEnvio, '//DigestValue') then
      begin
        sRetorno := ConcatencaNodeNFeComProtNFe(xmlEnvio, sRetorno);

        Result := sRetorno;

        try

          try
            Audita('EMISSAO','FRENTE', '', 'NFC-e recuperada ' + ExtractFileName(Application.ExeName) + ' ' + LimpaNumero(Form22.sBuild) + ' ' + FormataNumeroDoCupom(Form1.iCupom) + ' ' + Form1.sCaixa,0,0); // Ato, Modulo, Usuário, Histórico, Valor
          except

          end;

          // Salva xml autorizado na pasta xmldestinatario
          with TStringList.Create do
          begin
            Text := sRetorno;
            SaveToFile(spdNFCe.DiretorioXmlDestinatario + '\' + LimpaNumero(xmlNodeValue(xmlEnvio, '//@Id')) + '-nfce.xml');
            Free;
          end;
          Sleep(100);

        except
        end;

      end;

    end;

  end;

end;

procedure _ecf65_RecuparaXML(sNumeroNF: String; sCaixaNF: String);
var
  recupera: TRecuperaNFCe;
  iCupomOld: Integer;
  sCaixaOld: String;
  sData: String;
  SelectIBDataSet150Old: String;
begin
  if (Trim(sNumeroNF) <> '') and (Trim(sCaixaNF) <> '') then
  begin
    recupera := TRecuperaNFCe.Create;

    recupera.RecuperaXML(sNumeroNF, Form1.spdNFCe1.DiretorioXmlDestinatario);

    iCupomOld := Form1.icupom;
    sCaixaOld := Form1.sCaixa;

    Form1.icupom := StrToInt(sNumeroNF);
    Form1.sCaixa := sCaixaNF;
    SelectIBDataSet150Old := Form1.IBDataSet150.SelectSQL.Text;

    Form1.IBDataSet150.Close;
    Form1.IBDataSet150.SelectSQL.Text :=
      'select * ' +
      'from NFCE ' +
      'where NUMERONF = ' + QuotedStr(sNumeroNF) +
      ' and CAIXA = ' + QuotedStr(sCaixaNF);
    Form1.IBDataSet150.Open;

    try

      if recupera.cStatNFCe = '' then
      begin
        recupera.RecuperaXML(sNumeroNF, Form1.spdNFCe1.DiretorioLog);
      end;

      if (recupera.cStatNFCe <> '') and (recupera.XmlRecuperado <> '') then
      begin

        if (RightStr('000' + sNumeroNF, 9) = _ecf65_NumeroNfFromChave(xmlNodeValue(recupera.XmlRecuperado, '//chNFe')))
          and (Form1.IBDataSet150.FieldByName('NUMERONF').AsString = sNumeroNF)
          and (Form1.IBDataSet150.FieldByName('CAIXA').AsString = sCaixaNF) then
        begin

          try

            Form1.IBDataSet150.Edit;
            Form1.IBDataSet150.FieldByName('NFEXML').AsString := recupera.XmlRecuperado;
            Form1.IBDataSet150.FieldByName('NFEID').AsString  := xmlNodeValue(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//chNFe');
            Form1.IBDataSet150.FieldByName('TOTAL').AsFloat   := xmlNodeValueToFloat(Form1.IBDataSet150.FieldByName('NFEXML').AsString, '//vNF');
            if (recupera.cStatNFCe = NFCE_CSTAT_CANCELADA_135) then // Cancelada
              Form1.IBDataSet150.FieldByName('STATUS').AsString := NFCE_STATUS_CANCELAMENTO;
            if recupera.cStatNFCe = NFCE_CSTAT_AUTORIZADO_100 then // Autorizada
              Form1.IBDataSet150.FieldByName('STATUS').AsString := NFCE_STATUS_AUTORIZADO_USO_EM_PRODUCAO;
            Form1.IBDataSet150.Post;

            {Sandro Silva 2022-06-02 inicio}
            Audita('RECUPERA','FRENTE', '', 'Recuperou XML NFC-e: ' + xmlNodeValue(recupera.XmlRecuperado, '//protNFe/infProt/chNFe'), 0, 0); // Ato, Modulo, Usuário, Histórico, Valor
            {Sandro Silva 2022-06-02 fim}

          except

          end;

          if recupera.cStatNFCe = NFCE_CSTAT_AUTORIZADO_100 then // Autorizada
          begin
            TBlobField(Form1.IBDataSet150.FieldByName('NFEXML')).SaveToFile(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + xmlNodeValue(recupera.XmlRecuperado, '//chNFe') + '-nfce.xml');

            if xmlNodeXml(recupera.XmlRecuperado, '//pag') <> '' then
            begin
              _ecf65_GravaPagamentFromXML(recupera.XmlRecuperado, sNumeroNF, sCaixaNF);
            end;

          end;

          if (recupera.cStatNFCe = NFCE_CSTAT_CANCELADA_135) or (_ecf65_UsoDenegado(recupera.XmlRecuperado)) then
          begin

            if recupera.cStatNFCe = NFCE_CSTAT_CANCELADA_135 then // Cancelada
            begin
              TBlobField(Form1.IBDataSet150.FieldByName('NFEXML')).SaveToFile(Form1.spdNFCe1.DiretorioXmlDestinatario + '\' + xmlNodeValue(recupera.XmlRecuperado, '//chNFe') + '-caneve.xml');
            end;

            // Cancelar ALTERACA
            // Acertar ESTOQUE
            // Excluir RECEBER
            // Excluir PAGAMENT
            Form1.CancelaVendaAtualNoBanco(sNumeroNF, sData, True);

          end;

        end;

      end
      else
      begin

        if (recupera.IdNFCe <> '') then
        begin

          // Atualiza somente o id

          if (RightStr('000' + sNumeroNF, 9) = _ecf65_NumeroNfFromChave(recupera.IdNFCe))
            and (Form1.IBDataSet150.FieldByName('NUMERONF').AsString = sNumeroNF)
            and (Form1.IBDataSet150.FieldByName('CAIXA').AsString = sCaixaNF) then
          begin

            try

              Form1.IBDataSet150.Edit;
              Form1.IBDataSet150.FieldByName('NFEID').AsString := recupera.IdNFCe;
              Form1.IBDataSet150.Post;

            except

            end;
          end;
        end;

      end;

    finally
      Form1.icupom := iCupomOld;
      Form1.sCaixa := sCaixaOld;

      Form1.IBDataSet150.Close;
      Form1.IBDataSet150.SelectSQL.Text := SelectIBDataSet150Old;
      Form1.IBDataSet150.Open;

    end;

    FreeAndNil(recupera);
  end;
end;

function _ecf65_xmlAutorizado(sXML: String): Boolean;
begin
  //100|Autorizado o uso da NF-e ou 150|Autorizado o uso da NF-e, autorização fora de prazo
  Result := (Pos('<cStat>100</cStat>', sXML) <> 0) or (Pos('<cStat>150</cStat>', sXML) <> 0)
end;

procedure _ecf65_GravaIdCSC(sIdToken: String);
begin
  GravarParametroIni('FRENTE.INI', 'NFCE', 'ID Token NFCE', sIdToken);
  GravarParametroIni(ExtractFilePath(Application.ExeName) + 'NFE.INI', 'NFCE', 'ID Token NFCE', sIdToken);
end;

procedure _ecf65_GravaCSC(sCSC: String);
begin
  //
  GravarParametroIni('FRENTE.INI', 'NFCE', 'Número do Token NFCE', sCSC);
  GravarParametroIni(ExtractFilePath(Application.ExeName) + 'NFE.INI', 'NFCE','Número do Token NFCE', sCSC);
end;

function _ecf65_GerarcProdANVISA(sTAGS_: String; sNCM: String): Boolean;
begin
  Result := False;

  if (Pos('3001', sNCM) > 0)
  or (Pos('3002', sNCM) > 0)
  or (Pos('3003', sNCM) > 0)
  or (Pos('3004', sNCM) > 0)
  or (Pos('3005', sNCM) > 0)
  or (Pos('3006', sNCM) > 0) then
  begin

    if sTAGS_ <> '' then
    begin
      if (RetornaValorDaTagNoCampo('cProdANVISA', sTAGS_) <> '') then //
      begin
        Result := True;
      end;
    end;

  end;

end;

procedure _ecf65_DisponibilizarDANFCe(sStatus: String; sLote: String; fNFE: String);
begin
  if AnsiContainsText(sStatus, 'conting') then
  begin
    Form1.spdNFCe1.DanfceSettings.ExibirDetalhamento := True;
    Form1.spdNFCe1.DanfceSettings.ParamsAvancados    := 'IdentificacaoVia=Via Estabelecimento';
  end;

  if Form1.VisualizarDANFCE1.Checked then
    _ecf65_Visualiza_DANFECE(sLote, fNFE);

  if Form1.ImprimirDANFCE1.Checked then
    _ecf65_Imprime_DANFECE(sLote, fNFE);

  if Form1.PosElginPay.Transacao.ImprimirComprovanteVenda then
    Form1.PosElginPay.ImpressaoComprovanteVenda(fNFE);

  if AnsiContainsText(sStatus, 'conting') then
  begin
    // Contingência 2 vias
    if Form1.ImprimirDANFCE1.Checked = False then
      _ecf65_Imprime_DANFECE(sLote, fNFE);

    Form1.spdNFCe1.DanfceSettings.ParamsAvancados := 'IdentificacaoVia=Via Consumidor';
    _ecf65_Imprime_DANFECE(sLote, fNFE);
  end;
  Form1.spdNFCe1.DanfceSettings.ParamsAvancados := '';

  if Form1.EnviaremailcomXMLePDFacadavenda1.Checked then // Ficha 4736 Sandro Silva 2019-08-02
    _ecf65_Email_DANFECE(sLote, fNFE);

end;

{ TMobile }

constructor TMobile.Create;
begin
  inherited;
  VendaImportando := '';
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
