{
Alterações
Sandro Silva 2016-02-04
- Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
}
unit _Small_3;

interface

uses
  Windows, Messages, SmallFunc, Fiscal, SysUtils,Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Mask, Grids, DBGrids, DB//, DBTables
  , DBCtrls, SMALL_DBEdit, IniFiles, Unit2, FileCtrl, Unit22, Unit7, md5;

  // Alterado p/versão 2005 07/01/2005 - RONEI                                //

  // ---------------- //
  // IF DARUMA        //
  // ---------------- //
  // ----------------------------------- //
  // DARUMA                              //
  // ------------------------------------//
  // Se precisar de suporte da DARUMA    //
  // falar com:                          //
  // Floriano                            //
  // Depto de Assistência Técnica        //
  // Daruma Automação                    //
  // ----------------------------------- //
  // Fone : (0xx12) 281-1000 Ramal 633   //
  // Fax : (0xx12) 281-1032              //
  // ----------------------------------- //
  // floriano@daruma.com.br              //
  // www.daruma.com.br                   //
  // ----------------------------------- //
  // Declaracao da Dll Integradora
  // Daruma32.dll
  //-------------------------------------//
  //
  // CURITIBA
  // claudenir - 55 11 8137 0262
  // Alechandre ou Cristian
  // 8:30 1 as 5:30
  // (0xx41)33616076
  //
  // SUPORTE
  // Luiz Canguini - 0800 770 3320
  //
  // DARUMA  FS 345 FS 600
  //
  {Sandro Silva 2015-06-18 inicio
  Function Daruma_Registry_AplMensagem1(AplMsg1: String): Integer; StdCall; External 'Daruma32.dll';
  Function Daruma_Registry_AplMensagem2(AplMsg1: String): Integer; StdCall; External 'Daruma32.dll';
  //
  function Daruma_Registry_MFD_LeituraMFCompleta( Valor: String ): Integer; StdCall; External 'Daruma32.dll'
  function Daruma_Registry_Porta(Porta: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_Registry_Path(Path: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_Registry_Status(Status: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_Registry_StatusFuncao(StatusFuncao: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_Registry_Retorno(Retorno: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_Registry_ControlePorta(ControlePorta: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_Registry_ModoGaveta(ModoGaveta: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_Registry_Log(Log: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_Registry_NomeLog(NomeLog: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_Registry_Separador(Separador: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_Registry_SeparaMsgPromo(SeparaMsgPromo: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_Registry_Emulador(Emulador: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_Registry_ConfigRede(ConfigRede: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_Registry_VendeItemUmaLinha(ConfigRede: String ): Integer; StdCall; External 'Daruma32.dll';

  // Funções de Inicialização
  function Daruma_FI_AlteraSimboloMoeda( SimboloMoeda: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_ProgramaAliquota( Aliquota: String; ICMS_ISS: Integer ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_ProgramaHorarioVerao: Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_NomeiaDepartamento( Indice: Integer; Departamento: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_NomeiaTotalizadorNaoSujeitoIcms( Indice: Integer; Totalizador: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_ProgramaArredondamento: Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_ProgramaTruncamento: Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_ProgramaTruncamento';
  function Daruma_FI_LinhasEntreCupons( Linhas: Integer ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_EspacoEntreLinhas( Dots: Integer ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_ForcaImpactoAgulhas( ForcaImpacto: Integer ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_ProgramaFormasPagamento( Formas: String ): Integer; StdCall; External 'Daruma32.dll';
  // Funções do Cupom Fiscal
  function Daruma_FI_AbreCupom( CGC_CPF: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_VendeItem( Codigo: String; Descricao: String; Aliquota: String; TipoQuantidade: String; Quantidade: String; CasasDecimais: Integer; ValorUnitario: String; TipoDesconto: String; Desconto: String): Integer; StdCall; External 'Daruma32.dll';

  function Daruma_FI_VendeItemTresDecimais(
  Codigo: String;
  Descricao: String;
  Aliquota: String;
  Quantidade: String;
  ValorUnitario: String;
  TipoDesconto: String;
  Desconto: String): Integer; StdCall; External 'Daruma32.dll';

  function Daruma_FI_VendeItemDepartamento( Codigo: String; Descricao: String; Aliquota: String; ValorUnitario: String; Quantidade: String; Acrescimo: String; Desconto: String; IndiceDepartamento: String; UnidadeMedida: String): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_VendeItem1Lin13Dig( Codigo: String; Descricao: String; Aliquota: String; Quantidade: String;  ValorUnitario: String; Acrescimo_Desconto: String; Percentual : String): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_CancelaItemAnterior: Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_CancelaItemGenerico( NumeroItem: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_CancelaCupom: Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_FechaCupomResumido( FormaPagamento: String; Mensagem: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_FechaCupom( FormaPagamento: String; AcrescimoDesconto: String; TipoAcrescimoDesconto: String; ValorAcrescimoDesconto: String; ValorPago: String; Mensagem: String): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_ResetaImpressora: Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_IniciaFechamentoCupom( AcrescimoDesconto: String; TipoAcrescimoDesconto: String; ValorAcrescimoDesconto: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_EfetuaFormaPagamento( FormaPagamento: String; ValorFormaPagamento: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_EfetuaFormaPagamentoDescricaoForma( FormaPagamento: string; ValorFormaPagamento: string; DescricaoFormaPagto: string ): integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_TerminaFechamentoCupom( Mensagem: String): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_IdentificaConsumidor( Nome: String;Endereco: String; Doc: String): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_EstornoFormasPagamento( FormaOrigem: String; FormaDestino: String; Valor: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_UsaUnidadeMedida( UnidadeMedida: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_AumentaDescricaoItem( Descricao: String ): Integer; StdCall; External 'Daruma32.dll';
  // Funções dos Relatórios Fiscais
  function Daruma_FI_LeituraX: Integer; StdCall; External 'Daruma32.dll' ;
  function Daruma_FI_ReducaoZ( Data: String; Hora: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_RelatorioGerencial( Texto: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_FechaRelatorioGerencial: Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_LeituraMemoriaFiscalData( DataInicial: String; DataFinal: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_LeituraMemoriaFiscalReducao( ReducaoInicial: String; ReducaoFinal: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_LeituraMemoriaFiscalSerialData( DataInicial: String; DataFinal: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_LeituraMemoriaFiscalSerialReducao( ReducaoInicial: String; ReducaoFinal: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FIMFD_DownloadDaMFD(CoInicial: String; CoFinal: String ): Integer; StdCall; External 'Daruma32.dll';

  // Funções das Operações Não Fiscais
  function Daruma_FI_RecebimentoNaoFiscal( IndiceTotalizador: String; Valor: String; FormaPagamento: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_AbreComprovanteNaoFiscalVinculado( FormaPagamento: String; Valor: String; NumeroCupom: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_UsaComprovanteNaoFiscalVinculado( Texto: String ): Integer; StdCall; External 'Daruma32.dll'
  function Daruma_FI_FechaComprovanteNaoFiscalVinculado: Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_Sangria( Valor: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_Suprimento( Valor: String; FormaPagamento: String ): Integer; StdCall; External 'Daruma32.dll';
  // Funções de Informações da Impressora
  function Daruma_FI_StatusCupomFiscal( StatusRel: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_StatusComprovanteNaoFiscalVinculado( StatusRel: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_StatusRelatorioGerencial( StatusRel: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_NumeroSerie( NumeroSerie: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_SubTotal( SubTotal: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_NumeroCupom( NumeroCupom: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_RetornaGNF( GNF: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_LeituraXSerial: Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_VersaoFirmware( VersaoFirmware: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_CGC_IE( CGC: String; IE: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_GrandeTotal( GrandeTotal: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_VendaBruta( VendaBruta: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_Cancelamentos( ValorCancelamentos: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_Descontos( ValorDescontos: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_NumeroOperacoesNaoFiscais( NumeroOperacoes: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_NumeroCuponsCancelados( NumeroCancelamentos: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_NumeroIntervencoes( NumeroIntervencoes: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_NumeroReducoes( NumeroReducoes: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_NumeroSubstituicoesProprietario( NumeroSubstituicoes: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_UltimoItemVendido( NumeroItem: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_ClicheProprietarioEx( ClicheEx: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_NumeroCaixa( NumeroCaixa: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_NumeroLoja( NumeroLoja: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_SimboloMoeda( SimboloMoeda: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_MinutosLigada( Minutos: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_MinutosImprimindo( Minutos: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_VerificaModoOperacao( Modo: string ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_VerificaEpromConectada( Flag: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_FlagsFiscais( Var Flag: Integer ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_ValorPagoUltimoCupom( ValorCupom: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_DataHoraImpressora( Data: String; Hora: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_ContadoresTotalizadoresNaoFiscais( Contadores: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_VerificaTotalizadoresNaoFiscais( Totalizadores: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_DataHoraReducao( Data: String; Hora: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_DataMovimento( Data: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_VerificaTruncamento( Flag: string ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_Acrescimos( ValorAcrescimos: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_ContadorBilhetePassagem( ContadorPassagem: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_VerificaAliquotasIss( Flag: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_VerificaFormasPagamento( Formas: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_VerificaRecebimentoNaoFiscal( Recebimentos: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_VerificaDepartamentos( Departamentos: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_VerificaTipoImpressora( Var TipoImpressora: Integer ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_VerificaTotalizadoresParciais( Totalizadores: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_RetornoAliquotas( Aliquotas: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_VerificaEstadoImpressora( Var ACK: Integer; Var ST1: Integer; Var ST2: Integer ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_DadosUltimaReducao( DadosReducao: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_MonitoramentoPapel( Var Linhas: Integer): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_VerificaIndiceAliquotasIss( Flag: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_ValorFormaPagamento( FormaPagamento: String; Valor: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_ValorTotalizadorNaoFiscal( Totalizador: String; Valor: String ): Integer; StdCall; External 'Daruma32.dll';
//  function Daruma_FI_VerificaModeloECF( Modelo: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_VerificaModeloECF: Integer; StdCall; External 'Daruma32.dll';
  // Funções de Autenticação e Gaveta de Dinheiro
  function Daruma_FI_Autenticacao:Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_Autenticacao';
  function Daruma_FI_AutenticacaoStr(str :string):Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_AutenticacaoStr';
  function Daruma_FI_VerificaDocAutenticacao:Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_VerificaDocAutenticacao';
  function Daruma_FI_AcionaGaveta:Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_AcionaGaveta';
  function Daruma_FI_VerificaEstadoGaveta( Var EstadoGaveta: Integer ): Integer; StdCall; External 'Daruma32.dll';
  // Outras Funções
  function Daruma_FI_AbrePortaSerial: Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_RetornoImpressora( Var ACK: Integer; Var ST1: Integer; Var ST2: Integer ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_FechaPortaSerial: Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_FechaPortaSerial';
  function Daruma_FI_MapaResumo:Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_MapaResumo';
  function Daruma_FI_AberturaDoDia( ValorCompra: string; FormaPagamento: string ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_FechamentoDoDia: Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_FechamentoDoDia';
  function Daruma_FI_ImprimeConfiguracoesImpressora:Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_ImprimeConfiguracoesImpressora';
  function Daruma_FI_ImprimeDepartamentos: Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_ImprimeDepartamentos';
  function Daruma_FI_RelatorioTipo60Analitico: Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_RelatorioTipo60Analitico';
  function Daruma_FI_RelatorioTipo60Mestre: Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_RelatorioTipo60Mestre';
  function Daruma_FI_VerificaImpressoraLigada: Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_VerificaImpressoraLigada';
  function Daruma_FI_ImprimeConfiguracoes: Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_VerificaImpressoraLigada';
  //funcoes de TEF
  function Daruma_TEF_ImprimirResposta( Arquivo: string; FormaPagamento: string; Travar:string ): Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_TEF_ImprimirResposta';
  function Daruma_TEF_FechaRelatorio: Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_TEF_FechaRelatorio';
  //
//  function Daruma_FI_RetornaErroExtendido(sParam1: String): Integer; StdCall; external 'Daruma32.dll' Name 'Daruma_FI_RetornaErroExtendido';
  function Daruma_FI_RetornaErroExtendido(sParam1: String): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FI_VerificaEstadoGavetaStr(sParam1: String): Integer; StdCall; external 'Daruma32.dll' Name 'Daruma_FI_VerificaEstadoGavetaStr';
  function Daruma_FI_FlagsFiscaisStr(sParam1: String): Integer; StdCall; external 'Daruma32.dll' Name 'Daruma_FI_FlagsFiscaisStr';
  function Daruma_FIMFD_RetornaInformacao( Indice: String; Valor: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FIMFD_CodigoModeloFiscal(Valor: String): Integer; StdCall; External 'Daruma32.dll';
  //
  function Daruma_RFD_GerarArquivo(DataInicial: String; DataFinal: String): Integer; StdCall; External 'Daruma32.dll';
  //
  function Daruma_FIMFD_ProgramaRelatoriosGerenciais( NomeRelatorio: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FIMFD_AbreRelatorioGerencial( NomeRelatorio: String ): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FIMFD_GerarAtoCotepePafData(DataInicial: String; DataFinal: String): Integer; StdCall; External 'Daruma32.dll';
  function Daruma_FIMFD_GerarAtoCotepePafCOO(COOIni: string; COOFim: string): Integer; StdCall; External 'Daruma32.dll';
  }

  // Declarar as funções da dll usando loadlibary evitando conflito com sat dimep
const DARUMA_DLLNAME_03 = 'Daruma32.dll';

type
  TDaruma32 = class(TComponent)
    private
      DLL: THandle;    
      //Function Daruma_Registry_AplMensagem1(AplMsg1: String): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_Registry_AplMensagem1: function(AplMsg1: String): Integer; StdCall;
      //Function Daruma_Registry_AplMensagem2(AplMsg1: String): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_Registry_AplMensagem2: function(AplMsg1: String): Integer; StdCall;
      //
      //function Daruma_Registry_MFD_LeituraMFCompleta( Valor: String ): Integer; StdCall; External 'Daruma32.dll'
      _Daruma_Registry_MFD_LeituraMFCompleta: function(Valor: String): Integer; StdCall;

      //function Daruma_Registry_Porta(Porta: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_Registry_Porta: function(Porta: String): Integer; StdCall;
      //function Daruma_Registry_Path(Path: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_Registry_Path: function(Path: String): Integer; StdCall;
      //function Daruma_Registry_Status(Status: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_Registry_Status: function(Status: String): Integer; StdCall;
      //function Daruma_Registry_StatusFuncao(StatusFuncao: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_Registry_StatusFuncao: function(StatusFuncao: String): Integer; StdCall;
      //function Daruma_Registry_Retorno(Retorno: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_Registry_Retorno: function(Retorno: String): Integer; StdCall;
      //function Daruma_Registry_ControlePorta(ControlePorta: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_Registry_ControlePorta: function(ControlePorta: String): Integer; StdCall;
      //function Daruma_Registry_ModoGaveta(ModoGaveta: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_Registry_ModoGaveta: function(ModoGaveta: String): Integer; StdCall;
      //function Daruma_Registry_Log(Log: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_Registry_Log: function(Log: String): Integer; StdCall;
      //function Daruma_Registry_NomeLog(NomeLog: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_Registry_NomeLog: function(NomeLog: String): Integer; StdCall;
      //function Daruma_Registry_Separador(Separador: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_Registry_Separador: function(Separador: String): Integer; StdCall;
      //function Daruma_Registry_SeparaMsgPromo(SeparaMsgPromo: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_Registry_SeparaMsgPromo: function(SeparaMsgPromo: String ): Integer; StdCall;
      //function Daruma_Registry_Emulador(Emulador: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_Registry_Emulador: function(Emulador: String): Integer; StdCall;
      //function Daruma_Registry_ConfigRede(ConfigRede: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_Registry_ConfigRede: function(ConfigRede: String): Integer; StdCall;
      //function Daruma_Registry_VendeItemUmaLinha(ConfigRede: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_Registry_VendeItemUmaLinha: function(ConfigRede: String): Integer; StdCall;

      // Funções de Inicialização
      //function Daruma_FI_AlteraSimboloMoeda( SimboloMoeda: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_AlteraSimboloMoeda: function(SimboloMoeda: String): Integer; StdCall;
      //function Daruma_FI_ProgramaAliquota( Aliquota: String; ICMS_ISS: Integer ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_ProgramaAliquota: function(Aliquota: String; ICMS_ISS: Integer): Integer; StdCall;
      //function Daruma_FI_ProgramaHorarioVerao: Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_ProgramaHorarioVerao: function(): Integer; StdCall;
      //function Daruma_FI_NomeiaDepartamento( Indice: Integer; Departamento: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_NomeiaDepartamento: function(Indice: Integer; Departamento: String): Integer; StdCall;
      //function Daruma_FI_NomeiaTotalizadorNaoSujeitoIcms( Indice: Integer; Totalizador: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_NomeiaTotalizadorNaoSujeitoIcms: function(Indice: Integer; Totalizador: String): Integer; StdCall;
      //function Daruma_FI_ProgramaArredondamento: Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_ProgramaArredondamento: function(): Integer; StdCall;
      //function Daruma_FI_ProgramaTruncamento: Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_ProgramaTruncamento';
      _Daruma_FI_ProgramaTruncamento: function(): Integer; StdCall;
      //function Daruma_FI_LinhasEntreCupons( Linhas: Integer ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_LinhasEntreCupons: function(Linhas: Integer): Integer; StdCall;
      //function Daruma_FI_EspacoEntreLinhas( Dots: Integer ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_EspacoEntreLinhas: function(Dots: Integer): Integer; StdCall;
      //function Daruma_FI_ForcaImpactoAgulhas( ForcaImpacto: Integer ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_ForcaImpactoAgulhas: function(ForcaImpacto: Integer): Integer; StdCall;
      //function Daruma_FI_ProgramaFormasPagamento( Formas: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_ProgramaFormasPagamento: function(Formas: String): Integer; StdCall;
      // Funções do Cupom Fiscal
      //function Daruma_FI_AbreCupom( CGC_CPF: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_AbreCupom: function(CGC_CPF: String): Integer; StdCall;
      //function Daruma_FI_VendeItem( Codigo: String; Descricao: String; Aliquota: String; TipoQuantidade: String; Quantidade: String; CasasDecimais: Integer; ValorUnitario: String; TipoDesconto: String; Desconto: String): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_VendeItem: function(Codigo: String; Descricao: String; Aliquota: String; TipoQuantidade: String; Quantidade: String; CasasDecimais: Integer; ValorUnitario: String; TipoDesconto: String; Desconto: String): Integer; StdCall;

      //function Daruma_FI_VendeItemTresDecimais(Codigo: String; Descricao: String; Aliquota: String; Quantidade: String; ValorUnitario: String; TipoDesconto: String;Desconto: String): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_VendeItemTresDecimais: function(Codigo: String; Descricao: String; Aliquota: String; Quantidade: String; ValorUnitario: String; TipoDesconto: String;Desconto: String): Integer; StdCall;

      //function Daruma_FI_VendeItemDepartamento( Codigo: String; Descricao: String; Aliquota: String; ValorUnitario: String; Quantidade: String; Acrescimo: String; Desconto: String; IndiceDepartamento: String; UnidadeMedida: String): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_VendeItemDepartamento: function(Codigo: String; Descricao: String; Aliquota: String; ValorUnitario: String; Quantidade: String; Acrescimo: String; Desconto: String; IndiceDepartamento: String; UnidadeMedida: String): Integer; StdCall;
      //function Daruma_FI_VendeItem1Lin13Dig( Codigo: String; Descricao: String; Aliquota: String; Quantidade: String;  ValorUnitario: String; Acrescimo_Desconto: String; Percentual : String): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_VendeItem1Lin13Dig: function(Codigo: String; Descricao: String; Aliquota: String; Quantidade: String;  ValorUnitario: String; Acrescimo_Desconto: String; Percentual : String): Integer; StdCall;
      //function Daruma_FI_CancelaItemAnterior: Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_CancelaItemAnterior: function(): Integer; StdCall;
      //function Daruma_FI_CancelaItemGenerico( NumeroItem: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_CancelaItemGenerico: function(NumeroItem: String): Integer; StdCall;
      //function Daruma_FI_CancelaCupom: Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_CancelaCupom: function(): Integer; StdCall;
      //function Daruma_FI_FechaCupomResumido( FormaPagamento: String; Mensagem: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_FechaCupomResumido: function(FormaPagamento: String; Mensagem: String): Integer; StdCall;
      //function Daruma_FI_FechaCupom( FormaPagamento: String; AcrescimoDesconto: String; TipoAcrescimoDesconto: String; ValorAcrescimoDesconto: String; ValorPago: String; Mensagem: String): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_FechaCupom: function(FormaPagamento: String; AcrescimoDesconto: String; TipoAcrescimoDesconto: String; ValorAcrescimoDesconto: String; ValorPago: String; Mensagem: String): Integer; StdCall;
      //function Daruma_FI_ResetaImpressora: Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_ResetaImpressora: function(): Integer; StdCall;
      //function Daruma_FI_IniciaFechamentoCupom( AcrescimoDesconto: String; TipoAcrescimoDesconto: String; ValorAcrescimoDesconto: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_IniciaFechamentoCupom: function(AcrescimoDesconto: String; TipoAcrescimoDesconto: String; ValorAcrescimoDesconto: String ): Integer; StdCall;
      //function Daruma_FI_EfetuaFormaPagamento( FormaPagamento: String; ValorFormaPagamento: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_EfetuaFormaPagamento: function(FormaPagamento: String; ValorFormaPagamento: String): Integer; StdCall;
      //function Daruma_FI_EfetuaFormaPagamentoDescricaoForma( FormaPagamento: string; ValorFormaPagamento: string; DescricaoFormaPagto: string ): integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_EfetuaFormaPagamentoDescricaoForma: function(FormaPagamento: string; ValorFormaPagamento: string; DescricaoFormaPagto: string): integer; StdCall;
      //function Daruma_FI_TerminaFechamentoCupom( Mensagem: String): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_TerminaFechamentoCupom: function(Mensagem: String): Integer; StdCall;
      //function Daruma_FI_IdentificaConsumidor( Nome: String;Endereco: String; Doc: String): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_IdentificaConsumidor: function(Nome: String;Endereco: String; Doc: String): Integer; StdCall;
      //function Daruma_FI_EstornoFormasPagamento( FormaOrigem: String; FormaDestino: String; Valor: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_EstornoFormasPagamento: function(FormaOrigem: String; FormaDestino: String; Valor: String): Integer; StdCall;
      //function Daruma_FI_UsaUnidadeMedida( UnidadeMedida: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_UsaUnidadeMedida: function(UnidadeMedida: String): Integer; StdCall;
      //function Daruma_FI_AumentaDescricaoItem( Descricao: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_AumentaDescricaoItem: function(Descricao: String): Integer; StdCall;

      // Funções dos Relatórios Fiscais
      //function Daruma_FI_LeituraX: Integer; StdCall; External 'Daruma32.dll' ;
      _Daruma_FI_LeituraX: function(): Integer; StdCall;
      //function Daruma_FI_ReducaoZ( Data: String; Hora: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_ReducaoZ: function(Data: String; Hora: String): Integer; StdCall;
      //function Daruma_FI_RelatorioGerencial( Texto: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_RelatorioGerencial: function(Texto: String): Integer; StdCall;
      //function Daruma_FI_FechaRelatorioGerencial: Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_FechaRelatorioGerencial: function(): Integer; StdCall;
      //function Daruma_FI_LeituraMemoriaFiscalData( DataInicial: String; DataFinal: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_LeituraMemoriaFiscalData: function(DataInicial: String; DataFinal: String): Integer; StdCall;
      //function Daruma_FI_LeituraMemoriaFiscalReducao( ReducaoInicial: String; ReducaoFinal: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_LeituraMemoriaFiscalReducao: function(ReducaoInicial: String; ReducaoFinal: String): Integer; StdCall;
      //function Daruma_FI_LeituraMemoriaFiscalSerialData( DataInicial: String; DataFinal: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_LeituraMemoriaFiscalSerialData: function(DataInicial: String; DataFinal: String): Integer; StdCall;
      //function Daruma_FI_LeituraMemoriaFiscalSerialReducao( ReducaoInicial: String; ReducaoFinal: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_LeituraMemoriaFiscalSerialReducao: function(ReducaoInicial: String; ReducaoFinal: String): Integer; StdCall;
      //function Daruma_FIMFD_DownloadDaMFD(CoInicial: String; CoFinal: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FIMFD_DownloadDaMFD: function(CoInicial: String; CoFinal: String): Integer; StdCall;

      // Funções das Operações Não Fiscais
      //function Daruma_FI_RecebimentoNaoFiscal( IndiceTotalizador: String; Valor: String; FormaPagamento: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_RecebimentoNaoFiscal: function(IndiceTotalizador: String; Valor: String; FormaPagamento: String): Integer; StdCall;
      //function Daruma_FI_AbreComprovanteNaoFiscalVinculado( FormaPagamento: String; Valor: String; NumeroCupom: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_AbreComprovanteNaoFiscalVinculado: function(FormaPagamento: String; Valor: String; NumeroCupom: String ): Integer; StdCall;
      //function Daruma_FI_UsaComprovanteNaoFiscalVinculado( Texto: String ): Integer; StdCall; External 'Daruma32.dll'
      _Daruma_FI_UsaComprovanteNaoFiscalVinculado: function( Texto: String ): Integer; StdCall;
      //function Daruma_FI_FechaComprovanteNaoFiscalVinculado: Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_FechaComprovanteNaoFiscalVinculado: function(): Integer; StdCall;
      //function Daruma_FI_Sangria( Valor: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_Sangria: function(Valor: String): Integer; StdCall;
      //function Daruma_FI_Suprimento( Valor: String; FormaPagamento: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_Suprimento: function(Valor: String; FormaPagamento: String): Integer; StdCall;
      // Funções de Informações da Impressora
      //function Daruma_FI_StatusCupomFiscal( StatusRel: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_StatusCupomFiscal: function(StatusRel: String): Integer; StdCall;
      //function Daruma_FI_StatusComprovanteNaoFiscalVinculado( StatusRel: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_StatusComprovanteNaoFiscalVinculado: function(StatusRel: String): Integer; StdCall;
      //function Daruma_FI_StatusRelatorioGerencial( StatusRel: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_StatusRelatorioGerencial: function(StatusRel: String): Integer; StdCall;
      //function Daruma_FI_NumeroSerie( NumeroSerie: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_NumeroSerie: function(NumeroSerie: String): Integer; StdCall;
      //function Daruma_FI_SubTotal( SubTotal: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_SubTotal: function(SubTotal: String): Integer; StdCall;
      //function Daruma_FI_NumeroCupom( NumeroCupom: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_NumeroCupom: function(NumeroCupom: String): Integer; StdCall;
      //function Daruma_FI_RetornaGNF( GNF: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_RetornaGNF: function(GNF: String): Integer; StdCall;
      //function Daruma_FI_LeituraXSerial: Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_LeituraXSerial: function(): Integer; StdCall;
      //function Daruma_FI_VersaoFirmware( VersaoFirmware: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_VersaoFirmware: function(VersaoFirmware: String): Integer; StdCall;
      //function Daruma_FI_CGC_IE( CGC: String; IE: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_CGC_IE: function(CGC: String; IE: String): Integer; StdCall;
      //function Daruma_FI_GrandeTotal( GrandeTotal: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_GrandeTotal: function(GrandeTotal: String): Integer; StdCall;
      //function Daruma_FI_VendaBruta( VendaBruta: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_VendaBruta: function(VendaBruta: String): Integer; StdCall;
      //function Daruma_FI_Cancelamentos( ValorCancelamentos: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_Cancelamentos: function(ValorCancelamentos: String): Integer; StdCall;
      //function Daruma_FI_Descontos( ValorDescontos: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_Descontos: function(ValorDescontos: String): Integer; StdCall;
      //function Daruma_FI_NumeroOperacoesNaoFiscais( NumeroOperacoes: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_NumeroOperacoesNaoFiscais: function(NumeroOperacoes: String): Integer; StdCall;
      //function Daruma_FI_NumeroCuponsCancelados( NumeroCancelamentos: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_NumeroCuponsCancelados: function(NumeroCancelamentos: String): Integer; StdCall;
      //function Daruma_FI_NumeroIntervencoes( NumeroIntervencoes: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_NumeroIntervencoes: function(NumeroIntervencoes: String): Integer; StdCall;
      //function Daruma_FI_NumeroReducoes( NumeroReducoes: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_NumeroReducoes: function(NumeroReducoes: String ): Integer; StdCall;
      //function Daruma_FI_NumeroSubstituicoesProprietario( NumeroSubstituicoes: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_NumeroSubstituicoesProprietario: function(NumeroSubstituicoes: String ): Integer; StdCall;
      //function Daruma_FI_UltimoItemVendido( NumeroItem: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_UltimoItemVendido: function( NumeroItem: String ): Integer; StdCall;
      //function Daruma_FI_ClicheProprietarioEx( ClicheEx: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_ClicheProprietarioEx: function( ClicheEx: String ): Integer; StdCall;
      //function Daruma_FI_NumeroCaixa( NumeroCaixa: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_NumeroCaixa: function(NumeroCaixa: String ): Integer; StdCall;
      //function Daruma_FI_NumeroLoja( NumeroLoja: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_NumeroLoja: function(NumeroLoja: String ): Integer; StdCall;
      //function Daruma_FI_SimboloMoeda( SimboloMoeda: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_SimboloMoeda: function(SimboloMoeda: String ): Integer; StdCall;
      //function Daruma_FI_MinutosLigada( Minutos: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_MinutosLigada: function( Minutos: String ): Integer; StdCall;

      //function Daruma_FI_MinutosImprimindo( Minutos: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_MinutosImprimindo: function(Minutos: String): Integer; StdCall;
      //function Daruma_FI_VerificaModoOperacao( Modo: string ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_VerificaModoOperacao: function(Modo: string ): Integer; StdCall;
      //function Daruma_FI_VerificaEpromConectada( Flag: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_VerificaEpromConectada: function(Flag: String ): Integer; StdCall;
      //function Daruma_FI_FlagsFiscais( Var Flag: Integer ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_FlagsFiscais: function(Var Flag: Integer ): Integer; StdCall;
      //function Daruma_FI_ValorPagoUltimoCupom( ValorCupom: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_ValorPagoUltimoCupom: function( ValorCupom: String ): Integer; StdCall;
      //function Daruma_FI_DataHoraImpressora( Data: String; Hora: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_DataHoraImpressora: function(Data: String; Hora: String ): Integer; StdCall;
      //function Daruma_FI_ContadoresTotalizadoresNaoFiscais( Contadores: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_ContadoresTotalizadoresNaoFiscais: function(Contadores: String ): Integer; StdCall;
      //function Daruma_FI_VerificaTotalizadoresNaoFiscais( Totalizadores: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_VerificaTotalizadoresNaoFiscais: function(Totalizadores: String ): Integer; StdCall;
      //function Daruma_FI_DataHoraReducao( Data: String; Hora: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_DataHoraReducao: function(Data: String; Hora: String): Integer; StdCall;
      //function Daruma_FI_DataMovimento( Data: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_DataMovimento: function(Data: String ): Integer; StdCall;
      //function Daruma_FI_VerificaTruncamento( Flag: string ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_VerificaTruncamento: function(Flag: string ): Integer; StdCall;
      //function Daruma_FI_Acrescimos( ValorAcrescimos: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_Acrescimos: function(ValorAcrescimos: String ): Integer; StdCall;
      //function Daruma_FI_ContadorBilhetePassagem( ContadorPassagem: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_ContadorBilhetePassagem: function( ContadorPassagem: String ): Integer; StdCall;
      //function Daruma_FI_VerificaAliquotasIss( Flag: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_VerificaAliquotasIss: function(Flag: String ): Integer; StdCall;
      //function Daruma_FI_VerificaFormasPagamento( Formas: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_VerificaFormasPagamento: function(Formas: String ): Integer; StdCall;
      //function Daruma_FI_VerificaRecebimentoNaoFiscal( Recebimentos: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_VerificaRecebimentoNaoFiscal: function(Recebimentos: String ): Integer; StdCall;
      //function Daruma_FI_VerificaDepartamentos( Departamentos: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_VerificaDepartamentos: function(Departamentos: String ): Integer; StdCall;
      //function Daruma_FI_VerificaTipoImpressora( Var TipoImpressora: Integer ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_VerificaTipoImpressora: function(var TipoImpressora: Integer ): Integer; StdCall;
      //function Daruma_FI_VerificaTotalizadoresParciais( Totalizadores: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_VerificaTotalizadoresParciais: function(Totalizadores: String ): Integer; StdCall;
      //function Daruma_FI_RetornoAliquotas( Aliquotas: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_RetornoAliquotas: function(Aliquotas: String ): Integer; StdCall;
      //function Daruma_FI_VerificaEstadoImpressora( Var ACK: Integer; Var ST1: Integer; Var ST2: Integer ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_VerificaEstadoImpressora: function(var ACK: Integer; var ST1: Integer; var ST2: Integer ): Integer; StdCall;
      //function Daruma_FI_DadosUltimaReducao( DadosReducao: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_DadosUltimaReducao: function( DadosReducao: String ): Integer; StdCall;
      //function Daruma_FI_MonitoramentoPapel( Var Linhas: Integer): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_MonitoramentoPapel: function(var Linhas: Integer): Integer; StdCall;
      //function Daruma_FI_VerificaIndiceAliquotasIss( Flag: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_VerificaIndiceAliquotasIss: function(Flag: String ): Integer; StdCall;
      //function Daruma_FI_ValorFormaPagamento( FormaPagamento: String; Valor: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_ValorFormaPagamento: function(FormaPagamento: String; Valor: String ): Integer; StdCall;
      //function Daruma_FI_ValorTotalizadorNaoFiscal( Totalizador: String; Valor: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_ValorTotalizadorNaoFiscal: function( Totalizador: String; Valor: String ): Integer; StdCall;
      /////  function Daruma_FI_VerificaModeloECF( Modelo: String ): Integer; StdCall; External 'Daruma32.dll';
      //function Daruma_FI_VerificaModeloECF: Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_VerificaModeloECF: function(): Integer; StdCall;

      // Funções de Autenticação e Gaveta de Dinheiro
      //function Daruma_FI_Autenticacao:Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_Autenticacao';
      _Daruma_FI_Autenticacao: function(): Integer; StdCall;
      //function Daruma_FI_AutenticacaoStr(str :string):Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_AutenticacaoStr';
      _Daruma_FI_AutenticacaoStr: function(str :string):Integer; StdCall;
      //function Daruma_FI_VerificaDocAutenticacao:Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_VerificaDocAutenticacao';
      _Daruma_FI_VerificaDocAutenticacao: function(): Integer; StdCall;
      //function Daruma_FI_AcionaGaveta:Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_AcionaGaveta';
      _Daruma_FI_AcionaGaveta: function(): Integer; StdCall;
      //function Daruma_FI_VerificaEstadoGaveta( Var EstadoGaveta: Integer ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_VerificaEstadoGaveta: function(var EstadoGaveta: Integer ): Integer; StdCall;

      // Outras Funções
      //function Daruma_FI_AbrePortaSerial: Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_AbrePortaSerial: function(): Integer; StdCall;
      //function Daruma_FI_RetornoImpressora( Var ACK: Integer; Var ST1: Integer; Var ST2: Integer ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_RetornoImpressora: function(var ACK: Integer; var ST1: Integer; var ST2: Integer ): Integer; StdCall;
      //function Daruma_FI_FechaPortaSerial: Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_FechaPortaSerial';
      _Daruma_FI_FechaPortaSerial: function(): Integer; StdCall;
      //function Daruma_FI_MapaResumo:Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_MapaResumo';
      _Daruma_FI_MapaResumo: function(): Integer; StdCall;
      //function Daruma_FI_AberturaDoDia( ValorCompra: string; FormaPagamento: string ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_AberturaDoDia: function(ValorCompra: string; FormaPagamento: string ): Integer; StdCall;
      //function Daruma_FI_FechamentoDoDia: Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_FechamentoDoDia';
      _Daruma_FI_FechamentoDoDia: function(): Integer; StdCall;
      //function Daruma_FI_ImprimeConfiguracoesImpressora:Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_ImprimeConfiguracoesImpressora';
      _Daruma_FI_ImprimeConfiguracoesImpressora: function(): Integer; StdCall;
      //function Daruma_FI_ImprimeDepartamentos: Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_ImprimeDepartamentos';
      _Daruma_FI_ImprimeDepartamentos: function(): Integer; StdCall;
      //function Daruma_FI_RelatorioTipo60Analitico: Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_RelatorioTipo60Analitico';
      _Daruma_FI_RelatorioTipo60Analitico: function(): Integer; StdCall;
      //function Daruma_FI_RelatorioTipo60Mestre: Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_RelatorioTipo60Mestre';
      _Daruma_FI_RelatorioTipo60Mestre: function(): Integer; StdCall;
      //function Daruma_FI_VerificaImpressoraLigada: Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_VerificaImpressoraLigada';
      _Daruma_FI_VerificaImpressoraLigada: function(): Integer; StdCall;
      //function Daruma_FI_ImprimeConfiguracoes: Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_FI_VerificaImpressoraLigada';
      // 2015-08-31 _Daruma_FI_ImprimeConfiguracoes: function(): Integer; StdCall;

      //funcoes de TEF
      //function Daruma_TEF_ImprimirResposta( Arquivo: string; FormaPagamento: string; Travar:string ): Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_TEF_ImprimirResposta';
      _Daruma_TEF_ImprimirResposta: function( Arquivo: string; FormaPagamento: string; Travar:string ): Integer; StdCall;
      //function Daruma_TEF_FechaRelatorio: Integer; StdCall; External 'Daruma32.dll' Name 'Daruma_TEF_FechaRelatorio';
      _Daruma_TEF_FechaRelatorio: function(): Integer; StdCall;
      //
      ////  function Daruma_FI_RetornaErroExtendido(sParam1: String): Integer; StdCall; external 'Daruma32.dll' Name 'Daruma_FI_RetornaErroExtendido';
      //function Daruma_FI_RetornaErroExtendido(sParam1: String): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FI_RetornaErroExtendido: function(sParam1: String): Integer; StdCall;
      //function Daruma_FI_VerificaEstadoGavetaStr(sParam1: String): Integer; StdCall; external 'Daruma32.dll' Name 'Daruma_FI_VerificaEstadoGavetaStr';
      _Daruma_FI_VerificaEstadoGavetaStr: function(sParam1: String): Integer; StdCall;
      //function Daruma_FI_FlagsFiscaisStr(sParam1: String): Integer; StdCall; external 'Daruma32.dll' Name 'Daruma_FI_FlagsFiscaisStr';
      _Daruma_FI_FlagsFiscaisStr: function(sParam1: String): Integer; StdCall;
      //function Daruma_FIMFD_RetornaInformacao( Indice: String; Valor: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FIMFD_RetornaInformacao: function( Indice: String; Valor: String ): Integer; StdCall;
      //function Daruma_FIMFD_CodigoModeloFiscal(Valor: String): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FIMFD_CodigoModeloFiscal: function(Valor: String): Integer; StdCall;
      //
      //function Daruma_RFD_GerarArquivo(DataInicial: String; DataFinal: String): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_RFD_GerarArquivo: function(DataInicial: String; DataFinal: String): Integer; StdCall;
      //
      //function Daruma_FIMFD_ProgramaRelatoriosGerenciais( NomeRelatorio: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FIMFD_ProgramaRelatoriosGerenciais: function( NomeRelatorio: String ): Integer; StdCall;
      //function Daruma_FIMFD_AbreRelatorioGerencial( NomeRelatorio: String ): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FIMFD_AbreRelatorioGerencial: function( NomeRelatorio: String ): Integer; StdCall;
      //function Daruma_FIMFD_GerarAtoCotepePafData(DataInicial: String; DataFinal: String): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FIMFD_GerarAtoCotepePafData: function(DataInicial: String; DataFinal: String): Integer; StdCall;
      //function Daruma_FIMFD_GerarAtoCotepePafCOO(COOIni: string; COOFim: string): Integer; StdCall; External 'Daruma32.dll';
      _Daruma_FIMFD_GerarAtoCotepePafCOO: function(COOIni: string; COOFim: string): Integer; StdCall;
      procedure Import(var Proc: pointer; Name: Pchar);
    public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;

      procedure CarregaDLL;
      procedure FinalizaDLL;

      function Daruma_Registry_AplMensagem1(AplMsg1: String): Integer;
      function Daruma_Registry_AplMensagem2(AplMsg1: String): Integer;
      //
      function Daruma_Registry_MFD_LeituraMFCompleta( Valor: String ): Integer;
      function Daruma_Registry_Porta(Porta: String ): Integer;
      function Daruma_Registry_Path(Path: String ): Integer;
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
      function Daruma_FI_VendeItem( Codigo: String; Descricao: String; Aliquota: String; TipoQuantidade: String; Quantidade: String; CasasDecimais: Integer; ValorUnitario: String; TipoDesconto: String; Desconto: String): Integer;
      function Daruma_FI_VendeItemTresDecimais(Codigo: String; Descricao: String; Aliquota: String; Quantidade: String; ValorUnitario: String; TipoDesconto: String; Desconto: String): Integer;
      function Daruma_FI_VendeItemDepartamento( Codigo: String; Descricao: String; Aliquota: String; ValorUnitario: String; Quantidade: String; Acrescimo: String; Desconto: String; IndiceDepartamento: String; UnidadeMedida: String): Integer;
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
      function Daruma_FI_SubTotal( SubTotal: String ): Integer;
      function Daruma_FI_NumeroCupom( NumeroCupom: String ): Integer;
      function Daruma_FI_RetornaGNF( GNF: String ): Integer;
      function Daruma_FI_LeituraXSerial: Integer;
      function Daruma_FI_VersaoFirmware( VersaoFirmware: String ): Integer;
      function Daruma_FI_CGC_IE( CGC: String; IE: String ): Integer;
      function Daruma_FI_GrandeTotal( GrandeTotal: String ): Integer;
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
      function Daruma_FI_VerificaTipoImpressora( Var TipoImpressora: Integer ): Integer;
      function Daruma_FI_VerificaTotalizadoresParciais( Totalizadores: String ): Integer;
      function Daruma_FI_RetornoAliquotas( Aliquotas: String ): Integer;
      function Daruma_FI_VerificaEstadoImpressora( Var ACK: Integer; Var ST1: Integer; Var ST2: Integer ): Integer;
      function Daruma_FI_DadosUltimaReducao( DadosReducao: String ): Integer;
      function Daruma_FI_MonitoramentoPapel( Var Linhas: Integer): Integer;
      function Daruma_FI_VerificaIndiceAliquotasIss( Flag: String ): Integer;
      function Daruma_FI_ValorFormaPagamento( FormaPagamento: String; Valor: String ): Integer;
      function Daruma_FI_ValorTotalizadorNaoFiscal( Totalizador: String; Valor: String ): Integer;
      //  function Daruma_FI_VerificaModeloECF( Modelo: String ): Integer;
      function Daruma_FI_VerificaModeloECF: Integer;
      // Funções de Autenticação e Gaveta de Dinheiro
      function Daruma_FI_Autenticacao: Integer;
      function Daruma_FI_AutenticacaoStr(str :string): Integer;
      function Daruma_FI_VerificaDocAutenticacao: Integer;
      function Daruma_FI_AcionaGaveta:Integer;
      function Daruma_FI_VerificaEstadoGaveta( Var EstadoGaveta: Integer ): Integer;
      // Outras Funções
      function Daruma_FI_AbrePortaSerial: Integer;
      function Daruma_FI_RetornoImpressora( Var ACK: Integer; Var ST1: Integer; Var ST2: Integer ): Integer;
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
      //funcoes de TEF
      function Daruma_TEF_ImprimirResposta( Arquivo: string; FormaPagamento: string; Travar:string ): Integer;
      function Daruma_TEF_FechaRelatorio: Integer;
      //
      //  function Daruma_FI_RetornaErroExtendido(sParam1: String): Integer; StdCall; external 'Daruma32.dll' Name 'Daruma_FI_RetornaErroExtendido';
      function Daruma_FI_RetornaErroExtendido(sParam1: String): Integer;
      function Daruma_FI_VerificaEstadoGavetaStr(sParam1: String): Integer;
      function Daruma_FI_FlagsFiscaisStr(sParam1: String): Integer;
      function Daruma_FIMFD_RetornaInformacao( Indice: String; Valor: String ): Integer;
      function Daruma_FIMFD_CodigoModeloFiscal(Valor: String): Integer;
      //
      function Daruma_RFD_GerarArquivo(DataInicial: String; DataFinal: String): Integer;
      //
      function Daruma_FIMFD_ProgramaRelatoriosGerenciais( NomeRelatorio: String ): Integer;
      function Daruma_FIMFD_AbreRelatorioGerencial( NomeRelatorio: String ): Integer;
      function Daruma_FIMFD_GerarAtoCotepePafData(DataInicial: String; DataFinal: String): Integer;
      function Daruma_FIMFD_GerarAtoCotepePafCOO(COOIni: string; COOFim: string): Integer;

      ////////////////////////////
  end;


  {Sandro Silva 2015-06-18 final}

  //
  //
  //function _ecf03_CriaDaruma32: Boolean;
  function _ecf03_CodeErro(Pp1: Integer):Integer;
  function _ecf03_Inicializa(Pp1: String):Boolean;
  function _ecf03_FechaCupom(Pp1: Boolean):Boolean;
  function _ecf03_Pagamento(Pp1: Boolean):Boolean;
  function _ecf03_CancelaUltimoItem(Pp1: Boolean):Boolean;
  function _ecf03_SubTotal(Pp1: Boolean):Real;
  function _ecf03_AbreGaveta(Pp1: Boolean):Boolean;
  function _ecf03_Sangria(Pp1: Real):Boolean;
  function _ecf03_Suprimento(Pp1: Real):Boolean;
  function _ecf03_NovaAliquota(Pp1: String):Boolean;
  function _ecf03_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
  function _ecf03_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
  function _ecf03_CancelaUltimoCupom(Pp1: Boolean):Boolean;
  function _ecf03_AbreNovoCupom(Pp1: Boolean):Boolean;
  function _ecf03_NumeroDoCupom(Pp1: Boolean):String;
  function _ecf03_CancelaItemN(pP1, pP2: String):Boolean;
  function _ecf03_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
  function _ecf03_ReducaoZ(pP1: Boolean):Boolean;
  function _ecf03_LeituraX(pP1: Boolean):Boolean;
  function _ecf03_RetornaVerao(pP1: Boolean):Boolean;
  function _ecf03_LigaDesLigaVerao(pP1: Boolean):Boolean;
  function _ecf03_VersodoFirmware(pP1: Boolean): String;
  function _ecf03_NmerodeSrie(pP1: Boolean): String;
  function _ecf03_CGCIE(pP1: Boolean): String;
  function _ecf03_Cancelamentos(pP1: Boolean): String;
  function _ecf03_Descontos(pP1: Boolean): String;
  function _ecf03_ContadorSeqencial(pP1: Boolean): String;
  function _ecf03_Nmdeoperaesnofiscais(pP1: Boolean): String;
  function _ecf03_NmdeCuponscancelados(pP1: Boolean): String;
  function _ecf03_NmdeRedues(pP1: Boolean): String;
  function _ecf03_Nmdeintervenestcnicas(pP1: Boolean): String;
  function _ecf03_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
  function _ecf03_Clichdoproprietrio(pP1: Boolean): String;
  function _ecf03_NmdoCaixa(pP1: Boolean): String;
  function _ecf03_Nmdaloja(pP1: Boolean): String;
  function _ecf03_Moeda(pP1: Boolean): String;
  function _ecf03_Dataehoradaimpressora(pP1: Boolean): String;
  function _ecf03_Datadaultimareduo(pP1: Boolean): String;
  function _ecf03_Datadomovimento(pP1: Boolean): String;
  function _ecf03_StatusGaveta(Pp1: Boolean):String;
  function _ecf03_RetornaAliquotas(pP1: Boolean): String;
  function _ecf03_Vincula(pP1: String): Boolean;
  function _ecf03_FlagsDeISS(pP1: Boolean): String;
  function _ecf03_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
  function _ecf03_MudaMoeda(pP1: String): Boolean;
  function _ecf03_MostraDisplay(pP1: String): Boolean;
  function _ecf03_leituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
  function _ecf03_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean;
  function _ecf03_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
  function _ecf03_FechaCupom2(sP1: Boolean): Boolean;
  function _ecf03_ImprimeCheque(rP1: Real; sP2: String): Boolean;
  function _ecf03_MapaResumo(sP1: Boolean): Boolean;
  function _ecf03_GrandeTotal(sP1: Boolean): String;
  function _ecf03_TotalizadoresDasAliquotas(sP1: Boolean): String;
  function _ecf03_CupomAberto(sP1: Boolean): boolean;
  function _ecf03_FaltaPagamento(sP1: Boolean): boolean;
  //
  // PAF
  //
  function _ecf03_Marca(sP1: Boolean): String;
  function _ecf03_Modelo(sP1: Boolean): String;
  function _ecf03_Tipodaimpressora(pP1: Boolean): String;
  function _ecf03_VersaoSB(pP1: Boolean): String; //
  function _ecf03_HoraIntalacaoSB(pP1: Boolean): String; //
  function _ecf03_DataIntalacaoSB(pP1: Boolean): String; //
  function _ecf03_ProgramaAplicativo(sP1: Boolean): boolean;
  //
  function _ecf03_DadosDaUltimaReducao(pP1: Boolean): String; //
  function _ecf03_CodigoModeloEcf(pP1: Boolean): String; //
  function _ecf03_DataUltimaReducao: String;
  //
  // Contadores
  //
  function _ecf03_GNF(Pp1: Boolean):String;
  function _ecf03_GRG(Pp1: Boolean):String;
  function _ecf03_CDC(Pp1: Boolean):String;
  function _ecf03_CCF(Pp1: Boolean):String;
  function _ecf03_CER(Pp1: Boolean):String;

var
  _ecf03: TDaruma32;

implementation

// ---------------------------------- //
// Tratamento de erros da IF DARUMA   //
// ---------------------------------- //
{
function _ecf03_CriaDaruma32: Boolean;
begin

end;
}
function _ecf03_CodeErro(Pp1: Integer):Integer;
var
  Daruma_iACK, Daruma_iST1, Daruma_iST2: Integer;
  sRetorno, sMensagem: String;
begin
  //
  Result               := 0;
//  Form1.Image3.Visible := False;
  //
  Daruma_iACK := 0; //Variaveis devem ser inicializadas para Alocar Espaco
  Daruma_iST1 := 0;
  Daruma_iST2 := 0;
  sMensagem :='';
  //
  //
  if Daruma_iACK = 6 then
  begin
    // Verifica ST1
    Result := Daruma_iST1 + Daruma_iST2;
    //
    if Daruma_iST1 >= 128 then begin Daruma_iST1 := Daruma_iST1 - 128; sMensagem := 'Papel acabou.'; end;
    if Daruma_iST1 >= 64  then // Pouco Papel
    begin
      Daruma_iST1 := Daruma_iST1 - 64;
      if Form1.Memo3.Visible then
      begin
        Form1.Panel2.Visible := True;
        Form1.Panel2.BringToFront;
      end;
      Result := Result - 64;
    end;
    //
    if Daruma_iST1 >= 32  then begin Daruma_iST1 := Daruma_iST1 - 32;  sMensagem := sMensagem + 'Erro no Relogio.'; end;
    if Daruma_iST1 >= 16  then begin Daruma_iST1 := Daruma_iST1 - 16;  sMensagem := sMensagem + 'Impressora em Erro.'; end;
    if Daruma_iST1 >= 8   then begin Daruma_iST1 := Daruma_iST1 - 8;   sMensagem := sMensagem + 'Falta o ESC no comando.'; end;
    if Daruma_iST1 >= 4   then begin Daruma_iST1 := Daruma_iST1 - 4;   sMensagem := sMensagem + 'Nao existe o Comando.'; end;
    if Daruma_iST1 >= 2   then begin Daruma_iST1 := Daruma_iST1 - 2;   Result := Result - 2; end; //  sMensagem := sMensagem + 'Cupom Aberto' ; end;
    if Daruma_iST1 >= 1   then begin {Daruma_iST1 := Daruma_iST1 - 1;}   sMensagem := sMensagem + 'Parametro Errado.'; end;
    // Verifica ST2
    if Daruma_iST2 >= 128 then begin Daruma_iST2 := Daruma_iST2 - 128; sMensagem := sMensagem + 'Parametro Invalido.'; end;
    if Daruma_iST2 >= 64  then begin Daruma_iST2 := Daruma_iST2 - 64;  sMensagem := sMensagem + 'MF Lotada.'; end;
    if Daruma_iST2 >= 32  then begin Daruma_iST2 := Daruma_iST2 - 32;  sMensagem := sMensagem + 'Erro na Ram.'; end;
    if Daruma_iST2 >= 16  then begin Daruma_iST2 := Daruma_iST2 - 16;  sMensagem := sMensagem + 'Aliquota Nao Programada.'; end;
    if Daruma_iST2 >= 8   then begin Daruma_iST2 := Daruma_iST2 - 8;   sMensagem := sMensagem + 'Nao cabe mais Aliquota.'; end;
    if Daruma_iST2 >= 4   then begin Daruma_iST2 := Daruma_iST2 - 4;   sMensagem := sMensagem + 'Canc. Nao Permitido.'; end;
    if Daruma_iST2 >= 2   then begin Daruma_iST2 := Daruma_iST2 - 2;   sMensagem := sMensagem + 'CNPJ nao Programado.'; end;
    //
    if Daruma_iST2 >= 1   then
    begin
      //
      // Daruma_iST2 := Daruma_iST2 - 1;
      sMensagem   := sMensagem + 'Comando não executado...';
      Result := Result - 1;
      //
      setlength(sRetorno,4);
      // sRetorno := Replicate(' ',4);
      // sRetorno := '    ';
      _ecf03.Daruma_FI_RetornaErroExtendido(sRetorno);
      //
      if StrToInt(sRetorno) = 42 then
      begin
        sMensagem := '';
        ShowMessage('Comando não executado'+chr(10)+'A leitura X inicial do dia vai ser emitida.');
        _ecf03_LeituraX(True);

        {Sandro Silva 2015-10-06 inicio}
        if Trim(Form1.sNumeroDeSerieDaImpressora) = '' then
        begin
          Form1.sNumeroDeSerieDaImpressora := Copy(AllTrim(_ecf03_NmerodeSrie(True)), 1, 20);
        end;
        Form1.Demais('LX'); // 2015-10-06
        {Sandro Silva 2015-10-06 final}

        Result := 99;
      end;
    end;
    //
    if Length(sMensagem) > 1 then showmessage( sMensagem);
    //
  end;
  //
  if Daruma_iACK = 21 then
  begin
    showmessage( 'Daruma32.dll - Erro Fatal na Impressora');
    Application.Terminate;
    Exit;
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
    end else Result := 0;
  end;
  //
end;

// ----------------------------//
// Detecta qual a porta que    //
// a impressora está conectada //
// DARUMA                      //
// --------------------------- //
function _ecf03_Inicializa(Pp1: String):Boolean;
var
  I, Retorno : Integer;
//  sFormasPagamento: string;
//  Mais1ini : tIniFile;
  sString : String;
begin
  if _ecf03 = nil then
     _ecf03 := TDaruma32.Create(Application);

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
    _ecf03.Daruma_Registry_Porta(pchar(pP1));
    Retorno := _ecf03.Daruma_FI_NumeroSerie(sString);
    //
    for I := 1 to 7 do
    begin
      if Retorno <> 1 then
      begin
        ShowMessage('DARUMA'+Chr(10)+'Testando COM'+StrZero(I,1,0));
        _ecf03.Daruma_Registry_Porta(pchar('COM'+StrZero(I,1,0)));
        Retorno := _ecf03.Daruma_FI_NumeroSerie(sString);
        if Retorno = 1 then
          Form1.sPorta := 'COM'+StrZero(I,1,0);
      end;
    end;
    //
    if Retorno = 1 then Result := True else Result := False;
  end else Result := True;
  //
  _ecf03.Daruma_FIMFD_ProgramaRelatoriosGerenciais(pchar('IDENT DO PAF'));
  _ecf03.Daruma_FIMFD_ProgramaRelatoriosGerenciais(pchar('MEIOS DE PAGTO'));
  _ecf03.Daruma_FIMFD_ProgramaRelatoriosGerenciais(pchar('VENDA PRAZO'));
  _ecf03.Daruma_FIMFD_ProgramaRelatoriosGerenciais(pchar('DAV Emitidos'));
  _ecf03.Daruma_FIMFD_ProgramaRelatoriosGerenciais(pchar('CARTAO TEF'));
  _ecf03.Daruma_FIMFD_ProgramaRelatoriosGerenciais(pchar('Orcamento'));
  // 2016-02-04 Sandro Silva _ecf03.Daruma_FIMFD_ProgramaRelatoriosGerenciais(pchar('CONF CONTA'));
  // 2016-02-11 Sandro Silva _ecf03.Daruma_FIMFD_ProgramaRelatoriosGerenciais(pchar('TRANSF CONTA'));
  // 2016-02-11 _ecf03.Daruma_FIMFD_ProgramaRelatoriosGerenciais(pchar('CONTAS ABERTAS'));
  _ecf03.Daruma_FIMFD_ProgramaRelatoriosGerenciais(pchar('CONF CONTA CLI'));// 2016-02-04 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
  _ecf03.Daruma_FIMFD_ProgramaRelatoriosGerenciais(pchar('TRANSF CONT CLI')); // 2016-02-11 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
  _ecf03.Daruma_FIMFD_ProgramaRelatoriosGerenciais(pchar('CONT CLI ABERTA')); // 2016-02-11 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
  _ecf03.Daruma_FIMFD_ProgramaRelatoriosGerenciais(pchar('CONF MESA'));
  _ecf03.Daruma_FIMFD_ProgramaRelatoriosGerenciais(pchar('TRANSF MESA'));
  _ecf03.Daruma_FIMFD_ProgramaRelatoriosGerenciais(pchar('MESAS ABERTAS'));
  _ecf03.Daruma_FIMFD_ProgramaRelatoriosGerenciais(pchar('PARAM CONFIG'));
  //
end;

// ------------------------------ //
// Fecha o cupom que está sendo   //
// emitido                        //
// IF DARUMA FS 345               //
// ------------------------------ //
function _ecf03_FechaCupom(Pp1: Boolean):Boolean;
begin
  // -------------------- //
  // Fecha o cupom fiscal //
  // -------------------- //
  if Form1.fTotal <> 0 then
  begin
    if Form1.fTotal >= Form1.ibDataSet25RECEBER.AsFloat then
    begin
      _ecf03_CodeErro(_ecf03.Daruma_FI_IniciaFechamentoCupom('D','$',StrZero((Form1.fTotal-Form1.ibDataSet25RECEBER.AsFloat)*100,14,0)));
    end else
    begin
      _ecf03_CodeErro(_ecf03.Daruma_FI_IniciaFechamentoCupom('A','$',StrZero((Form1.ibDataSet25RECEBER.AsFloat-Form1.fTotal)*100,14,0)));
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
function _ecf03_Pagamento(Pp1: Boolean):Boolean;
{Sandro Silva 2017-11-13 inicio HOMOLOGA 2017}
// Evitar que duplique impressão dados do consumidor
var
  sCNPJCPF: String;
  sNomeCliente: String;
  sEndereco1: String;
  sEndereco2: String;
{Sandro Silva 2017-11-13 inicio HOMOLOGA 2017}
begin
  {Sandro Silva 2017-11-13 inicio HOMOLOGA 2017}
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
  {Sandro Silva 2017-11-13 final HOMOLOGA 2017}
  //
  Sleep(200);
  //
  if Form1.ibDataSet25ACUMULADO1.AsFloat <> 0 then _ecf03.Daruma_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label9.Caption)) ,Format('%10.2n',[Form1.ibDataSet25ACUMULADO1.AsFloat]));
  if Form1.ibDataSet25ACUMULADO2.AsFloat <> 0 then _ecf03.Daruma_FI_EfetuaFormaPagamento(pchar('Dinheiro')                    ,Format('%10.2n',[Form1.ibDataSet25ACUMULADO2.AsFloat]));
  if Form1.ibDataSet25PAGAR.AsFloat      <> 0 then _ecf03.Daruma_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label8.Caption)),Format('%10.2n',[Form1.ibDataSet25PAGAR.AsFloat])      );
  if Form1.ibDataSet25DIFERENCA_.AsFloat <> 0 then _ecf03.Daruma_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label17.Caption)),Format('%10.2n' ,[Form1.ibDataSet25DIFERENCA_.AsFloat]));
  if Form1.ibDataSet25VALOR01.AsFloat    <> 0 then _ecf03.Daruma_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label18.Caption)),Format('%10.2n',[Form1.ibDataSet25VALOR01.AsFloat])   );
  if Form1.ibDataSet25VALOR02.AsFloat    <> 0 then _ecf03.Daruma_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label19.Caption)),Format('%10.2n',[Form1.ibDataSet25VALOR02.AsFloat])   );
  if Form1.ibDataSet25VALOR03.AsFloat    <> 0 then _ecf03.Daruma_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label20.Caption)),Format('%10.2n',[Form1.ibDataSet25VALOR03.AsFloat])   );
  if Form1.ibDataSet25VALOR04.AsFloat    <> 0 then _ecf03.Daruma_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label21.Caption)),Format('%10.2n',[Form1.ibDataSet25VALOR04.AsFloat])   );
  if Form1.ibDataSet25VALOR05.AsFloat    <> 0 then _ecf03.Daruma_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label22.Caption)),Format('%10.2n',[Form1.ibDataSet25VALOR05.AsFloat])   );
  if Form1.ibDataSet25VALOR06.AsFloat    <> 0 then _ecf03.Daruma_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label23.Caption)),Format('%10.2n',[Form1.ibDataSet25VALOR06.AsFloat])   );
  if Form1.ibDataSet25VALOR07.AsFloat    <> 0 then _ecf03.Daruma_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label24.Caption)),Format('%10.2n',[Form1.ibDataSet25VALOR07.AsFloat])   );
  if Form1.ibDataSet25VALOR08.AsFloat    <> 0 then _ecf03.Daruma_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label25.Caption)),Format('%10.2n',[Form1.ibDataSet25VALOR08.AsFloat])   );
{
  if Form1.ibDataSet25ACUMULADO1.AsFloat <> 0 then Daruma_FI_EfetuaFormaPagamentoDescricaoForma(pchar(AllTrim(Form2.Label9.Caption)) ,Format('%10.2n',[Form1.ibDataSet25ACUMULADO1.AsFloat]),'');
  if Form1.ibDataSet25ACUMULADO2.AsFloat <> 0 then Daruma_FI_EfetuaFormaPagamentoDescricaoForma(pchar('Dinheiro')                    ,Format('%10.2n',[Form1.ibDataSet25ACUMULADO2.AsFloat]),'');
  if Form1.ibDataSet25PAGAR.AsFloat      <> 0 then Daruma_FI_EfetuaFormaPagamentoDescricaoForma(pchar(AllTrim(Form2.Label8.Caption)),Format('%10.2n',[Form1.ibDataSet25PAGAR.AsFloat])      ,'');
  if Form1.ibDataSet25DIFERENCA_.AsFloat <> 0 then Daruma_FI_EfetuaFormaPagamentoDescricaoForma(pchar(AllTrim(Form2.Label17.Caption)),Format('%10.2n' ,[Form1.ibDataSet25RECEBER.AsFloat])  ,'');
  if Form1.ibDataSet25VALOR01.AsFloat    <> 0 then Daruma_FI_EfetuaFormaPagamentoDescricaoForma(pchar(AllTrim(Form2.Label18.Caption)),Format('%10.2n',[Form1.ibDataSet25VALOR01.AsFloat])   ,'');
  if Form1.ibDataSet25VALOR02.AsFloat    <> 0 then Daruma_FI_EfetuaFormaPagamentoDescricaoForma(pchar(AllTrim(Form2.Label19.Caption)),Format('%10.2n',[Form1.ibDataSet25VALOR02.AsFloat])   ,'');
  if Form1.ibDataSet25VALOR03.AsFloat    <> 0 then Daruma_FI_EfetuaFormaPagamentoDescricaoForma(pchar(AllTrim(Form2.Label20.Caption)),Format('%10.2n',[Form1.ibDataSet25VALOR03.AsFloat])   ,'');
  if Form1.ibDataSet25VALOR04.AsFloat    <> 0 then Daruma_FI_EfetuaFormaPagamentoDescricaoForma(pchar(AllTrim(Form2.Label21.Caption)),Format('%10.2n',[Form1.ibDataSet25VALOR04.AsFloat])   ,'');
  if Form1.ibDataSet25VALOR05.AsFloat    <> 0 then Daruma_FI_EfetuaFormaPagamentoDescricaoForma(pchar(AllTrim(Form2.Label22.Caption)),Format('%10.2n',[Form1.ibDataSet25VALOR05.AsFloat])   ,'');
  if Form1.ibDataSet25VALOR06.AsFloat    <> 0 then Daruma_FI_EfetuaFormaPagamentoDescricaoForma(pchar(AllTrim(Form2.Label23.Caption)),Format('%10.2n',[Form1.ibDataSet25VALOR06.AsFloat])   ,'');
  if Form1.ibDataSet25VALOR07.AsFloat    <> 0 then Daruma_FI_EfetuaFormaPagamentoDescricaoForma(pchar(AllTrim(Form2.Label24.Caption)),Format('%10.2n',[Form1.ibDataSet25VALOR07.AsFloat])   ,'');
  if Form1.ibDataSet25VALOR08.AsFloat    <> 0 then Daruma_FI_EfetuaFormaPagamentoDescricaoForma(pchar(AllTrim(Form2.Label25.Caption)),Format('%10.2n',[Form1.ibDataSet25VALOR08.AsFloat])   ,'');
}
  {Sandro Silva 2017-11-13 inicio HOMOLOGA 2017
  // Evitar que duplique impressão dados do consumidor
  //
  if (AllTrim(Form2.Edit8.Text)<>'') or (AllTrim(Form2.Edit2.Text)<>'') then
  begin
    _ecf03.Daruma_FI_IdentificaConsumidor(AllTrim(Form2.Edit8.Text),AllTrim(Form2.Edit1.Text)+ ' ' +AllTrim(Form2.Edit3.Text),AllTrim(Form2.Edit2.Text)); // Identifica o consumidor
  end;
  //
  }
  if (AllTrim(sNomeCliente)<>'') or (AllTrim(sCNPJCPF)<>'') then
  begin
    _ecf03.Daruma_FI_IdentificaConsumidor(Copy(AllTrim(sNomeCliente), 1, 35),AllTrim(sEndereco1)+ ' ' +AllTrim(sEndereco2),AllTrim(sCNPJCPF)); // Identifica o consumidor // Sandro Silva 2019-08-09 _ecf03.Daruma_FI_IdentificaConsumidor(AllTrim(sNomeCliente),AllTrim(sEndereco1)+ ' ' +AllTrim(sEndereco2),AllTrim(sCNPJCPF)); // Identifica o consumidor
  end;
  {Sandro Silva 2017-11-13 final HOMOLOGA 2017}
  _ecf03.Daruma_FI_TerminaFechamentoCupom('MD5: '+Form1.sMD5DaLista+chr(10)+ConverteAcentos(Form1.sMensagemPromocional));
  //
  Result := True;
  //
end;


// --------------------- //
// Cancela o último item //
// --------------------- //
function _ecf03_CancelaUltimoItem(Pp1: Boolean):Boolean;
begin
  if _ecf03_codeErro(_ecf03.Daruma_FI_CancelaItemAnterior()) = 0 then Result := True else Result := False;
end;

// ---------------------- //
// Cancela o último cupom //
// ---------------------- //
function _ecf03_CancelaUltimoCupom(Pp1: Boolean):Boolean;
begin
//  if _ecf03_codeErro(Daruma_FI_CancelaCupom()) = 0 then Result := True else Result := False;
  if _ecf03.Daruma_FI_CancelaCupom() = 1 then Result := True else Result := False;
  if Result = False then
    ShowMessage('Cancelamento não permitido'); // Sandro Silva 2018-10-18
end;

function _ecf03_SubTotal(Pp1: Boolean):Real;
var
  sSubTotal: string;
begin
  // --------------------- //
  //  Retorno do Subtotal  //
  // --------------------- //
  sSubTotal := Replicate(' ',14);
  //

  if _ecf03.Daruma_FI_SubTotal(sSubTotal) = 1 then
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
    Result := 0;
  //
end;

function _ecf03_AbreNovoCupom(Pp1: Boolean):Boolean;
var
  Daruma_iACK, Daruma_iST1, Daruma_iST2: Integer;
begin
  if _ecf03.Daruma_FI_AbreCupom('') = 1 then
  begin
    _ecf03.Daruma_FI_RetornoImpressora(Daruma_iACK, Daruma_iST1, Daruma_iST2);
    if Daruma_iST2 > 1 then
    begin
      Result := False;
      _ecf03_FechaCupom2(True);
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
function _ecf03_NumeroDoCupom(Pp1: Boolean):String;
begin
  SetLEngth(Result,6);
  Result := '000000';
  _ecf03_CodeErro(_ecf03.Daruma_FI_NumeroCupom(Result));
  Result := LimpaNumero(Result);
end;


// -------------------------- //
// Retorna o número do CCF    //
// -------------------------- //
function _ecf03_ccF(Pp1: Boolean):String;
begin
  Result := Replicate('0',6);
  _ecf03.Daruma_FIMFD_RetornaInformacao('30',Result);
end;

// ------------------------------------------------------------------------- //
// Retorna o número de operações não fiscais executadas na impressora. GNF   //
// ------------------------------------------------------------------------- //
function _ecf03_gnf(Pp1: Boolean):String;
begin
  SetLEngth(Result,6);
  Result := '000000';
  _ecf03_CodeErro(_ecf03.Daruma_FI_RetornaGNF(Result));
  Result := LimpaNumero(Result);
end;

// ------------------------------------------------------------------------- //
// Retorna o número de operações não fiscais executadas na impressora. CER   //
// ------------------------------------------------------------------------- //
function _ecf03_CER(Pp1: Boolean):String;
begin
  Result := Replicate('0',80);
  // ShowMEssage(Result);
  _ecf03.Daruma_FIMFD_RetornaInformacao('44',Result);
  Result := Copy(Result,29,4);
end;

// --------------------------------------- //
// Contador Geral de Relatorio Gerencial   //
// --------------------------------------- //
function _ecf03_GRG(Pp1: Boolean):String;
begin
  Result := Replicate('0',6);
  _ecf03.Daruma_FIMFD_RetornaInformacao('33',Result);
end;

// -------------- //
// Contador CDC   //
// -------------- //
function _ecf03_CDC(Pp1: Boolean):String;
begin
  Result := Replicate('0',4);
  _ecf03.Daruma_FIMFD_RetornaInformacao('45',Result);
  Result := '00'+Result;
end;



// ------------------------------ //
// Cancela um item N              //
// IF DARUMA FS 345               //
// ------------------------------ //
function _ecf03_CancelaItemN(pP1, pP2 : String):Boolean;
begin
  //
  if _ecf03_CodeErro(_ecf03.Daruma_FI_CancelaItemGenerico(StrZero( StrToInt(pP1),4,0))) = 0 then Result := True else Result := False;
  //
end;

// -------------------------------- //
// Abre a gaveta                    //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf03_AbreGaveta(Pp1: Boolean):Boolean;
begin
  _ecf03.Daruma_FI_AcionaGaveta();
  Result := True;
end;

// -------------------------------- //
// Status da gaveta                 //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf03_StatusGaveta(Pp1: Boolean):String;
var
  I : Integer;
begin
  I := 0;
  _ecf03.Daruma_FI_VerificaEstadoGaveta( I );
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
function _ecf03_Sangria(Pp1: Real):Boolean;
begin
  ShowMessage('Sangria de: '+Format('%10.2n',[pP1]));
  if _ecf03_codeErro(_ecf03.Daruma_FI_Sangria(Format('%10.2n',[pP1]))) = 0 then
    Result := True
  else
    Result := False;
end;

// -------------------------------- //
// Suprimento                       //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf03_Suprimento(Pp1: Real):Boolean;
begin
  ShowMessage('Suprimento de: '+Format('%10.2n',[pP1]));
  if _ecf03_codeErro(_ecf03.Daruma_FI_Suprimento(Format('%10.2n',[pP1]),'Dinheiro')) = 0 then
    Result := True
  else
    Result := False;
end;

// -------------------------------- //
// Inclui uma nova aliquota         //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf03_NovaAliquota(Pp1: String):Boolean;
begin
  if _ecf03_CodeErro(_ecf03.Daruma_FI_ProgramaAliquota( pchar( pP1 ),0)) = 0 then
    Result := True
  else
    Result := False;
end;

function _ecf03_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
var
  I : Integer;
begin
  //
  Deletefile(pChar('c:\DarumaATOCOTEPE_DARUMA.txt'));
  //
//  Daruma_Registry_AlterarRegistry('AtoCotepe','Path','c:\DARUMA');
//  Daruma_Registry_AlterarRegistry('AtoCotepe','Beep','1');
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
    pP2 := StrZero(StrToInt(pP2),6,0);
    pP3 := StrZero(StrToInt(pP3),6,0);
    //
  end;
  //
  if Form7.sMfd = '2' then
  begin
    //
    if Form7.Label3.Caption = 'Data inicial:' then
    begin
      //
      pP2 := Copy(DateToStr(Form7.DateTimePicker1.Date),1,2)+Copy(DateToStr(Form7.DateTimePicker1.Date),4,2)+Copy(DateToStr(Form7.DateTimePicker1.Date),7,4);
      pP3 := Copy(DateToStr(Form7.DateTimePicker2.Date),1,2)+Copy(DateToStr(Form7.DateTimePicker2.Date),4,2)+Copy(DateToStr(Form7.DateTimePicker2.Date),7,4);
      I := _ecf03.Daruma_FIMFD_GerarAtoCotepePafData(pP2,pP3); // Por Data
      //
    end else
    begin
      pP2 := Form7.MaskEdit1.Text;
      pP3 := Form7.MaskEdit2.Text;
      I := _ecf03.Daruma_FIMFD_GerarAtoCotepePafCoo(pP2,pP3); // Por COO
    end;
    //
  end else
  begin
    I := _ecf03.Daruma_FIMFD_DownloadDaMFD(pchar(pP2),pchar(pP3));
  end;
  //
  if Form7.sMfd = '2' then
  begin
    if I = 1 then
    begin
      CopyFile(pChar('c:\DarumaATOCOTEPE_DARUMA.txt'),pChar(pP1),True);
      ShowMessage('O seguinte arquivo será gravado: '+pP1);
      Deletefile(pChar('c:\DarumaATOCOTEPE_DARUMA.txt'));
      Result := True;
    end else
    begin
      _ecf03_CodeErro(I);
      Result := False;
    end;
  end else
  begin
    //
    if I = 1 then
    begin
      if FileExists('C:\RETORNO.TXT') then
      begin
        CopyFile(pChar('C:\RETORNO.TXT'),pChar(pP1),True);
        ShowMessage('O seguinte arquivo será gravado: '+pP1);
        Deletefile(pChar('C:\RETORNO.TXT'));
        Result := True;
      end else Result := False;
    end else
    begin
      _ecf03_CodeErro(I);
      Result := False;
    end;
    //
  end;
  //


{
  //
  Deletefile(pChar('c:\DarumaATOCOTEPE_DARUMA.txt'));
  Deletefile(pChar('c:\RETORNO.TXT'));
  //
//  Daruma_Registry_AlterarRegistry('AtoCotepe','Path','c:\DARUMA');
//  Daruma_Registry_AlterarRegistry('AtoCotepe','Beep','1');
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
    pP2 := StrZero(StrToInt(pP2),6,0);
    pP3 := StrZero(StrToInt(pP3),6,0);
    //
  end;
  //
  if Form7.sMfd = '2' then
  begin
    //
    if Form7.Label3.Caption = 'Data inicial:' then
    begin
      //
      pP2 := Copy(DateToStr(Form7.DateTimePicker1.Date),1,2)+Copy(DateToStr(Form7.DateTimePicker1.Date),4,2)+Copy(DateToStr(Form7.DateTimePicker1.Date),7,4);
      pP3 := Copy(DateToStr(Form7.DateTimePicker2.Date),1,2)+Copy(DateToStr(Form7.DateTimePicker2.Date),4,2)+Copy(DateToStr(Form7.DateTimePicker2.Date),7,4);
      I := Daruma_FIMFD_GerarAtoCotepePafData(pP2,pP3); // Por Data
      //
    end else
    begin
      I := Daruma_FIMFD_GerarAtoCotepePafCoo(pP2,pP3); // Por COO
    end;
    //
  end else
  begin
    I := Daruma_FIMFD_DownloadDaMFD(pchar(pP2),pchar(pP3));
  end;
  //
  if I = 1 then
  begin
    //
    if FileExists('C:\RETORNO.TXT') then
    begin
      CopyFile(pChar('C:\RETORNO.TXT'),pChar(pP1),True);
      ShowMessage('O seguinte arquivo será gravado: '+pP1);
    end;
    //
    if FileExists('DarumaATOCOTEPE_DARUMA.txt') then
    begin
      CopyFile(pChar('DarumaATOCOTEPE_DARUMA.txt'),pChar(pP1),True);
      ShowMessage('O seguinte arquivo será gravado: '+pP1);
    end;
    //
    Result := True;
//    Deletefile(pChar('c:\DarumaATOCOTEPE_DARUMA.txt'));
//    Deletefile(pChar('c:\RETORNO.TXT'));
    //
    //
  end else
  begin
    _ecf03_CodeErro(I);
    Result := False;
  end;
  //
}
end;

function _ecf03_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
begin
  //
  if Form1.sTipo = 's' then
    _ecf03.Daruma_Registry_MFD_LeituraMFCompleta('0')
  else
    _ecf03.Daruma_Registry_MFD_LeituraMFCompleta('1');
  //
  if Length(pP1) = 6 then
  begin
    _ecf03_CodeErro(_ecf03.Daruma_FI_LeituraMemoriaFiscalData(pP1,pP2)); // Por data
  end else
  begin
    _ecf03_CodeErro(_ecf03.Daruma_FI_LeituraMemoriaFiscalReducao(pP1,pP2));
  end;
  //
  Result := True;
  //
end;

// -------------------------------- //
// Venda do Item                    //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf03_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
var
  I : Integer;
begin
  //
  if StrToInt(pP7) > 0 then pP8 := StrZero(((StrToInt(pP5)/1000)*(StrToInt(pp4)/1000)*(StrToInt(pp7)/10)),7,0);
  //
  pP6 := Copy(pP6+'   ',1,3);
  pP5 := pP5 + '0';
  //
  if _ecf03.Daruma_FI_VendeItemDepartamento( pchar(pP1),          //Codigo
                                      pchar(AllTrim(pP2)), // Descricao
                                      pChar(pP3),          // Aliquota
                                      pchar(pP5),          // ValorUnitario
                                      pchar(pP4),          // Quantidade
                                      '0',                 // Acrescimo
                                      pP8,                 // Desconto
                                      pChar('01'),         // IndiceDepartamento
                                      pChar(pP6),          // UnidadeMedida
                                      ) <> 1 then
  begin
    //
    if StrToInt(pP7) > 0 then pP7 := StrZero(StrToInt(pP7)*10,4,0); // Desconto %
    if StrToInt(pP8) > 0 then pP8 := StrZero(StrToInt(pP8),8,0); // Desconco $
    //
    pP4 := '0'+Copy(pP4,1,4)+','+Copy(pP4,5,3);
    pP5 := Copy('00' + pP5,1,9);
    //
    if StrToInt(pP7) > 0 then
    begin
                                          // Valor de desconto em %
      I := _ecf03.Daruma_FI_VendeItemTresDecimais( pchar(pP1),            // Codigo: STRING até 13 caracteres com o código do produto.
                           pchar(Copy(AllTrim(pP2)+Replicate(' ',29),1,29)), // Descricao: STRING até 29 caracteres com a descrição do produto.
                           pChar(pP3),            // Aliquota: STRING com o valor ou o índice da alíquota tributária. Se for o valor deve ser informado com o tamanho de 4 caracteres ou 5 com a vírgula. Se for o índice da alíquota deve ser 2 caracteres. Ex. (18,00 para o valor ou 05 para o índice).
                           pchar(pP4),            // Quantidade: STRING com até 4 dígitos para quantidade inteira e 7 dígitos para quantidade fracionária. Na quantidade fracionária são 3 casas decimais.
                           pchar(pP5),            // ValorUnitario: STRING até 9 dígitos para valor unitário
                           '%',                   // TipoDesconto: 1 (um) caracter indicando a forma do desconto. '$' desconto por valor e '%' desconto percentual.
                           pchar(pP7));
    end else
    begin                                         // Valor de desconto em $
      I := _ecf03.Daruma_FI_VendeItemTresDecimais(pchar(pP1),            // Codigo: STRING até 13 caracteres com o código do produto.
                           pchar(Copy(AllTrim(pP2)+Replicate(' ',29),1,29)), // Descricao: STRING até 29 caracteres com a descrição do produto.
                           pChar(pP3),            // Aliquota: STRING com o valor ou o índice da alíquota tributária. Se for o valor deve ser informado com o tamanho de 4 caracteres ou 5 com a vírgula. Se for o índice da alíquota deve ser 2 caracteres. Ex. (18,00 para o valor ou 05 para o índice).
                           pchar(pP4),            // Quantidade: STRING com até 4 dígitos para quantidade inteira e 7 dígitos para quantidade fracionária. Na quantidade fracionária são 3 casas decimais.
                           pchar(pP5),            // ValorUnitario: STRING até 8 dígitos para valor unitário
                           '$',                   // TipoDesconto: 1 (um) caracter indicando a forma do desconto. '$' desconto por valor e '%' desconto percentual.
                           pchar(pP8)); // ValorDesconto: String com até 8 dígitos para desconto por valor (2 casas decimais) e 4 dígitos para desconto percentual.

    end;
    if I = 1 then Result := True else
    begin
      _ecf03_CodeErro(I);
      Result := False;
    end;
  end else Result := True;
  //
  //
end;

// -------------------------------- //
// Reducao Z                        //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf03_ReducaoZ(pP1: Boolean):Boolean;
begin
  if _ecf03_CodeErro(_ecf03.Daruma_FI_ReducaoZ('','')) = 0 then Result := True else Result := False;
end;

// -------------------------------- //
// Leitura X                        //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf03_LeituraX(pP1: Boolean):Boolean;
begin
  if _ecf03_CodeErro(_ecf03.Daruma_FI_LeituraX()) = 0 then
    Result := True
  else
    Result := False;
end;

// ---------------------------------------------- //
// Retorna se o horario de verão está selecionado //
// IF DARUMA FS 345                               //
// ---------------------------------------------- //
function _ecf03_RetornaVerao(pP1: Boolean):Boolean;
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
function _ecf03_LigaDesLigaVerao(pP1: Boolean):Boolean;
begin
  if _ecf03_codeErro(_ecf03.Daruma_FI_ProgramaHorarioVerao()) = 0 then
    Result := True
  else
    Result := False;
end;

// -------------------------------- //
// Retorna a versão do firmware     //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf03_VersodoFirmware(pP1: Boolean): String;
begin
  Result := '    ';
  _ecf03_codeErro(_ecf03.Daruma_FI_VersaoFirmware(Result));
end;

// -------------------------------- //
// Retorna o número de série        //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf03_NmerodeSrie(pP1: Boolean): String;
begin
  Result := Replicate(' ',20);
  _ecf03.Daruma_FIMFD_RetornaInformacao('78',Result);
end;

// -------------------------------- //
// Retorna o CGC e IE               //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf03_CGCIE(pP1: Boolean): String;
var
  sCgc, sIe : String;
begin
  //
  sCgc := Replicate(' ',18);
  sIe  := Replicate(' ',15);
  _ecf03_CodeErro(_ecf03.Daruma_FI_CGC_IE(sCgc, sIe));
  Result := 'CGC='+sCgc+' IE='+sIe;
  //
end;

// --------------------------------- //
// Retorna o número de cancelamentos //
// IF DARUMA FS 345                  //
// --------------------------------- //
function _ecf03_Cancelamentos(pP1: Boolean): String;
begin
  Result := Replicate(' ',14);
  _ecf03_CodeErro(_ecf03.Daruma_FI_Cancelamentos(Result)); // Ok
end;


// -------------------------------- //
// Retorna o valor de descontos     //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf03_Descontos(pP1: Boolean): String;
begin
  Result := Replicate(' ',14);
  _ecf03_CodeErro(_ecf03.Daruma_FI_DesContos(Result));
end;

// -------------------------------- //
// Retorna o contados sequencial    //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf03_ContadorSeqencial(pP1: Boolean): String;
begin
  Result := Replicate(' ',6);
  _ecf03_CodeErro(_ecf03.Daruma_FI_NumeroCupom(Result));
end;

// -------------------------------- //
// Retorna o número de operações    //
// não fiscais acumuladas           //
// IF DARUMA FS 345                 //
// -------------------------------- //
function _ecf03_Nmdeoperaesnofiscais(pP1: Boolean): String;
begin
  Result := Replicate(' ',6);
  _ecf03_CodeErro(_ecf03.Daruma_FI_NumeroOperacoesNaoFiscais(Result));
end;

function _ecf03_NmdeCuponscancelados(pP1: Boolean): String;
begin
  Result := Replicate(' ',4);
  _ecf03_CodeErro(_ecf03.Daruma_FI_NumeroCuponsCancelados(Result));
end;

function _ecf03_NmdeRedues(pP1: Boolean): String;
begin
  Result := Replicate(' ',4);
  _ecf03_CodeErro(_ecf03.Daruma_FI_NumeroReducoes(Result));
  Result := Strzero( StrToInt( Limpanumero('0'+Result))+1,6,0);
end;

function _ecf03_Nmdeintervenestcnicas(pP1: Boolean): String;
begin
  Result := Replicate(' ',4);
  _ecf03_CodeErro(_ecf03.Daruma_FI_NumeroIntervencoes(Result));
end;

function _ecf03_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
begin
  Result := Replicate(' ',4);
  _ecf03_CodeErro(_ecf03.Daruma_FI_NumeroIntervencoes(Result));
end;

function _ecf03_Clichdoproprietrio(pP1: Boolean): String;
begin
  SetLength (Result,400);
  _ecf03.Daruma_FI_ClicheProprietarioEx(Result);
end;

// ------------------------------------ //
// Importante retornar apenas 3 dígitos //
// Ex: 001                              //
// IF DARUMA FS 345                     //
// ------------------------------------ //
function _ecf03_NmdoCaixa(pP1: Boolean): String;
begin
  Result := Replicate(' ',4);
  _ecf03_CodeErro(_ecf03.Daruma_FI_NumeroCaixa(Result));
  Result := LimpaNumero(Copy(Result,2,3));
end;

function _ecf03_Nmdaloja(pP1: Boolean): String;
begin
  Result := Replicate(' ',4);
  _ecf03_CodeErro(_ecf03.Daruma_FI_NumeroLoja(Result));
end;

function _ecf03_Moeda(pP1: Boolean): String;
var
  sMoeda: string;
begin
  setlength(sMoeda,4);
  _ecf03.Daruma_FI_SimboloMoeda(sMoeda);
  Result := AllTrim(Copy(sMoeda,2,1));
end;

function _ecf03_Dataehoradaimpressora(pP1: Boolean): String;
var
  sData: string;
  sHora: string;
begin
  sData := Replicate(' ',6);
  sHora := Replicate(' ',6);
  _ecf03_CodeErro(_ecf03.Daruma_FI_DataHoraImpressora(sData,sHora));
  Result := sData + sHora;
end;

function _ecf03_Datadaultimareduo(pP1: Boolean): String;
begin
  // Result := Replicate(' ',6);
  setlength( Result, 6 );
  _ecf03_CodeErro(_ecf03.Daruma_FI_DataMovimento(Result));
end;

function _ecf03_Datadomovimento(pP1: Boolean): String;
begin
  // Result := Replicate(' ',6);
  setlength( Result, 6 );
  _ecf03_CodeErro(_ecf03.Daruma_FI_DataMovimento(Result));
end;

// Deve retornar uma String com:                                          //
// Os 2 primeiros dígitos são o número de aliquotas gravadas: Ex 16       //
// os póximos de 4 em 4 são as aliquotas Ex: 1800                         //
// Ex: 161800120005000000000000000000000000000000000000000000000000000000 //
function _ecf03_RetornaAliquotas(pP1: Boolean): String;
begin
  Result := Replicate('0',80);
  _ecf03_CodeErro(_ecf03.Daruma_FI_RetornoAliquotas(Result));
  Result := Copy('16'+LimpaNumero(Result)+Replicate('0',80),1,66);  
end;

function _ecf03_Vincula(pP1: String): Boolean;
begin
  Result := False;
end;


function _ecf03_FlagsDeISS(pP1: Boolean): String;
var
  sIndiceAliquotas: string;
  I : Integer;
begin
  //
  setlength( sIndiceAliquotas, 79 );
  _ecf03.Daruma_FI_VerificaAliquotasIss( sIndiceAliquotas );
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

function _ecf03_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
//var
// 2015-06-26 hModulo:THandle;
begin
  //
  _ecf03_CodeErro(_ecf03.Daruma_FI_FechaPortaSerial());
  // 2015-06-26 hModulo:=GetModuleHandle('Daruma32.dll');
  // 2015-06-26 FreeLibrary(hModulo);
  FreeLibrary(_ecf03.DLL);
  FreeAndNil(_ecf03);
  Result := True;
  //
end;

function _ecf03_MudaMoeda(pP1: String): Boolean;
begin
  _ecf03.Daruma_FI_AlteraSimboloMoeda('R');
  Result := True;
end;

function _ecf03_MostraDisplay(pP1: String): Boolean;
begin
  Result := True;
end;

function _ecf03_LeituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
begin
  //
  Screen.Cursor := crHourGlass; // Cursor de Aguardo
  //
  if Length(pP2) = 4 then
  begin
    _ecf03_CodeErro(_ecf03.Daruma_FI_LeituraMemoriaFiscalSerialReducao(pP2,pP3));
  end else
  begin
    _ecf03_CodeErro(_ecf03.Daruma_FI_LeituraMemoriaFiscalSerialData(pP2,pP3));
  end;
  //
  Screen.Cursor := crDefault; // Cursor normal
  //
  DeleteFile(pP1);
  ShowMessage('O seguinte arquivo será gravado: '+pP1);
  CopyFile(pChar('C:\RETORNO.TXT'),pChar(pP1),True);
  Result := True;
  //
end;

function _ecf03_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean;
var
  I,  iRetorno : Integer;
  sLinha : String;
begin
  //
  begin
    //
    iRetorno := 1;
    //
    if Form1.ibDataSet25DIFERENCA_.AsFloat > 0 then iRetorno := _ecf03.Daruma_FI_AbreComprovanteNaoFiscalVinculado(pchar(AllTrim(Form2.Label17.Caption)),pchar(''),pchar(''));
    if Form1.ibDataSet25PAGAR.AsFloat >      0 then iRetorno := _ecf03.Daruma_FI_AbreComprovanteNaoFiscalVinculado(pchar(AllTrim(Form2.Label8.Caption)) ,pchar(''),pchar(''));
    if Form1.ibDataSet25ACUMULADO1.AsFloat > 0 then iRetorno := _ecf03.Daruma_FI_AbreComprovanteNaoFiscalVinculado(pchar(AllTrim(Form2.Label9.Caption)) ,pchar(''),pchar(''));
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
          iRetorno := _ecf03.Daruma_FI_UsaComprovanteNaoFiscalVinculado(pChar(sLinha));
          sLinha:='';
        end;
     end;
    end;


{
    for JiI := 1 to 1 do
    begin
      //
      for I := 1 to 3 do if iRetorno = 1 then iRetorno := Daruma_FI_UsaComprovanteNaoFiscalVinculado('');
      J := 0;
      for I := 1 to Length(sP1) do
      begin
        J := J + 1;
        if J = 600 then
        begin
          Daruma_FI_UsaComprovanteNaoFiscalVinculado(Copy(sP1,I-J+1,J));
          J := 0;
        end;
      end;
      //
      if J > 0 then Daruma_FI_UsaComprovanteNaoFiscalVinculado(Copy(sP1,Length(sP1)-J+1,J));
      //
    end;
}
    //
    if iRetorno = 1 then iRetorno := _ecf03.Daruma_FI_FechaComprovanteNaoFiscalVinculado();
    if (iRetorno = 1) or (iRetorno = -27) then Result   := True else
    begin
      Result := False;
    end;
    //
  end;
  //
end;

function _ecf03_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
var
  iI, I, iRetorno : Integer;
  sLinha : String;
begin
  //
  if Pos('IDENTIFICAÇÃO DO PAF-ECF',sP1)<>0 then
  begin
    _ecf03.Daruma_FIMFD_AbreRelatorioGerencial(pchar('IDENT DO PAF'));
  end else
  begin
    if Pos('Período Solicitado: de',sP1)<>0 then
    begin
      _ecf03.Daruma_FIMFD_AbreRelatorioGerencial(pchar('MEIOS DE PAGTO'));
    end else
    begin
      if (Pos('Documento: ',sP1)<>0) or (Pos(TITULO_PARCELAS_CARNE_RESUMIDO, sP1) > 0) then  // Sandro Silva 2018-04-29  if Pos('Documento: ',sP1)<>0 then
      begin
        _ecf03.Daruma_FIMFD_AbreRelatorioGerencial(pchar('VENDA PRAZO'));
      end else
      begin
        if Pos('DAV EMITIDOS',sP1)<>0 then
        begin
          _ecf03.Daruma_FIMFD_AbreRelatorioGerencial(pchar('DAV Emitidos'));
        end else
        begin
          if Pos('AUXILIAR DE VENDA (DAV) - OR',sP1)<>0 then
          begin
            _ecf03.Daruma_FIMFD_AbreRelatorioGerencial(pchar('Orcamento'));
          end else
          begin
            if Pos('CONFERENCIA DE CONTA',sP1)<>0 then
            begin
              // 2016-02-04 _ecf03.Daruma_FIMFD_AbreRelatorioGerencial(pchar('CONF CONTA'));
              // 2016-02-04 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
              _ecf03.Daruma_FIMFD_AbreRelatorioGerencial(pchar('CONF CONTA CLI'));
            end else
            begin
              if Pos('TRANSFERENCIAS ENTRE CONTA',sP1)<>0 then
              begin
                //Sandro Silva 2016-02-11 _ecf03.Daruma_FIMFD_AbreRelatorioGerencial(pchar('TRANSF CONTA'));
                // 2016-02-11 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
               _ecf03.Daruma_FIMFD_AbreRelatorioGerencial(pchar('TRANSF CONT CLI'));
              end else
              begin
                // Sandro Silva 2016-02-04 POLIMIG  if (Pos('CONTAS DE CLIENTES ABERTAS',sP1)<>0) or (Pos('CONTAS DE CLIENTES OS ABERTAS',sP1)<>0) or (Pos('NENHUMA',sP1)<>0) then
                if (Pos('CONTAS DE CLIENTES ABERTAS',sP1)<>0)
                    or (Pos('CONTAS DE CLIENTES OS ABERTAS',sP1)<>0)
                    or ((Pos('NENHUMA',sP1)<>0) and (Pos('CONTA DE CLIENTE',sP1)<>0)) then
                begin
                  // Sandro Silva 2016-02-11 _ecf03.Daruma_FIMFD_AbreRelatorioGerencial(pchar('CONTAS ABERTAS'));
                  // 2016-02-11 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
                  _ecf03.Daruma_FIMFD_AbreRelatorioGerencial(pchar('CONT CLI ABERTA'));
                end else
                begin
                  if Pos('CONFERENCIA DE MESA',sP1)<>0 then
                  begin
                    _ecf03.Daruma_FIMFD_AbreRelatorioGerencial(pchar('CONF MESA')); // TEF
                  end else
                  begin
                    if Pos('TRANSFERENCIAS ENTRE MESA',sP1)<>0 then
                    begin
                      _ecf03.Daruma_FIMFD_AbreRelatorioGerencial(pchar('TRANSF MESA')); // TEF
                    end else
                    begin
                      // Sandro Silva 2016-02-04 POLIMIG  if Pos('MESAS ABERTAS',sP1)<>0 then
                      if (Pos('MESAS ABERTAS',sP1)<>0) or
                       (Pos('NENHUMA MESA',sP1)<>0) then
                      begin
                        _ecf03.Daruma_FIMFD_AbreRelatorioGerencial(pchar('MESAS ABERTAS')); // TEF
                      end else
                      begin
                        if Pos('Parametros de Configuracao',sP1)<>0 then
                        begin
                          _ecf03.Daruma_FIMFD_AbreRelatorioGerencial(pchar('PARAM CONFIG')); // TEF
                        end else
                        begin
                          _ecf03.Daruma_FIMFD_AbreRelatorioGerencial(pchar('CARTAO TEF')); // TEF
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
            iRetorno := _ecf03.Daruma_FI_RelatorioGerencial(pChar(sLinha));
            sLinha:='';
          end;
       end;
      end;
      //
      for I := 1 to 5 do if iRetorno = 1 then iRetorno := _ecf03.Daruma_FI_RelatorioGerencial(' ');
      if iRetorno = 1 then sleep(4000); // Da um tempo
      //
    end;
    //
    if iRetorno = 1 then iRetorno := _ecf03.Daruma_FI_FechaRelatorioGerencial();
    if iRetorno = 1 then Result   := True else Result := False;
    if iRetorno = -27 then Result := True;
    //
  end;
  //
end;

function _ecf03_FechaCupom2(sP1: Boolean): Boolean;
begin
  //
  // Daruma_FI_FechaComprovanteNaoFiscalVinculado();
  // Daruma_FI_FechaRelatorioGerencial();
  //
  //if Daruma_FI_Status_ComprovanteNaoFiscalVinculado = 1 or
  //Daruma_FI_Status_ComprovanteNaoFiscalVinculado = 1
  _ecf03.Daruma_TEF_FechaRelatorio();
  //
  Result := True;
end;

//                                      //
// Imprime cheque - Parametro é o valor //
//                                      //
function _ecf03_ImprimeCheque(rP1: Real; sP2: String): Boolean;
begin
  Result := False;
end;

function _ecf03_MapaResumo(sP1: Boolean): Boolean;
begin
  Result := True;
end;

function _ecf03_GrandeTotal(sP1: Boolean): String;
begin
  Result := Replicate('0',18);
  _ecf03_CodeErro(_ecf03.Daruma_FI_GrandeTotal(Result));
end;

function _ecf03_TotalizadoresDasAliquotas(sP1: Boolean): String;
begin
  //
  // Teste voltar 200
  //
  Result := Replicate('0',445);
  _ecf03.Daruma_FI_VerificaTotalizadoresParciais(Result);
  Result := Copy(LimpaNumero(Result),1,400);
  //
  // ShowMessage(Result);
  //
end;


function _ecf03_CupomAberto(sP1: Boolean): boolean;
var
  I : Integer;
begin
  _ecf03.Daruma_FI_FlagsFiscais(I);
  if I >= 128 then I := I - 128;
  if I >= 32  then I := I - 32;
  if I >= 8   then I := I - 8;
  if I >= 4   then I := I - 4;
  if I >= 2   then I := I - 2;
  //
  // ShowMessage('CupomAberto ='+IntToStr(I));
  //
  if I = 1 then Result := True else Result := False;
  //
end;

function _ecf03_FaltaPagamento(sP1: Boolean): boolean;
var
  I : Integer;
begin
  _ecf03.Daruma_FI_FlagsFiscais(I);
  if I >= 128 then I := I - 128;
  if I >= 32  then I := I - 32;
  if I >= 8   then I := I - 8;
  if I >= 4   then I := I - 4;
  //
  //ShowMessage('Falta pagamento ='+IntToStr(I));
  //
  if I >= 2 then Result := True else Result := False;
  /////////////////////////////////////////////////////
  // Retorna true quando o cupom já foi finalizado e //
  // só esta faltando as formas de pagamento         //
  /////////////////////////////////////////////////////
end;

function _ecf03_ProgramaAplicativo(sP1: Boolean): boolean;
begin
//  Daruma_Registry_AplMensagem1(pchar('MD5: '+Form1.sMD5DaLista ));
//  Daruma_Registry_AplMensagem2(PChar('--------------------------------'));
  _ecf03.Daruma_Registry_AplMensagem1(pchar('   '));
  _ecf03.Daruma_Registry_AplMensagem2(pchar('   '));

  Result := True;
end;

//
// PAF
//

function _ecf03_Marca(sP1: Boolean): String;
begin
  Result := REplicate(' ',20);
  _ecf03.Daruma_FIMFD_RetornaInformacao('80',Result);
  //
  // Ok
  //
end;

function _ecf03_Modelo(sP1: Boolean): String;
begin
  Result := REplicate(' ',20);
  _ecf03.Daruma_FIMFD_RetornaInformacao('81',Result);
  //
  // Ok
  //
end;

function _ecf03_Tipodaimpressora(pP1: Boolean): String;
begin
  Result := REplicate(' ',7);
  _ecf03.Daruma_FIMFD_RetornaInformacao('79',Result);
  //
  // Ok
  //
end;

function _ecf03_VersaoSB(pP1: Boolean): String; //
begin
  Result := REplicate(' ',6);
  _ecf03.Daruma_FIMFD_RetornaInformacao('83',Result);
  //
  // Ok
  //
end;

function _ecf03_HoraIntalacaoSB(pP1: Boolean): String; //
begin
  Result := REplicate(' ',14);
  _ecf03.Daruma_FIMFD_RetornaInformacao('85',Result);
  Result := Copy(Result,9,6);
  //
  // Ok
  //
end;

function _ecf03_DataIntalacaoSB(pP1: Boolean): String; //
begin
  Result := REplicate(' ',14);
  _ecf03.Daruma_FIMFD_RetornaInformacao('85',Result);
  Result := Copy(Result,1,8);
  //
  // Ok
  //
end;

function _ecf03_DataUltimaReducao: String;
var
  sData: string;
  sHora: string;
begin
  Result := '00/00/2000';
  sData := Replicate(' ',6);
  sHora := Replicate(' ',6);

  try
    _ecf03.Daruma_FI_DataHoraReducao(sData, sHora);
    if (Trim(sData) <> '') and (Trim(sHora) <> '') then
    begin
      // Retorno da DLL: 09062016154545
      try
        //Result := FormatDateTime('dd/mm/yyyy', StrToDate(Copy(sData, 1, 2) + '/' + Copy(sData, 3, 2) + '/' + Copy(sData, 5, 4))) + ' ' + Copy(sHora, 1, 2) + ':' + Copy(sHora, 3, 2) + ':' + Copy(sHora, 5, 2);
        Result := FormatDateTime('dd/mm/yyyy', StrToDate(Copy(sData, 1, 2) + '/' + Copy(sData, 3, 2) + '/' + Copy(sData, 5, 4)))
      except
        Result := '00/00/2000';
      end;
    end;
  except

  end;
end;

function _ecf03_DadosDaUltimaReducao(pP1: Boolean): String; //
var
  sRetorno : String;
begin
  //
  sRetorno := Replicate(' ',631);
  _ecf03.Daruma_FI_DadosUltimaReducao(sRetorno);
  //
  // 1,2     Modo de redução
  // 4,18    GT
  // 23,14   Cancelamentos
  // 38,14   Descontos
  // 53,64   Tributos
  // 118,224 Acumulador das aliquotas
  //
  // 342,14  Totalizador de isenção de ICMS
  // 356,14  Totalizador de não incidência de ICMS
  // 370,14  Totalizador de substituição tributária de ICMS
  //
  // 385,14  Sangria
  // 400,14  Suprimento
  // 415,126 Acumulador não fiscal
  // 542,36  Contador especifico de rel não fiscal
  // 579,6   COO
  // 586,6   CNF
  // 593,2   Número de aliquotas cadastradas
  // 596,6   Data
  // 603,14  Acréscimos
  // 618,13  Acréscimos financeiros
  //
  Result :=  Copy(sRetorno,596,6)+ //   1,  6 Data
             Copy(sRetorno,579,6)+ //   7,  6 COO
             Copy(sRetorno,4,18 )+ //  13, 18 GT
     StrZero(StrToInt(_ecf03_NmdeRedues(True))-1,4,0) + //  31,  4 CRZ
      Copy(Form1.sAliquotas,3,64)+ //  35, 64 Aliquotas
          Copy(sRetorno, 118,224)+ //  99,224 Totalizadores das aliquotas
            _ecf03_Nmdeintervenestcnicas(True)+ // 323,  4 Contador de reinício de operação
            //
            Copy(sRetorno, 23, 14)+ // 327, 14 Totalizador de cancelamentos em ICMS
            Copy(sRetorno, 38, 14)+ // 341, 14 Totalizador de descontos em ICMS
            //
            Copy(sRetorno, 342, 14)+ // 355, 14 Totalizador de isenção de ICMS
            Copy(sRetorno, 356, 14)+ // 369, 14 Totalizador de não incidência de ICMS
            Copy(sRetorno, 370, 14)+ // 383, 14 Totalizador de substituição tributária de ICMS
            '';
  //
  // Ok testado
  //
end;

//
// Retorna o Código do Modelo do ECF Conf Tabéla Nacional de Identificação do ECF
//
function _ecf03_CodigoModeloEcf(pP1: Boolean): String; //
begin
  Result := Replicate(' ',6);
  _ecf03.Daruma_FIMFD_CodigoModeloFiscal(Result);
end;

{ TDaruma32 }

procedure TDaruma32.CarregaDLL;
begin
  try
    //ShowMessage(DLLName);  // 2015-06-16

    DLL     := LoadLibrary(PChar(DARUMA_DLLNAME_03)); //carregando dll
    //DLL := LoadLibrary(Pchar('C:\Program Files (x86)\Sweda Informática Ltda\Ativação SAT Sweda\SATDLL.dll')); //carregando dll
    if DLL = 0 then
      raise Exception.Create('Não foi possível carregar a biblioteca ' + DARUMA_DLLNAME_03);

    //importando métodos dinamicamente
    //Import(@_AtivarSat, 'AtivarSAT');

    Import(@_Daruma_Registry_AplMensagem1, 'Daruma_Registry_AplMensagem1');
    Import(@_Daruma_Registry_AplMensagem2, 'Daruma_Registry_AplMensagem2');
    Import(@_Daruma_Registry_MFD_LeituraMFCompleta, 'Daruma_Registry_MFD_LeituraMFCompleta');
    Import(@_Daruma_Registry_Porta, 'Daruma_Registry_Porta');
    Import(@_Daruma_Registry_Path, 'Daruma_Registry_Path');
    Import(@_Daruma_Registry_Status, 'Daruma_Registry_Status');
    Import(@_Daruma_Registry_StatusFuncao, 'Daruma_Registry_StatusFuncao');
    Import(@_Daruma_Registry_Retorno, 'Daruma_Registry_Retorno');
    Import(@_Daruma_Registry_ControlePorta, 'Daruma_Registry_ControlePorta');
    Import(@_Daruma_Registry_ModoGaveta, 'Daruma_Registry_ModoGaveta');
    Import(@_Daruma_Registry_Log, 'Daruma_Registry_Log');
    Import(@_Daruma_Registry_NomeLog, 'Daruma_Registry_NomeLog');
    Import(@_Daruma_Registry_Separador, 'Daruma_Registry_Separador');
    Import(@_Daruma_Registry_SeparaMsgPromo, 'Daruma_Registry_SeparaMsgPromo');
    Import(@_Daruma_Registry_Emulador, 'Daruma_Registry_Emulador');
    Import(@_Daruma_Registry_ConfigRede, 'Daruma_Registry_ConfigRede');
    Import(@_Daruma_Registry_VendeItemUmaLinha, 'Daruma_Registry_VendeItemUmaLinha');

    // Funções de Inicialização
    Import(@_Daruma_FI_AlteraSimboloMoeda, 'Daruma_FI_AlteraSimboloMoeda');
    Import(@_Daruma_FI_ProgramaAliquota, 'Daruma_FI_ProgramaAliquota');
    Import(@_Daruma_FI_ProgramaHorarioVerao, 'Daruma_FI_ProgramaHorarioVerao');
    Import(@_Daruma_FI_NomeiaDepartamento, 'Daruma_FI_NomeiaDepartamento');
    Import(@_Daruma_FI_NomeiaTotalizadorNaoSujeitoIcms, 'Daruma_FI_NomeiaTotalizadorNaoSujeitoIcms');
    Import(@_Daruma_FI_ProgramaArredondamento, 'Daruma_FI_ProgramaArredondamento');
    Import(@_Daruma_FI_ProgramaTruncamento, 'Daruma_FI_ProgramaTruncamento');
    Import(@_Daruma_FI_LinhasEntreCupons, 'Daruma_FI_LinhasEntreCupons');
    Import(@_Daruma_FI_EspacoEntreLinhas, 'Daruma_FI_EspacoEntreLinhas');
    Import(@_Daruma_FI_ForcaImpactoAgulhas, 'Daruma_FI_ForcaImpactoAgulhas');
    Import(@_Daruma_FI_ProgramaFormasPagamento, 'Daruma_FI_ProgramaFormasPagamento');

    // Funções do Cupom Fiscal
    Import(@_Daruma_FI_AbreCupom, 'Daruma_FI_AbreCupom');
    Import(@_Daruma_FI_VendeItem, 'Daruma_FI_VendeItem');
    Import(@_Daruma_FI_VendeItemTresDecimais, 'Daruma_FI_VendeItemTresDecimais');
    Import(@_Daruma_FI_VendeItemDepartamento, 'Daruma_FI_VendeItemDepartamento');
    Import(@_Daruma_FI_VendeItem1Lin13Dig, 'Daruma_FI_VendeItem1Lin13Dig');
    Import(@_Daruma_FI_CancelaItemAnterior, 'Daruma_FI_CancelaItemAnterior');
    Import(@_Daruma_FI_CancelaItemGenerico, 'Daruma_FI_CancelaItemGenerico');
    Import(@_Daruma_FI_CancelaCupom, 'Daruma_FI_CancelaCupom');
    Import(@_Daruma_FI_FechaCupomResumido, 'Daruma_FI_FechaCupomResumido');
    Import(@_Daruma_FI_FechaCupom, 'Daruma_FI_FechaCupom');
    Import(@_Daruma_FI_ResetaImpressora, 'Daruma_FI_ResetaImpressora');
    Import(@_Daruma_FI_IniciaFechamentoCupom, 'Daruma_FI_IniciaFechamentoCupom');
    Import(@_Daruma_FI_EfetuaFormaPagamento, 'Daruma_FI_EfetuaFormaPagamento');
    Import(@_Daruma_FI_EfetuaFormaPagamentoDescricaoForma, 'Daruma_FI_EfetuaFormaPagamentoDescricaoForma');
    Import(@_Daruma_FI_TerminaFechamentoCupom, 'Daruma_FI_TerminaFechamentoCupom');
    Import(@_Daruma_FI_IdentificaConsumidor, 'Daruma_FI_IdentificaConsumidor');
    Import(@_Daruma_FI_EstornoFormasPagamento, 'Daruma_FI_EstornoFormasPagamento');
    Import(@_Daruma_FI_UsaUnidadeMedida, 'Daruma_FI_UsaUnidadeMedida');
    Import(@_Daruma_FI_AumentaDescricaoItem, 'Daruma_FI_AumentaDescricaoItem');

    // Funções dos Relatórios Fiscais
    Import(@_Daruma_FI_LeituraX, 'Daruma_FI_LeituraX');
    Import(@_Daruma_FI_ReducaoZ, 'Daruma_FI_ReducaoZ');
    Import(@_Daruma_FI_RelatorioGerencial, 'Daruma_FI_RelatorioGerencial');
    Import(@_Daruma_FI_FechaRelatorioGerencial, 'Daruma_FI_FechaRelatorioGerencial');
    Import(@_Daruma_FI_LeituraMemoriaFiscalData, 'Daruma_FI_LeituraMemoriaFiscalData');
    Import(@_Daruma_FI_LeituraMemoriaFiscalReducao, 'Daruma_FI_LeituraMemoriaFiscalReducao');
    Import(@_Daruma_FI_LeituraMemoriaFiscalSerialData, 'Daruma_FI_LeituraMemoriaFiscalSerialData');
    Import(@_Daruma_FI_LeituraMemoriaFiscalSerialReducao, 'Daruma_FI_LeituraMemoriaFiscalSerialReducao');
    Import(@_Daruma_FIMFD_DownloadDaMFD, 'Daruma_FIMFD_DownloadDaMFD');

    // Funções das Operações Não Fiscais
    Import(@_Daruma_FI_RecebimentoNaoFiscal, 'Daruma_FI_RecebimentoNaoFiscal');
    Import(@_Daruma_FI_AbreComprovanteNaoFiscalVinculado, 'Daruma_FI_AbreComprovanteNaoFiscalVinculado');
    Import(@_Daruma_FI_UsaComprovanteNaoFiscalVinculado, 'Daruma_FI_UsaComprovanteNaoFiscalVinculado');
    Import(@_Daruma_FI_FechaComprovanteNaoFiscalVinculado, 'Daruma_FI_FechaComprovanteNaoFiscalVinculado');
    Import(@_Daruma_FI_Sangria, 'Daruma_FI_Sangria');
    Import(@_Daruma_FI_Suprimento, 'Daruma_FI_Suprimento');

    // Funções de Informações da Impressora
    Import(@_Daruma_FI_StatusCupomFiscal, 'Daruma_FI_StatusCupomFiscal');
    Import(@_Daruma_FI_StatusComprovanteNaoFiscalVinculado, 'Daruma_FI_StatusComprovanteNaoFiscalVinculado');
    Import(@_Daruma_FI_StatusRelatorioGerencial, 'Daruma_FI_StatusRelatorioGerencial');
    Import(@_Daruma_FI_NumeroSerie, 'Daruma_FI_NumeroSerie');
    Import(@_Daruma_FI_SubTotal, 'Daruma_FI_SubTotal');
    Import(@_Daruma_FI_NumeroCupom, 'Daruma_FI_NumeroCupom');
    Import(@_Daruma_FI_RetornaGNF, 'Daruma_FI_RetornaGNF');
    Import(@_Daruma_FI_LeituraXSerial, 'Daruma_FI_LeituraXSerial');
    Import(@_Daruma_FI_VersaoFirmware, 'Daruma_FI_VersaoFirmware');
    Import(@_Daruma_FI_CGC_IE, 'Daruma_FI_CGC_IE');
    Import(@_Daruma_FI_GrandeTotal, 'Daruma_FI_GrandeTotal');
    Import(@_Daruma_FI_VendaBruta, 'Daruma_FI_VendaBruta');
    Import(@_Daruma_FI_Cancelamentos, 'Daruma_FI_Cancelamentos');
    Import(@_Daruma_FI_Descontos, 'Daruma_FI_Descontos');
    Import(@_Daruma_FI_NumeroOperacoesNaoFiscais, 'Daruma_FI_NumeroOperacoesNaoFiscais');
    Import(@_Daruma_FI_NumeroCuponsCancelados, 'Daruma_FI_NumeroCuponsCancelados');
    Import(@_Daruma_FI_NumeroIntervencoes, 'Daruma_FI_NumeroIntervencoes');
    Import(@_Daruma_FI_NumeroReducoes, 'Daruma_FI_NumeroReducoes');
    Import(@_Daruma_FI_NumeroSubstituicoesProprietario, 'Daruma_FI_NumeroSubstituicoesProprietario');
    Import(@_Daruma_FI_UltimoItemVendido, 'Daruma_FI_UltimoItemVendido');
    Import(@_Daruma_FI_ClicheProprietarioEx, 'Daruma_FI_ClicheProprietarioEx');
    Import(@_Daruma_FI_NumeroCaixa, 'Daruma_FI_NumeroCaixa');
    Import(@_Daruma_FI_NumeroLoja, 'Daruma_FI_NumeroLoja');
    Import(@_Daruma_FI_SimboloMoeda, 'Daruma_FI_SimboloMoeda');
    Import(@_Daruma_FI_MinutosLigada, 'Daruma_FI_MinutosLigada');
    Import(@_Daruma_FI_MinutosImprimindo, 'Daruma_FI_MinutosImprimindo');
    Import(@_Daruma_FI_VerificaModoOperacao, 'Daruma_FI_VerificaModoOperacao');
    Import(@_Daruma_FI_VerificaEpromConectada, 'Daruma_FI_VerificaEpromConectada');
    Import(@_Daruma_FI_FlagsFiscais, 'Daruma_FI_FlagsFiscais');
    Import(@_Daruma_FI_ValorPagoUltimoCupom, 'Daruma_FI_ValorPagoUltimoCupom');
    Import(@_Daruma_FI_DataHoraImpressora, 'Daruma_FI_DataHoraImpressora');
    Import(@_Daruma_FI_ContadoresTotalizadoresNaoFiscais, 'Daruma_FI_ContadoresTotalizadoresNaoFiscais');
    Import(@_Daruma_FI_VerificaTotalizadoresNaoFiscais, 'Daruma_FI_VerificaTotalizadoresNaoFiscais');
    Import(@_Daruma_FI_DataHoraReducao, 'Daruma_FI_DataHoraReducao');
    Import(@_Daruma_FI_DataMovimento, 'Daruma_FI_DataMovimento');
    Import(@_Daruma_FI_VerificaTruncamento, 'Daruma_FI_VerificaTruncamento');
    Import(@_Daruma_FI_Acrescimos, 'Daruma_FI_Acrescimos');
    Import(@_Daruma_FI_ContadorBilhetePassagem, 'Daruma_FI_ContadorBilhetePassagem');
    Import(@_Daruma_FI_VerificaAliquotasIss, 'Daruma_FI_VerificaAliquotasIss');
    Import(@_Daruma_FI_VerificaFormasPagamento, 'Daruma_FI_VerificaFormasPagamento');
    Import(@_Daruma_FI_VerificaRecebimentoNaoFiscal, 'Daruma_FI_VerificaRecebimentoNaoFiscal');
    Import(@_Daruma_FI_VerificaDepartamentos, 'Daruma_FI_VerificaDepartamentos');
    Import(@_Daruma_FI_VerificaTipoImpressora, 'Daruma_FI_VerificaTipoImpressora');
    Import(@_Daruma_FI_VerificaTotalizadoresParciais, 'Daruma_FI_VerificaTotalizadoresParciais');
    Import(@_Daruma_FI_RetornoAliquotas, 'Daruma_FI_RetornoAliquotas');
    Import(@_Daruma_FI_VerificaEstadoImpressora, 'Daruma_FI_VerificaEstadoImpressora');
    Import(@_Daruma_FI_DadosUltimaReducao, 'Daruma_FI_DadosUltimaReducao');
    Import(@_Daruma_FI_MonitoramentoPapel, 'Daruma_FI_MonitoramentoPapel');
    Import(@_Daruma_FI_VerificaIndiceAliquotasIss, 'Daruma_FI_VerificaIndiceAliquotasIss');
    Import(@_Daruma_FI_ValorFormaPagamento, 'Daruma_FI_ValorFormaPagamento');
    Import(@_Daruma_FI_ValorTotalizadorNaoFiscal, 'Daruma_FI_ValorTotalizadorNaoFiscal');
    //  Import(@_Daruma_FI_VerificaModeloECF( Modelo: String , '');
    Import(@_Daruma_FI_VerificaModeloECF, 'Daruma_FI_VerificaModeloECF');
    // Funções de Autenticação e Gaveta de Dinheiro
    Import(@_Daruma_FI_Autenticacao, 'Daruma_FI_Autenticacao');
    Import(@_Daruma_FI_AutenticacaoStr, 'Daruma_FI_AutenticacaoStr');
    Import(@_Daruma_FI_VerificaDocAutenticacao, 'Daruma_FI_VerificaDocAutenticacao');
    Import(@_Daruma_FI_AcionaGaveta, 'Daruma_FI_AcionaGaveta');
    Import(@_Daruma_FI_VerificaEstadoGaveta, 'Daruma_FI_VerificaEstadoGaveta');
    // Outras Funções
    Import(@_Daruma_FI_AbrePortaSerial, 'Daruma_FI_AbrePortaSerial');
    Import(@_Daruma_FI_RetornoImpressora, 'Daruma_FI_RetornoImpressora');
    Import(@_Daruma_FI_FechaPortaSerial, 'Daruma_FI_FechaPortaSerial');
    Import(@_Daruma_FI_MapaResumo, 'Daruma_FI_MapaResumo');
    Import(@_Daruma_FI_AberturaDoDia, 'Daruma_FI_AberturaDoDia');
    Import(@_Daruma_FI_FechamentoDoDia, 'Daruma_FI_FechamentoDoDia');
    Import(@_Daruma_FI_ImprimeConfiguracoesImpressora, 'Daruma_FI_ImprimeConfiguracoesImpressora');
    Import(@_Daruma_FI_ImprimeDepartamentos, 'Daruma_FI_ImprimeDepartamentos');
    Import(@_Daruma_FI_RelatorioTipo60Analitico, 'Daruma_FI_RelatorioTipo60Analitico');
    Import(@_Daruma_FI_RelatorioTipo60Mestre, 'Daruma_FI_RelatorioTipo60Mestre');
    Import(@_Daruma_FI_VerificaImpressoraLigada, 'Daruma_FI_VerificaImpressoraLigada');
    // 2015-08-31 Import(@_Daruma_FI_ImprimeConfiguracoes, 'Daruma_FI_ImprimeConfiguracoes'); // 2015-08-20
    //funcoes de TEF
    Import(@_Daruma_TEF_ImprimirResposta, 'Daruma_TEF_ImprimirResposta');
    Import(@_Daruma_TEF_FechaRelatorio, 'Daruma_TEF_FechaRelatorio');
    //
    //  Import(@_Daruma_FI_RetornaErroExtendido(sParam1: String, ''); external 'Daruma32.dll' Name 'Daruma_FI_RetornaErroExtendido';
    Import(@_Daruma_FI_RetornaErroExtendido, 'Daruma_FI_RetornaErroExtendido');
    Import(@_Daruma_FI_VerificaEstadoGavetaStr, 'Daruma_FI_VerificaEstadoGavetaStr');
    Import(@_Daruma_FI_FlagsFiscaisStr, 'Daruma_FI_FlagsFiscaisStr');
    Import(@_Daruma_FIMFD_RetornaInformacao, 'Daruma_FIMFD_RetornaInformacao');
    Import(@_Daruma_FIMFD_CodigoModeloFiscal, 'Daruma_FIMFD_CodigoModeloFiscal');
    //
    Import(@_Daruma_RFD_GerarArquivo, 'Daruma_RFD_GerarArquivo');
    //
    Import(@_Daruma_FIMFD_ProgramaRelatoriosGerenciais, 'Daruma_FIMFD_ProgramaRelatoriosGerenciais');
    Import(@_Daruma_FIMFD_AbreRelatorioGerencial, 'Daruma_FIMFD_AbreRelatorioGerencial');
    Import(@_Daruma_FIMFD_GerarAtoCotepePafData, 'Daruma_FIMFD_GerarAtoCotepePafData');
    Import(@_Daruma_FIMFD_GerarAtoCotepePafCOO, 'Daruma_FIMFD_GerarAtoCotepePafCOO');

  except
    on E: Exception do
    begin
      ShowMessage('Erro ao carregar comandos Daruma' + #13 + E.Message);
    end;
  end;
end;

constructor TDaruma32.Create(AOwner: TComponent);
begin
  inherited;
  CarregaDLL;
end;

function TDaruma32.Daruma_FIMFD_AbreRelatorioGerencial(
  NomeRelatorio: String): Integer;
begin
  Result := _Daruma_FIMFD_AbreRelatorioGerencial(NomeRelatorio);
end;

function TDaruma32.Daruma_FIMFD_CodigoModeloFiscal(Valor: String): Integer;
begin
  Result := _Daruma_FIMFD_CodigoModeloFiscal(Valor);
end;

function TDaruma32.Daruma_FIMFD_DownloadDaMFD(CoInicial,
  CoFinal: String): Integer;
begin
  Result := _Daruma_FIMFD_DownloadDaMFD(CoInicial, CoFinal);
end;

function TDaruma32.Daruma_FIMFD_GerarAtoCotepePafCOO(COOIni,
  COOFim: string): Integer;
begin
  Result := _Daruma_FIMFD_GerarAtoCotepePafCOO(COOIni, COOFim);
end;

function TDaruma32.Daruma_FIMFD_GerarAtoCotepePafData(DataInicial,
  DataFinal: String): Integer;
begin
  Result := _Daruma_FIMFD_GerarAtoCotepePafData(DataInicial, DataFinal);
end;

function TDaruma32.Daruma_FIMFD_ProgramaRelatoriosGerenciais(
  NomeRelatorio: String): Integer;
begin
  Result := _Daruma_FIMFD_ProgramaRelatoriosGerenciais(NomeRelatorio);
end;

function TDaruma32.Daruma_FIMFD_RetornaInformacao(Indice,
  Valor: String): Integer;
begin
  Result := _Daruma_FIMFD_RetornaInformacao(Indice, Valor);
end;

function TDaruma32.Daruma_FI_AberturaDoDia(ValorCompra,
  FormaPagamento: string): Integer;
begin
  Result := _Daruma_FI_AberturaDoDia(ValorCompra, FormaPagamento);
end;

function TDaruma32.Daruma_FI_AbreComprovanteNaoFiscalVinculado(
  FormaPagamento, Valor, NumeroCupom: String): Integer;
begin
  Result := _Daruma_FI_AbreComprovanteNaoFiscalVinculado(FormaPagamento, Valor, NumeroCupom);
end;

function TDaruma32.Daruma_FI_AbreCupom(CGC_CPF: String): Integer;
begin
  Result := _Daruma_FI_AbreCupom(CGC_CPF);
end;

function TDaruma32.Daruma_FI_AbrePortaSerial: Integer;
begin
  Result := _Daruma_FI_AbrePortaSerial;
end;

function TDaruma32.Daruma_FI_AcionaGaveta: Integer;
begin
  Result := _Daruma_FI_AcionaGaveta;
end;

function TDaruma32.Daruma_FI_Acrescimos(ValorAcrescimos: String): Integer;
begin
  Result := _Daruma_FI_Acrescimos(ValorAcrescimos);
end;

function TDaruma32.Daruma_FI_AlteraSimboloMoeda(
  SimboloMoeda: String): Integer;
begin
  Result := _Daruma_FI_AlteraSimboloMoeda(SimboloMoeda);
end;

function TDaruma32.Daruma_FI_AumentaDescricaoItem(
  Descricao: String): Integer;
begin
  Result := _Daruma_FI_AumentaDescricaoItem(Descricao);
end;

function TDaruma32.Daruma_FI_Autenticacao: Integer;
begin
  Result := _Daruma_FI_Autenticacao;
end;

function TDaruma32.Daruma_FI_AutenticacaoStr(str: string): Integer;
begin
  Result := _Daruma_FI_AutenticacaoStr(str);
end;

function TDaruma32.Daruma_FI_CancelaCupom: Integer;
begin
  Result := _Daruma_FI_CancelaCupom;
end;

function TDaruma32.Daruma_FI_CancelaItemAnterior: Integer;
begin
  Result := _Daruma_FI_CancelaItemAnterior;
end;

function TDaruma32.Daruma_FI_CancelaItemGenerico(
  NumeroItem: String): Integer;
begin
  Result := _Daruma_FI_CancelaItemGenerico(NumeroItem);
end;

function TDaruma32.Daruma_FI_Cancelamentos(
  ValorCancelamentos: String): Integer;
begin
  Result := _Daruma_FI_Cancelamentos(ValorCancelamentos);
end;

function TDaruma32.Daruma_FI_CGC_IE(CGC, IE: String): Integer;
begin
  Result := _Daruma_FI_CGC_IE(CGC, IE);
end;

function TDaruma32.Daruma_FI_ClicheProprietarioEx(ClicheEx: String): Integer;
begin
  Result := _Daruma_FI_ClicheProprietarioEx(ClicheEx);
end;

function TDaruma32.Daruma_FI_ContadorBilhetePassagem(
  ContadorPassagem: String): Integer;
begin
  Result := _Daruma_FI_ContadorBilhetePassagem(ContadorPassagem);
end;

function TDaruma32.Daruma_FI_ContadoresTotalizadoresNaoFiscais(
  Contadores: String): Integer;
begin
  Result := _Daruma_FI_ContadoresTotalizadoresNaoFiscais(Contadores);
end;

function TDaruma32.Daruma_FI_DadosUltimaReducao(
  DadosReducao: String): Integer;
begin
  Result := _Daruma_FI_DadosUltimaReducao(DadosReducao);
end;

function TDaruma32.Daruma_FI_DataHoraImpressora(Data, Hora: String): Integer;
begin
  Result := _Daruma_FI_DataHoraImpressora(Data, Hora);
end;

function TDaruma32.Daruma_FI_DataHoraReducao(Data, Hora: String): Integer;
begin
  Result := _Daruma_FI_DataHoraReducao(Data, Hora);
end;

function TDaruma32.Daruma_FI_DataMovimento(Data: String): Integer;
begin
  Result := _Daruma_FI_DataMovimento(Data);
end;

function TDaruma32.Daruma_FI_Descontos(ValorDescontos: String): Integer;
begin
  Result := _Daruma_FI_Descontos( ValorDescontos);
end;

function TDaruma32.Daruma_FI_EfetuaFormaPagamento(FormaPagamento,
  ValorFormaPagamento: String): Integer;
begin
  Result := _Daruma_FI_EfetuaFormaPagamento(FormaPagamento, ValorFormaPagamento);
end;

function TDaruma32.Daruma_FI_EfetuaFormaPagamentoDescricaoForma(
  FormaPagamento, ValorFormaPagamento,
  DescricaoFormaPagto: string): integer;
begin
  Result := _Daruma_FI_EfetuaFormaPagamentoDescricaoForma(FormaPagamento, ValorFormaPagamento, DescricaoFormaPagto);
end;

function TDaruma32.Daruma_FI_EspacoEntreLinhas(Dots: Integer): Integer;
begin
  Result := _Daruma_FI_EspacoEntreLinhas(Dots);
end;

function TDaruma32.Daruma_FI_EstornoFormasPagamento(FormaOrigem,
  FormaDestino, Valor: String): Integer;
begin
  Result := _Daruma_FI_EstornoFormasPagamento(FormaOrigem, FormaDestino, Valor);
end;

function TDaruma32.Daruma_FI_FechaComprovanteNaoFiscalVinculado: Integer;
begin
  Result := _Daruma_FI_FechaComprovanteNaoFiscalVinculado;
end;

function TDaruma32.Daruma_FI_FechaCupom(FormaPagamento, AcrescimoDesconto,
  TipoAcrescimoDesconto, ValorAcrescimoDesconto, ValorPago,
  Mensagem: String): Integer;
begin
  Result := _Daruma_FI_FechaCupom(FormaPagamento, AcrescimoDesconto, TipoAcrescimoDesconto, ValorAcrescimoDesconto, ValorPago, Mensagem);
end;

function TDaruma32.Daruma_FI_FechaCupomResumido(FormaPagamento,
  Mensagem: String): Integer;
begin
  Result := _Daruma_FI_FechaCupomResumido(FormaPagamento, Mensagem);
end;

function TDaruma32.Daruma_FI_FechamentoDoDia: Integer;
begin
  Result := _Daruma_FI_FechamentoDoDia;
end;

function TDaruma32.Daruma_FI_FechaPortaSerial: Integer;
begin
  Result := _Daruma_FI_FechaPortaSerial;
end;

function TDaruma32.Daruma_FI_FechaRelatorioGerencial: Integer;
begin
  Result := _Daruma_FI_FechaRelatorioGerencial;
end;

function TDaruma32.Daruma_FI_FlagsFiscais(var Flag: Integer): Integer;
begin
  Result := _Daruma_FI_FlagsFiscais(Flag);
end;

function TDaruma32.Daruma_FI_FlagsFiscaisStr(sParam1: String): Integer;
begin
  Result := _Daruma_FI_FlagsFiscaisStr(sParam1);
end;

function TDaruma32.Daruma_FI_ForcaImpactoAgulhas(
  ForcaImpacto: Integer): Integer;
begin
  Result := _Daruma_FI_ForcaImpactoAgulhas(ForcaImpacto);
end;

function TDaruma32.Daruma_FI_GrandeTotal(GrandeTotal: String): Integer;
begin
  Result := _Daruma_FI_GrandeTotal(GrandeTotal);
end;

function TDaruma32.Daruma_FI_IdentificaConsumidor(Nome, Endereco,
  Doc: String): Integer;
begin
  Result := _Daruma_FI_IdentificaConsumidor(Nome, Endereco, Doc);
end;

function TDaruma32.Daruma_FI_ImprimeConfiguracoes: Integer;
begin
  //2015-08-31 Result := _Daruma_FI_ImprimeConfiguracoes;
  Result := 1;
end;

function TDaruma32.Daruma_FI_ImprimeConfiguracoesImpressora: Integer;
begin
  Result := _Daruma_FI_ImprimeConfiguracoesImpressora;
end;

function TDaruma32.Daruma_FI_ImprimeDepartamentos: Integer;
begin
  Result := _Daruma_FI_ImprimeDepartamentos;
end;

function TDaruma32.Daruma_FI_IniciaFechamentoCupom(AcrescimoDesconto,
  TipoAcrescimoDesconto, ValorAcrescimoDesconto: String): Integer;
begin
  Result := _Daruma_FI_IniciaFechamentoCupom(AcrescimoDesconto, TipoAcrescimoDesconto, ValorAcrescimoDesconto);
end;

function TDaruma32.Daruma_FI_LeituraMemoriaFiscalData(DataInicial,
  DataFinal: String): Integer;
begin
  Result := _Daruma_FI_LeituraMemoriaFiscalData(DataInicial, DataFinal);
end;

function TDaruma32.Daruma_FI_LeituraMemoriaFiscalReducao(ReducaoInicial,
  ReducaoFinal: String): Integer;
begin
  Result := _Daruma_FI_LeituraMemoriaFiscalReducao(ReducaoInicial, ReducaoFinal);
end;

function TDaruma32.Daruma_FI_LeituraMemoriaFiscalSerialData(DataInicial,
  DataFinal: String): Integer;
begin
  Result := _Daruma_FI_LeituraMemoriaFiscalSerialData(DataInicial, DataFinal);
end;

function TDaruma32.Daruma_FI_LeituraMemoriaFiscalSerialReducao(
  ReducaoInicial, ReducaoFinal: String): Integer;
begin
  Result := _Daruma_FI_LeituraMemoriaFiscalSerialReducao(ReducaoInicial, ReducaoFinal);
end;

function TDaruma32.Daruma_FI_LeituraX: Integer;
begin
  Result := _Daruma_FI_LeituraX;
end;

function TDaruma32.Daruma_FI_LeituraXSerial: Integer;
begin
  Result := _Daruma_FI_LeituraXSerial;
end;

function TDaruma32.Daruma_FI_LinhasEntreCupons(Linhas: Integer): Integer;
begin
  Result := _Daruma_FI_LinhasEntreCupons(Linhas);
end;

function TDaruma32.Daruma_FI_MapaResumo: Integer;
begin
  Result := _Daruma_FI_MapaResumo;
end;

function TDaruma32.Daruma_FI_MinutosImprimindo(Minutos: String): Integer;
begin
  Result := _Daruma_FI_MinutosImprimindo(Minutos);
end;

function TDaruma32.Daruma_FI_MinutosLigada(Minutos: String): Integer;
begin
  Result := _Daruma_FI_MinutosLigada(Minutos);
end;

function TDaruma32.Daruma_FI_MonitoramentoPapel(
  var Linhas: Integer): Integer;
begin
  Result := _Daruma_FI_MonitoramentoPapel(Linhas);
end;

function TDaruma32.Daruma_FI_NomeiaDepartamento(Indice: Integer;
  Departamento: String): Integer;
begin
  Result := _Daruma_FI_NomeiaDepartamento(Indice, Departamento);
end;

function TDaruma32.Daruma_FI_NomeiaTotalizadorNaoSujeitoIcms(Indice: Integer;
  Totalizador: String): Integer;
begin
  Result := _Daruma_FI_NomeiaTotalizadorNaoSujeitoIcms(Indice, Totalizador);
end;

function TDaruma32.Daruma_FI_NumeroCaixa(NumeroCaixa: String): Integer;
begin
  Result := _Daruma_FI_NumeroCaixa(NumeroCaixa);
end;

function TDaruma32.Daruma_FI_NumeroCupom(NumeroCupom: String): Integer;
begin
  Result := _Daruma_FI_NumeroCupom(NumeroCupom);
end;

function TDaruma32.Daruma_FI_NumeroCuponsCancelados(
  NumeroCancelamentos: String): Integer;
begin
  Result := _Daruma_FI_NumeroCuponsCancelados(NumeroCancelamentos);
end;

function TDaruma32.Daruma_FI_NumeroIntervencoes(
  NumeroIntervencoes: String): Integer;
begin
  Result := _Daruma_FI_NumeroIntervencoes(NumeroIntervencoes);
end;

function TDaruma32.Daruma_FI_NumeroLoja(NumeroLoja: String): Integer;
begin
  Result := _Daruma_FI_NumeroLoja(NumeroLoja);
end;

function TDaruma32.Daruma_FI_NumeroOperacoesNaoFiscais(
  NumeroOperacoes: String): Integer;
begin
  Result := _Daruma_FI_NumeroOperacoesNaoFiscais(NumeroOperacoes);
end;

function TDaruma32.Daruma_FI_NumeroReducoes(NumeroReducoes: String): Integer;
begin
  Result := _Daruma_FI_NumeroReducoes(NumeroReducoes);
end;

function TDaruma32.Daruma_FI_NumeroSerie(NumeroSerie: String): Integer;
begin
  Result := _Daruma_FI_NumeroSerie(NumeroSerie);
end;

function TDaruma32.Daruma_FI_NumeroSubstituicoesProprietario(
  NumeroSubstituicoes: String): Integer;
begin
  Result := _Daruma_FI_NumeroSubstituicoesProprietario(NumeroSubstituicoes);
end;

function TDaruma32.Daruma_FI_ProgramaAliquota(Aliquota: String;
  ICMS_ISS: Integer): Integer;
begin
  Result := _Daruma_FI_ProgramaAliquota( Aliquota, ICMS_ISS);
end;

function TDaruma32.Daruma_FI_ProgramaArredondamento: Integer;
begin
  Result := _Daruma_FI_ProgramaArredondamento;
end;

function TDaruma32.Daruma_FI_ProgramaFormasPagamento(
  Formas: String): Integer;
begin
  Result := _Daruma_FI_ProgramaFormasPagamento(Formas);
end;

function TDaruma32.Daruma_FI_ProgramaHorarioVerao: Integer;
begin
  Result := _Daruma_FI_ProgramaHorarioVerao;
end;

function TDaruma32.Daruma_FI_ProgramaTruncamento: Integer;
begin
  Result := _Daruma_FI_ProgramaTruncamento;
end;

function TDaruma32.Daruma_FI_RecebimentoNaoFiscal(IndiceTotalizador, Valor,
  FormaPagamento: String): Integer;
begin
  Result := _Daruma_FI_RecebimentoNaoFiscal(IndiceTotalizador, Valor, FormaPagamento);
end;

function TDaruma32.Daruma_FI_ReducaoZ(Data, Hora: String): Integer;
begin
  Result := _Daruma_FI_ReducaoZ(Data, Hora);
end;

function TDaruma32.Daruma_FI_RelatorioGerencial(Texto: String): Integer;
begin
  Result := _Daruma_FI_RelatorioGerencial(Texto);
end;

function TDaruma32.Daruma_FI_RelatorioTipo60Analitico: Integer;
begin
  Result := _Daruma_FI_RelatorioTipo60Analitico;
end;

function TDaruma32.Daruma_FI_RelatorioTipo60Mestre: Integer;
begin
  Result := _Daruma_FI_RelatorioTipo60Mestre;
end;

function TDaruma32.Daruma_FI_ResetaImpressora: Integer;
begin
  Result := _Daruma_FI_ResetaImpressora;
end;

function TDaruma32.Daruma_FI_RetornaErroExtendido(sParam1: String): Integer;
begin
  Result := _Daruma_FI_RetornaErroExtendido(sParam1);
end;

function TDaruma32.Daruma_FI_RetornaGNF(GNF: String): Integer;
begin
  Result := _Daruma_FI_RetornaGNF(GNF);
end;

function TDaruma32.Daruma_FI_RetornoAliquotas(Aliquotas: String): Integer;
begin
  Result := _Daruma_FI_RetornoAliquotas(Aliquotas);
end;

function TDaruma32.Daruma_FI_RetornoImpressora(var ACK, ST1,
  ST2: Integer): Integer;
begin
  Result := _Daruma_FI_RetornoImpressora(ACK, ST1, ST2);
end;

function TDaruma32.Daruma_FI_Sangria(Valor: String): Integer;
begin
  Result := _Daruma_FI_Sangria(Valor);
end;

function TDaruma32.Daruma_FI_SimboloMoeda(SimboloMoeda: String): Integer;
begin
  Result := _Daruma_FI_SimboloMoeda(SimboloMoeda);
end;

function TDaruma32.Daruma_FI_StatusComprovanteNaoFiscalVinculado(
  StatusRel: String): Integer;
begin
  Result := _Daruma_FI_StatusComprovanteNaoFiscalVinculado(StatusRel);
end;

function TDaruma32.Daruma_FI_StatusCupomFiscal(StatusRel: String): Integer;
begin
  Result := _Daruma_FI_StatusCupomFiscal(StatusRel);
end;

function TDaruma32.Daruma_FI_StatusRelatorioGerencial(
  StatusRel: String): Integer;
begin
  Result := _Daruma_FI_StatusRelatorioGerencial(StatusRel);
end;

function TDaruma32.Daruma_FI_SubTotal(SubTotal: String): Integer;
begin
  Result := _Daruma_FI_SubTotal(SubTotal);
end;

function TDaruma32.Daruma_FI_Suprimento(Valor,
  FormaPagamento: String): Integer;
begin
  Result := _Daruma_FI_Suprimento(Valor, FormaPagamento);
end;

function TDaruma32.Daruma_FI_TerminaFechamentoCupom(
  Mensagem: String): Integer;
begin
  Result := _Daruma_FI_TerminaFechamentoCupom(Mensagem);
end;

function TDaruma32.Daruma_FI_UltimoItemVendido(NumeroItem: String): Integer;
begin
  Result := _Daruma_FI_UltimoItemVendido(NumeroItem);
end;

function TDaruma32.Daruma_FI_UsaComprovanteNaoFiscalVinculado(
  Texto: String): Integer;
begin
  Result := _Daruma_FI_UsaComprovanteNaoFiscalVinculado(Texto);
end;

function TDaruma32.Daruma_FI_UsaUnidadeMedida(
  UnidadeMedida: String): Integer;
begin
  Result := _Daruma_FI_UsaUnidadeMedida(UnidadeMedida);
end;

function TDaruma32.Daruma_FI_ValorFormaPagamento(FormaPagamento,
  Valor: String): Integer;
begin
  Result := _Daruma_FI_ValorFormaPagamento(FormaPagamento, Valor);
end;

function TDaruma32.Daruma_FI_ValorPagoUltimoCupom(
  ValorCupom: String): Integer;
begin
  Result := _Daruma_FI_ValorPagoUltimoCupom(ValorCupom);
end;

function TDaruma32.Daruma_FI_ValorTotalizadorNaoFiscal(Totalizador,
  Valor: String): Integer;
begin
  Result := _Daruma_FI_ValorTotalizadorNaoFiscal(Totalizador, Valor);
end;

function TDaruma32.Daruma_FI_VendaBruta(VendaBruta: String): Integer;
begin
  Result := _Daruma_FI_VendaBruta(VendaBruta);
end;

function TDaruma32.Daruma_FI_VendeItem(Codigo, Descricao, Aliquota,
  TipoQuantidade, Quantidade: String; CasasDecimais: Integer;
  ValorUnitario, TipoDesconto, Desconto: String): Integer;
begin
  Result := _Daruma_FI_VendeItem(Codigo, Descricao, Aliquota, TipoQuantidade, Quantidade, CasasDecimais, ValorUnitario, TipoDesconto, Desconto);
end;

function TDaruma32.Daruma_FI_VendeItem1Lin13Dig(Codigo, Descricao, Aliquota,
  Quantidade, ValorUnitario, Acrescimo_Desconto,
  Percentual: String): Integer;
begin
  Result := _Daruma_FI_VendeItem1Lin13Dig(Codigo, Descricao, Aliquota, Quantidade, ValorUnitario, Acrescimo_Desconto, Percentual);
end;

function TDaruma32.Daruma_FI_VendeItemDepartamento(Codigo, Descricao,
  Aliquota, ValorUnitario, Quantidade, Acrescimo, Desconto,
  IndiceDepartamento, UnidadeMedida: String): Integer;
begin
  Result := _Daruma_FI_VendeItemDepartamento(Codigo, Descricao, Aliquota, ValorUnitario, Quantidade, Acrescimo, Desconto, IndiceDepartamento, UnidadeMedida);
end;

function TDaruma32.Daruma_FI_VendeItemTresDecimais(Codigo, Descricao,
  Aliquota, Quantidade, ValorUnitario, TipoDesconto,
  Desconto: String): Integer;
begin
  Result := _Daruma_FI_VendeItemTresDecimais(Codigo, Descricao, Aliquota, Quantidade, ValorUnitario, TipoDesconto, Desconto);
end;

function TDaruma32.Daruma_FI_VerificaAliquotasIss(Flag: String): Integer;
begin
  Result := _Daruma_FI_VerificaAliquotasIss(Flag);
end;

function TDaruma32.Daruma_FI_VerificaDepartamentos(
  Departamentos: String): Integer;
begin
  Result := _Daruma_FI_VerificaDepartamentos(Departamentos);
end;

function TDaruma32.Daruma_FI_VerificaDocAutenticacao: Integer;
begin
  Result := _Daruma_FI_VerificaDocAutenticacao;
end;

function TDaruma32.Daruma_FI_VerificaEpromConectada(Flag: String): Integer;
begin
  Result := _Daruma_FI_VerificaEpromConectada(Flag);
end;

function TDaruma32.Daruma_FI_VerificaEstadoGaveta(
  var EstadoGaveta: Integer): Integer;
begin
  Result := _Daruma_FI_VerificaEstadoGaveta(EstadoGaveta); 
end;

function TDaruma32.Daruma_FI_VerificaEstadoGavetaStr(
  sParam1: String): Integer;
begin
  Result := _Daruma_FI_VerificaEstadoGavetaStr(sParam1); 
end;

function TDaruma32.Daruma_FI_VerificaEstadoImpressora(var ACK, ST1,
  ST2: Integer): Integer;
begin
  Result := _Daruma_FI_VerificaEstadoImpressora(ACK, ST1, ST2);
end;

function TDaruma32.Daruma_FI_VerificaFormasPagamento(
  Formas: String): Integer;
begin
  Result := _Daruma_FI_VerificaFormasPagamento(Formas);
end;

function TDaruma32.Daruma_FI_VerificaImpressoraLigada: Integer;
begin
  Result := _Daruma_FI_VerificaImpressoraLigada;
end;

function TDaruma32.Daruma_FI_VerificaIndiceAliquotasIss(
  Flag: String): Integer;
begin
  Result := _Daruma_FI_VerificaIndiceAliquotasIss(Flag);
end;

function TDaruma32.Daruma_FI_VerificaModeloECF: Integer;
begin
  Result := _Daruma_FI_VerificaModeloECF;
end;

function TDaruma32.Daruma_FI_VerificaModoOperacao(Modo: string): Integer;
begin
  Result := _Daruma_FI_VerificaModoOperacao(Modo);
end;

function TDaruma32.Daruma_FI_VerificaRecebimentoNaoFiscal(
  Recebimentos: String): Integer;
begin
  Result := _Daruma_FI_VerificaRecebimentoNaoFiscal(Recebimentos);
end;

function TDaruma32.Daruma_FI_VerificaTipoImpressora(
  var TipoImpressora: Integer): Integer;
begin
  Result := _Daruma_FI_VerificaTipoImpressora(TipoImpressora);
end;

function TDaruma32.Daruma_FI_VerificaTotalizadoresNaoFiscais(
  Totalizadores: String): Integer;
begin
  Result := _Daruma_FI_VerificaTotalizadoresNaoFiscais(Totalizadores);
end;

function TDaruma32.Daruma_FI_VerificaTotalizadoresParciais(
  Totalizadores: String): Integer;
begin
  Result := _Daruma_FI_VerificaTotalizadoresParciais(Totalizadores);
end;

function TDaruma32.Daruma_FI_VerificaTruncamento(Flag: string): Integer;
begin
  Result := _Daruma_FI_VerificaTruncamento(Flag);
end;

function TDaruma32.Daruma_FI_VersaoFirmware(VersaoFirmware: String): Integer;
begin
  Result := _Daruma_FI_VersaoFirmware(VersaoFirmware);
end;

function TDaruma32.Daruma_Registry_AplMensagem1(AplMsg1: String): Integer;
begin
  Result := _Daruma_Registry_AplMensagem1(AplMsg1);
end;

function TDaruma32.Daruma_Registry_AplMensagem2(AplMsg1: String): Integer;
begin
  Result := _Daruma_Registry_AplMensagem2(AplMsg1);
end;

function TDaruma32.Daruma_Registry_ConfigRede(ConfigRede: String): Integer;
begin
  Result := _Daruma_Registry_ConfigRede(ConfigRede);
end;

function TDaruma32.Daruma_Registry_ControlePorta(
  ControlePorta: String): Integer;
begin
  Result := _Daruma_Registry_ControlePorta(ControlePorta);
end;

function TDaruma32.Daruma_Registry_Emulador(Emulador: String): Integer;
begin
  Result := _Daruma_Registry_Emulador(Emulador);
end;

function TDaruma32.Daruma_Registry_Log(Log: String): Integer;
begin
  Result := _Daruma_Registry_Log(Log);
end;

function TDaruma32.Daruma_Registry_MFD_LeituraMFCompleta(
  Valor: String): Integer;
begin
  Result := _Daruma_Registry_MFD_LeituraMFCompleta(Valor);
end;

function TDaruma32.Daruma_Registry_ModoGaveta(ModoGaveta: String): Integer;
begin
  Result := _Daruma_Registry_ModoGaveta(ModoGaveta);
end;

function TDaruma32.Daruma_Registry_NomeLog(NomeLog: String): Integer;
begin
  Result := _Daruma_Registry_NomeLog(NomeLog);
end;

function TDaruma32.Daruma_Registry_Path(Path: String): Integer;
begin
  Result := _Daruma_Registry_Path(Path);
end;

function TDaruma32.Daruma_Registry_Porta(Porta: String): Integer;
begin
  Result := _Daruma_Registry_Porta(Porta);
end;

function TDaruma32.Daruma_Registry_Retorno(Retorno: String): Integer;
begin
  Result := _Daruma_Registry_Retorno(Retorno);
end;

function TDaruma32.Daruma_Registry_Separador(Separador: String): Integer;
begin
  Result := _Daruma_Registry_Separador(Separador);
end;

function TDaruma32.Daruma_Registry_SeparaMsgPromo(
  SeparaMsgPromo: String): Integer;
begin
  Result := _Daruma_Registry_SeparaMsgPromo(SeparaMsgPromo);
end;

function TDaruma32.Daruma_Registry_Status(Status: String): Integer;
begin
  Result := _Daruma_Registry_Status(Status);
end;

function TDaruma32.Daruma_Registry_StatusFuncao(
  StatusFuncao: String): Integer;
begin
  Result := _Daruma_Registry_StatusFuncao(StatusFuncao);
end;

function TDaruma32.Daruma_Registry_VendeItemUmaLinha(
  ConfigRede: String): Integer;
begin
  Result := _Daruma_Registry_VendeItemUmaLinha(ConfigRede);
end;

function TDaruma32.Daruma_RFD_GerarArquivo(DataInicial,
  DataFinal: String): Integer;
begin
  Result := _Daruma_RFD_GerarArquivo(DataInicial, DataFinal);
end;

function TDaruma32.Daruma_TEF_FechaRelatorio: Integer;
begin
  Result := _Daruma_TEF_FechaRelatorio;
end;

function TDaruma32.Daruma_TEF_ImprimirResposta(Arquivo, FormaPagamento,
  Travar: string): Integer;
begin
  Result := _Daruma_TEF_ImprimirResposta(Arquivo, FormaPagamento, Travar);
end;

destructor TDaruma32.Destroy;
begin
  FinalizaDLL;
  inherited;
end;

procedure TDaruma32.FinalizaDLL;
begin
  _Daruma_Registry_AplMensagem1 := nil;
  _Daruma_Registry_AplMensagem2 := nil;
  _Daruma_Registry_MFD_LeituraMFCompleta := nil;
  _Daruma_Registry_Porta := nil;
  _Daruma_Registry_Path := nil;
  _Daruma_Registry_Status := nil;
  _Daruma_Registry_StatusFuncao := nil;
  _Daruma_Registry_Retorno := nil;
  _Daruma_Registry_ControlePorta := nil;
  _Daruma_Registry_ModoGaveta := nil;
  _Daruma_Registry_Log := nil;
  _Daruma_Registry_NomeLog := nil;
  _Daruma_Registry_Separador := nil;
  _Daruma_Registry_SeparaMsgPromo := nil;
  _Daruma_Registry_Emulador := nil;
  _Daruma_Registry_ConfigRede := nil;
  _Daruma_Registry_VendeItemUmaLinha := nil;

    // Funções de Inicialização
  _Daruma_FI_AlteraSimboloMoeda := nil;
  _Daruma_FI_ProgramaAliquota := nil;
  _Daruma_FI_ProgramaHorarioVerao := nil;
  _Daruma_FI_NomeiaDepartamento := nil;
  _Daruma_FI_NomeiaTotalizadorNaoSujeitoIcms := nil;
  _Daruma_FI_ProgramaArredondamento := nil;
  _Daruma_FI_ProgramaTruncamento := nil;
  _Daruma_FI_LinhasEntreCupons := nil;
  _Daruma_FI_EspacoEntreLinhas := nil;
  _Daruma_FI_ForcaImpactoAgulhas := nil;
  _Daruma_FI_ProgramaFormasPagamento := nil;

    // Funções do Cupom Fiscal
  _Daruma_FI_AbreCupom := nil;
  _Daruma_FI_VendeItem := nil;
  _Daruma_FI_VendeItemTresDecimais := nil;
  _Daruma_FI_VendeItemDepartamento := nil;
  _Daruma_FI_VendeItem1Lin13Dig := nil;
  _Daruma_FI_CancelaItemAnterior := nil;
  _Daruma_FI_CancelaItemGenerico := nil;
  _Daruma_FI_CancelaCupom := nil;
  _Daruma_FI_FechaCupomResumido := nil;
  _Daruma_FI_FechaCupom := nil;
  _Daruma_FI_ResetaImpressora := nil;
  _Daruma_FI_IniciaFechamentoCupom := nil;
  _Daruma_FI_EfetuaFormaPagamento := nil;
  _Daruma_FI_EfetuaFormaPagamentoDescricaoForma := nil;
  _Daruma_FI_TerminaFechamentoCupom := nil;
  _Daruma_FI_IdentificaConsumidor := nil;
  _Daruma_FI_EstornoFormasPagamento := nil;
  _Daruma_FI_UsaUnidadeMedida := nil;
  _Daruma_FI_AumentaDescricaoItem := nil;

    // Funções dos Relatórios Fiscais
  _Daruma_FI_LeituraX := nil;
  _Daruma_FI_ReducaoZ := nil;
  _Daruma_FI_RelatorioGerencial := nil;
  _Daruma_FI_FechaRelatorioGerencial := nil;
  _Daruma_FI_LeituraMemoriaFiscalData := nil;
  _Daruma_FI_LeituraMemoriaFiscalReducao := nil;
  _Daruma_FI_LeituraMemoriaFiscalSerialData := nil;
  _Daruma_FI_LeituraMemoriaFiscalSerialReducao := nil;
  _Daruma_FIMFD_DownloadDaMFD := nil;

    // Funções das Operações Não Fiscais
  _Daruma_FI_RecebimentoNaoFiscal := nil;
  _Daruma_FI_AbreComprovanteNaoFiscalVinculado := nil;
  _Daruma_FI_UsaComprovanteNaoFiscalVinculado := nil;
  _Daruma_FI_FechaComprovanteNaoFiscalVinculado := nil;
  _Daruma_FI_Sangria := nil;
  _Daruma_FI_Suprimento := nil;

    // Funções de Informações da Impressora
  _Daruma_FI_StatusCupomFiscal := nil;
  _Daruma_FI_StatusComprovanteNaoFiscalVinculado := nil;
  _Daruma_FI_StatusRelatorioGerencial := nil;
  _Daruma_FI_NumeroSerie := nil;
  _Daruma_FI_SubTotal := nil;
  _Daruma_FI_NumeroCupom := nil;
  _Daruma_FI_RetornaGNF := nil;
  _Daruma_FI_LeituraXSerial := nil;
  _Daruma_FI_VersaoFirmware := nil;
  _Daruma_FI_CGC_IE := nil;
  _Daruma_FI_GrandeTotal := nil;
  _Daruma_FI_VendaBruta := nil;
  _Daruma_FI_Cancelamentos := nil;
  _Daruma_FI_Descontos := nil;
  _Daruma_FI_NumeroOperacoesNaoFiscais := nil;
  _Daruma_FI_NumeroCuponsCancelados := nil;
  _Daruma_FI_NumeroIntervencoes := nil;
  _Daruma_FI_NumeroReducoes := nil;
  _Daruma_FI_NumeroSubstituicoesProprietario := nil;
  _Daruma_FI_UltimoItemVendido := nil;
  _Daruma_FI_ClicheProprietarioEx := nil;
  _Daruma_FI_NumeroCaixa := nil;
  _Daruma_FI_NumeroLoja := nil;
  _Daruma_FI_SimboloMoeda := nil;
  _Daruma_FI_MinutosLigada := nil;
  _Daruma_FI_MinutosImprimindo := nil;
  _Daruma_FI_VerificaModoOperacao := nil;
  _Daruma_FI_VerificaEpromConectada := nil;
  _Daruma_FI_FlagsFiscais := nil;
  _Daruma_FI_ValorPagoUltimoCupom := nil;
  _Daruma_FI_DataHoraImpressora := nil;
  _Daruma_FI_ContadoresTotalizadoresNaoFiscais := nil;
  _Daruma_FI_VerificaTotalizadoresNaoFiscais := nil;
  _Daruma_FI_DataHoraReducao := nil;
  _Daruma_FI_DataMovimento := nil;
  _Daruma_FI_VerificaTruncamento := nil;
  _Daruma_FI_Acrescimos := nil;
  _Daruma_FI_ContadorBilhetePassagem := nil;
  _Daruma_FI_VerificaAliquotasIss := nil;
  _Daruma_FI_VerificaFormasPagamento := nil;
  _Daruma_FI_VerificaRecebimentoNaoFiscal := nil;
  _Daruma_FI_VerificaDepartamentos := nil;
  _Daruma_FI_VerificaTipoImpressora := nil;
  _Daruma_FI_VerificaTotalizadoresParciais := nil;
  _Daruma_FI_RetornoAliquotas := nil;
  _Daruma_FI_VerificaEstadoImpressora := nil;
  _Daruma_FI_DadosUltimaReducao := nil;
  _Daruma_FI_MonitoramentoPapel := nil;
  _Daruma_FI_VerificaIndiceAliquotasIss := nil;
  _Daruma_FI_ValorFormaPagamento := nil;
  _Daruma_FI_ValorTotalizadorNaoFiscal := nil;
    //_Daruma_FI_VerificaModeloECF := nil;
  _Daruma_FI_VerificaModeloECF := nil;
    // Funções de Autenticação e Gaveta de Dinheiro
  _Daruma_FI_Autenticacao  := nil;
  _Daruma_FI_AutenticacaoStr := nil;
  _Daruma_FI_VerificaDocAutenticacao := nil;
  _Daruma_FI_AcionaGaveta := nil;
  _Daruma_FI_VerificaEstadoGaveta := nil;
    // Outras Funções
  _Daruma_FI_AbrePortaSerial := nil;
  _Daruma_FI_RetornoImpressora := nil;
  _Daruma_FI_FechaPortaSerial := nil;
  _Daruma_FI_MapaResumo := nil;
  _Daruma_FI_AberturaDoDia := nil;
  _Daruma_FI_FechamentoDoDia := nil;
  _Daruma_FI_ImprimeConfiguracoesImpressora := nil;
  _Daruma_FI_ImprimeDepartamentos := nil;
  _Daruma_FI_RelatorioTipo60Analitico := nil;
  _Daruma_FI_RelatorioTipo60Mestre := nil;
  _Daruma_FI_VerificaImpressoraLigada := nil;
  //2015-08-31_Daruma_FI_ImprimeConfiguracoes := nil;
    //funcoes de TEF
  _Daruma_TEF_ImprimirResposta := nil;
  _Daruma_TEF_FechaRelatorio := nil;
    //
    //_Daruma_FI_RetornaErroExtendido := nil;
  _Daruma_FI_RetornaErroExtendido := nil;
  _Daruma_FI_VerificaEstadoGavetaStr := nil;
  _Daruma_FI_FlagsFiscaisStr := nil;
  _Daruma_FIMFD_RetornaInformacao := nil;
  _Daruma_FIMFD_CodigoModeloFiscal := nil;
    //
  _Daruma_RFD_GerarArquivo := nil;
    //
  _Daruma_FIMFD_ProgramaRelatoriosGerenciais := nil;
  _Daruma_FIMFD_AbreRelatorioGerencial := nil;
  _Daruma_FIMFD_GerarAtoCotepePafData := nil;
  _Daruma_FIMFD_GerarAtoCotepePafCOO := nil;

end;

procedure TDaruma32.Import(var Proc: pointer; Name: Pchar);
begin
  if not Assigned(Proc) then
  begin
    Proc := GetProcAddress(DLL, Pchar(Name));
    if Proc = nil then
      raise Exception.Create('Não foi possível carregar a função ' + Name + ' da biblioteca ' + DARUMA_DLLNAME_03);
  end;
end;

end.
