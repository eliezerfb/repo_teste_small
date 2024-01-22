{
Para agilizar programação da comunicação, foram usados mesmo métodos da unit _small_03.pas (daruma32.dll), que fazem chamadas ao métudos da darumaframework.dll 

Alterações
Sandro Silva 2016-02-04
- Fiscal SEFAZ de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
}

unit _Small_17;

interface

uses
  Windows, Messages, SmallFunc_xe, Fiscal, SysUtils,Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Mask, Grids, DBGrids, DB, //DBTables,
  DBCtrls, SMALL_DBEdit, IniFiles, Unit2, FileCtrl, Unit22, Unit7, md5,
  StrUtils
  , udarumaframeworkclass;

(*
  // Declarar as funções da dll usando loadlibary evitando conflito com sat dimep
const DARUMA_DLLNAME_17 = 'DarumaFramework.dll';

type
  TDarumaFramework = class(TComponent)
    private
      DLL: THandle;
      _regAlterarValor_Daruma: function(pszPathChave:String; pszValor:String): Integer; StdCall;
      _regRetornaValorChave_DarumaFramework: function(pszProduto: String; pszChave: String; pszValor: String): Integer; StdCall;

      // Funções de Inicialização
      _confCadastrar_ECF_Daruma: function(pszCadastrar: String; pszValor: String; pszSeparador: String): Integer; StdCall;
      _confHabilitarHorarioVerao_ECF_Daruma: function(): Integer; StdCall;
      _confProgramarAvancoPapel_ECF_Daruma: function(pszSepEntreLinhas: String; pszSepEntreDoc: String; pszLinhasGuilhotina: String; pszGuilhotina: String; pszImpClicheAntecipada: String): Integer; StdCall;
      // Funções do Cupom Fiscal
      _iCFAbrir_ECF_Daruma: function(pszCPF: String; pszNome: String; pszEndereco: String):Integer; StdCall;
      _iCFVender_ECF_Daruma: function(pszCargaTributaria: String; pszQuantidade: String; pszPrecoUnitario: String; pszTipoDescAcresc: String; pszValorDescAcresc: String; pszCodigoItem:String; pszUnidadeMedida:String; pszDescricaoItem: String): Integer; StdCall;
      _iCFCancelarUltimoItem_ECF_Daruma:function(): Integer; StdCall;
      _iCFCancelarItem_ECF_Daruma: function(pszNumItemc:String): Integer; StdCall;
      _iCFCancelar_ECF_Daruma: function(): Integer; StdCall;
      _iCFEncerrarResumido_ECF_Daruma: function(): Integer; StdCall;
      _iCFEncerrar_ECF_Daruma: function(pszCupomAdicional: String; pszMensagem: String):Integer; StdCall;
      _iCFTotalizarCupom_ECF_Daruma: function(pszTipoDescAcresc: String; pszValorDescAcresc: String): Integer; StdCall;
      _iCFEfetuarPagamentoFormatado_ECF_Daruma: function(pszFormaPgto: String; pszValor: String): Integer; StdCall;
      _iCFEfetuarPagamento_ECF_Daruma: function(pszFormaPgto: String; pszValor: String; pszInfoAdicional: String): Integer; StdCall;
      _iCFEncerrarConfigMsg_ECF_Daruma: function(pszMensagem: String): Integer; StdCall;
      _iCFIdentificarConsumidor_ECF_Daruma: function(pszNome: String; pszEndereco: String; pszDoc: String): Integer; StdCall;
      _iEstornarPagamento_ECF_Daruma: function(pszFormaPgtoEstornado: String; pszFormaPgtoEfetivado: String; pszValor: String; pszInfoAdicional: String): Integer; StdCall;

      // Funções dos Relatórios Fiscais
      _iLeituraX_ECF_Daruma: function(): Integer; StdCall;
      _iReducaoZ_ECF_Daruma: function(pszData: String; pszHora: String): Integer; StdCall;
      _iRGImprimirTexto_ECF_Daruma: function(pszTexto: String): Integer; StdCall;
      _iRGFechar_ECF_Daruma: function(): Integer; StdCall;
      _iMFLer_ECF_Daruma: function(pszInicial: String; pszFinal: String): Integer; StdCall;
      _iMFLerSerial_ECF_Daruma: function(pszInicial:string; pszFinal:string): Integer; StdCall;
      _rGerarEspelhoMFD_ECF_Daruma: function(pszTipo: String; pszInicial: String; pszFinal: String): Integer; StdCall;

      // Funções das Operações Não Fiscais
      _iCNFReceberSemDesc_ECF_Daruma: function(pszIndice: String; pszValor: String): Integer; StdCall;
      _iCCDAbrirSimplificado_ECF_Daruma: function(pszFormaPgto:String; pszParcelas:String; pszDocOrigem:String; pszValor:String): Integer; StdCall;
      _iCCDImprimirTexto_ECF_Daruma: function(pszTexto: String): Integer; StdCall;
      _iCCDFechar_ECF_Daruma: function(): Integer; StdCall;
      _iSangria_ECF_Daruma: function(pszValor: String; pszMensagem: String): Integer; StdCall;
      _iSuprimento_ECF_Daruma: function(pszValor: String; pszMensagem: String): Integer; StdCall;

      // Funções de Informações da Impressora
      _rRetornarInformacao_ECF_Daruma: function(pszIndice: String; pszRetornar: String): Integer; StdCall;
      _rCFSubTotal_ECF_Daruma: function(pszValor: String):Integer; StdCall;
      _rLeituraX_ECF_Daruma: function():Integer; StdCall;
      _rStatusImpressoraBinario_ECF_Daruma: function(pszStatus: String):Integer; StdCall;
      _rCFVerificarStatus_ECF_Daruma: function(pszStatus: String; var piStatus: Integer): Integer; StdCall;
      _rDataHoraImpressora_ECF_Daruma: function(pszData: String; pszHora: String): Integer; StdCall;
      _regRetornaValorChave_Daruma: function(pszProduto: String; pszChave: String; pszValor: String):Integer; StdCall;
      _rLerAliquotas_ECF_Daruma: function(cAliquotas: String): Integer; StdCall;
      _rLerDecimais_ECF_Daruma: function(pszDecimalQtde: String; pszDecimalValor: String; var piDecimalQtde: Integer; var piDecimalValor: Integer): Integer; StdCall;
      _rRetornarDadosReducaoZ_ECF_Daruma: function(pszRetorno: String): Integer; StdCall;

      // Funções de Autenticação e Gaveta de Dinheiro
      _eAbrirGaveta_ECF_Daruma: function(): Integer; StdCall;
      _rStatusGaveta_ECF_Daruma: function(var piStatusGaveta: Integer): Integer; StdCall;

      // Outras Funções
      _rStatusUltimoCmdInt_ECF_Daruma: function(var piErro:integer;var piAviso:integer): Integer; StdCall;
      _eRetornarAvisoErroUltimoCMD_ECF_Daruma: function(pszAviso: String; pszErro: String): Integer; StdCall;
      _rGerarMapaResumo_ECF_Daruma: function(): Integer; StdCall;
      _iRelatorioConfiguracao_ECF_Daruma: function(): Integer; StdCall;
      _rVerificarImpressoraLigada_ECF_Daruma: function(): Integer; StdCall;

      //funcoes de TEF
      _iTEF_ImprimirResposta_ECF_Daruma: function(szArquivo:String; bTravarTeclado:Boolean):Integer; StdCall;
      _iTEF_Fechar_ECF_Daruma: function(): Integer; StdCall;
      //
      _rCodigoModeloFiscal_ECF_Daruma: function(pszValor:string): Integer; StdCall;
      //
      //
      _iRGAbrir_ECF_Daruma: function(pszNomeRG:String): Integer; StdCall;
      _rGerarRelatorio_ECF_Daruma: function(szRelatorio:string; szTipo:string; szInicial:string; szFinal:string): Integer; StdCall;
  		_rEfetuarDownloadMF_ECF_Daruma: function(pszNomeArquivo: String): Integer; StdCall;
      _rEfetuarDownloadMFD_ECF_Daruma: function(pszTipo: String; pszInicial: String; pszFinal: String; pszNomeArquivo: String): Integer; StdCall;
      _rVerificarReducaoZ_ECF_Daruma: function(zPendente: String): Integer; StdCall;
      FLoad: Boolean;
      FErroUltimoComando: Integer;
      FDescErroUltimoComando: String;
      FAvisoUltimoComando: Integer;
      FDescAvisoUltimoComando: String;
      //FProtocoloUnico: String;
      procedure Import(var Proc: pointer; Name: Pchar);
      procedure SetFErroUltimoComando(const Value: Integer);
      procedure SetDescErroUltimoComando(const Value: String);
      procedure SetFAvisoUltimoComando(const Value: Integer);
      procedure SetFDescAvisoUltimoComando(const Value: String);
    public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      property Load: Boolean read FLoad;
      property ErroUltimoComando: Integer read FErroUltimoComando write SetFErroUltimoComando;
      property DescErroUltimoComando: String read FDescErroUltimoComando write SetDescErroUltimoComando;
      property AvisoUltimoComando: Integer read FAvisoUltimoComando write SetFAvisoUltimoComando;
      property DescAvisoUltimoComando: String read FDescAvisoUltimoComando write SetFDescAvisoUltimoComando;

      function CarregaDLL: Boolean;
      procedure FinalizaDLL;

      function Daruma_Registry_Ler_Configuracao(sProduto: String; sChave: String): String;
      function Daruma_Registry_AplMensagem1(AplMsg1: String): Integer;
      function Daruma_Registry_AplMensagem2(AplMsg1: String): Integer;
      //
      function Daruma_Registry_MFD_LeituraMFCompleta( Valor: String ): Integer;
      function Daruma_Registry_Porta(Porta: String ): Integer;
      function Daruma_Registry_Path(Path: String; Stipo: String): Integer;
      function Daruma_Registry_Status(Status: String ): Integer;
      function Daruma_Registry_StatusFuncao(StatusFuncao: String ): Integer;
      function Daruma_Registry_Retorno(Retorno: String ): Integer;
      function Daruma_Registry_ControlePorta(ControlePorta: String ): Integer;
      function Daruma_Registry_ModoGaveta(ModoGaveta: String ): Integer;
      function Daruma_Registry_Log(Log: String ): Integer;
      function Daruma_Registry_NomeLog(NomeLog: String ): Integer;
      function Daruma_Registry_Separador(Separador: String ): Integer;
      function Daruma_Registry_SeparaMsgPromo(SeparaMsgPromo: String ): Integer;
      function Daruma_Registry_Emulador(Emulador: String ): Integer;
      function Daruma_Registry_ConfigRede(ConfigRede: String ): Integer;
      function Daruma_Registry_VendeItemUmaLinha(ConfigRede: String ): Integer;

      // Funções de Inicialização
      function Daruma_FI_AlteraSimboloMoeda( SimboloMoeda: String ): Integer;
      function Daruma_FI_ProgramaAliquota( Aliquota: String; ICMS_ISS: Integer ): Integer;
      function Daruma_FI_ProgramaHorarioVerao: Integer;
      function Daruma_FI_NomeiaDepartamento( Indice: Integer; Departamento: String ): Integer;
      function Daruma_FI_NomeiaTotalizadorNaoSujeitoIcms( Indice: Integer; Totalizador: String ): Integer;
      function Daruma_FI_ProgramaArredondamento: Integer;
      function Daruma_FI_ProgramaTruncamento: Integer;
      function Daruma_FI_LinhasEntreCupons( Linhas: Integer ): Integer;
      function Daruma_FI_EspacoEntreLinhas( Dots: Integer ): Integer;
      function Daruma_FI_ForcaImpactoAgulhas( ForcaImpacto: Integer ): Integer;
      function Daruma_FI_ProgramaFormasPagamento( Formas: String ): Integer;
      // Funções do Cupom Fiscal
      function Daruma_FI_AbreCupom( CGC_CPF: String ): Integer;
      function Daruma_FI_VendeItem(Aliquota: String; Quantidade: String; ValorUnitario: String; TipoDesconto: String; Desconto: String; Codigo: String; UnidadeMedida: String; DescricaoItem: String): Integer;
      function Daruma_FI_VendeItemTresDecimais(Codigo: String; Descricao: String; Aliquota: String; Quantidade: String; ValorUnitario: String; TipoDesconto: String; Desconto: String; UnidadeMedida: String): Integer;
      function Daruma_FI_VendeItemDepartamento(Codigo: String; Descricao: String; Aliquota: String; Quantidade: String; ValorUnitario: String; TipoDesconto: String; Desconto: String; UnidadeMedida: String): Integer;
      function Daruma_FI_VendeItem1Lin13Dig( Codigo: String; Descricao: String; Aliquota: String; Quantidade: String;  ValorUnitario: String; Acrescimo_Desconto: String; Percentual : String): Integer;
      function Daruma_FI_CancelaItemAnterior: Integer;
      function Daruma_FI_CancelaItemGenerico( NumeroItem: String ): Integer;
      function Daruma_FI_CancelaCupom: Integer;
      function Daruma_FI_FechaCupomResumido( FormaPagamento: String; Mensagem: String ): Integer;
      function Daruma_FI_FechaCupom( FormaPagamento: String; AcrescimoDesconto: String; TipoAcrescimoDesconto: String; ValorAcrescimoDesconto: String; ValorPago: String; Mensagem: String): Integer;
      function Daruma_FI_ResetaImpressora: Integer;
      function Daruma_FI_IniciaFechamentoCupom( AcrescimoDesconto: String; TipoAcrescimoDesconto: String; ValorAcrescimoDesconto: String ): Integer;
      function Daruma_FI_EfetuaFormaPagamento( FormaPagamento: String; ValorFormaPagamento: String ): Integer;
      function Daruma_FI_EfetuaFormaPagamentoDescricaoForma( FormaPagamento: string; ValorFormaPagamento: string; DescricaoFormaPagto: string ): integer;
      function Daruma_FI_TerminaFechamentoCupom( Mensagem: String): Integer;
      function Daruma_FI_IdentificaConsumidor( Nome: String;Endereco: String; Doc: String): Integer;
      function Daruma_FI_EstornoFormasPagamento( FormaOrigem: String; FormaDestino: String; Valor: String ): Integer;
      function Daruma_FI_UsaUnidadeMedida( UnidadeMedida: String ): Integer;
      function Daruma_FI_AumentaDescricaoItem( Descricao: String ): Integer;
      // Funções dos Relatórios Fiscais
      function Daruma_FI_LeituraX: Integer;
      function Daruma_FI_ReducaoZ( Data: String; Hora: String ): Integer;
      function Daruma_FI_RelatorioGerencial( Texto: String ): Integer;
      function Daruma_FI_FechaRelatorioGerencial: Integer;
      function Daruma_FI_LeituraMemoriaFiscalData( DataInicial: String; DataFinal: String ): Integer;
      function Daruma_FI_LeituraMemoriaFiscalReducao( ReducaoInicial: String; ReducaoFinal: String ): Integer;
      function Daruma_FI_LeituraMemoriaFiscalSerialData( DataInicial: String; DataFinal: String ): Integer;
      function Daruma_FI_LeituraMemoriaFiscalSerialReducao( ReducaoInicial: String; ReducaoFinal: String ): Integer;
      function Daruma_FIMFD_DownloadDaMFD(CoInicial: String; CoFinal: String ): Integer;
      function Daruma_EspelhoMFD(Inicial, Final: String): Integer;
      function Daruma_DownloadMF(sArquivo: String): Integer;
      function Daruma_DownloadMFD(COOInicial: String; COOFinal: String; sArquivo: String; Tipo: String = 'COO'): Integer;

      // Funções das Operações Não Fiscais
      function Daruma_FI_RecebimentoNaoFiscal( IndiceTotalizador: String; Valor: String; FormaPagamento: String ): Integer;
      function Daruma_FI_AbreComprovanteNaoFiscalVinculado( FormaPagamento: String; Valor: String; NumeroCupom: String ): Integer;
      function Daruma_FI_UsaComprovanteNaoFiscalVinculado( Texto: String ): Integer;
      function Daruma_FI_FechaComprovanteNaoFiscalVinculado: Integer;
      function Daruma_FI_Sangria( Valor: String ): Integer;
      function Daruma_FI_Suprimento( Valor: String; FormaPagamento: String ): Integer;
      // Funções de Informações da Impressora
      function Daruma_FI_StatusCupomFiscal( StatusRel: String ): Integer;
      function Daruma_FI_StatusComprovanteNaoFiscalVinculado( StatusRel: String ): Integer;
      function Daruma_FI_StatusRelatorioGerencial( StatusRel: String ): Integer;
      function Daruma_FI_NumeroSerie( NumeroSerie: String ): Integer;
      function Daruma_FI_SubTotal(var SubTotal: String ): Integer;
      function Daruma_FI_NumeroCupom( NumeroCupom: String ): Integer;
      function Daruma_FI_RetornaGNF( GNF: String ): Integer;
      function Daruma_FI_LeituraXSerial: Integer;
      function Daruma_FI_VersaoFirmware( VersaoFirmware: String ): Integer;
      function Daruma_FI_CGC_IE( CGC: String; IE: String ): Integer;
      function Daruma_FI_GrandeTotal(GrandeTotal: String ): Integer;
      function Daruma_FI_VendaBruta( VendaBruta: String ): Integer;
      function Daruma_FI_Cancelamentos( ValorCancelamentos: String ): Integer;
      function Daruma_FI_Descontos( ValorDescontos: String ): Integer;
      function Daruma_FI_NumeroOperacoesNaoFiscais( NumeroOperacoes: String ): Integer;
      function Daruma_FI_NumeroCuponsCancelados( NumeroCancelamentos: String ): Integer;
      function Daruma_FI_NumeroIntervencoes( NumeroIntervencoes: String ): Integer;
      function Daruma_FI_NumeroReducoes( NumeroReducoes: String ): Integer;
      function Daruma_FI_NumeroSubstituicoesProprietario( NumeroSubstituicoes: String ): Integer;
      function Daruma_FI_UltimoItemVendido( NumeroItem: String ): Integer;
      function Daruma_FI_ClicheProprietarioEx( ClicheEx: String ): Integer;
      function Daruma_FI_NumeroCaixa( NumeroCaixa: String ): Integer;
      function Daruma_FI_NumeroLoja( NumeroLoja: String ): Integer;
      function Daruma_FI_SimboloMoeda( SimboloMoeda: String ): Integer;
      function Daruma_FI_MinutosLigada( Minutos: String ): Integer;
      function Daruma_FI_MinutosImprimindo( Minutos: String ): Integer;
      function Daruma_FI_VerificaModoOperacao( Modo: string ): Integer;
      function Daruma_FI_VerificaEpromConectada( Flag: String ): Integer;
      function Daruma_FI_FlagsFiscais( Var Flag: Integer ): Integer;
      function Daruma_FI_ValorPagoUltimoCupom( ValorCupom: String ): Integer;
      function Daruma_FI_DataHoraImpressora( Data: String; Hora: String ): Integer;
      function Daruma_FI_ContadoresTotalizadoresNaoFiscais( Contadores: String ): Integer;
      function Daruma_FI_VerificaTotalizadoresNaoFiscais( Totalizadores: String ): Integer;
      function Daruma_FI_DataHoraReducao( Data: String; Hora: String ): Integer;
      function Daruma_FI_DataMovimento( Data: String ): Integer;
      function Daruma_FI_VerificaTruncamento( Flag: string ): Integer;
      function Daruma_FI_Acrescimos( ValorAcrescimos: String ): Integer;
      function Daruma_FI_ContadorBilhetePassagem( ContadorPassagem: String ): Integer;
      function Daruma_FI_VerificaAliquotasIss( Flag: String ): Integer;
      function Daruma_FI_VerificaFormasPagamento( Formas: String ): Integer;
      function Daruma_FI_VerificaRecebimentoNaoFiscal( Recebimentos: String ): Integer;
      function Daruma_FI_VerificaDepartamentos( Departamentos: String ): Integer;
      function Daruma_FI_VerificaTipoImpressora( var TipoImpressora: String): Integer;
      function Daruma_FI_VerificaTotalizadoresParciais( Totalizadores: String ): Integer;
      function Daruma_FI_RetornoAliquotas( Aliquotas: String ): Integer;
      function Daruma_FI_DadosUltimaReducao(var DadosReducao: String ): Integer;
      function Daruma_FI_VerificaIndiceAliquotasIss( Flag: String ): Integer;
      function Daruma_FI_ValorFormaPagamento( FormaPagamento: String; Valor: String ): Integer;
      function Daruma_FI_VerificaModeloECF(Modelo: String): Integer;
      // Funções de Autenticação e Gaveta de Dinheiro
      function Daruma_FI_Autenticacao: Integer;
      function Daruma_FI_AutenticacaoStr(str :string): Integer;
      function Daruma_FI_VerificaDocAutenticacao: Integer;
      function Daruma_FI_AcionaGaveta:Integer;
      function Daruma_FI_VerificaEstadoGaveta( Var EstadoGaveta: Integer ): Integer;
      // Outras Funções
      function Daruma_FI_AbrePortaSerial: Integer;
      function Daruma_FI_RetornoImpressora: Integer;
      function Daruma_FI_FechaPortaSerial: Integer;
      function Daruma_FI_MapaResumo:Integer;
      function Daruma_FI_AberturaDoDia( ValorCompra: string; FormaPagamento: string ): Integer;
      function Daruma_FI_FechamentoDoDia: Integer;
      function Daruma_FI_ImprimeConfiguracoesImpressora:Integer;
      function Daruma_FI_ImprimeDepartamentos: Integer;
      function Daruma_FI_RelatorioTipo60Analitico: Integer;
      function Daruma_FI_RelatorioTipo60Mestre: Integer;
      function Daruma_FI_VerificaImpressoraLigada: Integer;
      function Daruma_FI_ImprimeConfiguracoes: Integer;
      function Daruma_FI_VerificaReducaoZ: String;
      //funcoes de TEF
      function Daruma_TEF_ImprimirResposta(Arquivo: String; Travar: Boolean): Integer;
      function Daruma_TEF_FechaRelatorio: Integer;
      //
      function Daruma_FI_VerificaEstadoGavetaStr(iParam1: Integer): Integer;
      function Daruma_FI_FlagsFiscaisStr(sParam1: String): Integer;
      function Daruma_FIMFD_RetornaInformacao( Indice: String; Valor: String ): Integer;
      function Daruma_FIMFD_CodigoModeloFiscal(Valor: String): Integer;
      //
      function Daruma_RFD_GerarArquivo(DataInicial: String; DataFinal: String): Integer;
      //
      function Daruma_FIMFD_ProgramaRelatoriosGerenciais( NomeRelatorio: String ): Integer;
      function Daruma_FIMFD_AbreRelatorioGerencial( NomeRelatorio: String ): Integer;
      function Daruma_FIMFD_GerarAtoCotepePafData(Relatorio: String; Tipo: String; DataInicial: String; DataFinal: String): Integer;
      function Daruma_FIMFD_GerarAtoCotepePafCOO(Relatorio: String; Tipo: String; COOIni: String; COOFim: String): Integer;
      function Daruma_FI_LerCasasDecimais(var iDecimalQtd: Integer;
        var iDecimalUnitario: Integer): Integer;
      ////////////////////////////
  end;
*)

  {Sandro Silva 2015-06-18 final}

  //
  //
  function _ecf17_CodeErro(Pp1: Integer):Integer;
  function _ecf17_Inicializa(Pp1: String):Boolean;
  function _ecf17_FechaCupom(Pp1: Boolean):Boolean;
  function _ecf17_Pagamento(Pp1: Boolean):Boolean;
  function _ecf17_CancelaUltimoItem(Pp1: Boolean):Boolean;
  function _ecf17_SubTotal(Pp1: Boolean):Real;
  function _ecf17_AbreGaveta(Pp1: Boolean):Boolean;
  function _ecf17_Sangria(Pp1: Real):Boolean;
  function _ecf17_Suprimento(Pp1: Real):Boolean;
  function _ecf17_NovaAliquota(Pp1: String):Boolean;
  function _ecf17_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
  function _ecf17_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
  function _ecf17_CancelaUltimoCupom(Pp1: Boolean):Boolean;
  function _ecf17_AbreNovoCupom(Pp1: Boolean):Boolean;
  function _ecf17_NumeroDoCupom(Pp1: Boolean):String;
  function _ecf17_CancelaItemN(pP1, pP2: String):Boolean;
  function _ecf17_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
  function _ecf17_ReducaoZ(pP1: Boolean):Boolean;
  function _ecf17_LeituraX(pP1: Boolean):Boolean;
  function _ecf17_RetornaVerao(pP1: Boolean):Boolean;
  function _ecf17_LigaDesLigaVerao(pP1: Boolean):Boolean;
  function _ecf17_VersodoFirmware(pP1: Boolean): String;
  function _ecf17_NmerodeSrie(pP1: Boolean): String;
  function _ecf17_CGCIE(pP1: Boolean): String;
  function _ecf17_Cancelamentos(pP1: Boolean): String;
  function _ecf17_Descontos(pP1: Boolean): String;
  function _ecf17_ContadorSeqencial(pP1: Boolean): String;
  function _ecf17_Nmdeoperaesnofiscais(pP1: Boolean): String;
  function _ecf17_NmdeCuponscancelados(pP1: Boolean): String;
  function _ecf17_NmdeRedues(pP1: Boolean): String;
  function _ecf17_Nmdeintervenestcnicas(pP1: Boolean): String;
  function _ecf17_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
  function _ecf17_Clichdoproprietrio(pP1: Boolean): String;
  function _ecf17_NmdoCaixa(pP1: Boolean): String;
  function _ecf17_Nmdaloja(pP1: Boolean): String;
  function _ecf17_Moeda(pP1: Boolean): String;
  function _ecf17_Dataehoradaimpressora(pP1: Boolean): String;
  function _ecf17_Datadaultimareduo(pP1: Boolean): String;
  function _ecf17_Datadomovimento(pP1: Boolean): String;
  function _ecf17_StatusGaveta(Pp1: Boolean):String;
  function _ecf17_RetornaAliquotas(pP1: Boolean): String;
  function _ecf17_Vincula(pP1: String): Boolean;
  function _ecf17_FlagsDeISS(pP1: Boolean): String;
  function _ecf17_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
  function _ecf17_MudaMoeda(pP1: String): Boolean;
  function _ecf17_MostraDisplay(pP1: String): Boolean;
  function _ecf17_leituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
  function _ecf17_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean;
  function _ecf17_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
  function _ecf17_FechaCupom2(sP1: Boolean): Boolean;
  function _ecf17_ImprimeCheque(rP1: Real; sP2: String): Boolean;
  function _ecf17_MapaResumo(sP1: Boolean): Boolean;
  function _ecf17_GrandeTotal(sP1: Boolean): String;
  function _ecf17_TotalizadoresDasAliquotas(sP1: Boolean): String;
  function _ecf17_CupomAberto(sP1: Boolean): boolean;
  function _ecf17_FaltaPagamento(sP1: Boolean): boolean;
  //
  // PAF
  //
  function _ecf17_Marca(sP1: Boolean): String;
  function _ecf17_Modelo(sP1: Boolean): String;
  function _ecf17_Tipodaimpressora(pP1: Boolean): String;
  function _ecf17_VersaoSB(pP1: Boolean): String; //
  function _ecf17_HoraIntalacaoSB(pP1: Boolean): String; //
  function _ecf17_DataIntalacaoSB(pP1: Boolean): String; //
  function _ecf17_ProgramaAplicativo(sP1: Boolean): boolean;
  //
  function _ecf17_DadosDaUltimaReducao(pP1: Boolean): String; //
  function _ecf17_CodigoModeloEcf(pP1: Boolean): String; //
  function _ecf17_DataHoraUltimaReducao: String;
  //
  // Contadores
  //
  function _ecf17_GNF(Pp1: Boolean):String;
  function _ecf17_GRG(Pp1: Boolean):String;
  function _ecf17_CDC(Pp1: Boolean):String;
  function _ecf17_CCF(Pp1: Boolean):String;
  function _ecf17_CER(Pp1: Boolean):String;

