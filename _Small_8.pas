unit _Small_8;

interface

uses
  Windows, Messages, SmallFunc, Fiscal, SysUtils,Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Mask, Grids, DBGrids, DB, DBCtrls, SMALL_DBEdit, IniFiles, Unit2,
  Unit7, unit22;

  //--------------------------------------------------------------------------//
  // Módulo para Impressora Yanco/Bematech                                    //
  // Utiliza a nova dll da Bematech                                           //
  // 13/02/2003                                                               //
  // Alterado p/versão 2004 19/12/2003                                        //
  // 01/06/2004 alterado pack (download para MG)                              //
  // 24/11/2004 Alterado para funcionar tambem com Bematech                   //
  // 15/12/2004 2005                                                          //
  // 11/02/2005 2a via vinculado e limite de crédito                          //
  //--------------------------------------------------------------------------//

  { Declaração das Funções da nova DLL BEMAFI32.DLL }

  // Funções de Inicialização ////////////////////////////////////////////////////

  function Bematech_FI_AlteraSimboloMoeda(SimboloMoeda: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ProgramaAliquota(Aliquota: String; ICMS_ISS: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ProgramaHorarioVerao: Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_NomeiaDepartamento(Indice: Integer; Departamento: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_NomeiaTotalizadorNaoSujeitoIcms(Indice: Integer; Totalizador: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ProgramaArredondamento:Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ProgramaTruncamento:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_ProgramaTruncamento';
  function Bematech_FI_LinhasEntreCupons(Linhas: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_EspacoEntreLinhas(Dots: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ForcaImpactoAgulhas(ForcaImpacto: Integer): Integer; StdCall; External 'BEMAFI32.DLL';

  // Funções do Cupom Fiscal /////////////////////////////////////////////////////

  function Bematech_FI_AbreCupom(CGC_CPF: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VendeItem(Codigo: String; Descricao: String; Aliquota: String; TipoQuantidade: String; Quantidade: String; CasasDecimais: Integer; ValorUnitario: String; TipoDesconto: String; Desconto: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VendeItemDepartamento(Codigo: String; Descricao: String; Aliquota: String; ValorUnitario: String; Quantidade: String; Acrescimo: String; Desconto: String; IndiceDepartamento: String; UnidadeMedida: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_CancelaItemAnterior: Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_CancelaItemGenerico(NumeroItem: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_CancelaCupom: Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_FechaCupomResumido(FormaPagamento: String; Mensagem: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_FechaCupom(FormaPagamento: String; AcrescimoDesconto: String; TipoAcrescimoDesconto: String; ValorAcrescimoDesconto: String; ValorPago: String; Mensagem: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ResetaImpressora:Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_IniciaFechamentoCupom(AcrescimoDesconto: String; TipoAcrescimoDesconto: String; ValorAcrescimoDesconto: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_EfetuaFormaPagamento(FormaPagamento: String; ValorFormaPagamento: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_EfetuaFormaPagamentoDescricaoForma(FormaPagamento: string; ValorFormaPagamento: string; DescricaoFormaPagto: string ): integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_TerminaFechamentoCupom(Mensagem: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_EstornoFormasPagamento(FormaOrigem: String; FormaDestino: String; Valor: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_UsaUnidadeMedida(UnidadeMedida: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_AumentaDescricaoItem(Descricao: String): Integer; StdCall; External 'BEMAFI32.DLL';

  // Funções dos Relatórios Fiscais //////////////////////////////////////////////

  function Bematech_FI_LeituraX:Integer; StdCall; External 'BEMAFI32.DLL' ;
  function Bematech_FI_ReducaoZ(Data: String; Hora: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_RelatorioGerencial(Texto: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_FechaRelatorioGerencial:Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_LeituraMemoriaFiscalData(DataInicial: String; DataFinal: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_LeituraMemoriaFiscalReducao(ReducaoInicial: String; ReducaoFinal: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_LeituraMemoriaFiscalSerialData(DataInicial: String; DataFinal: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_LeituraMemoriaFiscalSerialReducao(ReducaoInicial: String; ReducaoFinal: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_DownloadMFD(sArquivo:String; DataInicial: String; DataFinal: String): Integer; StdCall; External 'BEMAFI32.DLL';

  // Funções das Operações Não Fiscais ///////////////////////////////////////////

  function Bematech_FI_RecebimentoNaoFiscal(IndiceTotalizador: String; Valor: String; FormaPagamento: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_AbreComprovanteNaoFiscalVinculado(FormaPagamento: String; Valor: String; NumeroCupom: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_UsaComprovanteNaoFiscalVinculado(Texto: String): Integer; StdCall; External 'BEMAFI32.DLL'
  function Bematech_FI_FechaComprovanteNaoFiscalVinculado:Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_Sangria(Valor: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_Suprimento(Valor: String; FormaPagamento: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_SegundaViaNaoFiscalVinculadoMFD(): Integer; StdCall; External 'BEMAFI32.DLL';

  // Funções de Informações da Impressora ////////////////////////////////////////

  function Bematech_FI_NumeroSerie(NumeroSerie: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_NumeroSerieMFD(NumeroSerie: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_SubTotal(SubTotal: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_NumeroCupom(NumeroCupom: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_LeituraXSerial: Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VersaoFirmware(VersaoFirmware: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_CGC_IE(CGC: String; IE: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_GrandeTotal(GrandeTotal: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_Cancelamentos(ValorCancelamentos: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_Descontos(ValorDescontos: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_NumeroOperacoesNaoFiscais(NumeroOperacoes: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_NumeroCuponsCancelados(NumeroCancelamentos: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_NumeroIntervencoes(NumeroIntervencoes: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_NumeroReducoes(NumeroReducoes: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_NumeroSubstituicoesProprietario(NumeroSubstituicoes: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_UltimoItemVendido(NumeroItem: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ClicheProprietario(Cliche: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_NumeroCaixa(NumeroCaixa: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_NumeroLoja(NumeroLoja: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_SimboloMoeda(SimboloMoeda: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_MinutosLigada(Minutos: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_MinutosImprimindo(Minutos: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VerificaModoOperacao(Modo: string): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VerificaEpromConectada(Flag: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_FlagsFiscais(Var Flag: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ValorPagoUltimoCupom(ValorCupom: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_DataHoraImpressora(Data: String; Hora: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ContadoresTotalizadoresNaoFiscais(Contadores: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VerificaTotalizadoresNaoFiscais(Totalizadores: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_DataHoraReducao(Data: String; Hora: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_DataMovimento(Data: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VerificaTruncamento(Flag: string): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_Acrescimos(ValorAcrescimos: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ContadorBilhetePassagem(ContadorPassagem: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VerificaAliquotasIss(Flag: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VerificaFormasPagamento(Formas: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VerificaRecebimentoNaoFiscal(Recebimentos: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VerificaDepartamentos(Departamentos: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VerificaTipoImpressora(Var TipoImpressora: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VerificaTotalizadoresParciais(Totalizadores: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_RetornoAliquotas(Aliquotas: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VerificaEstadoImpressora(Var ACK: Integer; Var ST1: Integer; Var ST2: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_DadosUltimaReducao(DadosReducao: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_MonitoramentoPapel(Var Linhas: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_VerificaIndiceAliquotasIss(Flag: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ValorFormaPagamento(FormaPagamento: String; Valor: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_ValorTotalizadorNaoFiscal(Totalizador: String; Valor: String): Integer; StdCall; External 'BEMAFI32.DLL';

  // Funções de Autenticação e Gaveta de Dinheiro ////////////////////////////////

  function Bematech_FI_Autenticacao:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_Autenticacao';
  function Bematech_FI_ProgramaCaracterAutenticacao(Parametros: String): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_AcionaGaveta:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_AcionaGaveta';
  function Bematech_FI_VerificaEstadoGaveta(Var EstadoGaveta: Integer): Integer; StdCall; External 'BEMAFI32.DLL';

  // Outras Funções //////////////////////////////////////////////////////////////

  function Bematech_FI_AbrePortaSerial:Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_RetornoImpressora(Var ACK: Integer; Var ST1: Integer; Var ST2: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_FechaPortaSerial:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_FechaPortaSerial';
  function Bematech_FI_MapaResumo:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_MapaResumo';
  function Bematech_FI_AberturaDoDia( ValorCompra: string; FormaPagamento: string ): Integer; StdCall; External 'BEMAFI32.DLL';
  function Bematech_FI_FechamentoDoDia:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_FechamentoDoDia';
  function Bematech_FI_ImprimeConfiguracoesImpressora:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_ImprimeConfiguracoesImpressora';
  function Bematech_FI_ImprimeDepartamentos:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_ImprimeDepartamentos';
  function Bematech_FI_RelatorioTipo60Analitico:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_RelatorioTipo60Analitico';
  function Bematech_FI_RelatorioTipo60Mestre:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_RelatorioTipo60Mestre';
  function Bematech_FI_VerificaImpressoraLigada:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_VerificaImpressoraLigada';
  function Bematech_FI_ImprimeCheque( Banco: String; Valor: String; Favorecido: String; Cidade: String; Data: String; Mensagem: String ): Integer; StdCall; External 'BEMAFI32.DLL';
  //
  Function _ecf08_TestaLigadaePapel(pP1:Boolean):Boolean;
  function _ecf08_CodeErro(Pp1: integer):integer;
  function _ecf08_Inicializa(Pp1: String):Boolean;
  function _ecf08_FechaCupom(Pp1: Boolean):Boolean;
  function _ecf08_Pagamento(Pp1: Boolean):Boolean;
  function _ecf08_CancelaUltimoItem(Pp1: Boolean):Boolean;
  function _ecf08_SubTotal(Pp1: Boolean):Real;
  function _ecf08_AbreGaveta(Pp1: Boolean):Boolean;
  function _ecf08_Sangria(Pp1: Real):Boolean;
  function _ecf08_Suprimento(Pp1: Real):Boolean;
  function _ecf08_NovaAliquota(Pp1: String):Boolean;
  function _ecf08_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
  function _ecf08_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
  function _ecf08_CancelaUltimoCupom(Pp1: Boolean):Boolean;
  function _ecf08_AbreNovoCupom(Pp1: Boolean):Boolean;
  function _ecf08_NumeroDoCupom(Pp1: Boolean):String;
  function _ecf08_CancelaItemN(pP1, pP2: String):Boolean;
  function _ecf08_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
  function _ecf08_ReducaoZ(pP1: Boolean):Boolean;
  function _ecf08_LeituraX(pP1: Boolean):Boolean;
  function _ecf08_RetornaVerao(pP1: Boolean):Boolean;
  function _ecf08_LigaDesLigaVerao(pP1: Boolean):Boolean;
  function _ecf08_VersodoFirmware(pP1: Boolean): String;
  function _ecf08_NmerodeSrie(pP1: Boolean): String;
  function _ecf08_CGCIE(pP1: Boolean): String;
  function _ecf08_Cancelamentos(pP1: Boolean): String;
  function _ecf08_Descontos(pP1: Boolean): String;
  function _ecf08_ContadorSeqencial(pP1: Boolean): String;
  function _ecf08_Nmdeoperaesnofiscais(pP1: Boolean): String;
  function _ecf08_NmdeCuponscancelados(pP1: Boolean): String;
  function _ecf08_NmdeRedues(pP1: Boolean): String;
  function _ecf08_Nmdeintervenestcnicas(pP1: Boolean): String;
  function _ecf08_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
  function _ecf08_Clichdoproprietrio(pP1: Boolean): String;
  function _ecf08_NmdoCaixa(pP1: Boolean): String;
  function _ecf08_Nmdaloja(pP1: Boolean): String;
  function _ecf08_Moeda(pP1: Boolean): String;
  function _ecf08_Dataehoradaimpressora(pP1: Boolean): String;
  function _ecf08_Datadaultimareduo(pP1: Boolean): String;
  function _ecf08_Datadomovimento(pP1: Boolean): String;
  function _ecf08_Tipodaimpressora(pP1: Boolean): String;
  function _ecf08_StatusGaveta(Pp1: Boolean):String;
  function _ecf08_RetornaAliquotas(pP1: Boolean): String;
  function _ecf08_Vincula(pP1: String): Boolean;
  function _ecf08_FlagsDeISS(pP1: Boolean): String;
  function _ecf08_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
  function _ecf08_MudaMoeda(pP1: String): Boolean;
  function _ecf08_MostraDisplay(pP1: String): Boolean;
  function _ecf08_leituraMemoriaFiscalEmDisco(pP1,pP2,pP3: String): Boolean;
  function _ecf08_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean; //iP2 = Número do Cupom vinculado
  function _ecf08_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
  function _ecf08_FechaCupom2(sP1: Boolean): Boolean;
  function _ecf08_ImprimeCheque(rP1: Real; sP2: String): Boolean;
  function _ecf08_GrandeTotal(sP1: Boolean): String;
  function _ecf08_TotalizadoresDasAliquotas(sP1: Boolean): String;
  function _ecf08_CupomAberto(sP1: Boolean): boolean;
  function _ecf08_FaltaPagamento(sP1: Boolean): boolean;
//  function _ecf08_VerificaFormasPagamento(bP1:Boolean): Boolean;

implementation

Function _ecf08_TestaLigadaePapel(pP1:Boolean):Boolean;
var
   iACK,iST1,iST2:integer;
begin
  iACK := 0; iST1 := 0; iST2 := 0;
  Result:=(Bematech_FI_VerificaImpressoraLigada()=1);
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
end;

Function _ecf08_CodeErro(pP1: integer):Integer; //
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
//  Form1.Image3.Visible := False;
  //

  //numeros negativos
  vErro[00] :=  'Erro de Comunicação !';//, 'Erro',
  vErro[01] :=  'Erro de Execução na Função. Verifique!';//, 'Erro',
  vErro[02] :=  'Parâmetro Inválido !';//, 'Erro',
  vErro[03] :=  'Alíquota não programada !';//, 'Atenção',
  vErro[04] :=  'Arquivo BemaFI32.INI não encontrado. Verifique!';//, 'Atenção',
  vErro[05] :=  'Erro ao Abrir a Porta de Comunicação';//, 'Erro',
  vErro[06] :=  'Impressora Desligada ou Desconectada';//, 'Atenção',
  vErro[07] :=  'Banco Não Cadastrado no Arquivo BemaFI32.ini';//, 'Atenção',
  vErro[08] :=  'Erro ao Criar ou Gravar no Arquivo Retorno.txt ou Status.txt';//, 'Erro',
  vErro[18] :=  'Não foi possível abrir arquivo INTPOS.001 !';//, 'Atenção',
  vErro[19] :=  'Parâmetro diferentes !';//, 'Atenção',
  vErro[20] :=  'Transação cancelada pelo Operador !';//, 'Atenção',
  vErro[21] :=  'A Transação não foi aprovada !';//, 'Atenção',
  vErro[22] :=  'Não foi possível terminal a Impressão !';//, 'Atenção',
  vErro[23] :=  'Não foi possível terminal a Operação !';//, 'Atenção',
  vErro[24] :=  'Forma de pagamento não programada.';//, 'Atenção',
  vErro[25] :=  'Totalizador não fiscal não programado.';//, 'Atenção',
  vErro[26] :=  'Transação já Efetuada !';//, 'Atenção',
  vErro[28] :=  'Não há Informações para serem Impressas !';// 'Atenção',

  vErro[99] := 'Falha de comunicação '+chr(10)+chr(10)+
               'Sugestão: verifique as conexões,'+chr(10)+
               'ligue e desligue a impressora. '+chr(10)+chr(10)+
               'O Sistema será Finalizado.';

  if pP1 <> 1 then
     Application.MessageBox(Pchar('ERRO n.'+IntToStr(pP1)+'-'+vErro[abs(pP1)]),'Atenção',mb_Ok + mb_DefButton1);
  //Result:=pP1;
  if (pP1=00) or (pP1=99) then
    Halt(1);

  //analisa o retorno da impressora
//  if pP1 <=0 then
//  begin
    iACK := 0; iST1 := 0; iST2 := 0;
    Bematech_FI_RetornoImpressora(iACK, iST1, iST2);
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
function _ecf08_VerificaFormaPgto(Forma:String):String; 
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

function _ecf08_VerificaDescricaoFormaPgto(Forma:String):String; 
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

// ----------------------------//
// Detecta qual a porta que    //
// a impressora está conectada //
// --------------------------- //
function _ecf08_Inicializa(Pp1: String):Boolean;
var
  iRetorno,iFlagFiscal : Integer;
  Mais1ini : TiniFile;
  sPrazo, sDinheiro, sCheque, sCartao, sExtra1, sExtra2, sExtra3, sExtra4,
  sExtra5, sExtra6, sExtra7, sExtra8, sTempo : String;

  cFormaPgto , cAcresDesc, cTipoAcresDesc, cValorAcresDesc, cValorPago, cMsgPromocional :string;

  aWinDir: array[0..200] of Char;
begin
  //
  Result:=True;
  if Copy(pP1,1,3) <> 'COM' then pP1 := 'COM1';

  //1: OK.
  //-4: O arquivo de inicialização BEMAFI32.INI não foi encontrado no diretório de sistema do Windows.
  //-5: Erro ao abrir a porta de comunicação.
  Bematech_FI_AbrePortaSerial();
  //- A função lê o nome da porta a ser aberta no arquivo BemaFi32.ini.
  //Se o parâmetro “porta” estiver configurado com a palavra “Default” a função
  //       localiza onde a impressora está conectada e configura o arquivo INI.

{  GetWindowsDirectory(aWinDir,200);
  if pos('WINNT',strPas(aWinDir)) > 0 then
     Mais1ini  := TIniFile.Create(StrPas(aWinDir)+'\System32\BemaFI32.INI')
  else
     Mais1ini  := TIniFile.Create(StrPas(aWinDir)+'\System\BemaFI32.INI');
}
  GetSystemDirectory(aWinDir,200);
  Mais1ini  := TIniFile.Create(StrPas(aWinDir)+'\BemaFI32.INI');

  Form1.sTipoImpressora:=Mais1Ini.ReadString('Sistema','ModeloImp','');
  Mais1Ini.WriteString('Sistema','Path',Form1.sAtual+'\');
  if Mais1Ini.ReadString('MFD','Impressora','0')='1' then
  begin
     Form1.sTipoImpressora:=Form1.sTipoImpressora+'_MFD';
  end;
  //testa a impressora
  iRetorno:=Bematech_FI_FlagsFiscais(iFlagFiscal);
//  showmessage(inttostr(iretorno)+chr(10)+
//              inttostr(iFlagFiscal)+chr(10));

  if iRetorno = 1 then
   begin
     Result:=True;
   end
  else
    if (iRetorno = -5) or (iRetorno = 0) then
     begin
       //deu erro, configura como Default para a função buscar
       Mais1Ini.WriteString('Sistema','Porta','Default');
       //tenta de novo
       iRetorno := Bematech_FI_AbrePortaSerial();
       if iRetorno = 1 then
          Result:=True
       else
        begin
          Showmessage('Problema de comunicação com a impressora');
          Result:=False;
        end;
     end
    else
     if iRetorno = -4 then
     begin
       Showmessage(' O sistema não encontrou o arquivo BEMAFI32.INI.'+chr(10)+
                   ' É necessário reinstalar o sistema.');
       Result:=False;
     end;

  iRetorno := Bematech_FI_VerificaImpressoraLigada();
  if iRetorno = -6 then
  begin
    //Application.MessageBox('A Impressora se encontra DESLIGADA.', 'Atenção', MB_IconInformation + MB_OK);
    Result:=False;
  end;
  //
  if Form22.Label6.Caption = 'Detectando porta de comunicação...' then
  begin

    if Result then
    begin
      pP1 := Mais1Ini.ReadString('Sistema','Porta','COM1');
      Form1.sPorta  := pP1;
      //verifica se tem leitura X aberta
      Bematech_FI_FechaRelatorioGerencial();
      if Bematech_FI_FlagsFiscais( iFlagFiscal )=1 then
      begin
        //showmessage(inttostr(iFlagFiscal ));
        if iFlagFiscal = 35 then
        begin
          if Form1.sTipoImpressora='YANCO' then
          begin
            //foi criado para fechar o cupom que está aberto depois de uma queda de energia
            // após ter sido efetuadas as formas de pagamento.
            cFormaPgto      := 'Dinheiro';
            cAcresDesc      := 'A';
            cTipoAcresDesc  := '$';
            cValorAcresDesc := '0000';
            cValorPago      := '1,00';
            cMsgPromocional := 'Obrigado, volte sempre !!!';

            _ecf08_CodeErro(Bematech_FI_FechaCupom( pchar( cFormaPgto ),
                                                pchar( cAcresDesc ),
                                                pchar( cTipoAcresDesc ),
                                                pchar( cValorAcresDesc ),
                                                pchar( cValorPago ),
                                                pchar( cMsgPromocional ) ));
          end;
        end;
      end;

      if (Copy(Form1.sTipoImpressora,1,8)='BEMATECH') then
      begin
        Mais1ini  := TIniFile.Create('frente.ini');
        if Mais1Ini.ReadString('Impressora Fiscal','Linhas Entre Cupons','')<> '' then
        begin
          Bematech_FI_LinhasEntreCupons( Mais1Ini.ReadInteger('Impressora Fiscal','Linhas Entre Cupons',0) );
        end;
      end;

      if (Form1.sTipoImpressora='YANCO') then
      begin
        // lê o arquivo frente.ini
        Mais1ini  := TIniFile.Create('frente.ini');
        sDinheiro := Mais1Ini.ReadString('Impressora Fiscal','Dinheiro','XX');
        sCheque   := Mais1Ini.ReadString('Impressora Fiscal','Cheque','XX');
        sCartao   := Mais1Ini.ReadString('Impressora Fiscal','Cartao','XX');
        sPrazo    := Mais1Ini.ReadString('Impressora Fiscal','Prazo','XX');
        sExtra1   := Mais1Ini.ReadString('Impressora Fiscal','Ordem forma extra 1','');
        sExtra2   := Mais1Ini.ReadString('Impressora Fiscal','Ordem forma extra 2','');
        sExtra3   := Mais1Ini.ReadString('Impressora Fiscal','Ordem forma extra 3','');
        sExtra4   := Mais1Ini.ReadString('Impressora Fiscal','Ordem forma extra 4','');
        sExtra5   := Mais1Ini.ReadString('Impressora Fiscal','Ordem forma extra 5','');
        sExtra6   := Mais1Ini.ReadString('Impressora Fiscal','Ordem forma extra 6','');
        sExtra7   := Mais1Ini.ReadString('Impressora Fiscal','Ordem forma extra 7','');
        sExtra8   := Mais1Ini.ReadString('Impressora Fiscal','Ordem forma extra 8','');
        //
        Form1.sFormas:=Replicate(' ',180); //zera a descrição das formas
        //dinheiro
        if (isNumericString(sDinheiro)) and (allTrim(sDinheiro)<> '') then
         begin
           sTempo:='';
           sTempo:=_ecf08_VerificaDescricaoFormaPgto(sDinheiro);
           if sTempo <> '' then
            begin
              //Mais1Ini.WriteString('Impressora Fiscal','Dinheiro',AllTrim(sTempo));
              sTempo:=Copy(AllTrim(sTempo)+replicate(' ',15),1,15);
              delete(Form1.sFormas,((StrToInt(sDinheiro)-1)*15)+1,15);
              insert(sTempo,Form1.sFormas,((StrToInt(sDinheiro)-1)*15)+1);
              sDinheiro:=AllTrim(sTempo);
            end
           else
             sDinheiro:='XX';
         end
        else //se for Dinheiro escrito em não número ou em branco
          begin
            sTempo:='';
            if (allTrim(sDinheiro)='XX') or (allTrim(sDinheiro)='') then // em branco tenta buscar
              sTempo:=_ecf08_VerificaFormaPgto('DINHEIRO')
            else
              sTempo:=_ecf08_VerificaFormaPgto(sDinheiro);//03
            if (sTempo = '') or (sTempo = 'XX') then
              begin
                ShowMessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                            'Dinheiro, chame um técnico autorizado.');
                Result:=True;//False;
                //Halt(1);
              end
             else
              begin
                //grava o número no ini
                Mais1Ini.WriteString('Impressora Fiscal','Dinheiro',AllTrim(sTempo));
                sDinheiro:=sTempo;//numérico
                sTempo:=_ecf08_VerificaDescricaoFormaPgto(sTempo);
                //grava na variável sFormas a descrição de sDinheiro
                delete(Form1.sFormas,((StrToInt(sDinheiro)-1)*15)+1,15);
                insert(sTempo,Form1.sFormas,((StrToInt(sDinheiro)-1)*15)+1);
                sDinheiro:=AllTrim(sTempo);
              end;
          end;

        //Cheque
        if (isNumericString(sCheque)) and (allTrim(sCheque)<> '') then
         begin
           sTempo:='';
           sTempo:=_ecf08_VerificaDescricaoFormaPgto(sCheque);//
           if sTempo <> '' then
            begin
              //Mais1Ini.WriteString('Impressora Fiscal','Cheque',AllTrim(sTempo));
              sTempo:=Copy(AllTrim(sTempo)+replicate(' ',15),1,15);
              delete(Form1.sFormas,((StrToInt(sCheque)-1)*15)+1,15);
              insert(sTempo,Form1.sFormas,((StrToInt(sCheque)-1)*15)+1);
              sCheque:=AllTrim(sTempo);
            end
           else
             sCheque:='XX';
         end
        else //se for Cheque escrito em não número
          begin
            sTempo:='';
            if (allTrim(sCheque)='XX') or (allTrim(sCheque)='') then // em branco tenta buscar
               sTempo:=_ecf08_VerificaFormaPgto('CHEQUE')
            else
               sTempo:=_ecf08_VerificaFormaPgto(sCheque);//03
            if (sTempo = '') or (sTempo = 'XX') then
              begin
                ShowMessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                            'Cheque, chame um técnico autorizado.');
                Result:=True;//False;
                //Halt(1);
              end
             else
              begin
                //grava o número no ini
                Mais1Ini.WriteString('Impressora Fiscal','Cheque',AllTrim(sTempo));
                sCheque:=sTempo;//numérico
                sTempo:=_ecf08_VerificaDescricaoFormaPgto(sTempo);
                //grava na variável sFormas a descrição de sCheque
                delete(Form1.sFormas,((StrToInt(sCheque)-1)*15)+1,15);
                insert(sTempo,Form1.sFormas,((StrToInt(sCheque)-1)*15)+1);
                sCheque:=AllTrim(sTempo);
              end;
          end;

        //Cartao
        if (isNumericString(sCartao)) and (allTrim(sCartao)<> '')then
         begin
           sTempo:='';
           sTempo:=_ecf08_VerificaDescricaoFormaPgto(sCartao);
           if sTempo <> '' then
            begin
     //         Mais1Ini.WriteString('Impressora Fiscal','Cartao',AllTrim(sTempo));
              sTempo:=Copy(AllTrim(sTempo)+replicate(' ',15),1,15);
              delete(Form1.sFormas,((StrToInt(sCartao)-1)*15)+1,15);
              insert(sTempo,Form1.sFormas,((StrToInt(sCartao)-1)*15)+1);
              sCartao:=AllTrim(sTempo);
            end
           else
             sCartao:='XX';
         end
        else //se for CARTAO escrito em não número
          begin
            sTempo:='';
            if (allTrim(sCartao)='XX') or (allTrim(sCartao)='') then // em branco tenta buscar
               sTempo:=_ecf08_VerificaFormaPgto('CARTAO')
            else
              sTempo:=_ecf08_VerificaFormaPgto(sCartao);//03
            if (sTempo = '') or (sTempo = 'XX') then
              begin
                ShowMessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                            'CARTAO, chame um técnico autorizado.');
                Result:=True;//False;
                //Halt(1);
              end
             else
              begin
                //grava o número no ini
                Mais1Ini.WriteString('Impressora Fiscal','Cartao',AllTrim(sTempo));
                sCartao:=sTempo;//numérico
                sTempo:=_ecf08_VerificaDescricaoFormaPgto(sTempo);
                //grava na variável sFormas a descrição de sCartao
                delete(Form1.sFormas,((StrToInt(sCartao)-1)*15)+1,15);
                insert(sTempo,Form1.sFormas,((StrToInt(sCartao)-1)*15)+1);
                sCartao:=AllTrim(sTempo);
              end;
          end;
        //Prazo
        if (isNumericString(sPrazo)) and (allTrim(sPrazo)<> '')then
         begin
           sTempo:='';
           sTempo:=_ecf08_VerificaDescricaoFormaPgto(sPrazo);
           if sTempo <> '' then
            begin
     //         Mais1Ini.WriteString('Impressora Fiscal','Prazo',AllTrim(sTempo));
              sTempo:=Copy(AllTrim(sTempo)+replicate(' ',15),1,15);
              delete(Form1.sFormas,((StrToInt(sPrazo)-1)*15)+1,15);
              insert(sTempo,Form1.sFormas,((StrToInt(sPrazo)-1)*15)+1);
              sPrazo:=AllTrim(sTempo);
            end
           else
             sPrazo:='XX';
         end
        else //se for Prazo escrito e não número
          begin
            sTempo:='';
            if (allTrim(sPrazo)='XX') or (allTrim(sPrazo)='') then // em branco tenta buscar
               sTempo:=_ecf08_VerificaFormaPgto('PRAZO')
            else
               sTempo:=_ecf08_VerificaFormaPgto(sPrazo);//03
            if (sTempo = '') or (sTempo = 'XX') then
              begin
                ShowMessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                            'Prazo, chame um técnico autorizado.');
                Result:=True;//False;
                //Halt(1);
              end
             else
              begin
                //grava o número no ini
                Mais1Ini.WriteString('Impressora Fiscal','Prazo',AllTrim(sTempo));
                sPrazo:=sTempo;//numérico
                sTempo:=_ecf08_VerificaDescricaoFormaPgto(sTempo);
                //grava na variável sFormas a descrição de sCheque
                delete(Form1.sFormas,((StrToInt(sPrazo)-1)*15)+1,15);
                insert(sTempo,Form1.sFormas,((StrToInt(sPrazo)-1)*15)+1);
                sPrazo:=AllTrim(sTempo);
              end;
          end;
        //vefifica as formas de pagamento
        if sDinheiro='XX' then
        begin
          sDinheiro:=_ecf08_VerificaFormaPgto('DINHEIRO');
          if sDinheiro = 'XX' then
            begin
               ShowMessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           'DINHEIRO, chame um técnico autorizado.');
               Result:=True;//False;
            end
          else
           begin
             Mais1Ini.WriteString('Impressora Fiscal','Dinheiro',AllTrim(sDinheiro));
           end;
        end;
         //
        if sCheque='XX' then
        begin
           sCheque := _ecf08_VerificaFormaPgto('CHEQUE');//retorna o número
           if sCheque = 'XX' then
            begin
              ShowMessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                          'CHEQUE, chame um técnico autorizado.');
              Result:=True;//False;
            end
           else
            begin
              Mais1Ini.WriteString('Impressora Fiscal','Cheque',AllTrim(sCheque));
            end;
        end;
        //
        if sCartao='XX' then
        begin
           sCartao := _ecf08_VerificaFormaPgto('CARTAO');
           if sCartao = 'XX' then
            begin
               ShowMessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           'CARTAO, chame um técnico autorizado.');
               Result:=True;//False;
               //Halt(1);
            end
           else
            begin
              Mais1Ini.WriteString('Impressora Fiscal','Cartao',AllTrim(sCartao));
            end;
        end;
        //
        if sPrazo='XX' then
        begin
           sPrazo := _ecf08_VerificaFormaPgto('PRAZO');
           if sPrazo = 'XX' then
            begin
              ShowMessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                          'PRAZO, chame um técnico autorizado.');
              Result:=True;//False;
            end
           else
            begin
              Mais1Ini.WriteString('Impressora Fiscal','Prazo',AllTrim(sPrazo));
            end;
        end;

        //formas extras---------------------------
        if (isNumericString(sExtra1)) and (AllTrim(sExtra1)<>'') then
        begin
          sTempo:='';
          sTempo:=_ecf08_VerificaDescricaoFormaPgto(sExtra1);
          if AllTrim(sTempo) <> '' then
           begin
    //         Mais1Ini.WriteString('Impressora Fiscal','Ordem forma extra 1',AllTrim(sTempo));
             sTempo:=Copy(AllTrim(sTempo)+replicate(' ',15),1,15);
             delete(Form1.sFormas,((StrToInt(sExtra1)-1)*15)+1,15);
             insert(sTempo,Form1.sFormas,((StrToInt(sExtra1)-1)*15)+1);
             sExtra1:=AllTrim(sTempo);
           end
          else
           begin
             ShowMessage('O sistema não encontrou uma forma de pagamento configurada no ECF:'+chr(10)+
                         Mais1Ini.ReadString('Impressora Fiscal','Forma extra 1','')+'. Chame um técnico autorizado.'+chr(10)+
                         'Esta forma de pagamento vai ser desconfigurada no sistema.');
             Mais1Ini.WriteString('Impressora Fiscal','Forma extra 1','');
             Mais1Ini.WriteString('Impressora Fiscal','Ordem forma extra 1','');
             Result:=True;//False;
           end;
        end;
        //
        if (isNumericString(sExtra2)) and (AllTrim(sExtra2)<>'')then
        begin
          sTempo:='';
          sTempo:=_ecf08_VerificaDescricaoFormaPgto(sExtra2);
          if AllTrim(sTempo) <> '' then
           begin
    //         Mais1Ini.WriteString('Impressora Fiscal','Ordem forma extra 2',AllTrim(sTempo));
             sTempo:=Copy(AllTrim(sTempo)+replicate(' ',15),1,15);
             delete(Form1.sFormas,((StrToInt(sExtra2)-1)*15)+1,15);
             insert(sTempo,Form1.sFormas,((StrToInt(sExtra2)-1)*15)+1);
             sExtra2:=AllTrim(sTempo);
           end
          else
           begin
             ShowMessage('O sistema não encontrou uma forma de pagamento configurada no ECF:'+chr(10)+
                         Mais1Ini.ReadString('Impressora Fiscal','Forma extra 2','')+'. Chame um técnico autorizado.'+chr(10)+
                         'Esta forma de pagamento vai ser desconfigurada no sistema.');
             Mais1Ini.WriteString('Impressora Fiscal','Forma extra 2','');
             Mais1Ini.WriteString('Impressora Fiscal','Ordem forma extra 2','');
             Result:=True;//False;
           end;
        end;
        //
        if (isNumericString(sExtra3)) and (AllTrim(sExtra3)<>'') then
        begin
          sTempo:='';
          sTempo:=_ecf08_VerificaDescricaoFormaPgto(sExtra3);
          if AllTrim(sTempo) <> '' then
           begin
    //         Mais1Ini.WriteString('Impressora Fiscal','Ordem forma extra 3',AllTrim(sTempo));
             sTempo:=Copy(AllTrim(sTempo)+replicate(' ',15),1,15);
             delete(Form1.sFormas,((StrToInt(sExtra3)-1)*15)+1,15);
             insert(sTempo,Form1.sFormas,((StrToInt(sExtra3)-1)*15)+1);
             sExtra3:=AllTrim(sTempo);
           end
          else
           begin
             ShowMessage('O sistema não encontrou uma forma de pagamento configurada no ECF:'+chr(10)+
                         Mais1Ini.ReadString('Impressora Fiscal','Forma extra 3','')+'. Chame um técnico autorizado.'+chr(10)+
                         'Esta forma de pagamento vai ser desconfigurada no sistema.');
             Mais1Ini.WriteString('Impressora Fiscal','Forma extra 3','');
             Mais1Ini.WriteString('Impressora Fiscal','Ordem forma extra 3','');
             Result:=True;//False;
           end;
        end;
        //
        if (isNumericString(sExtra4)) and (AllTrim(sExtra4)<>'') then
        begin
          sTempo:='';
          sTempo:=_ecf08_VerificaDescricaoFormaPgto(sExtra4);
          if AllTrim(sTempo) <> '' then
           begin
    //         Mais1Ini.WriteString('Impressora Fiscal','Ordem forma extra 4',AllTrim(sTempo));
             sTempo:=Copy(AllTrim(sTempo)+replicate(' ',15),1,15);
             delete(Form1.sFormas,((StrToInt(sExtra4)-1)*15)+1,15);
             insert(sTempo,Form1.sFormas,((StrToInt(sExtra4)-1)*15)+1);
             sExtra4:=AllTrim(sTempo);
           end
          else
           begin
             ShowMessage('O sistema não encontrou uma forma de pagamento configurada no ECF:'+chr(10)+
                         Mais1Ini.ReadString('Impressora Fiscal','Forma extra 4','')+'. Chame um técnico autorizado.'+chr(10)+
                         'Esta forma de pagamento vai ser desconfigurada no sistema.');
             Mais1Ini.WriteString('Impressora Fiscal','Forma extra 4','');
             Mais1Ini.WriteString('Impressora Fiscal','Ordem forma extra 4','');
             Result:=True;//False;
           end;
        end;
        //
        if (isNumericString(sExtra5)) and (AllTrim(sExtra5)<>'') then
        begin
          sTempo:='';
          sTempo:=_ecf08_VerificaDescricaoFormaPgto(sExtra5);
          if AllTrim(sTempo) <> '' then
           begin
    //         Mais1Ini.WriteString('Impressora Fiscal','Ordem forma extra 5',AllTrim(sTempo));
             sTempo:=Copy(AllTrim(sTempo)+replicate(' ',15),1,15);
             delete(Form1.sFormas,((StrToInt(sExtra5)-1)*15)+1,15);
             insert(sTempo,Form1.sFormas,((StrToInt(sExtra5)-1)*15)+1);
             sExtra5:=AllTrim(sTempo);
           end
          else
           begin
             ShowMessage('O sistema não encontrou uma forma de pagamento configurada no ECF:'+chr(10)+
                         Mais1Ini.ReadString('Impressora Fiscal','Forma extra 5','')+'. Chame um técnico autorizado.'+chr(10)+
                         'Esta forma de pagamento vai ser desconfigurada no sistema.');
             Mais1Ini.WriteString('Impressora Fiscal','Forma extra 5','');
             Mais1Ini.WriteString('Impressora Fiscal','Ordem forma extra 5','');
             Result:=True;//False;
           end;
        end;
        //
        if (isNumericString(sExtra6)) and (AllTrim(sExtra6)<>'') then
        begin
          sTempo:='';
          sTempo:=_ecf08_VerificaDescricaoFormaPgto(sExtra6);
          if AllTrim(sTempo) <> '' then
           begin
    //         Mais1Ini.WriteString('Impressora Fiscal','Ordem forma extra 6',AllTrim(sTempo));
             sTempo:=Copy(AllTrim(sTempo)+replicate(' ',15),1,15);
             delete(Form1.sFormas,((StrToInt(sExtra6)-1)*15)+1,15);
             insert(sTempo,Form1.sFormas,((StrToInt(sExtra6)-1)*15)+1);
             sExtra6:=AllTrim(sTempo);
           end
          else
           begin
             ShowMessage('O sistema não encontrou uma forma de pagamento configurada no ECF:'+chr(10)+
                         Mais1Ini.ReadString('Impressora Fiscal','Forma extra 6','')+'. Chame um técnico autorizado.'+chr(10)+
                         'Esta forma de pagamento vai ser desconfigurada no sistema.');
             Mais1Ini.WriteString('Impressora Fiscal','Forma extra 6','');
             Mais1Ini.WriteString('Impressora Fiscal','Ordem forma extra 6','');
             Result:=True;//False;
           end;
        end;
        //
        if (isNumericString(sExtra7)) and (AllTrim(sExtra7)<>'') then
        begin
          sTempo:='';
          sTempo:=_ecf08_VerificaDescricaoFormaPgto(sExtra7);
          if AllTrim(sTempo) <> '' then
           begin
    //         Mais1Ini.WriteString('Impressora Fiscal','Ordem forma extra 7',AllTrim(sTempo));
             sTempo:=Copy(AllTrim(sTempo)+replicate(' ',15),1,15);
             delete(Form1.sFormas,((StrToInt(sExtra7)-1)*15)+1,15);
             insert(sTempo,Form1.sFormas,((StrToInt(sExtra7)-1)*15)+1);
             sExtra7:=AllTrim(sTempo);
           end
          else
           begin
             ShowMessage('O sistema não encontrou uma forma de pagamento configurada no ECF:'+chr(10)+
                         Mais1Ini.ReadString('Impressora Fiscal','Forma extra 7','')+'. Chame um técnico autorizado.'+chr(10)+
                         'Esta forma de pagamento vai ser desconfigurada no sistema.');
             Mais1Ini.WriteString('Impressora Fiscal','Forma extra 7','');
             Mais1Ini.WriteString('Impressora Fiscal','Ordem forma extra 7','');
             Result:=True;//False;
           end;
        end;
        //
        if (isNumericString(sExtra8)) and (AllTrim(sExtra8)<>'') then
        begin
          sTempo:='';
          sTempo:=_ecf08_VerificaDescricaoFormaPgto(sExtra8);
          if AllTrim(sTempo) <> '' then
           begin
    //         Mais1Ini.WriteString('Impressora Fiscal','Ordem forma extra 8',AllTrim(sTempo));
             sTempo:=Copy(AllTrim(sTempo)+replicate(' ',15),1,15);
             delete(Form1.sFormas,((StrToInt(sExtra8)-1)*15)+1,15);
             insert(sTempo,Form1.sFormas,((StrToInt(sExtra8)-1)*15)+1);
             sExtra8:=AllTrim(sTempo);
           end
          else
           begin
             ShowMessage('O sistema não encontrou uma forma de pagamento configurada no ECF:'+chr(10)+
                         Mais1Ini.ReadString('Impressora Fiscal','Forma extra 8','')+'. Chame um técnico autorizado.'+chr(10)+
                         'Esta forma de pagamento vai ser desconfigurada no sistema.');
             Mais1Ini.WriteString('Impressora Fiscal','Forma extra 8','');
             Mais1Ini.WriteString('Impressora Fiscal','Ordem forma extra 8','');
             Result:=True;//False;
           end;
        end;
        //---------------fim das formas---------------
        //showmessage(Form1.sformas);
      end; //              if (Form1.sTipoImpressora='YANCO') then
    end;
  end;
  //
end;

// ------------------------------ //
Function _ecf08_FechaCupom(Pp1: Boolean):Boolean; //
var
  sDescAcres, sTipoDescAcres, sValorDescAcres, sTempo:string;
  iFlagFiscal:integer;
begin
   sTempo:='';
   Result:=True;
   if Form1.fTotal = 0 then // cupom em branco cancela
   begin
//      Result:=(Copy(_ecf08_TXRX('05'),1,1)='.');//cancela cupom atual
//      if Result then
      if Copy(Form1.sTipoImpressora,1,8)='BEMATECH' then
      begin
         Result:= (_ecf08_CodeErro(Bematech_FI_CancelaCupom())=1);
      end;
   end
   else
    begin
      sTipoDescAcres:='$';
      // verifica se tem desconto/acréscimo
      if JStrToFloat(Format('%13.2f',[Form1.fTotal])) > JStrToFloat(Format('%13.2f',[Form1.ibDataSet25RECEBER.AsFloat])) then //Desconto
       begin
         //desconto
         sDescAcres:='D';
         sValorDescAcres:=Copy(Right('00000000000000'+AllTrim(Format('%15f',[(Form1.fTotal-Form1.ibDataSet25RECEBER.AsFloat)*100])),17),1,14);
         sValorDescAcres:=Right(sValorDescAcres,12);//esta linha foi colocada porque com 14 digitos dava erro
       end
      else
       if JStrToFloat(Format('%13.2f',[Form1.fTotal])) < JStrToFloat(Format('%13.2f',[Form1.ibDataSet25RECEBER.AsFloat])) then //Acrescimo
       begin
         //acrescimo
         sDescAcres:='A';
         sValorDescAcres:=Copy(Right('00000000000000'+AllTrim(Format('%15f',[(Form1.ibDataSet25RECEBER.AsFloat-Form1.fTotal)*100])),17),1,14);
         sValorDescAcres:=Right(sValorDescAcres,12);//esta linha foi colocada porque com 14 digitos dava erro
       end
      else
       begin
         sDescAcres:='A';
         sTipoDescAcres:='%';
         sValorDescAcres:='0';
       end;

     if Copy(Form1.sTipoImpressora,1,8)='BEMATECH' then
      begin
         iFlagFiscal:=0;
         Bematech_FI_FlagsFiscais(iFlagFiscal);
         if Copy(Right(Replicate('0',8)+IntToBin(iFlagFiscal),8),7,1)='0' then
           Result:=(_ecf08_CodeErro(Bematech_FI_IniciaFechamentoCupom( pChar(sDescAcres) ,  pchar(sTipoDescAcres) ,  pchar(sValorDescAcres) )) = 1);
      end
     else
       Result:=(_ecf08_CodeErro(Bematech_FI_IniciaFechamentoCupom( pChar(sDescAcres) ,  pchar(sTipoDescAcres) ,  pchar(sValorDescAcres) )) = 1);
    end;
end;

function _ecf08_Pagamento(Pp1: Boolean):Boolean;
var
  sTempo,sTempo1 : String;
  fSubTotal:double;
  Mais1ini : TiniFile;
  sPrazo, sDinheiro, sCheque, sCartao, sExtra1, sExtra2, sExtra3, sExtra4,
  sExtra5, sExtra6, sExtra7, sExtra8 : String;
  iColunasPorLinha,k,i:integer;
begin
  Result:=False;
  if Form1.sTipoImpressora='YANCO' then
    iColunasPorLinha:=42
  else
    iColunasPorLinha:=40;
  //
  Mais1ini  := TIniFile.Create('frente.ini');

  if Copy(Form1.sTipoImpressora,1,8)='BEMATECH' then
   begin //---------BEMATECH---------
     sDinheiro:='Dinheiro';
     sCheque:='Cheque';
     sCartao:='Cartao';
     sPrazo:='Prazo';
     sExtra1   := Mais1Ini.ReadString('Impressora Fiscal','Forma extra 1','');
     sExtra2   := Mais1Ini.ReadString('Impressora Fiscal','Forma extra 2','');
     sExtra3   := Mais1Ini.ReadString('Impressora Fiscal','Forma extra 3','');
     sExtra4   := Mais1Ini.ReadString('Impressora Fiscal','Forma extra 4','');
     sExtra5   := Mais1Ini.ReadString('Impressora Fiscal','Forma extra 5','');
     sExtra6   := Mais1Ini.ReadString('Impressora Fiscal','Forma extra 6','');
     sExtra7   := Mais1Ini.ReadString('Impressora Fiscal','Forma extra 7','');
     sExtra8   := Mais1Ini.ReadString('Impressora Fiscal','Forma extra 8','');
   end
  else
   begin // ---------YANCO-------------
     //
     //-----Dinheiro-----
     sDinheiro:=Mais1Ini.ReadString('Impressora Fiscal','Dinheiro','');
     if (isNumericString(sDinheiro)) and (sDinheiro<>'') then
      sDinheiro    := AllTrim(Copy(Form1.sFormas,((StrToInt(sDinheiro)-1)*15)+1,15))
     else
       sDinheiro:='';
     //------cheque------
     sCheque:=Mais1Ini.ReadString('Impressora Fiscal','Cheque','');
     if (isNumericString(sCheque)) and (sCheque<>'') then
       sCheque    := AllTrim(Copy(Form1.sFormas,((StrToInt(sCheque)-1)*15)+1,15))
     else
      sCheque:='';
     //----Cartao----
     sCartao:=Mais1Ini.ReadString('Impressora Fiscal','Cartao','');
     if (isNumericString(sCartao)) and (sCartao<>'') then
       sCartao    := AllTrim(Copy(Form1.sFormas,((StrToInt(sCartao)-1)*15)+1,15))
     else
       sCartao:='';
     //----Prazo----
     sPrazo:=Mais1Ini.ReadString('Impressora Fiscal','Prazo','');
     if (isNumericString(sPrazo)) and (sPrazo<>'') then
       sPrazo    := AllTrim(Copy(Form1.sFormas,((StrToInt(sPrazo)-1)*15)+1,15))
     else
       sPrazo:='';
     //---forma extra 1---
     sExtra1   := Mais1Ini.ReadString('Impressora Fiscal','Ordem forma extra 1','');
     if AllTrim(sExtra1) <> '' then try sExtra1    := AllTrim(Copy(Form1.sFormas,((StrToInt(sExtra1)-1)*15)+1,15)); except sExtra1 :=''; end;
     //---forma extra 2---
     sExtra2   := Mais1Ini.ReadString('Impressora Fiscal','Ordem forma extra 2','');
     if AllTrim(sExtra2) <> '' then try sExtra2    := AllTrim(Copy(Form1.sFormas,((StrToInt(sExtra2)-1)*15)+1,15)); except sExtra2 :=''; end;
     //---forma extra 3---
     sExtra3   := Mais1Ini.ReadString('Impressora Fiscal','Ordem forma extra 3','');
     if AllTrim(sExtra3) <> '' then try sExtra3    := AllTrim(Copy(Form1.sFormas,((StrToInt(sExtra3)-1)*15)+1,15)); except sExtra3 :=''; end;
     //---forma extra 4---
     sExtra4   := Mais1Ini.ReadString('Impressora Fiscal','Ordem forma extra 4','');
     if AllTrim(sExtra4) <> '' then try sExtra4    := AllTrim(Copy(Form1.sFormas,((StrToInt(sExtra4)-1)*15)+1,15)); except sExtra4 :=''; end;
     //---forma extra 5---
     sExtra5   := Mais1Ini.ReadString('Impressora Fiscal','Ordem forma extra 5','');
     if AllTrim(sExtra5) <> '' then try sExtra5    := AllTrim(Copy(Form1.sFormas,((StrToInt(sExtra5)-1)*15)+1,15)); except sExtra5 :=''; end;
     //---forma extra 6---
     sExtra6   := Mais1Ini.ReadString('Impressora Fiscal','Ordem forma extra 6','');
     if AllTrim(sExtra6) <> '' then try sExtra6    := AllTrim(Copy(Form1.sFormas,((StrToInt(sExtra6)-1)*15)+1,15)); except sExtra6 :=''; end;
     //---forma extra 7---
     sExtra7   := Mais1Ini.ReadString('Impressora Fiscal','Ordem forma extra 7','');
     if AllTrim(sExtra7) <> '' then try sExtra7    := AllTrim(Copy(Form1.sFormas,((StrToInt(sExtra7)-1)*15)+1,15)); except sExtra7 :=''; end;
     //---forma extra 8 ---
     sExtra8   := Mais1Ini.ReadString('Impressora Fiscal','Ordem forma extra 8','');
     if AllTrim(sExtra8) <> '' then try sExtra8    := AllTrim(Copy(Form1.sFormas,((StrToInt(sExtra8)-1)*15)+1,15)); except sExtra8 :=''; end;
     //-- fim das formas --
   end;
  fSubTotal:=_ecf08_SubTotal(False);//falso para não fazer ch. de erro
  if fSubTotal > 0 then
  begin
    if Form1.ibDataSet25DIFERENCA_.AsFloat = 0 then// à vista
     begin
       //--------------------- //
       // Forma de pagamento   //
       //--------------------- //
       if Form1.ibDataSet25ACUMULADO2.AsFloat > 0 then // dinheiro > 0
       begin
          sTempo:=Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25ACUMULADO2.AsFloat*100])),15),1,12);  //dinheiro
          Result:=(Bematech_FI_EfetuaFormaPagamento( pchar( sDinheiro ), pchar( sTempo ) ) = 1 );
       end;
       if Form1.ibDataSet25ACUMULADO1.AsFloat > 0 then //cheque
       begin
         // se o valor em dinheiro já supriu o total da venda
         if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
            showmessage('A modalidade cheque será desconsiderada.')
         else
           begin
             sTempo:=Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25ACUMULADO1.AsFloat*100])),15),1,12);  //cheque
             Result:=(Bematech_FI_EfetuaFormaPagamento( pchar( sCheque ), pchar( sTempo ) ) = 1);
           end;
       end;
       if Form1.ibDataSet25PAGAR.AsFloat <> 0 then // Cartão
       begin
         // se o valor em dinheiro já supriu o total da venda
         if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
            showmessage('A modalidade Cartão será desconsiderada.')
         else
           begin
             sTempo:=Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25PAGAR.AsFloat*100])),15),1,12);  //Cartão
             Result:=(Bematech_FI_EfetuaFormaPagamento( pchar( sCartao ), pchar( sTempo ) )=1);
           end;
       end;
       //Modalidade extras
       if Form1.ibDataSet25VALOR01.AsFloat <> 0 then //Modalidade extra 1
       begin
         // se o valor em dinheiro já supriu o total da venda
         if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
            showmessage('A modalidade '+Form2.Label18.Caption+' será desconsiderada.')
         else
           begin
             sTempo:=Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR01.AsFloat*100])),15),1,12);  //Mod extra 1
             //Result:=(_ecf08_CodeErro(Bematech_FI_EfetuaFormaPagamento( pchar( sExtra1 ), pchar( sTempo ) ))=1);
             Result:=(Bematech_FI_EfetuaFormaPagamento( pchar( sExtra1 ), pchar( sTempo ) )=1);
           end;
       end;
       if Form1.ibDataSet25VALOR02.AsFloat <> 0 then //Modalidade extra 2
       begin
         // se o valor em dinheiro já supriu o total da venda
         if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
            showmessage('A modalidade '+Form2.Label19.Caption+' será desconsiderada.')
         else
           begin
             sTempo:=Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR02.AsFloat*100])),15),1,12);  //Mod extra 2
             //Result:=(_ecf08_CodeErro(Bematech_FI_EfetuaFormaPagamento( pchar( sExtra2 ), pchar( sTempo ) ))=1);
             Result:=(Bematech_FI_EfetuaFormaPagamento( pchar( sExtra2 ), pchar( sTempo ) )=1);
           end;
       end;
       if Form1.ibDataSet25VALOR03.AsFloat <> 0 then //Modalidade extra 3
       begin
         // se o valor em dinheiro já supriu o total da venda
         if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
            showmessage('A modalidade '+Form2.Label20.Caption+' será desconsiderada.')
         else
           begin
             sTempo:=Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR03.AsFloat*100])),15),1,12);  //Mod extra 3
//             Result:=(_ecf08_CodeErro(Bematech_FI_EfetuaFormaPagamento( pchar( sExtra3 ), pchar( sTempo ) ))=1);
             Result:=(Bematech_FI_EfetuaFormaPagamento( pchar( sExtra3 ), pchar( sTempo ) )=1);
           end;
       end;
       if Form1.ibDataSet25VALOR04.AsFloat <> 0 then //Modalidade extra 4
       begin
         // se o valor em dinheiro já supriu o total da venda
         if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
            showmessage('A modalidade '+Form2.Label21.Caption+' será desconsiderada.')
         else
           begin
             sTempo:=Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR04.AsFloat*100])),15),1,12);  //Mod extra 4
             //Result:=(_ecf08_CodeErro(Bematech_FI_EfetuaFormaPagamento( pchar( sExtra4 ), pchar( sTempo ) ))=1);
             Result:=(Bematech_FI_EfetuaFormaPagamento( pchar( sExtra4 ), pchar( sTempo ) )=1);
           end;
       end;
       if Form1.ibDataSet25VALOR05.AsFloat <> 0 then //Modalidade extra 5
       begin
         // se o valor em dinheiro já supriu o total da venda
         if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
            showmessage('A modalidade '+Form2.Label22.Caption+' será desconsiderada.')
         else
           begin
             sTempo:=Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR05.AsFloat*100])),15),1,12);  //Mod extra  5
             //Result:=(_ecf08_CodeErro(Bematech_FI_EfetuaFormaPagamento( pchar( sExtra5 ), pchar( sTempo ) ))=1);
             Result:=(Bematech_FI_EfetuaFormaPagamento( pchar( sExtra5 ), pchar( sTempo ) )=1);
           end;
       end;
       if Form1.ibDataSet25VALOR06.AsFloat <> 0 then //Modalidade extra 6
       begin
         // se o valor em dinheiro já supriu o total da venda
         if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
            showmessage('A modalidade '+Form2.Label23.Caption+' será desconsiderada.')
         else
           begin
             sTempo:=Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR06.AsFloat*100])),15),1,12);  //Mod extra 6
             //Result:=(_ecf08_CodeErro(Bematech_FI_EfetuaFormaPagamento( pchar( sExtra6 ), pchar( sTempo ) ))=1);
             Result:=(Bematech_FI_EfetuaFormaPagamento( pchar( sExtra6 ), pchar( sTempo ) )=1);
           end;
       end;
       if Form1.ibDataSet25VALOR07.AsFloat <> 0 then //Modalidade extra 7
       begin
         // se o valor em dinheiro já supriu o total da venda
         if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
            showmessage('A modalidade '+Form2.Label24.Caption+' será desconsiderada.')
         else
           begin
             sTempo:=Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR07.AsFloat*100])),15),1,12);  //Mod extra 7
             //Result:=(_ecf08_CodeErro(Bematech_FI_EfetuaFormaPagamento( pchar( sExtra7 ), pchar( sTempo ) ))=1);
             Result:=(Bematech_FI_EfetuaFormaPagamento( pchar( sExtra7 ), pchar( sTempo ) )=1);
           end;
       end;
       if Form1.ibDataSet25VALOR08.AsFloat <> 0 then //Modalidade extra 8
       begin
         // se o valor em dinheiro já supriu o total da venda
         if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
            showmessage('A modalidade '+Form2.Label25.Caption+' será desconsiderada.')
         else
           begin
             sTempo:=Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR08.AsFloat*100])),15),1,12);  //Mod extra 8
             //Result:=(_ecf08_CodeErro(Bematech_FI_EfetuaFormaPagamento( pchar( sExtra8 ), pchar( sTempo ) ))=1);
             Result:=(Bematech_FI_EfetuaFormaPagamento( pchar( sExtra8 ), pchar( sTempo ) )=1);
           end;
       end;

       sTempo:='';
       if AllTrim(Form2.Edit8.Text) <> '' then
       begin
          sTempo:=Copy('CPF/CNPJ:'+AllTrim(Form2.Edit2.Text)+Replicate(' ',iColunasPorLinha),1,iColunasPorLinha);
          if Length(AllTrim(Form2.Edit8.Text)) <= 35 then
             sTempo:=sTempo+Copy('Nome:'+AllTrim(Form2.Edit8.Text)+Replicate(' ',iColunasPorLinha),1,iColunasPorLinha)
          else
             sTempo:=sTempo+Copy('Nome:'+Copy(AllTrim(Form2.Edit8.Text), 1, 35)+Replicate(' ',(iColunasPorLinha*2)),1,(iColunasPorLinha*2)); // Sandro Silva 2019-08-09 sTempo:=sTempo+Copy('Nome:'+AllTrim(Form2.Edit8.Text)+Replicate(' ',(iColunasPorLinha*2)),1,(iColunasPorLinha*2)); 

          if Length(AllTrim(Form2.Edit1.Text+'-'+Form2.Edit3.Text)) <= 35 then
             sTempo:=sTempo+Copy('End.:'+AllTrim(Form2.Edit1.Text+'-'+Form2.Edit3.Text)+Replicate(' ',iColunasPorLinha),1,iColunasPorLinha)
          else
             sTempo:=sTempo+Copy('End.:'+AllTrim(Form2.Edit1.Text+'-'+Form2.Edit3.Text)+Replicate(' ',(iColunasPorLinha*2)),1,(iColunasPorLinha*2));

       end;
     end
    else //Prazo
     begin
       sTempo:='';
       sTempo:=Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25DIFERENCA_.Asfloat*100])),15),1,12);  //prazo
       Result:=(Bematech_FI_EfetuaFormaPagamento( pchar( sPrazo ), pchar( sTempo ) )=1);
       //fecha o cupom
       //Result:=(Copy(_ecf08_TXRX(Form1.sPorta,10,'.12'+ConverteAcentos(sTempo)),1,1)='.');
     end;

    if Result then
    begin
      // finaliza o cupom //
      Form1.sMensagemPromocional:=ConverteAcentos(Form1.sMensagemPromocional);
      //
      // extrai os caracteres chr(10) e chr(13) se houverem para não travar
{      while Pos(chr(10),Form1.sMensagem) > 0 do
         Form1.sMensagemPromocional:=Copy(Form1.sMensagemPromocional,1,Pos(chr(10),Form1.sMensagem)-1)+' '+Copy(Form1.sMensagem,Pos(chr(10),Form1.sMensagem)+1,length(Form1.sMensagem)-Pos(chr(10),Form1.sMensagem));
      while Pos(chr(13),Form1.sMensagem) > 0 do
         Form1.sMensagem:=Copy(Form1.sMensagem,1,Pos(chr(13),Form1.sMensagem)-1)+' '+Copy(Form1.sMensagem,Pos(chr(13),Form1.sMensagem)+1,length(Form1.sMensagem)-Pos(chr(13),Form1.sMensagem));
}
      //transforma chr(10) em linhas de 42 colunas
      if Form1.sTipoImpressora='BEMATECH_MFD' then
         sTempo1:=Form1.sMensagemPromocional
      else
       begin
        sTempo1:='';
        k:=0;
        for i:=1 to length(Form1.sMensagemPromocional) do
        begin
          if Copy(Form1.sMensagemPromocional,i,1)=chr(10) then
           begin
             if k>0 then
               sTempo1:=sTempo1+Replicate(' ',42-k);
             k:=0;
           end
          else
           begin
             sTempo1:=sTempo1+Copy(Form1.sMensagemPromocional,i,1);
             k:=k+1;
           end;
        end;
       end;
      //fecha o cupom
      _ecf08_CodeErro(Bematech_FI_TerminaFechamentoCupom( pchar( sTempo1 ) ));
    end;
  end;//if fSubTotal > 0
  Result:=true;
end;

// ------------------------------ //
// Cancela o último item  emitido //
// ------------------------------ //
function _ecf08_CancelaUltimoItem(Pp1: Boolean):Boolean;
begin
  Result:=(_ecf08_CodeErro(Bematech_FI_CancelaItemAnterior())=1);
end;

function _ecf08_CancelaUltimoCupom(Pp1: Boolean):Boolean;
begin
  if pP1 then
    Result:=(_ecf08_CodeErro(Bematech_FI_CancelaCupom())=1)
  else
    begin
      Result:=(Bematech_FI_CancelaCupom()=1);
      //se cancelou (as vezes não cancela e retorna True;
      if Result then
         if _ecf08_CupomAberto(True) then //se o cupom está aberto é porque não cancelou
            Result:=False;
    end;
end;

function _ecf08_SubTotal(Pp1: Boolean):Real;
var
  sSubTotal:String;
begin
  sSubTotal:=Replicate(' ',14);
  if pP1 then
   begin
     _ecf08_CodeErro(Bematech_FI_SubTotal( sSubTotal ));
   end
  else
   if Bematech_FI_SubTotal( sSubTotal )=0 then
     sSubTotal:='0';// se pp1 for falso não verifica o erro
  Result := StrToFloat(sSubTotal)/100;
end;

// ------------------------------ //
// Abre um novo copom fiscal      //
// ------------------------------ //
function _ecf08_AbreNovoCupom(Pp1: Boolean):Boolean;
var
  sModoOperacao,sDataMovimento:string;
begin
  Result:=False;
  // verifica se está em modo de INTERVENÇÃO
  sModoOperacao:=' ';
  if (Bematech_FI_VerificaModoOperacao( pchar(sModoOperacao) )=1) then
  begin
    if sModoOperacao='0' then
     begin
      showmessage('O ECF está em modo de intervenção técnica.'+chr(10)+
                 'Chame um técnico habilitado para retirá-lo deste modo.');
      halt(1);
     end
    else
      Result:=True;
  end;
  if Result then
  begin
     // verifica se necessita redução Z
     sDataMovimento := Replicate(' ',6);
     Result:=(_ecf08_CodeErro(Bematech_FI_DataMovimento( sDataMovimento ))=1);
     if Result then
     begin
        //se a data do movimento for <> data de hoje tenta fazer redução Z
        try
          if StrToDate(Copy(sDataMovimento,1,2)+'/'+Copy(sDataMovimento,3,2)+'/20'+Copy(sDataMovimento,5,2)) < Date then
          begin
            _ecf08_ReducaoZ(True);
            //Form1.EmitirReducaoZ(Form1);// 2015-10-07 Deve emitir mesas aberta, fechar as aberta a mais de 1 dias antes ou logo após da redução Z
          end;
        except
        end;

        if _ecf08_CupomAberto(True) then // se o cupo já estiver aberto ignora a checagem de erro
         begin
           Bematech_FI_AbreCupom('');
           Result:=True;
         end
        else
         begin
          Result:=(_ecf08_CodeErro(Bematech_FI_AbreCupom(''))=1);//
          if not Result then
           begin
             Result:=(Bematech_FI_FechaComprovanteNaoFiscalVinculado()=1);
             if not result then
                Result := (Bematech_FI_FechaRelatorioGerencial()=1);
             if Result then //tenta abrir de novo
                Bematech_FI_FechaComprovanteNaoFiscalVinculado();
             //Form1.bCupomAberto:=False;
             //tenta abrir de novo
             Result:=(_ecf08_CodeErro(Bematech_FI_AbreCupom(''))=1);//
           end;
          //else
           // Form1.bCupomAberto:=True; //tirei estas linhas pois não pedia mais o vendedor
         end;
     end;
{     if Bematech_FI_FlagsFiscais( iFlagFiscal )=1 then
      begin
//        if iFlagFiscal = 0 then
        showmessage(inttostr(iFlagFiscal));
        Result:=True;
//       Result:=(Copy(Right(Replicate('0',8)+IntToBin(iFlagFiscal),8),6,1)='1');
      end
     else
       Result:=False;
  end;
  if Result then
  begin
    Bematech_FI_AberturaDoDia( pchar( '50,00' ), pchar( 'Dinheiro' ) );

      }

{

       if Copy(sRetorno,21,1)= 'F' then
       begin
         //Faz a redução Z
         _ecf08_ReducaoZ(true);
       end;
       if Form1.bCupomAberto then //tenta abrir o cupom sem checagem de erro
        begin
          _ecf08_TXRX('17');
          Result:=True;
        end
       else
        begin
           // verifica se necessita leitura X
           if Copy(_ecf08_TXRX('28'),122,1)= 'F' then
           begin
              //Faz a leitura X
              _ecf08_LeituraX(true);
           end;
           //tenta abrir de novo
           sleep(1000);
           sRetorno:=_ecf08_TXRX('17');
           if (Pos('ERRO',sRetorno) >0) or (Pos('DIA ENCERRADO',sRetorno) >0) then
            begin
              showmessage(sRetorno);
              Result:=False;
            end
           else
              Result:=True;
        end;
       //
    end;}
  end;
end;


// -------------------------------- //
// Retorna o número do Cupom        //
// -------------------------------- //
function _ecf08_NumeroDoCupom(Pp1: Boolean):String;  
//var
//  sValor:String;
//  fValor:Double;
//  i:integer;
begin
  Result:=Replicate(' ',6);
  _ecf08_CodeErro(Bematech_FI_NumeroCupom( Result ));
{  if not Pp1 then
  begin
    sValor:=Replicate(' ',445);
    _ecf08_CodeErro(Bematech_FI_VerificaTotalizadoresParciais( sValor ));
    sValor:=LimpaNumero(sValor);
    fValor:=0;
    for i:=1 to 19 do
    begin
      fValor:=fValor+StrToInt(Copy(sValor,((i-1)*14)+1,14));
    end;
    // se a venda bruta do dia for igual a 0, não diminui 1 para acertar o reg inicial
    if fValor > 0 then
       Result:=StrZero(StrToInt(Result)-1,6,0);
  end;
//  showmessage(Format('%8.2f',[fValor]));}
end;

// ------------------------------ //
// Cancela um item N              //
// ------------------------------ //
function _ecf08_CancelaItemN(pP1, pP2 : String):Boolean;
var
  j,i:integer;
begin
  result:=False;

  pP1:=Right(pP1,3);
//  Result:=(_ecf08_CodeErro(Bematech_FI_CancelaItemGenerico( pchar( pP1 ) ))=1);

  if _ecf08_SubTotal(True) > 0 then
  begin
//     _ecf08_Envia('25'+StrZero((StrToInt(pP1)+Form1.iCancelaItenN),3,0)); //
     j:=StrToInt(pP1);
     for i:=1 to Form1.ComponentCount-1 do
     begin
       if (i<=StrToInt(pP1)) and ((Copy(AllTrim(TLAbel(Form1.Components[Form1.ComponentCount-1]).Caption),1,8) = 'Desconto') or (Copy(AllTrim(TLAbel(Form1.Components[Form1.ComponentCount-1]).Caption),1,8) = 'Cancelad')) then
         j:=j+1;
     end;
     if ((Copy(AllTrim(TLAbel(Form1.Components[Form1.ComponentCount-1]).Caption),1,8) = 'Desconto') or (Copy(AllTrim(TLAbel(Form1.Components[Form1.ComponentCount-1]).Caption),1,8) = 'Desconto')) then
      begin
        showmessage('Não é possível cancelar item com desconto');
        result:=False;
      end
     else
      begin
        Result:=(_ecf08_CodeErro(Bematech_FI_CancelaItemGenerico( pchar( StrZero(j,3,0) ) ))=1);
        if not result then
         begin
           showmessage('Não é possível cancelar este item');
         end;
      end;
   end;
end;

// -------------------------------- //
// Abre a gaveta                    //
// -------------------------------- //
function _ecf08_AbreGaveta(Pp1: Boolean):Boolean;
begin
   Result:=False;
   if (Form1.sGaveta <> '128') then
     Result:=(_ecf08_CodeErro(Bematech_FI_AcionaGaveta())=1);
end;

// -------------------------------- //
// Status da gaveta                 //
// -------------------------------- //
function _ecf08_StatusGaveta(Pp1: Boolean):String;
var
  Mais1ini : TiniFile;
  iEstadoGaveta:integer;
begin
  if Pp1 then
   begin
      Mais1ini  := TIniFile.Create('frente.ini');
      if Mais1Ini.ReadString('Impressora Fiscal','Gaveta','X') = '1' then //tem gaveta
       begin
         iEstadoGaveta:=0;
         Bematech_FI_VerificaEstadoGaveta( iEstadoGaveta );
         if iEstadoGaveta  = 0 then // Gaveta fechada ou sem gaveta
           Result:='000'
         else
           Result:='255';//Gaveta Aberta
       end
      else
       if Mais1Ini.ReadString('Impressora Fiscal','Gaveta','X') = 'X' then //Verifica se tem
        begin
          if Application.MessageBox(Pchar('Existe gaveta conectada ? '),'Confirma',mb_YesNo + MB_DEFBUTTON2+ MB_ICONWARNING) <> IDYES then
           begin
             Mais1Ini.WriteString('Impressora Fiscal','Gaveta','0');
             Result:='128'; //sem gaveta
           end
          else
           begin
             Mais1Ini.WriteString('Impressora Fiscal','Gaveta','1');
             iEstadoGaveta:=0;
             Bematech_FI_VerificaEstadoGaveta( iEstadoGaveta );
             if iEstadoGaveta  = 0 then // Gaveta fechada ou sem gaveta
               Result:='000'
             else
               Result:='255';//Gaveta Fechada
           end;
        end
       else
        Result:='128'; //sem gaveta
      Mais1ini.Free;
   end;
   sleep(500);
end;

// -------------------------------- //
// Sangria                          //
// -------------------------------- //
function _ecf08_Sangria(Pp1: Real):Boolean;
var
  sSangria:String;
begin
  sSangria:=LimpaNumero(Format('%13.2f',[pP1]));
  Result:=(_ecf08_CodeErro(Bematech_FI_Sangria( pchar(sSangria)))=1);
end;

// -------------------------------- //
// Suprimento                       //
// -------------------------------- //
function _ecf08_Suprimento(Pp1: Real):Boolean; 
Var
  sForma,  sSuprimento:String;
begin
  sSuprimento:=LimpaNumero(Format('%13.2f',[pP1]));
  sForma:='';
  Result:=(_ecf08_CodeErro(Bematech_FI_Suprimento( pchar(sSuprimento), pchar(sForma) ))=1);
end;

// -------------------------------- //
// Nova Aliquota                    //
// -------------------------------- //
function _ecf08_NovaAliquota(Pp1: String):Boolean;
//var
//   I:integer;
//   sNomeAliq:string;
begin
{   //verifica qual é a próxima em branco
   sNomeAliq:='';
   for I := 1 to 16 do  // São no maximo 16 aliquotas //
   begin
     if sNomeAliq = '' then
       if Copy(Form1.sAliquotas,(I*4)-1,4)='0000' then sNomeAliq := StrZero(I,2,0);
   end;

   if sNomeAliq='' then
    begin
      showmessage('Não há Alíquotas em branco');
      Result:=False;
    end
   else
     Result:=(Copy(_ecf08_TXRX(Form1.sPorta,60,'33'+'T'+sNomeAliq+pP1),1,1)='.');}
   showmessage('O Cadastro de alíquotas só é permitido através de intervenção técnica');
   result:=false;
end;

function _ecf08_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
begin
  ShowMessage('Função não suportada pelo modelo de ECF utilizado.');
  if Form7.Label3.Caption = 'Data inicial:' then Bematech_FI_DownloadMFD( pChar(pP1), pchar( pP2 ), pchar( pP3 ))
  else Bematech_FI_DownloadMFD( pChar(pP1), pchar( pP2 ), pchar( pP3 ));
  Result := True;
end;


function _ecf08_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
begin
//  showmessage(pP1+chr(10)+pP2);
  if Form7.Label3.Caption = 'Data inicial:' then
    Result:=(_ecf08_CodeErro(Bematech_FI_LeituraMemoriaFiscalData( pchar( pP1 ), pchar( pP2 ) ))=1)
  else
    Result:=(_ecf08_CodeErro(Bematech_FI_LeituraMemoriaFiscalReducao( pchar( pP1 ), pchar( pP2 ) ))=1);
end;


// -------------------------------- //
// Venda do Item                    //
// -------------------------------- //
function _ecf08_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
{       StrZero(StrToInt(ibDataSet4.FieldByname('CODIGO').AsString),13,0), // Código
                               copy(sDescricao,1,29), // Descricão
                               ST                   , // ST
         StrZero(ibDataSet27QUANTIDADE.AsFloat*1000,7,0), // Quantidade
            StrZero(ibDataSet27UNITARIO.AsFloat*100,7,0), // Unitário
                    Copy(ibDataSet4.FieldByname('MEDIDA').AsString,1,2)); // Medida;
                    Desconto %
                    Desconto Valor
}
var
  sTipoDesc,sTipoQuant,sDesc:string;
begin
  {
  Codigo: STRING até 13 caracteres com o código do produto.
  Descricao: STRING até 29 caracteres com a descrição do produto.
  Aliquota: STRING com o valor ou o índice da alíquota tributária. Se for o valor deve ser informado com o tamanho de 4 caracteres ou 5  com a  vírgula. Se for o índice da alíquota deve ser 2 caracteres. Ex. (18,00 para o valor ou  05 para o índice).
  TipoQuantidade: 1 (um) caracter indicando o tipo de quantidade. I - Inteira e F - Fracionária.
  Quantidade: STRING com até 4 dígitos para quantidade inteira e 7 dígitos para quantidade fracionária. Na quantidade fracionária são 3 casas decimais.
  CasasDecimais: INTEIRO indicando o número de casas decimais para o valor unitário (2 ou 3).
  ValorUnitario: STRING até 8 dígitos para valor unitário.
  TipoDesconto: 1 (um) caracter indicando a forma do desconto. '$' desconto por valor e '%' desconto percentual.
  ValorDesconto: String com até 8 dígitos para desconto por valor (2 casas decimais) e 4 dígitos para desconto percentual.
  }

  if Copy(pP3,1,2)='IS' then
  begin
    pP3:=Right(pP3,2);
  end;
  //Junta a unidade de medida com a descrição
  pP2:=pP6 + ' ' + Copy(pP2,1,26);

  if StrToInt(pP7) > 0 then
   begin
     sTipoDesc:='%';
     sDesc := Right(pP7,4);
   end
  else
   if StrToInt(pP8) > 0 then
    begin
      sTipoDesc:='$';
      //8 digitos com 2 casas decimais
      sDesc:='0'+pP8;
    end
   else
    begin
      sTipoDesc:='%';
      sDesc:='0000';
    end;
  //compara os 2 ou 3 últimos dígitos para ver se é inteiro ou não, se for igual é inteiro
//  if  Right(pP4,StrToInt(Form1.ConfCasas)) = Replicate('0',StrToInt(Form1.ConfCasas)) then
//Compara os tres últimos dígitos se for 000 é inteiro
    if  Right(pP4,3) = '000' then
    begin
      Delete(pP4,5,3);
      sTipoQuant:='I';
      Result:=(Bematech_FI_VendeItem( pchar( pP1 ), pchar( pP2 ), pchar( pP3 ), pchar( sTipoQuant ), pchar( pP4 ), StrToInt(Form1.ConfPreco), pchar( pP5 ), pchar( sTipoDesc ), pchar( sDesc ) )=1);
    end
  else
    begin
      sTipoQuant:='F';
      Result:=(Bematech_FI_VendeItem( pchar( pP1 ), pchar( pP2 ), pchar( pP3 ), pchar( sTipoQuant ), pchar( pP4 ), StrToInt(Form1.ConfPreco), pchar( pP5 ), pchar( sTipoDesc ), pchar( sDesc ) )=1);
    end;
{  showmessage(' pP1 '+pP1+chr(10)+
              ' pP2 '+pP2+chr(10)+
              ' pP3 '+pP3+chr(10)+
              ' pP4 '+pP4+chr(10)+
              ' pP5 '+pP5+chr(10)+
              ' pP6 '+pP6+chr(10));
}
end;

// -------------------------------- //
// Reducao Z                        //
// -------------------------------- //
function _ecf08_ReducaoZ(pP1: Boolean):Boolean;
var
  sData,sHora:String;
begin
  sData:=DateToStr(Date);
  sHora:=TimeToStr(Time);
  Result:=(Bematech_FI_ReducaoZ( pchar(sData), pchar(sHora))=1);
//  sleep(30000);// espera 30 segundos
end;

// -------------------------------- //
// Leitura X                        //
// -------------------------------- //
function _ecf08_LeituraX(pP1: Boolean):Boolean;
begin
  Result:=(Bematech_FI_LeituraX()=1);
//  sleep(30000);// espera 30 segundos
end;

// ---------------------------------------------- //
// Retorna se o horario de verão está selecionado //
// ---------------------------------------------- //
function _ecf08_RetornaVerao(pP1: Boolean):Boolean; 
var
  iFlagFiscal:integer;
begin
  if Bematech_FI_FlagsFiscais( iFlagFiscal )=1 then
   begin
     Result:=(Copy(Right(Replicate('0',8)+IntToBin(iFlagFiscal),8),6,1)='1');
   end
  else
     Result:=False;
end;

// -------------------------------- //
// Liga ou desliga horário de verao //
// -------------------------------- //
function _ecf08_LigaDesLigaVerao(pP1: Boolean):Boolean;
begin
  Result:=(Bematech_FI_ProgramaHorarioVerao()=1);
end;

// -------------------------------- //
// Retorna a versão do firmware     //
// -------------------------------- //
function _ecf08_VersodoFirmware(pP1: Boolean): String;
begin
  Result:=Replicate(' ',4);
  if Bematech_FI_VersaoFirmware(Result)<>1 then
     Result:='';
end;

// -------------------------------- //
// Retorna o número de série        //
// -------------------------------- //
function _ecf08_NmerodeSrie(pP1: Boolean): String;
var
  i:integer;
begin
  if Form1.sTipoImpressora='BEMATECH_MFD' then
   begin
     // reserva 20 bytes para a variável
     Result := replicate(' ',20);
     if _ecf08_CodeErro(Bematech_FI_NumeroSerieMFD( Result )) <> 1 then
        Result:='';
     //a rotina abaixo retira os chr(0)s que voltam na variável
     for i:=1 to 20 do
     begin
       if ord(Result[i])=0 then
           break;
     end;
     if i>0 then
       Result:=Copy(Result,1,i-1);
     Result:=AllTrim(Result);
   end
  else
   begin
     Result := replicate(' ',20);
     if _ecf08_CodeErro(Bematech_FI_NumeroSerie(Result))<> 1 then
       Result:='';
     for i:=1 to 20 do
     begin
       if ord(Result[i])=0 then
              break;
     end;
     if i>0 then
       Result:=Copy(Result,1,i-1);
     Result:=AllTrim(Result);
   end;
end;
{   var cNumeroSerie : String;
       iConta       : Integer;
  Begin
     // reserva 15 bytes para a variável
     For iConta := 1 To 20 Do Begin cNumeroSerie := cNumeroSerie + ' ' End;
     // função que retorna o número de série da impressora
     Bematech_FI_NumeroSerieMFD( cNumeroSerie );
     ShowMessage( 'Número de Série:' + #13 + #13 + cNumeroSerie );
  End;}

// -------------------------------- //
// Retorna o CGC e IE               //
// -------------------------------- //
function _ecf08_CGCIE(pP1: Boolean): String;  
var
  sCGC,sIE:string;
begin
  sCGC := Replicate(' ',18);
  sIE  := Replicate(' ',15);
  if _ecf08_CodeErro(Bematech_FI_CGC_IE( sCGC, sIE )) <> 1 then
     Result := ''
  else
     Result := sCGC+'-'+sIE;
end;

// --------------------------------- //
// Retorna o valor  de cancelamentos //
// --------------------------------- //
function _ecf08_Cancelamentos(pP1: Boolean): String;  
begin
{  Result:=Replicate(' ',631);
  if Bematech_FI_DadosUltimaReducao( Result ) <> 1 then
     Result:=''
  else
     Result:=Copy(Result,23,14);
}
  Result:=Replicate(' ',14);
  if Bematech_FI_Cancelamentos( Result ) <> 1 then
     Result:='';
end;

// -------------------------------- //
// Retorna o valor de descontos     //
// -------------------------------- //
function _ecf08_Descontos(pP1: Boolean): String;  
begin
{  Result:=Replicate(' ',631);
  if Bematech_FI_DadosUltimaReducao( Result ) <> 1 then
     Result:=''
  else
     Result:=Copy(Result,38,14);
}
  Result:=Replicate(' ',14);
  if Bematech_FI_Descontos( Result ) <> 1 then
     Result:='';
end;

// -------------------------------- //
// Retorna o contador sequencial    //
// -------------------------------- //
function _ecf08_ContadorSeqencial(pP1: Boolean): String;  
begin
{  Result:=Replicate(' ',631);
  if Bematech_FI_DadosUltimaReducao( Result ) <> 1 then
     Result:=''
  else
     Result:=Copy(Result,579,6);
}
  Result:=Replicate(' ',6);
  if Bematech_FI_NumeroCupom( Result ) <> 1 then
     Result:='';
end;

// -------------------------------- //
// Retorna o número de operações    //
// não fiscais acumuladas           //
// -------------------------------- //
function _ecf08_Nmdeoperaesnofiscais(pP1: Boolean): String;   
begin
  Result:=Replicate(' ',631);
  if Bematech_FI_DadosUltimaReducao( Result ) <> 1 then
     Result:=''
  else
     Result:=Copy(Result,586,6);
end;

function _ecf08_NmdeCuponscancelados(pP1: Boolean): String;  
begin
  Result:=Replicate(' ',4);
  if (Bematech_FI_NumeroCuponsCancelados( Result ) <> 1) then
     Result:='';
end;

function _ecf08_NmdeRedues(pP1: Boolean): String;  
begin
  Result:=Replicate(' ',4);
  if (Bematech_FI_NumeroReducoes( Result ) <> 1) then
     Result:=''
  else
     Result:=StrZero(StrToInt(Result)+1,4,0);//soma um para gravar certo no arq. de reduções.
end;

function _ecf08_Nmdeintervenestcnicas(pP1: Boolean): String;  
begin
  Result:=Replicate(' ',4);
  if (Bematech_FI_NumeroIntervencoes( Result ) <> 1) then
     Result:='';
end;


function _ecf08_Nmdesubstituiesdeproprietrio(pP1: Boolean): String; 
begin
  Result:=Replicate(' ',4);
  if Copy(Form1.sTipoImpressora,1,8)='BEMATECH' then
  begin
    if (Bematech_FI_NumeroSubstituicoesProprietario( Result ) <> 1) then
       Result:='';
  end;
end;

function _ecf08_Clichdoproprietrio(pP1: Boolean): String; 
begin
  Result:=Replicate(' ',186);
  if (Bematech_FI_ClicheProprietario( Result ) <> 1) then
     Result:='';
end;

// ------------------------------------ //
// Importante retornar apenas 3 dígitos //
// Ex: 001                              //
// ------------------------------------ //
function _ecf08_NmdoCaixa(pP1: Boolean): String;  
begin
  Result:=Replicate(' ',4);
  _ecf08_CodeErro(Bematech_FI_NumeroCaixa( Result ));
  Result:=Right(Result,3);
end;

function _ecf08_Nmdaloja(pP1: Boolean): String; 
begin
  Result:=Replicate(' ',4);
  _ecf08_CodeErro(Bematech_FI_NumeroLoja( Result ));
end;

function _ecf08_Moeda(pP1: Boolean): String;  
begin
  Result:=Replicate(' ',2);
  _ecf08_CodeErro(Bematech_FI_SimboloMoeda( Result ));
  Result:=StrTran(AllTrim(Result),'$','');  
end;

function _ecf08_Dataehoradaimpressora(pP1: Boolean): String;
var
 sData,sHora:String;
begin
 sData := Replicate(' ',6);
 sHora := Replicate(' ',6);
 _ecf08_CodeErro(Bematech_FI_DataHoraImpressora(sData,sHora));
 Result:=sData+sHora;//DDMMAAHHMMSS
end;

function _ecf08_Datadaultimareduo(pP1: Boolean): String;
begin
end;

function _ecf08_Datadomovimento(pP1: Boolean): String;  
begin
{  Result:=Replicate(' ',631);
  if Bematech_FI_DadosUltimaReducao( Result ) <> 1 then
     Result:=''
  else
     Result:=Copy(Result,596,6);}
  Result:=Replicate(' ',6);
  if Bematech_FI_DataMovimento( Result ) <> 1 then
     Result:='';
end;

function _ecf08_Tipodaimpressora(pP1: Boolean): String; //
begin
end;

// Deve retornar uma String com:                                          //
// Os 2 primeiros dígitos são o número de aliquotas gravadas: Ex 16       //
// os póximos de 4 em 4 são as aliquotas Ex: 1800                         //
// Ex: 161800120005000000000000000000000000000000000000000000000000000000 //
// retorna + 64 caracteres quando tem ISS                                 //

function _ecf08_RetornaAliquotas(pP1: Boolean): String;
var
  sISS, sAliquotas, sIndiceAliquotas : String;
  i:integer;
begin
//  AliquotasIss:=Replicate(' ',79);
//  iRetorno := Bematech_FI_VerificaAliquotasIss( AliquotasIss );
  Result:='';
  sAliquotas := Replicate(' ',79);
  if _ecf08_CodeErro(Bematech_FI_RetornoAliquotas( sAliquotas ))=1 then
  begin
    Result:=Copy(AllTrim(LimpaNumero(sAliquotas))+Replicate('0',64),1,64);//tira as vírgulas
    sISS:='';
    //verifica qual é a aliquota de ISS
    sIndiceAliquotas:=Replicate(' ',48);
    if _ecf08_CodeErro(Bematech_FI_VerificaIndiceAliquotasIss( sIndiceAliquotas ))=1 then
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


function _ecf08_Vincula(pP1: String): Boolean;
begin
   Result:=False;
end;


function _ecf08_FlagsDeISS(pP1: Boolean): String;
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
  Result:=chr(BinToInt(Copy(Result,1,8)))+chr(BinToInt(Copy(Result,9,8)));
end;

function _ecf08_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
begin
  if Copy(Form1.sTipoImpressora,1,8)='BEMATECH' then
    Result:=(_ecf08_CodeErro(Bematech_FI_FechaPortaSerial())=1)
  else
    Result:=True;
end;

function _ecf08_MudaMoeda(pP1: String): Boolean; 
begin
  Result:=False;
  if Copy(Form1.sTipoImpressora,1,8)='BEMATECH' then
     Result:=(_ecf08_CodeErro(Bematech_FI_AlteraSimboloMoeda( pchar( pP1 ) ))=1)
end;

function _ecf08_MostraDisplay(pP1: String): Boolean;
begin
  Result := True;
end;

function _ecf08_leituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean; 
begin
  Screen.Cursor := crHourGlass; // Cursor de Aguardo
  if Form7.Label3.Caption = 'Data inicial:' then
     _ecf08_CodeErro(Bematech_FI_LeituraMemoriaFiscalSerialData( pchar( pP2 ), pchar( pP3 ) ))
  else
     _ecf08_CodeErro(Bematech_FI_LeituraMemoriaFiscalSerialReducao( pchar( pP2 ), pchar( pP3 ) ));

  Screen.Cursor := crDefault; // Cursor normal
  //
//  ShowMessage('O seguinte arquivo será gravado: '+pP1);
  CopyFile( pChar(Form1.sAtual+'\'+'Retorno.txt') , pChar(pP1), True );
  Result := True;
end;


function _ecf08_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean; //iP2 = Número do Cupom vinculado
var
  I,J: Integer;
  sMod, sPar1,sPar2, sX: String;
//  Mais1ini : TiniFile;
begin
   begin
     Bematech_FI_FechaComprovanteNaoFiscalVinculado();//tenta fechar
     if Form1.ibDataSet25DIFERENCA_.AsFloat > 0 then sMod:='Prazo';
     if Form1.ibDataSet25PAGAR.AsFloat > 0      then sMod:='Cartao';
     if Form1.ibDataSet25ACUMULADO1.AsFloat > 0 then sMod:='Cheque';
     sPar1:='';
     sPar2:='';
     Result:=(Bematech_FI_AbreComprovanteNaoFiscalVinculado( pchar( sMod ), pchar( sPar1 ), pchar( sPar2 ) )=1);
     if Result = True then
     begin
      //Verifica o estado da impressora
      Result:=(Bematech_FI_VerificaImpressoraLigada()=1);
      if Result then
      begin
        for J := 1 to 1 do
        begin
          sX:='';
          for I := 1 to Length(sP1) do
          begin
            if Result = True then
            begin
               if Copy(sP1,I,1) <> chr(10) then
                begin
                  sX:=sX+Copy(sP1,I,1);
                end
               else
                begin
                  if AllTrim(sX) <> '' then
                   begin
                     //imprime a linha
                     Result:=(Bematech_FI_UsaComprovanteNaoFiscalVinculado( pchar( sX ) )=1);
                     if Result then Result:=_ecf08_TestaLigadaePapel(true);
                     //Result:=(Bematech_FI_VerificaImpressoraLigada()=1);
                     sX:='';
                   end
                  else
                   begin
                     if Form1.sTipoImpressora = 'BEMATECH' then
                        sX:=Chr(10)
                     else
                        sX:=Replicate(' ',40);
                     Result:=(Bematech_FI_UsaComprovanteNaoFiscalVinculado( pchar( sX ) )=1);
                     if Result then Result:=_ecf08_TestaLigadaePapel(true);
                     sX:='';
                   end;
                end;
            end;
          end;
          if AllTrim(sX) <> '' then
          begin
            //imprime a linha
            Result:=(Bematech_FI_UsaComprovanteNaoFiscalVinculado( pchar( sX ) )=1);
            if Result then Result:=_ecf08_TestaLigadaePapel(true);
          end;

          //avança 7 linhas
          if J < 1  then
          begin
            //avança 7 linhas
            if Result = True then
            begin
              if Form1.sTipoImpressora = 'YANCO' then
//                sX:=Chr(10)+chr(10)+Chr(10)+chr(10)+Chr(10)+chr(10)+chr(10)
//              else
                sX:=Replicate(' ',280);
              Result:=(Bematech_FI_UsaComprovanteNaoFiscalVinculado( pchar( sX ) )=1);
              if Result then Result:=_ecf08_TestaLigadaePapel(true);
            end;
            if Result = True then sleep(4000); // Da um tempo;
          end;
        end;
      end;
    end;
    //Result:=(Bematech_FI_FechaComprovanteNaoFiscalVinculado()=1);
    Bematech_FI_FechaComprovanteNaoFiscalVinculado();
    if Form1.sTipoImpressora='BEMATECH_MFD' then
     begin
       Result:=_ecf08_TestaLigadaePapel(true);
       Bematech_FI_SegundaViaNaoFiscalVinculadoMFD();
     end
    else
      Result:=_ecf08_TestaLigadaePapel(true);
    //Result:=(_ecf08_CodeErro(Bematech_FI_VerificaImpressoraLigada())=1);
   end;
//  Result := (Bematech_FI_FechaRelatorioGerencial()=1);
end;

function _ecf08_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
var
  I,J,iTamanhoDaLinha : Integer;
  sX: String;
  //
begin
  if Form1.sTipoImpressora = 'BEMATECH' then
     iTamanhoDaLinha:=40
  else
     iTamanhoDaLinha:=42;
  if 1 <> 0 then
   begin
     //showmessage(sP1);
     //showmessage(MostraCHR(sP1));
     //Verifica o estado da impressora
     Result:=(Bematech_FI_VerificaImpressoraLigada()=1);
     if Result then
     begin
       for J := 1 to 1 do
       begin
         //
         //tirar chr(10) e completar com espacos até formar 40 ou 42 colunas
         sX:='';// variável para armazenar a linha
         for I := 1 to Length(sP1) do
         begin
           if Result = True then
           begin
             if Copy(sP1,I,1) <> chr(10) then
              begin
                //adiciona o caracter na variável sX
                sX:=sX+Copy(sP1,I,1);
              end
             else
              begin
                // é um chr(10)
                if AllTrim(sX) ='' then // está em branco
                   sX:=Replicate(' ',iTamanhoDaLinha)
                else
                 begin
                   sX:=Copy(sX+Replicate(' ',iTamanhoDaLinha),1,iTamanhoDaLinha);
                 end;
                //imprime a linha
                if Result then
                   Result:=(Bematech_FI_RelatorioGerencial(pchar(sX))=1);
//                if Result then  Result:=(Bematech_FI_VerificaImpressoraLigada()=1);
                if Result then Result:=_ecf08_TestaLigadaePapel(true);
                if not Result then break;
                sX:='';
              end;
           end;
         end;
         if AllTrim(sX) <>'' then // não está em branco
         begin
           if Result then
             Result:=(Bematech_FI_RelatorioGerencial(pchar(sX))=1);
           if Result then Result:=_ecf08_TestaLigadaePapel(true);
         end;
         //avança 7 linhas
         if J < 1 then
         begin
           if Form1.sTipoImpressora = 'BEMATECH' then
             sX:=Chr(10)+chr(10)+Chr(10)+chr(10)+Chr(10)+chr(10)+chr(10)
           else
             sX:=Replicate(' ',294);
           if Result then
              Result:=(Bematech_FI_RelatorioGerencial( pchar( sX ) )=1);
           if Result then Result:=_ecf08_TestaLigadaePapel(true);
           if Result = True then sleep(4000); // Da um tempo;
         end;
       end;//for J
     end;//if result
     Result := (Bematech_FI_FechaRelatorioGerencial()=1);  // Fecha cupom não sujeito ao ICMS
     if Result then Result:=_ecf08_TestaLigadaePapel(true);
   end //ivias
  else
    Result:=True;
end;

function _ecf08_FechaCupom2(sP1: Boolean): Boolean;
begin
  Result:=(Bematech_FI_FechaComprovanteNaoFiscalVinculado()=1);
  if not result then
     Result := (Bematech_FI_FechaRelatorioGerencial()=1);
  //
end;

function _ecf08_ImprimeCheque(rP1: Real; sP2: String): Boolean;
begin
  Result:=False;
  if Copy(Form1.sTipoImpressora,1,8)='BEMATECH' then
  begin
     Result := False;
     if AllTrim(Form1.ibDataSet13.FieldByname('MUNICIPIO').AsString) <> '' then
      begin
        ShowMessage('Posicione o cheque na impressora, e tecle <enter>. '+sP2);
        //
        Result := True;
        if _ecf08_codeErro(Bematech_FI_ImprimeCheque( pchar( sP2 ), pchar( StrZero(rP1*100,14,0) ), pchar( Form1.ibDataSet13.FieldByname('NOME').AsString ), pchar( AllTrim(Form1.ibDataSet13.FieldByname('MUNICIPIO').AsString) ), pchar( DateToStr(Date) ), pchar( '' ) )) <> 1 then
           Result := False;
        ShowMessage('Retire o cheque na impressora, e tecle <enter>.');
      end
     else ShowMessage('O município do emitente não está preenchido.');
     //
  end;
end;

function _ecf08_GrandeTotal(sP1: Boolean): String;
begin
  Result := Replicate(' ',18);
  if Bematech_FI_GrandeTotal( Result ) <> 1 then
     Result:='0';
end;

function _ecf08_TotalizadoresDasAliquotas(sP1: Boolean): String;
begin
{- São retornadas as seguintes informações separadas por vírgulas:

Totalizadores parciais tributados..........: 224 bytes
Isenção....................................: 14 bytes
Não insidência.............................: 14 bytes
Substitução................................: 14 bytes
Totalizadores parciais não sujeitos ao ICMS: 126 bytes

Sangria....................................: 14 bytes
Suprimento.................................: 14 bytes
Grande Total...............................: 18 bytes
}

  Result:=Replicate(' ',445);
  if Bematech_FI_VerificaTotalizadoresParciais( Result ) <> 1 then
     Result:=''
  else
   begin
     Result:=Copy(Result,1,224)+Copy(Result,226,14)+Copy(Result,241,14)+Copy(Result,256,14);
   end;
end;

function _ecf08_CupomAberto(sP1: Boolean): boolean;
var
  iFlagFiscal:integer;
begin
  if Bematech_FI_FlagsFiscais( iFlagFiscal )=1 then
   begin
     Result:=(Copy(Right(Replicate('0',8)+IntToBin(iFlagFiscal),8),8,1)='1');
   end
  else
     Result:=False;
end;

function _ecf08_FaltaPagamento(sP1: Boolean): boolean; 
var
  iFlagFiscal:integer;
begin
  Result:=false;
  if Copy(Form1.sTipoImpressora,1,8)='BEMATECH' then
  begin
    if Bematech_FI_FlagsFiscais( iFlagFiscal )=1 then
       Result:=(Copy(Right(Replicate('0',8)+IntToBin(iFlagFiscal),8),7,1)='1')
    else
       Result:=False;
  end;
end;

end.






