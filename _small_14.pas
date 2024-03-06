{
Alterações
Sandro Silva 2016-02-04
- Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
}
unit _Small_14;

interface

uses
  //////////////////////////////////////////////////////////////////////////////////////////
  Windows, Messages, SmallFunc_xe, Fiscal, SysUtils,Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Mask, Grids, DBGrids, DB, DBCtrls, SMALL_DBEdit, IniFiles, Unit2,
  Unit7, unit22;

  //-----------------------------------------------------------------------//
  // Módulo para Impressora SWEDA                                          //
  // Utiliza a nova dll da SWEDA                                           //
  // 19/06/2006                                                            //
  // Alterado p/versão 2006 07/01/2005 - RONEI                             //
  // SUPORTE SWEDA                                                         //
  // FERNANDO E PEDRO                                                      //
  // (11) 5574-5644                                                        //
  // 08007713713                                                           //
  //-----------------------------------------------------------------------//

  // Funções do Cupom Fiscal /////////////////////////////////////////////////////
  function ECF_UsaRelatorioGerencialMFD(Texto : PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_AbreRelatorioGerencialMFD(Indice : PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_AbreCupom(CGC_CPF: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_VendeItem(Codigo: PAnsiChar; Descricao: PAnsiChar; Aliquota: PAnsiChar; TipoQuantidade: PAnsiChar; Quantidade: PAnsiChar; CasasDecimais: Integer; ValorUnitario: PAnsiChar; TipoDesconto: PAnsiChar; Desconto: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_VendeItemDepartamento(Codigo: PAnsiChar; Descricao: PAnsiChar; Aliquota: PAnsiChar; ValorUnitario: PAnsiChar; Quantidade: PAnsiChar; Acrescimo: PAnsiChar; Desconto: PAnsiChar; IndiceDepartamento: PAnsiChar; UnidadeMedida: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_CancelaItemAnterior: Integer; StdCall; External 'CONVECF.DLL';
  function ECF_CancelaItemGenerico(NumeroItem: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_CancelaCupom: Integer; StdCall; External 'CONVECF.DLL';
  function ECF_FechaCupomResumido(FormaPagamento: PAnsiChar; Mensagem: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_FechaCupom(FormaPagamento: PAnsiChar; AcrescimoDesconto: PAnsiChar; TipoAcrescimoDesconto: PAnsiChar; ValorAcrescimoDesconto: PAnsiChar; ValorPago: PAnsiChar; Mensagem: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_ResetaImpressora:Integer; StdCall; External 'CONVECF.DLL';
  function ECF_IniciaFechamentoCupom(AcrescimoDesconto: PAnsiChar; TipoAcrescimoDesconto: PAnsiChar; ValorAcrescimoDesconto: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_EfetuaFormaPagamento(FormaPagamento: PAnsiChar; ValorFormaPagamento: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_EfetuaFormaPagamentoDescricaoForma(FormaPagamento: PAnsiChar; ValorFormaPagamento: PAnsiChar; DescricaoFormaPagto: PAnsiChar ): integer; StdCall; External 'CONVECF.DLL';
  function ECF_TerminaFechamentoCupom(Mensagem: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_EstornoFormasPagamento(FormaOrigem: PAnsiChar; FormaDestino: PAnsiChar; Valor: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_UsaUnidadeMedida(UnidadeMedida: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_AumentaDescricaoItem(Descricao: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_NomeiaRelatorioGerencialMFD (Indice, Descricao : PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  // Funções dos Relatórios Fiscais //////////////////////////////////////////////

  function ECF_LeituraX:Integer; StdCall; External 'CONVECF.DLL' ;
  function ECF_ReducaoZ(Data: PAnsiChar; Hora: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_RelatorioGerencial(Texto: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_FechaRelatorioGerencial:Integer; StdCall; External 'CONVECF.DLL';
  //
  function ECF_LeituraMemoriaFiscalDataMFD(DataInicial,DataFinal,FlagLeitura : PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_LeituraMemoriaFiscalReducaoMFD(ReducaoInicial,ReducaoFinal,FlagLeitura : PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_LeituraMemoriaFiscalSerialDataMFD(DataInicial,DataFinal,FlagLeitura : PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_LeituraMemoriaFiscalSerialReducaoMFD(ReducaoInicial,ReducaoFinal,FlagLeitura : PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  //
  function ECF_LeituraMemoriaFiscalSerialData(DataInicial: PAnsiChar; DataFinal: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_LeituraMemoriaFiscalSerialReducao(ReducaoInicial: PAnsiChar; ReducaoFinal: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_DownloadMF( Arquivo: PAnsiChar ): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_FormatoDadosMFD(ArquivoOrigem: PAnsiChar;ArquivoDestino: PAnsiChar; TipoFormato: PAnsiChar; TipoDownload: PAnsiChar; ParametroInicial: PAnsiChar; ParametroFinal: PAnsiChar; UsuarioECF: PAnsiChar ): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_ReproduzirMemoriaFiscalMFD(tipo: PAnsiChar; fxai: PAnsiChar; fxaf:  PAnsiChar; asc: PAnsiChar; bin: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_GeraRegistrosCAT52MFD(pathbin:PAnsiChar; datas:PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  // Funções das Operações Não Fiscais ///////////////////////////////////////////
  function ECF_RecebimentoNaoFiscal(IndiceTotalizador: PAnsiChar; Valor: PAnsiChar; FormaPagamento: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_AbreComprovanteNaoFiscalVinculado(FormaPagamento: PAnsiChar; Valor: PAnsiChar; NumeroCupom: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_UsaComprovanteNaoFiscalVinculado(Texto: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL'
  function ECF_FechaComprovanteNaoFiscalVinculado:Integer; StdCall; External 'CONVECF.DLL';
  function ECF_Sangria(Valor: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_Suprimento(Valor: PAnsiChar; FormaPagamento: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  // Funções de Informações da Impressora ////////////////////////////////////////

  function ECF_NumeroSerie(NumeroSerie: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_NumeroSerieMFD(NumeroSerie: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_SubTotal(SubTotal: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_NumeroCupom(NumeroCupom: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_LeituraXSerial: Integer; StdCall; External 'CONVECF.DLL';
  function ECF_VersaoFirmware(VersaoFirmware: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_CGC_IE(CGC: PAnsiChar; IE: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_GrandeTotal(GrandeTotal: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_Cancelamentos(ValorCancelamentos: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_Descontos(ValorDescontos: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_NumeroOperacoesNaoFiscais(NumeroOperacoes: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';




  function ECF_ContadorComprovantesCreditoMFD(Comprovantes : PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';




  function ECF_NumeroCuponsCancelados(NumeroCancelamentos: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_NumeroIntervencoes(NumeroIntervencoes: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_NumeroReducoes(NumeroReducoes: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_NumeroSubstituicoesProprietario(NumeroSubstituicoes: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_UltimoItemVendido(NumeroItem: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_ClicheProprietario(Cliche: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_NumeroCaixa(NumeroCaixa: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_NumeroLoja(NumeroLoja: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_SimboloMoeda(SimboloMoeda: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_MinutosLigada(Minutos: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_MinutosImprimindo(Minutos: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_VerificaModoOperacao(Modo: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_VerificaEpromConectada(Flag: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_FlagsFiscais(Var Flag: Integer): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_ValorPagoUltimoCupom(ValorCupom: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_DataHoraImpressora(Data: PAnsiChar; Hora: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_ContadoresTotalizadoresNaoFiscais(Contadores: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_VerificaTotalizadoresNaoFiscais(Totalizadores: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_DataHoraReducao(Data: PAnsiChar; Hora: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_DataMovimento(Data: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_VerificaTruncamento(Flag: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_Acrescimos(ValorAcrescimos: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_ContadorBilhetePassagem(ContadorPassagem: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_VerificaAliquotasIss(Flag: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_VerificaFormasPagamento(Formas: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_VerificaRecebimentoNaoFiscal(Recebimentos: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_VerificaDepartamentos(Departamentos: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_VerificaTipoImpressora(Var TipoImpressora: Integer): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_VerificaTotalizadoresParciais(Totalizadores: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_RetornoAliquotas(Aliquotas: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_VerificaEstadoImpressora(Var ACK: Integer; Var ST1: Integer; Var ST2: Integer): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_MarcaModeloTipoImpressoraMFD(Marca, Modelo, Tipo : PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';

//  function ECF_VerificaEstadoImpressoraStr(Var ACK: PAnsiChar; Var ST1: PAnsiChar; Var ST2: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
//  function ECF_RetornoImpressoraStr(Var ACK: PAnsiChar; Var ST1: PAnsiChar; Var ST2: PAnsiChar; Var ST3: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';

  function ECF_DadosUltimaReducaoMFD(DadosReducao : PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_DadosUltimaReducao(DadosReducao: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_MonitoramentoPapel(Var Linhas: Integer): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_VerificaIndiceAliquotasIss(Flag: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_ValorFormaPagamento(FormaPagamento: PAnsiChar; Valor: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_ValorTotalizadorNaoFiscal(Totalizador: PAnsiChar; Valor: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';

  // Funções de Autenticação e Gaveta de Dinheiro ////////////////////////////////

  function ECF_Autenticacao:Integer; StdCall; External 'CONVECF.DLL' Name 'ECF_Autenticacao';
  function ECF_ProgramaCaracterAutenticacao(Parametros: PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_AcionaGaveta:Integer; StdCall; External 'CONVECF.DLL' Name 'ECF_AcionaGaveta';
  function ECF_VerificaEstadoGaveta(Var EstadoGaveta: Integer): Integer; StdCall; External 'CONVECF.DLL';

  // Outras Funções //////////////////////////////////////////////////////////////

  function ECF_AbrePortaSerial:Integer; StdCall; External 'CONVECF.DLL';
  function ECF_RetornoImpressora(Var ACK: Integer; Var ST1: Integer; Var ST2: Integer): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_FechaPortaSerial:Integer; StdCall; External 'CONVECF.DLL' Name 'ECF_FechaPortaSerial';
  function ECF_MapaResumo:Integer; StdCall; External 'CONVECF.DLL' Name 'ECF_MapaResumo';
  function ECF_AberturaDoDia( ValorCompra: PAnsiChar; FormaPagamento: PAnsiChar ): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_FechamentoDoDia:Integer; StdCall; External 'CONVECF.DLL' Name 'ECF_FechamentoDoDia';
  function ECF_ImprimeConfiguracoesImpressora:Integer; StdCall; External 'CONVECF.DLL' Name 'ECF_ImprimeConfiguracoesImpressora';
  function ECF_ImprimeDepartamentos:Integer; StdCall; External 'CONVECF.DLL' Name 'ECF_ImprimeDepartamentos';
  function ECF_RelatorioTipo60Analitico:Integer; StdCall; External 'CONVECF.DLL' Name 'ECF_RelatorioTipo60Analitico';
  function ECF_RelatorioTipo60Mestre:Integer; StdCall; External 'CONVECF.DLL' Name 'ECF_RelatorioTipo60Mestre';
  function ECF_VerificaImpressoraLigada:Integer; StdCall; External 'CONVECF.DLL' Name 'ECF_VerificaImpressoraLigada';
  function ECF_ImprimeCheque( Banco: PAnsiChar; Valor: PAnsiChar; Favorecido: PAnsiChar; Cidade: PAnsiChar; Data: PAnsiChar; Mensagem: PAnsiChar ): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_SegundaViaNaoFiscalVinculadoMFD(): Integer; StdCall; External 'CONVECF.DLL';
  //
  function ECF_ContadorCupomFiscalMFD(CuponsEmitidos : PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';
  function ECF_ContadorRelatoriosGerenciaisMFD (Relatorios : PAnsiChar): Integer; StdCall; External 'CONVECF.DLL';


  //
  Function _ecf14_TestaLigadaePapel(pP1:Boolean):Boolean;
  function _ecf14_CodeErro(Pp1: integer):integer;
  function _ecf14_Inicializa(Pp1: String):Boolean;
  function _ecf14_FechaCupom(Pp1: Boolean):Boolean;
  function _ecf14_Pagamento(Pp1: Boolean):Boolean;
  function _ecf14_CancelaUltimoItem(Pp1: Boolean):Boolean;
  function _ecf14_SubTotal(Pp1: Boolean):Real;
  function _ecf14_AbreGaveta(Pp1: Boolean):Boolean;
  function _ecf14_Sangria(Pp1: Real):Boolean;
  function _ecf14_Suprimento(Pp1: Real):Boolean;
  function _ecf14_NovaAliquota(Pp1: String):Boolean;
  function _ecf14_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
  function _ecf14_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
  function _ecf14_CancelaUltimoCupom(Pp1: Boolean):Boolean;
  function _ecf14_AbreNovoCupom(Pp1: Boolean):Boolean;
  function _ecf14_NumeroDoCupom(Pp1: Boolean):String;
  //
  // Contadores
  //
  function _ecf14_GNF(Pp1: Boolean):String; //
  function _ecf14_GRG(Pp1: Boolean):String; //
  function _ecf14_CDC(Pp1: Boolean):String;
  function _ecf14_CCF(Pp1: Boolean):String; //
  function _ecf14_CER(Pp1: Boolean):String; //


  //
  function _ecf14_CancelaItemN(pP1, pP2: String):Boolean;
  function _ecf14_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
  function _ecf14_ReducaoZ(pP1: Boolean):Boolean;
  function _ecf14_LeituraX(pP1: Boolean):Boolean;
  function _ecf14_RetornaVerao(pP1: Boolean):Boolean;
  function _ecf14_LigaDesLigaVerao(pP1: Boolean):Boolean;
  function _ecf14_VersodoFirmware(pP1: Boolean): String;
  function _ecf14_NmerodeSrie(pP1: Boolean): String;
  function _ecf14_CGCIE(pP1: Boolean): String;
  function _ecf14_Cancelamentos(pP1: Boolean): String;
  function _ecf14_Descontos(pP1: Boolean): String;
  function _ecf14_ContadorSeqencial(pP1: Boolean): String;
  function _ecf14_Nmdeoperaesnofiscais(pP1: Boolean): String;
  function _ecf14_NmdeCuponscancelados(pP1: Boolean): String;
  function _ecf14_NmdeRedues(pP1: Boolean): String;
  function _ecf14_Nmdeintervenestcnicas(pP1: Boolean): String;
  function _ecf14_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
  function _ecf14_DataUltimaReducao: String;  
  function _ecf14_Datadaultimareduo(pP1: Boolean): String;
  function _ecf14_Clichdoproprietrio(pP1: Boolean): String;
  function _ecf14_NmdoCaixa(pP1: Boolean): String;
  function _ecf14_Nmdaloja(pP1: Boolean): String;
  function _ecf14_Moeda(pP1: Boolean): String;
  function _ecf14_Dataehoradaimpressora(pP1: Boolean): String;
  function _ecf14_Datadomovimento(pP1: Boolean): String;
  function _ecf14_StatusGaveta(Pp1: Boolean):String;
  function _ecf14_RetornaAliquotas(pP1: Boolean): String;
  function _ecf14_Vincula(pP1: String): Boolean;
  function _ecf14_FlagsDeISS(pP1: Boolean): String;
  function _ecf14_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
  function _ecf14_MudaMoeda(pP1: String): Boolean;
  function _ecf14_MostraDisplay(pP1: String): Boolean;
  function _ecf14_leituraMemoriaFiscalEmDisco(pP1,pP2,pP3: String): Boolean;
  function _ecf14_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean; //iP2 = Número do Cupom vinculado
  function _ecf14_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
  function _ecf14_FechaCupom2(sP1: Boolean): Boolean;
  function _ecf14_ImprimeCheque(rP1: Real; sP2: String): Boolean;
  function _ecf14_GrandeTotal(sP1: Boolean): String;
  function _ecf14_TotalizadoresDasAliquotas(sP1: Boolean): String;
  function _ecf14_CupomAberto(sP1: Boolean): boolean;
  function _ecf14_FaltaPagamento(sP1: Boolean): boolean;
  function _ecf14_DadosUltimaReducaoZ(sP1: Boolean): String;
  function _ecf14_DadosDaUltimaReducao(pP1: Boolean): String; //
  //
  // PAF
  //
  function _ecf14_Marca(sP1: Boolean): String;
  function _ecf14_Modelo(sP1: Boolean): String;
  function _ecf14_Tipodaimpressora(pP1: Boolean): String;
  function _ecf14_VersaoSB(pP1: Boolean): String; //
  function _ecf14_HoraIntalacaoSB(pP1: Boolean): String; //
  function _ecf14_DataIntalacaoSB(pP1: Boolean): String; //
  function _ecf14_CodigoModeloEcf(pP1: Boolean): String; //
  //
  //  function _ecf14_VerificaFormasPagamento(bP1:Boolean): Boolean;
  //

implementation

Function _ecf14_TestaLigadaePapel(pP1:Boolean):Boolean;
var
   iACK,iST1,iST2:integer;
begin
  iACK := 0; iST1 := 0; iST2 := 0;
  //
  // Result := True;
  //
  Result:=(ECF_VerificaImpressoraLigada()=1);
  //
  if Result then
  begin
    Result:=(ECF_RetornoImpressora(iACK, iST1, iST2)=1);
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
end;

Function _ecf14_CodeErro(pP1: integer):Integer; //
var
  iACK, iST1, iST2: Integer;
  vErro    : array [0..99] of String;  // Cria uma matriz com  100 elementos
  I        : Integer;
  sErro:string;
begin
  //
  for I := 0 to 99 do vErro[I] := 'Comando não executado.';

  // Verificar se falta papel, e no sugerir uma leitura X
  //
  Form1.Panel2.Visible := False;
  //
  // numeros negativos
  vErro[00] :=  'Erro de Comunicação !';
  vErro[01] :=  'Erro de Execução na Função. Verifique!';
  vErro[02] :=  'Parâmetro Inválido !';
  vErro[03] :=  'Alíquota não programada !';
  vErro[04] :=  'Arquivo BemaFI32.INI não encontrado. Verifique!';
  vErro[05] :=  'Erro ao Abrir a Porta de Comunicação';
  vErro[06] :=  'Impressora Desligada ou Desconectada';
  vErro[07] :=  'Banco Não Cadastrado no Arquivo BemaFI32.ini';
  vErro[08] :=  'Erro ao Criar ou Gravar no Arquivo Retorno.txt ou Status.txt';
  vErro[18] :=  'Não foi possível abrir arquivo INTPOS.001 !';
  vErro[19] :=  'Parâmetro diferentes !';
  vErro[20] :=  'Transação cancelada pelo Operador !';
  vErro[21] :=  'A Transação não foi aprovada !';
  vErro[22] :=  'Não foi possível terminal a Impressão !';
  vErro[23] :=  'Não foi possível terminal a Operação !';
  vErro[24] :=  'Forma de pagamento não programada.';
  vErro[25] :=  'Totalizador não fiscal não programado.';
  vErro[26] :=  'Transação já Efetuada !';
  vErro[27] :=  'Status do ECF diferente de 6,0,0,0 !';
  vErro[28] :=  'Não há Informações para serem Impressas !';
  vErro[99] :=  'Falha de comunicação '+chr(10)+chr(10)+
                'Sugestão: verifique as conexões,'+chr(10)+
                'ligue e desligue a impressora. '+chr(10)+chr(10)+
                'O Sistema será Finalizado.';

//
// Ronei volto >>>>>
//
  if pP1 <> 1 then
     Application.MessageBox(Pchar('ERRO n.'+IntToStr(pP1)+' - '+vErro[abs(pP1)]),'Atenção',mb_Ok + mb_DefButton1);
  //Result:=pP1;
  if (pP1=00) or (pP1=99) then
    Halt(1);

  //analisa o retorno da impressora
//  if pP1 <=0 then
//  begin
    iACK := 0; iST1 := 0; iST2 := 0;
    ECF_RetornoImpressora(iACK, iST1, iST2);
    if iACK = 6 then
    begin
      sErro:='';
      // Verifica ST1
      if iST1 >= 128 then begin iST1 := iST1 - 128; sErro:='ERRO: fim de papel'+chr(10); end;
      if iST1 >= 64  then
      begin
        iST1 := iST1 - 64;
        sErro:='pouco papel';
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
      showmessage( 'Atenção!!!' + #13 + #10 +
                   'A Impressora retornou NAK. O sistema será finalizado.');
      Application.Terminate;
      Result:=pP1;
      Exit;
    end;
    if Copy(sErro,1,4)='ERRO' then
    begin
      showmessage( 'Atenção!!!' + #13 + #10 +
                   'A Impressora retornou: '+ #13 + #10 +sErro);
      pP1:=9;
    end;
//  end;
  Result:=pP1;
end;


// Verifica se a forma de pagamento está cadastrada
function _ecf14_VerificaFormaPgto(Forma:String):String;
var
  Retorno,i,j:integer;
  sFormasPagamento:String;
begin
   Result := 'XX';
   sFormasPagamento := Replicate(' ', 3016);
   Retorno := ECF_VerificaFormasPagamento(PAnsiChar(AnsiString(sFormasPagamento))); // 2024-03-06 Retorno := ECF_VerificaFormasPagamento(AnsiString(sFormasPagamento));
   if Retorno = 1 then //ok
   begin
     i := 1;
     J := 1;
     while i < length(sFormasPagamento) do
     begin
       if Result = 'XX' then // só entra se ainda não encontrou
         if Pos(UpperCase(Forma),UpperCase(Copy(sFormasPagamento,i,58)))>0 then
         begin
           Result := '0' + IntToStr(j);//Forma;//
         end;
       i := i + 58;
       j := J + 1;
     end;
   end;
end;

function _ecf14_VerificaDescricaoFormaPgto(Forma:String):String;
var
  sFormasPagamento:String;
begin
  if (isNumericString(Forma)) and (Alltrim(Forma)<> '') then
  begin
    sFormasPagamento := Replicate(' ', 3016);
    if (ECF_VerificaFormasPagamento(PAnsiChar(AnsiString(sFormasPagamento))) <> 1) then // 2024-03-06 if (ECF_VerificaFormasPagamento(AnsiString(sFormasPagamento)) <> 1) then
    begin
      Result := '';
    end else
    begin
      Result := Copy(sFormasPagamento, ((StrToInt(Forma) - 1) * 58) + 1, 15);
    end;
  end
  else
    Result := '';
end;

// --------------------------- //
// Detecta qual a porta que    //
// a impressora está conectada //
// --------------------------- //
function _ecf14_Inicializa(Pp1: String):Boolean;
var
  I : Integer;
begin
  //
  // teste
  //
  ECF_AbrePortaSerial();
  I := ECF_VerificaImpressoraLigada();
  //
  // FERNANDO E PEDRO                                                      //
  // (11) 5574-5644                                                        //
  //
  if I = 1 then
  begin
    Result:=True;
  end else
  begin
    Result:=False;
  end;
  {Sandro Silva 2023-12-13 inicio
  ECF_NomeiaRelatorioGerencialMFD(pchar('03'),pchar('IDENT DO PAF'));
  ECF_NomeiaRelatorioGerencialMFD(pchar('04'),pchar('VENDA PRAZO'));
  // 2016-02-04 ECF_NomeiaRelatorioGerencialMFD(pchar('05'),pchar('TEF'));
  ECF_NomeiaRelatorioGerencialMFD(pchar('05'),pchar('CARTAO TEF'));
  ECF_NomeiaRelatorioGerencialMFD(pchar('06'),pchar('MEIOS DE PAGTO'));
  ECF_NomeiaRelatorioGerencialMFD(pchar('07'),pchar('DAV EMITIDOS'));
  ECF_NomeiaRelatorioGerencialMFD(pchar('08'),pchar('ORCAMENT (DAV)'));
  // 2016-02-04 ECF_NomeiaRelatorioGerencialMFD(pchar('09'),pchar('CONF CONTA'));
  // Sandro Silva 2016-02-11 ECF_NomeiaRelatorioGerencialMFD(pchar('10'),pchar('TRANSF CONTA'));
  // Sandro Silva 2016-02-11 ECF_NomeiaRelatorioGerencialMFD(pchar('11'),pchar('CONTAS ABERTAS'));
  ECF_NomeiaRelatorioGerencialMFD(pchar('09'),pchar('CONF CONTA CLI')); // 2016-02-04 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
  ECF_NomeiaRelatorioGerencialMFD(pchar('10'),pchar('TRANSF CONT CLI')); // 2016-02-11 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
  ECF_NomeiaRelatorioGerencialMFD(pchar('11'),pchar('CONT CLI ABERTA')); // 2016-02-11 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
  ECF_NomeiaRelatorioGerencialMFD(pchar('12'),pchar('CONF MESA'));
  ECF_NomeiaRelatorioGerencialMFD(pchar('13'),pchar('TRANSF MESA'));
  ECF_NomeiaRelatorioGerencialMFD(pchar('14'),pchar('MESAS ABERTAS'));
  ECF_NomeiaRelatorioGerencialMFD(pchar('15'),pchar('PARAM CONFIG'));
  }
  ECF_NomeiaRelatorioGerencialMFD(PAnsiChar('03'),PAnsiChar('IDENT DO PAF'));
  ECF_NomeiaRelatorioGerencialMFD(PAnsiChar('04'),PAnsiChar('VENDA PRAZO'));
  // 2016-02-04 ECF_NomeiaRelatorioGerencialMFD(PAnsiChar('05'),PAnsiChar('TEF'));
  ECF_NomeiaRelatorioGerencialMFD(PAnsiChar('05'),PAnsiChar('CARTAO TEF'));
  ECF_NomeiaRelatorioGerencialMFD(PAnsiChar('06'),PAnsiChar('MEIOS DE PAGTO'));
  ECF_NomeiaRelatorioGerencialMFD(PAnsiChar('07'),PAnsiChar('DAV EMITIDOS'));
  ECF_NomeiaRelatorioGerencialMFD(PAnsiChar('08'),PAnsiChar('ORCAMENT (DAV)'));
  // 2016-02-04 ECF_NomeiaRelatorioGerencialMFD(PAnsiChar('09'),PAnsiChar('CONF CONTA'));
  // Sandro Silva 2016-02-11 ECF_NomeiaRelatorioGerencialMFD(PAnsiChar('10'),PAnsiChar('TRANSF CONTA'));
  // Sandro Silva 2016-02-11 ECF_NomeiaRelatorioGerencialMFD(PAnsiChar('11'),PAnsiChar('CONTAS ABERTAS'));
  ECF_NomeiaRelatorioGerencialMFD(PAnsiChar('09'),PAnsiChar('CONF CONTA CLI')); // 2016-02-04 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
  ECF_NomeiaRelatorioGerencialMFD(PAnsiChar('10'),PAnsiChar('TRANSF CONT CLI')); // 2016-02-11 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
  ECF_NomeiaRelatorioGerencialMFD(PAnsiChar('11'),PAnsiChar('CONT CLI ABERTA')); // 2016-02-11 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
  ECF_NomeiaRelatorioGerencialMFD(PAnsiChar('12'),PAnsiChar('CONF MESA'));
  ECF_NomeiaRelatorioGerencialMFD(PAnsiChar('13'),PAnsiChar('TRANSF MESA'));
  ECF_NomeiaRelatorioGerencialMFD(PAnsiChar('14'),PAnsiChar('MESAS ABERTAS'));
  ECF_NomeiaRelatorioGerencialMFD(PAnsiChar('15'),PAnsiChar('PARAM CONFIG'));
  {Sandro Silva 2023-12-13 fim}
  //
  // Ok
  //
end;

// ------------------------------ //
function _ecf14_FechaCupom(Pp1: Boolean):Boolean; //
begin
  if Form1.fTotal = 0 then Result:= (_ecf14_CodeErro(ECF_CancelaCupom())=1) else // cupom em branco cancela
  begin
    {Sandro Silva 2023-12-13 inicio
    if Form1.fTotal <= Form1.ibDataSet25RECEBER.AsFloat
       then Form1.Retorno := ECF_IniciaFechamentoCupom('A','$',pchar(StrZero((Form1.ibDataSet25RECEBER.AsFloat-Form1.fTotal)*100,14,0)))
         else Form1.Retorno := ECF_IniciaFechamentoCupom('D','$',pchar(StrZero((Form1.fTotal-Form1.ibDataSet25RECEBER.AsFloat)*100,14,0)));
    }
    if Form1.fTotal <= Form1.ibDataSet25RECEBER.AsFloat then
      Form1.Retorno := ECF_IniciaFechamentoCupom(PAnsiChar(AnsiString('A')),PAnsiChar(AnsiString('$')), PAnsiChar(AnsiString(StrZero((Form1.ibDataSet25RECEBER.AsFloat-Form1.fTotal)*100,14,0)))) //2024-03-06 Form1.Retorno := ECF_IniciaFechamentoCupom(AnsiString('A'),AnsiString('$'), AnsiString(StrZero((Form1.ibDataSet25RECEBER.AsFloat-Form1.fTotal)*100,14,0)))
    else
      Form1.Retorno := ECF_IniciaFechamentoCupom(PAnsiChar(AnsiString('D')), PAnsiChar(AnsiString('$')), PAnsiChar(AnsiString(StrZero((Form1.fTotal-Form1.ibDataSet25RECEBER.AsFloat)*100,14,0))));//2024-03-06 Form1.Retorno := ECF_IniciaFechamentoCupom(AnsiString('D'), AnsiString('$'), AnsiString(StrZero((Form1.fTotal-Form1.ibDataSet25RECEBER.AsFloat)*100,14,0)));
    {Sandro Silva 2023-12-13 fim}
    if Form1.Retorno = 1 then Result := True else Result := False;
  end;
end;

function _ecf14_Pagamento(Pp1: Boolean):Boolean;
begin
  // ------------------ //
  // Forma de pagamento //
  // ------------------ //
  //  ShowMessage(
  //    'Em cheque...: '+StrZero(Form1.ibDataSet25ACUMULADO1.AsFloat*100,14,0)+ Chr(10) +
  //    'Em dinheiro.: '+StrZero(Form1.ibDataSet25ACUMULADO2.AsFloat*100,14,0)+ Chr(10) +
  //    'Receber.....: '+StrZero(Form1.ibDataSet25RECEBER.AsFloat*100,14,0)+ Chr(10)+
  //    'Total.......: '+StrZero(Form1.fTotal*100,14,0)+ Chr(10));
  {Sandro Silva 2023-12-13 inicio
  if Form1.ibDataSet25ACUMULADO2.AsFloat > 0 then ECF_EfetuaFormaPagamento(pchar('Dinheiro'),pchar( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25ACUMULADO2.AsFloat*100])),15),1,12))); // Dinheiro
  if Form1.ibDataSet25ACUMULADO1.AsFloat > 0 then ECF_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label9.Caption)),pchar( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25ACUMULADO1.AsFloat*100])),15),1,12))); // Cheque
  if Form1.ibDataSet25PAGAR.AsFloat      > 0 then ECF_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label8.Caption)),pchar( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25PAGAR.AsFloat*100])),15),1,12)));      // Cartão
  if Form1.ibDataSet25DIFERENCA_.AsFloat > 0 then ECF_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label17.Caption)),pchar( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25DIFERENCA_.AsFloat*100])),15),1,12))); // Prazo
  if Form1.ibDataSet25VALOR01.AsFloat     > 0 then ECF_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label18.Caption)), pchar( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR01.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR02.AsFloat     > 0 then ECF_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label19.Caption)), pchar( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR02.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR03.AsFloat     > 0 then ECF_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label20.Caption)), pchar( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR03.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR04.AsFloat     > 0 then ECF_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label21.Caption)), pchar( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR04.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR05.AsFloat     > 0 then ECF_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label22.Caption)), pchar( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR05.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR06.AsFloat     > 0 then ECF_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label23.Caption)), pchar( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR06.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR07.AsFloat     > 0 then ECF_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label24.Caption)), pchar( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR07.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR08.AsFloat     > 0 then ECF_EfetuaFormaPagamento(pchar(AllTrim(Form2.Label25.Caption)), pchar( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR08.AsFloat*100])),15),1,12)));    // Dinheiro
  //
  ECF_TerminaFechamentoCupom(pchar('MD5: '+Form1.sMD5DaLista+chr(10)+ConverteAcentos(Form1.sMensagemPromocional)));
  }
  {2024-03-06
  if Form1.ibDataSet25ACUMULADO2.AsFloat > 0 then ECF_EfetuaFormaPagamento(AnsiString('Dinheiro'),AnsiString( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25ACUMULADO2.AsFloat*100])),15),1,12))); // Dinheiro
  if Form1.ibDataSet25ACUMULADO1.AsFloat > 0 then ECF_EfetuaFormaPagamento(AnsiString(AllTrim(Form2.Label9.Caption)),AnsiString( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25ACUMULADO1.AsFloat*100])),15),1,12))); // Cheque
  if Form1.ibDataSet25PAGAR.AsFloat      > 0 then ECF_EfetuaFormaPagamento(AnsiString(AllTrim(Form2.Label8.Caption)),AnsiString( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25PAGAR.AsFloat*100])),15),1,12)));      // Cartão
  if Form1.ibDataSet25DIFERENCA_.AsFloat > 0 then ECF_EfetuaFormaPagamento(AnsiString(AllTrim(Form2.Label17.Caption)),AnsiString( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25DIFERENCA_.AsFloat*100])),15),1,12))); // Prazo
  if Form1.ibDataSet25VALOR01.AsFloat     > 0 then ECF_EfetuaFormaPagamento(AnsiString(AllTrim(Form2.Label18.Caption)), AnsiString( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR01.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR02.AsFloat     > 0 then ECF_EfetuaFormaPagamento(AnsiString(AllTrim(Form2.Label19.Caption)), AnsiString( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR02.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR03.AsFloat     > 0 then ECF_EfetuaFormaPagamento(AnsiString(AllTrim(Form2.Label20.Caption)), AnsiString( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR03.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR04.AsFloat     > 0 then ECF_EfetuaFormaPagamento(AnsiString(AllTrim(Form2.Label21.Caption)), AnsiString( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR04.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR05.AsFloat     > 0 then ECF_EfetuaFormaPagamento(AnsiString(AllTrim(Form2.Label22.Caption)), AnsiString( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR05.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR06.AsFloat     > 0 then ECF_EfetuaFormaPagamento(AnsiString(AllTrim(Form2.Label23.Caption)), AnsiString( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR06.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR07.AsFloat     > 0 then ECF_EfetuaFormaPagamento(AnsiString(AllTrim(Form2.Label24.Caption)), AnsiString( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR07.AsFloat*100])),15),1,12)));    // Dinheiro
  if Form1.ibDataSet25VALOR08.AsFloat     > 0 then ECF_EfetuaFormaPagamento(AnsiString(AllTrim(Form2.Label25.Caption)), AnsiString( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR08.AsFloat*100])),15),1,12)));    // Dinheiro
  //
  ECF_TerminaFechamentoCupom(AnsiString('MD5: '+Form1.sMD5DaLista+chr(10)+ConverteAcentos(Form1.sMensagemPromocional)));
  }
  if Form1.ibDataSet25ACUMULADO2.AsFloat > 0 then ECF_EfetuaFormaPagamento(PAnsiChar(AnsiString('Dinheiro')),PAnsiChar(AnsiString( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25ACUMULADO2.AsFloat*100])),15),1,12)))); // Dinheiro
  if Form1.ibDataSet25ACUMULADO1.AsFloat > 0 then ECF_EfetuaFormaPagamento(PAnsiChar(AnsiString(AllTrim(Form2.Label9.Caption))),PAnsiChar(AnsiString( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25ACUMULADO1.AsFloat*100])),15),1,12)))); // Cheque
  if Form1.ibDataSet25PAGAR.AsFloat      > 0 then ECF_EfetuaFormaPagamento(PAnsiChar(AnsiString(AllTrim(Form2.Label8.Caption))),PAnsiChar(AnsiString( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25PAGAR.AsFloat*100])),15),1,12))));      // Cartão
  if Form1.ibDataSet25DIFERENCA_.AsFloat > 0 then ECF_EfetuaFormaPagamento(PAnsiChar(AnsiString(AllTrim(Form2.Label17.Caption))),PAnsiChar(AnsiString( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25DIFERENCA_.AsFloat*100])),15),1,12)))); // Prazo
  if Form1.ibDataSet25VALOR01.AsFloat     > 0 then ECF_EfetuaFormaPagamento(PAnsiChar(AnsiString(AllTrim(Form2.Label18.Caption))), PAnsiChar(AnsiString( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR01.AsFloat*100])),15),1,12))));    // Dinheiro
  if Form1.ibDataSet25VALOR02.AsFloat     > 0 then ECF_EfetuaFormaPagamento(PAnsiChar(AnsiString(AllTrim(Form2.Label19.Caption))), PAnsiChar(AnsiString( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR02.AsFloat*100])),15),1,12))));    // Dinheiro
  if Form1.ibDataSet25VALOR03.AsFloat     > 0 then ECF_EfetuaFormaPagamento(PAnsiChar(AnsiString(AllTrim(Form2.Label20.Caption))), PAnsiChar(AnsiString( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR03.AsFloat*100])),15),1,12))));    // Dinheiro
  if Form1.ibDataSet25VALOR04.AsFloat     > 0 then ECF_EfetuaFormaPagamento(PAnsiChar(AnsiString(AllTrim(Form2.Label21.Caption))), PAnsiChar(AnsiString( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR04.AsFloat*100])),15),1,12))));    // Dinheiro
  if Form1.ibDataSet25VALOR05.AsFloat     > 0 then ECF_EfetuaFormaPagamento(PAnsiChar(AnsiString(AllTrim(Form2.Label22.Caption))), PAnsiChar(AnsiString( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR05.AsFloat*100])),15),1,12))));    // Dinheiro
  if Form1.ibDataSet25VALOR06.AsFloat     > 0 then ECF_EfetuaFormaPagamento(PAnsiChar(AnsiString(AllTrim(Form2.Label23.Caption))), PAnsiChar(AnsiString( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR06.AsFloat*100])),15),1,12))));    // Dinheiro
  if Form1.ibDataSet25VALOR07.AsFloat     > 0 then ECF_EfetuaFormaPagamento(PAnsiChar(AnsiString(AllTrim(Form2.Label24.Caption))), PAnsiChar(AnsiString( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR07.AsFloat*100])),15),1,12))));    // Dinheiro
  if Form1.ibDataSet25VALOR08.AsFloat     > 0 then ECF_EfetuaFormaPagamento(PAnsiChar(AnsiString(AllTrim(Form2.Label25.Caption))), PAnsiChar(AnsiString( Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR08.AsFloat*100])),15),1,12))));    // Dinheiro
  //
  ECF_TerminaFechamentoCupom(PAnsiChar(AnsiString('MD5: '+Form1.sMD5DaLista+chr(10)+ConverteAcentos(Form1.sMensagemPromocional))));


  Result:=true;
  //
