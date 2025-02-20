unit _Small_11;

interface

uses
  Windows, Messages, SmallFunc_xe, Fiscal, SysUtils,Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Mask, Grids, DBGrids, DB, DBCtrls, SMALL_DBEdit, IniFiles, Unit2, Unit22;
  // ------------------------------ //
  // Alterado 10/11/2005 - RONEI    //
  // ------------------------------ //
  // ------------------------------ //
  // INTERPROM
  // --------------------------------------------- //
  //  - Acesse: www.interprom.com.br/kitecf        //
  //  - Usuário: kitecf                            //
  //  - Senha: ecf4176                             //
  //  - Domínio se solicitado: interprom.com.br    //
  // --------------------------------------------- //
  //Comandos Cupons Fiscais
  function ICASH_Abre( ICASH_PortaSerial: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_Fecha : Integer; StdCall; External 'ICASH.DLL';
  function ICASH_LeDadosFiscais (ICASH_Numero: String;ICASH_Estado: String; ICASH_Resposta_1: String; ICASH_Resposta_2: String; ICASH_Resposta_3: String; ICASH_Resposta_4: String; ICASH_Resposta_5:  String): Integer; StdCall; External 'ICASH.DLL';
  //
  function ICASH_LeituraX( ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_ReducaoZ( ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_AbreCupom(ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_TotalizaCupom( ICASH_Finalizadora: String ;ICASH_Valor: String ;ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_PromoveCupom( ICASH_Atributo: String;ICASH_Mensagem_1: String;ICASH_Mensagem_2: String;ICASH_Mensagem_3: String;ICASH_Mensagem_4: String;ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_VendeItem(ICASH_Codigo: String; ICASH_Descricao: String; ICASH_Quantidade: String;ICASH_Unidade: String;ICASH_Preco: String;ICASH_Decimal: String;ICASH_Situacao: String;ICASH_Estado: String;ICASH_Numero: String;ICASH_ReQuantidade: String;ICASH_TotalItem: String;ICASH_TotalCupom: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_LeEstado( ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_EncerraCupom( ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_EncerraCupom_NF( ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_CancelaUltimoItem( ICASH_Estado: String;ICASH_Numero: String;ICASH_Quantidade: String;ICASH_TotalItem: String;ICASH_TotalCupom: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_ImprimeCupomAdicional( ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_CancelaCupomAtual( ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_CancelaCupomAnterior( ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_LeTotalCupom( ICASH_Estado: String;ICASH_Total: String;ICASH_Troco: String;ICASH_Pago: String;ICASH_Faltante: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_AbreCupom_NF( ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_CancelaCupomAtual_NF( ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_CancelaCupomAnterior_NF( ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_FechaCupom_NF_Vinculado ( ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_AbreGaveta( ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_ImprimeCreditoDebito_2aVia( ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_ReimprimeCreditoDebito_1aVia( ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_ReimprimeCreditoDebito_2aVia( ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_ReimprimeEstornoCreditoDebito_1aVia( ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_ImprimeEstornoCreditoDebito_2aVia( ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_ReimprimeEstornoCreditoDebito_2aVia( ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_FechaRelatorioGerencial( ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_LeLeituraX( ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_LeMemoriaFiscal( ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_LeSoftwareBasico( ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_LeMemoriaFiscalPlanilha( ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_HorarioVerao( ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_MemoriaFiscalData (ICASH_Inicial: String; ICASH_Final: String; ICASH_Formato: String;ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_MemoriaFiscalNumero (ICASH_Inicial: String; ICASH_Final: String; ICASH_Formato: String;ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_CancelaQualquerItem (ICASH_Numero: String;ICASH_Estado: String;ICASH_ReNumero: String;ICASH_Quantidade: String;ICASH_TotalItem: String;ICASH_TotalCupom: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_ImprimeCupom_NF_NaoVinculado ( ICASH_Totalizador: String; ICASH_Finalizadora : String; ICASH_Valor : String; ICASH_Atributo : String; ICASH_Mensagem_1: String; ICASH_Mensagem_2: String; ICASH_Mensagem_3: String; ICASH_Mensagem_4: String;ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_DescontoAcrescimoSubtotal (ICASH_Tipo: String;ICASH_Percentual: String;ICASH_Valor: String;ICASH_Estado: String;ICASH_Sinal: String;ICASH_RePercentual: String;ICASH_Aliquotas: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_ImprimeCupom_NF_Vinculado (ICASH_Atributo: Char; ICASH_Mensagem: String;ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_AbreCreditoDebito(ICASH_Finalizadora: String; ICASH_Parcelas: String; ICASH_Valor: String; ICASH_Sequencial: String;ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_AbreRelatorioGerencial (ICASH_Numero: String;ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_ImprimeRelatorioGerencial (ICASH_Atributo: Char; ICASH_Mensagem: String;ICASH_Estado: String): Integer; StdCall; External 'ICASH.DLL';
  function ICASH_DescontoAcrescimoItem (ICASH_Tipo: String;ICASH_Percentual: String;ICASH_Valor: String;ICASH_Numero: String;ICASH_Estado: String;ICASH_ReNumero: String;ICASH_Quantidade: String;ICASH_TotalItem: String;ICASH_TotalCupom: String): Integer; StdCall; External 'ICASH.DLL';
  //
  function _ecf11_CodeErro(pP1: Integer; pP2: String):Integer;
  function _ecf11_Inicializa(Pp1: String):Boolean;
  function _ecf11_FechaCupom(Pp1: Boolean):Boolean;
  function _ecf11_Pagamento(Pp1: Boolean):Boolean;
  function _ecf11_CancelaUltimoItem(Pp1: Boolean):Boolean;
  function _ecf11_SubTotal(Pp1: Boolean):Real;
  function _ecf11_AbreGaveta(Pp1: Boolean):Boolean;
  function _ecf11_Sangria(Pp1: Real):Boolean;
  function _ecf11_Suprimento(Pp1: Real):Boolean;
  function _ecf11_NovaAliquota(Pp1: String):Boolean;
  function _ecf11_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
  function _ecf11_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
  function _ecf11_CancelaUltimoCupom(Pp1: Boolean):Boolean;
  function _ecf11_AbreNovoCupom(Pp1: Boolean):Boolean;
  function _ecf11_NumeroDoCupom(Pp1: Boolean):String;
  function _ecf11_CancelaItemN(pP1, pP2: String):Boolean;
  function _ecf11_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
  function _ecf11_ReducaoZ(pP1: Boolean):Boolean;
  function _ecf11_LeituraX(pP1: Boolean):Boolean;
  function _ecf11_RetornaVerao(pP1: Boolean):Boolean;
  function _ecf11_LigaDesLigaVerao(pP1: Boolean):Boolean;
  function _ecf11_VersodoFirmware(pP1: Boolean): String;
  function _ecf11_NmerodeSrie(pP1: Boolean): String;
  function _ecf11_CGCIE(pP1: Boolean): String;
  function _ecf11_Cancelamentos(pP1: Boolean): String;
  function _ecf11_Descontos(pP1: Boolean): String;
  function _ecf11_ContadorSeqencial(pP1: Boolean): String;
  function _ecf11_Nmdeoperaesnofiscais(pP1: Boolean): String;
  function _ecf11_NmdeCuponscancelados(pP1: Boolean): String;
  function _ecf11_NmdeRedues(pP1: Boolean): String;
  function _ecf11_Nmdeintervenestcnicas(pP1: Boolean): String;
  function _ecf11_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
  function _ecf11_Clichdoproprietrio(pP1: Boolean): String;
  function _ecf11_NmdoCaixa(pP1: Boolean): String;
  function _ecf11_Nmdaloja(pP1: Boolean): String;
  function _ecf11_Moeda(pP1: Boolean): String;
  function _ecf11_Dataehoradaimpressora(pP1: Boolean): String;
  function _ecf11_Datadaultimareduo(pP1: Boolean): String;
  function _ecf11_Datadomovimento(pP1: Boolean): String;
  function _ecf11_Tipodaimpressora(pP1: Boolean): String;
  function _ecf11_StatusGaveta(Pp1: Boolean):String;
  function _ecf11_RetornaAliquotas(pP1: Boolean): String;
  function _ecf11_Vincula(pP1: String): Boolean;
  function _ecf11_FlagsDeISS(pP1: Boolean): String;
  function _ecf11_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
  function _ecf11_MudaMoeda(pP1: String): Boolean;
  function _ecf11_MostraDisplay(pP1: String): Boolean;
  function _ecf11_leituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
  function _ecf11_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean;
  function _ecf11_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
  function _ecf11_FechaCupom2(sP1: Boolean): Boolean;
  function _ecf11_ImprimeCheque(rP1: Real; sP2: String): Boolean;
  function _ecf11_GrandeTotal(sP1: Boolean): String;
  function _ecf11_TotalizadoresDasAliquotas(sP1: Boolean): String;
  function _ecf11_CupomAberto(sP1: Boolean): boolean;
  function _ecf11_FaltaPagamento(sP1: Boolean): boolean;
var
  sPrazo,
  sDinheiro,
  sCheque,
  sCartao,
  sExtra1,
  sExtra2,
  sExtra3,
  sExtra4,
  sExtra5,
  sExtra6,
  sExtra7,
  sExtra8  : String;


  iRetorno: Integer;
  Estado : String;
  ret1 : String;
  ret2 : String;
  ret3 : String;
  ret4 : String;
  ret5 : String;

implementation

// ---------------------------------- //
// Tratamento de erros da INTERPROM   //
// ---------------------------------- //
function _ecf11_CodeErro(pP1: Integer; pP2: String):Integer;
var
  vErro    : array [0..130] of String;  // Cria uma matriz com 50 elementos
begin
  //
  for Result := 1 to 130 do vErro[Result] := 'Erro desconhecido, número: '+IntToStr(Result);
  //
  vErro[035] := 'Tamanho do comando inválido';
  vErro[036] := 'Comando inválido';
  vErro[037] := 'Comando deve ser executado após zerar toda a memória';
  vErro[038] := 'Não é redução “Z”';
  vErro[039] := 'Erro de cupom aberto';
  vErro[040] := 'Dados numéricos inválidos';
  vErro[041] := 'Data e/ ou hora invalida';
  vErro[042] := 'Comando já executado ou proibido';
  vErro[043] := 'Erro de texto inválido';
  vErro[044] := 'Erro de seqüência de operação';
  vErro[045] := 'Erro de parâmetro inválido';
  vErro[047] := 'Necessita programação prévia';
  vErro[064] := 'Jumper de intervenção na posição errada';
  vErro[067] := 'Redução Z do dia já realizada';
  vErro[079] := 'Erro não definido';
  vErro[112] := 'Erro na abertura da porta serial';
  vErro[113] := 'Erro na configuração da porta serial';
  vErro[114] := 'Erro no fechamento da porta serial';
  vErro[115] := 'Erro na passagem de parâmetros';
  vErro[116] := 'Erro no comando ou parâmetro para esta biblioteca';
  vErro[117] := 'Erro por estouro de tempo na espera de resposta da impressora';
  vErro[118] := 'Erro de escrita na porta serial';
  vErro[119] := 'Erro de leitura na porta serial';
  vErro[120] := 'Erro de comunicação com impressora fiscal';
  vErro[121] := 'Erro de checksum na mensagem recebida';
  vErro[048] := 'Em período de vendas';
  vErro[049] := 'Cupom fiscal aberto (Cabeçalho Impresso)';
  vErro[050] := 'Cupom fiscal em posição de efetuar venda';
  vErro[051] := 'Cupom fiscal totalizando venda';
  vErro[052] := 'Cupom fiscal finalizando a totalização (Formas de pagamento)';
  vErro[053] := 'Cupom fiscal com dados de cliente impressos';
  vErro[054] := 'Cupom não fiscal aberto';
  vErro[055] := 'Cupom não fiscal em posição de efetuar venda';
  vErro[056] := 'Cupom não fiscal totalizando venda';
  vErro[057] := 'Cupom não fiscal finalizando a totalização';
  vErro[065] := 'Cupom não fiscal com dados de cliente impressos';
  vErro[066] := 'Emitindo Relatório Gerencial';
  vErro[067] := 'Em Intervenção Técnica';
  vErro[068] := 'Dia já encerrado';
  vErro[069] := 'Obrigatório fechar dia';
  vErro[070] := 'Comprovante de Crédito/ Débito Aberto';
  vErro[071] := 'Comprovante de Estorno de Crédito/ Débito Aberto';
  vErro[072] := 'Fora de período de vendas';
  //
  if pP1 <> 0 then
  begin
    ShowMessage(vErro[pP1]);
    Result := pP1;
  end else
  begin
    Result := 0;
  end;
  //
end;


// ----------------------------//
// Detecta qual a porta que    //
// a impressora está conectada //
// INTERPROM                   //
// --------------------------- //
function _ecf11_Inicializa(Pp1: String):Boolean;
var
  I : Integer;
  iRetorno: Integer;
  Estado : String;
begin
  //
  Estado        := Replicate(' ',5);
  Form1.sPorta  := UpperCase(pP1);
  //
  ICASH_Abre(pChar(UpperCase(pP1)));
  iRetorno := ICASH_LeEstado(Estado);
  //
  for I := 1 to 7 do
  begin
    //
    if iRetorno <> 0 then
    begin
      //
      Result := False;
      ShowMessage('Interprom'+Chr(10)+'Testando COM'+StrZero(I,1,0));
      //
      ICASH_Fecha();
      ICASH_Abre(pchar('COM'+StrZero(I,1,0)));
      iRetorno := ICASH_LeEstado(Estado);
      Form1.sPorta  := 'COM'+StrZero(I,1,0);
      //
      if iRetorno = 0 then Form1.sPorta  := 'COM'+StrZero(I,1,0);
      //
    end else Result := True;
    //
  end;
  //
end;


// ------------------------------ //
// Fecha o cupom que está sendo   //
// emitido                        //
// INTERPROM                      //
// ------------------------------ //
function _ecf11_FechaCupom(Pp1: Boolean):Boolean;
begin
  //
  Estado := '     ';
  ret1:='                         ';
  ret2:='                         ';
  ret3:='                         ';
  //
  if Form1.fTotal <> 0 then
  begin
    //
    if Form1.fTotal >= Form1.ibDataSet25RECEBER.AsFloat then
    begin
      // Desconto
      iRetorno := ICASH_DescontoAcrescimoSubtotal('2','0000',
      pchar(StrZero((Form1.fTotal-Form1.ibDataSet25RECEBER.AsFloat)*100,12,0))
      ,Estado,ret1,ret2,ret3); // Desconto
    end else
    begin
      iRetorno := ICASH_DescontoAcrescimoSubtotal('4','0000',
      pchar(StrZero((Form1.ibDataSet25RECEBER.AsFloat-Form1.fTotal)*100,12,0))
      ,Estado,ret1,ret2,ret3); // Acrescimo
    end;
    //
    // _ecf11_codeErro(iRetorno,Estado);
    //
  end else _ecf11_CancelaUltimoCupom(True);// cupom em branco cancela;
  //
  Result := True;
  //
end;

// ------------------------------ //
// Fecha o cupom que está sendo   //
// emitido                        //
// INTERPROM                          //
// ------------------------------ //
function _ecf11_Pagamento(Pp1: Boolean):Boolean;
var
  Mais1ini : TiniFile;
  s: array [0..100]  of String;  // Cria uma matriz com 4 elementos
  J, I, Z : Integer;
begin
  //
  Mais1ini  := TIniFile.Create('frente.ini');
  //
  sDinheiro := StrZero(Mais1Ini.ReadInteger('Frente de caixa','Dinheiro', 1),2,0);
  sCheque   := StrZero(Mais1Ini.ReadInteger('Frente de caixa','Cheque'  , 2),2,0);
  sCartao   := StrZero(Mais1Ini.ReadInteger('Frente de caixa','Cartao'  , 3),2,0);
  sPrazo    := StrZero(Mais1Ini.ReadInteger('Frente de caixa','Prazo' , 4),2,0);
  //
  sExtra1   := StrZero(Mais1Ini.ReadInteger('Frente de caixa','Ordem forma extra 1', 5),2,0);
  sExtra2   := StrZero(Mais1Ini.ReadInteger('Frente de caixa','Ordem forma extra 2', 6),2,0);
  sExtra3   := StrZero(Mais1Ini.ReadInteger('Frente de caixa','Ordem forma extra 3', 7),2,0);
  sExtra4   := StrZero(Mais1Ini.ReadInteger('Frente de caixa','Ordem forma extra 4', 8),2,0);
  sExtra5   := StrZero(Mais1Ini.ReadInteger('Frente de caixa','Ordem forma extra 5', 9),2,0);
  sExtra6   := StrZero(Mais1Ini.ReadInteger('Frente de caixa','Ordem forma extra 6',10),2,0);
  sExtra7   := StrZero(Mais1Ini.ReadInteger('Frente de caixa','Ordem forma extra 7',11),2,0);
  sExtra8   := StrZero(Mais1Ini.ReadInteger('Frente de caixa','Ordem forma extra 8',12),2,0);
  //
  Estado := ' ';
  // ------------------ //
  // Forma de pagamento //
  // ------------------ //
//  ShowMessage(
//      'Em cheque...: '+StrZero(Form1.ibDataSet25ACUMULADO1.AsFloat*100,14,0)+ Chr(10) +
//      'Em dinheiro.: '+StrZero(Form1.ibDataSet25ACUMULADO2.AsFloat*100,14,0)+ Chr(10) +
//      'Receber.....: '+StrZero(Form1.ibDataSet25RECEBER.AsFloat*100,14,0)+ Chr(10)+
//      'Total.......: '+StrZero(Form1.fTotal*100,14,0)+ Chr(10));
  //
  if Form1.ibDataSet25ACUMULADO1.AsFloat <> 0 then ICASH_TotalizaCupom(sCheque   , StrZero(Form1.ibDataSet25ACUMULADO1.AsFloat * 100,13,0),Estado);  // Cheque
  if Form1.ibDataSet25ACUMULADO2.AsFloat <> 0 then ICASH_TotalizaCupom(sDinheiro , StrZero(Form1.ibDataSet25ACUMULADO2.AsFloat * 100,13,0),Estado);  // Dinheiro
  if Form1.ibDataSet25PAGAR.AsFloat      <> 0 then ICASH_TotalizaCupom(sCartao   , StrZero(Form1.ibDataSet25PAGAR.AsFloat      * 100,13,0),Estado);  // Cartão
  if Form1.ibDataSet25DIFERENCA_.Asfloat <> 0 then ICASH_TotalizaCupom(sPrazo    , StrZero(Form1.ibDataSet25DIFERENCA_.AsFloat * 100,13,0),Estado);  // Prazo
  if Form1.ibDataSet25VALOR01.AsFloat    <> 0 then ICASH_TotalizaCupom(sExtra1   , StrZero(Form1.ibDataSet25VALOR01.AsFloat    * 100,13,0),Estado);  // Forma extra 1
  if Form1.ibDataSet25VALOR02.AsFloat    <> 0 then ICASH_TotalizaCupom(sExtra2   , StrZero(Form1.ibDataSet25VALOR02.AsFloat    * 100,13,0),Estado);  // Forma extra 2
  if Form1.ibDataSet25VALOR03.AsFloat    <> 0 then ICASH_TotalizaCupom(sExtra3   , StrZero(Form1.ibDataSet25VALOR03.AsFloat    * 100,13,0),Estado);  // Forma extra 3
  if Form1.ibDataSet25VALOR04.AsFloat    <> 0 then ICASH_TotalizaCupom(sExtra4   , StrZero(Form1.ibDataSet25VALOR04.AsFloat    * 100,13,0),Estado);  // Forma extra 4
  if Form1.ibDataSet25VALOR05.AsFloat    <> 0 then ICASH_TotalizaCupom(sExtra5   , StrZero(Form1.ibDataSet25VALOR05.AsFloat    * 100,13,0),Estado);  // Forma extra 5
  if Form1.ibDataSet25VALOR06.AsFloat    <> 0 then ICASH_TotalizaCupom(sExtra6   , StrZero(Form1.ibDataSet25VALOR06.AsFloat    * 100,13,0),Estado);  // Forma extra 6
  if Form1.ibDataSet25VALOR07.AsFloat    <> 0 then ICASH_TotalizaCupom(sExtra7   , StrZero(Form1.ibDataSet25VALOR07.AsFloat    * 100,13,0),Estado);  // Forma extra 7
  if Form1.ibDataSet25VALOR08.AsFloat    <> 0 then ICASH_TotalizaCupom(sExtra8   , StrZero(Form1.ibDataSet25VALOR08.AsFloat    * 100,13,0),Estado);  // Forma extra 8
  //
  Form1.sMensagemPromocional := Form1.sMensagemPromocional + chr(10);
  //
  J := 0;
  Z := 0;
  s[1] := ' '; s[2] := ' '; s[3] := ' '; s[4] := ' ';
  //
  for I := 1 to Length(Form1.sMensagemPromocional) do
  begin
    J := J + 1;
    if Copy(Form1.sMensagemPromocional,I,1) = Chr(10) then
    begin
      Z := Z + 1;
      s[Z] := Copy(Form1.sMensagemPromocional,I-J+1,J-1);
//      ShowMessage( Copy(Form1.sMensagemPromocional,I-J+1,J-1) );
      J := 0;
    end;
  end;
  //
  Estado := ' ';
  iRetorno:= ICASH_PromoveCupom ('0000',s[1],s[2],s[3],s[4],Estado);
  Estado := ' ';
  iRetorno:= ICASH_EncerraCupom(Estado);
//  _ecf11_codeErro(iRetorno,Estado);
  //
  Result := True;
  //
end;


// ------------------------------ //
// INTERPROM                      //
// cancela o último item do cupom //
// ------------------------------ //
function _ecf11_CancelaUltimoItem(Pp1: Boolean):Boolean;
begin
  Estado := '     ';
  ret1:='                         ';
  ret2:='                         ';
  ret3:='                         ';
  ret4:='                         ';
  iRetorno:= ICASH_CancelaUltimoItem(Estado,ret1,ret2,ret3,ret4);
//  _ecf11_codeErro(iRetorno,Estado);
//  ShowMessage(IntToStr(iRetorno));
  Result := True;
//  if iRetorno = 0 then Result := True else Result := False;
end;

// -------------------------------//
// INTERPROM                      //
// Cancela o último cupom emitido //
// -------------------------------//
function _ecf11_CancelaUltimoCupom(Pp1: Boolean):Boolean;
begin
  Estado := ' ';
//  iRetorno:= ICASH_CancelaCupomAtual(Estado);
  iRetorno:= ICASH_CancelaCupomAnterior(Estado);
  _ecf11_codeErro(iRetorno,Estado);
  ICASH_CancelaCupomAtual(Estado);
  if iRetorno = 0 then Result := True else Result := False;
end;

// -------------------------------//
// INTERPROM                          //
// Subtotal                       //
// -------------------------------//
function _ecf11_SubTotal(Pp1: Boolean):Real;
begin
  ret1 := '                          ';
  ret2 := '                          ';
  ret3 := '                          ';
  ret4 := '                          ';
  Estado := ' ';
  iRetorno:= ICASH_LeTotalCupom(Estado,ret1,ret2,ret3,ret4);
  Result := StrToFloat('0'+AllTrim(Ret1))/100;
  // --------------------- //
  //  Retorno do Subtotal  //
  // --------------------- //
end;

// ------------------------------ //
// Abre um novo cupom fiscal      //
// INTERPROM                          //
// ------------------------------ //
function _ecf11_AbreNovoCupom(Pp1: Boolean):Boolean;
begin
  Estado:= ' ';
  iRetorno := ICASH_AbreCupom(Estado);
//  _ecf11_codeErro(iRetorno,Estado);
  if Copy(Estado,1,1) = 'E' then
  begin
    Result := False;
    _ecf11_codeErro(iRetorno,Estado);
  end else Result := True;
end;

// -------------------------------- //
// Retorna o número do Cupom        //
// INTERPROM                            //
// -------------------------------- //
function _ecf11_NumeroDoCupom(Pp1: Boolean):String;
begin
{  //
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',6);
  Ret2   := Replicate(' ',1);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  iRetorno := ICASH_LeDadosFiscais ('04',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  _ecf11_codeErro(iRetorno,Estado);
  Result := Copy(Ret1,1,6);
  //
  }
  //
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',6);
  Ret2   := Replicate(' ',6);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  iRetorno := ICASH_LeDadosFiscais ('02',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  _ecf11_codeErro(iRetorno,Estado);
  Result := Copy(Ret2,1,6);
  //
end;

// ------------------------------ //
// Cancela um item N              //
// INTERPROM                          //
// ------------------------------ //
function _ecf11_CancelaItemN(pP1, pP2 : String):Boolean;
begin
  //
  Estado := '     ';
  ret1:='   ';
  ret2:='       ';
  ret3:='            ';
  ret4:='              ';
  iRetorno := ICASH_CancelaQualquerItem(StrZero(StrtoInt(pP1),3,0),Estado,ret1,ret2,ret3,ret4);
  _ecf11_codeErro(iRetorno,Estado);
  if iRetorno = 0 then Result := True else Result := False;
  // ------------------------------------------------------------------ //
  // A variável iCancelaItenN deve ser incrementada quando a impressora //
  // considera não considera que o item já foi cancelado isso evita um  //
  // problema de cancelar um item na tela e no arquivo e na impressora  //
  // cancelar outro.                                                    //
  // ------------------------------------------------------------------ //
end;

// -------------------------------- //
// Abre a gaveta                    //
// INTERPROM                            //
// -------------------------------- //
function _ecf11_AbreGaveta(Pp1: Boolean):Boolean;
begin
  Estado := ' ';
  iRetorno:= ICASH_AbreGaveta(Estado);
  _ecf11_codeErro(iRetorno,Estado);
  Result := True;
end;

// -------------------------------- //
// Status da gaveta                 //
// INTERPROM                        //
//                                  //
// 000 Gaveta Fechada.              //
// 255 Gaveta Aberta.               //
// 128 Valor atribuido quando não   //
//     tem gaveta.                  //
// -------------------------------- //
function _ecf11_StatusGaveta(Pp1: Boolean):String;
begin
  //
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',10);
  Ret2   := Replicate(' ',1);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  ICASH_LeDadosFiscais ('82',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  //
  if Form1.iStatusGaveta = 0 then
  begin
    if Copy(Ret1,1,1) = '1' then Result := '255' else Result := '000';
  end else
  begin
    if Copy(Ret1,1,1) = '1' then Result := '000' else Result := '000';
  end;
  //
  //  Retorno := Replicate(' ',1000);
  //  TransStatusDecoD(Retorno); // Função não documentada
  //  if Copy(Retorno,28,1) = '1' then Result := '255' else Result := '000' ;
  //
end;

// -------------------------------- //
// SAngria                          //
// INTERPROM                            //
// -------------------------------- //
function _ecf11_Sangria(Pp1: Real):Boolean;
begin
  Estado := '                   ';
  iRetorno:= ICASH_ImprimeCupom_NF_NaoVinculado('2','1',AllTrim(StrTran(StrTran(Format('%13.2f',[pP1]),'.',''),',','')),'3000','SANGRIA',' ',' ',' ',Estado);
  _ecf11_codeErro(iRetorno,Estado);
  Result := True;
end;

// -------------------------------- //
// Suprimento                       //
// INTERPROM                            //
// -------------------------------- //
function _ecf11_Suprimento(Pp1: Real):Boolean;
begin
  Estado := '                   ';
  iRetorno:= ICASH_ImprimeCupom_NF_NaoVinculado('1','1',AllTrim(StrTran(StrTran(Format('%13.2f',[pP1]),'.',''),',','')),'3000','SUPRIMENTO',' ',' ',' ',Estado);
  _ecf11_codeErro(iRetorno,Estado);
  Result := True;
end;

// -------------------------------- //
// Nova Aliquota                    //
// INTERPROM                            //
// -------------------------------- //
function _ecf11_NovaAliquota(Pp1: String):Boolean;
begin
  // Este comando só pode ser feito mediante uma intervenção técnica //
  ShowMessage('Este comando só poderá ser executado mediante uma'
  + chr(10) + 'intervenção técnica.'
  + chr(10)
  + chr(10) + 'Se realmente for necessário cadastrar uma nova aliquota,'
  + chr(10) + 'Chame um técnico habilitado.');
  Result := True;
end;

function _ecf11_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
begin
  ShowMessage('Função não suportada pelo modelo de ECF utilizado.');
  Result := True;
end;

function _ecf11_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
begin
  Estado := ' ';
  if Length(pP1) = 6 then
  begin
//  ShowMessage(pChar(Copy(pP1,1,4)+'20'+Copy(pP1,5,2))+Chr(10)+pChar(Copy(pP2,1,4)+'20'+Copy(pP2,5,2)));
//  iRetorno:= ICASH_MemoriaFiscalData('04112005','14112005','1',Estado);
    iRetorno:= ICASH_MemoriaFiscalData(pChar(Copy(pP1,1,4)+'20'+Copy(pP1,5,2)),pChar(Copy(pP2,1,4)+'20'+Copy(pP2,5,2)),'1',Estado);
    _ecf11_codeErro(iRetorno,Estado);
  end else
  begin
    iRetorno:= ICASH_MemoriaFiscalNumero(pP1,pP2,'1',Estado);
    _ecf11_codeErro(iRetorno,Estado);
  end;
  Result := True;
end;


// -------------------------------- //
// Venda do Item                    //
// INTERPROM                            //
// -------------------------------- //
function _ecf11_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
var
  sTipo : String;
begin
  // ---------------------------- //
  // pP1 -> Código     13 dígitos //
  // pP2 -> Descricão  29 dígitos //
  // pP3 -> ST          2 dígitos //
  // pP4 -> Quantidade  7 dígitos //
  // pP5 -> Unitário    7 dígitos //
  // pP6 -> Medida      2 dígitos //
  // ---------------------------- //
  pP1    := pChar(pP1+Modulo_10(pP1));
  pP2    := Copy(pP2,1,28);
  pP6    := pp6+' ';
  Estado := ' ';
  //
  Ret1:= '             ';Ret2:= '             '; Ret3:= '             ';Ret4:= '             ';
  //
  // ShowMessage('T'+Copy(pP3,1,2)+','+Copy(pP3,3,2));
  //
//  if LimpaNumero(pP3) <> '' then pP3 := 'T'+Copy(pP3,1,2)+','+Copy(pP3,3,2)+'%';
  //
  if (Copy(pP3,1,1) <> 'I') and (Copy(pP3,1,1) <> 'F') and (Copy(pP3,1,1) <> 'N') then
  begin

// ShowMessage(Form1.sAliquotas+chr(10)+pP3);

    pP3 := Copy(Form1.sAliquotas,(StrtoInt(Copy(pP3,1,2))*4)-1,4);
    if LimpaNumero(pP3) <> '' then pP3 := 'T'+Copy(LimpaNumero(pP3),1,2)+',00%';
  end;
  //
//  pP3 := 'T18,00%';
  if Copy(pP3,1,1) = 'I' then pP3 := 'I1';     // 38 isenção
  if Copy(pP3,1,1) = 'F' then pP3 := 'F1';     // 40 não incidência
  if Copy(pP3,1,1) = 'N' then pP3 := 'NS1';    // 42 Substituição
  //
  // Venda do item
  //
//  ShowMessage(pP3);
  //
  iRetorno:= ICASH_VendeItem(pP1,pP2,pP4,pP6,pP5,'2',pP3,Estado,Ret1,Ret2,Ret3,Ret4);
  _ecf11_codeErro(iRetorno,Estado);
  //
  // Desconto ou acrescimo na venda do item
  //
  if (StrToInt(pP7) <> 0) or (StrToInt(pP8) <> 0) then
  begin
    //
    if StrToInt(pP7) <> 0 then sTipo := '1' else sTipo := '2';
    //
    Estado := '     ';
    ret1   := '                         ';
    ret2   := '                         ';
    ret3   := '                         ';
    ret4   := '                         ';
    //
//    iRetorno:= ICASH_DescontoAcrescimoItem(sTipo,pP7,pP8, Strzero(Form1.iItem,3,0) ,Estado,ret1,ret2,ret3,ret4);
    iRetorno:= ICASH_DescontoAcrescimoItem(sTipo,Copy(pP7,4,4),'00000'+pP8, Strzero(Form1.iItem,3,0) ,Estado,ret1,ret2,ret3,ret4);
    _ecf11_codeErro(iRetorno,Estado);
    //
  end;
  //
  REsult := True;
  //
end;

// -------------------------------- //
// Reducao Z                        //
// INTERPROM                        //
// -------------------------------- //
function _ecf11_ReducaoZ(pP1: Boolean):Boolean;
begin
  Estado := ' ';
  ICASH_ReducaoZ(Estado);
  iRetorno := _ecf11_codeErro(iRetorno,Estado);
  Result := True;
end;

// -------------------------------- //
// Leitura X                        //
// INTERPROM                            //
// -------------------------------- //
function _ecf11_LeituraX(pP1: Boolean):Boolean;
begin
  Estado := ' ';
  iRetorno := ICASH_LeituraX(Estado);
   _ecf11_codeErro(iRetorno,Estado);
  Result := True;
end;

// ---------------------------------------------- //
// Retorna se o horario de verão está selecionado //
// INTERPROM                                          //
// ---------------------------------------------- //
function _ecf11_RetornaVerao(pP1: Boolean):Boolean;
begin
  //
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',10);
  Ret2   := Replicate(' ',1);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  ICASH_LeDadosFiscais ('82',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  if Copy(Ret1,3,1) = '1' then Result := True else Result := False;
  //
end;

// -------------------------------- //
// Liga ou desliga horário de verao //
// INTERPROM                            //
// -------------------------------- //
function _ecf11_LigaDesLigaVerao(pP1: Boolean):Boolean;
begin
  Estado := ' ';
  _ecf11_CodeErro(ICASH_HorarioVerao(Estado),'');
  Result := True;
end;

// -------------------------------- //
// Retorna a versão do firmware     //
// INTERPROM                            //
// -------------------------------- //
function _ecf11_VersodoFirmware(pP1: Boolean): String;
begin
  //
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',6);
  Ret2   := Replicate(' ',1);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  Result := '';
  iRetorno := ICASH_LeDadosFiscais ('89',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
   _ecf11_codeErro(iRetorno,Estado);
  Result := Ret1;
  //
end;

// -------------------------------- //
// Retorna o número de série        //
// INTERPROM                            //
// -------------------------------- //
function _ecf11_NmerodeSrie(pP1: Boolean): String;
begin
  //
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',12);
  Ret2   := Replicate(' ',1);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  iRetorno := ICASH_LeDadosFiscais ('91',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
   _ecf11_codeErro(iRetorno,Estado);
  Result := Ret1;
  //
end;

// -------------------------------- //
// Retorna o CGC e IE               //
// INTERPROM                            //
// -------------------------------- //
function _ecf11_CGCIE(pP1: Boolean): String;
begin
  //
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',18);
  Ret2   := Replicate(' ',1);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  Result := '';
  ICASH_LeDadosFiscais ('94',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  Result := Result + Copy(Ret1,1,18) + chr(10);
  iRetorno := ICASH_LeDadosFiscais ('95',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  Result := Result + Copy(Ret1,1,18) + chr(10);
  _ecf11_codeErro(iRetorno,Estado);
  //
end;

// --------------------------------- //
// Retorna o número de cancelamentos //
// INTERPROM                             //
// --------------------------------- //
function _ecf11_Cancelamentos(pP1: Boolean): String;
begin
  //
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',13);
  Ret2   := Replicate(' ',1);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  Result := '';
  iRetorno := ICASH_LeDadosFiscais ('11',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  Result := Ret1;
  _ecf11_codeErro(iRetorno,Estado);
  //
end;


// -------------------------------- //
// Retorna o valor de descontos     //
// INTERPROM                            //
// -------------------------------- //
function _ecf11_Descontos(pP1: Boolean): String;
begin
  //
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',13);
  Ret2   := Replicate(' ',1);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  Result := '';
  iRetorno := ICASH_LeDadosFiscais ('12',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  Result := Ret1;
  _ecf11_codeErro(iRetorno,Estado);
  //
end;

// -------------------------------- //
// Retorna o contados sequencial    //
// INTERPROM                            //
// -------------------------------- //
function _ecf11_ContadorSeqencial(pP1: Boolean): String;
begin
  //
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',6);
  Ret2   := Replicate(' ',1);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  iRetorno := ICASH_LeDadosFiscais ('04',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  _ecf11_codeErro(iRetorno,Estado);
  Result := Copy(Ret1,1,6);
  //
end;

// -------------------------------- //
// Retorna o número de operações    //
// não fiscais acumuladas           //
// INTERPROM                            //
// -------------------------------- //
function _ecf11_Nmdeoperaesnofiscais(pP1: Boolean): String;
begin
  //
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',6);
  Ret2   := Replicate(' ',1);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  iRetorno := ICASH_LeDadosFiscais ('03',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  _ecf11_codeErro(iRetorno,Estado);
  Result := Copy(Ret1,1,6);
  //
end;

function _ecf11_NmdeCuponscancelados(pP1: Boolean): String;
begin
  //
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',4);
  Ret2   := Replicate(' ',1);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  iRetorno := ICASH_LeDadosFiscais ('07',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  _ecf11_codeErro(iRetorno,Estado);
  Result := Copy(Ret1,1,4);
  //
end;

function _ecf11_NmdeRedues(pP1: Boolean): String;
begin
  //
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',4);
  Ret2   := Replicate(' ',1);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  iRetorno := ICASH_LeDadosFiscais ('01',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  _ecf11_codeErro(iRetorno,Estado);
  Result := Copy(Ret1,1,4);
  //
end;

function _ecf11_Nmdeintervenestcnicas(pP1: Boolean): String;
begin
  //
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',4);
  Ret2   := Replicate(' ',1);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  iRetorno := ICASH_LeDadosFiscais ('00',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  _ecf11_codeErro(iRetorno,Estado);
  Result := Copy(Ret1,1,4);
  //
end;

function _ecf11_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
begin
  //
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',4);
  Ret2   := Replicate(' ',1);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  iRetorno := ICASH_LeDadosFiscais ('00',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  _ecf11_codeErro(iRetorno,Estado);
  Result := Copy(Ret1,1,4);
  //
end;

function _ecf11_Clichdoproprietrio(pP1: Boolean): String;
begin
  //
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',1);
  Ret2   := Replicate(' ',48);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  Result := '';
  ICASH_LeDadosFiscais ('97',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  Result := Result + Copy(Ret2,1,48) + chr(10);
  ICASH_LeDadosFiscais ('98',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  Result := Result + Copy(Ret2,1,48) + chr(10);
  ICASH_LeDadosFiscais ('99',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  Result := Result + Copy(Ret2,1,48) + chr(10);
  ICASH_LeDadosFiscais ('100',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  Result := Result + Copy(Ret2,1,48) + chr(10);
  //
end;

// ------------------------------------ //
// Importante retornar apenas 3 dígitos //
// Ex: 001                              //
// INTERPROM                    //
// ------------------------------------ //
function _ecf11_NmdoCaixa(pP1: Boolean): String;
begin
  //
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',4);
  Ret2   := Replicate(' ',1);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  iRetorno := ICASH_LeDadosFiscais ('86',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  _ecf11_codeErro(iRetorno,Estado);
  Result := StrZero(StrToInt(Copy(Ret1,1,3)),3,0);
  //
end;

function _ecf11_Nmdaloja(pP1: Boolean): String;
begin
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',4);
  Ret2   := Replicate(' ',1);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  iRetorno := ICASH_LeDadosFiscais ('85',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  _ecf11_codeErro(iRetorno,Estado);
  Result := Ret1;
  //
end;

function _ecf11_Moeda(pP1: Boolean): String;
begin
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',3);
  Ret2   := Replicate(' ',1);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  iRetorno := ICASH_LeDadosFiscais ('88',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  _ecf11_codeErro(iRetorno,Estado);
  Result := Copy(Ret1,1,1);
  //
  //  Result := StrTran(AllTrim(CurrencyString),'$','');
  //
end;

// ----------------------------------------- //
// Dia + Mês + Ano + Hora + Minuto + Segundo //
// Ex: 26091976200000                        //
// ----------------------------------------- //
function _ecf11_Dataehoradaimpressora(pP1: Boolean): String;
begin
  //
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',8);
  Ret2   := Replicate(' ',6);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  iRetorno := ICASH_LeDadosFiscais ('81',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  _ecf11_codeErro(iRetorno,Estado);
  Result := Copy(Ret1,1,4)+Copy(Ret1,7,2)+Copy(Ret2,1,6);
  //
end;

function _ecf11_Datadaultimareduo(pP1: Boolean): String;
begin
  //
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',8);
  Ret2   := Replicate(' ',1);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  iRetorno := ICASH_LeDadosFiscais ('83',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  _ecf11_codeErro(iRetorno,Estado);
  Result := Copy(Ret1,1,4)+Copy(Ret1,7,2);
  //
end;

function _ecf11_Datadomovimento(pP1: Boolean): String;
begin
  //
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',8);
  Ret2   := Replicate(' ',1);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  iRetorno := ICASH_LeDadosFiscais ('83',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  _ecf11_codeErro(iRetorno,Estado);
  Result := Copy(Ret1,1,4)+Copy(Ret1,7,2);
  //
end;

function _ecf11_Tipodaimpressora(pP1: Boolean): String;
begin
  //
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',7);
  Ret2   := Replicate(' ',1);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  iRetorno := ICASH_LeDadosFiscais('92',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  _ecf11_codeErro(iRetorno,Estado);
  Result := Ret1;
  //
end;

// Deve retornar uma String com:                                          //
// Os 2 primeiros dígitos são o número de aliquotas gravadas: Ex 16       //
// os póximos de 4 em 4 são as aliquotas Ex: 1800                         //
// Ex: 161800120005000000000000000000000000000000000000000000000000000000 //
function _ecf11_RetornaAliquotas(pP1: Boolean): String;
var
  I : Integer;
begin
  //
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',7);
  Ret2   := Replicate(' ',13);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  Result := '16';
  //
  for I := 19 to 34 do
  begin
    ICASH_LeDadosFiscais (StrZero(I,2,0),Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
//    ShowMessage(Ret1);
    Result := Result + Copy(Ret1,2,2) + Copy(Ret1,5,2);
  end;
  //
{  ICASH_LeDadosFiscais ('38',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  ShowMessage(Ret1);
  ICASH_LeDadosFiscais ('40',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  ShowMessage(Ret1);
  ICASH_LeDadosFiscais ('42',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  ShowMessage(Ret1);
} //

// ShowMessage(Result);

  Result := StrTran(Result,'*','0');
  //
end;

function _ecf11_Vincula(pP1: String): Boolean;
begin
  Result := True;
end;


function _ecf11_FlagsDeISS(pP1: Boolean): String;
begin
  // ------------------------------------------ //
  // Flags de Vinculação ao ISS                 //
  // (Cada “bit” corresponde a                  //
  // um totalizador.                            //
  // Um “bit” setado indica vinculação ao ISS)  //
  // ------------------------------------------ //
  Result := Chr(0)+chr(0);
end;

function _ecf11_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
begin
  ICASH_Fecha();
  Result := True;
end;

function _ecf11_MudaMoeda(pP1: String): Boolean;
begin
  Result := True;
end;

function _ecf11_MostraDisplay(pP1: String): Boolean;
begin
  Result := True;
end;


function _ecf11_leituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
begin
  //
  Estado := ' ';
  iRetorno:= ICASH_LeMemoriaFiscal(Estado);
  _ecf11_codeErro(iRetorno,Estado);
  CopyFile('icash.lst', pChar(pP1), True );
  Result := True;
  //
end;

function _ecf11_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean;
var
  iRetorno, J, I, iI : Integer;
begin
  //
  begin
    //
    Estado := ' ';
    iRetorno := 1;
    //
    if Form1.ibDataSet25PAGAR.AsFloat >      0 then iRetorno := ICASH_AbreCreditoDebito(sCartao ,'1' ,StrZero(Form1.ibDataSet25PAGAR.AsFloat        * 100,10,0),StrZero(iP2,6,0),Estado); // TEF
    if Form1.ibDataSet25DIFERENCA_.AsFloat > 0 then iRetorno := ICASH_AbreCreditoDebito(sPrazo  ,'1' ,StrZero(Form1.ibDataSet25DIFERENCA_.AsFloat   * 100,10,0),StrZero(iP2,6,0),Estado); // Prazo
    if Form1.ibDataSet25ACUMULADO1.AsFloat > 0 then iRetorno := ICASH_AbreCreditoDebito(sCheque ,'1' ,StrZero(Form1.ibDataSet25ACUMULADO1.AsFloat   * 100,10,0),StrZero(iP2,6,0),Estado); // Cheque
    //
    // ShowMessage('Prazo='+sPrazo+chr(10)
    //            +'Cupom='+StrZero(iP2,6,0)+chr(10)
    //            +'Valor='+StrZero(Form1.ibDataSet25DIFERENCA_.AsFloat   * 100,13,0)+chr(10)
    //            +'Estado='+Estado
    //            );
    //
    for iI := 1 to 1 do
    begin
      J := 1;
      for I := 1 to Length(sP1) do
      begin
        if iRetorno = 0 then
        begin
          if Copy(sP1,I,1) = Chr(10) then
          begin
            iRetorno := ICASH_ImprimeCupom_NF_Vinculado ('0',Copy(sP1,J,I-J),Estado);
            J := I + 1;
          end;
        end;
      end;
      //
      for I := 1 to 5 do if iRetorno = 0 then iRetorno := ICASH_ImprimeCupom_NF_Vinculado ('0',' ',Estado);
      if iRetorno = 0 then sleep(4000); // Da um tempo; // Da um tempo
      //
    end;
    //
    if iRetorno = 0 then iRetorno:= ICASH_FechaCupom_NF_Vinculado(Estado);
    if iRetorno = 0 then Result := True else Result := False;
    //
  end;
  //
end;

function _ecf11_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
var
  iRetorno, J, I, iI : Integer;
begin
  //
  begin
    //
    Estado   := ' ';
    iRetorno := ICASH_AbreRelatorioGerencial('1',Estado);
    for iI := 1 to 1 do
    begin
      J := 1;
      for I := 1 to Length(sP1) do
      begin
        if iRetorno = 0 then
        begin
          if Copy(sP1,I,1) = Chr(10) then
          begin
            iRetorno := ICASH_ImprimeRelatorioGerencial('0',Copy(sP1,J,I-J),Estado);
            J := I + 1;
          end;
        end;
      end;
      //
      for I := 1 to 5 do if iRetorno = 0 then iRetorno := ICASH_ImprimeRelatorioGerencial('0',' ',Estado);
      if iRetorno = 0 then sleep(4000); // Da um tempo; // Da um tempo
      //
    end;
    //
    if iRetorno = 0 then iRetorno:= ICASH_FechaRelatorioGerencial(Estado);
    if iRetorno = 0 then Result := True else Result := False;
    //
  end;
  //
end;

function _ecf11_FechaCupom2(sP1: Boolean): Boolean;
begin
  Estado := ' ';
  iRetorno:= ICASH_EncerraCupom(Estado);
//  if iRetorno = 0 then Result := True else Result := False;
  Result := True;
end;

function _ecf11_ImprimeCheque(rP1: Real; sP2: String): Boolean;
begin
  Result := False;
end;

function _ecf11_GrandeTotal(sP1: Boolean): String;
begin
  //
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',18);
  Ret2   := Replicate(' ',1);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  iRetorno := ICASH_LeDadosFiscais('009',Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
  _ecf11_codeErro(iRetorno,Estado);
  Result := Ret1;
  //
end;

function _ecf11_TotalizadoresDasAliquotas(sP1: Boolean): String;
var
  I : Integer;
begin
  //
  Estado := Replicate(' ',1);
  Ret1   := Replicate(' ',7);
  Ret2   := Replicate(' ',13);
  Ret3   := Replicate(' ',1);
  Ret4   := Replicate(' ',1);
  Ret5   := Replicate(' ',1);
  //
  Result := '';
  //
  for I := 19 to 34 do
  begin
    ICASH_LeDadosFiscais (StrZero(I,2,0),Estado,Ret1,Ret2,Ret3,Ret4,Ret5);
//    Result := Result + StrZero(StrToInt('0'+LimpaNumero(Ret2)),14,0);
    Result := Result + ' ' + Ret2;
  end;
  //
  ICASH_LeDadosFiscais('38',Estado,Ret1,Ret2,Ret3,Ret4,Ret5); // Isenção
  Result := Result + ' ' + Ret2;
  ICASH_LeDadosFiscais('40',Estado,Ret1,Ret2,Ret3,Ret4,Ret5); // Não Incidência
  Result := Result + ' ' + Ret2;
  ICASH_LeDadosFiscais('42',Estado,Ret1,Ret2,Ret3,Ret4,Ret5); // Substituição
  Result := Result + ' ' + Ret2;
  ICASH_LeDadosFiscais('35',Estado,Ret1,Ret2,Ret3,Ret4,Ret5); // Isenção
  Result := Result + ' ' + Ret2;
  //
  Result := StrTran(Result,'*','0');
  //
end;

function _ecf11_CupomAberto(sP1: Boolean): boolean;
begin
  Estado := ' ';
  iRetorno:= ICASH_LeEstado(Estado);
  if (Estado >= '2') and (Estado <> 'E') then Result := True else Result := False;
end;

function _ecf11_FaltaPagamento(sP1: Boolean): boolean;
begin
  //
  Estado := ' ';
  iRetorno:= ICASH_LeEstado(Estado);
  if (Estado >= '3') and (Estado <> 'E') then Result := True else Result := False;
  //
end;

end.






