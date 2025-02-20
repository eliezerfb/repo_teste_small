{
Para agilizar programação da comunicação, foram usados mesmo métodos da unit _small_03.pas (daruma32.dll), que fazem chamadas ao métudos da darumaframework.dll

Alterações
Sandro Silva 2016-02-04
- Fiscal SEFAZ de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
}

unit udarumaframeworkclass;

interface

uses
  Windows, Messages
  {$IFDEF VER150}// – Delphi 7
  , SmallFunc
  {$ELSE}
  , smallfunc_xe
  {$ENDIF}
  , SysUtils,Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Mask, Grids
  //, DBGrids, DB, DBTables,  DBCtrls, SMALL_DBEdit, IniFiles, FileCtrl,
  ,StrUtils;

  // Declarar as funções da dll usando loadlibary evitando conflito com sat dimep
const DARUMA_DLLNAME_17 = 'DarumaFramework.dll';

type
  TDarumaFramework = class(TComponent)
    private
      FDLLHandle: THandle;
      _regAlterarValor_Daruma: function(pszPathChave: AnsiString; pszValor: AnsiString): Integer; StdCall;
      _regRetornaValorChave_DarumaFramework: function(pszProduto: AnsiString; pszChave: AnsiString; pszValor: AnsiString): Integer; StdCall;

      // Funções de Inicialização
      _confCadastrar_ECF_Daruma: function(pszCadastrar: AnsiString; pszValor: AnsiString; pszSeparador: AnsiString): Integer; StdCall;
      _confHabilitarHorarioVerao_ECF_Daruma: function(): Integer; StdCall;
      _confProgramarAvancoPapel_ECF_Daruma: function(pszSepEntreLinhas: AnsiString; pszSepEntreDoc: AnsiString; pszLinhasGuilhotina: AnsiString; pszGuilhotina: AnsiString; pszImpClicheAntecipada: AnsiString): Integer; StdCall;
      // Funções do Cupom Fiscal
      _iCFAbrir_ECF_Daruma: function(pszCPF: AnsiString; pszNome: AnsiString; pszEndereco: AnsiString):Integer; StdCall;
      _iCFVender_ECF_Daruma: function(pszCargaTributaria: AnsiString; pszQuantidade: AnsiString; pszPrecoUnitario: AnsiString; pszTipoDescAcresc: AnsiString; pszValorDescAcresc: AnsiString; pszCodigoItem:AnsiString; pszUnidadeMedida:AnsiString; pszDescricaoItem: AnsiString): Integer; StdCall;
      _iCFCancelarUltimoItem_ECF_Daruma:function(): Integer; StdCall;
      _iCFCancelarItem_ECF_Daruma: function(pszNumItemc: AnsiString): Integer; StdCall;
      _iCFCancelar_ECF_Daruma: function(): Integer; StdCall;
      _iCFEncerrarResumido_ECF_Daruma: function(): Integer; StdCall;
      _iCFEncerrar_ECF_Daruma: function(pszCupomAdicional: AnsiString; pszMensagem: AnsiString):Integer; StdCall;
      _iCFTotalizarCupom_ECF_Daruma: function(pszTipoDescAcresc: AnsiString; pszValorDescAcresc: AnsiString): Integer; StdCall;
      _iCFEfetuarPagamentoFormatado_ECF_Daruma: function(pszFormaPgto: AnsiString; pszValor: AnsiString): Integer; StdCall;
      _iCFEfetuarPagamento_ECF_Daruma: function(pszFormaPgto: AnsiString; pszValor: AnsiString; pszInfoAdicional: AnsiString): Integer; StdCall;
      _iCFEncerrarConfigMsg_ECF_Daruma: function(pszMensagem: AnsiString): Integer; StdCall;
      _iCFIdentificarConsumidor_ECF_Daruma: function(pszNome: AnsiString; pszEndereco: AnsiString; pszDoc: AnsiString): Integer; StdCall;
      _iEstornarPagamento_ECF_Daruma: function(pszFormaPgtoEstornado: AnsiString; pszFormaPgtoEfetivado: AnsiString; pszValor: AnsiString; pszInfoAdicional: AnsiString): Integer; StdCall;

      // Funções dos Relatórios Fiscais
      _iLeituraX_ECF_Daruma: function(): Integer; StdCall;
      _iReducaoZ_ECF_Daruma: function(pszData: AnsiString; pszHora: AnsiString): Integer; StdCall;
      _iRGImprimirTexto_ECF_Daruma: function(pszTexto: AnsiString): Integer; StdCall;
      _iRGFechar_ECF_Daruma: function(): Integer; StdCall;
      _iMFLer_ECF_Daruma: function(pszInicial: AnsiString; pszFinal: AnsiString): Integer; StdCall;
      _iMFLerSerial_ECF_Daruma: function(pszInicial:AnsiString; pszFinal:AnsiString): Integer; StdCall;
      _rGerarEspelhoMFD_ECF_Daruma: function(pszTipo: AnsiString; pszInicial: AnsiString; pszFinal: AnsiString): Integer; StdCall;

      // Funções das Operações Não Fiscais
      _iCNFReceberSemDesc_ECF_Daruma: function(pszIndice: AnsiString; pszValor: AnsiString): Integer; StdCall;
      _iCCDAbrirSimplificado_ECF_Daruma: function(pszFormaPgto:AnsiString; pszParcelas:AnsiString; pszDocOrigem:AnsiString; pszValor:AnsiString): Integer; StdCall;
      _iCCDImprimirTexto_ECF_Daruma: function(pszTexto: AnsiString): Integer; StdCall;
      _iCCDFechar_ECF_Daruma: function(): Integer; StdCall;
      _iSangria_ECF_Daruma: function(pszValor: AnsiString; pszMensagem: AnsiString): Integer; StdCall;
      _iSuprimento_ECF_Daruma: function(pszValor: AnsiString; pszMensagem: AnsiString): Integer; StdCall;

      // Funções de Informações da Impressora
      _rRetornarInformacao_ECF_Daruma: function(pszIndice: AnsiString; pszRetornar: AnsiString): Integer; StdCall;
      _rCFSubTotal_ECF_Daruma: function(pszValor: AnsiString):Integer; StdCall;
      _rLeituraX_ECF_Daruma: function():Integer; StdCall;
      _rStatusImpressoraBinario_ECF_Daruma: function(pszStatus: AnsiString):Integer; StdCall;
      _rCFVerificarStatus_ECF_Daruma: function(pszStatus: AnsiString; var piStatus: Integer): Integer; StdCall;
      _rDataHoraImpressora_ECF_Daruma: function(pszData: AnsiString; pszHora: AnsiString): Integer; StdCall;
      _regRetornaValorChave_Daruma: function(pszProduto: AnsiString; pszChave: AnsiString; pszValor: AnsiString):Integer; StdCall;
      _rLerAliquotas_ECF_Daruma: function(cAliquotas: AnsiString): Integer; StdCall;
      _rLerDecimais_ECF_Daruma: function(pszDecimalQtde: AnsiString; pszDecimalValor: AnsiString; var piDecimalQtde: Integer; var piDecimalValor: Integer): Integer; StdCall;
      _rRetornarDadosReducaoZ_ECF_Daruma: function(pszRetorno: AnsiString): Integer; StdCall;

      // Funções de Autenticação e Gaveta de Dinheiro
      _eAbrirGaveta_ECF_Daruma: function(): Integer; StdCall;
      _rStatusGaveta_ECF_Daruma: function(var piStatusGaveta: Integer): Integer; StdCall;

      // Outras Funções
      _rStatusUltimoCmdInt_ECF_Daruma: function(var piErro: integer; var piAviso: integer): Integer; StdCall;
      _eRetornarAvisoErroUltimoCMD_ECF_Daruma: function(pszAviso: AnsiString; pszErro: AnsiString): Integer; StdCall;
      _rGerarMapaResumo_ECF_Daruma: function(): Integer; StdCall;
      _iRelatorioConfiguracao_ECF_Daruma: function(): Integer; StdCall;
      _rVerificarImpressoraLigada_ECF_Daruma: function(): Integer; StdCall;

      //funcoes de TEF
      _iTEF_ImprimirResposta_ECF_Daruma: function(szArquivo: AnsiString; bTravarTeclado: Boolean):Integer; StdCall;
      _iTEF_Fechar_ECF_Daruma: function(): Integer; StdCall;
      //
      _rCodigoModeloFiscal_ECF_Daruma: function(pszValor: AnsiString): Integer; StdCall;
      //
      //
      _iRGAbrir_ECF_Daruma: function(pszNomeRG: AnsiString): Integer; StdCall;
      _rGerarRelatorio_ECF_Daruma: function(szRelatorio: AnsiString; szTipo: AnsiString; szInicial: AnsiString; szFinal: AnsiString): Integer; StdCall;
  		_rEfetuarDownloadMF_ECF_Daruma: function(pszNomeArquivo: AnsiString): Integer; StdCall;
      _rEfetuarDownloadMFD_ECF_Daruma: function(pszTipo: AnsiString; pszInicial: AnsiString; pszFinal: AnsiString; pszNomeArquivo: AnsiString): Integer; StdCall;
      _rVerificarReducaoZ_ECF_Daruma: function(zPendente: AnsiString): Integer; StdCall;
      FLoad: Boolean;
      FErroUltimoComando: Integer;
      FDescErroUltimoComando: String;
      FAvisoUltimoComando: Integer;
      FDescAvisoUltimoComando: String;
      //FProtocoloUnico: String;
      procedure Import(var Proc: pointer; Name: PAnsichar);
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
      property DLL: THandle read FDLLHandle write FDLLHandle;

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
      function Daruma_EspelhoMFD(dtInicial, dtFinal: String): Integer;
      function Daruma_DownloadMF(sArquivo: String): Integer;
      function Daruma_DownloadMFD(COOInicial: String; COOFinal: String; sArquivo: String; Tipo: String = 'COO'): Integer;

      // Funções das Operações Não Fiscais
      function Daruma_FI_RecebimentoNaoFiscal( IndiceTotalizador: String; Valor: String; FormaPagamento: String ): Integer;
      function Daruma_FI_AbreComprovanteNaoFiscalVinculado(FormaPagamento: String; Valor: String; NumeroCupom: String ): Integer;
      function Daruma_FI_UsaComprovanteNaoFiscalVinculado(Texto: String ): Integer;
      function Daruma_FI_FechaComprovanteNaoFiscalVinculado: Integer;
      function Daruma_FI_Sangria(Valor: String ): Integer;
      function Daruma_FI_Suprimento(Valor: String; FormaPagamento: String): Integer;
      // Funções de Informações da Impressora
      function Daruma_FI_StatusCupomFiscal( StatusRel: String ): Integer;
      function Daruma_FI_StatusComprovanteNaoFiscalVinculado( StatusRel: String ): Integer;
      function Daruma_FI_StatusRelatorioGerencial(var StatusRel: String ): Integer;
      function Daruma_FI_NumeroSerie(var NumeroSerie: String ): Integer;
      function Daruma_FI_SubTotal(var SubTotal: String ): Integer;
      function Daruma_FI_NumeroCupom(var NumeroCupom: String ): Integer;
      function Daruma_FI_RetornaGNF(var GNF: String ): Integer;
      function Daruma_FI_LeituraXSerial: Integer;
      function Daruma_FI_VersaoFirmware(var VersaoFirmware: String ): Integer;
      function Daruma_FI_CGC_IE(var CGC: String; var IE: String ): Integer;
      function Daruma_FI_GrandeTotal(var GrandeTotal: String ): Integer;
      function Daruma_FI_VendaBruta(var VendaBruta: String ): Integer;
      function Daruma_FI_Cancelamentos(var ValorCancelamentos: String ): Integer;
      function Daruma_FI_Descontos(var ValorDescontos: String ): Integer;
      function Daruma_FI_NumeroOperacoesNaoFiscais(var NumeroOperacoes: String ): Integer;
      function Daruma_FI_NumeroCuponsCancelados(var NumeroCancelamentos: String ): Integer;
      function Daruma_FI_NumeroIntervencoes(var NumeroIntervencoes: String ): Integer;
      function Daruma_FI_NumeroReducoes(var NumeroReducoes: String ): Integer;
      function Daruma_FI_NumeroSubstituicoesProprietario(var NumeroSubstituicoes: String ): Integer;
      function Daruma_FI_UltimoItemVendido(var NumeroItem: String ): Integer;
      function Daruma_FI_ClicheProprietarioEx(var ClicheEx: String ): Integer;
      function Daruma_FI_NumeroCaixa(var NumeroCaixa: String ): Integer;
      function Daruma_FI_NumeroLoja(var NumeroLoja: String ): Integer;
      function Daruma_FI_SimboloMoeda(var SimboloMoeda: String ): Integer;
      function Daruma_FI_MinutosLigada(var Minutos: String ): Integer;
      function Daruma_FI_MinutosImprimindo(var Minutos: String ): Integer;
      function Daruma_FI_VerificaModoOperacao(var Modo: string ): Integer;
      function Daruma_FI_VerificaEpromConectada(var Flag: String ): Integer;
      function Daruma_FI_FlagsFiscais(var Flag: Integer ): Integer;
      function Daruma_FI_ValorPagoUltimoCupom(var ValorCupom: String ): Integer;
      function Daruma_FI_DataHoraImpressora(var Data: String; var Hora: String ): Integer;
      function Daruma_FI_ContadoresTotalizadoresNaoFiscais(var Contadores: String ): Integer;
      function Daruma_FI_VerificaTotalizadoresNaoFiscais(var Totalizadores: String ): Integer;
      function Daruma_FI_DataHoraReducao(var Data: String; var Hora: String ): Integer;
      function Daruma_FI_DataMovimento(var Data: String): Integer;
      function Daruma_FI_VerificaTruncamento(var Flag: String ): Integer;
      function Daruma_FI_Acrescimos(var ValorAcrescimos: String ): Integer;
      function Daruma_FI_ContadorBilhetePassagem(var ContadorPassagem: String ): Integer;
      function Daruma_FI_VerificaAliquotasIss(var Flag: String ): Integer;
      function Daruma_FI_VerificaFormasPagamento(var Formas: String ): Integer;
      function Daruma_FI_VerificaRecebimentoNaoFiscal(var Recebimentos: String ): Integer;
      function Daruma_FI_VerificaDepartamentos(var Departamentos: String ): Integer;
      function Daruma_FI_VerificaTipoImpressora(var TipoImpressora: String): Integer;
      function Daruma_FI_VerificaTotalizadoresParciais(var Totalizadores: String ): Integer;
      function Daruma_FI_RetornoAliquotas(var Aliquotas: String ): Integer;
      function Daruma_FI_DadosUltimaReducao(var DadosReducao: String ): Integer;
      function Daruma_FI_VerificaIndiceAliquotasIss(var Flag: String ): Integer;
      function Daruma_FI_ValorFormaPagamento(var FormaPagamento: String; var Valor: String ): Integer;
      function Daruma_FI_VerificaModeloECF(var Modelo: String): Integer;
      // Funções de Autenticação e Gaveta de Dinheiro
      function Daruma_FI_Autenticacao: Integer;
      function Daruma_FI_AutenticacaoStr(str :string): Integer;
      function Daruma_FI_VerificaDocAutenticacao: Integer;
      function Daruma_FI_AcionaGaveta:Integer;
      function Daruma_FI_VerificaEstadoGaveta(var EstadoGaveta: Integer ): Integer;
      // Outras Funções
      function Daruma_FI_AbrePortaSerial: Integer;
      function Daruma_FI_RetornoImpressora: Integer;
      function Daruma_FI_FechaPortaSerial: Integer;
      function Daruma_FI_MapaResumo:Integer;
      function Daruma_FI_AberturaDoDia(var ValorCompra: String;
        var FormaPagamento: String): Integer;
      function Daruma_FI_FechamentoDoDia: Integer;
      function Daruma_FI_ImprimeConfiguracoesImpressora:Integer;
      function Daruma_FI_ImprimeDepartamentos: Integer;
      function Daruma_FI_RelatorioTipo60Analitico: Integer;
      function Daruma_FI_RelatorioTipo60Mestre: Integer;
      function Daruma_FI_VerificaImpressoraLigada: Integer;
      function Daruma_FI_ImprimeConfiguracoes: Integer;
      function Daruma_FI_VerificaReducaoZ: String;
      //funcoes de TEF
      function Daruma_TEF_ImprimirResposta(Arquivo: String;
        Travar: Boolean): Integer;
      function Daruma_TEF_FechaRelatorio: Integer;
      //
      function Daruma_FI_VerificaEstadoGavetaStr(iParam1: Integer): Integer;
      function Daruma_FI_FlagsFiscaisStr(var sParam1: String): Integer;
      function Daruma_FIMFD_RetornaInformacao(Indice: String; var Valor: String ): Integer;
      function Daruma_FIMFD_CodigoModeloFiscal(var Valor: String): Integer;
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
  {Sandro Silva 2015-06-18 final}

  //

