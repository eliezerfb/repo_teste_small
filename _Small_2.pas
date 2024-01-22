(***************************************************************************
{
Alterações
Sandro Silva 2016-02-04
- Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
}

//
// BEMATECH
//

//
// suporte@bematech.com.br
// Telefone....: 0800 644 2362
// CNPJ Small..: 07.426.598/0001-24
//

// 41-3351-2760 / 41-9921-9932 André Munhoz
// 41-3351-2631
// andre.munhoz@bematech.com.br

Chave de intervenção da MP 4200 TH FI II

Chave de MIL
320c1ed9d9e5699ef63ad68ea3a4e0ab7794dbbfdda73a2b11b3f2c24e0bfeb2b569412d14d000516219f0c9b90a9818a4950d2f202fadc53c69e9b6f6b00ea08a7c2ed4f11035a6025e311e004ee3c6956d35feb8e5594c931760e49b66d5ac2657b328397e4dd234131050e87baa160d567c6e919647035a38f2cfa0a94d7d

Link para downloads no site da bematech:
http://bematechpartners.com.br/wp01/?page_id=1011
**************************************************************)

unit _Small_2;

interface

uses
  //////////////////////////////////////////////////////////////////////////////////////////
  // Importante:                                                                          //
  // Para trabalhar com a impressora fiscal YANCO é                                       //
  // necessário alterar, no arquivo BemaFI32.ini, a chave "ModeloImp" para YANCO.         //
  //////////////////////////////////////////////////////////////////////////////////////////
  Windows, Messages, SmallFunc_xe, Fiscal, SysUtils,Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Mask, Grids, DBGrids, DB, DBCtrls, SMALL_DBEdit, IniFiles, Unit2,
  Unit7, unit22, MD5
  , ufuncoesfrentepaf
  , ubematechbemaficlass

  ;
  //--------------------------------------------------------------------------//
  // Módulo para Impressora Bematech                                          //
  // Utiliza a nova dll da Bematech                                           //
  // 13/02/2003                                                               //
  // Alterado p/versão 2006 07/01/2005 - RONEI                                //
  //--------------------------------------------------------------------------//
  // Declaração das Funções da nova DLL BEMAFI32.DLL                          //
  // 0800 -  644 2362                                                         //
  //--------------------------------------------------------------------------//
  function Bematech_FI_ProgramaIdAplicativoMFD(IDAplicativo: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_AlteraSimboloMoeda(SimboloMoeda: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ProgramaAliquota(Aliquota: AnsiString; ICMS_ISS: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ProgramaHorarioVerao: Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_NomeiaDepartamento(Indice: Integer; Departamento: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_NomeiaTotalizadorNaoSujeitoIcms(Indice: Integer; Totalizador: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ProgramaArredondamento:Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ProgramaTruncamento:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_ProgramaTruncamento';
  function Bematech_FI_LinhasEntreCupons(Linhas: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_EspacoEntreLinhas(Dots: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ForcaImpactoAgulhas(ForcaImpacto: Integer): Integer; StdCall; External 'BEMAFI32.DLL';

  // Funções do Cupom Fiscal /////////////////////////////////////////////////////

  function Bematech_FI_AbreCupom(CGC_CPF: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VendeItem(Codigo: AnsiString; Descricao: AnsiString; Aliquota: AnsiString; TipoQuantidade: AnsiString; Quantidade: AnsiString; CasasDecimais: Integer; ValorUnitario: AnsiString; TipoDesconto: AnsiString; Desconto: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VendeItemDepartamento(Codigo: AnsiString; Descricao: AnsiString; Aliquota: AnsiString; ValorUnitario: AnsiString; Quantidade: AnsiString; Acrescimo: AnsiString; Desconto: AnsiString; IndiceDepartamento: AnsiString; UnidadeMedida: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_CancelaItemAnterior: Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_CancelaItemGenerico(NumeroItem: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_CancelaCupom: Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_EstornoNaoFiscalVinculadoPosteriorMFD(FormaPagamento: AnsiString; Valor: AnsiString; COOCupom: AnsiString; COOCDC: AnsiString; CPF: AnsiString; Nome: AnsiString; Endereco: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL'; //2015-10-22 Cancelar vinculados
  function Bematech_FI_EstornoNaoFiscalVinculadoMFD(CPF: AnsiString; Nome: AnsiString; Endereco: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL'; //2017-0725 Cancelar vinculados


  function Bematech_FI_FechaCupomResumido(FormaPagamento: AnsiString; Mensagem: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_FechaCupom(FormaPagamento: AnsiString; AcrescimoDesconto: AnsiString; TipoAcrescimoDesconto: AnsiString; ValorAcrescimoDesconto: AnsiString; ValorPago: AnsiString; Mensagem: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ResetaImpressora:Integer; StdCall; External 'BEMAFI32.DLL';

  function Bematech_FI_IniciaFechamentoCupom(AcrescimoDesconto: AnsiString; TipoAcrescimoDesconto: AnsiString; ValorAcrescimoDesconto: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';

  function Bematech_FI_EfetuaFormaPagamento(FormaPagamento: AnsiString; ValorFormaPagamento: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_EfetuaFormaPagamentoDescricaoForma(FormaPagamento: AnsiString; ValorFormaPagamento: AnsiString; DescricaoFormaPagto: AnsiString ): integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_TerminaFechamentoCupom(Mensagem: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_EstornoFormasPagamento(FormaOrigem: AnsiString; FormaDestino: AnsiString; Valor: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_UsaUnidadeMedida(UnidadeMedida: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_AumentaDescricaoItem(Descricao: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';

  // Funções dos Relatórios Fiscais //////////////////////////////////////////////

  function Bematech_FI_LeituraX:Integer; StdCall; External 'BEMAFI32.DLL' ;
  function Bematech_FI_ReducaoZ(Data: AnsiString; Hora: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_RelatorioGerencial(Texto: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_UsaRelatorioGerencialMFD(Texto: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_FechaRelatorioGerencial:Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_LeituraMemoriaFiscalData(DataInicial: AnsiString; DataFinal: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_LeituraMemoriaFiscalReducao(ReducaoInicial: AnsiString; ReducaoFinal: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_LeituraMemoriaFiscalSerialData(DataInicial: AnsiString; DataFinal: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_LeituraMemoriaFiscalSerialReducao(ReducaoInicial: AnsiString; ReducaoFinal: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_DownloadMFD(sArquivo:AnsiString; sTipo:AnsiString; DataInicial: AnsiString; DataFinal: AnsiString; sUsuario: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_FormatoDadosMFD( ArquivoOrigem: AnsiString; ArquivoDestino: AnsiString; TipoFormato: AnsiString; TipoDownload: AnsiString; ParametroInicial: AnsiString; ParametroFinal: AnsiString; UsuarioECF: AnsiString ): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ArquivoMFD( cNomeArquivoOrigem: AnsiString; cDadoInicial: AnsiString; cDadoFinal: AnsiString; cTipoDownload: AnsiString; cUsuario: AnsiString; iTipoGeracao: integer; cChavePublica: AnsiString; cChavePrivada: AnsiString; iUnicoArquivo: integer ): Integer;  StdCall; External'BEMAFI32.DLL';


  function Bematech_FI_DownloadMF( Arquivo: AnsiString ): Integer; StdCall; External 'BEMAFI32.DLL';

  //
  // Novas leituras MFD
  //
  function Bematech_FI_LeituraMemoriaFiscalDataMFD(DataInicial, DataFinal, FlagLeitura : AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_LeituraMemoriaFiscalReducaoMFD(ReducaoInicial, ReducaoFinal, FlagLeitura : AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_LeituraMemoriaFiscalSerialDataMFD(DataInicial, DataFinal, FlagLeitura : AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_LeituraMemoriaFiscalSerialReducaoMFD(ReducaoInicial, ReducaoFinal, FlagLeitura : AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_GeraRegistrosCAT52MFD(cArquivo,cData: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_GeraRegistrosCAT52MFDEx( cArquivo, cData, cArqDestino: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  //
  function BemaGeraRegistrosTipoE( cArqMFD: AnsiString; cArqTXT: AnsiString; cDataInicial: AnsiString; cDataFinal: AnsiString; cRazao: AnsiString; cEndereco: AnsiString; cPAR1: AnsiString; cCMD: AnsiString; cPAR2: AnsiString; cPAR3: AnsiString; cPAR4: AnsiString; cPAR5: AnsiString; cPAR6: AnsiString; cPAR7: AnsiString; cPAR8: AnsiString; cPAR9: AnsiString; cPAR10: AnsiString; cPAR11: AnsiString; cPAR12: AnsiString; cPAR13: AnsiString; cPAR14: AnsiString ): Integer; StdCall; External 'BemaMFD2.dll';

  // Funções das Operações Não Fiscais ///////////////////////////////////////////

  function Bematech_FI_RecebimentoNaoFiscal(IndiceTotalizador: AnsiString; Valor: AnsiString; FormaPagamento: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_AbreComprovanteNaoFiscalVinculado(FormaPagamento: AnsiString; Valor: AnsiString; NumeroCupom: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_UsaComprovanteNaoFiscalVinculado(Texto: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL'
  function Bematech_FI_FechaComprovanteNaoFiscalVinculado:Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_Sangria(Valor: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_Suprimento(Valor: AnsiString; FormaPagamento: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';

  // Funções de Informações da Impressora ////////////////////////////////////////

  function Bematech_FI_NumeroSerie(NumeroSerie: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_NumeroSerieMFD(NumeroSerie: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_SubTotal(SubTotal: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_NumeroCupom(NumeroCupom: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_LeituraXSerial: Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VersaoFirmware(VersaoFirmware: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_CGC_IE(CGC: AnsiString; IE: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_GrandeTotal(GrandeTotal: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_Cancelamentos(ValorCancelamentos: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_Descontos(ValorDescontos: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_NumeroOperacoesNaoFiscais(NumeroOperacoes: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_NumeroCuponsCancelados(NumeroCancelamentos: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_NumeroIntervencoes(NumeroIntervencoes: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_NumeroReducoes(NumeroReducoes: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_NumeroSubstituicoesProprietario(NumeroSubstituicoes: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_UltimoItemVendido(NumeroItem: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ClicheProprietario(Cliche: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_NumeroCaixa(NumeroCaixa: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_NumeroLoja(NumeroLoja: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_SimboloMoeda(SimboloMoeda: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_MinutosLigada(Minutos: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_MinutosImprimindo(Minutos: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VerificaModoOperacao(Modo: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VerificaEpromConectada(Flag: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_FlagsFiscais(Var Flag: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ValorPagoUltimoCupom(ValorCupom: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_DataHoraImpressora(Data: AnsiString; Hora: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';

  //Convênio 0909 Início
  function Bematech_FI_VendaLiquida(Valor: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  //Convênio 0909 Fim
  //
  // Contadores
  //
  function Bematech_FI_ContadoresTotalizadoresNaoFiscais(Contadores: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ContadorCupomFiscalMFD(CuponsEmitidos : AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ContadorRelatoriosGerenciaisMFD (Relatorios : AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ContadorComprovantesCreditoMFD(Comprovantes : AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  //


  function Bematech_FI_VerificaTotalizadoresNaoFiscais(Totalizadores: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_DataHoraReducao(Data: AnsiString; Hora: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_DataMovimento(Data: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VerificaTruncamento(Flag: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_Acrescimos(ValorAcrescimos: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ContadorBilhetePassagem(ContadorPassagem: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VerificaAliquotasIss(Flag: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VerificaFormasPagamento(Formas: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VerificaRecebimentoNaoFiscal(Recebimentos: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VerificaDepartamentos(Departamentos: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VerificaTipoImpressora(Var TipoImpressora: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VerificaTotalizadoresParciais(Totalizadores: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_RetornoAliquotas(Aliquotas: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VerificaEstadoImpressora(Var ACK: Integer; Var ST1: Integer; Var ST2: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_DadosUltimaReducao(DadosReducao: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_MonitoramentoPapel(Var Linhas: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VerificaIndiceAliquotasIss(Flag: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ValorFormaPagamento(FormaPagamento: AnsiString; Valor: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ValorTotalizadorNaoFiscal(Totalizador: AnsiString; Valor: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_MarcaModeloTipoImpressoraMFD(Marca, Modelo, Tipo : AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';

  // Funções de Autenticação e Gaveta de Dinheiro ////////////////////////////////

  function Bematech_FI_Autenticacao:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_Autenticacao';
  function Bematech_FI_ProgramaCaracterAutenticacao(Parametros: AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_AcionaGaveta:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_AcionaGaveta';
  function Bematech_FI_VerificaEstadoGaveta(Var EstadoGaveta: Integer): Integer; StdCall; External 'BEMAFI32.DLL';

  // Outras Funções //////////////////////////////////////////////////////////////

  function Bematech_FI_AbrePortaSerial:Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_AbrePorta(numero: Integer): Integer; StdCall; External 'BEMAFI32.DLL';

  function Bematech_FI_RetornoImpressora(Var ACK: Integer; Var ST1: Integer; Var ST2: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_FechaPortaSerial:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_FechaPortaSerial';
  function Bematech_FI_MapaResumo:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_MapaResumo';
  function Bematech_FI_AberturaDoDia( ValorCompra: AnsiString; FormaPagamento: AnsiString ): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_FechamentoDoDia:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_FechamentoDoDia';
  function Bematech_FI_ImprimeConfiguracoesImpressora:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_ImprimeConfiguracoesImpressora';
  function Bematech_FI_ImprimeDepartamentos:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_ImprimeDepartamentos';
  function Bematech_FI_RelatorioTipo60Analitico:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_RelatorioTipo60Analitico';
  function Bematech_FI_RelatorioTipo60Mestre:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_RelatorioTipo60Mestre';
  function Bematech_FI_VerificaImpressoraLigada:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_VerificaImpressoraLigada';
  function Bematech_FI_ImprimeCheque( Banco: AnsiString; Valor: AnsiString; Favorecido: AnsiString; Cidade: AnsiString; Data: AnsiString; Mensagem: AnsiString ): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_SegundaViaNaoFiscalVinculadoMFD(): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_DadosUltimaReducaoMFD(DadosReducao : AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  //
  function Bematech_FI_NomeiaRelatorioGerencialMFD (Indice, Descricao : AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_AbreRelatorioGerencialMFD(Indice : AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VerificaRelatorioGerencialMFD(Relatorios : AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';

  {Sandro Silva 2016-03-01 inicio}
  function Bematech_FI_HabilitaDesabilitaRetornoEstendidoMFD(FlagRetorno : AnsiString): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_RetornoImpressoraMFD(Var ACK: Integer; Var ST1: Integer; Var ST2: Integer; Var ST3: Integer ): Integer; StdCall; External 'BEMAFI32.DLL';
  {Sandro Silva 2016-03-01 final}

  //
  // Minhas
  //
  function _ecf02_ConfigAliquota(sAliquota: String): Boolean;
  Function _ecf02_TestaLigadaePapel(pP1:Boolean):Boolean;
  function _ecf02_CodeErro(Pp1: integer):integer;
  function _ecf02_Inicializa(Pp1: String):Boolean;
  function _ecf02_FechaCupom(Pp1: Boolean):Boolean;
  function _ecf02_Pagamento(Pp1: Boolean):Boolean;
  function _ecf02_CancelaUltimoItem(Pp1: Boolean):Boolean;
  function _ecf02_SubTotal(Pp1: Boolean):Real;
  function _ecf02_AbreGaveta(Pp1: Boolean):Boolean;
  function _ecf02_Sangria(Pp1: Real):Boolean;
  function _ecf02_Suprimento(Pp1: Real):Boolean;
  function _ecf02_NovaAliquota(Pp1: String):Boolean;
  function _ecf02_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
  function _ecf02_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
  function _ecf02_CancelaUltimoCupom(Pp1: Boolean):Boolean;
  function _ecf02_AbreNovoCupom(Pp1: Boolean):Boolean;
  function _ecf02_NumeroDoCupom(Pp1: Boolean):String;
  //
  function _ecf02_CancelaItemN(pP1, pP2: String):Boolean;
  function _ecf02_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
  function _ecf02_ReducaoZ(pP1: Boolean):Boolean;
  function _ecf02_LeituraX(pP1: Boolean):Boolean;
  function _ecf02_RetornaVerao(pP1: Boolean):Boolean;
  function _ecf02_LigaDesLigaVerao(pP1: Boolean):Boolean;
  function _ecf02_VersodoFirmware(pP1: Boolean): String;
  function _ecf02_NmerodeSrie(pP1: Boolean): String;
  function _ecf02_CGCIE(pP1: Boolean): String;
  function _ecf02_Cancelamentos(pP1: Boolean): String;
  function _ecf02_Descontos(pP1: Boolean): String;
  function _ecf02_ContadorSeqencial(pP1: Boolean): String;
  function _ecf02_Nmdeoperaesnofiscais(pP1: Boolean): String;
  function _ecf02_NmdeCuponscancelados(pP1: Boolean): String;
  function _ecf02_NmdeRedues(pP1: Boolean): String;
  function _ecf02_Nmdeintervenestcnicas(pP1: Boolean): String;
  function _ecf02_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
  function _ecf02_Datadaultimareduo(pP1: Boolean): String;
  function _ecf02_Clichdoproprietrio(pP1: Boolean): String;
  function _ecf02_NmdoCaixa(pP1: Boolean): String;
  function _ecf02_Nmdaloja(pP1: Boolean): String;
  function _ecf02_Moeda(pP1: Boolean): String;
  function _ecf02_Dataehoradaimpressora(pP1: Boolean): String;
  function _ecf02_Datadomovimento(pP1: Boolean): String;
  function _ecf02_StatusGaveta(Pp1: Boolean):String;
  function _ecf02_RetornaAliquotas(pP1: Boolean): String;
  function _ecf02_VerificaAliquotasIss: String;
  function _ecf02_Vincula(pP1: String): Boolean;
  function _ecf02_FlagsDeISS(pP1: Boolean): String;
  function _ecf02_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
  function _ecf02_MudaMoeda(pP1: String): Boolean;
  function _ecf02_MostraDisplay(pP1: String): Boolean;
  function _ecf02_leituraMemoriaFiscalEmDisco(pP1,pP2,pP3: String): Boolean;
  function _ecf02_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean; //iP2 = Número do Cupom vinculado
  function _ecf02_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
  function _ecf02_FechaCupom2(sP1: Boolean): Boolean;
  function _ecf02_ImprimeCheque(rP1: Real; sP2: String): Boolean;
  function _ecf02_GrandeTotal(sP1: Boolean): String;
  function _ecf02_TotalizadoresDasAliquotas(sP1: Boolean): String;
  function _ecf02_CupomAberto(sP1: Boolean): boolean;
  function _ecf02_FaltaPagamento(sP1: Boolean): boolean;
  function _ecf02_ProgramaAplicativo(sP1: Boolean): boolean;
  function _ecf02_DadosUltimaReducaoZ(sP1: Boolean): String;
  function _ecf02_RetornoStatusImpressora(bExibir: Boolean): String;
  //
  // PAF
  //
  function _ecf02_Marca(sP1: Boolean): String;
  function _ecf02_Modelo(sP1: Boolean): String;
  function _ecf02_Tipodaimpressora(pP1: Boolean): String;
  function _ecf02_VersaoSB(pP1: Boolean): String; //
  function _ecf02_HoraIntalacaoSB(pP1: Boolean): String; //
  function _ecf02_DataIntalacaoSB(pP1: Boolean): String; //
  function _ecf02_DadosDaUltimaReducao(pP1: Boolean): String; //
  function _ecf02_CodigoModeloEcf(pP1: Boolean): String; //
  function _ecf02_DataUltimaReducao: String;
  function _ecf02_HoraUltimaReducao: String;
  //
  // Contadores
  //
  function _ecf02_GNF(Pp1: Boolean):String;
  function _ecf02_GRG(Pp1: Boolean):String;
  function _ecf02_CDC(Pp1: Boolean):String;
  function _ecf02_CCF(Pp1: Boolean):String;
  function _ecf02_CER(Pp1: Boolean):String;



  //
  //  function _ecf02_VerificaFormasPagamento(bP1:Boolean): Boolean;
  //

var
  _ecf02: TBemaFI;


implementation

uses StrUtils, ufuncoesfrente;


function FunctionDetect(LibName, FuncName: String; var LibPointer: Pointer): boolean;
var
  LibHandle: tHandle;
begin
  Result := false;
  LibPointer := NIL;
  if LoadLibrary(PChar(LibName)) = 0 then Exit; // Sandro Silva 2023-12-13 if LoadLibrary(PChar(LibName)) = 0 then exit;
  LibHandle := GetModuleHandle(PChar(LibName)); // Sandro Silva 2023-12-13 LibHandle := GetModuleHandle(PChar(LibName));
  if LibHandle <> 0 then
  begin
    LibPointer := GetProcAddress(LibHandle, PAnsiChar(AnsiString(FuncName))); // Sandro Silva 2023-12-13 LibPointer := GetProcAddress(LibHandle, PChar(FuncName));
    if LibPointer <> NIL then Result := true;
  end;
end;

procedure SleepEntreMetodos;
begin
  //if AnsiContainsText(Form1.sModeloFabricante, '4200 TH') then
    Sleep(200);
end;

function _ecf02_ConfigAliquota(sAliquota: String): Boolean;
begin
  Result := (Bematech_FI_ProgramaAliquota(AnsiString(sAliquota), 0) = 1); // Sandro Silva 2023-12-13 Result := (Bematech_FI_ProgramaAliquota(PChar(sAliquota), 0) = 1);
end;

function _ecf02_TestaLigadaePapel(pP1:Boolean):Boolean;
var
   iACK,iST1,iST2:integer;
begin
  //
  // Result := True;
  //
  iACK := 0; iST1 := 0; iST2 := 0;
  Result:=(Bematech_FI_VerificaImpressoraLigada()=1);
  //
  if Result then
  begin
    Result:=(Bematech_FI_RetornoImpressora(iACK, iST1, iST2)=1);
    if iACK = 6 then
    begin
      // Verifica ST1
      if iST1 >= 128 then
      begin
        iST1 := iST1 - 128;
        Result:=False; //sErro:='ERRO: fim de papel';
      end;
    end;
  end;
  //
  //if not Result then if FunctionDetect('USER32.DLL','BlockInput',@Form1.xBlockInput) then Form1.xBlockInput(False);  // Enable  Keyboard & mouse
  //
end;  

function _ecf02_CodeErro(pP1: integer):Integer; //
var
  iACK, iST1, iST2{, iST3}: Integer;
  vErro    : array [0..99] of String;  // Cria uma matriz com  100 elementos
  I        : Integer;
  sErro:string;
begin
  //
  for I := 0 to 99 do vErro[I] := 'Comando não executado.';
  if pP1 = 0 then pP1 := 1;
  //
  // Verificar se falta papel, e no sugerir uma leitura X
  //
  Form1.Panel2.Visible := False;
  //
  // numeros negativos
  // vErro[00] :=  'Erro de Comunicação!';
  //
  vErro[01] :=  'Erro de Execução na Função. Verifique!';
  vErro[02] :=  'Parâmetro Inválido!';
  vErro[03] :=  'Alíquota não programada!';
  vErro[04] :=  'Arquivo BemaFI32.INI não encontrado. Verifique!';
  vErro[05] :=  'Erro ao Abrir a Porta de Comunicação';
  vErro[06] :=  'Impressora Desligada ou Desconectada';
  vErro[07] :=  'Banco Não Cadastrado no Arquivo BemaFI32.ini';
  vErro[08] :=  'Erro ao Criar ou Gravar no Arquivo Retorno.txt ou Status.txt';
  vErro[18] :=  'Não foi possível abrir arquivo INTPOS.001!';
  vErro[19] :=  'Parâmetro diferentes!';
  vErro[20] :=  'Transação cancelada pelo Operador!';
  vErro[21] :=  'A Transação não foi aprovada!';
  vErro[22] :=  'Não foi possível terminal a Impressão!';
  vErro[23] :=  'Não foi possível terminal a Operação!';
  vErro[24] :=  'Forma de pagamento não programada.';
  vErro[25] :=  'Totalizador não fiscal não programado.';
  vErro[26] :=  'Transação já Efetuada!';
  vErro[28] :=  'Não há Informações para serem Impressas!';
  vErro[99] :=  'Falha de comunicação '+chr(10)+chr(10)+
                'Sugestão: verifique as conexões,'+chr(10)+
                'ligue e desligue a impressora. '+chr(10)+chr(10)+
                'O Sistema será Finalizado.';

  //
  if pP1 <> 1 then
  begin
    //if FunctionDetect('USER32.DLL','BlockInput',@Form1.xBlockInput) then Form1.xBlockInput(False);  // Enable  Keyboard & mouse
    Application.MessageBox(Pchar('ERRO n.'+IntToStr(pP1)+' - '+vErro[abs(pP1)]),'Atenção',mb_Ok + mb_DefButton1);
  end;
  //
  if (pP1=00) or (pP1=99) then Halt(1);

  //analisa o retorno da impressora
  //  if pP1 <=0 then
  //  begin
    iACK := 0; iST1 := 0; iST2 := 0; // Sandro Silva 2016-04-01 Não precisa  iST3 := 0;

    Bematech_FI_RetornoImpressora(iACK, iST1, iST2);

    if iACK = 6 then
    begin
      sErro:='';

      // Verifica ST1
      if iST1 >= 128 then
      begin
        iST1  := iST1 - 128;
        sErro := 'ERRO: fim de papel'+chr(10);
      end;

      if iST1 >= 64  then
      begin
        iST1 := iST1 - 64;
        // Sandro Silva 2016-03-03 sErro := 'pouco papel';
         sErro := sErro + 'Atenção: pouco papel'+chr(10);
        if Form1.Memo3.Visible then
        begin
          Form1.Panel2.Visible := True;
          Form1.Panel2.BringToFront;
        end;
      end;

      IF iST1 >= 32  then begin iST1 := iST1 - 32;  sErro:=sErro+'ERRO: erro no relógio'+chr(10); end;
      IF iST1 >= 16  then begin iST1 := iST1 - 16;  sErro:=sErro+'ERRO: impressora em erro'+chr(10); end;
      IF iST1 >= 8   then begin iST1 := iST1 - 8;   sErro:=sErro+'ERRO: CMD não iniciado com ESC'+chr(10); end;
      IF iST1 >= 4   then begin iST1 := iST1 - 4;   sErro:=sErro+'ERRO: Comando inexistente'+chr(10); end;
      IF iST1 >= 2   then begin iST1 := iST1 - 2;   sErro:=sErro+'cupom aberto'+chr(10); end;
      IF iST1 >= 1   then begin iST1 := iST1 - 1;   sErro:=sErro+'ERRO: número de parâmetros inválidos'+chr(10); end;

      // Verifica ST2
      IF iST2 >= 128 then begin iST2 := iST2 - 128; sErro:=sErro+'ERRO: tipo de parâmetro inválido'+chr(10); end;
      IF iST2 >= 64  then begin iST2 := iST2 - 64;  sErro:=sErro+'ERRO: Memória Fiscal Lotada'+chr(10); end;
      IF iST2 >= 32  then begin iST2 := iST2 - 32;  sErro:=sErro+'ERRO: CMOS não Volátil'+chr(10); end;
      IF iST2 >= 16  then begin iST2 := iST2 - 16;  sErro:=sErro+'ERRO: Alíquota Não Programada'+chr(10); end;
      if iST2 >= 8   then begin iST2 := iST2 - 8;   sErro:=sErro+'ERRO: Alíquotas lotadas'+chr(10); end;
      IF iST2 >= 4   then begin iST2 := iST2 - 4;   sErro:=sErro+'ERRO: Cancelamento não Permitido'+chr(10); end;
      IF iST2 >= 2   then begin iST2 := iST2 - 2;   sErro:=sErro+'ERRO: CGC/IE não Programados'+chr(10); end;
      IF iST2 >= 1   then begin iST2 := iST2 - 1;   sErro:=sErro+'ERRO: Comando não Executado'; end;
    end;
    if iACK = 21 then
    begin
      Application.MessageBox(PChar('Atenção!!!' + #13 + #10 +
                   'A Impressora retornou NAK. O sistema será finalizado.'), 'Atenção', MB_ICONWARNING + MB_OK);
      Application.Terminate;
      Result:=pP1;
      Exit;
    end;
    // Sandro Silva 2016-03-03 if Copy(sErro,1,4)='ERRO' then
    if Pos('ERRO', sErro) <> 0 then
    begin
      Application.MessageBox(PChar('Atenção!!!' + #13 + #10 +
                   'A Impressora retornou: '+ #13 + #10 +sErro), 'Atenção', MB_ICONWARNING + MB_OK);

      // Sandro Silva 2016-09-14  _ecf02_RetornoStatusImpressora(True);// Sandro Silva 2016-03-03
      if _ecf02_RetornoStatusImpressora(True) <> '' then
        pP1:=9;
    end;
//  end;
  Result:=pP1;
end;



// Verifica se a forma de pagamento está cadastrada
function _ecf02_VerificaFormaPgto(Forma:String):String;
var
  Retorno,i,j:integer;
  sFormasPagamento:String;
begin
   Result:='XX';
   sFormasPagamento:=Replicate(' ',3016);
   Retorno:=Bematech_FI_VerificaFormasPagamento( sFormasPagamento );
   if Retorno=1 then //ok
   begin
     i:=1;
     J:=1;
     while i < length(sFormasPagamento) do
     begin
       if Result='XX' then // só entra se ainda não encontrou
         if Pos(UpperCase(Forma),UpperCase(Copy(sFormasPagamento,i,58)))>0 then
         begin
           Result:='0'+IntToStr(j);//Forma;//
         end;
       i:=i+58;
       j:=J+1;
     end;
   end;
end;

function _ecf02_VerificaDescricaoFormaPgto(Forma:String):String;
var
  sFormasPagamento:String;
begin
   if (isNumericString(Forma)) and (Alltrim(Forma)<> '') then
    begin
      sFormasPagamento:=Replicate(' ',3016);
      if (Bematech_FI_VerificaFormasPagamento( sFormasPagamento )<>1) then
        Result:=''
      else
        Result:=Copy(sFormasPagamento,((StrToInt(Forma)-1)*58)+1,15);
    end
   else
   Result:='';
end;

// --------------------------- //
// Detecta qual a porta que    //
// a impressora está conectada //
// --------------------------- //
function _ecf02_Inicializa(Pp1: String):Boolean;
var
  iRetorno : Integer;
  sFlag: String;
//  Mais1Ini : tIniFile;
begin
  //
  if Form22.Label6.Caption = 'Detectando porta de comunicação...' then
  begin
   Bematech_FI_AbrePortaSerial();
   //_ecf02_CodeErro(Bematech_FI_AbrePortaSerial());
  end;
  //
  {Sandro Silva 2016-03-01 inicio}
  try
    sFlag := '1';
    Bematech_FI_HabilitaDesabilitaRetornoEstendidoMFD(AnsiString(sFlag)); // Sandro Silva 2023-12-13 Bematech_FI_HabilitaDesabilitaRetornoEstendidoMFD(pchar(sFlag));
    _ecf02_RetornoStatusImpressora(True);
  except
  end;
  {Sandro Silva 2016-03-01 final}

  iRetorno := Bematech_FI_VerificaImpressoraLigada();
  //
  if iRetorno = 1 then
  begin
    //
    {Sandro Silva 2023-12-13 inicio
    Bematech_FI_NomeiaRelatorioGerencialMFD(pchar('02'),pchar('IDENT DO PAF'));
    Bematech_FI_NomeiaRelatorioGerencialMFD(pchar('03'),pchar('VENDA PRAZO'));
    Bematech_FI_NomeiaRelatorioGerencialMFD(pchar('04'),pchar('CARTAO TEF'));
    Bematech_FI_NomeiaRelatorioGerencialMFD(pchar('05'),pchar('MEIOS DE PAGTO'));
    Bematech_FI_NomeiaRelatorioGerencialMFD(pchar('06'),pchar('DAV EMITIDOS'));
    Bematech_FI_NomeiaRelatorioGerencialMFD(pchar('07'),pchar('ORCAMENT (DAV)'));
    Bematech_FI_NomeiaRelatorioGerencialMFD(pchar('08'),pchar('CONF CONTA CLI'));// 2016-02-04 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
    Bematech_FI_NomeiaRelatorioGerencialMFD(pchar('09'),pchar('TRANSF CONT CLI'));// 2016-02-11 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
    Bematech_FI_NomeiaRelatorioGerencialMFD(pchar('10'),pchar('CONT CLI ABERTA'));// 2016-02-11 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
    Bematech_FI_NomeiaRelatorioGerencialMFD(pchar('11'),pchar('CONF MESA'));
    Bematech_FI_NomeiaRelatorioGerencialMFD(pchar('12'),pchar('TRANSF MESA'));
    Bematech_FI_NomeiaRelatorioGerencialMFD(pchar('13'),pchar('MESAS ABERTAS'));
    Bematech_FI_NomeiaRelatorioGerencialMFD(pchar('14'),pchar('PARAM CONFIG'));
    }
    Bematech_FI_NomeiaRelatorioGerencialMFD(AnsiString('02'), AnsiString('IDENT DO PAF'));
    Bematech_FI_NomeiaRelatorioGerencialMFD(AnsiString('03'), AnsiString('VENDA PRAZO'));
    Bematech_FI_NomeiaRelatorioGerencialMFD(AnsiString('04'), AnsiString('CARTAO TEF'));
    Bematech_FI_NomeiaRelatorioGerencialMFD(AnsiString('05'), AnsiString('MEIOS DE PAGTO'));
    Bematech_FI_NomeiaRelatorioGerencialMFD(AnsiString('06'), AnsiString('DAV EMITIDOS'));
    Bematech_FI_NomeiaRelatorioGerencialMFD(AnsiString('07'), AnsiString('ORCAMENT (DAV)'));
    Bematech_FI_NomeiaRelatorioGerencialMFD(AnsiString('08'), AnsiString('CONF CONTA CLI'));// 2016-02-04 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
    Bematech_FI_NomeiaRelatorioGerencialMFD(AnsiString('09'), AnsiString('TRANSF CONT CLI'));// 2016-02-11 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
    Bematech_FI_NomeiaRelatorioGerencialMFD(AnsiString('10'), AnsiString('CONT CLI ABERTA'));// 2016-02-11 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
    Bematech_FI_NomeiaRelatorioGerencialMFD(AnsiString('11'), AnsiString('CONF MESA'));
    Bematech_FI_NomeiaRelatorioGerencialMFD(AnsiString('12'), AnsiString('TRANSF MESA'));
    Bematech_FI_NomeiaRelatorioGerencialMFD(AnsiString('13'), AnsiString('MESAS ABERTAS'));
    Bematech_FI_NomeiaRelatorioGerencialMFD(AnsiString('14'), AnsiString('PARAM CONFIG'));
    {Sandro Silva 2023-12-13 fim}
    //
    Result := True;
    //
  end else
  begin
    _ecf02_CodeErro(iRetorno); // Sandro Silva 2016-03-01
    Result := False;
  end;
  //
end;

// ------------------------------ //
function _ecf02_FechaCupom(Pp1: Boolean):Boolean; //
begin
  //
  if Form1.fTotal = 0 then
  begin
    Result := (_ecf02_CodeErro(Bematech_FI_CancelaCupom()) = 1)
  end
  else // cupom em branco cancela
  begin
    //
    if Form1.fTotal >= Form1.ibDataSet25RECEBER.AsFloat then
    begin
      Form1.Retorno := Bematech_FI_IniciaFechamentoCupom('D', '$', AnsiString(StrZero((Form1.fTotal - Form1.ibDataSet25RECEBER.AsFloat) * 100, 12, 0))); // Sandro Silva 2023-12-13 Form1.Retorno := Bematech_FI_IniciaFechamentoCupom('D','$',pchar(StrZero((Form1.fTotal-Form1.ibDataSet25RECEBER.AsFloat)*100,12,0)));
    end else
    begin
      Form1.Retorno := Bematech_FI_IniciaFechamentoCupom('A', '$', AnsiString(StrZero((Form1.ibDataSet25RECEBER.AsFloat - Form1.fTotal) * 100, 12, 0))); // Sandro Silva 2023-12-13 Form1.Retorno := Bematech_FI_IniciaFechamentoCupom('A','$',pchar(StrZero((Form1.ibDataSet25RECEBER.AsFloat-Form1.fTotal)*100,12,0)));
    end;
    //
    if Form1.Retorno = 1 then
    begin
      Result := True;
    end else
    begin
      _ecf02_CodeErro(Form1.Retorno);
      Result := False;
    end;
  end;
  //
end;

function _ecf02_Pagamento(Pp1: Boolean):Boolean;
begin
  // ------------------ //
  // Forma de pagamento //
  // ------------------ //
//    ShowMessage(
//      'Em dinheiro.: '+StrZero(Form1.ibDataSet25ACUMULADO2.AsFloat*100,14,0)+ Chr(10) +
//      'Prazo.......: '+StrZero(Form1.ibDataSet25DIFERENCA_.AsFloat*100,14,0));
  {Sandro Silva 2023-12-13 inicio
  if Form1.fTEFPago                      > 0 then Bematech_FI_EfetuaFormaPagamento(pchar('Cartao') ,pchar( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.fTEFPago*100])),15),1,12)));      // Cartão
//  if Form1.fTEFPago                      > 0 then Bematech_FI_EfetuaFormaPagamento(pchar('Cartao '+Form1.sDebitoOuCredito)  ,pchar( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.fTEFPago*100])),15),1,12)));      // Cartão
  if Form1.ibDataSet25ACUMULADO1.AsFloat > 0 then Bematech_FI_EfetuaFormaPagamento(pchar('Cheque')  ,pchar( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25ACUMULADO1.AsFloat*100])),15),1,12))); // Cheque
  if Form1.ibDataSet25DIFERENCA_.AsFloat > 0 then Bematech_FI_EfetuaFormaPagamento(pchar('Prazo')   ,pchar( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25DIFERENCA_.AsFloat*100])),15),1,12))); // Prazo
  if Form1.ibDataSet25ACUMULADO2.AsFloat > 0 then Bematech_FI_EfetuaFormaPagamento(pchar('Dinheiro'),pchar( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25ACUMULADO2.AsFloat*100])),15),1,12))); // Dinheiro
  //
  if Form1.ibDataSet25VALOR01.AsFloat     > 0 then Bematech_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label18.Caption)), pchar( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR01.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR02.AsFloat     > 0 then Bematech_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label19.Caption)), pchar( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR02.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR03.AsFloat     > 0 then Bematech_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label20.Caption)), pchar( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR03.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR04.AsFloat     > 0 then Bematech_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label21.Caption)), pchar( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR04.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR05.AsFloat     > 0 then Bematech_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label22.Caption)), pchar( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR05.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR06.AsFloat     > 0 then Bematech_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label23.Caption)), pchar( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR06.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR07.AsFloat     > 0 then Bematech_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label24.Caption)), pchar( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR07.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR08.AsFloat     > 0 then Bematech_FI_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label25.Caption)), pchar( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR08.AsFloat*100])),15),1,12)));    // Dinheiro
  //
  // Sandro Silva 2016-09-14  Result:=(_ecf02_CodeErro(Bematech_FI_TerminaFechamentoCupom('MD5: '+pchar(Form1.sMD5DaLista+chr(10)+ConverteAcentos(Form1.sMensagemPromocional))) )=1);
  Result:=(_ecf02_CodeErro(Bematech_FI_TerminaFechamentoCupom(Copy('MD5: '+pchar(Form1.sMD5DaLista+chr(10)+ConverteAcentos(Form1.sMensagemPromocional)), 1, 384)) )=1);
  }
  if Form1.fTEFPago                      > 0 then Bematech_FI_EfetuaFormaPagamento(AnsiString('Cartao'), AnsiString(Copy(Right('000000000000' + AllTrim(Format('%13f', [Form1.fTEFPago * 100])),15),1,12)));      // Cartão
  if Form1.ibDataSet25ACUMULADO1.AsFloat > 0 then Bematech_FI_EfetuaFormaPagamento(AnsiString('Cheque'), AnsiString(Copy(Right('000000000000' + AllTrim(Format('%13f', [Form1.ibDataSet25ACUMULADO1.AsFloat * 100])), 15), 1, 12))); // Cheque
  if Form1.ibDataSet25DIFERENCA_.AsFloat > 0 then Bematech_FI_EfetuaFormaPagamento(AnsiString('Prazo'), AnsiString(Copy(Right('000000000000' + AllTrim(Format('%13f', [Form1.ibDataSet25DIFERENCA_.AsFloat * 100])), 15), 1, 12))); // Prazo
  if Form1.ibDataSet25ACUMULADO2.AsFloat > 0 then Bematech_FI_EfetuaFormaPagamento(AnsiString('Dinheiro'), AnsiString(Copy(Right('000000000000' + AllTrim(Format('%13f', [Form1.ibDataSet25ACUMULADO2.AsFloat * 100])), 15), 1, 12))); // Dinheiro

  if Form1.ibDataSet25VALOR01.AsFloat     > 0 then Bematech_FI_EfetuaFormaPagamento(AnsiString(AllTrim(Form2.Label18.Caption)), AnsiString(Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR01.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR02.AsFloat     > 0 then Bematech_FI_EfetuaFormaPagamento(AnsiString(AllTrim(Form2.Label19.Caption)), AnsiString(Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR02.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR03.AsFloat     > 0 then Bematech_FI_EfetuaFormaPagamento(AnsiString(AllTrim(Form2.Label20.Caption)), AnsiString(Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR03.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR04.AsFloat     > 0 then Bematech_FI_EfetuaFormaPagamento(AnsiString(AllTrim(Form2.Label21.Caption)), AnsiString(Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR04.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR05.AsFloat     > 0 then Bematech_FI_EfetuaFormaPagamento(AnsiString(AllTrim(Form2.Label22.Caption)), AnsiString(Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR05.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR06.AsFloat     > 0 then Bematech_FI_EfetuaFormaPagamento(AnsiString(AllTrim(Form2.Label23.Caption)), AnsiString(Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR06.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR07.AsFloat     > 0 then Bematech_FI_EfetuaFormaPagamento(AnsiString(AllTrim(Form2.Label24.Caption)), AnsiString(Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR07.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR08.AsFloat     > 0 then Bematech_FI_EfetuaFormaPagamento(AnsiString(AllTrim(Form2.Label25.Caption)), AnsiString(Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR08.AsFloat*100])),15),1,12)));    // Dinheiro
  //
  Result:=(_ecf02_CodeErro(Bematech_FI_TerminaFechamentoCupom(Copy('MD5: '+ AnsiString(Form1.sMD5DaLista+chr(10)+ConverteAcentos(Form1.sMensagemPromocional)), 1, 384)) ) = 1);
  {Sandro Silva 2023-12-13 fim}
  //
  // Result:=true;
  //
end;

// ------------------------------ //
// Cancela o último item  emitido //
// ------------------------------ //
function _ecf02_CancelaUltimoItem(Pp1: Boolean):Boolean;
begin
  Result := (_ecf02_CodeErro(Bematech_FI_CancelaItemAnterior()) = 1);
end;

function _ecf02_CancelaUltimoCupom(Pp1: Boolean): Boolean;
var
  iRetorno: Integer;
  bVinculado: Boolean;
begin
  iRetorno := 1;
  bVinculado := False;
  try
    Form1.IBQuery65.Close;
    Form1.IBQuery65.SQL.Text :=
      'select A.COO as COO_CUPOM, A.CCF as ALTERACA_CCF, ' +
      'P.CCF as PAGAMENT_CCF, P.GNF as PAGAMENT_GNF, P.FORMA, P.VALOR, P.REGISTRO as SEQUENCIA, ' +
      'D.COO as COO_VINCULADO ' +
      'from ALTERACA A ' +
      'left join PAGAMENT P on P.PEDIDO = A.PEDIDO and P.CAIXA = A.CAIXA and P.CCF = A.CCF and coalesce(P.GNF, '''') <> '''' ' +
      //'left join DEMAIS D on D.GNF = P.GNF and D.ECF = (select first 1 R.SERIE from REDUCOES R where R.PDV = A.CAIXA order by DATA desc) ' +
      // Sandro Silva 2017-07-25  'left join DEMAIS D on D.GNF = P.GNF and coalesce(D.CDC, '''') <> '''' and D.ECF = ' + QuotedStr(Form1.sNumeroDeSerieDaImpressora) +
      'left join DEMAIS D on D.GNF = P.GNF and D.ECF = ' + QuotedStr(Form1.sNumeroDeSerieDaImpressora) + // Para selecionar todas as impressões relacionadas ao cupom (Vinculado Cartão, Gerencial)
      ' where A.CAIXA = ' + QuotedStr(Form1.sCaixa) +
      ' and A.PEDIDO = ' + QuotedStr(NumeroCupom) +
      ' group by A.COO, A.CCF, P.CCF, P.GNF, D.COO, P.FORMA, P.VALOR, P.REGISTRO ' +
      'order by SEQUENCIA';
    Form1.IBQuery65.Open;

    // DLL da Bematech está retornando cancelado o cupom mesmo quando ele não é o último documento impresso, porém não cancela na impressora
    if Form1.IBQuery65.FieldByName('COO_VINCULADO').AsString = '' then
    begin
      // Não encontrou impressão de cupom vinculado do TEF, pesquisa outras impressões com COO maior que o COO do cupom que está sendo cancelado
      Form1.IBQuery65.Close;
      Form1.IBQuery65.SQL.Text :=
        'select A.COO as COO_CUPOM, A.CCF as ALTERACA_CCF, A.DATA, A.HORA, ' +
        'D.COO as COO_VINCULADO, D.DENOMINACAO, D.DATA, D.HORA ' +
        'from ALTERACA A ' +
        'left join DEMAIS D on D.ECF = ' + QuotedStr(Form1.sNumeroDeSerieDaImpressora) + ' and D.COO > A.COO ' +
        ' where A.CAIXA = ' + QuotedStr(Form1.sCaixa) +
        ' and A.PEDIDO = ' + QuotedStr(NumeroCupom) +
        ' order by A.DATA desc, A.HORA desc';
      Form1.IBQuery65.Open;
    end;

    if Form1.IBQuery65.FieldByName('COO_VINCULADO').AsString <> '' then
    begin
      // Cancelamento de vinculado não funciona corretamente com todos modelos de ECF. 4200 cancela o vinculado e não cancela o cupom
      bVinculado := True;
      iRetorno := 0;// Sandro Silva 2018-10-04 
      ShowMessage('Cancelamento não permitido');
    end;
  except

  end;

  if bVinculado = False then
  begin
    iRetorno := Bematech_FI_CancelaCupom();
    _ecf02_CodeErro(iRetorno);
    // Sandro Silva 2017-08-16  Result := (iRetorno = 1);
  end;

  Result := (iRetorno = 1);// Sandro Silva 2017-08-16 
end;

function _ecf02_SubTotal(Pp1: Boolean):Real;
var
  sSubTotal: String;
  bChave: Boolean;
begin
  //
  sSubTotal := Replicate(' ',14);
  Result    := 0;
  //
  bChave := False;
  while not bChave do
  begin
    try
      Bematech_FI_SubTotal( sSubTotal );

      //ShowMessage('Teste 01 ' + sSubTotal);

      Result := StrToFloat(sSubTotal)/100;
      {Sandro Silva 2017-07-25 inicio}
      {Sandro Silva 2019-05-02 inicio Ficha 4601 Movido para Form1.PDV_SubTotal(
      if Result = 0 then
      begin
        // ecf 4200 retorna zerado qdo tem cupom aberto, com itens vendido, fechar o frente e abrir novamente
        Result := Form1.SubTotalAlteraca(Result); // Sandro Silva 2019-04-30 Result := Form1.SubTotalAlteraca;
      end;
      }
      {Sandro Silva 2017-07-25 final}

      bChave := True;
    except
      Result := 0;
      bChave := False;
      Sleep(100);
    end;
  end;
end;

// ------------------------------ //
// Abre um novo copom fiscal      //
// ------------------------------ //
function _ecf02_AbreNovoCupom(Pp1: Boolean):Boolean;
begin

  //_ecf02_RetornoStatusImpressora(True);// Sandro Silva 2016-03-03

  if _ecf02_CupomAberto(True) then // se o cupo já estiver aberto ignora a checagem de erro
  begin
    // Sandro Silva 2017-08-22 Bematech orientou a não tentar abrir cupom quando já estiver aberto, porque irá zerar o subtotal do cupom
    // Sandro Silva 2019-08-26  if (Form1.bECF0909 = False) then // ECF não é do convênio 09/09 e se o cupom já estiver aberto ignora a checagem de erro
    if AnsiContainsText(Form1.sModeloFabricante, '4200 TH') = False then // ECF não é do convênio 09/09 e se o cupom já estiver aberto ignora a checagem de // Sandro Silva 2019-08-26 ER 02.06 UnoChapeco
      Bematech_FI_AbreCupom(Form1.sCPF_CNPJ_Validado);
  end else
  begin
    Result := (_ecf02_CodeErro(Bematech_FI_AbreCupom(Form1.sCPF_CNPJ_Validado))=1);
    if not Result then
    begin
      Result:=(Bematech_FI_FechaComprovanteNaoFiscalVinculado()=1);
      if not result then Result := (Bematech_FI_FechaRelatorioGerencial()=1);
      if Result then Bematech_FI_FechaComprovanteNaoFiscalVinculado();
   end;
  end;
  //
  if _ecf02_CupomAberto(True) then
  begin
    Result := True
  end
  else
  begin
    // Sandro Silva 2016-03-03 ShowMessage('Não é possível abrir um novo cupom. Verifique redução Z pendente.');
    ShowMessage('Não é possível abrir um novo cupom.');
    Result := False;
  end;
  //
end;


// -------------------------------- //
// Retorna o número do Cupom        //
// -------------------------------- //
function _ecf02_NumeroDoCupom(Pp1: Boolean):String;
begin
  Result:=Replicate(' ',6);
  _ecf02_CodeErro(Bematech_FI_NumeroCupom( Result ));
end;

// -------------------------------- //
// Retorna o número do Cupom CCF    //
// -------------------------------- //
function _ecf02_ccF(Pp1: Boolean):String;
begin
   Result:=Replicate(' ',6);
  _ecf02_CodeErro(Bematech_FI_ContadorCupomFiscalMFD( Result ));
end;

// ------------------------------------------------------------------------- //
// Retorna o número de operações não fiscais executadas na impressora. GNF   //
// ------------------------------------------------------------------------- //
function _ecf02_GNF(Pp1: Boolean):String;
begin
  Result:=Replicate(' ',6);
  _ecf02_CodeErro(Bematech_FI_NumeroOperacoesNaoFiscais( Result ));
end;

// --------------------------------------- //
// Contador Geral de Relatorio Gerencial   //
// --------------------------------------- //
function _ecf02_GRG(Pp1: Boolean):String;
begin
  Result:=Replicate(' ',6);
  _ecf02_CodeErro(Bematech_FI_ContadorRelatoriosGerenciaisMFD( Result ));
end;

// -------------- //
// Contador CDC   //
// -------------- //
function _ecf02_CDC(Pp1: Boolean):String;
begin
  Result:=Replicate(' ',6);
  _ecf02_CodeErro(Bematech_FI_ContadorComprovantesCreditoMFD( Result ));
end;

// ------------------------------------------------------------------------- //
// Retorna o número de operações não fiscais executadas na impressora. CER   //
// ------------------------------------------------------------------------- //
function _ecf02_CER(Pp1: Boolean):String;
var
  s : String;
begin
  //
  s :=Replicate(' ',659);
  Bematech_FI_VerificaRelatorioGerencialMFD( s );
  // ShowMessage(S);
  if pP1 = True then
  begin
    Result := Copy(s,155,4); // Conferencia de conta
  end else
  begin
    Result := Copy(s,221,4); // Conferencia de mesa
  end;
  //
  Result := StrZero(StrToInt('0'+Limpanumero(Result)),4,0);
  //
  // ShowMessage('|'+Result+'|');
  // ShowMessage(IntToStr(Length(Result)));
  //
end;


// ------------------------------ //
// Cancela um item N              //
// ------------------------------ //
function _ecf02_CancelaItemN(pP1, pP2 : String):Boolean;
begin
  pP1:=Right(pP1,3);
  Result:=(_ecf02_CodeErro(Bematech_FI_CancelaItemGenerico(AnsiString( pP1 ) ))=1); // Sandro Silva 2023-12-13 Result:=(_ecf02_CodeErro(Bematech_FI_CancelaItemGenerico( pchar( pP1 ) ))=1);
end;

// -------------------------------- //
// Abre a gaveta                    //
// -------------------------------- //
function _ecf02_AbreGaveta(Pp1: Boolean):Boolean;
//var
//  iRetorno : Integer;
begin
  // iRetorno :=
  Bematech_FI_AcionaGaveta();
  Result:=True;
end;

// -------------------------------- //
// Status da gaveta                 //
// -------------------------------- //
function _ecf02_StatusGaveta(Pp1: Boolean):String;
var
  I : Integer;
begin
  //
  I:=0;
  Bematech_FI_VerificaEstadoGaveta( I );
  //
  if Form1.iStatusGaveta = 0 then
  begin
    if I  = 0 then Result:='000' else Result:='255';
  end else
  begin
    if I  = 0 then Result:='255' else Result:='000';
  end;
  //
end;

// -------------------------------- //
// Sangria                          //
// -------------------------------- //
function _ecf02_Sangria(Pp1: Real):Boolean;
var
  iResult : Integer;
begin
  iResult := Bematech_FI_Sangria(AnsiString(StrZero(pP1*100,12,0))); // Sandro Silva 2023-12-13 iResult := Bematech_FI_Sangria(pchar(StrZero(pP1*100,12,0)));
  iResult := _ecf02_CodeErro(iResult);
  if iResult = 1 then
    Result := True
  else
    Result := False;
end;

// -------------------------------- //
// Suprimento                       //
// -------------------------------- //
function _ecf02_Suprimento(Pp1: Real):Boolean;
var
  iResult : Integer;
begin
  iResult := Bematech_FI_Suprimento(AnsiString(StrZero(pP1*100,12,0)), AnsiString('')); // Sandro Silva 2023-12-13 iResult := Bematech_FI_Suprimento(pchar(StrZero(pP1*100,12,0)),pChar(''));
//  iResult := Bematech_FI_Suprimento( pchar(Format('%13.2f',[pP1])), pchar(''));
  iResult := _ecf02_CodeErro(iResult);
  if iResult = 1 then Result := True else Result := False;
end;

// -------------------------------- //
// Nova Aliquota                    //
// -------------------------------- //
function _ecf02_NovaAliquota(Pp1: String):Boolean;
begin
  showmessage('O Cadastro de alíquotas só é permitido através de intervenção técnica');
  result:=false;
end;

function _ecf02_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
var
  cTipoDownload  : String;
  cUsuario       : String;
  cArquivoOrigem, cArquivoDestino, cTipoFormato : String;
  iTipoGeracao, I : Integer;
  cCOOInicial, cCOOFinal : String;
  cDadoInicial, cDadoFinal, sChavePublica, sChavePrivada: string;
  sArqDestino: String; //2015-08-19
  iUnicoArquivo: Integer;

  procedure DeleteArquivoCOTEPE1704(sArquivo: String);
  var
    SR: TSearchRec;
    iFile: integer;
  begin
    iFile := FindFirst(sArquivo, faAnyFile, SR);
    while iFile = 0 do
    begin
      if (SR.Attr and faDirectory) <> faDirectory then
      begin
        if SR.Name <> '' then
          DeleteFile('c:\' + SR.Name);
      end;
      iFile := FindNext(SR);
    end;
  end;

  function ArquivoCOTEPE1704(sArquivo: String): String;
  var
    SR: TSearchRec;
    iFile: integer;
  begin
    Result := '';
    iFile := FindFirst(sArquivo, faAnyFile, SR);
    while iFile = 0 do
    begin
      if (SR.Attr and faDirectory) <> faDirectory then
      begin
        if SR.Name <> '' then
          Result := 'c:\' + sr.Name;
      end;
      iFile := FindNext(SR);
    end;
  end;
  procedure EliminaFalsoEAD(sFileNameOrigem: String; sFileNameDestino: String);
  // Sandro Silva 2016-03-05 POLIMIG Copia arquivo gerado pelo ECF para outro arquivo para efetuar a assinatura
  var
    tfOrigem: TextFile;
    tfDestino: TextFile;
    sLinha: String;
    iLinha: Integer;
  begin
    if FileExists(sFileNameOrigem) then
    begin
      AssignFile(tfOrigem, sFileNameOrigem);
      Reset(tfOrigem);

      AssignFile(tfDestino, sFileNameDestino);
      Rewrite(tfDestino);

      sLinha := '';
      iLInha := 0;
      while not Eof(tfOrigem) do
      begin
        ReadLn(tfOrigem, sLinha);
        if Copy(sLinha, 1, 3) = 'EAD' then
        begin
          Writeln(tfDestino);
          Break;
        end
        else
        begin
          if iLinha > 0 then
            Writeln(tfDestino);
          Write(tfDestino, sLinha);
          Inc(iLinha);
        end;
      end;
      CloseFile(tfOrigem);
      CloseFile(tfDestino);
    end;
  end;
begin
  I := 1; // Sandro Silva 2016-04-01
  {Sandro Silva 2017-08-02 inicio}
  if (Form7.sMfd = 'MFPERIODO') or (Form7.sMfd = 'MFDPERIODO') then
  begin

    if (Form7.sMfd = 'MFPERIODO')then
    begin
      //
      while FileExists(pP1) do
      begin
        DeleteFile(pchar(pP1));
        Sleep(10);
      end;
      //
      try
        I := Bematech_FI_DownloadMF(AnsiString(pP1)); // Sandro Silva 2023-12-13 I := Bematech_FI_DownloadMF(PChar(pP1));
        _ecf02_CodeErro(I);
      except
        ShowMessage('Erro ao gravar o arquivo MF.');
      end;
      //
      Screen.Cursor := crDefault; // Cursor normal
      //
      while not FileExists(pP1) do
      begin
        Sleep(10);
      end;
      //
      Screen.Cursor := crDefault; // Cursor normal
      Result := (I = 1); // True;
      //
    end
    else
    begin

      cArquivoOrigem := pP1;
      cTipoDownload  := '1';
      cCOOInicial    := AllTrim(pp2);
      cCOOFinal      := AllTrim(pp3);
      cUsuario       := '1';

      I := Bematech_FI_DownloadMFD(AnsiString(cArquivoOrigem), AnsiString(cTipoDownload), AnsiString(cCOOInicial), AnsiString(cCOOFinal), AnsiString(cUsuario)); // Sandro Silva 2023-12-13 I := Bematech_FI_DownloadMFD(pchar(cArquivoOrigem), pchar(cTipoDownload), pchar(cCOOInicial), pchar(cCOOFinal), pchar(cUsuario));

      _ecf02_CodeErro(I);

      while not FileExists(pP1) do
      begin
        Sleep(10);
      end;
      //
      Screen.Cursor := crDefault; // Cursor normal
      Result := (I = 1); // True;

    end;

  end
  else
  begin
  {Sandro Silva 2017-08-02 final}
    //
    if Form7.sMfd = 'MFCOMPLETA' then
    begin
      //
      while FileExists(pP1) do
      begin
        DeleteFile(pchar(pP1));
        Sleep(10);
      end;
      //
      try
        _ecf02_CodeErro(Bematech_FI_DownloadMF(AnsiString( pP1 ) )); // Sandro Silva 2023-12-13 _ecf02_CodeErro( Bematech_FI_DownloadMF( pchar( pP1 ) ));
      except
        ShowMessage('Erro ao gravar o arquivo MF.');
      end;
      //
      Screen.Cursor := crDefault; // Cursor normal
      //
      while not FileExists(pP1) do
      begin
        Sleep(10);
      end;
      //
      Screen.Cursor := crDefault; // Cursor normal
      Result := True;
      //
    end else
    begin
      //
      if Form7.sMfd = 'MFDCOMPLETA' then
      begin
        //
        while FileExists(pP1) do
        begin
          DeleteFile(pchar(pP1));
          Sleep(10);
        end;
        //
        while FileExists('C:\DOWNLOAD.MFD') do
        begin
          DeleteFile(pchar('C:\DOWNLOAD.MFD'));
          Sleep(10);
        end;
        //
        try
          //
          cTipoDownload   := '0';
          cArquivoOrigem  := 'C:\DOWNLOAD.MFD';
          cUsuario        := '1';
          //
          cCOOInicial := '000001';
          cCOOFinal := '999999';
          //
          _ecf02_CodeErro(Bematech_FI_DownloadMFD(AnsiString(cArquivoOrigem), AnsiString(cTipoDownload), AnsiString( cCOOInicial ), AnsiString( cCOOFinal ), AnsiString( cUsuario ) )); // Sandro Silva 2023-12-13 _ecf02_CodeErro(Bematech_FI_DownloadMFD( pChar(cArquivoOrigem) , pchar(cTipoDownload) , pchar( cCOOInicial ), pchar( cCOOFinal ) , pchar( cUsuario ) ));
          //
        except
          ShowMessage('Erro ao gravar o arquivo MFD.');
        end;
        //
        if FileExists('c:\download.mfd') then
        begin
          CopyFile(pChar('c:\download.mfd'),pchar(pP1), True );
        end else
        begin
          if FileExists(Form1.sAtual+'\xxx.mfd') then CopyFile(pChar(Form1.sAtual+'\xxx.mfd'),pchar(pP1), True );
        end;
        //
        Screen.Cursor := crDefault; // Cursor normal
        Result := True;
        //
      end else
      begin
        //
        if Form7.Label3.Caption = 'Data inicial:' then
        begin
          cTipoDownload := '1';
          cCOOInicial   := AllTrim(pp2);
          cCOOFinal     := AllTrim(pp3);
        end else
        begin
          cTipoDownload   := '2';
          cCOOInicial := StrZero(StrToInt(pP2),6,0);
          cCOOFinal   := StrZero(StrToInt(pP3),6,0);
        end;
        //
        cArquivoOrigem  := 'C:\DOWNLOAD.MFD';
        cUsuario        := '1';

        if (Form7.sMfd = '0') or (Form7.sMfd = '2') then
        begin
          //
          if (Form7.sMfd = '0') then iTipoGeracao := 0 else iTipoGeracao := 1;
          //
          if cTipoDownload = '1' then
          begin
            cTipoDownload := 'D';
            cDadoInicial  := DateToStr(Form7.DateTimePicker1.Date);
            cDadoFinal    := DateToStr(Form7.DateTimePicker2.Date);
          end;
          //
          if cTipoDownload = '2' then
          begin
            cDadoInicial  := StrZero(StrToInt(Form7.MaskEdit1.Text),6,0);
            cDadoFinal    := StrZero(StrToInt(Form7.MaskEdit2.Text),6,0);
            cTipoDownload := 'C';

            cCOOInicial   := StrZero(StrToInt(Form7.MaskEdit1.Text),6,0);
            cCOOFinal     := StrZero(StrToInt(Form7.MaskEdit2.Text),6,0);
          end;
          //
          sChavePublica := 'DF9F4DC6AF517A889BCE1181DEF8394455DBCD19768E8C785D9121E8DB9B9B104E5231EE8F8299D24451465178D3FC41D40DAFAF9C855824393FC964C747'+
                           '5C3993104443E8E73333D93C24E5D46B27D9A4DF5E6F0B05490B6C6829CEFA1030294DABC29E498A0F6096E8CE26B407B2E1B4939FDE6174EC1621BB3E988D29742D';
          sChavePrivada := Form1.sPasta;

          if Pos('17/04', Form7.Caption) = 0 then
          begin
            iUnicoArquivo   := 1;
            cUsuario        := '1'; // Sandro Silva 2016-03-03
            if Form7.sMfd = '2' then
              I := Bematech_FI_ArquivoMFD( AnsiString( '' ), AnsiString( cDadoInicial ), AnsiString( cDadoFinal ), AnsiString(cTipoDownload), AnsiString( cUsuario ), iTipoGeracao, AnsiString( sChavePublica ), AnsiString( sChavePrivada ), iUnicoArquivo ); // Sandro Silva 2023-12-13 I := Bematech_FI_ArquivoMFD( pchar( '' ), pchar( cDadoInicial ), pchar( cDadoFinal ), pchar(cTipoDownload), pchar( cUsuario ), iTipoGeracao, pchar( sChavePublica ), pchar( sChavePrivada ), iUnicoArquivo );
          end
          else
          begin
            cArquivoOrigem  := 'C:\DOWNLOAD.MFD';
            cUsuario        := '1';

            while FileExists(cArquivoOrigem) do
            begin
              DeleteFile(pchar(cArquivoOrigem));
              Sleep(10);
            end;
            //
            try

              iTipoGeracao  := 1; //2;

              iUnicoArquivo := 1;

              Bematech_FI_ArquivoMFD( AnsiString( '' ), AnsiString( cDadoInicial ), AnsiString( cDadoFinal ), AnsiString( cTipoDownload ), AnsiString( cUsuario ), iTipoGeracao, AnsiString( sChavePublica ), AnsiString( sChavePrivada ), iUnicoArquivo ); // Sandro Silva 2023-12-13 Bematech_FI_ArquivoMFD( pchar( '' ), pchar( cDadoInicial ), pchar( cDadoFinal ), pchar( cTipoDownload ), pchar( cUsuario ), iTipoGeracao, pchar( sChavePublica ), pchar( sChavePrivada ), iUnicoArquivo );

            except
              ShowMessage('Erro ao gravar o arquivo MFD.');
            end;

            i := 1;

          end;

          //
        end else
        begin
          I := Bematech_FI_DownloadMFD(AnsiString(cArquivoOrigem), AnsiString(cTipoDownload), AnsiString( cCOOInicial ), AnsiString( cCOOFinal ), AnsiString( cUsuario ) ); // Sandro Silva 2023-12-13 I := Bematech_FI_DownloadMFD( pChar(cArquivoOrigem) , pchar(cTipoDownload) , pchar( cCOOInicial ), pchar( cCOOFinal ) , pchar( cUsuario ) );
        end;
        //
        if I = 1 then
        begin
          //
          cTipoFormato    := '0';
          cUsuario        := '1';
          //

          if Form7.sMfd = '2' then
          begin
            if Pos('17/04', Form7.Caption) = 0 then
            begin
              sArqDestino := ArquivoCOTEPE1704('C:\MFD' + Form1.sNumeroDeSerieDaImpressora + '_' + FormatDateTime('yyyymmdd', Date) + '_*.*');
              if FileExists(sArqDestino) then
                CopyFile(PChar(sArqDestino), PChar(Form1.SaveDialog1.FileName), False);
            end;

            {Sandro Silva 2016-03-05 POLIMIG inicio}
            if Pos('17/04', Form7.Caption) > 0 then
            begin
              sArqDestino := ArquivoCOTEPE1704('C:\MFD' + Form1.sNumeroDeSerieDaImpressora + '_' + FormatDateTime('yyyymmdd', Date) + '_*.*');
              if FileExists(sArqDestino) then
                EliminaFalsoEAD(PChar(sArqDestino), PChar(ExtractFilePath(sArqDestino) + Form1.sNumeroDeSerieDaImpressora + '_1704.txt'));
              CopyFile(PChar(ExtractFilePath(sArqDestino) + Form1.sNumeroDeSerieDaImpressora + '_1704.txt'), PChar(Form1.SaveDialog1.FileName), False);
              DeleteFile(PChar(ExtractFilePath(sArqDestino) + Form1.sNumeroDeSerieDaImpressora + '_1704.txt'));
              DeleteFile(PChar(sArqDestino));
            end;
            {Sandro Silva 2016-03-05 POLIMIG final}

            ShowMessage('O arquivo '+AllTrim(Form1.SaveDialog1.FileName)+' foi gravado na pasta: '+Form1.sAtual);
          end;

          //
          if Form7.sMfd = '1' then
          begin
            //
            if FileExists(pchar(cArquivoOrigem)) then
            begin
              //
              cTipoFormato    := '0';
              cUsuario        := '1';
              cArquivoDestino := Form1.SaveDialog1.FileName;
              //
              {Sandro Silva 2023-12-13 inicio
              I := Bematech_FI_FormatoDadosMFD( pchar( cArquivoOrigem ),
                                                pchar( cArquivoDestino ),
                                                pchar( cTipoFormato ),
                                                pchar( cTipoDownload ),
                                                pchar( cCOOInicial ),
                                                pchar( cCOOFinal ),
                                                pchar( cUsuario ) );
              }
              I := Bematech_FI_FormatoDadosMFD( AnsiString( cArquivoOrigem ),
                                                AnsiString( cArquivoDestino ),
                                                AnsiString( cTipoFormato ),
                                                AnsiString( cTipoDownload ),
                                                AnsiString( cCOOInicial ),
                                                AnsiString( cCOOFinal ),
                                                AnsiString( cUsuario ) );
              {Sandro Silva 2023-12-13 fim}
              //
            end;
          end;
          //
          if Form7.sMfd = '0' then
          begin
            {
            if FileExists(pchar(cArquivoOrigem)) then
            begin
              ShowMessage('Final: COTEPE 17/04 por DATA');
              //
              cArquivoDestino := Form1.SaveDialog1.FileName;
              //
              I := BemaGeraRegistrosTipoE(pchar( cArquivoOrigem ),
                                          pchar( cArquivoDestino ),
                                          pchar( cCOOInicial ),
                                          pchar( cCOOFinal ),
                                          pchar('TESTE'),
                                          pchar('TESTE'), '',
                                          pchar('2'), '', '', '', '', '', '', '', '', '', '', '', '', '');
              //
            end;
             }
          end;
          //
          if I = 1 then
          begin
            Result := True
          end
          else
          begin
             ShowMessage('Erro: '+IntToStr(I));
             Result := False;
          end;
          //
        end else
        begin
          ShowMessage('Erro: '+IntToStr(I));
          Result := False;
        end;
        //
      end;
    end;
  end; // if (Form7.sMfd = 'MFPERIODO') or (Form7.sMfd = 'MFDPERIODO') then
  //
end;

function _ecf02_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
begin
//  showmessage(pP1+chr(10)+pP2);
// ShowMessage(Form1.sTipo);
  if Form7.Label3.Caption = 'Data inicial:' then
  begin
    Result:=(_ecf02_CodeErro(Bematech_FI_LeituraMemoriaFiscalDataMFD(AnsiString(pP1), AnsiString(pP2), AnsiString(Form1.sTipo)))=1); // Sandro Silva 2023-12-13 Result:=(_ecf02_CodeErro(Bematech_FI_LeituraMemoriaFiscalDataMFD( pchar( pP1 ), pchar( pP2 ), pChar(Form1.sTipo)))=1);
//    Result:=(_ecf02_CodeErro(Bematech_FI_LeituraMemoriaFiscalData( pchar( pP1 ), pchar( pP2 ) ))=1)
  end else
  begin
    Result:=(_ecf02_CodeErro(Bematech_FI_LeituraMemoriaFiscalReducaoMFD(AnsiString( pP1 ), AnsiString( pP2 ), AnsiString(Form1.sTipo)))=1); // Sandro Silva 2023-12-13 Result:=(_ecf02_CodeErro(Bematech_FI_LeituraMemoriaFiscalReducaoMFD( pchar( pP1 ), pchar( pP2 ), pChar(Form1.sTipo)))=1);
//    Result:=(_ecf02_CodeErro(Bematech_FI_LeituraMemoriaFiscalReducao( pchar( pP1 ), pchar( pP2 ) ))=1);
  end;
end;


// -------------------------------- //
// Venda do Item                    //
// -------------------------------- //
function _ecf02_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
var
  sIndice, sAcresc : string;
  I : Integer;
begin
  //
  if LimpaNumero(pP3) = pP3 then
  begin
    pP3 := Copy(Form1.sAliquotas,((StrToInt(pP3)*4)-1),4);
  end;

  if StrToInt(pP7) > 0 then pP8 := StrZero(((StrToInt(pP5)/1000)*(StrToInt(pp4)/1000)*(StrToInt(pp7)/10)),7,0);
  //
  pP5 := pP5 + '0';
  //
  sIndice  := '00';
  sAcresc  := '00';
  //
  {Sandro Silva 2023-12-13 inicio
  I := Bematech_FI_VendeItemDepartamento(pchar( pP1 ),    // Código
                                         pchar( pP2 ),    // Descricao
                                         pchar( pP3 ),    // ST
                                         pchar( pP5 ),    // Valor Unitário
                                         pchar( pP4 ),    // Quantidade
                                         pchar( sAcresc), // Acréscimo
                                         pchar( pP8 ),    // Desconto
                                         pchar( sIndice ),// Índice do departamento
                                         pchar( pP6 )     // Unidade medida
                                         );
  }
  I := Bematech_FI_VendeItemDepartamento(AnsiString( pP1 ),    // Código
                                         AnsiString( pP2 ),    // Descricao
                                         AnsiString( pP3 ),    // ST
                                         AnsiString( pP5 ),    // Valor Unitário
                                         AnsiString( pP4 ),    // Quantidade
                                         AnsiString( sAcresc), // Acréscimo
                                         AnsiString( pP8 ),    // Desconto
                                         AnsiString( sIndice ),// Índice do departamento
                                         AnsiString( pP6 )     // Unidade medida
                                         );
  {Sandro Silva 2023-12-13 fim}
//  if I <> 1 then
  _ecf02_CodeErro(I);
  //
  if I=1 then Result := True else Result := False;
  //
end;

// -------------------------------- //
// Reducao Z                        //
// -------------------------------- //
function _ecf02_ReducaoZ(pP1: Boolean):Boolean;
var
  iRetorno: Integer;
begin
  //
  // Sandro Silva 2017-06-19  Bematech_FI_ReducaoZ(pChar(''),pChar(''));
  iRetorno := Bematech_FI_ReducaoZ(AnsiString(''), AnsiString(''));  // Sandro Silva 2023-12-13   iRetorno := Bematech_FI_ReducaoZ(pChar(''),pChar('')); // Sandro Silva 2017-06-19
  _ecf02_CodeErro(iRetorno); // Sandro Silva 2017-06-19
  //Bematech_FI_ReducaoZ(pChar(''),pChar('18:10:00'));
  Result := True;
  //
end;

// -------------------------------- //
// Leitura X                        //
// -------------------------------- //
function _ecf02_LeituraX(pP1: Boolean):Boolean;
begin
  Result:=(Bematech_FI_LeituraX()=1);
end;

// ---------------------------------------------- //
// Retorna se o horario de verão está selecionado //
// ---------------------------------------------- //
function _ecf02_RetornaVerao(pP1: Boolean):Boolean;
var
  I : Integer;
begin
  if Bematech_FI_FlagsFiscais( I )=1 then Result:=(Copy(Right(Replicate('0',8)+IntToBin( I ),8),6,1)='1') else Result:=False;
end;

// -------------------------------- //
// Liga ou desliga horário de verao //
// -------------------------------- //
function _ecf02_LigaDesLigaVerao(pP1: Boolean):Boolean;
begin
  Result:=(Bematech_FI_ProgramaHorarioVerao()=1);
end;

// -------------------------------- //
// Retorna a versão do firmware     //
// -------------------------------- //
function _ecf02_VersodoFirmware(pP1: Boolean): String;
begin
  Result:=Replicate(' ',4);
  SleepEntreMetodos; // Sandro Silva 2019-08-30 ER 02.06 UnoChapeco
  if Bematech_FI_VersaoFirmware(Result) <> 1 then Result:='';

end;

// -------------------------------- //
// Retorna o número de série        //
// -------------------------------- //
function _ecf02_NmerodeSrie(pP1: Boolean): String;
var
  I: Integer;
begin
  SleepEntreMetodos; // Sandro Silva 2019-08-30 ER 02.06 UnoChapeco
  //
  if Form1.sMFD_ = 'Sim' then
  begin
    Result := Replicate(' ',20);
    Bematech_FI_NumeroSerieMFD(Result);
    //
    if Length(Alltrim(Result)) <> 20 then
    begin
      //
      if _ecf02_CodeErro(Bematech_FI_NumeroSerie(Result))<> 1 then Result:='';
      for i:=1 to 20 do if ord(Result[i])=0 then break;
      if I > 0 then Result:=AllTrim(Copy(Result,1,i-1));
      //
    end;
  end else
  begin
     Result := replicate(' ',20);
     if _ecf02_CodeErro(Bematech_FI_NumeroSerie(Result))<> 1 then Result:='';
     for i:=1 to 20 do if ord(Result[i])=0 then break;
     if I > 0 then Result:=AllTrim(Copy(Result,1,i-1));
  end;
  //
  {
  //
  if Form1.sMFD_ = 'Sim' then
  begin
    //2015-09-01 Result := Replicate(' ',20);
    Result := Replicate(' ',21);
    Bematech_FI_NumeroSerieMFD(Result);
    //ShowMessage('Teste 1 Form1.sMFD_ ' + Form1.sMFD_ + #13 + ' Num. série ecf - Bematech_FI_NumeroSerieMFD: "' + Result + '"' +
    //         #13 + '"' + Copy(Result, 20, 1) + '"');

    //
    //2015-09-31 if Length(Alltrim(Result)) <> 20 then
    if Copy(Result, 20, 1) = ' ' then
    begin
      //
      if _ecf02_CodeErro(Bematech_FI_NumeroSerie(Result))<> 1 then Result:='';

      //ShowMessage('Teste 1 Num. série ecf <> 20 - Bematech_FI_NumeroSerie: ' + Result);

      for i:=1 to 20 do if ord(Result[i])=0 then break;
      if I > 0 then Result:=AllTrim(Copy(Result,1,i-1));

      //ShowMessage('Teste 1 Num. série ecf <> 20 - depois de recortar: ' + Result);

      //
    end
    else
      Result := Copy(Result, 1, 20);

    //ShowMessage('Teste 1 Form1.sMFD_ ' + Form1.sMFD_ + #13 + ' Num. série ecf - Bematech_FI_NumeroSerieMFD: "' + Result + '"');

  end else
  begin
     // 2015-09-01 Result := replicate(' ',20);
     Result := replicate(' ',21);
     if _ecf02_CodeErro(Bematech_FI_NumeroSerie(Result))<> 1 then Result:='';

     //ShowMessage('Teste 1 Form1.sMFD_ ' + Form1.sMFD_ + #13 + ' Num. série ecf = 20 - Bematech_FI_NumeroSerie: ' + Result);

     for i:=1 to 20 do if ord(Result[i])=0 then break;
     if I > 0 then Result:=AllTrim(Copy(Result,1,i-1));

     //ShowMessage('Teste 1 Num. série ecf = 20 - depois de recortar: ' + Result);

  end;
  //

  //ShowMessage('Teste 1 Num. série ecf ' + Result);
  }
end;

// -------------------------------- //
// Retorna o CGC e IE               //
// -------------------------------- //
function _ecf02_CGCIE(pP1: Boolean): String;
var
  sCGC,sIE:string;
begin
  sCGC := Replicate(' ',18);
  sIE  := Replicate(' ',15);
  if _ecf02_CodeErro(Bematech_FI_CGC_IE( sCGC, sIE )) <> 1 then Result := '' else Result := sCGC+'-'+sIE;
end;

// --------------------------------- //
// Retorna o valor  de cancelamentos //
// --------------------------------- //
function _ecf02_Cancelamentos(pP1: Boolean): String;
begin
  Result:=Replicate(' ',14);
  if Bematech_FI_Cancelamentos( Result ) <> 1 then Result:='';
end;

// -------------------------------- //
// Retorna o valor de descontos     //
// -------------------------------- //
function _ecf02_Descontos(pP1: Boolean): String;
begin
  Result:=Replicate(' ',14);
  if Bematech_FI_Descontos( Result ) <> 1 then Result:='';
end;

// -------------------------------- //
// Retorna o contador sequencial    //
// -------------------------------- //
function _ecf02_ContadorSeqencial(pP1: Boolean): String;
begin
  Result:=Replicate(' ',6);
  if Bematech_FI_NumeroCupom( Result ) <> 1 then Result:='';
end;

// -------------------------------- //
// Retorna o número de operações    //
// não fiscais acumuladas           //
// -------------------------------- //
function _ecf02_Nmdeoperaesnofiscais(pP1: Boolean): String;
begin
  Result:=Replicate(' ',631);
  if Bematech_FI_DadosUltimaReducao( Result ) <> 1 then Result:='' else Result:=Copy(Result,586,6);
end;

function _ecf02_NmdeCuponscancelados(pP1: Boolean): String;
begin
  Result:=Replicate(' ',4);
  if (Bematech_FI_NumeroCuponsCancelados( Result ) <> 1) then Result:='';
end;

function _ecf02_NmdeRedues(pP1: Boolean): String;
begin
  Result:=Replicate(' ',4);
  SleepEntreMetodos; // Sandro Silva 2019-08-30 ER 02.06 UnoChapeco
  if (Bematech_FI_NumeroReducoes( Result ) <> 1) then Result:='' else Result:=StrZero(StrToInt(Result)+1,4,0);//soma um para gravar certo no arq. de reduções.

end;

function _ecf02_Nmdeintervenestcnicas(pP1: Boolean): String;
begin
  Result:=Replicate(' ',4);
  SleepEntreMetodos; // Sandro Silva 2019-08-30 ER 02.06 UnoChapeco
  if (Bematech_FI_NumeroIntervencoes( Result ) <> 1) then Result:='';
end;


function _ecf02_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
begin
  Result:=Replicate(' ',4);
  if (Bematech_FI_NumeroSubstituicoesProprietario( Result ) <> 1) then Result:='';
end;

function _ecf02_Clichdoproprietrio(pP1: Boolean): String;
begin
  Result:=Replicate(' ',186);
  if (Bematech_FI_ClicheProprietario( Result ) <> 1) then Result:='';
end;

// ------------------------------------ //
// Importante retornar apenas 3 dígitos //
// Ex: 001                              //
// ------------------------------------ //
function _ecf02_NmdoCaixa(pP1: Boolean): String;
var
  i: Integer;
begin
  //
  Result:=Replicate(' ',4);
  SleepEntreMetodos; // Sandro Silva 2019-08-30 ER 02.06 UnoChapeco  
  // Sandro Silva 2018-10-04  _ecf02_CodeErro(Bematech_FI_NumeroCaixa( Result ));
  i := 0;
  while Trim(Result) = '' do
  begin
    inc(i);
    _ecf02_CodeErro(Bematech_FI_NumeroCaixa( Result ));
    if (Trim(Result) <> '') or (i > 3) then
      Break;
    Sleep(1000);
  end;
  Result := Right(AllTrim(pChar(Result)),3);
  //
end;

function _ecf02_Nmdaloja(pP1: Boolean): String;
begin
  Result:=Replicate(' ',4);
  _ecf02_CodeErro(Bematech_FI_NumeroLoja( Result ));
end;

function _ecf02_Moeda(pP1: Boolean): String;
begin
  Result:=Replicate(' ',2);
  _ecf02_CodeErro(Bematech_FI_SimboloMoeda( Result ));
  Result:=StrTran(AllTrim(Result),'$','');
end;

function _ecf02_Dataehoradaimpressora(pP1: Boolean): String;
var
  sData,sHora:String;
  //I : Integer;
begin
 sData := Replicate(' ',6);
 sHora := Replicate(' ',6);
 SleepEntreMetodos; // Sandro Silva 2019-08-30 ER 02.06 UnoChapeco
 // _ecf02_CodeErro(Bematech_FI_DataHoraImpressora(sData,sHora));
 Bematech_FI_DataHoraImpressora(sData,sHora);

 //ShowMessage('Teste 1');
 //_ecf02_CodeErro(I);

 //
 // ShowMessage(sData+sHora);
 //
 Result:=StrTran(sData+sHora,',','');//DDMMAAHHMMSS
 //
 // ShowMessage(Result);
 //

end;

function _ecf02_Datadaultimareduo(pP1: Boolean): String;
begin
  Result:=Replicate(' ',6);
  SleepEntreMetodos; // Sandro Silva 2019-08-30 ER 02.06 UnoChapeco
  if Bematech_FI_DataMovimento( Result ) <> 1 then Result:='';
end;


function _ecf02_Datadomovimento(pP1: Boolean): String;
begin
  Result:=Replicate(' ',6);
  if Bematech_FI_DataMovimento( Result ) <> 1 then Result:='';
end;

// Deve retornar uma String com:                                          //
// Os 2 primeiros dígitos são o número de aliquotas gravadas: Ex 16       //
// os póximos de 4 em 4 são as aliquotas Ex: 1800                         //
// Ex: 161800120005000000000000000000000000000000000000000000000000000000 //
// retorna + 64 caracteres quando tem ISS                                 //

function _ecf02_VerificaAliquotasIss: String;
var
  AliquotasIss: String;
  iRetorno: Integer;
begin
  try
    AliquotasIss := Replicate(' ',79);
    SleepEntreMetodos; // Sandro Silva 2019-08-30 ER 02.06 UnoChapeco    
    iRetorno := Bematech_FI_VerificaAliquotasIss( AliquotasIss );
    Result := PansiChar(AliquotasIss);
    if _ecf02_CodeErro(iRetorno) <> 1 then
    begin
      Result := '';
    end;
  except
    Result := '';
  end;
end;

function _ecf02_RetornaAliquotas(pP1: Boolean): String;
var
  sISS, sAliquotas, sIndiceAliquotas : String;
  i:integer;
begin
//  AliquotasIss:=Replicate(' ',79);
//  iRetorno := Bematech_FI_VerificaAliquotasIss( AliquotasIss );
  Result:='';
  // 2015-08-18 sAliquotas := Replicate(' ',79);
  sAliquotas := Replicate(' ',80); // Retorna 80 posições
  if _ecf02_CodeErro(Bematech_FI_RetornoAliquotas( sAliquotas ))=1 then
  begin
    Result:=Copy(AllTrim(LimpaNumero(sAliquotas))+Replicate('0',64),1,64);//tira as vírgulas
    sISS:='';
    //verifica qual é a aliquota de ISS
    sIndiceAliquotas:=Replicate(' ',48);
    if _ecf02_CodeErro(Bematech_FI_VerificaIndiceAliquotasIss( sIndiceAliquotas ))=1 then
    begin
      for i:=1 to 16 do
      begin
         if pos(StrZero(i,2,0),sIndiceAliquotas) > 0 then
          begin
            sISS:=sISS+Copy(Result,((i-1)*4)+1,4);
          end
         else
            sISS:=sISS+'0000';
      end;
      //showmessage(Result+chr(10)+inttostr(Length(Result)));
      Result:='16'+Result+sISS;
      //showmessage(Result+chr(10)+inttostr(Length(Result)));
    end;
  end;

end;


function _ecf02_Vincula(pP1: String): Boolean;
begin
   Result:=False;
end;


function _ecf02_FlagsDeISS(pP1: Boolean): String;
var
  sIndiceAliquotas:string;
begin
  sIndiceAliquotas:=Replicate('0',48);
  Bematech_FI_VerificaIndiceAliquotasIss( sIndiceAliquotas );
  //o retorno é a alíquota separada por vírgula
  Result:=Replicate('0',16);
  sIndiceAliquotas:=AllTrim(sIndiceAliquotas);
  if StrToInt('0'+Copy(sIndiceAliquotas,1,2)) > 0 then
  begin
    delete(Result,StrToInt('0'+Copy(sIndiceAliquotas,1,2)),1);
    insert('1',Result,StrToInt('0'+Copy(sIndiceAliquotas,1,2)));
    delete(sIndiceAliquotas,1,2);
  end;
  While Copy(sIndiceAliquotas,1,1) = ',' do
  begin
    delete(sIndiceAliquotas,1,1);
    if StrToInt('0'+Copy(sIndiceAliquotas,1,2)) > 0 then
    begin
      delete(Result,StrToInt('0'+Copy(sIndiceAliquotas,1,2)),1);
      insert('1',Result,StrToInt('0'+Copy(sIndiceAliquotas,1,2)));
      delete(sIndiceAliquotas,1,2);
    end;
  end;
  Result := chr(BinToInt(Copy(Result,1,8)))+chr(BinToInt(Copy(Result,9,8)));
end;

function _ecf02_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
begin
  Bematech_FI_FechaPortaSerial();
  Result:=True;
end;

function _ecf02_MudaMoeda(pP1: String): Boolean;
begin
  Result := (_ecf02_CodeErro(Bematech_FI_AlteraSimboloMoeda( AnsiString( pP1 ) )) = 1) // Sandro Silva 2023-12-13 Result := (_ecf02_CodeErro(Bematech_FI_AlteraSimboloMoeda( pchar( pP1 ) ))=1)
end;

function _ecf02_MostraDisplay(pP1: String): Boolean;
begin
  Result := True;
end;

function _ecf02_leituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
begin
  //
  Screen.Cursor := crHourGlass; // Cursor de Aguardo
  //
  if Form7.Label3.Caption = 'Data inicial:' then
  begin
    pP2 := DateToStr(Form7.DateTimePicker1.Date);
    pP3 := DateToStr(Form7.DateTimePicker2.Date);
    Bematech_FI_LeituraMemoriaFiscalSerialDataMFD( AnsiString( pP2 ), AnsiString( pP3 ), AnsiString(Form1.sTipo) ); // Sandro Silva 2023-12-13 Bematech_FI_LeituraMemoriaFiscalSerialDataMFD( pchar( pP2 ), pchar( pP3 ), pChar(Form1.sTipo) );
  end else
  begin
    Bematech_FI_LeituraMemoriaFiscalSerialReducaoMFD( AnsiString( pP2 ), AnsiString( pP3 ), AnsiString(Form1.sTipo) ); // Sandro Silva 2023-12-13 Bematech_FI_LeituraMemoriaFiscalSerialReducaoMFD( pchar( pP2 ), pchar( pP3 ), pChar(Form1.sTipo) );
  end;
  //
  CopyFile('c:\retorno.txt', pChar(pP1), True );
  //
  Screen.Cursor := crDefault; // Cursor normal
  Result := True;
  //
end;


function _ecf02_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean; //iP2 = Número do Cupom vinculado
var
  J, I: Integer;
  sLinha: String;
begin
  Result := False;
  //
  {Sandro Silva 2023-12-13 inicio
  if Form1.ibDataSet25DIFERENCA_.AsFloat > 0 then Result := (Bematech_FI_AbreComprovanteNaoFiscalVinculado( pchar('Prazo'),  pchar(''), pchar(''))=1);
  //  if Form1.fTEFPago                      > 0 then Result := (Bematech_FI_AbreComprovanteNaoFiscalVinculado( pchar('Cartao '+Form1.sDebitoOuCredito), pchar(''), pchar(''))=1);
  //  if Form1.fTEFPago                      > 0 then Result := (Bematech_FI_AbreComprovanteNaoFiscalVinculado( pchar('Cartao'), pchar(''), pchar(''))=1);
  if Form1.fTEFPago                      > 0 then Result := (Bematech_FI_AbreComprovanteNaoFiscalVinculado( pchar('Cartao'), pChar(StrZero(Form1.fTEFPago*100,12,0)), pChar(FormataNumeroDoCupom(Form1.icupom)) )=1); // Sandro Silva 2021-11-29 if Form1.fTEFPago                      > 0 then Result := (Bematech_FI_AbreComprovanteNaoFiscalVinculado( pchar('Cartao'), pChar(StrZero(Form1.fTEFPago*100,12,0)), pChar(StrZero(Form1.icupom,6,0)) )=1);
  if Form1.ibDataSet25ACUMULADO1.AsFloat > 0 then Result := (Bematech_FI_AbreComprovanteNaoFiscalVinculado( pchar('Cheque'), pchar(''), pchar(''))=1);
  }
  if Form1.ibDataSet25DIFERENCA_.AsFloat > 0 then
    Result := (Bematech_FI_AbreComprovanteNaoFiscalVinculado( AnsiString('Prazo'),  AnsiString(''), AnsiString('')) = 1);
  if Form1.fTEFPago                      > 0 then
    Result := (Bematech_FI_AbreComprovanteNaoFiscalVinculado( AnsiString('Cartao'), AnsiString(StrZero(Form1.fTEFPago * 100, 12, 0)), AnsiString(FormataNumeroDoCupom(Form1.icupom))) = 1);
  if Form1.ibDataSet25ACUMULADO1.AsFloat > 0 then
    Result := (Bematech_FI_AbreComprovanteNaoFiscalVinculado( AnsiString('Cheque'), AnsiString(''), AnsiString('')) = 1);
  {Sandro Silva 2023-12-13 fim}
  if Result then
  begin
    //
    for J := 1 to 1 do
    begin
      //
      Result := (Bematech_FI_VerificaImpressoraLigada()=1);
      //
      if Result then
      begin
        //
        sLinha := '';
        for I := 1 to Length(sP1) do
        begin
          if Result = True then
          begin
            if Copy(sP1,I,1) <> chr(10) then
            begin
              sLinha := sLinha+Copy(sP1,I,1);
            end else
            begin
              if sLinha = '' then
                sLinha := ' ';
              if Form1.sCRLF = 'Sim' then
                sLinha := sLinha + Chr(10);
              Result := _ecf02_TestaLigadaePapel(true);
              if Result then
                Result := (Bematech_FI_UsaComprovanteNaoFiscalVinculado( AnsiString( sLinha ) )=1); // Sandro Silva 2023-12-13 if Result then Result := (Bematech_FI_UsaComprovanteNaoFiscalVinculado( pchar( sLinha ) )=1);
              if Result then
                Result := _ecf02_TestaLigadaePapel(true);
              sLinha := '';
            end;
          end;
        end;
      end;
      //
      if Result = True then
      begin
        sLinha := Chr(10)+chr(10)+Chr(10);
        Result := _ecf02_TestaLigadaePapel(true);
        if Result then
          Result := (Bematech_FI_UsaComprovanteNaoFiscalVinculado( AnsiString( sLinha ) ) = 1); // Sandro Silva 2023-12-13 if Result then Result:=(Bematech_FI_UsaComprovanteNaoFiscalVinculado( pchar( sLinha ) )=1);
        if Result then
          Result := _ecf02_TestaLigadaePapel(true);
      end;
      //
    end;
  end;
  //
  Bematech_FI_FechaComprovanteNaoFiscalVinculado();
  //
end;

function _ecf02_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
var
  //
  I, J, iResult : Integer;
  sGRG, sLinha: String;
  tInicio : tTime;
  Hora, Min, Seg, cent : Word;
  bImprimindoConferenciaMesa: Boolean; // 2015-09-08 Indica quando está fazendo a impressão do TEF. Envia linha a linha para a impressora
  //
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
      for i := 600 downto 1 do
      begin
         if Copy(sTexto, i, 1) = Chr(10) then
         begin
           bQuebra := True;
           Break;
         end;
      end;

      if bQuebra = False then
        sTexto2 := Copy(sTexto, 1, 600)
      else
        sTexto2 := Copy(sTexto, 1, i);
        Result := Bematech_FI_UsaRelatorioGerencialMFD(sTexto2);
        if Result <> 1 then
          Break;
      sTexto := StringReplace(sTexto, sTexto2, '', [rfIgnoreCase]);
    end;
  end;
begin
  bImprimindoConferenciaMesa := True;
  //
  if _ecf02_TestaLigadaePapel(true)
   or (Pos('IDENTIFICAÇÃO DO PAF-ECF',sP1)<>0)  // Sandro Silva 2017-11-07 Polimig
   or (Pos('Parametros de Configuracao',sP1)<>0) // Sandro Silva 2017-11-07 Polimig 
   then
  begin
    //
    tInicio := Time;
    try
      sGRG    := _ecf02_GRG(True); // Guarda o número anterior do Contador de Relatórios Gerenciais
    except end;
    //
    //
    if Pos('IDENTIFICAÇÃO DO PAF-ECF',sP1)<>0 then
    begin
      iResult := Bematech_FI_AbreRelatorioGerencialMFD(AnsiString('02')); // Identificação do PAF // Sandro Silva 2023-12-13 iResult := Bematech_FI_AbreRelatorioGerencialMFD(pchar('02')); // Identificação do PAF
      bImprimindoConferenciaMesa := True
    end else
    begin
      if Pos('Período Solicitado: de', sP1)<>0 then
      begin
        iResult := Bematech_FI_AbreRelatorioGerencialMFD(AnsiString('05')); // Meios de pagamento // Sandro Silva 2023-12-13 iResult := Bematech_FI_AbreRelatorioGerencialMFD(pchar('05')); // Meios de pagamento
      end else
      begin
        if (Pos('Documento: ', sP1) <> 0) or (Pos(TITULO_PARCELAS_CARNE_RESUMIDO, sP1) > 0) then  // Sandro Silva 2018-04-29  if Pos('Documento: ',sP1)<>0 then
        begin
          iResult := Bematech_FI_AbreRelatorioGerencialMFD(AnsiString('03')); // Venda a prazo // Sandro Silva 2023-12-13 iResult := Bematech_FI_AbreRelatorioGerencialMFD(pchar('03')); // Venda a prazo
        end else
        begin
          if Pos('DAV EMITIDOS',sP1)<>0 then
          begin
            iResult := Bematech_FI_AbreRelatorioGerencialMFD(AnsiString('06')); // DAV Emitidos // Sandro Silva 2023-12-13 iResult := Bematech_FI_AbreRelatorioGerencialMFD(pchar('06')); // DAV Emitidos
          end else
          begin
            if Pos('AUXILIAR DE VENDA (DAV) - OR',sP1)<>0 then
            begin
              iResult := Bematech_FI_AbreRelatorioGerencialMFD(AnsiString('07')); // Orçamento (DAV) // Sandro Silva 2023-12-13 iResult := Bematech_FI_AbreRelatorioGerencialMFD(pchar('07')); // Orçamento (DAV)
            end else
            begin
              if Pos('CONFERENCIA DE CONTA',sP1)<>0 then
              begin
                iResult := Bematech_FI_AbreRelatorioGerencialMFD(AnsiString('08')); // Conferencia de contas // Sandro Silva 2023-12-13 iResult := Bematech_FI_AbreRelatorioGerencialMFD(pchar('08')); // Conferencia de contas
                bImprimindoConferenciaMesa := True
              end else
              begin
                if Pos('TRANSFERENCIAS ENTRE CONTA',sP1)<>0 then
                begin
                  iResult := Bematech_FI_AbreRelatorioGerencialMFD(AnsiString('09')); // Transferencia entre contas // Sandro Silva 2023-12-13 iResult := Bematech_FI_AbreRelatorioGerencialMFD(pchar('09')); // Transferencia entre contas
                end else
                begin
                  // Sandro Silva 2016-02-04 POLIMIG  if (Pos('CONTAS DE CLIENTES ABERTAS',sP1)<>0) or (Pos('CONTAS DE CLIENTES OS ABERTAS',sP1)<>0) or (Pos('NENHUMA',sP1)<>0) then
                  if (Pos('CONTAS DE CLIENTES ABERTAS',sP1)<>0)
                    or (Pos('CONTAS DE CLIENTES OS ABERTAS',sP1)<>0)
                    or ((Pos('NENHUMA',sP1)<>0) and (Pos('CONTA DE CLIENTE',sP1)<>0)) then
                  begin
                    iResult := Bematech_FI_AbreRelatorioGerencialMFD(AnsiString('10')); // Mesas contas // Sandro Silva 2023-12-13 iResult := Bematech_FI_AbreRelatorioGerencialMFD(pchar('10')); // Mesas contas
                  end else
                  begin
                    if Pos('CONFERENCIA DE MESA',sP1)<>0 then
                    begin
                      iResult := Bematech_FI_AbreRelatorioGerencialMFD(AnsiString('11')); // Conferencia de contas // Sandro Silva 2023-12-13 iResult := Bematech_FI_AbreRelatorioGerencialMFD(pchar('11')); // Conferencia de contas
                      bImprimindoConferenciaMesa := True
                    end else
                    begin
                      if Pos('TRANSFERENCIAS ENTRE MESA',sP1)<>0 then
                      begin
                        iResult := Bematech_FI_AbreRelatorioGerencialMFD(AnsiString('12')); // Transferencia entre contas // Sandro Silva 2023-12-13 iResult := Bematech_FI_AbreRelatorioGerencialMFD(pchar('12')); // Transferencia entre contas
                      end else
                      begin
                        // Sandro Silva 2016-02-04 POLIMIG if Pos('MESAS ABERTAS',sP1)<>0 then
                        if (Pos('MESAS ABERTAS',sP1)<>0) or
                         (Pos('NENHUMA MESA',sP1)<>0) then
                        begin
                          iResult := Bematech_FI_AbreRelatorioGerencialMFD(AnsiString('13')); // Mesas contas // Sandro Silva 2023-12-13 iResult := Bematech_FI_AbreRelatorioGerencialMFD(pchar('13')); // Mesas contas
                        end else
                        begin
                          if Pos('Parametros de Configuracao',sP1)<>0 then
                          begin
                            iResult := Bematech_FI_AbreRelatorioGerencialMFD(AnsiString('14')); // Parâmetros de Configuração // Sandro Silva 2023-12-13 iResult := Bematech_FI_AbreRelatorioGerencialMFD(pchar('14')); // Parâmetros de Configuração
                          end else
                          begin
                            iResult := Bematech_FI_AbreRelatorioGerencialMFD(AnsiString('04')); // Cartão TEF // Sandro Silva 2023-12-13 iResult := Bematech_FI_AbreRelatorioGerencialMFD(pchar('04')); // Cartão TEF
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

    {Sandro Silva 2016-03-01 inicio}
    _ecf02_CodeErro(iResult);
    {Sandro Silva 2016-03-01 final}
    try
      Bematech_FI_FlagsFiscais(I);
      if (I=12) or (I=8) then iResult := 0; // 8 - Já houve redução Z no dia // 32 ?????
    except end;
    //
    // ShowMessage(IntToStr(I));
    //
    if not _ecf02_TestaLigadaePapel(true) then iResult := 0;
    //
    begin
      //
      // iResult := Bematech_FI_VerificaImpressoraLigada();
      //

      ///
      //bImprimindoConferenciaMesa := False;


      if iResult = 1 then
      begin
        //if bImprimindoConferenciaMesa = False then
        if (Form1.sRGTurbo <> 'Sim') or (bImprimindoConferenciaMesa = False) then
        begin
          //
          for J := 1 to 1 do
          begin
            //
            sLinha := '';
            for I := 1 to Length(sP1) do
            begin
              //
              if iResult = 1 then
              begin
                if Copy(sP1,I,1) <> chr(10) then
                begin
                  sLinha := sLinha+Copy(sP1,I,1);
                end else
                begin
                  //
                  if sLinha = '' then sLinha:=' ';
                  if Form1.sCRLF = 'Sim' then sLinha := sLinha + Chr(10);
                  //
                  //
                  if not _ecf02_TestaLigadaePapel(true) then iResult := 0;
                  //
                  if iResult = 1 then
                  begin
                    iResult := Bematech_FI_UsaRelatorioGerencialMFD(AnsiString(sLinha)); // Sandro Silva 2023-12-13 iResult := Bematech_FI_UsaRelatorioGerencialMFD(pchar(sLinha));
                  end;
                  //
                  DecodeTime((Time - tInicio), Hora, Min, Seg, cent);
                  if (Min >= 1) and (Seg >= 30) then
                  begin
                    tInicio := Time;
                    Bematech_FI_FechaRelatorioGerencial();  // Fecha cupom não sujeito ao ICMS
                    Bematech_FI_AbreRelatorioGerencialMFD(AnsiString('04')); // TEP // Sandro Silva 2023-12-13 Bematech_FI_AbreRelatorioGerencialMFD(pchar('04')); // TEP
                  end;
                  //
                  if iResult = 1 then
                  begin
                    Result := _ecf02_TestaLigadaePapel(true);
                    if Result then iResult := 1 else iResult := 0;
                  end;
                  //
                  sLinha:='';
                  //
                  //
                end;
              end;
            end;
          end;
        end
        else if (bImprimindoConferenciaMesa) and (Form1.sRGTurbo = 'Sim') then
        begin // Agilizar a impressão
          // Não usar para o tef
          Imprimir(sP1);
        end; // if bImprimindoTef then

        //
        iResult := Bematech_FI_FechaRelatorioGerencial();  // Fecha cupom não sujeito ao ICMS
        if iResult = 1 then
        begin
          Result := _ecf02_TestaLigadaePapel(true);
          if Result then iResult := 1 else iResult := 0;
        end;
        //
      end; // if iResult = 1 then
      //
      if iResult = 1 then Result := True else Result := False;
      //
    end;
    //
    if Result then
    begin
      if sGRG = _ecf02_GRG(True) then // Garda o número anterior do Contador de Relatórios
      begin
        Result := False;
      end;
    end;
  end else
  begin
    Result := False;
  end;
  //
end;

function _ecf02_FechaCupom2(sP1: Boolean): Boolean;
begin
  Result:=(Bematech_FI_FechaComprovanteNaoFiscalVinculado()=1);
  if not result then Result := (Bematech_FI_FechaRelatorioGerencial()=1);
end;

function _ecf02_ImprimeCheque(rP1: Real; sP2: String): Boolean;
begin
  {Sandro Silva 2015-07-28 inicio
  Result := False;
  if AllTrim(Form1.ibDataSet13.FieldByname('MUNICIPIO').AsString) <> '' then
  begin
    ShowMessage('Posicione o cheque na impressora, e tecle <enter>. '+sP2);
    Result := True;
    if _ecf02_codeErro(Bematech_FI_ImprimeCheque( pchar( sP2 ), pchar( StrZero(rP1*100,14,0) ), pchar( Form1.ibDataSet13.FieldByname('NOME').AsString ), pchar( AllTrim(Form1.ibDataSet13.FieldByname('MUNICIPIO').AsString) ), pchar( DateToStr(Date) ), pchar( '' ) )) <> 1 then Result := False;
    ShowMessage('Retire o cheque na impressora, e tecle <enter>.');
  end else ShowMessage('O município do emitente não está preenchido.');
  }
  ShowMessage('Função não suportada pelo modelo de ECF utilizado.');
  Result := True;
end;

function _ecf02_GrandeTotal(sP1: Boolean): String;
begin
  // Caso falhar o retorno do GT, incluir um SleepEntreMetodos e executar Bematech_FI_GrandeTotal() novamente
  Result := Replicate(' ',18);
  SleepEntreMetodos; // Sandro Silva 2019-08-30 ER 02.06 UnoChapeco
  if Bematech_FI_GrandeTotal( Result ) <> 1 then Result := '0';
end;

function _ecf02_TotalizadoresDasAliquotas(sP1: Boolean): String;
begin
  Result := Replicate(' ',445);
  if Bematech_FI_VerificaTotalizadoresParciais( Result ) <> 1 then Result := '' else Result := Copy(Result,1,224)+Copy(Result,226,14)+Copy(Result,241,14)+Copy(Result,256,14);
end;

function _ecf02_CupomAberto(sP1: Boolean): boolean;
var
  I : Integer;
begin
  if Bematech_FI_FlagsFiscais(I)=1 then
    Result := (Copy(Right(Replicate('0',8)+IntToBin(I),8),8,1)='1')
  else
    Result := False;
end;

function _ecf02_FaltaPagamento(sP1: Boolean): boolean;
var
  I : integer;
begin
  if Bematech_FI_FlagsFiscais(I)=1 then Result:=(Copy(Right(Replicate('0',8)+IntToBin(I),8),7,1)='1') else Result:=False;
end;

function _ecf02_ProgramaAplicativo(sP1: Boolean): boolean;
begin
//  Bematech_FI_ProgramaIdAplicativoMFD(pchar(Form1.sMD5DaLista));
//  Bematech_FI_ProgramaIdAplicativoMFD(pchar('                              '));
  Result := True;
end;

function _ecf02_DadosUltimaReducaoZ(sP1: Boolean): String;
var
  sDados : String;
begin
  sDados := Replicate(' ',1278);
  SleepEntreMetodos; // Sandro Silva 2019-08-30 ER 02.06 UnoChapeco
  if Form1.sMFD_ = 'Sim' then
    Bematech_FI_DadosUltimaReducaoMFD( sDados );
  REsult := sDados;
end;

function _ecf02_Marca(sP1: Boolean): String;
var
  sMarca, sModelo, sTipo: String;
begin
  if Form1.sMFD_ = 'Sim' then
  begin
    sMarca  := Replicate(' ',15);
    sModelo := Replicate(' ',20);
    sTipo   := Replicate(' ',7);
    Bematech_FI_MarcaModeloTipoImpressoraMFD( sMarca, sModelo, sTipo );
    Result := sMarca;
  end else
  begin
    Result := 'BEMATECH';
  end;
end;

function _ecf02_Modelo(sP1: Boolean): String;
var
  sMarca, sModelo, sTipo: String;
begin
  if Form1.sMFD_ = 'Sim' then
  begin
    sMarca  := Replicate(' ',15);
    sModelo := Replicate(' ',20);
    sTipo   := Replicate(' ',7);
    Bematech_FI_MarcaModeloTipoImpressoraMFD( sMarca, sModelo, sTipo );
    Result := sModelo;
  end else
  begin
    Result := '';
  end;
end;

function _ecf02_Tipodaimpressora(pP1: Boolean): String; //
var
  sMarca, sModelo, sTipo: String;
begin
  if Form1.sMFD_ = 'Sim' then
  begin
    sMarca  := Replicate(' ',15);
    sModelo := Replicate(' ',20);
    sTipo   := Replicate(' ',7);
    Bematech_FI_MarcaModeloTipoImpressoraMFD( sMarca, sModelo, sTipo );
    Result := sTipo;
  end else
  begin
    Result := 'IF';
  end;
end;

function _ecf02_VersaoSB(pP1: Boolean): String; //
begin
  Result := '01.00.02';
end;

function _ecf02_HoraIntalacaoSB(pP1: Boolean): String; //
begin
  Result := '155746';
end;

function _ecf02_DataIntalacaoSB(pP1: Boolean): String; //
begin
  Result := '261011';
end;

function _ecf02_DadosDaUltimaReducao(pP1: Boolean): String; //
var
  sRetorno : String;
begin
  {
  DadosReducao: Variável STRING com o tamanho de 1278 posições para receber os dados da última redução.
  Modo de redução Z:                                          1,2
  Contador de reinício de operação:                           4,4
  Contador de redução z:                                      9,4
  Contador de ordem de operação:                              14,6
  Contador Geral de operações não fiscais:                    21,6
  Contador de cupom fiscal:                                   28,6
  Contador Geral de relatório gerencial:                      35,6
  Contador de fita detalhe emitida:                           42,6
  Contador de operação não fiscal cancelada:                  49,4
  Contador de cupom fiscal cancelado:                         54,4
  Contadores específicos de operações não fiscais:            59,120
  Contadores específicos de relatórios gerenciais:            180,120
  Contador de comprovantes de débito ou crédito:              301,4
  Contador de comprovantes de débito ou crédito não emitidos: 306,4
  Contador de comprovantes de débito ou crédito cancelados:   311,4
  Totalizador geral:                                          316,18
  Totalizadores Parciais Tributados:                          335,224
  Totalizador de isenção de ICMS:                             560,14
  Totalizador de não incidência de ICMS:                      575,14
  Totalizador de substituição tributária de ICMS:             590,14
  Totalizador de isenção de ISSQN:                            605,14
  Totalizador de não incidência de ISSQN:                     620,14
  Totalizador de substituição tributária de ISSQN:            635,14
  Totalizador de descontos em ICMS:                           650,14
  Totalizador de descontos em ISSQN:                          665,14
  Totalizador de acréscimos em ICMS:                          680,14
  Totalizador de acréscimos em ISSQN:                         695,14
  Totalizador de cancelamentos em ICMS                        710,14
  Totalizador de cancelamentos em ISSQN:                      725,14
  Totalizadores parciais não sujeitos ao ICMS:                740,392
  Totalizador de sangria:                                     1133,14
  Totalizador de suprimento:                                  1148,14
  Totalizador de cancelamentos de não fiscais:                1163,14
  Totalizador de descontos de não fiscais:                    1178,14
  Totalizador de acréscimos de não fiscais:                   1193,14
  Alíquotas tributárias:                                      1208,64
  Data do movimento:                                          1273,6
  }
  sRetorno := Replicate(' ',1278);
  Bematech_FI_DadosUltimaReducaoMFD(sRetorno);

  //
  Result := Copy(sRetorno,1273,  6)+ //   1,  6 Data
//            Copy(sRetorno,  28,  6)+ //   7,  6 Contador de cupom fiscal
            Copy(sRetorno,  14,  6)+ //   7,  6 Contador de cupom fiscal
            Copy(sRetorno, 316, 18)+ //  13, 18 GT
            Copy(sRetorno,   9,  4)+ //  31,  4 CRZ
            Copy(sRetorno,1208, 64)+ //  35, 64 Aliquotas
            Copy(sRetorno, 335,224)+ //  99,224 Totalizadores das aliquotas
            Copy(sRetorno,   4,  4)+ // 323,  4 Contador de reinício de operação
            Copy(sRetorno, 710, 14)+ // 327, 14 Totalizador de cancelamentos em ICMS
            Copy(sRetorno, 650, 14)+ // 341, 14 Totalizador de descontos em ICMS
            Copy(sRetorno, 560, 14)+ // 355, 14 Totalizador de isenção de ICMS
            Copy(sRetorno, 575, 14)+ // 369, 14 Totalizador de não incidência de ICMS
            Copy(sRetorno, 590, 14)+ // 383, 14 Totalizador de substituição tributária de ICMS
            '';
  //
  // Ok testado
  //
end;

//
// Retorna o Código do Modelo do ECF Conf Tabéla Nacional de Identificação do ECF
//
function _ecf02_CodigoModeloEcf(pP1: Boolean): String; //
begin
  Result := '032101';
  if Form1.sCodigoIdentificaEcf <> '' then
    Result := Form1.sCodigoIdentificaEcf;
end;

function _ecf02_DataUltimaReducao: String;
var
  Data, Hora: String;
  iConta: Integer;
  iRetorno: Integer;
begin
  Result := '00/00/2000';
  try
    for iConta := 1 to 6 do
      Data := Data + ' ';

    for iConta := 1 to 6 do
      Hora := Hora + ' ';

    iRetorno := Bematech_FI_DataHoraReducao( Data, Hora );

    if iRetorno = 1 then
    begin
      if (Trim(Data) <> '') and (Trim(Hora) <> '') then
      begin
        try
          // Formata data, se não for data válida retornar vazio
          Result := FormatDateTime('dd/mm/yyyy', StrToDate(Copy(Data, 1, 2) + '/' + Copy(Data, 3, 2) + '/' + Copy(Data, 5, 2)));
          //Result := Result + ' ' + Copy(Hora, 1, 2) + ':' + Copy(Hora, 3, 2) + ':' + Copy(Hora, 5, 2);
        except
          Result := '00/00/2000';
        end;
      end;
    end;
  except

  end;
end;

function _ecf02_HoraUltimaReducao: String;
var
  Data, Hora: String;
  iConta: Integer;
  iRetorno: Integer;
begin
  Result := '00/00/2000';
  try
    for iConta := 1 to 6 do
      Data := Data + ' ';

    for iConta := 1 to 6 do
      Hora := Hora + ' ';

    iRetorno := Bematech_FI_DataHoraReducao( Data, Hora );

    if iRetorno = 1 then
    begin
      if (Trim(Data) <> '') and (Trim(Hora) <> '') then
      begin
        try
          // Formata data, se não for data válida retornar vazio
          //Result := FormatDateTime('dd/mm/yyyy', StrToDate(Copy(Data, 1, 2) + '/' + Copy(Data, 3, 2) + '/' + Copy(Data, 5, 2)));
          Result := Copy(Hora, 1, 2) + ':' + Copy(Hora, 3, 2) + ':' + Copy(Hora, 5, 2);
        except
          Result := '00:00:00';
        end;
      end;
    end;
  except

  end;
end;

function _ecf02_RetornoStatusImpressora(bExibir: Boolean): String;
var
  ACK, ST1, ST2, ST3: Integer;
begin
  ACK := 0;
  ST1 := 0;
  ST2 := 0;
  ST3 := 0;

  if _ecf02_CupomAberto(True) = False then // Sandro Silva 2016-09-14
    Bematech_FI_TerminaFechamentoCupom(' ');// Sandro Silva 2016-03-03 Precisa ter comando fiscal para o ST3
  Bematech_FI_RetornoImpressoraMFD( ACK, ST1, ST2, ST3 );

  Result := '';
  if ST3 = 63  then
    Result := 'A impressora retornou: ' + #13 + 'BLOQUEIO POR RZ';
  if ST3 = 66  then
    Result := 'A impressora retornou: ' + #13 + 'AGUARDANDO RZ';
  if bExibir then
    if Result <> '' then
      Application.MessageBox(PChar(Result), 'Atenção', MB_ICONWARNING + MB_OK);
end;

end.