end;

// ------------------------------ //
// Cancela o último item  emitido //
// ------------------------------ //
function _ecf14_CancelaUltimoItem(Pp1: Boolean):Boolean;
begin
  Result:=(_ecf14_CodeErro(ECF_CancelaItemAnterior())=1);
end;

function _ecf14_CancelaUltimoCupom(Pp1: Boolean):Boolean;
begin
  if pP1 then Result:=(_ecf14_CodeErro(ECF_CancelaCupom())=1) else
  begin
    Result:=(ECF_CancelaCupom()=1);
    if Result then if _ecf14_CupomAberto(True) then Result:=False; //se o cupom está aberto é porque não cancelou
    
    if Result = False then
      ShowMessage('Cancelamento não permitido'); // Sandro Silva 2018-10-18
  end;
end;

function _ecf14_SubTotal(Pp1: Boolean):Real;
var
  sSubTotal:String;
begin
  sSubTotal:=Replicate(' ',14);
  if pP1 then
   begin
     _ecf14_CodeErro(ECF_SubTotal(PAnsiChar(AnsiString(sSubTotal)))); // Sandro Silva 2024-03-06 _ecf14_CodeErro(ECF_SubTotal( AnsiString(sSubTotal) )); // Sandro Silva 2023-12-14 _ecf14_CodeErro(ECF_SubTotal( sSubTotal ));
   end
  else
   if ECF_SubTotal(PAnsiChar(AnsiString(sSubTotal))) = 0 then // Sandro Silva 2024-03-06 if ECF_SubTotal( AnsiString(sSubTotal) )=0 then // Sandro Silva 2023-12-14 if ECF_SubTotal( sSubTotal )=0 then
     sSubTotal:='0';// se pp1 for falso não verifica o erro
  Result := StrToFloatDef(sSubTotal, 0) / 100; // Sandro Silva 2023-12-14 Result := StrToFloat(sSubTotal)/100;