implementation

{ TDarumaFramework }

function TDarumaFramework.CarregaDLL: Boolean;
begin
  Result := False;
  try
    FDLLHandle     := LoadLibrary(PChar(ExtractFilePath(Application.ExeName) + DARUMA_DLLNAME_17)); //carregando dll

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
      if FDLLHandle = 0 then
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
  Result := _iRGAbrir_ECF_Daruma(AnsiString(NomeRelatorio)); //Sandro Silva 2020-08-28 Result := _iRGAbrir_ECF_Daruma(NomeRelatorio);
end;

function TDarumaFramework.Daruma_FIMFD_CodigoModeloFiscal(var Valor: String): Integer;
begin
  Result := Daruma_FIMFD_RetornaInformacao('82', Valor); // Sandro Silva 2020-08-26 Result := _rCodigoModeloFiscal_ECF_Daruma(Valor);
  //Valor := Copy(Valor, 1, 6);
end;

function TDarumaFramework.Daruma_FIMFD_DownloadDaMFD(CoInicial,
  CoFinal: String): Integer;
begin
  Result := _rGerarEspelhoMFD_ECF_Daruma(AnsiString('2'), AnsiString(CoInicial), AnsiString(CoFinal)); // 1 = DATA; 2 = COO; 3 = DATAM //Sandro Silva 2020-08-28 Result := _rGerarEspelhoMFD_ECF_Daruma('2', CoInicial, CoFinal); // 1 = DATA; 2 = COO; 3 = DATAM