var
  _ecf17: TDarumaFramework;

implementation

// ---------------------------------- //
// Tratamento de erros da IF DARUMA   //
// ---------------------------------- //
function _ecf17_CodeErro(Pp1: Integer): Integer;
var
  //Daruma_iACK, Daruma_iST1, Daruma_iST2: Integer;
  //sRetorno, sMensagem: String;
  sMensagem: String;
begin
  //
  //Result               := 0;
  if _ecf17.AvisoUltimoComando = 1  then // Pouco Papel
  begin //2015-11-02
    if Form1.Memo3.Visible then
    begin
      Form1.Panel2.Visible := True;
      Form1.Panel2.BringToFront;
    end;
  end;

  case Pp1 of
     0:   sMensagem := 'Erro durante a execução.';
     1:   sMensagem := 'Operação realizada com sucesso.';
    -1:   sMensagem := 'Erro do Método.';
    -2:   sMensagem := 'Parâmetro incorreto.';
    -3:   sMensagem := 'Alíquota (Situação tributária) não programada.';
    -4:   sMensagem := 'Chave do Registry não encontrada.';
    -5:   sMensagem := 'Erro ao Abrir a porta de Comunicação.';
    -6:   sMensagem := 'Impressora Desligada.';
    -7:   sMensagem := 'Erro no Número do Banco.';
    -8:   sMensagem := 'Erro ao Gravar as informações no arquivo de Status ou de Retorno de Info.';
    -9:   sMensagem := 'Erro ao Fechar a porta de Comunicação.';
    -10:  sMensagem := 'O ECF não tem a forma de pagamento e não permite cadastrar esta forma.';
    -12:  sMensagem := 'A função executou o comando porém o ECF sinalizou Erro, chame a rStatusUltimoCmdInt_ECF_Daruma para identificar o Erro.';
    -24:  sMensagem := 'Forma de Pagamento não Programada.';
    -25:  sMensagem := 'Totalizador nao ECF Não Vinculado não Programado.';
    -27:  sMensagem := 'Foi Detectado Erro ou Warning na Impressora.';
    -28:  sMensagem := 'Time-Out.';
    -40:  sMensagem := 'Tag XML Inválida.';
    -50:  sMensagem := 'Problemas ao Criar Chave no Registry.';
    -51:  sMensagem := 'Erro ao Gravar LOG.';
    -52:  sMensagem := 'Erro ao abrir arquivo.';
    -53:  sMensagem := 'Fim de arquivo.';
    -60:  sMensagem := 'Erro na tag de formatação DHTML.';
    -90:  sMensagem := 'Erro Configurar a Porta de Comunicação.';
    -99:  sMensagem := 'Parâmetro inválido ou ponteiro nulo de parâmetro.';
    -101: sMensagem := 'Erro ao LER ou ESCREVER arquivo.';
    -102: sMensagem := 'Erro ao LER ou ESCREVER arquivo.';
    {$IFDEF LINUX}
     -103: sMensagem := 'Não foram encontradas as bibliotecas auxiliares (liblebin.so e libLeituraMFDBin.so)';
    {$ELSE}
     -103: sMensagem := 'Não foram encontradas as DLLs auxiliares (lebin.dll e LeituraMFDBin.dll)';
    {$ENDIF}
    -104: sMensagem := 'Data informada é inferior ao primeiro documento emitido';
    -105: sMensagem := 'Data informada é maior que a ultima redução Z impressa';
    -106: sMensagem := 'Nao possui movimento fiscal';
    -107: sMensagem := 'Porta de comunicação ocupada';
    -110: sMensagem := 'Indica que o GT foi atualizado no arquivo de registro do PAF';
    -112: sMensagem := 'O numero de serie ja existe no arquivo do PAF';
    -113: sMensagem := 'ECF conectado nao cadastrado no arquivo do PAF';
    -114: sMensagem := 'MFD Danificada';
    -115: sMensagem := 'Erro ao abrir arquivos .idx/.dat/.mf';
    -116: sMensagem := 'Intervalo solicitado não é válido';
    -117: sMensagem := 'Impressora não identificada durante download dos binários';
    -118: sMensagem := 'Erro ao abrir porta serial';
    -119: sMensagem := 'Leitura dos binários abortada';
  else
    sMensagem := 'Erro desconhecido.'
                + chr(10)
                + chr(10) + 'Verifique:'
                + chr(10)
                + chr(10) + '1. Impressora desligada.'
                + chr(10) + '2. Cabo não conectado.'
                + chr(10) + '3. Porta de comunicação inválida.'
                + chr(10) + '4. Chame um técnico habilitado.'
                + chr(10)
                + chr(10);
  end;
  //

  if pP1 <> 1 then
  begin
    if pP1 = 0 then //Erro de comunicação, a Função nao conseguir enviar o comando.
    begin
      ShowMessage('Erro de comunicação física: '
                + chr(10)
                + chr(10) + 'Verifique:'
                + chr(10)
                + chr(10) + '1. Impressora desligada.'
                + chr(10) + '2. Cabo não conectado.'
                + chr(10) + '3. Porta de comunicação inválida.'
                + chr(10) + '4. Chame um técnico habilitado.'
                + chr(10)
                + chr(10));
       Result := 99;
    end
    else
    begin
      ShowMessage(sMensagem);
      Result := 0;
    end;
  end
  else
  begin
    Result := 1;
  end;
  //
  if _ecf17.ErroUltimoComando <> 0 then
  begin //2015-11-02
    //if _ecf17.ErroUltimoComando <> 88 then // 88	RZ do movimento anterior pendente
    //  ShowMessage(_ecf17.DescErroUltimoComando);
    Result := 0;
  end;
end;

// ----------------------------//
// Detecta qual a porta que    //
// a impressora está conectada //
// DARUMA                      //
// --------------------------- //
function _ecf17_Inicializa(Pp1: String):Boolean;
var
  I, Retorno : Integer;
//  sFormasPagamento: string;
//  Mais1ini : tIniFile;
  sString : String;
begin
  if _ecf17 = nil then
  begin
    _ecf17 := TDarumaFramework.Create(nil); // Sandro Silva 2020-09-02 _ecf17 := TDarumaFramework.Create(Application);
    //ShowMessage(_ecf17.Daruma_Registry_Ler_Configuracao('ECF', 'Habilitar'));
  end;

  Result := False;
  if _ecf17.Load then
  begin
    //
    sString := Replicate(' ',15);
    if Copy(pP1,1,3) <> 'COM' then pP1 := 'COM1';
    //
    // Daruma_Registry_ControlePorta('0');
    // Daruma_FI_AbrePortaSerial
    //
    //
    if Form22.Label6.Caption = 'Detectando porta de comunicação...' then
    begin
      //
      // 2015-09-30 _ecf17.Daruma_Registry_Porta(pchar(pP1));

      //Retorno := _ecf17.Daruma_FI_VerificaImpressoraLigada;

      //ShowMessage('Teste 1 ' + IntToStr(retorno));

      sString := Replicate(' ',21); // Conf.Tabela Consulta as Informações do ECF
      Retorno := _ecf17.Daruma_FI_NumeroSerie(sString);
      //
      if Retorno <> 1 then
      begin
        // 2015-11-10 for I := 1 to 7 do
        for I := 1 to 20 do
        begin
          if Retorno <> 1 then
          begin
            Application.ProcessMessages;
            Application.BringToFront;
            ShowMessage('DARUMA'+Chr(10)+'Testando COM'+StrZero(I,1,0));
            _ecf17.Daruma_Registry_Porta('COM'+StrZero(I,1,0)); // Sandro Silva 2020-09-02 _ecf17.Daruma_Registry_Porta(pchar('COM'+StrZero(I,1,0))); 
            Retorno := _ecf17.Daruma_FI_NumeroSerie(sString);
            if Retorno = 1 then
              Form1.sPorta := 'COM'+StrZero(I,1,0);
          end;
        end;
      end;
      //
      if Retorno = 1 then
        Result := True
      else
        Result := False;

      _ecf17.Daruma_FI_ProgramaFormasPagamento('Dinheiro');
      _ecf17.Daruma_FI_ProgramaFormasPagamento('Cheque');
      _ecf17.Daruma_FI_ProgramaFormasPagamento('Cartao');
      _ecf17.Daruma_FI_ProgramaFormasPagamento('Prazo');
      //
    end
    else
      Result := True;
    //
    _ecf17.Daruma_FIMFD_ProgramaRelatoriosGerenciais('IDENT DO PAF');
    _ecf17.Daruma_FIMFD_ProgramaRelatoriosGerenciais('MEIOS DE PAGTO');
    _ecf17.Daruma_FIMFD_ProgramaRelatoriosGerenciais('VENDA PRAZO');
    _ecf17.Daruma_FIMFD_ProgramaRelatoriosGerenciais('DAV Emitidos');
    _ecf17.Daruma_FIMFD_ProgramaRelatoriosGerenciais('CARTAO TEF');
    _ecf17.Daruma_FIMFD_ProgramaRelatoriosGerenciais('Orcamento');
    _ecf17.Daruma_FIMFD_ProgramaRelatoriosGerenciais('CONF CONTA CLI');// 2016-02-04 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
    _ecf17.Daruma_FIMFD_ProgramaRelatoriosGerenciais('TRANSF CONT CLI');// 2016-02-11 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
    _ecf17.Daruma_FIMFD_ProgramaRelatoriosGerenciais('CONT CLI ABERTA');// 2016-02-11 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
    _ecf17.Daruma_FIMFD_ProgramaRelatoriosGerenciais('CONF MESA');
    _ecf17.Daruma_FIMFD_ProgramaRelatoriosGerenciais('TRANSF MESA');
    _ecf17.Daruma_FIMFD_ProgramaRelatoriosGerenciais('MESAS ABERTAS');
    _ecf17.Daruma_FIMFD_ProgramaRelatoriosGerenciais('PARAM CONFIG');
    //

   if _ecf17.Daruma_FI_VerificaReducaoZ = '1' then
     ShowMessage('Redução Z pendente');
  end; //if _ecf17.Load then