end;

// ------------------------------ //
// Abre um novo copom fiscal      //
// ------------------------------ //
function _ecf14_AbreNovoCupom(Pp1: Boolean):Boolean;
begin
  if _ecf14_CupomAberto(True) then // se o cupo já estiver aberto ignora a checagem de erro
  begin
    ECF_AbreCupom(PAnsiChar(AnsiString(Form1.sCPF_CNPJ_Validado))); // 2024-03-06 ECF_AbreCupom(AnsiString(Form1.sCPF_CNPJ_Validado));
    Result:=True;
  end else
  begin
    Result := (_ecf14_CodeErro(ECF_AbreCupom(PAnsiChar(AnsiString(Form1.sCPF_CNPJ_Validado))))=1); // 2024-03-06 Result:= (_ecf14_CodeErro(ECF_AbreCupom(AnsiString(Form1.sCPF_CNPJ_Validado)))=1);
    if not Result then
    begin
      Result := (ECF_FechaComprovanteNaoFiscalVinculado()=1);
      if not result then Result := (ECF_FechaRelatorioGerencial()=1);
      if Result then ECF_FechaComprovanteNaoFiscalVinculado();
      Result := (_ecf14_CodeErro(ECF_AbreCupom(PAnsiChar(AnsiString(Form1.sCPF_CNPJ_Validado))))=1);//2024-03-06 Result:=(_ecf14_CodeErro(ECF_AbreCupom(AnsiString(Form1.sCPF_CNPJ_Validado)))=1);//
    end;
  end;