end;

function TDarumaFramework.Daruma_EspelhoMFD(dtInicial,
  dtFinal: String): Integer;
begin
  if Pos('/', dtInicial) <> 0 then
  begin
    Result := _rGerarEspelhoMFD_ECF_Daruma(AnsiString('1'), AnsiString(LimpaNumero(dtInicial)), AnsiString(LimpaNumero(dtFinal))) // 1 = DATA; 2 = COO; 3 = DATAM //Sandro Silva 2020-08-28 Result := _rGerarEspelhoMFD_ECF_Daruma('1', LimpaNumero(Inicial), LimpaNumero(Final)) // 1 = DATA; 2 = COO; 3 = DATAM
  end
  else
    Result := _rGerarEspelhoMFD_ECF_Daruma(AnsiString('2'), AnsiString(dtInicial), AnsiString(dtFinal)); // 1 = DATA; 2 = COO; 3 = DATAM //Sandro Silva 2020-08-28 Result := _rGerarEspelhoMFD_ECF_Daruma('2', Inicial, Final); // 1 = DATA; 2 = COO; 3 = DATAM
end;

function TDarumaFramework.Daruma_FIMFD_GerarAtoCotepePafCOO(Relatorio: String;
   Tipo: String; COOIni, COOFim: String): Integer;
begin
  Result := _rGerarRelatorio_ECF_Daruma(AnsiString(Relatorio), AnsiString(Tipo), AnsiString(COOIni), AnsiString(COOFim)); //Sandro Silva 2020-08-28 Result := _rGerarRelatorio_ECF_Daruma(Relatorio, Tipo, COOIni, COOFim);
end;

function TDarumaFramework.Daruma_FIMFD_GerarAtoCotepePafData(Relatorio: String;
   Tipo: String; DataInicial: String; DataFinal: String): Integer;
begin
  Result := _rGerarRelatorio_ECF_Daruma(AnsiString(Relatorio), AnsiString(Tipo), AnsiString(DataInicial), AnsiString(DataFinal)); //Sandro Silva 2020-08-28 Result := _rGerarRelatorio_ECF_Daruma(Relatorio, Tipo, DataInicial, DataFinal);
end;

function TDarumaFramework.Daruma_FIMFD_ProgramaRelatoriosGerenciais(
  NomeRelatorio: String): Integer;
begin
  Result := _confCadastrar_ECF_Daruma(AnsiString('RG'), AnsiString(NomeRelatorio), AnsiString('|')); //Sandro Silva 2020-08-28 Result := _confCadastrar_ECF_Daruma('RG', NomeRelatorio, '|');
end;

function TDarumaFramework.Daruma_FIMFD_RetornaInformacao(Indice: String;
  var Valor: String): Integer;
var
  asIndice: AnsiString;
  asValor: AnsiString;