end;

// ------------------------------ //
// Fecha o cupom que está sendo   //
// emitido                        //
// IF DARUMA FS 345               //
// ------------------------------ //
function _ecf17_FechaCupom(Pp1: Boolean):Boolean;
begin
  // -------------------- //
  // Fecha o cupom fiscal //
  // -------------------- //
  if Form1.fTotal <> 0 then
  begin
    if Form1.fTotal >= Form1.ibDataSet25RECEBER.AsFloat then
    begin
      _ecf17_CodeErro(_ecf17.Daruma_FI_IniciaFechamentoCupom('D','D$',StrZero((Form1.fTotal-Form1.ibDataSet25RECEBER.AsFloat)*100,14,0)));
    end else
    begin
      _ecf17_CodeErro(_ecf17.Daruma_FI_IniciaFechamentoCupom('A','A$',StrZero((Form1.ibDataSet25RECEBER.AsFloat-Form1.fTotal)*100,14,0)));
    end;
    //
    Result := True;
    // else Result := False;
    //
  end else Result := False;
  //
  // CURITIBA
  // claudenir - 55 11 8137 0262
  // Alechandre ou Cristian
  // REgedit Log = 1
  // suporte@daruma.com.br
  // Leandro
  // 8:30 1 as 5:30
  // (0xx41)33616076
  //
  // DARUMA  FS 345 FS 600
  //
end;

// ------------------------------ //
// Fecha o cupom que está sendo   //
// emitido                        //
// IF DARUMA FS 345               //
// ------------------------------ //
function _ecf17_Pagamento(Pp1: Boolean):Boolean;
var
  //iForma: Integer;
  sCNPJCPF: String;
  sNomeCliente: String;
  sEndereco1: String;
  sEndereco2: String;
begin
  sCNPJCPF     := Form2.Edit2.Text;
  sNomeCliente := Form2.Edit8.Text;
  sEndereco1   := Form2.Edit1.Text;
  sEndereco2   := Form2.Edit3.Text;

  if (AllTrim(Form2.Edit8.Text) <> '') and (AllTrim(Form2.Edit2.Text) = '') then
  begin
    //Result := False;
    //Showmessage('Informe o CPF/CNPJ do cliente');
    sNomeCliente := '';
    sEndereco1   := '';
    sEndereco2   := '';
  end;

  //
  Sleep(200);
  //
  {Sandro Silva 2020-09-02 inicio
  if Form1.ibDataSet25ACUMULADO1.AsFloat <> 0 then _ecf17.Daruma_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label9.Caption)), Format('%10.2n',[Form1.ibDataSet25ACUMULADO1.AsFloat]));
  if Form1.ibDataSet25ACUMULADO2.AsFloat <> 0 then _ecf17.Daruma_FI_EfetuaFormaPagamento(pchar('Dinheiro')                   , Format('%10.2n',[Form1.ibDataSet25ACUMULADO2.AsFloat]));
  if Form1.ibDataSet25PAGAR.AsFloat      <> 0 then _ecf17.Daruma_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label8.Caption)), Format('%10.2n',[Form1.ibDataSet25PAGAR.AsFloat])      );
  if Form1.ibDataSet25DIFERENCA_.AsFloat <> 0 then _ecf17.Daruma_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label17.Caption)),Format('%10.2n' ,[Form1.ibDataSet25DIFERENCA_.AsFloat]));
  if Form1.ibDataSet25VALOR01.AsFloat    <> 0 then _ecf17.Daruma_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label18.Caption)),Format('%10.2n',[Form1.ibDataSet25VALOR01.AsFloat])   );
  if Form1.ibDataSet25VALOR02.AsFloat    <> 0 then _ecf17.Daruma_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label19.Caption)),Format('%10.2n',[Form1.ibDataSet25VALOR02.AsFloat])   );
  if Form1.ibDataSet25VALOR03.AsFloat    <> 0 then _ecf17.Daruma_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label20.Caption)),Format('%10.2n',[Form1.ibDataSet25VALOR03.AsFloat])   );
  if Form1.ibDataSet25VALOR04.AsFloat    <> 0 then _ecf17.Daruma_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label21.Caption)),Format('%10.2n',[Form1.ibDataSet25VALOR04.AsFloat])   );
  if Form1.ibDataSet25VALOR05.AsFloat    <> 0 then _ecf17.Daruma_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label22.Caption)),Format('%10.2n',[Form1.ibDataSet25VALOR05.AsFloat])   );
  if Form1.ibDataSet25VALOR06.AsFloat    <> 0 then _ecf17.Daruma_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label23.Caption)),Format('%10.2n',[Form1.ibDataSet25VALOR06.AsFloat])   );
  if Form1.ibDataSet25VALOR07.AsFloat    <> 0 then _ecf17.Daruma_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label24.Caption)),Format('%10.2n',[Form1.ibDataSet25VALOR07.AsFloat])   );
  if Form1.ibDataSet25VALOR08.AsFloat    <> 0 then _ecf17.Daruma_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label25.Caption)),Format('%10.2n',[Form1.ibDataSet25VALOR08.AsFloat])   );
  }
  if Form1.ibDataSet25ACUMULADO1.AsFloat <> 0 then _ecf17.Daruma_FI_EfetuaFormaPagamento(AllTrim(Form2.Label9.Caption), Format('%10.2n',[Form1.ibDataSet25ACUMULADO1.AsFloat]));
  if Form1.ibDataSet25ACUMULADO2.AsFloat <> 0 then _ecf17.Daruma_FI_EfetuaFormaPagamento('Dinheiro'                   , Format('%10.2n',[Form1.ibDataSet25ACUMULADO2.AsFloat]));
  if Form1.ibDataSet25PAGAR.AsFloat      <> 0 then _ecf17.Daruma_FI_EfetuaFormaPagamento(AllTrim(Form2.Label8.Caption), Format('%10.2n',[Form1.ibDataSet25PAGAR.AsFloat])      );
  if Form1.ibDataSet25DIFERENCA_.AsFloat <> 0 then _ecf17.Daruma_FI_EfetuaFormaPagamento(AllTrim(Form2.Label17.Caption),Format('%10.2n',[Form1.ibDataSet25DIFERENCA_.AsFloat]));
  if Form1.ibDataSet25VALOR01.AsFloat    <> 0 then _ecf17.Daruma_FI_EfetuaFormaPagamento(AllTrim(Form2.Label18.Caption),Format('%10.2n',[Form1.ibDataSet25VALOR01.AsFloat])   );
  if Form1.ibDataSet25VALOR02.AsFloat    <> 0 then _ecf17.Daruma_FI_EfetuaFormaPagamento(AllTrim(Form2.Label19.Caption),Format('%10.2n',[Form1.ibDataSet25VALOR02.AsFloat])   );
  if Form1.ibDataSet25VALOR03.AsFloat    <> 0 then _ecf17.Daruma_FI_EfetuaFormaPagamento(AllTrim(Form2.Label20.Caption),Format('%10.2n',[Form1.ibDataSet25VALOR03.AsFloat])   );
  if Form1.ibDataSet25VALOR04.AsFloat    <> 0 then _ecf17.Daruma_FI_EfetuaFormaPagamento(AllTrim(Form2.Label21.Caption),Format('%10.2n',[Form1.ibDataSet25VALOR04.AsFloat])   );
  if Form1.ibDataSet25VALOR05.AsFloat    <> 0 then _ecf17.Daruma_FI_EfetuaFormaPagamento(AllTrim(Form2.Label22.Caption),Format('%10.2n',[Form1.ibDataSet25VALOR05.AsFloat])   );
  if Form1.ibDataSet25VALOR06.AsFloat    <> 0 then _ecf17.Daruma_FI_EfetuaFormaPagamento(AllTrim(Form2.Label23.Caption),Format('%10.2n',[Form1.ibDataSet25VALOR06.AsFloat])   );
  if Form1.ibDataSet25VALOR07.AsFloat    <> 0 then _ecf17.Daruma_FI_EfetuaFormaPagamento(AllTrim(Form2.Label24.Caption),Format('%10.2n',[Form1.ibDataSet25VALOR07.AsFloat])   );
  if Form1.ibDataSet25VALOR08.AsFloat    <> 0 then _ecf17.Daruma_FI_EfetuaFormaPagamento(AllTrim(Form2.Label25.Caption),Format('%10.2n',[Form1.ibDataSet25VALOR08.AsFloat])   );
  {Sandro Silva 2020-09-02 fim}

  if (AllTrim(sNomeCliente)<>'') or (AllTrim(sCNPJCPF)<>'') then
  begin
    _ecf17.Daruma_FI_IdentificaConsumidor(AllTrim(sNomeCliente),AllTrim(sEndereco1)+ ' ' +AllTrim(sEndereco2),AllTrim(sCNPJCPF)); // Identifica o consumidor darumaframework trunca se nome for maior que 30 posições
  end;
  //
  _ecf17.Daruma_FI_TerminaFechamentoCupom('MD5: '+Form1.sMD5DaLista+chr(10)+ConverteAcentos(Form1.sMensagemPromocional));

  //
  Result := True;
  //
end;

// --------------------- //
// Cancela o último item //
// --------------------- //
function _ecf17_CancelaUltimoItem(Pp1: Boolean):Boolean;
begin
  if _ecf17_codeErro(_ecf17.Daruma_FI_CancelaItemAnterior()) = 1 then Result := True else Result := False;
end;

// ---------------------- //
// Cancela o último cupom //
// ---------------------- //
function _ecf17_CancelaUltimoCupom(Pp1: Boolean):Boolean;
begin
  if _ecf17.Daruma_FI_CancelaCupom() = 1 then
    Result := True
  else
  begin
    ShowMessage(_ecf17.DescErroUltimoComando);
    Result := False;
  end;
end;

function _ecf17_SubTotal(Pp1: Boolean):Real;
var
  sSubTotal: string;
begin
  // --------------------- //
  //  Retorno do Subtotal  //
  // --------------------- //
  sSubTotal := Replicate(' ',12);
  //
  if _ecf17.Daruma_FI_SubTotal(sSubTotal) = 1 then
  begin
    //
    Result  := StrToFloat(sSubTotal) / 100;
    if form1.ConfPreco = '1' then Result  := StrToFloat(sSubTotal) / 10;
    if form1.ConfPreco = '2' then Result  := StrToFloat(sSubTotal) / 100;
    if form1.ConfPreco = '3' then Result  := StrToFloat(sSubTotal) / 1000;
    if form1.ConfPreco = '4' then Result  := StrToFloat(sSubTotal) / 10000;
    //
  end
  else
  begin
    Result := 0;
    _ecf17.ErroUltimoComando  := 0;
    _ecf17.AvisoUltimoComando := 0;
    _ecf17.Daruma_FI_RetornoImpressora;
    if _ecf17.ErroUltimoComando <> 0 then
      ShowMessage(_ecf17.DescErroUltimoComando);
  end;
  //
end;

function _ecf17_AbreNovoCupom(Pp1: Boolean):Boolean;
begin
  if _ecf17.Daruma_FI_AbreCupom('') = 1 then
  begin
    _ecf17.ErroUltimoComando  := 0;
    _ecf17.AvisoUltimoComando := 0;
    _ecf17.Daruma_FI_RetornoImpressora;

    {Sandro Silva 2016-08-31 inicio}
    if _ecf17.AvisoUltimoComando = 1 then
      _ecf17_CodeErro(1);
    {Sandro Silva 2016-08-31 final}

    if _ecf17.ErroUltimoComando = 78 then // Cupom aberto
    begin
      // 2015-10-20 Ronei acha que é suficiente passar true aqui
      Result := True;
    end
    else if _ecf17.ErroUltimoComando = 88 then
    begin
      Result := False;
      ShowMessage('Redução Z pendente');
    end
    else if _ecf17.ErroUltimoComando = 89 then
    begin
      Result := False;
      ShowMessage('Já emitiu RZ de hoje');
    end
    else
      Result := True;
  end
  else
    Result := False;
end;

// -------------------------------- //
// Retorna o número do Cupom        //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf17_NumeroDoCupom(Pp1: Boolean):String;
begin
  SetLEngth(Result,6);
  Result := '000000';
  _ecf17_CodeErro(_ecf17.Daruma_FI_NumeroCupom(Result));
  Result := LimpaNumero(Result);
end;


// -------------------------- //
// Retorna o número do CCF    //
// -------------------------- //
function _ecf17_ccF(Pp1: Boolean):String;
begin
  Result := Replicate('0',6);
  _ecf17.Daruma_FIMFD_RetornaInformacao('30',Result);
end;

// ------------------------------------------------------------------------- //
// Retorna o número de operações não fiscais executadas na impressora. GNF   //
// ------------------------------------------------------------------------- //
function _ecf17_gnf(Pp1: Boolean):String;
begin
  SetLEngth(Result,6);
  Result := '000000';
  _ecf17_CodeErro(_ecf17.Daruma_FI_RetornaGNF(Result));
  Result := LimpaNumero(Result);
end;

// ------------------------------------------------------------------------- //
// Retorna o número de operações não fiscais executadas na impressora. CER   //
// ------------------------------------------------------------------------- //
function _ecf17_CER(Pp1: Boolean):String;
begin
  Result := Replicate('0',80);
  // ShowMEssage(Result);
  _ecf17.Daruma_FIMFD_RetornaInformacao('44',Result);
  Result := Copy(Result, 41, 4);
end;

// --------------------------------------- //
// Contador Geral de Relatorio Gerencial   //
// --------------------------------------- //
function _ecf17_GRG(Pp1: Boolean):String;
begin
  Result := Replicate('0',6);
  _ecf17.Daruma_FIMFD_RetornaInformacao('33',Result);
end;

// -------------- //
// Contador CDC   //
// -------------- //
function _ecf17_CDC(Pp1: Boolean):String;
begin
  Result := Replicate('0',4);
  _ecf17.Daruma_FIMFD_RetornaInformacao('45',Result);
  Result := '00'+Result;
end;

// ------------------------------ //
// Cancela um item N              //
// IF DARUMA FS 345               //
// ------------------------------ //
function _ecf17_CancelaItemN(pP1, pP2 : String):Boolean;
begin
  //
  if _ecf17_CodeErro(_ecf17.Daruma_FI_CancelaItemGenerico(StrZero(StrToInt(pP1),4,0))) = 1 then
  begin
    _ecf17.ErroUltimoComando  := 0;
    _ecf17.AvisoUltimoComando := 0;
    _ecf17.Daruma_FI_RetornoImpressora;
    //if iErro <> 0 then
    //  Result := iErro;
    if _ecf17.ErroUltimoComando <> 0 then
    begin
      if _ecf17.ErroUltimoComando = 97 then
        ShowMessage(_ecf17.DescErroUltimoComando);
      Result := False
    end
    else
      Result := True
  end
  else
    Result := False;
  //
end;

// -------------------------------- //
// Abre a gaveta                    //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf17_AbreGaveta(Pp1: Boolean):Boolean;
begin
  _ecf17.Daruma_FI_AcionaGaveta();
  Result := True;
end;

// -------------------------------- //
// Status da gaveta                 //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf17_StatusGaveta(Pp1: Boolean):String;
var
  I : Integer;
begin
  I := 0;
  _ecf17.Daruma_FI_VerificaEstadoGaveta( I );
  //
  //  Showmessage('Status Gaveta = '+ IntToStr(I));
  //
  if Form1.iStatusGaveta = 0 then
  begin
    if I = 1 then
      Result := '000'
    else
      Result := '255' ;
  end else
  begin
    if I = 1 then
      Result := '255'
    else
      Result := '000' ;
  end;
  //
end;

// -------------------------------- //
// SAngria                          //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf17_Sangria(Pp1: Real):Boolean;
begin
  ShowMessage('Sangria de: '+Format('%10.2n',[pP1]));
  if _ecf17_codeErro(_ecf17.Daruma_FI_Sangria(Format('%10.2n',[pP1]))) = 1 then
  begin
    _ecf17.ErroUltimoComando  := 0;
    _ecf17.AvisoUltimoComando := 0;
    _ecf17.Daruma_FI_RetornoImpressora;
    if _ecf17.ErroUltimoComando <> 0 then
    begin
      Result := False;
      ShowMessage(_ecf17.DescErroUltimoComando);
    end
    else
      Result := True
  end
  else
    Result := False;
end;

// -------------------------------- //
// Suprimento                       //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf17_Suprimento(Pp1: Real):Boolean;
begin
  ShowMessage('Suprimento de: '+Format('%10.2n',[pP1]));
  if _ecf17_codeErro(_ecf17.Daruma_FI_Suprimento(Format('%10.2n',[pP1]),'Dinheiro')) = 1 then
  begin
    _ecf17.ErroUltimoComando  := 0;
    _ecf17.AvisoUltimoComando := 0;
    _ecf17.Daruma_FI_RetornoImpressora;
    if _ecf17.ErroUltimoComando <> 0 then
    begin
      Result := False;
      ShowMessage(_ecf17.DescErroUltimoComando);
    end
    else
      Result := True
  end
  else
    Result := False;