end;


// -------------------------------- //
// Retorna o número do Cupom        //
// -------------------------------- //
function _ecf14_NumeroDoCupom(Pp1: Boolean):String;
begin
  Result := Replicate(' ',6);
  _ecf14_CodeErro(ECF_NumeroCupom(PAnsiChar(AnsiString(Result)))); // 2024-03-06 _ecf14_CodeErro(ECF_NumeroCupom( Result ));
end;

// -------------------------- //
// Retorna o número do CCF    //
// -------------------------- //
function _ecf14_ccF(Pp1: Boolean):String;
begin
  Result := Replicate(' ',6);
  ECF_ContadorCupomFiscalMFD(PAnsiChar(AnsiString(Result))); // Sandro Silva 2024-03-06 ECF_ContadorCupomFiscalMFD(PAnsiChar(Result)); // Sandro Silva 2023-12-13 ECF_ContadorCupomFiscalMFD(pChar(Result));
end;

// ------------------------------------------------------------------------- //
// Retorna o número de operações não fiscais executadas na impressora. GNF   //
// ------------------------------------------------------------------------- //
function _ecf14_gnf(Pp1: Boolean):String;
begin
  Result := Replicate(' ',6);
  ECF_NumeroOperacoesNaoFiscais(PAnsiChar(AnsiString(Result))); // 2024-03-06 ECF_NumeroOperacoesNaoFiscais(Result);
end;

//
// Retorna a quantidade de relatórios gerenciais emitidos.
//
function _ecf14_CDC(Pp1: Boolean):String;
begin
  Result := Replicate(' ',4);
  ECF_ContadorComprovantesCreditoMFD(PAnsiChar(AnsiString(Result))); // Sandro Silva 2024-03-06 ECF_ContadorComprovantesCreditoMFD(PAnsiChar(Result)); // Sandro Silva 2023-12-13 ECF_ContadorComprovantesCreditoMFD(pChar(Result));
  Result := '00' + Result;
end;

//
// Retorna a quantidade de relatórios gerenciais emitidos.
//
function _ecf14_GRG(Pp1: Boolean):String;
begin
  Result := Replicate(' ',6);
  ECF_ContadorRelatoriosGerenciaisMFD(PAnsiChar(AnsiString(Result))); // Sandro Silva 2024-03-06 ECF_ContadorRelatoriosGerenciaisMFD(PAnsiChar(Result)); // Sandro Silva 2023-12-13 ECF_ContadorRelatoriosGerenciaisMFD(pChar(Result));
end;


// ------------------------------------------------------------------------- //
// Retorna o número de operações não fiscais executadas na impressora. CER   //
// ------------------------------------------------------------------------- //
function _ecf14_CER(Pp1: Boolean):String;
begin
  Result := Replicate(' ',6);
  ECF_ContadorRelatoriosGerenciaisMFD(PAnsiChar(AnsiString(Result))); // Sandro Silva 2024-03-06 ECF_ContadorRelatoriosGerenciaisMFD(PAnsiChar(Result)); // Sandro Silva 2023-12-13 ECF_ContadorRelatoriosGerenciaisMFD(pChar(Result));