begin
  asIndice := AnsiString(Indice);
  asValor := AnsiString(StringOfChar(#0, 3000)); // Sandro Silva 2020-08-31 asValor := AnsiString(Valor);
  Result := _rRetornarInformacao_ECF_Daruma(asIndice, asValor); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma(Indice, Valor);
  Valor := String(asValor);
end;

function TDarumaFramework.Daruma_FI_AberturaDoDia(var ValorCompra: String;
  var FormaPagamento: string): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_AbreComprovanteNaoFiscalVinculado(
  FormaPagamento, Valor, NumeroCupom: String): Integer;
begin
  Result := _iCCDAbrirSimplificado_ECF_Daruma(AnsiString(FormaPagamento), AnsiString('1'), AnsiString(NumeroCupom), AnsiString(Valor)); //Sandro Silva 2020-08-28   Result := _iCCDAbrirSimplificado_ECF_Daruma(FormaPagamento, '1', NumeroCupom, Valor);
end;

function TDarumaFramework.Daruma_FI_AbreCupom(CGC_CPF: String): Integer;
begin
  Result := _iCFAbrir_ECF_Daruma(AnsiString(CGC_CPF), AnsiString(''), AnsiString('')); //Sandro Silva 2020-08-28 Result := _iCFAbrir_ECF_Daruma(CGC_CPF, '', '');
end;

function TDarumaFramework.Daruma_FI_AbrePortaSerial: Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_AcionaGaveta: Integer;
begin
  Result := _eAbrirGaveta_ECF_Daruma;
end;

function TDarumaFramework.Daruma_FI_Acrescimos(var ValorAcrescimos: String): Integer;
begin
  ValorAcrescimos := Replicate('0', 13);
  Result := Daruma_FIMFD_RetornaInformacao('12', ValorAcrescimos); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('12', ValorAcrescimos);
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

    {Sandro Silva 2020-08-28
    // Daruma_FI_RetornoImpressora zera estas duas variávies
    FErroUltimoComando  := 0;// _ecf17.ErroUltimoComando  := 0;
    FAvisoUltimoComando := 0;// _ecf17.AvisoUltimoComando := 0;
    }
    Daruma_FI_RetornoImpressora; // _ecf17.Daruma_FI_RetornoImpressora;
    if FErroUltimoComando <> 0 then // if _ecf17.ErroUltimoComando <> 0 then
      Result := FErroUltimoComando; // Result := _ecf17.ErroUltimoComando;
  end;

end;

function TDarumaFramework.Daruma_FI_CancelaItemAnterior: Integer;
begin
  Result := _iCFCancelarUltimoItem_ECF_Daruma;
end;

function TDarumaFramework.Daruma_FI_CancelaItemGenerico(
  NumeroItem: String): Integer;
begin
  Result := _iCFCancelarItem_ECF_Daruma(AnsiString(NumeroItem)); //Sandro Silva 2020-08-28 Result := _iCFCancelarItem_ECF_Daruma(NumeroItem);
end;

function TDarumaFramework.Daruma_FI_Cancelamentos(
  var ValorCancelamentos: String): Integer;
begin
  //Tipo retorno Totalizador de Cancelamentos ICMS com 13 posições
  Result := Daruma_FIMFD_RetornaInformacao('13',ValorCancelamentos); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('13',ValorCancelamentos);
end;

function TDarumaFramework.Daruma_FI_CGC_IE(var CGC: String; var IE: String): Integer;
begin
  {Sandro Silva 2020-08-28
  //Tipo retorno CNPJ do usuário atual com 20 posições
  _rRetornarInformacao_ECF_Daruma('90', CGC);
  //Tipo retorno IE do usuário atual com 20 posições
  Result := _rRetornarInformacao_ECF_Daruma('91', IE);
 }
  //Tipo retorno CNPJ do usuário atual com 20 posições
  Daruma_FIMFD_RetornaInformacao('90', CGC);
  //Tipo retorno IE do usuário atual com 20 posições
  Result := Daruma_FIMFD_RetornaInformacao('91', IE);
 {Sandro Silva 2020-08-28 }
end;

function TDarumaFramework.Daruma_FI_ClicheProprietarioEx(var ClicheEx: String): Integer;
begin
  //Tipo retorno Clichê até 219 posições
  Result := Daruma_FIMFD_RetornaInformacao('132', ClicheEx); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('132', ClicheEx);
end;

function TDarumaFramework.Daruma_FI_ContadorBilhetePassagem(
  var ContadorPassagem: String): Integer;
begin
  Result := 1; //_Daruma_FI_ContadorBilhetePassagem(ContadorPassagem);
end;

function TDarumaFramework.Daruma_FI_ContadoresTotalizadoresNaoFiscais(
  var Contadores: String): Integer;
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
  Result := Daruma_FIMFD_RetornaInformacao('140', Str_Informacao); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('140', Str_Informacao);
  DadosReducao := LimpaSharp(Str_Informacao);
end;

function TDarumaFramework.Daruma_FI_DataHoraImpressora(var Data: String;
  var Hora: String): Integer;
begin
  //Tipo retorno Data e hora atual da impressora (DDMMAAAA hhmmss)
  Result := _rDataHoraImpressora_ECF_Daruma(AnsiString(Data), AnsiString(Hora)); //Sandro Silva 2020-08-28 Result := _rDataHoraImpressora_ECF_Daruma(Data, Hora);
end;

function TDarumaFramework.Daruma_FI_DataHoraReducao(var Data: String;
  var Hora: String): Integer;
var
  sDataHora: String;
begin
  //Tipo retorno Data da última RZ gravada na MF com 14 posições
  sDataHora := DupeString(' ', 14);
  Result := Daruma_FIMFD_RetornaInformacao('154', sDataHora); // Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('154', sDataHora); // '09062016154545'
  //sDataHora := String(sDataHora); // Sandro Silva 2020-08-26
  if Result = 1 then
  begin
    Data := Copy(sDataHora, 1, 8); // Sandro Silva 2020-08-26
    Hora := Copy(sDataHora, 9, 6); // Sandro Silva 2020-08-26
  end;
end;

function TDarumaFramework.Daruma_FI_DataMovimento(var Data: String): Integer;
begin
  //Tipo retorno Data do Movimento com 8 posições
  Result := Daruma_FIMFD_RetornaInformacao('70', Data); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('70', Data);
end;

function TDarumaFramework.Daruma_FI_Descontos(var ValorDescontos: String): Integer;
begin
  //Tipo retorno Totalizador de Descontos ICMS 13 posições
  Result := Daruma_FIMFD_RetornaInformacao('11', ValorDescontos); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('11', ValorDescontos);
end;

function TDarumaFramework.Daruma_FI_EfetuaFormaPagamento(FormaPagamento,
  ValorFormaPagamento: String): Integer;
begin
  Result := _iCFEfetuarPagamentoFormatado_ECF_Daruma(AnsiString(FormaPagamento), AnsiString(Trim(ValorFormaPagamento))); //Sandro Silva 2020-08-28 Result := _iCFEfetuarPagamentoFormatado_ECF_Daruma(FormaPagamento, Trim(ValorFormaPagamento));
end;

function TDarumaFramework.Daruma_FI_EfetuaFormaPagamentoDescricaoForma(
  FormaPagamento, ValorFormaPagamento,
  DescricaoFormaPagto: string): integer;
begin
  Result := _iCFEfetuarPagamento_ECF_Daruma(AnsiString(FormaPagamento), AnsiString(ValorFormaPagamento), AnsiString(DescricaoFormaPagto)); //Sandro Silva 2020-08-28 Result := _iCFEfetuarPagamento_ECF_Daruma(FormaPagamento,  ValorFormaPagamento, DescricaoFormaPagto);
end;

function TDarumaFramework.Daruma_FI_EspacoEntreLinhas(Dots: Integer): Integer;
begin
  Result := 1; //_confProgramarAvancoPapel_ECF_Daruma();
end;

function TDarumaFramework.Daruma_FI_EstornoFormasPagamento(FormaOrigem,
  FormaDestino, Valor: String): Integer;
begin
  Result := _iEstornarPagamento_ECF_Daruma(AnsiString(FormaOrigem), AnsiString(FormaDestino), AnsiString(Valor), AnsiString('')); //Sandro Silva 2020-08-28 Result := _iEstornarPagamento_ECF_Daruma(FormaOrigem, FormaDestino, Valor, '');
end;

function TDarumaFramework.Daruma_FI_FechaComprovanteNaoFiscalVinculado: Integer;
begin
  Result := _iCCDFechar_ECF_Daruma;
end;

function TDarumaFramework.Daruma_FI_FechaCupom(FormaPagamento, AcrescimoDesconto,
  TipoAcrescimoDesconto, ValorAcrescimoDesconto, ValorPago,
  Mensagem: String): Integer;
begin
  Result := _iCFEncerrar_ECF_Daruma(AnsiString('0'), AnsiString(Mensagem)); //Sandro Silva 2020-08-28 Result := _iCFEncerrar_ECF_Daruma('0', Mensagem);
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
  Str_StatusCupomFiscal: AnsiString; //Sandro Silva 2020-08-31 Str_StatusCupomFiscal:String;
begin
  Str_StatusCupomFiscal :=  AnsiString(StringOfChar(#0, 2)); //Sandro Silva 2020-08-31 SetLength (Str_StatusCupomFiscal, 2);
  Result := _rCFVerificarStatus_ECF_Daruma(Str_StatusCupomFiscal, Flag);
end;

function TDarumaFramework.Daruma_FI_FlagsFiscaisStr(
  var sParam1: String): Integer;
var
  asParam: AnsiString;
begin
  asParam := AnsiString(StringOfChar(#0, 18));
  //asParam := DupeString(' ', 18);
  Result := _rStatusImpressoraBinario_ECF_Daruma(asParam); //Sandro Silva 2020-08-28 Result := _rStatusImpressoraBinario_ECF_Daruma(asParam); //Sandro Silva 2020-08-28 Result := _rStatusImpressoraBinario_ECF_Daruma(sParam1);
  sParam1 := asParam;// Copy(asParam, 1, 18) //Copy(asParam, 1, 18);
end;

function TDarumaFramework.Daruma_FI_ForcaImpactoAgulhas(
  ForcaImpacto: Integer): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_GrandeTotal(var GrandeTotal: String): Integer;
begin
  // Tipo retorno GT com 18 posições
  Result := Daruma_FIMFD_RetornaInformacao('1', GrandeTotal); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('1', GrandeTotal);
  Daruma_FI_RetornoImpressora; // _ecf17.Daruma_FI_RetornoImpressora;
end;

function TDarumaFramework.Daruma_FI_IdentificaConsumidor(Nome, Endereco,
  Doc: String): Integer;
begin
  Result := _iCFIdentificarConsumidor_ECF_Daruma(AnsiString(Copy(Nome, 1, 30)), AnsiString(Endereco), AnsiString(Doc)); //Sandro Silva 2020-08-28 Result := _iCFIdentificarConsumidor_ECF_Daruma(Copy(Nome, 1, 30), Endereco, Doc); // Sandro Silva 2019-08-07  Result := _iCFIdentificarConsumidor_ECF_Daruma(Nome, Endereco, Doc);
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
  Result := _iCFTotalizarCupom_ECF_Daruma(AnsiString(TipoAcrescimoDesconto), AnsiString(ValorAcrescimoDesconto)); //Sandro Silva 2020-08-28 Result := _iCFTotalizarCupom_ECF_Daruma(TipoAcrescimoDesconto, ValorAcrescimoDesconto);
end;

function TDarumaFramework.Daruma_FI_LeituraMemoriaFiscalData(DataInicial,
  DataFinal: String): Integer;
begin
  Result := _iMFLer_ECF_Daruma(AnsiString(DataInicial), AnsiString(DataFinal)); //Sandro Silva 2020-08-28 Result := _iMFLer_ECF_Daruma(DataInicial, DataFinal);
end;

function TDarumaFramework.Daruma_FI_LeituraMemoriaFiscalReducao(ReducaoInicial,
  ReducaoFinal: String): Integer;
begin
  Result := _iMFLer_ECF_Daruma(AnsiString(ReducaoInicial), AnsiString(ReducaoFinal)); //Sandro Silva 2020-08-28 Result := _iMFLer_ECF_Daruma(ReducaoInicial, ReducaoFinal);
end;

function TDarumaFramework.Daruma_FI_LeituraMemoriaFiscalSerialData(DataInicial,
  DataFinal: String): Integer;
begin
  Result := _iMFLerSerial_ECF_Daruma(AnsiString(DataInicial), AnsiString(DataFinal)); //Sandro Silva 2020-08-28 Result := _iMFLerSerial_ECF_Daruma(DataInicial, DataFinal);
end;

function TDarumaFramework.Daruma_FI_LeituraMemoriaFiscalSerialReducao(
  ReducaoInicial, ReducaoFinal: String): Integer;
begin
  Result := _iMFLerSerial_ECF_Daruma(AnsiString(ReducaoInicial), AnsiString(ReducaoFinal)); //Sandro Silva 2020-08-28 Result := _iMFLerSerial_ECF_Daruma(ReducaoInicial, ReducaoFinal);
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

function TDarumaFramework.Daruma_FI_MinutosImprimindo(var Minutos: String): Integer;
begin
  //Tipo retorno Tempo emitindo documentos fiscais (segs) com 6 posições
  Result := Daruma_FIMFD_RetornaInformacao('67', Minutos); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('67', Minutos);
end;

function TDarumaFramework.Daruma_FI_MinutosLigada(var Minutos: String): Integer;
begin
  //Tipo retorno Tempo operacional (segs) com 6 posições
  Result := Daruma_FIMFD_RetornaInformacao('68', Minutos); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('68', Minutos);
end;

function TDarumaFramework.Daruma_FI_NomeiaDepartamento(Indice: Integer;
  Departamento: String): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_NomeiaTotalizadorNaoSujeitoIcms(Indice: Integer;
  Totalizador: String): Integer;
begin
  Result := _confCadastrar_ECF_Daruma(AnsiString('TNF'), AnsiString(Totalizador), AnsiString('|')); //Sandro Silva 2020-08-28 Result := _confCadastrar_ECF_Daruma('TNF', Totalizador, '|');
end;

function TDarumaFramework.Daruma_FI_NumeroCaixa(var NumeroCaixa: String): Integer;
begin
  //Tipo retorno ECF com 3 posições
  Result := Daruma_FIMFD_RetornaInformacao('107', NumeroCaixa); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('107', NumeroCaixa);
end;

function TDarumaFramework.Daruma_FI_NumeroCupom(var NumeroCupom: String): Integer;
begin
  //Tipo retorno COO com 6 posições "000000"
  Result := _rRetornarInformacao_ECF_Daruma(AnsiString('26'), AnsiString(NumeroCupom)); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('26', NumeroCupom);
end;

function TDarumaFramework.Daruma_FI_NumeroCuponsCancelados(
  var NumeroCancelamentos: String): Integer;
begin
  //Tipo retorno CFC com 4 posições
  Result := Daruma_FIMFD_RetornaInformacao('39', NumeroCancelamentos); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('39', NumeroCancelamentos);
end;

function TDarumaFramework.Daruma_FI_NumeroIntervencoes(
  var NumeroIntervencoes: String): Integer;
begin
  // Tipo retorno CRO com 3 posições
  Result  := Daruma_FIMFD_RetornaInformacao('23', NumeroIntervencoes); //Sandro Silva 2020-08-28 Result  := _rRetornarInformacao_ECF_Daruma('23', NumeroIntervencoes);
end;

function TDarumaFramework.Daruma_FI_NumeroLoja(var NumeroLoja: String): Integer;
begin
  //Tipo retorno Número da Loja com 4 posições
  Result := Daruma_FIMFD_RetornaInformacao('129', NumeroLoja); //Sandro Silva 2020-08-28 Result :=_rRetornarInformacao_ECF_Daruma('129', NumeroLoja);
end;

function TDarumaFramework.Daruma_FI_NumeroOperacoesNaoFiscais(
  var NumeroOperacoes: String): Integer;
begin
  //Tipo retorno GNF com 6 posições
  Result := Daruma_FIMFD_RetornaInformacao('28', NumeroOperacoes); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('28', NumeroOperacoes);
end;

function TDarumaFramework.Daruma_FI_NumeroReducoes(var NumeroReducoes: String): Integer;
begin
  //Tipo retorno CRZ com 4 posições
  Result := Daruma_FIMFD_RetornaInformacao('24', NumeroReducoes); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('24', NumeroReducoes);
end;

function TDarumaFramework.Daruma_FI_NumeroSerie(var NumeroSerie: String): Integer;
begin
  // Tipo retorno Número de fabricação do ECF com 20+1 posições (Quando ocorrido intervenção retorna 21 posições)
  Result := Daruma_FIMFD_RetornaInformacao('78', NumeroSerie); //Sandro Silva 2020-08-31 Result := _rRetornarInformacao_ECF_Daruma(AnsiString('78'), AnsiString(NumeroSerie)); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('78', NumeroSerie);
end;

function TDarumaFramework.Daruma_FI_NumeroSubstituicoesProprietario(
  var NumeroSubstituicoes: String): Integer;
begin
  // Tipo retorno Número de ordem seqüencial do usuário
  Result := Daruma_FIMFD_RetornaInformacao('94', NumeroSubstituicoes); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('94', NumeroSubstituicoes);
end;

function TDarumaFramework.Daruma_FI_ProgramaAliquota(Aliquota: String;
  ICMS_ISS: Integer): Integer;
begin
  if ICMS_ISS = 0 then
    Result := _confCadastrar_ECF_Daruma(AnsiString('ALIQUOTA'), AnsiString('T' + Aliquota), AnsiString('|')) // ICMS //Sandro Silva 2020-08-28 Result := _confCadastrar_ECF_Daruma('ALIQUOTA', 'T' + Aliquota, '|') // ICMS
  else
    Result := _confCadastrar_ECF_Daruma(AnsiString('ALIQUOTA'), AnsiString('S' + Aliquota), AnsiString('|')); // ISS //Sandro Silva 2020-08-28 Result := _confCadastrar_ECF_Daruma('ALIQUOTA', 'S' + Aliquota, '|'); // ISS
end;

function TDarumaFramework.Daruma_FI_ProgramaArredondamento: Integer;
begin
  Result := _regAlterarValor_Daruma(AnsiString('ECF\ArredondarTruncar'), AnsiString('A')); //Sandro Silva 2020-08-28 Result := _regAlterarValor_Daruma('ECF\ArredondarTruncar', 'A');
end;

function TDarumaFramework.Daruma_FI_ProgramaFormasPagamento(
  Formas: String): Integer;
begin
  Result := _confCadastrar_ECF_Daruma(AnsiString('FPGTO'), AnsiString(Formas), AnsiString('|')); //Sandro Silva 2020-08-28 Result := _confCadastrar_ECF_Daruma('FPGTO', Formas, '|');
end;

function TDarumaFramework.Daruma_FI_ProgramaHorarioVerao: Integer;
begin
  Result := _confHabilitarHorarioVerao_ECF_Daruma;
end;

function TDarumaFramework.Daruma_FI_ProgramaTruncamento: Integer;
begin
  Result := _regAlterarValor_Daruma(AnsiString('ECF\ArredondarTruncar'), AnsiString('T')); //Sandro Silva 2020-08-28 Result := _regAlterarValor_Daruma('ECF\ArredondarTruncar', 'T');
end;

function TDarumaFramework.Daruma_FI_RecebimentoNaoFiscal(IndiceTotalizador, Valor,
  FormaPagamento: String): Integer;
begin
  Result := _iCNFReceberSemDesc_ECF_Daruma(AnsiString(IndiceTotalizador), AnsiString(Valor)); //Sandro Silva 2020-08-28 Result := _iCNFReceberSemDesc_ECF_Daruma(IndiceTotalizador, Valor);
end;

function TDarumaFramework.Daruma_FI_ReducaoZ(Data, Hora: String): Integer;
begin
  Result := _iReducaoZ_ECF_Daruma(AnsiString(Data), AnsiString(Hora)); //Sandro Silva 2020-08-28 Result := _iReducaoZ_ECF_Daruma(Data, Hora);
end;

function TDarumaFramework.Daruma_FI_RelatorioGerencial(Texto: String): Integer;
begin
  Result := _iRGImprimirTexto_ECF_Daruma(AnsiString(Texto)); //Sandro Silva 2020-08-28 Result := _iRGImprimirTexto_ECF_Daruma(Texto);
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

function TDarumaFramework.Daruma_FI_RetornaGNF(var GNF: String): Integer;
begin
  //Tipo  	GNF com 06 posições
  Result := Daruma_FIMFD_RetornaInformacao('28', GNF); // Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('28', GNF);
end;

function TDarumaFramework.Daruma_FI_RetornoAliquotas(var Aliquotas: String): Integer;
var
  asAliquotas: AnsiString;
begin
  asAliquotas := AnsiString(Aliquotas);
  Result := _rLerAliquotas_ECF_Daruma(asAliquotas); //Sandro Silva 2020-08-28 Result := _rLerAliquotas_ECF_Daruma(Aliquotas);
  Aliquotas := asAliquotas;
end;

function TDarumaFramework.Daruma_FI_RetornoImpressora: Integer;
// Erro do último comando. É diferente de _ecf17_CodeErro();
var
  asDescErroUltimoComando: AnsiString;
  asDescAvisoUltimoComando: AnsiString;
begin

  asDescErroUltimoComando  := AnsiString(StringOFChar(' ', 300)); //Sandro Silva 2020-08-28 FDescErroUltimoComando  := StringOFChar(' ', 300);
  asDescAvisoUltimoComando := AnsiString(StringOFChar(' ', 300)); //Sandro Silva 2020-08-28 FDescAvisoUltimoComando := StringOFChar(' ', 300);

  FErroUltimoComando  := 0;
  FAvisoUltimoComando := 0;

  _rStatusUltimoCmdInt_ECF_Daruma(FErroUltimoComando, FAvisoUltimoComando);
  Result := _eRetornarAvisoErroUltimoCMD_ECF_Daruma(asDescAvisoUltimoComando, asDescErroUltimoComando); //Sandro Silva 2020-08-28 Result := _eRetornarAvisoErroUltimoCMD_ECF_Daruma(FDescAvisoUltimoComando, FDescErroUltimoComando);
  FDescAvisoUltimoComando := Trim(asDescAvisoUltimoComando); //Sandro Silva 2020-08-28 FDescAvisoUltimoComando := Trim(FDescAvisoUltimoComando);
  FDescErroUltimoComando  := Trim(asDescErroUltimoComando); //Sandro Silva 2020-08-28 FDescErroUltimoComando  := Trim(FDescErroUltimoComando);
end;

function TDarumaFramework.Daruma_FI_Sangria(Valor: String): Integer;
begin
  Result := _iSangria_ECF_Daruma(AnsiString(Valor), AnsiString('')); //Sandro Silva 2020-08-28 Result := _iSangria_ECF_Daruma(pchar(Valor), pchar(''));
end;

function TDarumaFramework.Daruma_FI_SimboloMoeda(var SimboloMoeda: String): Integer;
begin
  //Tipo retorno Símbolo da moeda atual com 2 posições
  Result := Daruma_FIMFD_RetornaInformacao('95', SimboloMoeda); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('95', SimboloMoeda);
end;

function TDarumaFramework.Daruma_FI_StatusComprovanteNaoFiscalVinculado(
  StatusRel: String): Integer;
begin
  //Tipo Retorno Tipo do documento atual 0 = nenhum documento  1= CF  2=CNF  3=CCD  4=RG
  Result := _rRetornarInformacao_ECF_Daruma(AnsiString('56'), AnsiString(StatusRel)); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('56', StatusRel);
end;

function TDarumaFramework.Daruma_FI_StatusCupomFiscal(StatusRel: String): Integer;
begin
  //Tipo retorno Estado do CF / CNF: 0 = fechado 1 = CF em registro de item 2 = CF em totalização 3 = CF em pagamento 4 = CF em finalização 5 = CNF em registro de item 6 = CNF em totalização 7 = CNF em pagamento 8 = CNF em finalização
  Result := _rRetornarInformacao_ECF_Daruma(AnsiString('57'), AnsiString(StatusRel)); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('57', StatusRel);
end;

function TDarumaFramework.Daruma_FI_StatusRelatorioGerencial(
  var StatusRel: String): Integer;
begin
  //Tipo retorno Tipo do documento atual 0 = nenhum documento  1= CF  2=CNF  3=CCD  4=RG
  Result := _rRetornarInformacao_ECF_Daruma(AnsiString('56'), AnsiString(StatusRel)); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('56', StatusRel);
end;

function TDarumaFramework.Daruma_FI_SubTotal(var SubTotal: String): Integer;
begin
  Subtotal := Replicate(' ', 12);
  Result := _rCFSubTotal_ECF_Daruma(AnsiString(SubTotal)); //Sandro Silva 2020-08-28 Result := _rCFSubTotal_ECF_Daruma(SubTotal);
end;

function TDarumaFramework.Daruma_FI_Suprimento(Valor,
  FormaPagamento: String): Integer;
begin
  Result := _iSuprimento_ECF_Daruma(AnsiString(Valor), AnsiString(Copy(FormaPagamento + DupeString(' ', 619), 1, 619))); // Precisa passar a Forma com tamanho máximo de texto suportado (619)  Sandro Silva 2020-09-04  Result := _iSuprimento_ECF_Daruma(PChar(Valor), PChar(FormaPagamento));
end;

function TDarumaFramework.Daruma_FI_TerminaFechamentoCupom(
  Mensagem: String): Integer;
begin
  Result := _iCFEncerrarConfigMsg_ECF_Daruma(AnsiString(Mensagem)); //Sandro Silva 2020-08-28 Result := _iCFEncerrarConfigMsg_ECF_Daruma(Mensagem);
end;

function TDarumaFramework.Daruma_FI_UltimoItemVendido(var NumeroItem: String): Integer;
begin
  //Tipo retorno Número do último item registrado (CF ou CNF) com 3 posições
  Result := Daruma_FIMFD_RetornaInformacao('58', NumeroItem); //Sandro Silva 2020-08-28   Result := _rRetornarInformacao_ECF_Daruma('58', NumeroItem);
end;

function TDarumaFramework.Daruma_FI_UsaComprovanteNaoFiscalVinculado(
  Texto: String): Integer;
begin
  Result := _iCCDImprimirTexto_ECF_Daruma(AnsiString(Texto)); //Sandro Silva 2020-08-28 Result := _iCCDImprimirTexto_ECF_Daruma(Texto);
end;

function TDarumaFramework.Daruma_FI_UsaUnidadeMedida(
  UnidadeMedida: String): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_ValorFormaPagamento(
  var FormaPagamento: String; var Valor: String): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_ValorPagoUltimoCupom(
  var ValorCupom: String): Integer;
begin
  //Tipo retorno Soma dos pagamentos aplicados ao documento atual com 13 posições
  Result := Daruma_FIMFD_RetornaInformacao('48', ValorCupom); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('48', ValorCupom);
end;

function TDarumaFramework.Daruma_FI_VendaBruta(var VendaBruta: String): Integer;
var
  sGT: String;
  sGTInicial: String;
begin
  //Para calcular a venda bruta você deve fazer o calcula GT - GTInicial, onde GT é o rRetornarInformacao_ECF_Daruma(1,) e GT inicial é rRetornarInformacao_ECF_Daruma(2,)
  SetLength(sGT, 18);
  SetLength(sGTInicial, 18);
  Result := Daruma_FIMFD_RetornaInformacao('1', sGT); //Sandro Silva 2020-08-28   Result := _rRetornarInformacao_ECF_Daruma('1', sGT);
  if Result = 1 then
  begin
    Result := Daruma_FIMFD_RetornaInformacao('2', sGTInicial); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('2', sGTInicial);
    VendaBruta := StringReplace(FormatFloat('0.00', (StrToFloatDef(sGT, 0)/100) - (StrToFloatDef(sGTInicial, 0)/100)), ',', '', [rfReplaceAll]);
  end;
end;

function TDarumaFramework.Daruma_FI_VendeItem(Aliquota, Quantidade,
  ValorUnitario, TipoDesconto, Desconto, Codigo, UnidadeMedida,
  DescricaoItem: String): Integer;
begin
  Result := _iCFVender_ECF_Daruma(AnsiString(Aliquota), AnsiString(Quantidade), AnsiString(ValorUnitario), AnsiString(TipoDesconto), AnsiString(Desconto), AnsiString(Codigo), AnsiString(UnidadeMedida), AnsiString(DescricaoItem)); //Sandro Silva 2020-08-28 Result := _iCFVender_ECF_Daruma(Aliquota, Quantidade, ValorUnitario, TipoDesconto, Desconto, Codigo, UnidadeMedida, DescricaoItem);
  Daruma_FI_RetornoImpressora; //Sandro Silva 2020-08-28 _ecf17.Daruma_FI_RetornoImpressora; // Sandro Silva 2019-08-08
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
  Result := _iCFVender_ECF_Daruma(AnsiString(Trim(Aliquota)), AnsiString(Trim(Quantidade)), AnsiString(Trim(ValorUnitario)), AnsiString(Trim(TipoDesconto)), AnsiString(Trim(Desconto)), AnsiString(Trim(Codigo)), AnsiString(Trim(UnidadeMedida)), AnsiString(Trim(Descricao))); //Sandro Silva 2020-08-28 Result := _iCFVender_ECF_Daruma(Trim(Aliquota), Trim(Quantidade), Trim(ValorUnitario), Trim(TipoDesconto), Trim(Desconto), Trim(Codigo), Trim(UnidadeMedida), Trim(Descricao));

  Daruma_FI_RetornoImpressora;  // _ecf17.Daruma_FI_RetornoImpressora;
end;

function TDarumaFramework.Daruma_FI_VendeItemTresDecimais(Codigo, Descricao,
  Aliquota, Quantidade, ValorUnitario, TipoDesconto,
  Desconto, UnidadeMedida: String): Integer;
begin
  Result := _iCFVender_ECF_Daruma(AnsiString(Aliquota), AnsiString(Quantidade), AnsiString(ValorUnitario), AnsiString(TipoDesconto), AnsiString(Desconto), AnsiString(Codigo), AnsiString(UnidadeMedida), AnsiString(Descricao)); //Sandro Silva 2020-08-28 Result := _iCFVender_ECF_Daruma(Aliquota, Quantidade, ValorUnitario, TipoDesconto, Desconto, Codigo, UnidadeMedida, Descricao);
end;

function TDarumaFramework.Daruma_FI_VerificaAliquotasIss(var Flag: String): Integer;
var
  sRetorno: AnsiString; // sRetorno: String;
  iAliq: Integer;
  sl: TStringList;
begin
  //Tipo retorno string 150 posições
  //Ex: T0700;T1200;S0700;T0800;T0900;S0800;T0800;T0900;T1000;T1100;T1200;T1300;T1400;T1600;T1700;T1800;TF1;TF2;TI1;TI2;TN1;TN2;SFS1;SFS2;SIS1;SIS2;SNS1;SNS2
  // T - Alíquota de ICMS - Ex: 01700 - Alíquota de 17,00 de ICMS
  // S - Alíquota de ISS - Ex: 11700 - Alíquota de 17,00 de ISS
  sRetorno := AnsiString(StringOfChar(#0, 150)); //SetLength(sRetorno, 150);
  Result := _rLerAliquotas_ECF_Daruma(sRetorno); //Sandro Silva 2020-08-28   Result := _rLerAliquotas_ECF_Daruma(sRetorno);
  {Sandro Silva 2020-08-31 inicio
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
  }
  sl := TStringList.Create;
  sl.Delimiter := ';';
  sl.DelimitedText := sRetorno;

  for iAliq := 0 to sl.Count - 1 do
  begin
    if AnsiUpperCase(Copy(sl.Strings[iALiq], 1, 1)) = 'S' then
    begin
      if Flag <> '' then
        Flag := Flag + ';';
      Flag := Flag + sl.Strings[iALiq];
    end;
  end;
  FreeAndNil(sl)
  {Sandro Silva 2020-08-31 fim}
end;

function TDarumaFramework.Daruma_FI_VerificaDepartamentos(
  var Departamentos: String): Integer;
begin
  Result := 1; // _Daruma_FI_VerificaDepartamentos(Departamentos);
end;

function TDarumaFramework.Daruma_FI_VerificaDocAutenticacao: Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_VerificaEpromConectada(var Flag: String): Integer;
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
  var Formas: String): Integer;
begin
  Formas := DupeString(' ', 260); //Sandro Silva 2020-08-28
  //Tipo retorno Totalizador de Meios de Pagamento 01 a 20 com 260 posições
  Result := Daruma_FIMFD_RetornaInformacao('6', Formas); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('6', Formas);
end;

function TDarumaFramework.Daruma_FI_VerificaImpressoraLigada: Integer;
begin
  Result := _rVerificarImpressoraLigada_ECF_Daruma;
end;

function TDarumaFramework.Daruma_FI_VerificaIndiceAliquotasIss(
  var Flag: String): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_FI_VerificaModeloECF(var Modelo: String): Integer;
begin
  SetLength(Modelo, 20);
  Result := Daruma_FIMFD_RetornaInformacao('81', Modelo); //Sandro Silva 2020-08-28   Result :=_rRetornarInformacao_ECF_Daruma('81', Modelo);
end;

function TDarumaFramework.Daruma_FI_VerificaModoOperacao(var Modo: String): Integer;
var
  asModo: AnsiString;
begin
  //Tipo retorno 18 posições
  asModo := AnsiString(stringOfChar(#0, 18)); //Sandro Silva 2020-08-28 SetLength(modo, 18);
  Result := _rStatusImpressoraBinario_ECF_Daruma(asModo); //Sandro Silva 2020-08-28   Result := _rStatusImpressoraBinario_ECF_Daruma(Modo);
  Modo := asModo;
end;

function TDarumaFramework.Daruma_FI_VerificaRecebimentoNaoFiscal(
  var Recebimentos: String): Integer;
begin
  //Tipo retorno Totalizadores Não-Fiscais 02 a 20 com 247 posições
  Result := Daruma_FIMFD_RetornaInformacao('9', Recebimentos); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('9', Recebimentos);
end;

function TDarumaFramework.Daruma_FI_VerificaTipoImpressora(
  var TipoImpressora: String): Integer;
begin
  //Tipo retorno Tipo do ECF com 7 posições
  Result := _rRetornarInformacao_ECF_Daruma('79', TipoImpressora);
end;

function TDarumaFramework.Daruma_FI_VerificaTotalizadoresNaoFiscais(
  var Totalizadores: String): Integer;
begin
  //Tipo retorno Totalizadores Não-Fiscais 02 a 20 total de 247 posições
  Result := Daruma_FIMFD_RetornaInformacao('9', Totalizadores); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('9', Totalizadores);
end;

function TDarumaFramework.Daruma_FI_VerificaTotalizadoresParciais(
  var Totalizadores: String): Integer;
begin
  //Tipo retorno T01 a T16 + F1 + F2 + I1 + I2 + N1 + N2 + FS1 + FS2 + IS1 + IS2 + NS1 + NS2 com 364 posições
  Result := Daruma_FIMFD_RetornaInformacao('3', Totalizadores); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('3', Totalizadores);
end;

function TDarumaFramework.Daruma_FI_VerificaTruncamento(var Flag: String): Integer;
var
  asFlag: AnsiString;
begin
  asFlag := AnsiString(StringOfChar(#0, 100)); //Sandro Silva 2020-08-28 SetLength(Flag, 100);
  Result := _regRetornaValorChave_Daruma(AnsiString('ECF'), AnsiString('ArredondarTruncar'), Flag);
  Flag := asFlag;
end;

function TDarumaFramework.Daruma_FI_VersaoFirmware(var VersaoFirmware: String): Integer;
begin
  //Tipo retorno Versão do SB instalado com 6 posições
  Result := Daruma_FIMFD_RetornaInformacao('83', VersaoFirmware); //Sandro Silva 2020-08-28 Result := _rRetornarInformacao_ECF_Daruma('83',VersaoFirmware);
end;

function TDarumaFramework.Daruma_Registry_Ler_Configuracao(sProduto: String;
  sChave: String): String;
var
  Str_Valor: AnsiString; // Sandro Silva 2020-08-28  Str_Valor: String;
begin
  Str_Valor := AnsiString(StringOFChar(#0,100)); // Sandro Silva 2020-08-28 StringOFChar(#0,100);
  _regRetornaValorChave_DarumaFramework(AnsiString(sProduto), AnsiString(sChave), AnsiString(Str_Valor)); // Sandro Silva 2020-08-28 _regRetornaValorChave_DarumaFramework(sProduto, sChave, Str_Valor);
  Result := Str_Valor;
  ShowMessage(Result);
end;

function TDarumaFramework.Daruma_Registry_AplMensagem1(AplMsg1: String): Integer;
begin
  Result := _regAlterarValor_Daruma(AnsiString('ECF\MensagemApl1'), AnsiString(AplMsg1)); // Sandro Silva 2020-08-28 Result := _regAlterarValor_Daruma('ECF\MensagemApl1', AplMsg1);
end;

function TDarumaFramework.Daruma_Registry_AplMensagem2(AplMsg1: String): Integer;
begin
  Result := _regAlterarValor_Daruma(AnsiString('ECF\MensagemApl2'), AnsiString(AplMsg1)); // Sandro Silva 2020-08-26 Result := _regAlterarValor_Daruma('ECF\MensagemApl2', AplMsg1);
end;

function TDarumaFramework.Daruma_Registry_ConfigRede(ConfigRede: String): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_Registry_ControlePorta(
  ControlePorta: String): Integer;
begin
  Result := _regAlterarValor_Daruma(AnsiString('ECF\ControleAutomatico'), AnsiString(ControlePorta)); // Sandro Silva 2020-08-28 Result := _regAlterarValor_Daruma('ECF\ControleAutomatico', ControlePorta);
end;

function TDarumaFramework.Daruma_Registry_Emulador(Emulador: String): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_Registry_Log(Log: String): Integer;
begin
  Result := _regAlterarValor_Daruma(AnsiString('ECF\Auditoria'), AnsiString(Log)); // Sandro Silva 2020-08-28 Result := _regAlterarValor_Daruma('ECF\Auditoria', Log);
end;

function TDarumaFramework.Daruma_Registry_MFD_LeituraMFCompleta(
  Valor: String): Integer;
begin
  Result := _regAlterarValor_Daruma(AnsiString('ECF\LMFCompleta'), AnsiString(Valor)); // Sandro Silva 2020-08-28 Result := _regAlterarValor_Daruma('ECF\LMFCompleta', Valor); 
end;

function TDarumaFramework.Daruma_Registry_ModoGaveta(ModoGaveta: String): Integer;
begin
  Result := _regAlterarValor_Daruma(AnsiString('ECF\ModoGaveta'), AnsiString(ModoGaveta)); // Sandro Silva 2020-08-28 Result := _regAlterarValor_Daruma('ECF\ModoGaveta', ModoGaveta);
end;

function TDarumaFramework.Daruma_Registry_NomeLog(NomeLog: String): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_Registry_Path(Path: String; sTipo: String): Integer;
// Tipo = Arquivos ou Relatórios
begin
  if sTipo = 'Arquivos' then
    Result := _regAlterarValor_Daruma(AnsiString('START\LocalArquivos'), AnsiString(Path)) // Sandro Silva 2020-08-28 Result := _regAlterarValor_Daruma('START\LocalArquivos', Path)
  else
    if sTipo = 'PathBibliotecasAuxiliares' then
      Result := _regAlterarValor_Daruma(AnsiString('START\PathBibliotecasAuxiliares'), AnsiString(Path)) // Sandro Silva 2020-08-28 Result := _regAlterarValor_Daruma('START\PathBibliotecasAuxiliares', Path)
    else
      Result := _regAlterarValor_Daruma(AnsiString('START\LocalArquivosRelatorios'), AnsiString(Path)); //Sandro Silva 2020-08-28 Result := _regAlterarValor_Daruma('START\LocalArquivosRelatorios', Path);
end;

function TDarumaFramework.Daruma_Registry_Porta(Porta: String): Integer;
begin
  Result := _regAlterarValor_Daruma(AnsiString('ECF\PortaSerial'), AnsiString(Porta)); // Sandro Silva 2020-08-28 Result := _regAlterarValor_Daruma('ECF\PortaSerial', Porta);
end;

function TDarumaFramework.Daruma_Registry_Retorno(Retorno: String): Integer;
begin
  Result := 1;
end;

function TDarumaFramework.Daruma_Registry_Separador(Separador: String): Integer;
begin
  Result := _regAlterarValor_Daruma(AnsiString('ECF\CaracterSeparador'), AnsiString(Separador)); //Sandro Silva 2020-08-28 Result := _regAlterarValor_Daruma('ECF\CaracterSeparador', Separador);
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
  Result := _regAlterarValor_Daruma(AnsiString('ECF\RetornarAvisoErro'), AnsiString(StatusFuncao)); // Sandro Silva 2020-08-28 Result := _regAlterarValor_Daruma('ECF\RetornarAvisoErro', StatusFuncao);
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
  Result := _iTEF_ImprimirResposta_ECF_Daruma(AnsiString(Arquivo), Travar);
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

procedure TDarumaFramework.Import(var Proc: pointer; Name: PAnsichar);
begin
  if not Assigned(Proc) then
  begin
    Proc := GetProcAddress(FDLLHandle, PAnsichar(Name));
    if Proc = nil then
      raise Exception.Create('Não foi possível carregar a função ' + Name + ' da biblioteca ' + DARUMA_DLLNAME_17);
  end;
end;

function TDarumaFramework.Daruma_DownloadMF(sArquivo: String): Integer;
begin
  Result := _rEfetuarDownloadMF_ECF_Daruma(AnsiString(sArquivo)); //Sandro Silva 2020-08-28 Result := _rEfetuarDownloadMF_ECF_Daruma(sArquivo);
end;

function TDarumaFramework.Daruma_DownloadMFD(COOInicial: String;
  COOFinal: String; sArquivo: String; Tipo: String = 'COO'): Integer;
begin
  // Sandro Silva 2017-08-01  Result := _rEfetuarDownloadMFD_ECF_Daruma('COO', COOInicial, COOFinal, sArquivo);
  COOInicial := Right('000000' + COOInicial,6);
  COOFinal   := Right('000000' + COOFinal, 6);
  Result := _rEfetuarDownloadMFD_ECF_Daruma(AnsiString(Tipo), AnsiString(COOInicial), AnsiString(COOFinal), AnsiString(sArquivo)); //Sandro Silva 2020-08-28 Result := _rEfetuarDownloadMFD_ECF_Daruma(Tipo, COOInicial, COOFinal, sArquivo);
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
  Result := _rLerDecimais_ECF_Daruma(AnsiString(Str_DecimalQtde), AnsiString(Str_DecimalValor), Int_DecimalQtde, Int_DecimalValor); //Sandro Silva 2020-08-28   Result := _rLerDecimais_ECF_Daruma(Str_DecimalQtde, Str_DecimalValor, Int_DecimalQtde, Int_DecimalValor);
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

end.