end;

// -------------------------------- //
// Inclui uma nova aliquota         //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf17_NovaAliquota(Pp1: String):Boolean;
begin
  if _ecf17_CodeErro(_ecf17.Daruma_FI_ProgramaAliquota(pP1,0)) = 1 then // Sandro Silva 2020-09-02 if _ecf17_CodeErro(_ecf17.Daruma_FI_ProgramaAliquota( pchar( pP1 ),0)) = 1 then 
    Result := True
  else
    Result := False;
end;

function _ecf17_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
var
  I : Integer;
  sArquivoAto1704: String;
begin
  Result := True;// Sandro Silva 2017-08-16 
  if (Form7.sMfd = 'MFPERIODO') or (Form7.sMfd = 'MFDPERIODO') then
  begin // ER 02.05
    // Sandro Silva 2017-08-01

    if Form7.sMfd = 'MFDPERIODO' then
    begin
      DeleteFile(pP1);
      i := _ecf17.Daruma_DownloadMFD(pP2, pP3, pP1, 'DATAM');
      if I = 1 then
      begin
        if FileExists(pP1) then
        begin
          Application.BringToFront;
          Application.ProcessMessages;
          Result := True;
        end
        else
          Result := False;
      end
      else
      begin
        {Sandro Silva 2017-08-24 inicio}
        if FileExists(pP1) then
          DeleteFile(pP1);
        {Sandro Silva 2017-08-24 final}

        Result := False;
      end;
      //
    end
    else
    if Form7.sMfd = 'MFPERIODO' then
    begin
      DeleteFile(pP1);
      Result := False;
      // Daruma não gera MF por período. Apenas total
      //
    end;
  end
  else
  begin

    //
    if Form7.sMfd = 'MFDCOMPLETA' then
    begin
      DeleteFile(pP1);
      i := _ecf17.Daruma_DownloadMFD(pP2, pP3, pP1);
      if I = 1 then
      begin
        if FileExists(pP1) then
        begin
          Application.BringToFront;
          Application.ProcessMessages;
          // Sandro Silva 2017-08-01  ShowMessage('O seguinte arquivo será gravado: '+pP1);
          Result := True;
        end
        else
          Result := False;
      end
      else
      begin
        _ecf17_CodeErro(I);
        Result := False;
      end;
      //
    end
    else
    if Form7.sMfd = 'MFCOMPLETA' then
    begin
      DeleteFile(pP1);
      i := _ecf17.Daruma_DownloadMF(pP1);
      if I = 1 then
      begin
        if FileExists(pP1) then
        begin
          Application.BringToFront;
          Application.ProcessMessages;
          // Sandro Silva 2017-08-01  ShowMessage('O seguinte arquivo será gravado: '+pP1);
          Result := True;
        end
        else
          Result := False;
      end
      else
      begin
        _ecf17_CodeErro(I);
        Result := False;
      end;
      //
    end
    else
    begin
      DeleteFile(PChar('.\DarumaATOCOTEPE_DARUMA.txt')); // Sandro Silva 2020-09-02 Deletefile(pChar('.\DarumaATOCOTEPE_DARUMA.txt'));
      DeleteFile(PChar('.\Espelho_MFD.txt')); // Sandro Silva 2020-09-02 Deletefile(pChar('.\Espelho_MFD.txt'));
      //
      //
      //
      if Form7.Label3.Caption = 'Data inicial:' then
      begin
        //
        pP2 := Copy(DateToStr(Form7.DateTimePicker1.Date),1,2)+'/'+Copy(DateToStr(Form7.DateTimePicker1.Date),4,2)+'/'+Copy(DateToStr(Form7.DateTimePicker1.Date),9,2);
        pP3 := Copy(DateToStr(Form7.DateTimePicker2.Date),1,2)+'/'+Copy(DateToStr(Form7.DateTimePicker2.Date),4,2)+'/'+Copy(DateToStr(Form7.DateTimePicker2.Date),9,2);
        //
        // ShowMessage(pP2+chr(10)+pP3);
        //
      end else
      begin
        //
        pP2 := StrZero(StrToInt(Form7.MaskEdit1.Text),6,0);
        pP3 := StrZero(StrToInt(Form7.MaskEdit2.Text),6,0);
        //
      end;
      //
      if Form7.sMfd = '2' then
      begin
        //
        if Form7.Label3.Caption = 'Data inicial:' then
        begin

          sArquivoAto1704 := '.\ATO_MFD_DATA.TXT';
          DeleteFile(PChar(sArquivoAto1704)); // Sandro Silva 2020-09-02 DeleteFile(pChar(sArquivoAto1704));

          //
          pP2 := Copy(DateToStr(Form7.DateTimePicker1.Date),1,2)+Copy(DateToStr(Form7.DateTimePicker1.Date),4,2)+Copy(DateToStr(Form7.DateTimePicker1.Date),7,4);
          pP3 := Copy(DateToStr(Form7.DateTimePicker2.Date),1,2)+Copy(DateToStr(Form7.DateTimePicker2.Date),4,2)+Copy(DateToStr(Form7.DateTimePicker2.Date),7,4);

          I := _ecf17.Daruma_FIMFD_GerarAtoCotepePafData('MFD', 'DATAM', pP2,pP3); // Por Data
          //
        end else
        begin
          sArquivoAto1704 := '.\ATO_MFD_COO.TXT';
          DeleteFile(PChar(sArquivoAto1704)); // Sandro Silva 2020-09-02 Deletefile(pChar(sArquivoAto1704));

          {Sandro Silva 2015-08-20 inicio}
          pP2 := FormatFloat('000000', StrToIntDef(Form7.MaskEdit1.Text, 0));
          pP3 := FormatFloat('000000', StrToIntDef(Form7.MaskEdit2.Text, 0));
          {Sandro Silva 2015-08-20 final}
          I := _ecf17.Daruma_FIMFD_GerarAtoCotepePafCoo('MFD', 'COO', pP2,pP3); // Por COO
        end;
        //
      end else
      begin
        // 2015-09-28 I := _ecf17.Daruma_FIMFD_DownloadDaMFD(pchar(pP2),pchar(pP3));
        I := _ecf17.Daruma_EspelhoMFD(pP2,pP3); // Sandro Silva 2020-09-02 I := _ecf17.Daruma_EspelhoMFD(pchar(pP2),pchar(pP3));
      end;
      //
      if Form7.sMfd = '2' then
      begin
        if I = 1 then
        begin
          CopyFile(PChar(sArquivoAto1704), PChar(pP1), False); // Sandro Silva 2020-09-02 CopyFile(pChar(sArquivoAto1704), pChar(pP1), False);

          Application.BringToFront;
          Application.ProcessMessages;
          // Sandro Silva 2017-08-01  ShowMessage('O seguinte arquivo será gravado: ' + pP1);
          Deletefile(PChar(sArquivoAto1704)); // Sandro Silva 2020-09-02 Deletefile(pChar(sArquivoAto1704));
          {Sandro Silva 2015-09-30 final}
          Result := True;
        end else
        begin
          _ecf17_CodeErro(I);
          Result := False;
        end;
      end else
      begin
        //
        if I = 1 then
        begin
          if FileExists('.\Espelho_MFD.txt') then
          begin
            CopyFile(PChar('.\Espelho_MFD.txt'), PChar(pP1), False); // Sandro Silva 2020-09-02 CopyFile(pChar('.\Espelho_MFD.txt'),pChar(pP1), False);
            Application.BringToFront;
            Application.ProcessMessages;
            // Sandro Silva 2017-08-01  ShowMessage('O seguinte arquivo será gravado: '+pP1);
            DeleteFile(PChar('.\Espelho_MFD.txt')); // Sandro Silva 2020-09-02 Deletefile(pChar('.\Espelho_MFD.txt'));
            Result := True;
          end else Result := False;
        end else
        begin
          _ecf17_CodeErro(I);
          Result := False;
        end;
        //
      end;
      //
    end;
  end;
end;

function _ecf17_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
begin
  //
  if Form1.sTipo = 's' then
    _ecf17.Daruma_Registry_MFD_LeituraMFCompleta('0')
  else
    _ecf17.Daruma_Registry_MFD_LeituraMFCompleta('1');
  //
  if Length(pP1) = 6 then
  begin
    _ecf17_CodeErro(_ecf17.Daruma_FI_LeituraMemoriaFiscalData(pP1,pP2)); // Por data
  end else
  begin
    _ecf17_CodeErro(_ecf17.Daruma_FI_LeituraMemoriaFiscalReducao(pP1,pP2));
  end;
  //
  Result := True;
  //
end;

// -------------------------------- //
// Venda do Item                    //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf17_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
var
  I : Integer;
begin

  if StrToFloat(pP7) > 0 then
    pP8 := FormatFloat('0.00', (StrToFloat(pP5) * StrToFloat(pP4) * StrToFloat(pP7)) / 100);
  //
  pP6 := Copy(pP6+'   ',1,3);

  I := _ecf17.Daruma_FI_VendeItemDepartamento(pP1,          //Codigo
                                              Trim(pP2), // Descricao
                                              pP3,          // Aliquota
                                              pP4,          // Quantidade
                                              pP5,          // ValorUnitario
                                              //'0',                 // Acrescimo
                                              'D$',// Tipo de desconto A% - Acréscimo em  Percentual; A$ - Acréscimo em Valor; D% - Desconto em Percentual; D$ - Desconto em Valor;
                                              pP8,                 // Desconto/Acrescimo
                                              //'01',         // IndiceDepartamento
                                              Trim(pP6)          // UnidadeMedida
                                              );

  if _ecf17.ErroUltimoComando <> 0 then // Valor bruto zero
  begin
    ShowMessage(_ecf17.DescErroUltimoComando);
    Result := False;
  end
  else
  begin
    if I = 1 then
    begin
      Result := True
    end
    else
    begin
      _ecf17_CodeErro(I);
      Result := False;
    end;
  end;

  {Sandro Silva 2016-08-31 inicio}
  if _ecf17.AvisoUltimoComando = 1 then
    _ecf17_CodeErro(1);
  {Sandro Silva 2016-08-31 final}

  //
end;

// -------------------------------- //
// Reducao Z                        //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf17_ReducaoZ(pP1: Boolean):Boolean;
begin
  if _ecf17_CodeErro(_ecf17.Daruma_FI_ReducaoZ('      ','      ')) = 1 then Result := True else Result := False;
end;

// -------------------------------- //
// Leitura X                        //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf17_LeituraX(pP1: Boolean):Boolean;
begin
  if _ecf17_CodeErro(_ecf17.Daruma_FI_LeituraX()) = 1 then
    Result := True
  else
    Result := False;
end;

// ---------------------------------------------- //
// Retorna se o horario de verão está selecionado //
// IF DARUMA FS 345                               //
// ---------------------------------------------- //
function _ecf17_RetornaVerao(pP1: Boolean):Boolean;
var
  sS : String;
begin
  sS := ' ';
//  Daruma_FI_FlagsFiscaisStr(sS);
  if Copy(sS,1,1) = '4' then
    Result := True
  else
    Result := False; // Horário de verão selecionado
end;

// -------------------------------- //
// Liga ou desliga horário de verao //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf17_LigaDesLigaVerao(pP1: Boolean):Boolean;
begin
  if _ecf17_codeErro(_ecf17.Daruma_FI_ProgramaHorarioVerao()) = 1 then
    Result := True
  else
    Result := False;
end;

// -------------------------------- //
// Retorna a versão do firmware     //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf17_VersodoFirmware(pP1: Boolean): String;
begin
  Result := '      ';
  _ecf17_codeErro(_ecf17.Daruma_FI_VersaoFirmware(Result));
end;

// -------------------------------- //
// Retorna o número de série        //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf17_NmerodeSrie(pP1: Boolean): String;
begin
  //Result := Replicate(' ',20);
  //_ecf17.Daruma_FIMFD_RetornaInformacao('78',Result);
  Result := Replicate(' ',21);
  _ecf17.Daruma_FIMFD_RetornaInformacao('78',Result);
  Result := Copy(Result, 1, 20);
end;

// -------------------------------- //
// Retorna o CGC e IE               //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf17_CGCIE(pP1: Boolean): String;
var
  sCgc, sIe : String;
begin
  //
  sCgc := Replicate(' ',20);
  sIe  := Replicate(' ',20);
  _ecf17_CodeErro(_ecf17.Daruma_FI_CGC_IE(sCgc, sIe));
  Result := 'CGC='+sCgc+' IE='+sIe;
  //
end;

// --------------------------------- //
// Retorna o número de cancelamentos //
// IF DARUMA FS 345                  //
// --------------------------------- //
function _ecf17_Cancelamentos(pP1: Boolean): String;
begin
  // 2015-08-12 Result := Replicate(' ',14);
  Result := Replicate(' ', 13);
  _ecf17_CodeErro(_ecf17.Daruma_FI_Cancelamentos(Result)); // Ok
end;


// -------------------------------- //
// Retorna o valor de descontos     //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf17_Descontos(pP1: Boolean): String;
begin
  // 2015-08-12 Result := Replicate(' ',14);
  Result := Replicate(' ', 13);
  _ecf17_CodeErro(_ecf17.Daruma_FI_DesContos(Result));
end;

// -------------------------------- //
// Retorna o contados sequencial    //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf17_ContadorSeqencial(pP1: Boolean): String;
begin
  Result := Replicate(' ',6);
  _ecf17_CodeErro(_ecf17.Daruma_FI_NumeroCupom(Result));
end;

// -------------------------------- //
// Retorna o número de operações    //
// não fiscais acumuladas           //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf17_Nmdeoperaesnofiscais(pP1: Boolean): String;
begin
  Result := Replicate(' ',6);
  _ecf17_CodeErro(_ecf17.Daruma_FI_NumeroOperacoesNaoFiscais(Result));
end;

function _ecf17_NmdeCuponscancelados(pP1: Boolean): String;
begin
  Result := Replicate(' ',4);
  _ecf17_CodeErro(_ecf17.Daruma_FI_NumeroCuponsCancelados(Result));
end;

function _ecf17_NmdeRedues(pP1: Boolean): String;
begin
  Result := Replicate(' ',4);
  _ecf17_CodeErro(_ecf17.Daruma_FI_NumeroReducoes(Result));
  Result := Strzero( StrToInt( Limpanumero('0'+Result))+1,6,0);
end;

function _ecf17_Nmdeintervenestcnicas(pP1: Boolean): String;
begin
  //2015-08-12 Result := Replicate(' ',4);
  Result := Replicate(' ', 3);
  _ecf17_CodeErro(_ecf17.Daruma_FI_NumeroIntervencoes(Result));
end;

function _ecf17_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
begin
  Result := Replicate(' ', 2);
  _ecf17_CodeErro(_ecf17.Daruma_FI_NumeroSubstituicoesProprietario(Result));
end;

function _ecf17_Clichdoproprietrio(pP1: Boolean): String;
begin
  // 2015-08-13 SetLength (Result,400);
  SetLength (Result, 219);
  _ecf17.Daruma_FI_ClicheProprietarioEx(Result);
end;

// ------------------------------------ //
// Importante retornar apenas 3 dígitos //
// Ex: 001                              //
// IF DARUMA FS 345                     //
// ------------------------------------ //
function _ecf17_NmdoCaixa(pP1: Boolean): String;
begin
  Result := Replicate(' ',4);
  _ecf17_CodeErro(_ecf17.Daruma_FI_NumeroCaixa(Result));
  // 2015-09-22 Result := LimpaNumero(Copy(Result,2,3));
  Result := RightStr('00' + LimpaNumero(Result), 3);
end;

function _ecf17_Nmdaloja(pP1: Boolean): String;
begin
  Result := Replicate(' ',4);
  _ecf17_CodeErro(_ecf17.Daruma_FI_NumeroLoja(Result));
end;

function _ecf17_Moeda(pP1: Boolean): String;
var
  sMoeda: string;
begin
  setlength(sMoeda, 2);
  _ecf17.Daruma_FI_SimboloMoeda(sMoeda);
  Result := AllTrim(Copy(sMoeda,2,1));
end;

function _ecf17_Dataehoradaimpressora(pP1: Boolean): String;
var
  sData: string;
  sHora: string;
begin
  //sData := Replicate(' ',6);
  sData := Replicate(' ', 8);
  sHora := Replicate(' ', 6);
  _ecf17_CodeErro(_ecf17.Daruma_FI_DataHoraImpressora(sData,sHora));
  sData := Copy(sData, 1, 4) + RightStr(sData, 2);
  Result := sData + sHora;
end;

function _ecf17_Datadaultimareduo(pP1: Boolean): String;
begin
  // Result := Replicate(' ',6);
  // 2015-08-13 setlength( Result, 6 );
  setlength( Result, 8);
  _ecf17_CodeErro(_ecf17.Daruma_FI_DataMovimento(Result));
end;

function _ecf17_Datadomovimento(pP1: Boolean): String;
begin
  // Result := Replicate(' ',6);
  // 2015-10-14 setlength(Result, 6);
  setlength(Result, 8);
  _ecf17_CodeErro(_ecf17.Daruma_FI_DataMovimento(Result));
end;

// Deve retornar uma String com:                                          //
// Os 2 primeiros dígitos são o número de aliquotas gravadas: Ex 16       //
// os póximos de 4 em 4 são as aliquotas Ex: 1800                         //
// Ex: 161800120005000000000000000000000000000000000000000000000000000000 //
function _ecf17_RetornaAliquotas(pP1: Boolean): String;
begin
  Result := Replicate('0', 150);
  _ecf17_CodeErro(_ecf17.Daruma_FI_RetornoAliquotas(Result));
  Result := Copy('16'+LimpaNumero(Result)+Replicate('0',150),1,66);
end;

function _ecf17_Vincula(pP1: String): Boolean;
begin
  Result := False;
end;

function _ecf17_FlagsDeISS(pP1: Boolean): String;
var
  sIndiceAliquotas: string;
  I : Integer;