end;



// ------------------------------ //
// Cancela um item N              //
// ------------------------------ //
function _ecf14_CancelaItemN(pP1, pP2 : String):Boolean;
begin
  pP1:=Right(pP1,3);
  // 2024-03-06 Result:=(_ecf14_CodeErro(ECF_CancelaItemGenerico( AnsiString( pP1 ) ))=1); // Sandro Silva 2023-12-13 Result:=(_ecf14_CodeErro(ECF_CancelaItemGenerico( pchar( pP1 ) ))=1);
  Result := (_ecf14_CodeErro(ECF_CancelaItemGenerico(PAnsiChar(AnsiString( pP1 )) ))=1);
end;

// -------------------------------- //
// Abre a gaveta                    //
// -------------------------------- //
function _ecf14_AbreGaveta(Pp1: Boolean):Boolean;
begin
  ECF_AcionaGaveta();
  Result:=True;
end;

// -------------------------------- //
// Status da gaveta                 //
// -------------------------------- //
function _ecf14_StatusGaveta(Pp1: Boolean):String;
var
  I : Integer;
begin
  //
  // Estado = 1 sensor em nível 1 (fechada)
  // Estado = 0 sensor em nível 0 (aberta)
  //
  I := 0;
  ECF_VerificaEstadoGaveta(I);
  //
  if Form1.iStatusGaveta = 0 then
  begin
    if I <> 0 then Result := '255' else  Result :='000';
  end else
  begin
    if I <> 0 then Result := '000' else  Result :='255';
  end;
  //
  Application.ProcessMessages;
  Sleep(100);
  //
end;

// -------------------------------- //
// Sangria                          //
// -------------------------------- //
function _ecf14_Sangria(Pp1: Real):Boolean;
begin
  ECF_Sangria(PAnsiChar(AnsiString(Format('%14.2f',[pP1])))); // Sandro Silva 2024-03-06 ECF_Sangria( PAnsiChar(Format('%14.2f',[pP1]))); // Sandro Silva 2023-12-13 ECF_Sangria( pchar(Format('%14.2f',[pP1])));
  ECF_TerminaFechamentoCupom(PAnsiChar(AnsiString('SANGRIA')));// 2024-03-06 ECF_TerminaFechamentoCupom(AnsiString('SANGRIA'));
  Result := True;
end;

// -------------------------------- //
// Suprimento                       //
// -------------------------------- //
function _ecf14_Suprimento(Pp1: Real):Boolean;
begin
  Result := (_ecf14_CodeErro(ECF_Suprimento(PAnsiChar(ANsiString(Format('%14.2f',[pP1]))), PAnsiChar(AnsiString('Dinheiro')))) = 1); // Sandro Silva 2024-03-06 Result:=(_ecf14_CodeErro(ECF_Suprimento( PAnsiChar(Format('%14.2f',[pP1])), PAnsiChar('Dinheiro') ))=1); // Sandro Silva 2023-12-13 Result:=(_ecf14_CodeErro(ECF_Suprimento( pchar(Format('%14.2f',[pP1])), pchar('Dinheiro') ))=1);
  ECF_TerminaFechamentoCupom(PAnsiChar(AnsiString('SUPRIMENTO'))); // 2024-03-06 ECF_TerminaFechamentoCupom(AnsiString('SUPRIMENTO'));
end;

// -------------------------------- //
// Nova Aliquota                    //
// -------------------------------- //
function _ecf14_NovaAliquota(Pp1: String):Boolean;
begin
  showmessage('O Cadastro de alíquotas só é permitido através de intervenção técnica');
  result:=false;
end;

function _ecf14_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
var
  I : Integer;
  sArquivoOrigem, sTipoDownload, sCOOInicial, sCOOFinal, sTipoFormato, sUsuario, sArquivoDestino : String;
begin
  //
  sArquivoOrigem  := 'c:\MF.BIN';
  sArquivoDestino := pP1;
  //
  if Form7.Label3.Caption = 'Data inicial:' then
  begin
    sTipoDownload := '1';
    sCOOInicial   := DateToStr(Form7.DateTimePicker1.Date);
    sCOOfinal     := DateToStr(Form7.DateTimePicker2.Date);
  end else
  begin
    sCOOInicial   := StrZero(StrToInt(pP2),6,0);
    sCOOfinal     := StrZero(StrToInt(pP3),6,0);
    sTipoDownload := '2';
  end;
  //
  I := ECF_DownloadMF(PAnsiChar(AnsiString(sArquivoOrigem))); // Sandro Silva 2023-12-13 I := ECF_DownloadMF(pChar(sArquivoOrigem));
  //
  if I = 1 then
  begin
    //
    if Form7.sMfd = '2' then
    begin
      //
      sTipoFormato    := '2';     // TXT é disponível
      sArquivoDestino := 'c:\SW'+Right(Form1.sNumeroDeSerieDaImpressora,5)+'.'+IntToHex(Day(Date),1)+IntToHex(Month(Date),1)+IntToHex(Year(Date)-2000,1);
      {Sandro Silva 2023-12-13 inicio
      I := ECF_ReproduzirMemoriaFiscalMFD(pchar(sTipoFormato),
                                         pchar(sCOOInicial),
                                         pchar(sCOOfinal),
                                         pchar(sArquivoDestino),
                                         pchar(sArquivoOrigem));
      }
      I := ECF_ReproduzirMemoriaFiscalMFD(PAnsiChar(AnsiString(sTipoFormato)),
                                         PAnsiChar(AnsiString(sCOOInicial)),
                                         PAnsiChar(AnsiString(sCOOfinal)),
                                         PAnsiChar(AnsiString(sArquivoDestino)),
                                         PAnsiChar(AnsiString(sArquivoOrigem))
                                         );
      {Sandro Silva 2023-12-13 fim}
      //
      Form1.SaveDialog1.FileName         := sArquivoDestino;
      //
    end else
    begin
      //
      sUsuario        := '1';
      sTipoFormato    := '0';     // TXT é disponível
      {Sandro Silva 2023-12-13 inicio
      I := ECF_FormatoDadosMFD( pchar(sArquivoOrigem),
                                pchar(sArquivoDestino),
                                pchar(sTipoFormato),
                                pchar(sTipoDownload),
                                pchar(sCOOInicial),
                                pchar(sCOOFinal),
                                pchar(sUsuario));
      }
      I := ECF_FormatoDadosMFD(PAnsiChar(AnsiString(sArquivoOrigem)),
                               PAnsiChar(AnsiString(sArquivoDestino)),
                               PAnsiChar(AnsiString(sTipoFormato)),
                               PAnsiChar(AnsiString(sTipoDownload)),
                               PAnsiChar(AnsiString(sCOOInicial)),
                               PAnsiChar(AnsiString(sCOOFinal)),
                               PAnsiChar(AnsiString(sUsuario))
                               );
      {Sandro Silva 2023-12-13 fim}
       //
    end;
  end;
  //
  if I =1 then Result := True else
  begin
//     if I = 0 then ShowMessage('Erro de comunucação') else ShowMessage('Não foi possível gerar o arquivo.'+chr(10)+chr(10)+'Erro: '+IntToStr(I)+chr(10)+chr(10)+'Status do ECF diferente de 6,0,0,0');
     Result := False;
  end;
  //
  //
end;

function _ecf14_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
begin
//  showmessage(pP1+chr(10)+pP2);
  if Form7.Label3.Caption = 'Data inicial:' then
    ECF_LeituraMemoriaFiscalDataMFD(PAnsiChar(AnsiString(pP1)), PAnsiChar(AnsiString(pP2)), PAnsiChar(AnsiString(Form1.sTipo)))//2024-03-06 ECF_LeituraMemoriaFiscalDataMFD( PAnsiChar( pP1 ), PAnsiChar( pP2 ) ,PAnsiChar(Form1.sTipo) ) // Sandro Silva 2023-12-13 ECF_LeituraMemoriaFiscalDataMFD( pchar( pP1 ), pchar( pP2 ) ,pChar(Form1.sTipo) )
  else
    ECF_LeituraMemoriaFiscalReducaoMFD(PAnsiChar(AnsiString(pP1)), PAnsiChar(AnsiString(pP2)), PAnsiChar(AnsiString(Form1.sTipo))); // Sandro Silva 2024-03-06 ECF_LeituraMemoriaFiscalReducaoMFD( PAnsiChar( pP1 ), PAnsiChar( pP2 ) ,PAnsiChar(Form1.sTipo)); // Sandro Silva 2023-12-13 ECF_LeituraMemoriaFiscalReducaoMFD( pchar( pP1 ), pchar( pP2 ) ,pChar(Form1.sTipo));
  Result := True;
end;


// -------------------------------- //
// Venda do Item                    //
// -------------------------------- //
function _ecf14_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
var
  sTipoDesc,sTipoQuant,sDesc:string;
begin
//  if _ecf14_TestaLigadaePapel(True) then
// begin

  if Copy(pP3,1,2)='IS' then pP3:=Right(pP3,2);
  //Junta a unidade de medida com a descrição
  pP2:=pP6 + ' ' + Copy(pP2,1,26);
  sTipoDesc:='%';
  sDesc:='0000';
  //
  if StrToInt(pP7) > 0 then
  begin
    sTipoDesc:='%';
    sDesc := Right(pP7,4);
  end else
  if StrToInt(pP8) > 0 then
  begin
    sTipoDesc:='$';
    sDesc:='0'+pP8; //8 digitos com 2 casas decimais
  end;
  ///////////////////////////////////////////////////////////////////////////////////////////////////
  //  compara os 2 ou 3 últimos dígitos para ver se é inteiro ou não, se for igual é inteiro       //
  //  if  Right(pP4,StrToInt(Form1.ConfCasas)) = Replicate('0',StrToInt(Form1.ConfCasas)) then     //
  //  Compara os tres últimos dígitos se for 000 é inteiro                                         //
  ///////////////////////////////////////////////////////////////////////////////////////////////////
  if  Right(pP4,3) = '000' then
  begin
    Delete(pP4,5,3);
    sTipoQuant:='I';
  end else sTipoQuant:='F';
  //
  //2024-03-06 Result:=(ECF_VendeItem( AnsiString( pP1 ), AnsiString( pP2 ), AnsiString( pP3 ), AnsiString( sTipoQuant ), AnsiString( pP4 ), 2 , AnsiString( pP5 ), AnsiString( sTipoDesc ), AnsiString( sDesc ) )=1); // Sandro Silva 2023-12-13 Result:=(ECF_VendeItem( pchar( pP1 ), pchar( pP2 ), pchar( pP3 ), pchar( sTipoQuant ), pchar( pP4 ), 2 , pchar( pP5 ), pchar( sTipoDesc ), pchar( sDesc ) )=1);
  Result := (ECF_VendeItem(PAnsiChar(AnsiString( pP1 )), PAnsiChar(AnsiString( pP2 )), PAnsiChar(AnsiString( pP3 )), PAnsiChar(AnsiString( sTipoQuant )), PAnsiChar(AnsiString( pP4 )), 2 , PAnsiChar(AnsiString( pP5 )), PAnsiChar(AnsiString( sTipoDesc )), PAnsiChar(AnsiString( sDesc )) )=1);
  //
  // if not Result then ShowMessage('Verifique: Impressora desligada ou desconectada'+chr(10)+' ou off-line.');
  //