begin
  //
  SetLength(sIndiceAliquotas, 150);
  _ecf17.Daruma_FI_VerificaAliquotasIss( sIndiceAliquotas );
  //
  Result := '';
  //
  for I := 1 to 16 do
  begin
    if Copy(Form1.sAliquotas,(I*4)-1,4) = Copy(sIndiceAliquotas,1,4) then
      Result := Result + '1'
    else
      Result := Result + '0';
  end;
  //
  Result:=chr(BinToInt(Copy(Result,1,8)))+chr(BinToInt(Copy(Result,9,8)));
  //
end;

function _ecf17_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
begin
  //
  _ecf17_CodeErro(_ecf17.Daruma_FI_FechaPortaSerial());
  FreeLibrary(_ecf17.DLL);
  FreeAndNil(_ecf17);
  Result := True;
  //
end;

function _ecf17_MudaMoeda(pP1: String): Boolean;
begin
  _ecf17.Daruma_FI_AlteraSimboloMoeda('R');
  Result := True;
end;

function _ecf17_MostraDisplay(pP1: String): Boolean;
begin
  Result := True;
end;

function _ecf17_LeituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
begin
  //
  Screen.Cursor := crHourGlass; // Cursor de Aguardo
  //
  if Length(pP2) = 4 then
  begin
    _ecf17_CodeErro(_ecf17.Daruma_FI_LeituraMemoriaFiscalSerialReducao(pP2,pP3));
  end else
  begin
    _ecf17_CodeErro(_ecf17.Daruma_FI_LeituraMemoriaFiscalSerialData(pP2,pP3));
  end;
  //
  Screen.Cursor := crDefault; // Cursor normal
  //
  DeleteFile(pP1);
  ShowMessage('O seguinte arquivo será gravado: '+pP1);
  CopyFile(PChar('C:\RETORNO.TXT'), PChar(pP1), False); // Sandro Silva 2020-09-02 CopyFile(pChar('C:\RETORNO.TXT'),pChar(pP1),True);
  Result := True;
  //
end;

function _ecf17_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean;
var
  I,  iRetorno : Integer;
  sLinha : String;
begin
  //
  begin
    //
    iRetorno := 1;
    //
    if Form1.ibDataSet25.FieldByName('DIFERENCA_').AsFloat > 0 then
      iRetorno := _ecf17.Daruma_FI_AbreComprovanteNaoFiscalVinculado(AllTrim(Form2.Label17.Caption), FormatFloat('0.00', Form1.ibDataSet25.FieldByName('DIFERENCA_').AsFloat), IntToStr(Form1.icupom)); // Sandro Silva 2020-09-02 iRetorno := _ecf17.Daruma_FI_AbreComprovanteNaoFiscalVinculado(PChar(AllTrim(Form2.Label17.Caption)), PChar(FormatFloat('0.00', Form1.ibDataSet25.FieldByName('DIFERENCA_').AsFloat)), PChar(IntToStr(Form1.icupom)));
    if Form1.ibDataSet25.FieldByName('PAGAR').AsFloat >      0 then
      iRetorno := _ecf17.Daruma_FI_AbreComprovanteNaoFiscalVinculado(AllTrim(Form2.Label8.Caption), FormatFloat('0.00', Form1.ibDataSet25.FieldByName('PAGAR').AsFloat), IntToStr(Form1.icupom)); // Sandro Silva 2020-09-02 iRetorno := _ecf17.Daruma_FI_AbreComprovanteNaoFiscalVinculado(PChar(AllTrim(Form2.Label8.Caption)) , PChar(FormatFloat('0.00', Form1.ibDataSet25.FieldByName('PAGAR').AsFloat)), PChar(IntToStr(Form1.icupom)));
    if Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat > 0 then
      iRetorno := _ecf17.Daruma_FI_AbreComprovanteNaoFiscalVinculado(AllTrim(Form2.Label9.Caption), FormatFloat('0.00', Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat), IntToStr(Form1.icupom)); // Sandro Silva 2020-09-02 iRetorno := _ecf17.Daruma_FI_AbreComprovanteNaoFiscalVinculado(PChar(AllTrim(Form2.Label9.Caption)) , PChar(FormatFloat('0.00', Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat)), PChar(IntToStr(Form1.icupom)));
    {Sandro Silva 2015-10-21 final}
    //
    for I := 1 to Length(sP1) do
    begin
     if iRetorno = 1 then
     begin
        if Copy(sP1,I,1) <> chr(10) then
        begin
          sLinha := sLinha+Copy(sP1,I,1);
        end else
        begin
          //
          if sLinha = '' then sLinha:=' ';
          iRetorno := _ecf17.Daruma_FI_UsaComprovanteNaoFiscalVinculado(sLinha); // Sandro Silva 2020-09-02 iRetorno := _ecf17.Daruma_FI_UsaComprovanteNaoFiscalVinculado(pChar(sLinha));
          sLinha:='';
        end;
     end;
    end;
    //
    if iRetorno = 1 then
      iRetorno := _ecf17.Daruma_FI_FechaComprovanteNaoFiscalVinculado();
    if (iRetorno = 1) or (iRetorno = -27) then
    begin
      Result   := True
    end
    else
    begin
      Result := False;
    end;
    //
  end;
  //
end;

function _ecf17_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
var
  iI, I, iRetorno : Integer;
  sLinha : String;
  bImprimindoConferenciaMesa: Boolean; // 2015-09-08 Indica quando está fazendo a impressão do TEF. Envia linha a linha para a impressora
  function Imprimir(sTexto: String): Integer;
  var
    sTexto2: String;
    i: Integer;
    bQuebra: Boolean;
  begin
    Result := 1;

    if Form1.sCRLF = 'Sim' then
      sTexto := StringReplace(sTexto, #10, #10#10, [rfReplaceAll]);
    while Trim(sTexto) <> '' do
    begin
      bQuebra := False;
      for i := 619 downto 1 do
      begin
        if Copy(sTexto, i, 1) = Chr(10) then
        begin
          bQuebra := True;
          Break;
        end;
      end;

      if bQuebra = False then
        sTexto2 := Copy(sTexto, 1, 619)
      else
        sTexto2 := Copy(sTexto, 1, i);
      Result := _ecf17.Daruma_FI_RelatorioGerencial(sTexto2);
      //Sleep(500);
      if Result <> 1 then
        Break;
      sTexto := StringReplace(sTexto, sTexto2, '', [rfIgnoreCase]);
    end;
  end;
begin
  bImprimindoConferenciaMesa := (Form1.sRGTurbo = 'Sim');
  if _ecf17.Daruma_FI_VerificaReducaoZ = '1' then // RZ pendente
  begin
    Result := False;
  end
  else
  begin
    //
    if Pos('IDENTIFICAÇÃO DO PAF-ECF',sP1)<>0 then
    begin
      _ecf17.Daruma_FIMFD_AbreRelatorioGerencial('IDENT DO PAF'); // Sandro Silva 2020-09-02 _ecf17.Daruma_FIMFD_AbreRelatorioGerencial(pchar('IDENT DO PAF'));
    end else
    begin
      if Pos('Período Solicitado: de',sP1)<>0 then
      begin
        _ecf17.Daruma_FIMFD_AbreRelatorioGerencial('MEIOS DE PAGTO'); // Sandro Silva 2020-09-02 _ecf17.Daruma_FIMFD_AbreRelatorioGerencial(pchar('MEIOS DE PAGTO'));
      end else
      begin
        if (Pos('Documento: ',sP1)<>0) or (Pos(TITULO_PARCELAS_CARNE_RESUMIDO, sP1) > 0) then  // Sandro Silva 2018-04-29  if Pos('Documento: ',sP1)<>0 then
        begin
          _ecf17.Daruma_FIMFD_AbreRelatorioGerencial('VENDA PRAZO'); // Sandro Silva 2020-09-02 _ecf17.Daruma_FIMFD_AbreRelatorioGerencial(pchar('VENDA PRAZO'));
        end else
        begin
          if Pos('DAV EMITIDOS',sP1)<>0 then
          begin
            _ecf17.Daruma_FIMFD_AbreRelatorioGerencial('DAV Emitidos'); // Sandro Silva 2020-09-02 _ecf17.Daruma_FIMFD_AbreRelatorioGerencial(pchar('DAV Emitidos'));
          end else
          begin
            if Pos('AUXILIAR DE VENDA (DAV) - OR',sP1)<>0 then
            begin
              _ecf17.Daruma_FIMFD_AbreRelatorioGerencial('Orcamento'); // Sandro Silva 2020-09-02 _ecf17.Daruma_FIMFD_AbreRelatorioGerencial(pchar('Orcamento'));
            end else
            begin
              if Pos('CONFERENCIA DE CONTA',sP1)<>0 then
              begin
                // 2016-02-04 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
                _ecf17.Daruma_FIMFD_AbreRelatorioGerencial('CONF CONTA CLI'); // Sandro Silva 2020-09-02 _ecf17.Daruma_FIMFD_AbreRelatorioGerencial(pchar('CONF CONTA CLI'));
              end else
              begin
                if Pos('TRANSFERENCIAS ENTRE CONTA',sP1)<>0 then
                begin
                  // 2016-02-11 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
                  _ecf17.Daruma_FIMFD_AbreRelatorioGerencial('TRANSF CONT CLI'); // Sandro Silva 2020-09-02 _ecf17.Daruma_FIMFD_AbreRelatorioGerencial(pchar('TRANSF CONT CLI'));
                end else
                begin
                  if (Pos('CONTAS DE CLIENTES ABERTAS',sP1)<>0)
                    or (Pos('CONTAS DE CLIENTES OS ABERTAS',sP1)<>0)
                    or ((Pos('NENHUMA',sP1)<>0) and (Pos('CONTA DE CLIENTE',sP1)<>0)) then
                  begin
                    // 2016-02-11 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
                    _ecf17.Daruma_FIMFD_AbreRelatorioGerencial('CONT CLI ABERTA'); // Sandro Silva 2020-09-02 _ecf17.Daruma_FIMFD_AbreRelatorioGerencial(pchar('CONT CLI ABERTA'));
                  end else
                  begin
                    if Pos('CONFERENCIA DE MESA',sP1)<>0 then
                    begin
                      _ecf17.Daruma_FIMFD_AbreRelatorioGerencial('CONF MESA'); // CONFERENCIA // Sandro Silva 2020-09-02 _ecf17.Daruma_FIMFD_AbreRelatorioGerencial(pchar('CONF MESA')); // CONFERENCIA
                    end else
                    begin
                      if Pos('TRANSFERENCIAS ENTRE MESA',sP1)<>0 then
                      begin
                        _ecf17.Daruma_FIMFD_AbreRelatorioGerencial('TRANSF MESA'); // TRANSFERENCIA MESAS // Sandro Silva 2020-09-02 _ecf17.Daruma_FIMFD_AbreRelatorioGerencial(pchar('TRANSF MESA')); // TRANSFERENCIA MESAS
                      end else
                      begin
                        if (Pos('MESAS ABERTAS',sP1)<>0) or
                         (Pos('NENHUMA MESA',sP1)<>0) then
                        begin
                          _ecf17.Daruma_FIMFD_AbreRelatorioGerencial('MESAS ABERTAS'); // MESAS ABERTAS // Sandro Silva 2020-09-02 _ecf17.Daruma_FIMFD_AbreRelatorioGerencial(pchar('MESAS ABERTAS')); // MESAS ABERTAS
                        end else
                        begin
                          if Pos('Parametros de Configuracao',sP1)<>0 then
                          begin
                            _ecf17.Daruma_FIMFD_AbreRelatorioGerencial('PARAM CONFIG'); // PARÂMETROS DE CONFIGURAÇÃO // Sandro Silva 2020-09-02 _ecf17.Daruma_FIMFD_AbreRelatorioGerencial(pchar('PARAM CONFIG')); // PARÂMETROS DE CONFIGURAÇÃO
                          end else
                          begin
                            _ecf17.Daruma_FIMFD_AbreRelatorioGerencial('CARTAO TEF'); // TEF // Sandro Silva 2020-09-02 _ecf17.Daruma_FIMFD_AbreRelatorioGerencial(pchar('CARTAO TEF')); // TEF
                            bImprimindoConferenciaMesa := False;
                          end;
                        end;
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
    //
    begin
      //
      iRetorno := 1;
      {Sandro Silva 2020-09-03 inicio
      //
      sLinha := '';
      for iI := 1 to 1 do
      begin
        //
        for I := 1 to Length(sP1) do
        begin
          if iRetorno = 1 then
          begin
            if Copy(sP1,I,1) <> chr(10) then
            begin
              sLinha := sLinha+Copy(sP1,I,1);
            end else
            begin
              //
              if sLinha = '' then sLinha:=' ';
              iRetorno := _ecf17.Daruma_FI_RelatorioGerencial(sLinha); // Sandro Silva 2020-09-02 iRetorno := _ecf17.Daruma_FI_RelatorioGerencial(pChar(sLinha));
              sLinha:='';
            end;
          end;
        end;
        //
        for I := 1 to 5 do // 5 linhas em branco
        begin
          if iRetorno = 1 then
            iRetorno := _ecf17.Daruma_FI_RelatorioGerencial(' ');
        end;
        if iRetorno = 1 then
          sleep(4000); // Da um tempo
        //
      end;
      }
      //
      if (Form1.sRGTurbo <> 'Sim') or (bImprimindoConferenciaMesa = False) then
      begin

        sLinha := '';
        for iI := 1 to 1 do
        begin
          //
          for I := 1 to Length(sP1) do
          begin
            if iRetorno = 1 then
            begin
              if Copy(sP1,I,1) <> chr(10) then
              begin
                sLinha := sLinha+Copy(sP1,I,1);
              end else
              begin
                //
                if sLinha = '' then sLinha:=' ';
                iRetorno := _ecf17.Daruma_FI_RelatorioGerencial(sLinha); // Sandro Silva 2020-09-02 iRetorno := _ecf17.Daruma_FI_RelatorioGerencial(pChar(sLinha));
                sLinha:='';
              end;
            end;
          end;
          //
          for I := 1 to 5 do // 5 linhas em branco
          begin
            if iRetorno = 1 then
              iRetorno := _ecf17.Daruma_FI_RelatorioGerencial(' ');
          end;
          if iRetorno = 1 then
            Sleep(4000); // Da um tempo
          //
        end;
      end
      else if (bImprimindoConferenciaMesa) and (Form1.sRGTurbo = 'Sim') then
      begin // Agilizar a impressão
        Imprimir(sP1);

        if iRetorno = 1 then
          iRetorno := _ecf17.Daruma_FI_RelatorioGerencial(#10+#10+#10+#10+#10);
        if iRetorno = 1 then
          Sleep(1000); // Sleep(4000); // Da um tempo
      end;
      {Sandro Silva 2020-09-03 fim}

      //
      if iRetorno = 1 then iRetorno := _ecf17.Daruma_FI_FechaRelatorioGerencial();
      if iRetorno = 1 then Result   := True else Result := False;
      if iRetorno = -27 then Result := True;
      //
    end;
    //
  end; // if _ecf17.Daruma_FI_VerificaReducaoZ = '1' then
end;

function _ecf17_FechaCupom2(sP1: Boolean): Boolean;
begin
  _ecf17.Daruma_TEF_FechaRelatorio();
  //
  Result := True;
end;

//                                      //
// Imprime cheque - Parametro é o valor //
//                                      //
function _ecf17_ImprimeCheque(rP1: Real; sP2: String): Boolean;
begin
  Result := False;
end;

function _ecf17_MapaResumo(sP1: Boolean): Boolean;
begin
  Result := True;
end;

function _ecf17_GrandeTotal(sP1: Boolean): String;
begin
  Result := Replicate('0', 18);
  _ecf17_CodeErro(_ecf17.Daruma_FI_GrandeTotal(Result));
end;

function _ecf17_TotalizadoresDasAliquotas(sP1: Boolean): String;
begin
  //
  // Teste voltar 200
  //
  Result := Replicate('0', 364);
  _ecf17.Daruma_FI_VerificaTotalizadoresParciais(Result);
  Result := Copy(LimpaNumero(Result),1,364);
  //
  // ShowMessage(Result);
  //
end;

function _ecf17_CupomAberto(sP1: Boolean): boolean;
var
  I : Integer;
  //EstadoECF: String;
begin
  _ecf17.Daruma_FI_FlagsFiscais(I);
  //
  // ShowMessage('CupomAberto ='+IntToStr(I));
  //
  if I = 1 then
    Result := True
  else
    Result := False;
  //

end;

function _ecf17_FaltaPagamento(sP1: Boolean): boolean;
var
  I : Integer;
begin

  _ecf17.Daruma_FI_FlagsFiscais(I);
  //
  //ShowMessage('Falta pagamento ='+IntToStr(I));
  //
  // 2015-10-20
  // Possíveis status do cupom fiscal
  // 0 = Fechado
  // 1 = CF em registro de item
  // 2 = CF em totalização
  // 3 = CF em pagamento
  // 4 = CF em finalização
  if I >= 2 then 
    Result := True
  else
    Result := False;
  /////////////////////////////////////////////////////
  // Retorna true quando o cupom já foi finalizado e //
  // só esta faltando as formas de pagamento         //
  /////////////////////////////////////////////////////
end;

function _ecf17_ProgramaAplicativo(sP1: Boolean): boolean;
begin
  _ecf17.Daruma_Registry_AplMensagem1('   '); // Sandro Silva 2020-09-02 _ecf17.Daruma_Registry_AplMensagem1(pchar('   '));
  _ecf17.Daruma_Registry_AplMensagem2('   '); // Sandro Silva 2020-09-02 _ecf17.Daruma_Registry_AplMensagem2(pchar('   '));
  Result := True;
end;

//
// PAF
//

function _ecf17_Marca(sP1: Boolean): String;
begin
  Result := REplicate(' ',20);
  _ecf17.Daruma_FIMFD_RetornaInformacao('80',Result);
  //
  // Ok
  //
end;

function _ecf17_Modelo(sP1: Boolean): String;
begin
  Result := Replicate(' ',20);
  _ecf17.Daruma_FIMFD_RetornaInformacao('81',Result);
  //
  // Ok
  //
end;

function _ecf17_Tipodaimpressora(pP1: Boolean): String;
begin
  Result := REplicate(' ',7);
  _ecf17.Daruma_FIMFD_RetornaInformacao('79',Result);
  //
  // Ok
  //
end;

function _ecf17_VersaoSB(pP1: Boolean): String; //
begin
  Result := REplicate(' ',6);
  _ecf17.Daruma_FIMFD_RetornaInformacao('83',Result);
  //
  // Ok
  //
end;

function _ecf17_HoraIntalacaoSB(pP1: Boolean): String; //
begin
  Result := REplicate(' ',14);
  _ecf17.Daruma_FIMFD_RetornaInformacao('85',Result);
  Result := Copy(Result,9,6);
  //
  // Ok
  //
end;

function _ecf17_DataIntalacaoSB(pP1: Boolean): String; //
begin
  Result := REplicate(' ',14);
  _ecf17.Daruma_FIMFD_RetornaInformacao('85',Result);
  Result := Copy(Result,1,8);
  //
  // Ok
  //
end;

function _ecf17_DataHoraUltimaReducao: String;
var
  sData, sHora: String;
begin
  Result := '';
  try
    _ecf17.Daruma_FI_DataHoraReducao(sData, sHora);
    if (Trim(sData) <> '') and (Trim(sHora) <> '') then
    begin
      try
        // Retorno da DLL: 09062016154545
        Result := FormatDateTime('dd/mm/yyyy', StrToDate(Copy(sData, 1, 2) + '/' + Copy(sData, 3, 2) + '/' + Copy(sData, 5, 4))) + ' ' + Copy(sHora, 1, 2) + ':' + Copy(sHora, 3, 2) + ':' + Copy(sHora, 5, 2);
      except
        Result := '00/00/2000 00:00:00';
      end;
    end;
  except

  end;
end;

function _ecf17_DadosDaUltimaReducao(pP1: Boolean): String; //
var
  sRetorno : String;
begin
  sRetorno := Replicate('0',1164);
  //sRetorno := StringOFChar(#0, 1164);
  _ecf17.Daruma_FI_DadosUltimaReducao(sRetorno);

//Data do Movimento             8       1,8
//Grande Total                 18       9,18
//Grande Total Inicial         18       27,18
//Descontos ICMS               14       45,14
//Descontos ISS                14       59,14
//Cancelamentos ICMS           14       73,14
//Cancelamentos ISS            14       87,14
//Acréscimos ICMS              14      101,14
//Acréscimos ISS               14      115,14
//Tributados ICMS/ISS         224      129,224
//F1 ICMS                      14      353,14
//F2 ICMS                      14      367,14
//I1 ICMS                      14      381,14
//I2 ICMS                      14      395,14
//N1 ICMS                      14      409,14
//N2 ICMS                      14      423,14
//F1 ISS                       14      437,14
//F2 ISS                       14      451,14
//I1 ISS                       14      465,14
//I2 ISS                       14      479,14
//N1 ISS                       14      493,14
//N2 ISS                       14      507,14
//Totalizadores NF            280      521,280
//Descontos NF                 14      801,14
//Cancelamentos NF             14      815,14
//Acréscimos NF                14      829,14
//Alíquotas                    80      843,80
//CRO                           4      923,4
//CRZ                           4      927,4
//CRZ Restante                  4      931,4
//COO                           6      935,6
//GNF                           6      941,6
//CCF                           6      947,6
//CVC                           6      953,6
//GRG                           6      959,6
//CFD                           6      965,6
//CBP                           6      971,6
//NFC                           4      977,4
//CMV                           4      981,4
//CFC                           4      985,4
//CNC                           4      989,4
//CBC                           4      993,4
//NCN                           4      997,4
//CDC                           4     1001,4
//CON                          80     1005,80
//CER                          80     1085,80

  //sRetorno := StringReplace(sRetorno, #7, ';', [rfReplaceAll]);
  //sRetorno := StringReplace(sRetorno, '''', '', [rfReplaceAll]);

  Result := Copy(Copy(sRetorno, 1, 8), 1, 4) + RightStr(Copy(sRetorno, 1, 8), 2) + //   1,  6 Data
             Copy(sRetorno, 935, 6) + //   7,  6 COO
             Copy(sRetorno, 9, 18) + //  13, 18 GT
     StrZero(StrToInt(Copy(sRetorno, 927, 4)), 4, 0) + //  31,  4 CRZ // 2015-09-25 StrZero(StrToInt(Copy(sRetorno, 927, 4)) -1, 4, 0) + //  31,  4 CRZ
      Copy(Form1.sAliquotas, 3, 64) + //  35, 64 Aliquotas
          Copy(sRetorno, 129, 224) + //  99,224 Totalizadores das aliquotas
            Copy(sRetorno, 923, 4) + //  923, 4 CRO // 2015-09-25 '0'+_ecf17_Nmdeintervenestcnicas(True) + // 323,  4 Contador de reinício de operação
            //
            Copy(sRetorno, 73, 14) + // 327, 14 Totalizador de cancelamentos em ICMS
            Copy(sRetorno, 45, 14) + // 341, 14 Totalizador de descontos em ICMS
            //
            Copy(sRetorno, 381, 14) + // 355, 14 Totalizador de isenção de ICMS
            Copy(sRetorno, 409, 14) + // 369, 14 Totalizador de não incidência de ICMS
            Copy(sRetorno, 353, 14) + // 383, 14 Totalizador de substituição tributária de ICMS
            //Copy(sRetorno, 59, 14) + //59, 14   Totalizador de Descontos ISS // Sandro Silva 2018-05-24
            '';


  //
  // Ok testado
  //
end;

//
// Retorna o Código do Modelo do ECF Conf Tabéla Nacional de Identificação do ECF
//
function _ecf17_CodigoModeloEcf(pP1: Boolean): String; //
begin
  Result := Replicate(' ',6);
  _ecf17.Daruma_FIMFD_CodigoModeloFiscal(Result);
end;

(*
{ TDarumaFramework }

function TDarumaFramework.CarregaDLL: Boolean;
begin
  Result := False;
  try
    DLL     := LoadLibrary(PChar(ExtractFilePath(Application.ExeName) + DARUMA_DLLNAME_17)); //carregando dll

    //importando métodos dinamicamente
    Import(@_regAlterarValor_Daruma, 'regAlterarValor_Daruma');
    Import(@_regRetornaValorChave_DarumaFramework, 'regRetornaValorChave_DarumaFramework');

    // Funções de Inicialização
    Import(@_confCadastrar_ECF_Daruma, 'confCadastrar_ECF_Daruma');
    Import(@_confHabilitarHorarioVerao_ECF_Daruma, 'confHabilitarHorarioVerao_ECF_Daruma');
    Import(@_confProgramarAvancoPapel_ECF_Daruma, 'confProgramarAvancoPapel_ECF_Daruma');

    // Funções do Cupom Fiscal
    Import(@_iCFAbrir_ECF_Daruma, 'iCFAbrir_ECF_Daruma');
    Import(@_iCFVender_ECF_Daruma, 'iCFVender_ECF_Daruma');
    Import(@_iCFCancelarUltimoItem_ECF_Daruma, 'iCFCancelarUltimoItem_ECF_Daruma');
    Import(@_iCFCancelarItem_ECF_Daruma, 'iCFCancelarItem_ECF_Daruma');
    Import(@_iCFCancelar_ECF_Daruma, 'iCFCancelar_ECF_Daruma');
    Import(@_iCFEncerrarResumido_ECF_Daruma, 'iCFEncerrarResumido_ECF_Daruma');
    Import(@_iCFEncerrar_ECF_Daruma, 'iCFEncerrar_ECF_Daruma');
    Import(@_iCFTotalizarCupom_ECF_Daruma, 'iCFTotalizarCupom_ECF_Daruma');
    Import(@_iCFEfetuarPagamentoFormatado_ECF_Daruma, 'iCFEfetuarPagamentoFormatado_ECF_Daruma');
    Import(@_iCFEfetuarPagamento_ECF_Daruma, 'iCFEfetuarPagamento_ECF_Daruma');
    Import(@_iCFEncerrarConfigMsg_ECF_Daruma, 'iCFEncerrarConfigMsg_ECF_Daruma');
    Import(@_iCFIdentificarConsumidor_ECF_Daruma, 'iCFIdentificarConsumidor_ECF_Daruma');
    Import(@_iEstornarPagamento_ECF_Daruma, 'iEstornarPagamento_ECF_Daruma');

    // Funções dos Relatórios Fiscais
    Import(@_iLeituraX_ECF_Daruma, 'iLeituraX_ECF_Daruma');
    Import(@_iReducaoZ_ECF_Daruma, 'iReducaoZ_ECF_Daruma');
    Import(@_iRGImprimirTexto_ECF_Daruma, 'iRGImprimirTexto_ECF_Daruma');
    Import(@_iRGFechar_ECF_Daruma, 'iRGFechar_ECF_Daruma');
    Import(@_iMFLer_ECF_Daruma, 'iMFLer_ECF_Daruma');
    Import(@_iMFLerSerial_ECF_Daruma, 'iMFLerSerial_ECF_Daruma');
    Import(@_rGerarEspelhoMFD_ECF_Daruma, 'rGerarEspelhoMFD_ECF_Daruma');

    // Funções das Operações Não Fiscais
    Import(@_iCNFReceberSemDesc_ECF_Daruma, 'iCNFReceberSemDesc_ECF_Daruma');
    Import(@_iCCDAbrirSimplificado_ECF_Daruma, 'iCCDAbrirSimplificado_ECF_Daruma');
    Import(@_iCCDImprimirTexto_ECF_Daruma, 'iCCDImprimirTexto_ECF_Daruma');
    Import(@_iCCDFechar_ECF_Daruma, 'iCCDFechar_ECF_Daruma');
    Import(@_iSangria_ECF_Daruma, 'iSangria_ECF_Daruma');
    Import(@_iSuprimento_ECF_Daruma, 'iSuprimento_ECF_Daruma');

    // Funções de Informações da Impressora
    Import(@_rRetornarInformacao_ECF_Daruma, 'rRetornarInformacao_ECF_Daruma');
    Import(@_rCFSubTotal_ECF_Daruma, 'rCFSubTotal_ECF_Daruma');
    Import(@_rLeituraX_ECF_Daruma, 'rLeituraX_ECF_Daruma');
    Import(@_rStatusImpressoraBinario_ECF_Daruma, 'rStatusImpressoraBinario_ECF_Daruma');
    Import(@_rCFVerificarStatus_ECF_Daruma, 'rCFVerificarStatus_ECF_Daruma');
    Import(@_rDataHoraImpressora_ECF_Daruma, 'rDataHoraImpressora_ECF_Daruma');
    Import(@_rLerAliquotas_ECF_Daruma, 'rLerAliquotas_ECF_Daruma');
    Import(@_rLerDecimais_ECF_Daruma, 'rLerDecimais_ECF_Daruma');
    Import(@_rRetornarDadosReducaoZ_ECF_Daruma, 'rRetornarDadosReducaoZ_ECF_Daruma');
    Import(@_eAbrirGaveta_ECF_Daruma, 'eAbrirGaveta_ECF_Daruma');
    Import(@_rStatusGaveta_ECF_Daruma, 'rStatusGaveta_ECF_Daruma');
    // Outras Funções
    Import(@_rStatusUltimoCmdInt_ECF_Daruma, 'rStatusUltimoCmdInt_ECF_Daruma');
    Import(@_eRetornarAvisoErroUltimoCMD_ECF_Daruma, 'eRetornarAvisoErroUltimoCMD_ECF_Daruma');
    Import(@_rGerarMapaResumo_ECF_Daruma, 'rGerarMapaResumo_ECF_Daruma');
    Import(@_iRelatorioConfiguracao_ECF_Daruma, 'iRelatorioConfiguracao_ECF_Daruma');
    Import(@_rVerificarImpressoraLigada_ECF_Daruma, 'rVerificarImpressoraLigada_ECF_Daruma');
    //funcoes de TEF
    Import(@_iTEF_ImprimirResposta_ECF_Daruma, 'iTEF_ImprimirResposta_ECF_Daruma');
    Import(@_iTEF_Fechar_ECF_Daruma, 'iTEF_Fechar_ECF_Daruma');
    //
    Import(@_rCodigoModeloFiscal_ECF_Daruma, 'rCodigoModeloFiscal_ECF_Daruma');
    Import(@_iRGAbrir_ECF_Daruma, 'iRGAbrir_ECF_Daruma');
    Import(@_rGerarRelatorio_ECF_Daruma, 'rGerarRelatorio_ECF_Daruma');
    Import(@_rEfetuarDownloadMF_ECF_Daruma, 'rEfetuarDownloadMF_ECF_Daruma');
    Import(@_rEfetuarDownloadMFD_ECF_Daruma, 'rEfetuarDownloadMFD_ECF_Daruma');
    Import(@_rVerificarReducaoZ_ECF_Daruma, 'rVerificarReducaoZ_ECF_Daruma');
    Result := True;
  except
    on E: Exception do
    begin
      if DLL = 0 then
        ShowMessage('Não foi possível carregar a biblioteca ' + DARUMA_DLLNAME_17)
      else
        ShowMessage('Erro ao carregar comandos Daruma' + #13 + E.Message);
    end;
  end;
end;

constructor TDarumaFramework.Create(AOwner: TComponent);
begin
  inherited;
  FLoad := CarregaDLL;
end;

function TDarumaFramework.Daruma_FIMFD_AbreRelatorioGerencial(
  NomeRelatorio: String): Integer;
begin
  Result := _iRGAbrir_ECF_Daruma(NomeRelatorio);
end;

function TDarumaFramework.Daruma_FIMFD_CodigoModeloFiscal(Valor: String): Integer;
begin
  Result := Daruma_FIMFD_RetornaInformacao('82', Valor); // Sandro Silva 2020-08-26 Result := _rCodigoModeloFiscal_ECF_Daruma(Valor);
end;

function TDarumaFramework.Daruma_FIMFD_DownloadDaMFD(CoInicial,
  CoFinal: String): Integer;
begin
  Result := _rGerarEspelhoMFD_ECF_Daruma('2', CoInicial, CoFinal); // 1 = DATA; 2 = COO; 3 = DATAM
end;

function TDarumaFramework.Daruma_EspelhoMFD(Inicial,
  Final: String): Integer;
begin
  if Pos('/', Inicial) <> 0 then
  begin
    Result := _rGerarEspelhoMFD_ECF_Daruma('1', LimpaNumero(Inicial), LimpaNumero(Final)) // 1 = DATA; 2 = COO; 3 = DATAM
  end
  else
    Result := _rGerarEspelhoMFD_ECF_Daruma('2', Inicial, Final); // 1 = DATA; 2 = COO; 3 = DATAM
end;

function TDarumaFramework.Daruma_FIMFD_GerarAtoCotepePafCOO(Relatorio: String;
   Tipo: String; COOIni, COOFim: String): Integer;
begin
  Result := _rGerarRelatorio_ECF_Daruma(Relatorio, Tipo, COOIni, COOFim);
end;

function TDarumaFramework.Daruma_FIMFD_GerarAtoCotepePafData(Relatorio: String;
   Tipo: String; DataInicial: String; DataFinal: String): Integer;
begin
  Result := _rGerarRelatorio_ECF_Daruma(Relatorio, Tipo, DataInicial, DataFinal);
end;

function TDarumaFramework.Daruma_FIMFD_ProgramaRelatoriosGerenciais(
  NomeRelatorio: String): Integer;
begin
  Result := _confCadastrar_ECF_Daruma('RG', NomeRelatorio, '|');
end;

function TDarumaFramework.Daruma_FIMFD_RetornaInformacao(Indice,
  Valor: String): Integer;
begin
  Result := _rRetornarInformacao_ECF_Daruma(Indice, Valor);
end;

function TDarumaFramework.Daruma_FI_AberturaDoDia(ValorCompra,
  FormaPagamento: string): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_AbreComprovanteNaoFiscalVinculado(
  FormaPagamento, Valor, NumeroCupom: String): Integer;
begin
  Result := _iCCDAbrirSimplificado_ECF_Daruma(FormaPagamento, '1', NumeroCupom, Valor);
end;

function TDarumaFramework.Daruma_FI_AbreCupom(CGC_CPF: String): Integer;
begin
  Result := _iCFAbrir_ECF_Daruma(CGC_CPF, '', '');
end;

function TDarumaFramework.Daruma_FI_AbrePortaSerial: Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_AcionaGaveta: Integer;
begin
  Result := _eAbrirGaveta_ECF_Daruma;
end;

function TDarumaFramework.Daruma_FI_Acrescimos(ValorAcrescimos: String): Integer;
begin
  ValorAcrescimos := Replicate('0', 13);
  Result := _rRetornarInformacao_ECF_Daruma('12', ValorAcrescimos);
end;

function TDarumaFramework.Daruma_FI_AlteraSimboloMoeda(
  SimboloMoeda: String): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_AumentaDescricaoItem(
  Descricao: String): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_Autenticacao: Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_AutenticacaoStr(str: string): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_CancelaCupom: Integer;
begin
  Result := _iCFCancelar_ECF_Daruma;

  if Result = 1 then
  begin
    _ecf17.ErroUltimoComando  := 0;
    _ecf17.AvisoUltimoComando := 0;
    _ecf17.Daruma_FI_RetornoImpressora;
    if _ecf17.ErroUltimoComando <> 0 then
      Result := _ecf17.ErroUltimoComando;
  end;

end;

function TDarumaFramework.Daruma_FI_CancelaItemAnterior: Integer;
begin
  Result := _iCFCancelarUltimoItem_ECF_Daruma;
end;

function TDarumaFramework.Daruma_FI_CancelaItemGenerico(
  NumeroItem: String): Integer;
begin
  Result := _iCFCancelarItem_ECF_Daruma(NumeroItem);
end;

function TDarumaFramework.Daruma_FI_Cancelamentos(
  ValorCancelamentos: String): Integer;
begin
  //Tipo retorno Totalizador de Cancelamentos ICMS com 13 posições
  Result := _rRetornarInformacao_ECF_Daruma('13',ValorCancelamentos);
end;

function TDarumaFramework.Daruma_FI_CGC_IE(CGC, IE: String): Integer;
begin
  //Tipo retorno CNPJ do usuário atual com 20 posições
  _rRetornarInformacao_ECF_Daruma('90', CGC);
  //Tipo retorno IE do usuário atual com 20 posições
  Result := _rRetornarInformacao_ECF_Daruma('91', IE);
end;

function TDarumaFramework.Daruma_FI_ClicheProprietarioEx(ClicheEx: String): Integer;
begin
  //Tipo retorno Clichê até 219 posições
  Result := _rRetornarInformacao_ECF_Daruma('132', ClicheEx);
end;

function TDarumaFramework.Daruma_FI_ContadorBilhetePassagem(
  ContadorPassagem: String): Integer;
begin
  Result := 1; //_Daruma_FI_ContadorBilhetePassagem(ContadorPassagem);
end;

function TDarumaFramework.Daruma_FI_ContadoresTotalizadoresNaoFiscais(
  Contadores: String): Integer;
begin
  Result := 1; //_Daruma_FI_ContadoresTotalizadoresNaoFiscais(Contadores);
end;

function TDarumaFramework.Daruma_FI_DadosUltimaReducao(
  var DadosReducao: String): Integer;
var
  Str_Informacao: String;
  function LimpaSharp(Texto: String): String;
  // 2015-09-29 Elimina a sequência de carateres '#8' contidos no retorno da FS800. A sequência pode mudar '#1', '#2', '#3'...
  var
    I: Integer;
    sSharp: String;
    caractere: String;
  begin
    for i := 1 to Length(Texto) do
    begin
      caractere := Copy(Texto, i, 1);
      if (caractere = #0)
        or (caractere = #1)
        or (caractere = #2)
        or (caractere = #3)
        or (caractere = #4)
        or (caractere = #5)
        or (caractere = #6)
        or (caractere = #7)
        or (caractere = #8)
        or (caractere = #9) then
      begin
        sSharp := caractere;
        Break;
      end;
    end;
    Result := StringReplace(Texto, sSharp, '0', [rfReplaceAll]);
  end;
begin
  //Tipo retorno Informações da última RZ com 1164 posições
  Str_Informacao := AnsiString(StringOFChar(#0, 1164));
  Result := _rRetornarInformacao_ECF_Daruma('140', Str_Informacao);
  DadosReducao := LimpaSharp(Str_Informacao);
end;

function TDarumaFramework.Daruma_FI_DataHoraImpressora(Data, Hora: String): Integer;
begin
  //Tipo retorno Data e hora atual da impressora (DDMMAAAA hhmmss)
  Result := _rDataHoraImpressora_ECF_Daruma(Data, Hora);
end;

function TDarumaFramework.Daruma_FI_DataHoraReducao(Data, Hora: String): Integer;
var
  sDataHora: String;
begin
  //Tipo retorno Data da última RZ gravada na MF com 14 posições
  sDataHora := DupeString(' ', 14);
  Result := _rRetornarInformacao_ECF_Daruma('154', sDataHora); // '09062016154545'
  if Result = 1 then
  begin
    Data := Copy(sDataHora, 1, 8);
    Hora := Copy(sDataHora, 9, 6);
  end;
end;

function TDarumaFramework.Daruma_FI_DataMovimento(Data: String): Integer;
begin
  //Tipo retorno Data do Movimento com 8 posições
  Result := _rRetornarInformacao_ECF_Daruma('70', Data);
end;

function TDarumaFramework.Daruma_FI_Descontos(ValorDescontos: String): Integer;
begin
  //Tipo retorno Totalizador de Descontos ICMS 13 posições
  Result := _rRetornarInformacao_ECF_Daruma('11', ValorDescontos);
end;

function TDarumaFramework.Daruma_FI_EfetuaFormaPagamento(FormaPagamento,
  ValorFormaPagamento: String): Integer;
begin
  Result := _iCFEfetuarPagamentoFormatado_ECF_Daruma(FormaPagamento, Trim(ValorFormaPagamento));
end;

function TDarumaFramework.Daruma_FI_EfetuaFormaPagamentoDescricaoForma(
  FormaPagamento, ValorFormaPagamento,
  DescricaoFormaPagto: string): integer;
begin
  Result := _iCFEfetuarPagamento_ECF_Daruma(FormaPagamento,  ValorFormaPagamento, DescricaoFormaPagto);
end;

function TDarumaFramework.Daruma_FI_EspacoEntreLinhas(Dots: Integer): Integer;
begin
  Result := 1; //_confProgramarAvancoPapel_ECF_Daruma();
end;

function TDarumaFramework.Daruma_FI_EstornoFormasPagamento(FormaOrigem,
  FormaDestino, Valor: String): Integer;
begin
  Result := _iEstornarPagamento_ECF_Daruma(FormaOrigem, FormaDestino, Valor, '');
end;

function TDarumaFramework.Daruma_FI_FechaComprovanteNaoFiscalVinculado: Integer;
begin
  Result := _iCCDFechar_ECF_Daruma;
end;

function TDarumaFramework.Daruma_FI_FechaCupom(FormaPagamento, AcrescimoDesconto,
  TipoAcrescimoDesconto, ValorAcrescimoDesconto, ValorPago,
  Mensagem: String): Integer;
begin
  Result := _iCFEncerrar_ECF_Daruma('0', Mensagem);
end;

function TDarumaFramework.Daruma_FI_FechaCupomResumido(FormaPagamento,
  Mensagem: String): Integer;
begin
  Result := _iCFEncerrarResumido_ECF_Daruma;
end;

function TDarumaFramework.Daruma_FI_FechamentoDoDia: Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_FechaPortaSerial: Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_FechaRelatorioGerencial: Integer;
begin
  Result := _iRGFechar_ECF_Daruma;
end;

function TDarumaFramework.Daruma_FI_FlagsFiscais(var Flag: Integer): Integer;
var
  Str_StatusCupomFiscal:String;
begin
  SetLength (Str_StatusCupomFiscal, 2);
  Result := _rCFVerificarStatus_ECF_Daruma(Str_StatusCupomFiscal, Flag);
end;

function TDarumaFramework.Daruma_FI_FlagsFiscaisStr(sParam1: String): Integer;
begin
  Result := _rStatusImpressoraBinario_ECF_Daruma(sParam1);
end;

function TDarumaFramework.Daruma_FI_ForcaImpactoAgulhas(
  ForcaImpacto: Integer): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_GrandeTotal(GrandeTotal: String): Integer;
begin
  // Tipo retorno GT com 18 posições
  Result := _rRetornarInformacao_ECF_Daruma('1', GrandeTotal);
  _ecf17.Daruma_FI_RetornoImpressora;
end;

function TDarumaFramework.Daruma_FI_IdentificaConsumidor(Nome, Endereco,
  Doc: String): Integer;
begin
  Result := _iCFIdentificarConsumidor_ECF_Daruma(Copy(Nome, 1, 30), Endereco, Doc); // Sandro Silva 2019-08-07  Result := _iCFIdentificarConsumidor_ECF_Daruma(Nome, Endereco, Doc);
end;

function TDarumaFramework.Daruma_FI_ImprimeConfiguracoes: Integer;
begin
  Result := _iRelatorioConfiguracao_ECF_Daruma;
end;

function TDarumaFramework.Daruma_FI_ImprimeConfiguracoesImpressora: Integer;
begin
  Result := _iRelatorioConfiguracao_ECF_Daruma;
end;

function TDarumaFramework.Daruma_FI_ImprimeDepartamentos: Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_IniciaFechamentoCupom(AcrescimoDesconto,
  TipoAcrescimoDesconto, ValorAcrescimoDesconto: String): Integer;
begin
  Result := _iCFTotalizarCupom_ECF_Daruma(TipoAcrescimoDesconto, ValorAcrescimoDesconto);
end;

function TDarumaFramework.Daruma_FI_LeituraMemoriaFiscalData(DataInicial,
  DataFinal: String): Integer;
begin
  Result := _iMFLer_ECF_Daruma(DataInicial, DataFinal);
end;

function TDarumaFramework.Daruma_FI_LeituraMemoriaFiscalReducao(ReducaoInicial,
  ReducaoFinal: String): Integer;
begin
  Result := _iMFLer_ECF_Daruma(ReducaoInicial, ReducaoFinal);
end;

function TDarumaFramework.Daruma_FI_LeituraMemoriaFiscalSerialData(DataInicial,
  DataFinal: String): Integer;
begin
  Result := _iMFLerSerial_ECF_Daruma(DataInicial, DataFinal);
end;

function TDarumaFramework.Daruma_FI_LeituraMemoriaFiscalSerialReducao(
  ReducaoInicial, ReducaoFinal: String): Integer;
begin
  Result := _iMFLerSerial_ECF_Daruma(ReducaoInicial, ReducaoFinal);
end;

function TDarumaFramework.Daruma_FI_LeituraX: Integer;
begin
  Result := _iLeituraX_ECF_Daruma;
end;

function TDarumaFramework.Daruma_FI_LeituraXSerial: Integer;
begin
  Result := _rLeituraX_ECF_Daruma;
end;

function TDarumaFramework.Daruma_FI_LinhasEntreCupons(Linhas: Integer): Integer;
begin
  Result := 1;//_confProgramarAvancoPapel_ECF_Daruma();
end;

function TDarumaFramework.Daruma_FI_MapaResumo: Integer;
begin
  Result := _rGerarMapaResumo_ECF_Daruma;
end;

function TDarumaFramework.Daruma_FI_MinutosImprimindo(Minutos: String): Integer;
begin
  //Tipo retorno Tempo emitindo documentos fiscais (segs) com 6 posições
  Result := _rRetornarInformacao_ECF_Daruma('67', Minutos);
end;

function TDarumaFramework.Daruma_FI_MinutosLigada(Minutos: String): Integer;
begin
  //Tipo retorno Tempo operacional (segs) com 6 posições
  Result := _rRetornarInformacao_ECF_Daruma('68', Minutos);
end;

function TDarumaFramework.Daruma_FI_NomeiaDepartamento(Indice: Integer;
  Departamento: String): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_NomeiaTotalizadorNaoSujeitoIcms(Indice: Integer;
  Totalizador: String): Integer;
begin
  Result := _confCadastrar_ECF_Daruma('TNF', Totalizador, '|');
end;

function TDarumaFramework.Daruma_FI_NumeroCaixa(NumeroCaixa: String): Integer;
begin
  //Tipo retorno ECF com 3 posições
  Result := _rRetornarInformacao_ECF_Daruma('107', NumeroCaixa);
end;

function TDarumaFramework.Daruma_FI_NumeroCupom(NumeroCupom: String): Integer;
begin
  //Tipo retorno COO com 6 posições "000000"
  Result := _rRetornarInformacao_ECF_Daruma('26', NumeroCupom);
end;

function TDarumaFramework.Daruma_FI_NumeroCuponsCancelados(
  NumeroCancelamentos: String): Integer;
begin
  //Tipo retorno CFC com 4 posições
  Result := _rRetornarInformacao_ECF_Daruma('39', NumeroCancelamentos);
end;

function TDarumaFramework.Daruma_FI_NumeroIntervencoes(
  NumeroIntervencoes: String): Integer;
begin
  // Tipo retorno CRO com 3 posições
  Result  := _rRetornarInformacao_ECF_Daruma('23', NumeroIntervencoes);
end;

function TDarumaFramework.Daruma_FI_NumeroLoja(NumeroLoja: String): Integer;
begin
  //Tipo retorno Número da Loja com 4 posições
  Result := _rRetornarInformacao_ECF_Daruma('129', NumeroLoja);
end;

function TDarumaFramework.Daruma_FI_NumeroOperacoesNaoFiscais(
  NumeroOperacoes: String): Integer;
begin
  //Tipo retorno GNF com 6 posições
  Result := _rRetornarInformacao_ECF_Daruma('28', NumeroOperacoes);
end;

function TDarumaFramework.Daruma_FI_NumeroReducoes(NumeroReducoes: String): Integer;
begin
  //Tipo retorno CRZ com 4 posições
  Result := _rRetornarInformacao_ECF_Daruma('24', NumeroReducoes);
end;

function TDarumaFramework.Daruma_FI_NumeroSerie(NumeroSerie: String): Integer;
begin
  // Tipo retorno Número de fabricação do ECF com 20+1 posições (Quando ocorrido intervenção retorna 21 posições)
  Result := _rRetornarInformacao_ECF_Daruma('78', NumeroSerie);
end;

function TDarumaFramework.Daruma_FI_NumeroSubstituicoesProprietario(
  NumeroSubstituicoes: String): Integer;
begin
  // Tipo retorno Número de ordem seqüencial do usuário
  Result := _rRetornarInformacao_ECF_Daruma('94', NumeroSubstituicoes);
end;

function TDarumaFramework.Daruma_FI_ProgramaAliquota(Aliquota: String;
  ICMS_ISS: Integer): Integer;
begin
  if ICMS_ISS = 0 then
    Result := _confCadastrar_ECF_Daruma('ALIQUOTA', 'T' + Aliquota, '|') // ICMS
  else
    Result := _confCadastrar_ECF_Daruma('ALIQUOTA', 'S' + Aliquota, '|'); // ISS
end;

function TDarumaFramework.Daruma_FI_ProgramaArredondamento: Integer;
begin
  Result := _regAlterarValor_Daruma('ECF\ArredondarTruncar', 'A');
end;

function TDarumaFramework.Daruma_FI_ProgramaFormasPagamento(
  Formas: String): Integer;
begin
  Result := _confCadastrar_ECF_Daruma('FPGTO', Formas, '|');
end;

function TDarumaFramework.Daruma_FI_ProgramaHorarioVerao: Integer;
begin
  Result := _confHabilitarHorarioVerao_ECF_Daruma;
end;

function TDarumaFramework.Daruma_FI_ProgramaTruncamento: Integer;
begin
  Result := _regAlterarValor_Daruma('ECF\ArredondarTruncar', 'T');
end;

function TDarumaFramework.Daruma_FI_RecebimentoNaoFiscal(IndiceTotalizador, Valor,
  FormaPagamento: String): Integer;
begin
  Result := _iCNFReceberSemDesc_ECF_Daruma(IndiceTotalizador, Valor);
end;

function TDarumaFramework.Daruma_FI_ReducaoZ(Data, Hora: String): Integer;
begin
  Result := _iReducaoZ_ECF_Daruma(Data, Hora);
end;

function TDarumaFramework.Daruma_FI_RelatorioGerencial(Texto: String): Integer;
begin
  Result := _iRGImprimirTexto_ECF_Daruma(Texto);
end;

function TDarumaFramework.Daruma_FI_RelatorioTipo60Analitico: Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_RelatorioTipo60Mestre: Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_ResetaImpressora: Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_RetornaGNF(GNF: String): Integer;
begin
  //Tipo  	GNF com 06 posições
  Result := _rRetornarInformacao_ECF_Daruma('28', GNF);
end;

function TDarumaFramework.Daruma_FI_RetornoAliquotas(Aliquotas: String): Integer;
begin
  Result := _rLerAliquotas_ECF_Daruma(Aliquotas);
end;

function TDarumaFramework.Daruma_FI_RetornoImpressora: Integer;
// Erro do último comando. É diferente de _ecf17_CodeErro();
begin

  FDescErroUltimoComando  := StringOFChar(' ', 300);
  FDescAvisoUltimoComando := StringOFChar(' ', 300);

  FErroUltimoComando  := 0;
  FAvisoUltimoComando := 0;

  _rStatusUltimoCmdInt_ECF_Daruma(FErroUltimoComando, FAvisoUltimoComando);
  Result := _eRetornarAvisoErroUltimoCMD_ECF_Daruma(FDescAvisoUltimoComando, FDescErroUltimoComando);
  FDescAvisoUltimoComando := Trim(FDescAvisoUltimoComando);
  FDescErroUltimoComando  := Trim(FDescErroUltimoComando);
end;

function TDarumaFramework.Daruma_FI_Sangria(Valor: String): Integer;
begin
  Result := _iSangria_ECF_Daruma(pchar(Valor), pchar(''));
end;

function TDarumaFramework.Daruma_FI_SimboloMoeda(SimboloMoeda: String): Integer;
begin
  //Tipo retorno Símbolo da moeda atual com 2 posições
  Result := _rRetornarInformacao_ECF_Daruma('95', SimboloMoeda);
end;

function TDarumaFramework.Daruma_FI_StatusComprovanteNaoFiscalVinculado(
  StatusRel: String): Integer;
begin
  //Tipo Retorno Tipo do documento atual 0 = nenhum documento  1= CF  2=CNF  3=CCD  4=RG
  Result := _rRetornarInformacao_ECF_Daruma('56', StatusRel);
end;

function TDarumaFramework.Daruma_FI_StatusCupomFiscal(StatusRel: String): Integer;
begin
  //Tipo retorno Estado do CF / CNF: 0 = fechado 1 = CF em registro de item 2 = CF em totalização 3 = CF em pagamento 4 = CF em finalização 5 = CNF em registro de item 6 = CNF em totalização 7 = CNF em pagamento 8 = CNF em finalização
  Result := _rRetornarInformacao_ECF_Daruma('57', StatusRel);
end;

function TDarumaFramework.Daruma_FI_StatusRelatorioGerencial(
  StatusRel: String): Integer;
begin
  //Tipo retorno Tipo do documento atual 0 = nenhum documento  1= CF  2=CNF  3=CCD  4=RG
  Result := _rRetornarInformacao_ECF_Daruma('56', StatusRel);
end;

function TDarumaFramework.Daruma_FI_SubTotal(var SubTotal: String): Integer;
begin
  Subtotal := Replicate(' ', 12);
  Result := _rCFSubTotal_ECF_Daruma(SubTotal);
end;

function TDarumaFramework.Daruma_FI_Suprimento(Valor,
  FormaPagamento: String): Integer;
begin
  Result := _iSuprimento_ECF_Daruma(PChar(Valor), PChar(FormaPagamento));
end;

function TDarumaFramework.Daruma_FI_TerminaFechamentoCupom(
  Mensagem: String): Integer;
begin
  Result := _iCFEncerrarConfigMsg_ECF_Daruma(Mensagem);
end;

function TDarumaFramework.Daruma_FI_UltimoItemVendido(NumeroItem: String): Integer;
begin
  //Tipo retorno Número do último item registrado (CF ou CNF) com 3 posições
  Result := _rRetornarInformacao_ECF_Daruma('58', NumeroItem);
end;

function TDarumaFramework.Daruma_FI_UsaComprovanteNaoFiscalVinculado(
  Texto: String): Integer;
begin
  Result := _iCCDImprimirTexto_ECF_Daruma(Texto);
end;

function TDarumaFramework.Daruma_FI_UsaUnidadeMedida(
  UnidadeMedida: String): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_ValorFormaPagamento(FormaPagamento,
  Valor: String): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_ValorPagoUltimoCupom(
  ValorCupom: String): Integer;
begin
  //Tipo retorno Soma dos pagamentos aplicados ao documento atual com 13 posições
  Result := _rRetornarInformacao_ECF_Daruma('48', ValorCupom);
end;

function TDarumaFramework.Daruma_FI_VendaBruta(VendaBruta: String): Integer;
var
  sGT: String;
  sGTInicial: String;
begin
  //Para calcular a venda bruta você deve fazer o calcula GT - GTInicial, onde GT é o rRetornarInformacao_ECF_Daruma(1,) e GT inicial é rRetornarInformacao_ECF_Daruma(2,)
  SetLength(sGT, 18);
  SetLength(sGTInicial, 18);
  Result := _rRetornarInformacao_ECF_Daruma('1', sGT);
  if Result = 1 then
  begin
    Result := _rRetornarInformacao_ECF_Daruma('2', sGTInicial);
    VendaBruta := StringReplace(FormatFloat('0.00', (StrToFloatDef(sGT, 0)/100) - (StrToFloatDef(sGTInicial, 0)/100)), ',', '', [rfReplaceAll]);
  end;
end;

function TDarumaFramework.Daruma_FI_VendeItem(Aliquota, Quantidade,
  ValorUnitario, TipoDesconto, Desconto, Codigo, UnidadeMedida,
  DescricaoItem: String): Integer;
begin
  Result := _iCFVender_ECF_Daruma(Aliquota, Quantidade, ValorUnitario, TipoDesconto, Desconto, Codigo, UnidadeMedida, DescricaoItem);
  _ecf17.Daruma_FI_RetornoImpressora; // Sandro Silva 2019-08-08
end;

function TDarumaFramework.Daruma_FI_VendeItem1Lin13Dig(Codigo, Descricao, Aliquota,
  Quantidade, ValorUnitario, Acrescimo_Desconto,
  Percentual: String): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_VendeItemDepartamento(Codigo, Descricao,
  Aliquota, Quantidade, ValorUnitario, TipoDesconto,
  Desconto, UnidadeMedida: String): Integer;
begin
  Result := _iCFVender_ECF_Daruma(Trim(Aliquota), Trim(Quantidade), Trim(ValorUnitario), Trim(TipoDesconto), Trim(Desconto), Trim(Codigo), Trim(UnidadeMedida), Trim(Descricao));

  _ecf17.Daruma_FI_RetornoImpressora;
end;

function TDarumaFramework.Daruma_FI_VendeItemTresDecimais(Codigo, Descricao,
  Aliquota, Quantidade, ValorUnitario, TipoDesconto,
  Desconto, UnidadeMedida: String): Integer;
begin
  Result := _iCFVender_ECF_Daruma(Aliquota, Quantidade, ValorUnitario, TipoDesconto, Desconto, Codigo, UnidadeMedida, Descricao);
end;

function TDarumaFramework.Daruma_FI_VerificaAliquotasIss(Flag: String): Integer;
var
  sRetorno: String;
  iAliq: Integer;
begin
  //Tipo retorno string 150 posições
  //Ex: T0700;T1200;S0700;T0800;T0900;S0800;T0800;T0900;T1000;T1100;T1200;T1300;T1400;T1600;T1700;T1800;TF1;TF2;TI1;TI2;TN1;TN2;SFS1;SFS2;SIS1;SIS2;SNS1;SNS2
  // T - Alíquota de ICMS - Ex: 01700 - Alíquota de 17,00 de ICMS
  // S - Alíquota de ISS - Ex: 11700 - Alíquota de 17,00 de ISS
  SetLength(sRetorno, 150);
  Result := _rLerAliquotas_ECF_Daruma(sRetorno);
  with TStringList.Create do
  begin
    Delimiter := ';';
    DelimitedText := sRetorno;

    for iAliq := 0 to Count - 1 do
    begin
      if AnsiUpperCase(Copy(Strings[iALiq], 1, 1)) = 'S' then
      begin
        if Flag <> '' then
          Flag := Flag + ';';
        Flag := Flag + Strings[iALiq];
      end;
    end;

    Free;
  end;
end;

function TDarumaFramework.Daruma_FI_VerificaDepartamentos(
  Departamentos: String): Integer;
begin
  Result := 1; // _Daruma_FI_VerificaDepartamentos(Departamentos);
end;

function TDarumaFramework.Daruma_FI_VerificaDocAutenticacao: Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_VerificaEpromConectada(Flag: String): Integer;
begin
  Result := 1; //_Daruma_FI_VerificaEpromConectada(Flag);
end;

function TDarumaFramework.Daruma_FI_VerificaEstadoGaveta(
  var EstadoGaveta: Integer): Integer;
begin
  Result := _rStatusGaveta_ECF_Daruma(EstadoGaveta);
end;

function TDarumaFramework.Daruma_FI_VerificaEstadoGavetaStr(
  iParam1: Integer): Integer;
begin
  Result := _rStatusGaveta_ECF_Daruma(iParam1);
end;

function TDarumaFramework.Daruma_FI_VerificaFormasPagamento(
  Formas: String): Integer;
begin
  //Tipo retorno Totalizador de Meios de Pagamento 01 a 20 com 260 posições
  Result := _rRetornarInformacao_ECF_Daruma('6', Formas);
end;

function TDarumaFramework.Daruma_FI_VerificaImpressoraLigada: Integer;
begin
  Result := _rVerificarImpressoraLigada_ECF_Daruma;
end;

function TDarumaFramework.Daruma_FI_VerificaIndiceAliquotasIss(
  Flag: String): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_VerificaModeloECF(Modelo: String): Integer;
begin
  SetLength(Modelo, 20);
  Result :=_rRetornarInformacao_ECF_Daruma('81', Modelo);
end;

function TDarumaFramework.Daruma_FI_VerificaModoOperacao(Modo: String): Integer;
begin
  //Tipo retorno 18 posições
  SetLength (modo, 18);
  Result := _rStatusImpressoraBinario_ECF_Daruma(Modo);
end;

function TDarumaFramework.Daruma_FI_VerificaRecebimentoNaoFiscal(
  Recebimentos: String): Integer;
begin
  //Tipo retorno Totalizadores Não-Fiscais 02 a 20 com 247 posições
  Result := _rRetornarInformacao_ECF_Daruma('9', Recebimentos);
end;

function TDarumaFramework.Daruma_FI_VerificaTipoImpressora(
  var TipoImpressora: String): Integer;
begin
  //Tipo retorno Tipo do ECF com 7 posições
  Result := _rRetornarInformacao_ECF_Daruma('79', TipoImpressora);
end;

function TDarumaFramework.Daruma_FI_VerificaTotalizadoresNaoFiscais(
  Totalizadores: String): Integer;
begin
  //Tipo retorno Totalizadores Não-Fiscais 02 a 20 total de 247 posições
  Result := _rRetornarInformacao_ECF_Daruma('9', Totalizadores);
end;

function TDarumaFramework.Daruma_FI_VerificaTotalizadoresParciais(
  Totalizadores: String): Integer;
begin
  //Tipo retorno T01 a T16 + F1 + F2 + I1 + I2 + N1 + N2 + FS1 + FS2 + IS1 + IS2 + NS1 + NS2 com 364 posições
  Result := _rRetornarInformacao_ECF_Daruma('3', Totalizadores)
end;

function TDarumaFramework.Daruma_FI_VerificaTruncamento(Flag: string): Integer;
begin
  SetLength(Flag, 100);
  Result := _regRetornaValorChave_Daruma('ECF', 'ArredondarTruncar', Flag);
end;

function TDarumaFramework.Daruma_FI_VersaoFirmware(VersaoFirmware: String): Integer;
begin
  //Tipo retorno Versão do SB instalado com 6 posições
  Result := _rRetornarInformacao_ECF_Daruma('83',VersaoFirmware);
end;

function TDarumaFramework.Daruma_Registry_Ler_Configuracao(sProduto: String;
  sChave: String): String;
var
  Str_Valor: String;
begin
  Str_Valor := StringOFChar(#0,100);
  _regRetornaValorChave_DarumaFramework(sProduto, sChave, Str_Valor);
  Result := Str_Valor;
  ShowMessage(Result);
end;

function TDarumaFramework.Daruma_Registry_AplMensagem1(AplMsg1: String): Integer;
begin
  Result := _regAlterarValor_Daruma('ECF\MensagemApl1', AplMsg1);
end;

function TDarumaFramework.Daruma_Registry_AplMensagem2(AplMsg1: String): Integer;
begin
  Result := _regAlterarValor_Daruma('ECF\MensagemApl2', AplMsg1);
end;

function TDarumaFramework.Daruma_Registry_ConfigRede(ConfigRede: String): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_Registry_ControlePorta(
  ControlePorta: String): Integer;
begin
  Result := _regAlterarValor_Daruma('ECF\ControleAutomatico', ControlePorta);
end;

function TDarumaFramework.Daruma_Registry_Emulador(Emulador: String): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_Registry_Log(Log: String): Integer;
begin
  Result := _regAlterarValor_Daruma('ECF\Auditoria', Log);
end;

function TDarumaFramework.Daruma_Registry_MFD_LeituraMFCompleta(
  Valor: String): Integer;
begin
  Result := _regAlterarValor_Daruma('ECF\LMFCompleta', Valor);
end;

function TDarumaFramework.Daruma_Registry_ModoGaveta(ModoGaveta: String): Integer;
begin
  Result := _regAlterarValor_Daruma('ECF\ModoGaveta', ModoGaveta);
end;

function TDarumaFramework.Daruma_Registry_NomeLog(NomeLog: String): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_Registry_Path(Path: String; sTipo: String): Integer;
// Tipo = Arquivos ou Relatórios
begin
  if sTipo = 'Arquivos' then
    Result := _regAlterarValor_Daruma('START\LocalArquivos', Path)
  else
    if sTipo = 'PathBibliotecasAuxiliares' then
      Result := _regAlterarValor_Daruma('START\PathBibliotecasAuxiliares', Path)
    else
      Result := _regAlterarValor_Daruma('START\LocalArquivosRelatorios', Path);
end;

function TDarumaFramework.Daruma_Registry_Porta(Porta: String): Integer;
begin
  Result := _regAlterarValor_Daruma('ECF\PortaSerial', Porta);
end;

function TDarumaFramework.Daruma_Registry_Retorno(Retorno: String): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_Registry_Separador(Separador: String): Integer;
begin
  Result := _regAlterarValor_Daruma('ECF\CaracterSeparador', Separador);
end;

function TDarumaFramework.Daruma_Registry_SeparaMsgPromo(
  SeparaMsgPromo: String): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_Registry_Status(Status: String): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_Registry_StatusFuncao(
  StatusFuncao: String): Integer;
begin
  Result := _regAlterarValor_Daruma('ECF\RetornarAvisoErro', StatusFuncao);
end;

function TDarumaFramework.Daruma_Registry_VendeItemUmaLinha(
  ConfigRede: String): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_RFD_GerarArquivo(DataInicial,
  DataFinal: String): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_TEF_FechaRelatorio: Integer;
begin
  Result := _iTEF_Fechar_ECF_Daruma;
end;

function TDarumaFramework.Daruma_TEF_ImprimirResposta(Arquivo: String;
  Travar: Boolean): Integer;
begin
  Result := _iTEF_ImprimirResposta_ECF_Daruma(Arquivo, Travar);
end;

destructor TDarumaFramework.Destroy;
begin
  FinalizaDLL;
  inherited;
end;

procedure TDarumaFramework.FinalizaDLL;
begin
  _regAlterarValor_Daruma := nil;
  _regRetornaValorChave_DarumaFramework := nil;

    // Funções de Inicialização
  _confCadastrar_ECF_Daruma := nil;
  _confHabilitarHorarioVerao_ECF_Daruma := nil;
  _confProgramarAvancoPapel_ECF_Daruma := nil;

    // Funções do Cupom Fiscal
  _iCFAbrir_ECF_Daruma := nil;
  _iCFVender_ECF_Daruma := nil;
  _iCFCancelarUltimoItem_ECF_Daruma := nil;
  _iCFCancelarItem_ECF_Daruma := nil;
  _iCFCancelar_ECF_Daruma := nil;
  _iCFEncerrarResumido_ECF_Daruma := nil;
  _iCFEncerrar_ECF_Daruma := nil;
  _iCFTotalizarCupom_ECF_Daruma := nil;
  _iCFEfetuarPagamentoFormatado_ECF_Daruma := nil;
  _iCFEfetuarPagamento_ECF_Daruma := nil;
  _iCFEncerrarConfigMsg_ECF_Daruma := nil;
  _iCFIdentificarConsumidor_ECF_Daruma := nil;
  _iEstornarPagamento_ECF_Daruma := nil;

    // Funções dos Relatórios Fiscais
  _iLeituraX_ECF_Daruma := nil;
  _iReducaoZ_ECF_Daruma := nil;
  _iRGImprimirTexto_ECF_Daruma := nil;
  _iRGFechar_ECF_Daruma := nil;
  _iMFLer_ECF_Daruma := nil;
  _iMFLerSerial_ECF_Daruma := nil;
  _rGerarEspelhoMFD_ECF_Daruma := nil;

    // Funções das Operações Não Fiscais
  _iCNFReceberSemDesc_ECF_Daruma := nil;
  _iCCDAbrirSimplificado_ECF_Daruma := nil;
  _iCCDImprimirTexto_ECF_Daruma := nil;
  _iCCDFechar_ECF_Daruma := nil;
  _iSangria_ECF_Daruma := nil;
  _iSuprimento_ECF_Daruma := nil;

    // Funções de Informações da Impressora
  _rRetornarInformacao_ECF_Daruma := nil;
  _rLeituraX_ECF_Daruma := nil;
  _rStatusImpressoraBinario_ECF_Daruma := nil;
  _rDataHoraImpressora_ECF_Daruma := nil;
  _rRetornarInformacao_ECF_Daruma := nil;
  _regRetornaValorChave_Daruma := nil;
  _rLerAliquotas_ECF_Daruma := nil;
  _rLerDecimais_ECF_Daruma := nil;
  _rRetornarDadosReducaoZ_ECF_Daruma := nil;
    // Funções de Autenticação e Gaveta de Dinheiro
  _eAbrirGaveta_ECF_Daruma := nil;
  _rStatusGaveta_ECF_Daruma := nil;
    // Outras Funções
  _rStatusUltimoCmdInt_ECF_Daruma := nil;
  _eRetornarAvisoErroUltimoCMD_ECF_Daruma := nil;
  _iRelatorioConfiguracao_ECF_Daruma := nil;
    //funcoes de TEF
  _iTEF_ImprimirResposta_ECF_Daruma := nil;
  _iTEF_Fechar_ECF_Daruma := nil;
    //
  _rCodigoModeloFiscal_ECF_Daruma := nil;
    //
  _confCadastrar_ECF_Daruma := nil;
  _iRGAbrir_ECF_Daruma := nil;
  _rGerarRelatorio_ECF_Daruma := nil;
  _rEfetuarDownloadMF_ECF_Daruma := nil;
  _rEfetuarDownloadMFD_ECF_Daruma := nil;
  _rVerificarReducaoZ_ECF_Daruma := nil
end;

procedure TDarumaFramework.Import(var Proc: pointer; Name: Pchar);
begin
  if not Assigned(Proc) then
  begin
    Proc := GetProcAddress(DLL, Pchar(Name));
    if Proc = nil then
      raise Exception.Create('Não foi possível carregar a função ' + Name + ' da biblioteca ' + DARUMA_DLLNAME_17);
  end;
end;

function TDarumaFramework.Daruma_DownloadMF(sArquivo: String): Integer;
begin
  Result := _rEfetuarDownloadMF_ECF_Daruma(sArquivo);
end;

function TDarumaFramework.Daruma_DownloadMFD(COOInicial: String;
  COOFinal: String; sArquivo: String; Tipo: String = 'COO'): Integer;
begin
  // Sandro Silva 2017-08-01  Result := _rEfetuarDownloadMFD_ECF_Daruma('COO', COOInicial, COOFinal, sArquivo);
  COOInicial := Right('000000' + COOInicial,6);
  COOFinal   := Right('000000' + COOFinal, 6);
  Result := _rEfetuarDownloadMFD_ECF_Daruma(Tipo, COOInicial, COOFinal, sArquivo);
end;

function TDarumaFramework.Daruma_FI_VerificaReducaoZ: String;
var
  Str_VerificarRZ: String;
begin
  SetLength (Str_VerificarRZ,1);
  _rVerificarReducaoZ_ECF_Daruma(Str_VerificarRZ);
  Result := str_VerificarRZ; // 0 Não pendente; 1 Pendente
end;

function TDarumaFramework.Daruma_FI_LerCasasDecimais(var iDecimalQtd: Integer;
  var iDecimalUnitario: Integer): Integer;
var
  Str_DecimalQtde, Str_DecimalValor: String;
	Int_DecimalQtde: Integer;
  Int_DecimalValor: Integer;
begin
  SetLength(Str_DecimalQtde, 2);
  SetLength(Str_DecimalValor, 2);
  Result := _rLerDecimais_ECF_Daruma(Str_DecimalQtde, Str_DecimalValor, Int_DecimalQtde, Int_DecimalValor);
  iDecimalQtd      := Int_DecimalQtde;
  iDecimalUnitario := Int_DecimalValor;
end;

procedure TDarumaFramework.SetFErroUltimoComando(const Value: Integer);
begin
  FErroUltimoComando := Value;
end;

procedure TDarumaFramework.SetDescErroUltimoComando(const Value: String);
begin
  FDescErroUltimoComando := Trim(Value);
end;

procedure TDarumaFramework.SetFAvisoUltimoComando(const Value: Integer);
begin
  FAvisoUltimoComando := Value;
end;

procedure TDarumaFramework.SetFDescAvisoUltimoComando(const Value: String);
begin
  FDescAvisoUltimoComando := Trim(Value);
end;
*)
end.