end;

// -------------------------------- //
// Reducao Z                        //
// -------------------------------- //
function _ecf14_ReducaoZ(pP1: Boolean):Boolean;
var
  sData,sHora:String;
begin
  sData:=DateToStr(Date);
  sHora:=TimeToStr(Time);
  //2024-03-06 Result := (ECF_ReducaoZ( AnsiString(sData), AnsiString(sHora))=1); // Sandro Silva 2023-12-13 Result:=(ECF_ReducaoZ( pchar(sData), pchar(sHora))=1);
  Result := (ECF_ReducaoZ(PAnsiChar(AnsiString(sData)), PAnsiChar(AnsiString(sHora)))=1);
end;

// -------------------------------- //
// Leitura X                        //
// -------------------------------- //
function _ecf14_LeituraX(pP1: Boolean):Boolean;
begin
  Result:=(ECF_LeituraX()=1);
end;

// ---------------------------------------------- //
// Retorna se o horario de verão está selecionado //
// ---------------------------------------------- //
function _ecf14_RetornaVerao(pP1: Boolean):Boolean;
var
  I : Integer;
begin
  if ECF_FlagsFiscais( I )=1 then Result:=(Copy(Right(Replicate('0',8)+IntToBin( I ),8),6,1)='1') else Result:=False;
end;

// -------------------------------- //
// Liga ou desliga horário de verao //
// -------------------------------- //
function _ecf14_LigaDesLigaVerao(pP1: Boolean):Boolean;
begin
//  Result:=(ECF_ProgramaHorarioVerao()=1);
  REsult := False;
end;

// -------------------------------- //
// Retorna a versão do firmware     //
// -------------------------------- //
function _ecf14_VersodoFirmware(pP1: Boolean): String;
begin
  Result := Replicate(' ',4);
  if ECF_VersaoFirmware(PAnsiChar(AnsiString(Result))) <> 1 then Result := ''; // 2024-03-06 if ECF_VersaoFirmware(Result) <> 1 then Result:='';
end;

// -------------------------------- //
// Retorna o número de série        //
// -------------------------------- //
function _ecf14_NmerodeSrie(pP1: Boolean): String;
var
  i:integer;
begin
  // reserva 20 bytes para a variável
  Result := replicate(' ',20);
    if _ecf14_CodeErro(ECF_NumeroSerieMFD(PAnsiChar(AnsiString(Result)))) <> 1 then // Sandro Silva 2024-03-06 if _ecf14_CodeErro(ECF_NumeroSerieMFD( AnsiString(Result) )) <> 1 then // Sandro Silva 2023-12-14 if _ecf14_CodeErro(ECF_NumeroSerieMFD( Result )) <> 1 then
    Result:='';
  //a rotina abaixo retira os chr(0)s que voltam na variável
  for i:=1 to 20 do if ord(Result[i])=0 then Break;
  if i>0 then Result:=AllTrim(Copy(Result,1,i-1));
end;

// -------------------------------- //
// Retorna o CGC e IE               //
// -------------------------------- //
function _ecf14_CGCIE(pP1: Boolean): String;
var
  sCGC,sIE:string;
begin
  sCGC := Replicate(' ',18);
  sIE  := Replicate(' ',15);
  if _ecf14_CodeErro(ECF_CGC_IE(PAnsiChar(AnsiString(sCGC)), PAnsiChar(AnsiString(sIE)))) <> 1 then Result := '' else Result := sCGC+'-'+sIE; // 2024-03-06 if _ecf14_CodeErro(ECF_CGC_IE( sCGC, sIE )) <> 1 then Result := '' else Result := sCGC+'-'+sIE;
end;

// --------------------------------- //
// Retorna o valor  de cancelamentos //
// --------------------------------- //
function _ecf14_Cancelamentos(pP1: Boolean): String;
begin
  Result:=Replicate(' ',14);
  if ECF_Cancelamentos(PAnsiChar(AnsiString(Result))) <> 1 then Result := ''; // 2024-03-06 if ECF_Cancelamentos( Result ) <> 1 then Result:='';
end;

// -------------------------------- //
// Retorna o valor de descontos     //
// -------------------------------- //
function _ecf14_Descontos(pP1: Boolean): String;
begin
  Result:=Replicate(' ',14);
  if ECF_Descontos(PAnsiChar(AnsiString(Result))) <> 1 then Result := ''; //2024-03-06 if ECF_Descontos( Result ) <> 1 then Result:='';
end;

// -------------------------------- //
// Retorna o contador sequencial    //
// -------------------------------- //
function _ecf14_ContadorSeqencial(pP1: Boolean): String;
begin
  Result:=Replicate(' ',6);
  if ECF_NumeroCupom(PAnsiChar(AnsiString(Result))) <> 1 then Result:=''; // 2024-03-06 if ECF_NumeroCupom( Result ) <> 1 then Result:='';
end;

// -------------------------------- //
// Retorna o número de operações    //
// não fiscais acumuladas           //
// -------------------------------- //
function _ecf14_Nmdeoperaesnofiscais(pP1: Boolean): String;
begin
  Result := Replicate(' ', 631);
  if ECF_DadosUltimaReducao(PAnsiChar(AnsiString(Result))) <> 1 then //2024-03-06 if ECF_DadosUltimaReducao(AnsiString(Result) ) <> 1 then
    Result := ''
  else
    Result := Copy(Result, 586, 6);
end;

function _ecf14_NmdeCuponscancelados(pP1: Boolean): String;
begin
  Result:=Replicate(' ',4);
  if (ECF_NumeroCuponsCancelados(PansiChar(AnsiString(Result))) <> 1) then Result := ''; // 2024-03-06 if (ECF_NumeroCuponsCancelados( Result ) <> 1) then Result:='';
end;

function _ecf14_NmdeRedues(pP1: Boolean): String;
begin
  {Sandro Silva 2023-12-14 inicio
  Result:=Replicate(' ',4);
  if (ECF_NumeroReducoes( Result ) <> 1) then Result:='' else Result:=StrZero(StrToInt(Result)+1,4,0);//soma um para gravar certo no arq. de reduções.
  }
  Result := AnsiString(Replicate(' ', 4));
  if (ECF_NumeroReducoes(PAnsiChar(AnsiString(Result))) <> 1) then // 2024-03-06 if (ECF_NumeroReducoes( Result ) <> 1) then
    Result := ''
  else
    Result := StrZero(StrToIntDef(Result, 0) + 1, 4, 0);//soma um para gravar certo no arq. de reduções.
end;

function _ecf14_Nmdeintervenestcnicas(pP1: Boolean): String;
begin
  Result := AnsiString(Replicate(' ',4)); // Sandro Silva 2023-12-14 Result := (Replicate(' ',4);
  if (ECF_NumeroIntervencoes(PAnsiChar(AnsiString(Result))) <> 1) then Result := ''; // 2024-03-06 if (ECF_NumeroIntervencoes( Result ) <> 1) then Result:='';
end;


function _ecf14_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
begin
  {Sandro Silva 2023-12-14 inicio
  Result:=Replicate(' ',4);
  if (ECF_NumeroSubstituicoesProprietario( Result ) <> 1) then Result:='';
  }
  Result := AnsiString(Replicate(' ', 4));
  if (ECF_NumeroSubstituicoesProprietario(PAnsiCHar(AnsiString(Result))) <> 1) then// 2024-03-06 if (ECF_NumeroSubstituicoesProprietario( Result ) <> 1) then
    Result := '';

end;

function _ecf14_Clichdoproprietrio(pP1: Boolean): String;
begin
  Result:=Replicate(' ',186);
  if (ECF_ClicheProprietario(PAnsiChar(AnsiString(Result))) <> 1) then Result:=''; // 2024-03-06 if (ECF_ClicheProprietario( Result ) <> 1) then Result:='';
end;

// ------------------------------------ //
// Importante retornar apenas 3 dígitos //
// Ex: 001                              //
// ------------------------------------ //
function _ecf14_NmdoCaixa(pP1: Boolean): String;
begin
  Result := AnsiString(Replicate(' ', 4)); // Sandro Silva 2023-12-14 Result := Replicate(' ',4);
  _ecf14_CodeErro(ECF_NumeroCaixa(PAnsiChar(AnsiString(Result)))); // 2024-03-06 _ecf14_CodeErro(ECF_NumeroCaixa( Result ));
  Result := Right(Result, 3);
end;

function _ecf14_Nmdaloja(pP1: Boolean): String;
begin
  Result := AnsiString(Replicate(' ', 4)); // Sandro Silva 2023-12-14 Result:=Replicate(' ',4);
  _ecf14_CodeErro(ECF_NumeroLoja(PAnsiChar(AnsiString(Result)))); // 2024-03-06 _ecf14_CodeErro(ECF_NumeroLoja( Result ));
end;

function _ecf14_Moeda(pP1: Boolean): String;
begin
  Result := AnsiString(Replicate(' ', 2)); // Sandro Silva 2023-12-14   Result:=Replicate(' ',2);
  _ecf14_CodeErro(ECF_SimboloMoeda(PAnsiChar(AnsiString(Result)))); // 2024-03-06 _ecf14_CodeErro(ECF_SimboloMoeda( Result ));
  Result:=StrTran(AllTrim(Result),'$','');
end;

function _ecf14_Dataehoradaimpressora(pP1: Boolean): String;
var
 sData,sHora:String;
begin
 sData := Replicate(' ',6);
 sHora := Replicate(' ',6);
 _ecf14_CodeErro(ECF_DataHoraImpressora(PansiChar(AnsiString(sData)), PAnsiChar(AnsiString(sHora)))); // Sandro Silva 2024-03-06 _ecf14_CodeErro(ECF_DataHoraImpressora(AnsiString(sData), AnsiString(sHora))); // Sandro Silva 2023-12-14 _ecf14_CodeErro(ECF_DataHoraImpressora(sData,sHora));
 Result := sData + sHora;//DDMMAAHHMMSS
end;

function _ecf14_DataUltimaReducao: String;
var
  sData: string;
  sHora: string;
begin
  Result := '00/00/2000';
  sData := Replicate(' ',6);
  sHora := Replicate(' ',6);

  try
    ECF_DataHoraReducao(PAnsiChar(AnsiString(sData)), PAnsiChar(AnsiString(sHora))); // Sandro Silva 2024-03-06 ECF_DataHoraReducao(AnsiString(sData), AnsiString(sHora)); // Sandro Silva 2023-12-14 ECF_DataHoraReducao(sData, sHora);
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

function _ecf14_Datadaultimareduo(pP1: Boolean): String;
begin
  Result := Replicate(' ', 6);
  if ECF_DataMovimento(PAnsiChar(AnsiString(Result))) <> 1 then //2024-03-06 if ECF_DataMovimento( AnsiString(Result) ) <> 1 then
    Result := '';
end;


function _ecf14_Datadomovimento(pP1: Boolean): String;
begin
  Result := Replicate(' ', 6);
  if ECF_DataMovimento(PAnsiChar(AnsiString(Result))) <> 1 then //2024-03-06 if ECF_DataMovimento(AnsiString(Result)) <> 1 then
    Result := '';
end;

// Deve retornar uma String com:                                          //
// Os 2 primeiros dígitos são o número de aliquotas gravadas: Ex 16       //
// os póximos de 4 em 4 são as aliquotas Ex: 1800                         //
// Ex: 161800120005000000000000000000000000000000000000000000000000000000 //
// retorna + 64 caracteres quando tem ISS                                 //

function _ecf14_RetornaAliquotas(pP1: Boolean): String;
var
  sISS, sAliquotas, sIndiceAliquotas : String;
  i:integer;
begin
//  AliquotasIss:=Replicate(' ',79);
//  iRetorno := ECF_VerificaAliquotasIss( AliquotasIss );
  Result := '';
  sAliquotas := Replicate(' ', 79);
  if _ecf14_CodeErro(ECF_RetornoAliquotas(PAnsiChar(AnsiString(sAliquotas)))) = 1 then// 2024-03-06 if _ecf14_CodeErro(ECF_RetornoAliquotas(AnsiString(sAliquotas) )) = 1 then
  begin
    Result:=Copy(AllTrim(LimpaNumero(sAliquotas))+Replicate('0',64),1,64);//tira as vírgulas
    sISS:='';
    //verifica qual é a aliquota de ISS
    sIndiceAliquotas:=Replicate(' ',48);
    if _ecf14_CodeErro(ECF_VerificaIndiceAliquotasIss(PAnsiChar(AnsiString(sIndiceAliquotas)))) = 1 then//2024-03-06 if _ecf14_CodeErro(ECF_VerificaIndiceAliquotasIss(AnsiString(sIndiceAliquotas) ))=1 then
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
//      showmessage(Result+chr(10)+inttostr(Length(Result)));
      Result:='16'+Result+sISS;
//      showmessage(Result+chr(10)+inttostr(Length(Result)));
    end;
  end;
end;


function _ecf14_Vincula(pP1: String): Boolean;
begin
   Result:=False;
end;


function _ecf14_FlagsDeISS(pP1: Boolean): String;
var
  sIndiceAliquotas: String;
begin
  sIndiceAliquotas := Replicate('0',48);
  ECF_VerificaIndiceAliquotasIss(PAnsiChar(AnsiString(sIndiceAliquotas))); //2024-03-06 ECF_VerificaIndiceAliquotasIss( sIndiceAliquotas );
  //o retorno é a alíquota separada por vírgula
  Result := Replicate('0',16);
  sIndiceAliquotas := AllTrim(sIndiceAliquotas);
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
  Result:=chr(BinToInt(Copy(Result,1,8)))+chr(BinToInt(Copy(Result,9,8)));
end;

function _ecf14_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
var
  I : Integer;
begin
  //
  //ShowMessage('Teste fechando a porta serial');
  //
  i := ECF_FechaPortaSerial();
  if i = 1 then Result := True else Result := False;
  //
  // ShowMessage('Teste Ok');
  //
end;

function _ecf14_MudaMoeda(pP1: String): Boolean;
begin
//  Result:=(_ecf14_CodeErro(ECF_AlteraSimboloMoeda( pchar( pP1 ) ))=1)
  Result := False;
end;

function _ecf14_MostraDisplay(pP1: String): Boolean;
begin
  Result := True;
end;

function _ecf14_leituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
begin
  Screen.Cursor := crHourGlass; // Cursor de Aguardo
  if Form7.Label3.Caption = 'Data inicial:' then
  begin
    ECF_LeituraMemoriaFiscalSerialDataMFD(PAnsiChar(AnsiString(pP2)), PAnsiChar(AnsiString(pP3)), PAnsiChar(AnsiString(Form1.sTipo))); // Sandro Silva 2024-03-06 ECF_LeituraMemoriaFiscalSerialDataMFD(PAnsiChar(pP2),PAnsiChar(pP3),PAnsiChar(Form1.sTipo)); // Sandro Silva 2023-12-13 ECF_LeituraMemoriaFiscalSerialDataMFD(pchar(pP2),pchar(pP3),pChar(Form1.sTipo));
  end else
  begin
    ECF_LeituraMemoriaFiscalSerialReducaoMFD(PAnsiChar(AnsiString(pP2)), PAnsiChar(AnsiString(pP3)), PAnsiChar(AnsiString(Form1.sTipo))); // Sandro Silva 2024-03-06 ECF_LeituraMemoriaFiscalSerialReducaoMFD(PAnsiChar(pP2),PAnsiChar(pP3),PAnsiChar(Form1.sTipo)); // Sandro Silva 2023-12-13 ECF_LeituraMemoriaFiscalSerialReducaoMFD(pchar(pP2),pchar(pP3),pChar(Form1.sTipo));
  end;
  CopyFile('c:\retorno.txt', pChar(pP1), True );
  // CopyFile( pChar(Form1.sAtual+'\'+'Retorno.txt') , pChar(pP1), True );
//  Screen.Cursor := crDefault; // Cursor normal
// ShowMessage(pChar(pP1)+chr(10)+pChar(Form1.sAtual+'\'+'Retorno.txt'));
  Result := True;
end;


function _ecf14_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean; //iP2 = Número do Cupom vinculado
var
  I: Integer;
  sPar1,sPar2, sX: String;
begin
  //
  begin
     //
     Result := False;
     //
     Sleep(500);
     //
     sPar1:='';
     sPar2:='';
     //
      {Sandro Silva 2023-12-13 inicio
     if Form1.ibDataSet25DIFERENCA_.AsFloat > 0 then Result := (ECF_AbreComprovanteNaoFiscalVinculado( pchar(AllTrim(Form2.Label17.Caption)) ,  pchar( sPar1 ), pchar( sPar2 ) )=1);
     if Form1.ibDataSet25PAGAR.AsFloat >      0 then Result := (ECF_AbreComprovanteNaoFiscalVinculado( pchar(AllTrim(Form2.Label8.Caption))  , pchar( sPar1 ), pchar( sPar2 ) )=1);
     if Form1.ibDataSet25ACUMULADO1.AsFloat > 0 then Result := (ECF_AbreComprovanteNaoFiscalVinculado( pchar(AllTrim(Form2.Label9.Caption))  , pchar( sPar1 ), pchar( sPar2 ) )=1);
     }
     {2024-03-06
     if Form1.ibDataSet25DIFERENCA_.AsFloat > 0 then Result := (ECF_AbreComprovanteNaoFiscalVinculado( PAnsiChar(AllTrim(Form2.Label17.Caption)) ,  PAnsiChar( sPar1 ), PAnsiChar( sPar2 ) )=1);
     if Form1.ibDataSet25PAGAR.AsFloat >      0 then Result := (ECF_AbreComprovanteNaoFiscalVinculado( PAnsiChar(AllTrim(Form2.Label8.Caption))  , PAnsiChar( sPar1 ), PAnsiChar( sPar2 ) )=1);
     if Form1.ibDataSet25ACUMULADO1.AsFloat > 0 then Result := (ECF_AbreComprovanteNaoFiscalVinculado( PAnsiChar(AllTrim(Form2.Label9.Caption))  , PAnsiChar( sPar1 ), PAnsiChar( sPar2 ) )=1);
     }
     if Form1.ibDataSet25DIFERENCA_.AsFloat > 0 then Result := (ECF_AbreComprovanteNaoFiscalVinculado(PAnsiChar(AnsiString(AllTrim(Form2.Label17.Caption))),  PAnsiChar(AnsiString(sPar1)), PAnsiChar(AnsiString(sPar2))) = 1);
     if Form1.ibDataSet25PAGAR.AsFloat >      0 then Result := (ECF_AbreComprovanteNaoFiscalVinculado(PAnsiChar(AnsiString(AllTrim(Form2.Label8.Caption)))  , PAnsiChar(AnsiString(sPar1)), PAnsiChar(AnsiString(sPar2))) = 1);
     if Form1.ibDataSet25ACUMULADO1.AsFloat > 0 then Result := (ECF_AbreComprovanteNaoFiscalVinculado(PAnsiChar(AnsiString(AllTrim(Form2.Label9.Caption)))  , PAnsiChar(AnsiString(sPar1)), PAnsiChar(AnsiString(sPar2))) = 1);
     //
     if Result = True then
     begin
      //Verifica o estado da impressora
      Result := (ECF_VerificaImpressoraLigada() = 1);
      if Result then
      begin
        sX := '';
        for I := 1 to Length(sP1) do
        begin
          if Result = True then
          begin
             if Copy(sP1, I, 1) <> chr(10) then
             begin
               sX := sX + Copy(sP1, I, 1);
             end else
             begin
               if AllTrim(sX) <> '' then
               begin
                 //imprime a linha
                 Result := (ECF_UsaComprovanteNaoFiscalVinculado(PAnsiChar(AnsiString(sX)) ) = 1); // Sandro Silva 2024-03-06 Result := (ECF_UsaComprovanteNaoFiscalVinculado( PAnsiChar( sX ) )=1); // Sandro Silva 2023-12-13 Result:=(ECF_UsaComprovanteNaoFiscalVinculado( pchar( sX ) )=1);
                 if Result then Result:=_ecf14_TestaLigadaePapel(True);
                 //Result:=(ECF_VerificaImpressoraLigada()=1);
                 sX:='';
               end else
               begin
                 sX:=Replicate(' ',40);
                 Result:=(ECF_UsaComprovanteNaoFiscalVinculado(PAnsiChar(AnsiString(sX))) = 1); // Sandro Silva 2024-03-06 Result:=(ECF_UsaComprovanteNaoFiscalVinculado( PAnsiChar( sX ) )=1); // Sandro Silva 2023-12-13 Result:=(ECF_UsaComprovanteNaoFiscalVinculado( pchar( sX ) )=1);
                 if Result then Result:=_ecf14_TestaLigadaePapel(true);
                 sX:='';
               end;
             end;
          end;
        end;
        //
        if AllTrim(sX) <> '' then
        begin
          ECF_UsaComprovanteNaoFiscalVinculado(PAnsiChar(AnsiString(sX))); // Sandro Silva 2024-03-06 ECF_UsaComprovanteNaoFiscalVinculado( PAnsiChar( sX ) ); // Sandro Silva 2023-12-13 ECF_UsaComprovanteNaoFiscalVinculado( pchar( sX ) );
        end;
        //
      end;
    end;
    ECF_FechaComprovanteNaoFiscalVinculado();
    Result:=_ecf14_TestaLigadaePapel(true);
    //Result:=(_ecf14_CodeErro(ECF_VerificaImpressoraLigada())=1);
  end;
end;

function _ecf14_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
var
  I : Integer;
  sLinha : String;
  //
begin
  //
  Result:=(ECF_VerificaImpressoraLigada()=1);
  //
  if Result then
  begin
    //
    if Pos('IDENTIFICAÇÃO DO PAF-ECF',sP1)<>0 then
    begin
      ECF_AbreRelatorioGerencialMFD('03'); // Identificação do PAF
    end else
    begin
      if Pos('Período Solicitado: de',sP1)<>0 then
      begin
        ECF_AbreRelatorioGerencialMFD('06'); // Meios de pagamento
      end else
      begin
        if (Pos('Documento: ',sP1)<>0) or (Pos(TITULO_PARCELAS_CARNE_RESUMIDO, sP1) > 0) then  // Sandro Silva 2018-04-29  if Pos('Documento: ',sP1)<>0 then
        begin
          ECF_AbreRelatorioGerencialMFD('04'); // Venda a prazo
        end else
        begin
          if Pos('DAV EMITIDOS',sP1)<>0 then
          begin
            ECF_AbreRelatorioGerencialMFD('07'); // DAV Emitidos
          end else
          begin
            if Pos('AUXILIAR DE VENDA (DAV) - OR',sP1)<>0 then
            begin
              ECF_AbreRelatorioGerencialMFD('08'); // Orçamento (DAV)
            end else
            begin
              if Pos('CONFERENCIA DE CONTA',sP1)<>0 then
              begin
                ECF_AbreRelatorioGerencialMFD('09'); // Conferencia de contas
              end else
              begin
                if Pos('TRANSFERENCIAS ENTRE CONTA',sP1)<>0 then
                begin
                  ECF_AbreRelatorioGerencialMFD('10'); // Transferencia entre contas
                end else
                begin
                  // Sandro Silva 2016-02-04 POLIMIG  if (Pos('CONTAS DE CLIENTES ABERTAS',sP1)<>0) or (Pos('CONTAS DE CLIENTES OS ABERTAS',sP1)<>0) or (Pos('NENHUMA',sP1)<>0) then
                  if (Pos('CONTAS DE CLIENTES ABERTAS',sP1)<>0)
                    or (Pos('CONTAS DE CLIENTES OS ABERTAS',sP1)<>0)
                    or ((Pos('NENHUMA',sP1)<>0) and (Pos('CONTA DE CLIENTE',sP1)<>0)) then
                  begin
                    ECF_AbreRelatorioGerencialMFD('11'); // Mesas contas
                  end else
                  begin
                    if Pos('CONFERENCIA DE MESA',sP1)<>0 then
                    begin
                      ECF_AbreRelatorioGerencialMFD('12'); // Conferencia de contas
                    end else
                    begin
                      if Pos('TRANSFERENCIAS ENTRE MESA',sP1)<>0 then
                      begin
                        ECF_AbreRelatorioGerencialMFD('13'); // Transferencia entre contas
                      end else
                      begin
                        // Sandro Silva 2016-02-04 POLIMIG  if Pos('MESAS ABERTAS',sP1)<>0 then
                        if (Pos('MESAS ABERTAS',sP1)<>0) or
                         (Pos('NENHUMA MESA',sP1)<>0) then
                        begin
                          ECF_AbreRelatorioGerencialMFD('14'); // Mesas contas
                        end else
                        begin
                          if Pos('Parametros de Configuracao',sP1)<>0 then
                          begin
                            ECF_AbreRelatorioGerencialMFD('15'); // Parâmetros de Configuração
                          end else
                          begin
                            ECF_AbreRelatorioGerencialMFD('05'); // CARTAO TEF
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
  end;
  //
  if Result then
  begin
    //
    sLinha := '';
    //
    for I := 1 to Length(sP1) do
    begin
      //
      if Result then
      begin
        if (Copy(sP1,I,1) = chr(10)) or ( Length(sLinha) >=47 ) then // Linha pode ter no maximo 55 caracteres;
        begin
          //
          if (Copy(sP1,I,1) <> chr(10)) then sLinha := sLinha+Copy(sP1,I,1);
          //
          if sLinha = '' then sLinha := ' ';
          //2024-03-06 Result := (ECF_UsaRelatorioGerencialMFD(PAnsiChar(sLinha))=1);; // Sandro Silva 2023-12-13 Result := (ECF_UsaRelatorioGerencialMFD(pchar(sLinha))=1);;
          Result := (ECF_UsaRelatorioGerencialMFD(PAnsiChar(AnsiString(sLinha))) = 1);
          if Result then Result:=_ecf14_TestaLigadaePapel(true);
          sLinha    := '';
          //
        end else
        begin
          //
          sLinha := sLinha+Copy(sP1,I,1);
          //
        end;
      end;
    end;
    //
    for I := 1 to 3 do
      if Result then
        Result := (ECF_UsaRelatorioGerencialMFD(PAnsiChar('           '))=1);; // Sandro Silva 2023-12-13 Result := (ECF_UsaRelatorioGerencialMFD(pChar('           '))=1);;
    //
    if Result then Result := (ECF_FechaRelatorioGerencial()=1);  // Fecha cupom não sujeito ao ICMS
    if Result then Result:=_ecf14_TestaLigadaePapel(true);
    //
  end;
  //
end;

function _ecf14_FechaCupom2(sP1: Boolean): Boolean;
begin
  Result:=(ECF_FechaComprovanteNaoFiscalVinculado()=1);
  if not result then Result := (ECF_FechaRelatorioGerencial()=1);
end;

function _ecf14_ImprimeCheque(rP1: Real; sP2: String): Boolean;
begin
  Result:=False;
end;

function _ecf14_GrandeTotal(sP1: Boolean): String;
begin
  Result := Replicate(' ',18);
  if _ecf14_CodeErro(ECF_GrandeTotal(PAnsiChar(AnsiString(Result)))) <> 1 then Result := '0'; // 2024-03-06 if _ecf14_CodeErro(ECF_GrandeTotal( Result )) <> 1 then Result:='0';
end;

function _ecf14_TotalizadoresDasAliquotas(sP1: Boolean): String;
begin
  Result:=Replicate(' ',445);
  if ECF_VerificaTotalizadoresParciais(PAnsiChar(AnsiString(Result))) <> 1 then // 2024-03-06 if ECF_VerificaTotalizadoresParciais(AnsiString(Result)) <> 1 then
    Result := ''
  else
    Result := Copy(Result, 1, 224) + Copy(Result, 226, 14) + Copy(Result, 241, 14) + Copy(Result, 256, 14);
end;

function _ecf14_CupomAberto(sP1: Boolean): boolean;
var
  iACK,iST1,iST2:integer;
begin
  //
  iACK := 0; iST1 := 0; iST2 := 0;
  ECF_VerificaEstadoImpressora(iACK, iST1, iST2);
//  ShowMEssage(IntToStr(iACk)+Chr(10)+IntToStr(isT1)+Chr(10)+IntToStr(isT2));
  if (iSt1 = 2) or (iSt1 = 66) then Result := True else Result := False;
  //

{
var
  sACK,sST1,sST2, sSt3 :String;
begin
  //
sAck := '   ';
sSt1 := '   ';
sSt2 := '   ';
sSt3 := '   ';
  //
  ECF_RetornoImpressoraStr(sACK,sST1,sST2, sSt3);
  //
  ShowMEssage('Status da impressora: '+chr(10)+sACk+Chr(10)+ssT1+Chr(10)+ssT2);
  //
  if sSt1 = '2' then Result := True else Result := False;
}
  //
end;

function _ecf14_FaltaPagamento(sP1: Boolean): boolean;
//var
//  iACK,iST1,iST2:integer;
//  I : integer;
begin
  //
//  iACK := 0; iST1 := 0; iST2 := 0;
//  ECF_VerificaEstadoImpressora(iACK, iST1, iST2);
//  ShowMEssage(IntToStr(iACk)+Chr(10)+IntToStr(isT1)+Chr(10)+IntToStr(isT2));
  //
  Result:=False;
  //
end;

function _ecf14_DadosUltimaReducaoZ(sP1: Boolean): String;
var
  sDados : String;
begin
  sDados := Replicate(' ',1278);
  ECF_DadosUltimaReducaoMFD(PAnsiChar(AnsiString(sDados))); // Sandro Silva 2024-03-06 ECF_DadosUltimaReducaoMFD(PAnsiChar(sDados)); // Sandro Silva 2023-12-13 ECF_DadosUltimaReducaoMFD(pChar(sDados));
  Result := sDados;
end;

function _ecf14_Marca(sP1: Boolean): String;
var
  sMarca, sModelo, sTipo: String;
begin
  sMarca  := Replicate(' ',15);
  sModelo := Replicate(' ',20);
  sTipo   := Replicate(' ',7);
  ECF_MarcaModeloTipoImpressoraMFD(PansiChar(AnsiString(sMarca)), PAnsiChar(AnsiString(sModelo)), PAnsiChar(AnsiString(sTipo))); // Sandro Silva 2024-03-06 ECF_MarcaModeloTipoImpressoraMFD(PansiChar(sMarca), PAnsiChar(sModelo), PAnsiChar(sTipo)); // Sandro Silva 2023-12-13 ECF_MarcaModeloTipoImpressoraMFD(pChar(sMarca), pChar(sModelo), pChar(sTipo));
  Result := sMarca;
end;

function _ecf14_Modelo(sP1: Boolean): String;
var
  sMarca, sModelo, sTipo: String;
begin
  sMarca  := Replicate(' ',15);
  sModelo := Replicate(' ',20);
  sTipo   := Replicate(' ',7);
  ECF_MarcaModeloTipoImpressoraMFD(PansiChar(AnsiString(sMarca)), PAnsiChar(AnsiString(sModelo)), PAnsiChar(AnsiString(sTipo))); // Sandro Silva 2024-03-06 ECF_MarcaModeloTipoImpressoraMFD(PansiChar(sMarca), PAnsiChar(sModelo), PAnsiChar(sTipo)); // Sandro Silva 2023-12-13 ECF_MarcaModeloTipoImpressoraMFD(pChar(sMarca), pChar(sModelo), pChar(sTipo));
  Result := sModelo;
end;

function _ecf14_Tipodaimpressora(pP1: Boolean): String; //
var
  sMarca, sModelo, sTipo: String;
begin
  sMarca  := Replicate(' ',15);
  sModelo := Replicate(' ',20);
  sTipo   := Replicate(' ',7);
  ECF_MarcaModeloTipoImpressoraMFD(PAnsiChar(AnsiString(sMarca)), PAnsiChar(AnsiString(sModelo)), PAnsiChar(AnsiString(sTipo))); // Sandro Silva 2024-03-06 ECF_MarcaModeloTipoImpressoraMFD(PAnsiChar(sMarca), PAnsiChar(sModelo), PAnsiChar(sTipo)); // Sandro Silva 2023-12-13 ECF_MarcaModeloTipoImpressoraMFD(pChar(sMarca), pChar(sModelo), pChar(sTipo));
  Result := sTipo;
end;

function _ecf14_VersaoSB(pP1: Boolean): String; //
begin
  Result := '01.00.04';
end;

function _ecf14_HoraIntalacaoSB(pP1: Boolean): String; //
begin
  Result := '172925';
end;

function _ecf14_DataIntalacaoSB(pP1: Boolean): String; //
begin
  Result := '180506';
end;

function _ecf14_DadosDaUltimaReducao(pP1: Boolean): String; //
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
  ECF_DadosUltimaReducaoMFD(PAnsiChar(AnsiString(sRetorno))); // Sandro Silva 2024-03-06 ECF_DadosUltimaReducaoMFD(PAnsiChar(sRetorno)); // Sandro Silva 2023-12-13 ECF_DadosUltimaReducaoMFD(pChar(sRetorno));
  //
  Result := Copy(sRetorno,1273,  6)+ //   1,  6 Data
            Copy(sRetorno,  14,  6)+ //   7,  6 COO
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
  // Falta testar
  //
end;

//
// Retorna o Código do Modelo do ECF Conf Tabéla Nacional de Identificação do ECF
//
function _ecf14_CodigoModeloEcf(pP1: Boolean): String; //
begin
  Result := '381702';
  if Form1.sCodigoIdentificaEcf <> '' then
    Result := Form1.sCodigoIdentificaEcf;
end;


end.



