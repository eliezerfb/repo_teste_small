{
Alterações
Sandro Silva 2016-02-04
- Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
}
unit _Small_12;

interface

uses

  Windows, Messages, SmallFunc, Fiscal, SysUtils,Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Variants, ExtCtrls, Mask, Grids, DBGrids, DB//, DBTables
  , DBCtrls, SMALL_DBEdit, IniFiles, Unit2, Unit22, Unit7, MD5;

  // ------------------------------- //
  // Alterado 03/01/2006 - RONEI     //
  // ------------------------------- //

  /////////////////////////////////////
  // URANO LOGGER                    //
  // Suporte: trends                 //
  // Fone: (01454)32181736 Suporte   //
  // Fone: (01454)32181700 comercial //
  // Simone area comercial           //
  // Valmor Mayer                    //
  // Fone: (01447)9989910            //
  // ----------- ------------------- //
  // TRENDS (01454)32181736 Fabricio //
  // ZPM    (01451)33955713 Vadoski  //
  /////////////////////////////////////
  //                                 //
  // URANO  (01451)34628707          //
  //                                 //
  /////////////////////////////////////

  function  DLLG2_DefineTimeout( MHandle:integer; TempoMaximo:integer ) :integer;  stdcall;external 'DLLG2.DLL';
  function  DLLG2_LeTimeout(Porta : Integer) : Integer; stdcall; external 'dllg2.dll';
  function  DLLG2_IniciaDriver(porta:Pchar):integer; stdcall;external 'DLLG2.DLL';
  function  DLLG2_EncerraDriver(MHandle:integer):integer; stdcall;external 'DLLG2.DLL';
  function  DLLG2_Versao(Versao : Pchar; TamVersao:integer):pchar; stdcall;external 'DLLG2.DLL';
  function  DLLG2_SetaArquivoLog(NomeArquivoLog:Pchar):integer; stdcall;external 'DLLG2.DLL';
  function  DLLG2_LimpaParams(MHandle:integer):integer; stdcall;external 'DLLG2.DLL';
  function  DLLG2_AdicionaParam(MHandle:integer;NomePar:Pchar;VlrPar:Pchar;TipoPar:integer):integer; stdcall;external 'DLLG2.DLL';
  function  DLLG2_ExecutaComando(MHandle:integer;Comando:pchar):integer; stdcall;external 'DLLG2.DLL';
  function  DLLG2_ObtemCodErro(MHandle:integer):integer;stdcall;external 'DLLG2.DLL';
  function  DLLG2_Retorno(MHandle,Indice:integer;NomeRetorno:pchar;TamNomeRetorno:integer;VlrRetorno:pchar;TamVlrRetorno:integer):integer; stdcall;external 'DLLG2.DLL';
  function  DLLG2_ObtemNomeErro(MHandle:integer;NomeErro:pchar;TamNomeErro:integer):pchar; stdcall;external 'DLLG2.DLL';
  function  DLLG2_ObtemCircunstancia(MHandle:integer;Circunstancia:pchar;TamNomeCircus:integer):pchar; stdcall;external 'DLLG2.DLL';
  //
  function _ecf12_CodeErro(pP1: Integer; pP2: String):Integer;
  function _ecf12_Inicializa(Pp1: String): Boolean;
  function _ecf12_FechaCupom(Pp1: Boolean):Boolean;
  function _ecf12_Pagamento(Pp1: Boolean):Boolean;
  function _ecf12_CancelaUltimoItem(Pp1: Boolean):Boolean;
  function _ecf12_SubTotal(Pp1: Boolean):Real;
  function _ecf12_AbreGaveta(Pp1: Boolean):Boolean;
  function _ecf12_Sangria(Pp1: Real):Boolean;
  function _ecf12_Suprimento(Pp1: Real):Boolean;
  function _ecf12_NovaAliquota(Pp1: String):Boolean;
  function _ecf12_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;

  function _ecf12_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;

  function _ecf12_CancelaUltimoCupom(Pp1: Boolean):Boolean;
  function _ecf12_AbreNovoCupom(Pp1: Boolean):Boolean;
  function _ecf12_NumeroDoCupom(Pp1: Boolean):String;
  function _ecf12_CancelaItemN(pP1, pP2: String):Boolean;
  function _ecf12_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
  function _ecf12_ReducaoZ(pP1: Boolean):Boolean;
  function _ecf12_LeituraX(pP1: Boolean):Boolean;
  function _ecf12_RetornaVerao(pP1: Boolean):Boolean;
  function _ecf12_LigaDesLigaVerao(pP1: Boolean):Boolean;
  function _ecf12_VersodoFirmware(pP1: Boolean): String;
  function _ecf12_NmerodeSrie(pP1: Boolean): String;
  function _ecf12_CGCIE(pP1: Boolean): String;
  function _ecf12_Cancelamentos(pP1: Boolean): String;
  function _ecf12_Descontos(pP1: Boolean): String;
  function _ecf12_ContadorSeqencial(pP1: Boolean): String;
  function _ecf12_Nmdeoperaesnofiscais(pP1: Boolean): String;
  function _ecf12_NmdeCuponscancelados(pP1: Boolean): String;
  function _ecf12_NmdeRedues(pP1: Boolean): String;
  function _ecf12_Nmdeintervenestcnicas(pP1: Boolean): String;
  function _ecf12_NmContadorGeraldeRelatrioGerencial(pP1: Boolean): String; // Sandro Silva 2017-10-09
  function _ecf12_NmContadordeCuponsFiscal(pP1: Boolean): String;
  function _ecf12_NmContadordeCuponsCrditoDbito(pP1: Boolean): String; // Sandro Silva 2017-10-09
  function _ecf12_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
  function _ecf12_Clichdoproprietrio(pP1: Boolean): String;
  function _ecf12_NmdoCaixa(pP1: Boolean): String;
  function _ecf12_Nmdaloja(pP1: Boolean): String;
  function _ecf12_Moeda(pP1: Boolean): String;
  function _ecf12_Dataehoradaimpressora(pP1: Boolean): String;
  function _ecf12_Datadaultimareduo(pP1: Boolean): String;
  function _ecf12_Datadomovimento(pP1: Boolean): String;
  function _ecf12_StatusGaveta(Pp1: Boolean):String;
  function _ecf12_RetornaAliquotas(pP1: Boolean): String;
  function _ecf12_Vincula(pP1: String): Boolean;
  function _ecf12_FlagsDeISS(pP1: Boolean): String;
  function _ecf12_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
  function _ecf12_MudaMoeda(pP1: String): Boolean;
  function _ecf12_MostraDisplay(pP1: String): Boolean;
  function _ecf12_leituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
  function _ecf12_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean;
  function _ecf12_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
  function _ecf12_FechaCupom2(sP1: Boolean): Boolean;
  function _ecf12_ImprimeCheque(rP1: Real; sP2: String): Boolean;
  function _ecf12_GrandeTotal(sP1: Boolean): String;
  function _ecf12_TotalizadoresDasAliquotas(sP1: Boolean): String;
  function _ecf12_CupomAberto(sP1: Boolean): boolean;
  function _ecf12_FaltaPagamento(sP1: Boolean): boolean;

function _ecf12_Marca(sP1: Boolean): String;
function _ecf12_Modelo(sP1: Boolean): String;
function _ecf12_Tipodaimpressora(pP1: Boolean): String; //
function _ecf12_VersaoSB(pP1: Boolean): String; //
function _ecf12_HoraIntalacaoSB(pP1: Boolean): String; //
function _ecf12_DataIntalacaoSB(pP1: Boolean): String; //
function _ecf12_ProgramaAplicativo(sP1: Boolean): boolean;
function _ecf12_DadosDaUltimaReducao(pP1: Boolean): String; //
function _ecf12_CodigoModeloEcf(pP1: Boolean): String; //



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
  iHd : Integer;
  Estado : String;
  ret1 : String;
  ret2 : String;
  ret3 : String;
  ret4 : String;
  ret5 : String;

  FAvancoPapel: String; // Sandro Silva 2016-08-26

implementation

// ---------------------------------- //
// Tratamento de erros da URANO LOG   //
// ---------------------------------- //
function _ecf12_CodeErro(pP1: Integer; pP2: String):Integer;
var
  nomeerro: array [0..255] of char;
  circunstancia: array [0..255] of char;
  Retorno: array [0..255] of char;
begin
  //
  if (DLLG2_ObtemCodErro(iHd) <> 0) then
  begin
    DLLG2_ObtemNomeErro(iHd, nomeerro, sizeof(nomeerro));
    DLLG2_ObtemCircunstancia(iHd, circunstancia, sizeof(circunstancia));
    application.MessageBox(pchar(nomeerro + ' - ' + circunstancia), 'Logger - Erro', MB_ICONERROR);
    Result := 255;
  end else
  begin
    DLLG2_LimpaParams(iHd);                                                    // Limpa os parâmetros
    DLLG2_AdicionaParam(iHd, 'NomeIndicador', 'SensorPoucoPapel', 7);          // Seta os parâmetros
    DLLG2_ExecutaComando(iHd, 'LeIndicador');                                  // Executa a função
    DLLG2_Retorno(iHd, 0, 'ValorTextoIndicador', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    //
    if AllTrim(Retorno) = '1' then
    begin
      if Form1.Memo3.Visible then
      begin
        Form1.Panel2.Visible := True;
        Form1.Panel2.BringToFront;
      end;
    end else
    begin
      Form1.PAnel2.Visible := False;
    end;
    //
    Result := 0;
  end;
  //
end;


// ----------------------------//
// Detecta qual a porta que    //
// a impressora está conectada //
// URANO LOG                   //
// --------------------------- //
// Sandro Silva 2016-04-02  function _ecf12_Inicializa(Pp1: String; iTimeOutDLLG2: Integer): Boolean;
function _ecf12_Inicializa(Pp1: String): Boolean;
var
  I : Integer;
  Retorno: array [0..255] of char;
begin
  //
  Result := False;
  Form1.sPorta := pP1;

  FAvancoPapel := Form1.sAvancoPapel; // Sandro Silva 2016-08-26  Padrão 200

  //
  for I := 1 to 3 do
  begin
    if Length(AllTrim(Retorno)) <> 10 then
    begin
      iHd := DLLG2_IniciaDriver(pChar(pP1));
      {Sandro Silva 2016-02-18 inicio}
      if Form1.iTimeOutDLLG2 > 5 then
        DLLG2_DefineTimeout(iHd, Form1.iTimeOutDLLG2);
      {Sandro Silva 2016-02-18 final}
      DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
      DLLG2_AdicionaParam(iHd, 'NomeData', 'Data', 7);            // Seta os parâmetros
      DLLG2_ExecutaComando(iHd, 'LeData');                        // Executa a função
      DLLG2_Retorno(iHd, 0, 'ValorData', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    end;
  end;
  //
  if Length(AllTrim(Retorno)) <> 10 then
  begin
    if Form22.Label6.Caption = 'Detectando porta de comunicação...' then
    begin
      for I := 1 to 7 do
      begin
        if Length(AllTrim(Retorno)) <> 10 then
        begin
          Result := False;
          ShowMessage('FIT LOGGER'+Chr(10)+'Testando COM'+StrZero(I,1,0)+chr(10)+chr(10)+'Data: '+Retorno);
          iHd := DLLG2_IniciaDriver(pChar('COM'+StrZero(I,1,0)));
          {Sandro Silva 2016-02-18 inicio}
          if Form1.iTimeOutDLLG2 > 5 then
            DLLG2_DefineTimeout(iHd, Form1.iTimeOutDLLG2);
          {Sandro Silva 2016-02-18 final}
          DLLG2_LimpaParams(iHd);                                          // Limpa os parâmetros
          DLLG2_AdicionaParam(iHd, 'NomeData', 'Data', 7);                 // Seta os parâmetros
          DLLG2_ExecutaComando(iHd, 'LeData');                             // Executa a função
          DLLG2_Retorno(iHd, 0, 'ValorData', 0, Retorno, sizeof(retorno)); // Obtem o retorno
          Form1.sPorta  := 'COM'+StrZero(I,1,0);
        end else Result := True;
      end;
     end;
  end else Result := True;
  //
  // Nomeia relatórios gerenciais
  //
  try
    DLLG2_LimpaParams(iHd);                                                              // Limpa os parâmetros.
    DLLG2_AdicionaParam(iHd,'CodGerencial','1',4);
    DLLG2_AdicionaParam(iHd,'DescricaoGerencial','IDENT DO PAF',7);
    DLLG2_AdicionaParam(iHd,'NomeGerencial','IDENT DO PAF',7);
    DLLG2_ExecutaComando(iHd,'DefineGerencial');
  except end;
  try
    DLLG2_LimpaParams(iHd);                                                              // Limpa os parâmetros.
    DLLG2_AdicionaParam(iHd,'CodGerencial','2',4);
    DLLG2_AdicionaParam(iHd,'DescricaoGerencial','VENDA PRAZO',7);
    DLLG2_AdicionaParam(iHd,'NomeGerencial','VENDA PRAZO',7);
    DLLG2_ExecutaComando(iHd,'DefineGerencial');
  except end;
  {Sandro Silva 2016-02-04 inicio
  try
    DLLG2_LimpaParams(iHd);                                                              // Limpa os parâmetros.
    DLLG2_AdicionaParam(iHd,'CodGerencial','3',4);
    DLLG2_AdicionaParam(iHd,'DescricaoGerencial','TEF',7);
    DLLG2_AdicionaParam(iHd,'NomeGerencial','TEF',7);
    DLLG2_ExecutaComando(iHd,'DefineGerencial');
  except end;
  }
  try
    DLLG2_LimpaParams(iHd);                                                              // Limpa os parâmetros.
    DLLG2_AdicionaParam(iHd,'CodGerencial','3',4);
    DLLG2_AdicionaParam(iHd,'DescricaoGerencial','CARTAO TEF',7);
    DLLG2_AdicionaParam(iHd,'NomeGerencial','CARTAO TEF',7);
    DLLG2_ExecutaComando(iHd,'DefineGerencial');
  except end;
  {Sandro Silva 2016-02-04 final}
  try
    DLLG2_LimpaParams(iHd);                                                              // Limpa os parâmetros.
    DLLG2_AdicionaParam(iHd,'CodGerencial','4',4);
    DLLG2_AdicionaParam(iHd,'DescricaoGerencial','MEIOS DE PAGTO',7);
    DLLG2_AdicionaParam(iHd,'NomeGerencial','MEIOS DE PAGTO',7);
    DLLG2_ExecutaComando(iHd,'DefineGerencial');
    DLLG2_LimpaParams(iHd);                                                              // Limpa os parâmetros.
  except end;
  try
    DLLG2_AdicionaParam(iHd,'CodGerencial','5',4);
    DLLG2_AdicionaParam(iHd,'DescricaoGerencial','DAV Emitidos',7);
    DLLG2_AdicionaParam(iHd,'NomeGerencial','DAV Emitidos',7);
    DLLG2_ExecutaComando(iHd,'DefineGerencial');
  except end;
  try
    DLLG2_AdicionaParam(iHd,'CodGerencial','6',4);
    DLLG2_AdicionaParam(iHd,'DescricaoGerencial','Orçamento (DAV)',7);
    DLLG2_AdicionaParam(iHd,'NomeGerencial','Orçamento (DAV)',7);
    DLLG2_ExecutaComando(iHd,'DefineGerencial');
  except end;
  {Sandro Silva 2016-02-04 inicio
  try
    DLLG2_AdicionaParam(iHd,'CodGerencial','7',4);
    DLLG2_AdicionaParam(iHd,'DescricaoGerencial','CONF CONTA',7);
    DLLG2_AdicionaParam(iHd,'NomeGerencial','CONF CONTA',7);
    DLLG2_ExecutaComando(iHd,'DefineGerencial');
  except end;
  }
  try
    DLLG2_AdicionaParam(iHd,'CodGerencial','7',4);
    DLLG2_AdicionaParam(iHd,'DescricaoGerencial','CONF CONTA CLI',7); // 2016-02-04 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
    DLLG2_AdicionaParam(iHd,'NomeGerencial','CONF CONTA CLI',7);
    DLLG2_ExecutaComando(iHd,'DefineGerencial');
  except end;
  {Sandro Silva 2016-02-04 final}
  {Sandro Silva 2016-02-11 inicio
  try
    DLLG2_AdicionaParam(iHd,'CodGerencial','8',4);
    DLLG2_AdicionaParam(iHd,'DescricaoGerencial','TRANSF CONTA',7);
    DLLG2_AdicionaParam(iHd,'NomeGerencial','TRANSF CONTA',7);
    DLLG2_ExecutaComando(iHd,'DefineGerencial');
  except end;
  try
    DLLG2_AdicionaParam(iHd,'CodGerencial','9',4);
    DLLG2_AdicionaParam(iHd,'DescricaoGerencial','CONTAS ABERTAS',7);
    DLLG2_AdicionaParam(iHd,'NomeGerencial','CONTAS ABERTAS',7);
    DLLG2_ExecutaComando(iHd,'DefineGerencial');
  except end;
  }
  try
    DLLG2_AdicionaParam(iHd,'CodGerencial','8',4);
    DLLG2_AdicionaParam(iHd,'DescricaoGerencial','TRANSF CONT CLI',7); // 2016-02-11 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
    DLLG2_AdicionaParam(iHd,'NomeGerencial','TRANSF CONT CLI',7);
    DLLG2_ExecutaComando(iHd,'DefineGerencial');
  except end;
  try
    DLLG2_AdicionaParam(iHd,'CodGerencial','9',4);
    DLLG2_AdicionaParam(iHd,'DescricaoGerencial','CONT CLI ABERTA',7); // 2016-02-11 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
    DLLG2_AdicionaParam(iHd,'NomeGerencial','CONT CLI ABERTA',7);
    DLLG2_ExecutaComando(iHd,'DefineGerencial');
  except end;
  {Sandro Silva 2016-02-11 final}
  try
    DLLG2_AdicionaParam(iHd,'CodGerencial','10',4);
    DLLG2_AdicionaParam(iHd,'DescricaoGerencial','CONF MESA',7);
    DLLG2_AdicionaParam(iHd,'NomeGerencial','CONF MESA',7);
    DLLG2_ExecutaComando(iHd,'DefineGerencial');
  except end;
  try
    DLLG2_AdicionaParam(iHd,'CodGerencial','11',4);
    DLLG2_AdicionaParam(iHd,'DescricaoGerencial','TRANSF MESA',7);
    DLLG2_AdicionaParam(iHd,'NomeGerencial','TRANSF MESA',7);
    DLLG2_ExecutaComando(iHd,'DefineGerencial');
  except end;
  try
    DLLG2_AdicionaParam(iHd,'CodGerencial','12',4);
    DLLG2_AdicionaParam(iHd,'DescricaoGerencial','MESAS ABERTAS',7);
    DLLG2_AdicionaParam(iHd,'NomeGerencial','MESAS ABERTAS',7);
    DLLG2_ExecutaComando(iHd,'DefineGerencial');
  except end;
  try
    DLLG2_AdicionaParam(iHd,'CodGerencial','13',4);
    DLLG2_AdicionaParam(iHd,'DescricaoGerencial','PARAM CONFIG',7);
    DLLG2_AdicionaParam(iHd,'NomeGerencial','PARAM CONFIG',7);
    DLLG2_ExecutaComando(iHd,'DefineGerencial');
  except end;
  //
end;


// ------------------------------ //
// Fecha o cupom que está sendo   //
// emitido                        //
// URANO LOG                      //
// ------------------------------ //
function _ecf12_FechaCupom(Pp1: Boolean):Boolean;
begin
  //
  if Form1.fTotal <> 0 then
  begin
    //
    if Form1.ibDataSet25RECEBER.AsFloat-Form1.fTotal <> 0 then
    begin
      DLLG2_LimpaParams(iHd);                                                                                    // Limpa os parâmetros
      DLLG2_AdicionaParam(iHd,'Cancelar','False',0);  // 	Indicador de cancelamento da operação.Se este parâmetro for informado (='true'), cancela
      DLLG2_AdicionaParam(iHd,'ValorAcrescimo',pChar(Format('%12.2f',[Form1.ibDataSet25RECEBER.AsFloat-Form1.fTotal])),6);  // Valor do desconto (quando negativo) ou acréscimo (quando positivo).
      DLLG2_ExecutaComando(iHd,'AcresceSubtotal');
    end;
    //
  end else _ecf12_CancelaUltimoCupom(True);// cupom em branco cancela;
  //
  Result := True;
  //
end;

// ------------------------------ //
// Fecha o cupom que está sendo   //
// emitido                        //
// URANO LOG                          //
// ------------------------------ //
function _ecf12_Pagamento(Pp1: Boolean):Boolean;
begin
  //
  // ------------------ //
  // Forma de pagamento //
  // ------------------ //
//  ShowMessage(
//      'Em cheque...: '+StrZero(Form1.ibDataSet25ACUMULADO1.AsFloat*100,14,0)+ Chr(10) +
//      'Em dinheiro.: '+StrZero(Form1.ibDataSet25ACUMULADO2.AsFloat*100,14,0)+ Chr(10) +
//      'Receber.....: '+StrZero(Form1.ibDataSet25RECEBER.AsFloat*100,14,0)+ Chr(10)+
//      'Total.......: '+StrZero(Form1.fTotal*100,14,0)+ Chr(10));
  //
  if Form1.ibDataSet25ACUMULADO1.AsFloat <> 0 then
  begin
    DLLG2_LimpaParams(iHd);                                                              // Limpa os parâmetros.
    DLLG2_AdicionaParam(iHd,'NomeMeioPagamento',pchar(AllTrim(Form2.Label9.Caption)),7); // cheque
    DLLG2_AdicionaParam(iHd,'Valor',pChar(Form1.ibDataSet25ACUMULADO1.AsString),6);          // Valor da operação.Indica o montante pago com o Meio de Pagamento informado.
    DLLG2_ExecutaComando(iHd,'PagaCupom');                     // Executa a função
  end;
  //
  if Form1.ibDataSet25ACUMULADO2.AsFloat <> 0 then
  begin
    DLLG2_LimpaParams(iHd);                                                              // Limpa os parâmetros.
    DLLG2_AdicionaParam(iHd,'NomeMeioPagamento',pChar(Copy('Dinheiro'+Replicate(' ',16),1,16)),7);
    DLLG2_AdicionaParam(iHd,'Valor',pChar(Form1.ibDataSet25ACUMULADO2.AsString),6);          // Valor da operação.Indica o montante pago com o Meio de Pagamento informado.
    DLLG2_ExecutaComando(iHd,'PagaCupom');
  end;
  //
  if Form1.ibDataSet25PAGAR.AsFloat <> 0 then
  begin
    DLLG2_LimpaParams(iHd);                                                              // Limpa os parâmetros.
    DLLG2_AdicionaParam(iHd,'NomeMeioPagamento',pchar(AllTrim(Form2.Label8.Caption)),7); // Cartão
    DLLG2_AdicionaParam(iHd,'Valor',pChar(Form1.ibDataSet25Pagar.AsString),6);               // Valor da operação.Indica o montante pago com o Meio de Pagamento informado.
    DLLG2_ExecutaComando(iHd,'PagaCupom');                     // Executa a função
  end;
  //
  if Form1.ibDataSet25DIFERENCA_.aSFloat <> 0 then
  begin
    DLLG2_LimpaParams(iHd);                                                               // Limpa os parâmetros.
    DLLG2_AdicionaParam(iHd,'NomeMeioPagamento',pchar(AllTrim(Form2.Label17.Caption)),7); // Prazo
    DLLG2_AdicionaParam(iHd,'Valor',pChar(Form1.ibDataSet25DIFERENCA_.AsString),6);           // Valor da operação.Indica o montante pago com o Meio de Pagamento informado.
    DLLG2_ExecutaComando(iHd,'PagaCupom');                     // Executa a função
  end;
  //
  if Form1.ibDataSet25VALOR01.AsFloat    <> 0 then
  begin
    DLLG2_LimpaParams(iHd);                                                       // Limpa os parâmetros.
    DLLG2_AdicionaParam(iHd,'NomeMeioPagamento',pchar(AllTrim(Form2.Label18.Caption)),7);
    DLLG2_AdicionaParam(iHd,'Valor',pChar(Form1.ibDataSet25VALOR01.AsString),6);   // Valor da operação.Indica o montante pago com o Meio de Pagamento informado.
    DLLG2_ExecutaComando(iHd,'PagaCupom');                     // Executa a função
  end;
  //
  if Form1.ibDataSet25VALOR02.AsFloat    <> 0 then
  begin
    DLLG2_LimpaParams(iHd);                                                       // Limpa os parâmetros.
    DLLG2_AdicionaParam(iHd,'NomeMeioPagamento',pchar(AllTrim(Form2.Label19.Caption)),7);
    DLLG2_AdicionaParam(iHd,'Valor',pChar(Form1.ibDataSet25VALOR02.AsString),6);   // Valor da operação.Indica o montante pago com o Meio de Pagamento informado.
    DLLG2_ExecutaComando(iHd,'PagaCupom');                     // Executa a função
  end;
  //
  if Form1.ibDataSet25VALOR03.AsFloat    <> 0 then
  begin
    DLLG2_LimpaParams(iHd);                                                       // Limpa os parâmetros.
    DLLG2_AdicionaParam(iHd,'NomeMeioPagamento',pchar(AllTrim(Form2.Label20.Caption)),7);
    DLLG2_AdicionaParam(iHd,'Valor',pChar(Form1.ibDataSet25VALOR03.AsString),6);   // Valor da operação.Indica o montante pago com o Meio de Pagamento informado.
    DLLG2_ExecutaComando(iHd,'PagaCupom');                     // Executa a função
  end;
  //
  if Form1.ibDataSet25VALOR04.AsFloat    <> 0 then
  begin
    DLLG2_LimpaParams(iHd);                                                       // Limpa os parâmetros.
    DLLG2_AdicionaParam(iHd,'NomeMeioPagamento',pchar(AllTrim(Form2.Label21.Caption)),7);
    DLLG2_AdicionaParam(iHd,'Valor',pChar(Form1.ibDataSet25VALOR04.AsString),6);   // Valor da operação.Indica o montante pago com o Meio de Pagamento informado.
    DLLG2_ExecutaComando(iHd,'PagaCupom');                     // Executa a função
  end;
  //
  if Form1.ibDataSet25VALOR05.AsFloat    <> 0 then
  begin
    DLLG2_LimpaParams(iHd);                                                       // Limpa os parâmetros.
    DLLG2_AdicionaParam(iHd,'NomeMeioPagamento',pchar(AllTrim(Form2.Label22.Caption)),7);
    DLLG2_AdicionaParam(iHd,'Valor',pChar(Form1.ibDataSet25VALOR05.AsString),6);   // Valor da operação.Indica o montante pago com o Meio de Pagamento informado.
    DLLG2_ExecutaComando(iHd,'PagaCupom');                     // Executa a função
  end;
  //
  if Form1.ibDataSet25VALOR06.AsFloat    <> 0 then
  begin
    DLLG2_LimpaParams(iHd);                                                       // Limpa os parâmetros.
    DLLG2_AdicionaParam(iHd,'NomeMeioPagamento',pchar(AllTrim(Form2.Label23.Caption)),7);
    DLLG2_AdicionaParam(iHd,'Valor',pChar(Form1.ibDataSet25VALOR06.AsString),6);   // Valor da operação.Indica o montante pago com o Meio de Pagamento informado.
    DLLG2_ExecutaComando(iHd,'PagaCupom');                     // Executa a função
  end;
  //
  if Form1.ibDataSet25VALOR07.AsFloat    <> 0 then
  begin
    DLLG2_LimpaParams(iHd);                                                       // Limpa os parâmetros.
    DLLG2_AdicionaParam(iHd,'NomeMeioPagamento',pchar(AllTrim(Form2.Label24.Caption)),7);
    DLLG2_AdicionaParam(iHd,'Valor',pChar(Form1.ibDataSet25VALOR07.AsString),6);   // Valor da operação.Indica o montante pago com o Meio de Pagamento informado.
    DLLG2_ExecutaComando(iHd,'PagaCupom');                     // Executa a função
  end;
  //
  if Form1.ibDataSet25VALOR08.AsFloat    <> 0 then
  begin
    DLLG2_LimpaParams(iHd);                                                       // Limpa os parâmetros.
    DLLG2_AdicionaParam(iHd,'NomeMeioPagamento',pchar(AllTrim(Form2.Label25.Caption)),7);
    DLLG2_AdicionaParam(iHd,'Valor',pChar(Form1.ibDataSet25VALOR08.AsString),6);   // Valor da operação.Indica o montante pago com o Meio de Pagamento informado.
    DLLG2_ExecutaComando(iHd,'PagaCupom');                     // Executa a função
  end;
  //
  DLLG2_LimpaParams(iHd);                                                        // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd,'TextoLivre',pchar(Alltrim(copy('MD5: '+Form1.sMD5DaLista+Chr(10)+ConverteAcentos2(Form1.sMensagemPromocional)+Replicate(' ',492),1,492))),7);
  DLLG2_ExecutaComando(iHd,'ImprimeTexto');                                      // Executa a função
  //
{
  DLLG2_LimpaParams(iHd);                                           // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd,'IdConsumidor',pchar(Alltrim(copy('MD5: '+Form1.sMD5DaLista+chr(10)+ConverteAcentos2(Form1.sMensagemPromocional)+Replicate(' ',492),1,492))),7);     // Identificação do operador
  DLLG2_ExecutaComando(iHd,'IdentificaConsumidor');                     // Executa a função
}
  //
  DLLG2_LimpaParams(iHd);                                               // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd,'Operador','',7);         // Identificação do operador
//  DLLG2_AdicionaParam(iHd,'TextoPromocional',pchar(Alltrim(copy('MD5: '+Form1.sMD5DaLista+Chr(10)+ConverteAcentos(Form1.sMensagemPromocional)+Replicate(' ',492),1,492))),7);
  DLLG2_ExecutaComando(iHd,'EncerraDocumento');                         // Executa a função
  //
  DLLG2_LimpaParams(iHd);                                           // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd,'Avanco',pChar(FAvancoPapel),12);
  DLLG2_ExecutaComando(iHd,'AvancaPapel'); // Executa a função
  //
  if Form1.sCortaPapel = 'Sim' then
  begin
    DLLG2_LimpaParams(iHd);
    DLLG2_AdicionaParam(iHd,'TipoCorte','1',12);               //
    DLLG2_ExecutaComando(iHd,'CortaPapel'); // Executa a função
    Form1.Edit1.SetFocus;
  end;
  //
  Result := True;
  //
end;

// ------------------------------ //
// URANO LOG                      //
// cancela o último item do cupom //
// ------------------------------ //
function _ecf12_CancelaUltimoItem(Pp1: Boolean):Boolean;
begin
  //
  DLLG2_LimpaParams(iHd);                                           // Limpa os parâmetros
  DLLG2_ExecutaComando(iHd,'CancelaItemFiscal');                    // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then Result := True              // Verifica se teve erro no retorno
    else Result := False;
  _ecf12_CodeErro(iHd,'');
  //
end;

// -------------------------------//
// URANO LOG                      //
// Cancela o último cupom emitido //
// -------------------------------//
function _ecf12_CancelaUltimoCupom(Pp1: Boolean):Boolean;
begin
  //
  DLLG2_LimpaParams(iHd);                                           // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd,'Operador','1',7);     // Identificação do operador
  DLLG2_ExecutaComando(iHd,'CancelaCupom');                     // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then Result := True              // Verifica se teve erro no retorno
    else Result := False;

  if Result = False then
    ShowMessage('Cancelamento não permitido'); // Sandro Silva 2018-10-18

  //
  DLLG2_LimpaParams(iHd);                                           // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd,'Avanco',pChar(FAvancoPapel),12);     // Identificação do operador
  DLLG2_ExecutaComando(iHd,'AvancaPapel'); // Executa a função
  //
  if Form1.sCortaPapel = 'Sim' then
  begin
    DLLG2_LimpaParams(iHd);                                          // Limpa os parâmetros
    DLLG2_AdicionaParam(iHd,'TipoCorte','1',12);               //
    DLLG2_ExecutaComando(iHd,'CortaPapel'); // Executa a função
    Form1.Edit1.SetFocus;
  end;
  //
  //  _ecf12_CodeErro(iHd,'');
  //
end;

// -------------------------------//
// URANO LOG                      //
// Subtotal                       //
// -------------------------------//
function _ecf12_SubTotal(Pp1: Boolean):Real;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                                // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeDadoMonetario', 'TotalDocLiquido', 7);   // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeMoeda');                                  // Executa a função

  if (DLLG2_ObtemCodErro(iHd) = 0) then                                  // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorMoeda', 0, Retorno, sizeof(retorno)); // Obtem o retorno
// ShowMessage(retorno);
    Result := StrToFloat(StrTran(Retorno,'.',''));
  end else Result := 0;
//  _ecf12_CodeErro(iHd,'');
  //
end;

// ------------------------------ //
// Abre um novo cupom fiscal      //
// URANO LOG                          //
// ------------------------------ //
function _ecf12_AbreNovoCupom(Pp1: Boolean):Boolean;
begin
  //
  if not _ecf12_CupomAberto(True) then
  begin
    DLLG2_LimpaParams(iHd);                                                    // Limpa os parâmetros
    DLLG2_AdicionaParam(iHd,'IdConsumidor',pChar(Form1.sCPF_CNPJ_Validado),7); //
    DLLG2_ExecutaComando(iHd,'AbreCupomFiscal');                               // Executa a função
    if (DLLG2_ObtemCodErro(iHd) = 0) then Result := True else Result := False;
    _ecf12_CodeErro(iHd,'');
  end else Result := True;
  //
end;

// -------------------------------- //
// Retorna o número do Cupom        //
// URANO LOG                            //
// -------------------------------- //
function _ecf12_NumeroDoCupom(Pp1: Boolean):String;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeInteiro', 'COO', 7);          // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeInteiro');                     // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorInteiro', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := StrZero(StrToInt(Retorno),6,0);
  end else Result := '000000';
  _ecf12_CodeErro(iHd,'');
  //
end;

// ------------------------------ //
// Cancela um item N              //
// URANO LOG                          //
// ------------------------------ //
function _ecf12_CancelaItemN(pP1, pP2 : String):Boolean;
begin
  //
  DLLG2_LimpaParams(iHd);                                           // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd,'NumItem',pChar(pP1),4);     // Identificação do operador
  DLLG2_ExecutaComando(iHd,'CancelaItemFiscal');                    // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then Result := True              // Verifica se teve erro no retorno
    else Result := False;
  _ecf12_CodeErro(iHd,'');
  // ------------------------------------------------------------------ //
  // A variável iCancelaItenN deve ser incrementada quando a impressora //
  // considera não considera que o item já foi cancelado isso evita um  //
  // problema de cancelar um item na tela e no arquivo e na impressora  //
  // cancelar outro.                                                    //
  // ------------------------------------------------------------------ //
end;

// -------------------------------- //
// Abre a gaveta                    //
// URANO LOG                            //
// -------------------------------- //
function _ecf12_AbreGaveta(Pp1: Boolean):Boolean;
begin
  DLLG2_LimpaParams(iHd);                                           // Limpa os parâmetros
//  DLLG2_AdicionaParam(iHd,'TempoAcionamentoGaveta','100',7);        // Tempo, em milissegundos, de acionamento do solenóide.
  DLLG2_ExecutaComando(iHd,'AbreGaveta');                    // Executa a função
  Result := True;
end;

// -------------------------------- //
// Status da gaveta                 //
// URANO LOG                        //
//                                  //
// 000 Gaveta Fechada.              //
// 255 Gaveta Aberta.               //
// 128 Valor atribuido quando não   //
//     tem gaveta.                  //
// -------------------------------- //
function _ecf12_StatusGaveta(Pp1: Boolean):String;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeIndicador', 'SensorGaveta', 7);   // Seta os parâmetros
  //
  DLLG2_ExecutaComando(iHd, 'LeIndicador');                       // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorTextoIndicador', 0, Retorno, sizeof(retorno)); // Obtem o retorno
  end;
  //
  if Form1.iStatusGaveta = 0 then
  begin
    if Copy(Retorno,1,1) = '1' then Result := '255' else Result := '000';
  end else
  begin
    if Copy(Retorno,1,1) = '1' then Result := '000' else Result := '255';
  end;
  //
end;

// -------------------------------- //
// SAngria                          //
// URANO LOG                            //
// -------------------------------- //
function _ecf12_Sangria(Pp1: Real):Boolean;
begin
  //
  DLLG2_LimpaParams(iHd);                                      // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd,'NomeNaoFiscal','Sangria',7);        //
  DLLG2_AdicionaParam(iHd,'TipoNaoFiscal','False',0);          //
  DLLG2_ExecutaComando(iHd,'DefineNaoFiscal');                 // Executa a função
  //
  DLLG2_LimpaParams(iHd);                                      // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd,'NomeNaoFiscal','Sangria',7);        //
  DLLG2_AdicionaParam(iHd,'Valor',pChar(FloatToStr(pP1)),6);   // Valor da operação.Indica o montante pago com o Meio de Pagamento informado.
  DLLG2_ExecutaComando(iHd,'EmiteItemNaoFiscal');              // Executa a função
  //
  DLLG2_LimpaParams(iHd);                                      // Limpa os parâmetros.
  DLLG2_AdicionaParam(iHd,'CodMeioPagamento','-2',0);          // Índice do Meio de Pagamento.
  DLLG2_AdicionaParam(iHd,'Valor',pChar(FloattoStr(pP1)),6);   // Valor da operação.Indica o montante pago com o Meio de Pagamento informado.
  //
  DLLG2_ExecutaComando(iHd,'PagaCupom');                       // Executa a função
//  if (DLLG2_ObtemCodErro(iHd) <> 0) then _ecf12_CodeErro(iHd,'');
  //
  DLLG2_LimpaParams(iHd);                                           // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd,'Operador','1',7);     // Identificação do operador
  DLLG2_ExecutaComando(iHd,'EncerraDocumento');                     // Executa a função
  //
  if (DLLG2_ObtemCodErro(iHd) <> 0) then Result := False else Result := True;
//  _ecf12_CodeErro(iHd,'');
  //
  DLLG2_LimpaParams(iHd);                                           // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd,'Avanco',pChar(FAvancoPapel),12);     // Identificação do operador
  DLLG2_ExecutaComando(iHd,'AvancaPapel'); // Executa a função
  //
  if Form1.sCortaPapel = 'Sim' then
  begin
    DLLG2_LimpaParams(iHd);                                          // Limpa os parâmetros
    DLLG2_AdicionaParam(iHd,'TipoCorte','1',12);               //
    DLLG2_ExecutaComando(iHd,'CortaPapel'); // Executa a função
    Form1.Edit1.SetFocus;
  end;
  //
end;

// -------------------------------- //
// Suprimento                       //
// URANO LOG                            //
// -------------------------------- //
function _ecf12_Suprimento(Pp1: Real):Boolean;
begin
  //
  DLLG2_LimpaParams(iHd);                                      // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd,'NomeNaoFiscal','Suprimento',7);     //
  DLLG2_AdicionaParam(iHd,'TipoNaoFiscal','True',0);           //
  DLLG2_ExecutaComando(iHd,'DefineNaoFiscal');                 // Executa a função
  //
  DLLG2_LimpaParams(iHd);                                      // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd,'NomeNaoFiscal','Suprimento',7);     //
  DLLG2_AdicionaParam(iHd,'Valor',pChar(FloatToStr(pP1)),6);   // Valor da operação.Indica o montante pago com o Meio de Pagamento informado.
  DLLG2_ExecutaComando(iHd,'EmiteItemNaoFiscal');              // Executa a função
  //
  DLLG2_LimpaParams(iHd);                                      // Limpa os parâmetros.
  DLLG2_AdicionaParam(iHd,'CodMeioPagamento','-2',0);          // Índice do Meio de Pagamento.
  DLLG2_AdicionaParam(iHd,'Valor',pChar(FloattoStr(pP1)),6);   // Valor da operação.Indica o montante pago com o Meio de Pagamento informado.
  //
  DLLG2_ExecutaComando(iHd,'PagaCupom');                       // Executa a função
//  if (DLLG2_ObtemCodErro(iHd) <> 0) then _ecf12_CodeErro(iHd,'');
  //
  DLLG2_LimpaParams(iHd);                                           // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd,'Operador','1',7);     // Identificação do operador
  DLLG2_ExecutaComando(iHd,'EncerraDocumento');                     // Executa a função
  //
  if (DLLG2_ObtemCodErro(iHd) <> 0) then Result := False else Result := True;
//  _ecf12_CodeErro(iHd,'');
  //
  DLLG2_LimpaParams(iHd);                                           // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd,'Avanco',pChar(FAvancoPapel),12);     // Identificação do operador
  DLLG2_ExecutaComando(iHd,'AvancaPapel'); // Executa a função
  //
  if Form1.sCortaPapel = 'Sim' then
  begin
    DLLG2_LimpaParams(iHd);                                          // Limpa os parâmetros
    DLLG2_AdicionaParam(iHd,'TipoCorte','1',12);               //
    DLLG2_ExecutaComando(iHd,'CortaPapel'); // Executa a função
    Form1.Edit1.SetFocus;
  end;
  //
end;

// -------------------------------- //
// Nova Aliquota                    //
// URANO LOG                            //
// -------------------------------- //
function _ecf12_NovaAliquota(Pp1: String):Boolean;
begin
  // Este comando só pode ser feito mediante uma intervenção técnica //
  ShowMessage('Este comando só poderá ser executado mediante uma'
  + chr(10) + 'intervenção técnica.'
  + chr(10)
  + chr(10) + 'Se realmente for necessário cadastrar uma nova aliquota,'
  + chr(10) + 'Chame um técnico habilitado.');
  Result := True;
  //
end;

function _ecf12_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
var
  Retorno: array [0..400] of char;
  sTexto : String;
begin

  if (Form7.sMfd = 'MFPERIODO') or (Form7.sMfd = 'MFDPERIODO') then
  begin
    {Sandro Silva 2017-08-25 inicio}
    if FileExists(pP1) then
      DeleteFile(pP1);

    Result := True;
    
    {Sandro Silva 2017-08-25 final}
  end
  else
  begin
    //
    // URANO  (01451)34628707 Filipe   //
    //
    DLLG2_LimpaParams(iHd);                                    // Limpa os parâmetros
    DLLG2_AdicionaParam(iHd,'Destino','S',7);                  // Seta os parâmetros
    //
    if Form7.Label3.Caption = 'Data inicial:' then
    begin
      DLLG2_AdicionaParam(iHd,'DataInicial',pChar(Copy(pP2,1,2)+'/'+Copy(pP2,3,2)+'/'+'20'+Copy(pP2,5,2)),2);         // Seta os parâmetros
      DLLG2_AdicionaParam(iHd,'DataFinal',pChar(Copy(pP3,1,2)+'/'+Copy(pP3,3,2)+'/'+'20'+Copy(pP3,5,2)),2);           // Seta os parâmetros
    end else
    begin
      DLLG2_AdicionaParam(iHd,'COOInicial',pChar(StrZero(StrToInt(pP2),6,0)),4);         // Seta os parâmetros
      DLLG2_AdicionaParam(iHd,'COOFinal',pChar(StrZero(StrToInt(pP3),6,0)),4);           // Seta os parâmetros
    end;
    //
    DLLG2_ExecutaComando(iHd,'EmiteLeituraFitaDetalhe');               // Executa a função
    //
  {
    DLLG2_LimpaParams(iHd);                                    // Limpa os parâmetros
    DLLG2_AdicionaParam(iHd,'Destino','S',7);                  // Seta os parâmetros
    DLLG2_AdicionaParam(iHd,'Operador','',7);                  // Seta os parâmetros
    //
    DLLG2_ExecutaComando(iHd,'EmiteLeituraX');                 // Executa a função
  }
    //
    if iHd <> 0 then _ecf12_CodeErro(iHd,'');
    //
    //
    DeleteFile(pP1);   // Apaga o arquivo anterior
    AssignFile(Form1.F,pP1);
    Rewrite(Form1.F);           // Abre para gravação
    Retorno := '<INICIO>';
    sTexto  := '';
    //
    while AllTrim(Retorno) <> '' do
    begin
      //
      Retorno := '';
      //
      sLeep(100);
      DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
      DLLG2_ExecutaComando(iHd,'LeImpressao');
  //    if iHd <> 0 then _ecf12_CodeErro(iHd,'');
      DLLG2_Retorno(iHd, 0, 'TextoImpressao', 0, Retorno, sizeof(retorno)); // Obtem o retorno
      sTexto := sTexto + Retorno;
    end;
    //
    Writeln(Form1.F,sTexto);
    CloseFile(Form1.F);  // Fecha o arquivo
    //
    Result := True;
    //
  end;
end;

function _ecf12_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
begin
  //
  DLLG2_LimpaParams(iHd);                                    // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd,'Destino','I',7);                  // Seta os parâmetros
  DLLG2_AdicionaParam(iHd,'Operador','',7);             // Seta os parâmetros
  //
  if Form1.sTipo = 's' then DLLG2_AdicionaParam(iHd,'LeituraSimplificada','True',0) else DLLG2_AdicionaParam(iHd,'LeituraSimplificada','False',0);
  //
  if Length(pP1) = 6 then
  begin
    DLLG2_AdicionaParam(iHd,'DataInicial',pChar(Copy(pP1,1,2)+'/'+Copy(pP1,3,2)+'/'+'20'+Copy(pP1,5,2)),2);         // Seta os parâmetros
    DLLG2_AdicionaParam(iHd,'DataFinal',pChar(Copy(pP2,1,2)+'/'+Copy(pP2,3,2)+'/'+'20'+Copy(pP2,5,2)),2);           // Seta os parâmetros
  end else
  begin
    DLLG2_AdicionaParam(iHd,'ReducaoInicial',pChar(pP1),4);         // Seta os parâmetros
    DLLG2_AdicionaParam(iHd,'ReducaoFinal',pChar(pP2),4);           // Seta os parâmetros
  end;
  //
  DLLG2_ExecutaComando(iHd,'EmiteLeituraMF');                 // Executa a função
  Result := True;
  //
end;


// -------------------------------- //
// Venda do Item                    //
// URANO LOG                            //
// -------------------------------- //
function _ecf12_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String) :Boolean;
var
  I : Integer;
begin
  // ---------------------------- //
  // pP1 -> Código     13 dígitos //
  // pP2 -> Descricão  29 dígitos //
  // pP3 -> ST          2 dígitos //
  // pP4 -> Quantidade  7 dígitos //
  // pP5 -> Unitário    7 dígitos //
  // pP6 -> Medida      2 dígitos //
  // ---------------------------- //
  if Copy(pP3,1,1) = 'F' then pP3 := '-2';     // 42 Substituição
  if Copy(pP3,1,1) = 'I' then pP3 := '-3';     // 38 isenção
  if Copy(pP3,1,1) = 'N' then pP3 := '-4';     // 40 não incidência
  //
  DLLG2_LimpaParams(iHd);                                    // Limpa os parâmetros
//  DLLG2_AdicionaParam(iHd,'AliquotaICMS','True',0);          // Identifica a aliquota como ICMS ('true') ou ISSQN ('false')
  DLLG2_AdicionaParam(iHd,'CodAliquota',pchar(pp3),0);       //	Índice da alíquota
  DLLG2_AdicionaParam(iHd,'CodProduto',pChar(pP1),7);        //	Código do produto
  DLLG2_AdicionaParam(iHd,'NomeProduto',pChar(pP2),7);       // Nome descritivo do produto
  DLLG2_AdicionaParam(iHd,'PrecoUnitario',pChar(FloatToStr(StrToFloat(pP5)/ StrtoInt('1'+Replicate('0',StrToInt(Form1.ConfPreco)) ))),6);     // Preço Unitário.O comando de venda de item trata preços unitários que possuam até 3 casas decimais.
  //
  DLLG2_AdicionaParam(iHd,'Quantidade',pChar(FloatToStr(StrToFloat(pP4)/1000)),6);        // Quantidade envolvida na transação.O comando de venda de item trata quantidades com até 3 casas decimais.
  DLLG2_AdicionaParam(iHd,'Unidade',pChar(pP6),7);           // Unidade do produto. Se não informado será assumido o texto "un" (sem as aspas).
  DLLG2_ExecutaComando(iHd,'VendeItem');                     // Executa a função
  //
  Result := False;
  //
  for I := 1 to 60 do
  begin
    if not Result then
    begin
      if (DLLG2_ObtemCodErro(iHd) = 0) then Result := True       // Verifica se teve erro no retorno
      else
      begin
         Result := False;
         Sleep(1000);
      end;
    end;
  end;
  // TRENDS (01454)32181736 Fabricio //
  // ZPM    (01451)33955713 Vadoski  //
  // URANO  (01451)34628707 Filipe   //
  //
  _ecf12_CodeErro(iHd,'');
  //
  if (StrToInt(pP8) <> 0) or (StrToInt(pP7) <> 0) then
  begin
    //
    DLLG2_LimpaParams(iHd);
    DLLG2_AdicionaParam(iHd,'Cancelar','False',0);     //
    if (StrToInt(pP8) <> 0) then DLLG2_AdicionaParam(iHd,'ValorAcrescimo',pChar( FloatToStr( ( StrToFloat(pP8)/100*-1 ))),6);     // Preço Unitário.O comando de venda de item trata preços unitários que possuam até 3 casas decimais.
    if (StrToInt(pP7) <> 0) then DLLG2_AdicionaParam(iHd,'ValorPercentual',pChar( FloatToStr( ( StrToFloat(pP7)/100*-1 ))),6);     // Preço Unitário.O comando de venda de item trata preços unitários que possuam até 3 casas decimais.
    DLLG2_ExecutaComando(iHd,'AcresceItemFiscal');                                               // Executa a função
    //
    if (DLLG2_ObtemCodErro(iHd) = 0) then Result := True       // Verifica se teve erro no retorno
       else Result := False;
    _ecf12_CodeErro(iHd,'');
    //
  end;
  //
  if not Result then
  begin
    ShowMessage('Quantidade: '+pChar(FloatToStr(StrToFloat(pP4)/1000))+chr(10)+
                'Preço: '+pChar(FloatToStr(StrToFloat(pP5)/ StrtoInt('1'+Replicate('0',StrToInt(Form1.ConfPreco)) ))));
  end;
  //
end;

// -------------------------------- //
// Reducao Z                        //
// URANO LOG                        //
// -------------------------------- //
function _ecf12_ReducaoZ(pP1: Boolean):Boolean;
begin
  //
  DLLG2_LimpaParams(iHd);                                               // Limpa os parâmetros
  DLLG2_ExecutaComando(iHd,'EmiteReducaoZ');                 // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then Result := True       // Verifica se teve erro no retorno
    else Result := False;
  //
  DLLG2_LimpaParams(iHd);                                           // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd,'Avanco',pChar(FAvancoPapel),12);     // Identificação do operador
  DLLG2_ExecutaComando(iHd,'AvancaPapel'); // Executa a função
  //
  if Form1.sCortaPapel = 'Sim' then
  begin
    DLLG2_LimpaParams(iHd);                                          // Limpa os parâmetros
    DLLG2_AdicionaParam(iHd,'TipoCorte','1',12);               //
    DLLG2_ExecutaComando(iHd,'CortaPapel'); // Executa a função
    Form1.Edit1.SetFocus;
  end;
  //
end;

// -------------------------------- //
// Leitura X                        //
// URANO LOG                            //
// -------------------------------- //
function _ecf12_LeituraX(pP1: Boolean):Boolean;
begin
  //
  DLLG2_LimpaParams(iHd);                                    // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd,'Destino','I',7);                  // Seta os parâmetros
  DLLG2_AdicionaParam(iHd,'Operador','',7);                  // Seta os parâmetros
  //
  DLLG2_ExecutaComando(iHd,'EmiteLeituraX');                 // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then Result := True       // Verifica se teve erro no retorno
    else Result := False;
  //
  DLLG2_LimpaParams(iHd);                                           // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd,'Avanco',pChar(FAvancoPapel),12);     // Identificação do operador
  DLLG2_ExecutaComando(iHd,'AvancaPapel'); // Executa a função
  //
  if Form1.sCortaPapel = 'Sim' then
  begin
    DLLG2_LimpaParams(iHd);                                          // Limpa os parâmetros
    DLLG2_AdicionaParam(iHd,'TipoCorte','1',12);               //
    DLLG2_ExecutaComando(iHd,'CortaPapel'); // Executa a função
    Form1.Edit1.SetFocus;
  end;
  //
  // _ecf12_CodeErro(iHd,'');
  //
end;

// ---------------------------------------------- //
// Retorna se o horario de verão está selecionado //
// URANO LOG                                          //
// ---------------------------------------------- //
function _ecf12_RetornaVerao(pP1: Boolean):Boolean;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                         // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeIndicador', 'HorarioVerao', 7);   // Seta os parâmetros
  //
  DLLG2_ExecutaComando(iHd, 'LeIndicador');                       // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                           // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorTextoIndicador', 0, Retorno, sizeof(retorno)); // Obtem o retorno
  end else _ecf12_CodeErro(iHd,'');
  //
  if Copy(Ret1,3,1) = '1' then Result := True else Result := False;
  //
end;

// -------------------------------- //
// Liga ou desliga horário de verao //
// URANO LOG                            //
// -------------------------------- //
function _ecf12_LigaDesLigaVerao(pP1: Boolean):Boolean;
begin
  //
  if (_ecf12_RetornaVerao(True) = True) then
  begin
    DLLG2_LimpaParams(iHd);                                           // Limpa os parâmetros
    DLLG2_AdicionaParam(iHd,'EntradaHV','0',4);                       // Seta os parâmetros
    DLLG2_ExecutaComando(iHd,'AcertaHorarioVerao');                   // Executa a função
  end else
  begin
    DLLG2_LimpaParams(iHd);                                           // Limpa os parâmetros
    DLLG2_AdicionaParam(iHd,'EntradaHV','1',4);                       // Seta os parâmetros
    DLLG2_ExecutaComando(iHd,'AcertaHorarioVerao');                   // Executa a função
  end;
  //
  _ecf12_CodeErro(iHd,'');
  //
  Result := True;
  //
end;

// -------------------------------- //
// Retorna a versão do firmware     //
// URANO LOG                            //
// -------------------------------- //
function _ecf12_VersodoFirmware(pP1: Boolean): String;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                               // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeTexto', 'VersaoSW', 7); // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeTexto');                 // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                 // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorTexto', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := Retorno;
  end else _ecf12_CodeErro(iHd,'');
  //
end;

// -------------------------------- //
// Retorna o número de série        //
// URANO LOG                            //
// -------------------------------- //
function _ecf12_NmerodeSrie(pP1: Boolean): String;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeTexto', 'NumeroSerieECF', 7); // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeTexto');                       // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorTexto', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := Retorno;
  end else _ecf12_CodeErro(iHd,'');
end;

// -------------------------------- //
// Retorna o CGC e IE               //
// URANO LOG                            //
// -------------------------------- //
function _ecf12_CGCIE(pP1: Boolean): String;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeTexto', 'CNPJ', 7);           // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeTexto');                       // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorTexto', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := Retorno;
  end else _ecf12_CodeErro(iHd,'');
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeTexto', 'IE', 7);           // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeTexto');                       // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorTexto', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := Result +Chr(10)+ Retorno;
  end else _ecf12_CodeErro(iHd,'');
  //
end;

// --------------------------------- //
// Retorna o número de cancelamentos //
// URANO LOG                             //
// --------------------------------- //
function _ecf12_Cancelamentos(pP1: Boolean): String;
var
  Retorno: array [0..606] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeDadoMonetario', 'TotalDiaCancelamentosICMS', 7); // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeMoeda');                                          // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                                          // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorMoeda', 0, Retorno, sizeof(retorno));            // Obtem o retorno
    Result := StrZero(StrToFloat(Retorno)*100,14,0);
  end else
  begin
     _ecf12_CodeErro(iHd,'');
     Result := '0';
  end;
  //
  // ShowMessage(Retorno);
  //
end;


// -------------------------------- //
// Retorna o valor de descontos     //
// URANO LOG                            //
// -------------------------------- //
function _ecf12_Descontos(pP1: Boolean): String;
var
  Retorno: array [0..606] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeDadoMonetario', 'TotalDiaDescontos', 7);        // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeMoeda');                                         // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                                         // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorMoeda', 0, Retorno, sizeof(retorno));           // Obtem o retorno
    Result := StrZero(StrToFloat(Retorno)*100,14,0);
  end else
  begin
     _ecf12_CodeErro(iHd,'');
     Result := '0';
  end;
  //
end;

// -------------------------------- //
// Retorna o contados sequencial    //
// URANO LOG                            //
// -------------------------------- //
function _ecf12_ContadorSeqencial(pP1: Boolean): String;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeInteiro', 'COO', 7);          // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeInteiro');                     // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorInteiro', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := StrZero(StrToInt(Retorno),6,0);
  end else
  begin
     _ecf12_CodeErro(iHd,'');
     Result := '000000';
  end;
  //
end;

// -------------------------------- //
// Retorna o número de operações    //
// não fiscais acumuladas           //
// URANO LOG                            //
// -------------------------------- //
function _ecf12_Nmdeoperaesnofiscais(pP1: Boolean): String;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeInteiro', 'GNF', 7);          // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeInteiro');                     // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorInteiro', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := StrZero(StrToInt(Retorno),6,0);
  end else
  begin
     _ecf12_CodeErro(iHd,'');
     Result := '000000';
  end;
  //
end;

function _ecf12_NmdeCuponscancelados(pP1: Boolean): String;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeInteiro', 'CFC', 7);          // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeInteiro');                     // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorInteiro', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := StrZero(StrToInt(Retorno),6,0);
  end else
  begin
     _ecf12_CodeErro(iHd,'');
     Result := '000000';
  end;
  //
end;

function _ecf12_NmdeRedues(pP1: Boolean): String;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeInteiro', 'CRZ', 7);          // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeInteiro');                     // Executa a função
  //
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorInteiro', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := StrZero(StrToInt(Retorno),6,0);
  end else
  begin
     _ecf12_CodeErro(iHd,'');
     Result := '000000';
  end;
  //
  // ShowMessage('Contador de Redução Z (CRZ): '+Result);
  //
end;

function _ecf12_Nmdeintervenestcnicas(pP1: Boolean): String;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeInteiro', 'CRO', 7);          // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeInteiro');                     // Executa a função
  //
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorInteiro', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := StrZero(StrToInt(Retorno),6,0);
  end else
  begin
     _ecf12_CodeErro(iHd,'');
     Result := '000000';
  end;
  //
  // ShowMessage('Contador de Reinício de Operação (Intervenções Técnicas realizadas): '+Result);
  //
end;

// Sandro Silva 2017-10-09  Contador Geral de Relatório Gerencial
function _ecf12_NmContadorGeraldeRelatrioGerencial(pP1: Boolean): String;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeInteiro', 'GRG', 7);          // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeInteiro');                     // Executa a função
  //
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorInteiro', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := StrZero(StrToInt(Retorno),6,0);
  end else
  begin
     _ecf12_CodeErro(iHd,'');
     Result := '000000';
  end;
  //
  // ShowMessage('Contador Geral de Relatório Gerencial: '+Result);
  //
end;

function _ecf12_NmContadordeCuponsFiscal(pP1: Boolean): String;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeInteiro', 'CCF', 7);          // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeInteiro');                     // Executa a função
  //
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorInteiro', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := StrZero(StrToInt(Retorno),6,0);
  end else
  begin
     _ecf12_CodeErro(iHd,'');
     Result := '000000';
  end;
  //
  // ShowMessage('Contador Geral de Relatório Gerencial: '+Result);
  //
end;

// Sandro Silva 2017-10-09 Contador de Cupons Crédito/Débito
function _ecf12_NmContadordeCuponsCrditoDbito(pP1: Boolean): String;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeInteiro', 'CDC', 7);          // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeInteiro');                     // Executa a função
  //
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorInteiro', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := StrZero(StrToInt(Retorno),6,0);
  end else
  begin
     _ecf12_CodeErro(iHd,'');
     Result := '000000';
  end;
  //
  // ShowMessage('Contador Geral de Relatório Gerencial: '+Result);
  //
end;

function _ecf12_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                                       // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeInteiro', 'ContadorProprietarios', 7);          // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeInteiro');                                       // Executa a função
  //
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorInteiro', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := StrZero(StrToInt(Retorno),6,0);
  end else
  begin
     _ecf12_CodeErro(iHd,'');
     Result := '000000';
  end;
  //
end;

function _ecf12_Clichdoproprietrio(pP1: Boolean): String;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                               // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeTexto', 'Cliche', 7); // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeTexto');                 // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                 // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorTexto', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := Retorno;
  end else _ecf12_CodeErro(iHd,'');
  //
end;

// ------------------------------------ //
// Importante retornar apenas 3 dígitos //
// Ex: 001                              //
// URANO LOG                    //
// ------------------------------------ //
function _ecf12_NmdoCaixa(pP1: Boolean): String;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeInteiro', 'ECF', 7);            // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeInteiro');                        // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorInteiro', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := StrZero(StrToInt(Retorno),3,0);
  end else
  begin
     _ecf12_CodeErro(iHd,'');
     Result := '000';
  end;
  //
end;

function _ecf12_Nmdaloja(pP1: Boolean): String;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeInteiro', 'Loja', 7);            // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeInteiro');                        // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorInteiro', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := StrZero(StrToInt(Retorno),3,0);
  end else
  begin
     _ecf12_CodeErro(iHd,'');
     Result := '000';
  end;
  //
end;

function _ecf12_Moeda(pP1: Boolean): String;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeTexto', 'SimboloMoeda', 7);          // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeTexto');                       // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorTexto', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := StrTran(AllTrim(Retorno),'$','');
  end else _ecf12_CodeErro(iHd,'');
  //
end;

// ----------------------------------------- //
// Dia + Mês + Ano + Hora + Minuto + Segundo //
// Ex: 26091976200000                        //
// ----------------------------------------- //
function _ecf12_Dataehoradaimpressora(pP1: Boolean): String;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeData', 'Data', 7);            // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeData');                        // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorData', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := Copy(StrTran(Retorno,'/',''),1,4)+Copy(StrTran(Retorno,'/',''),7,2);
  end else _ecf12_CodeErro(iHd,'');
  //
  DLLG2_LimpaParams(iHd);                                    // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeHora', 'Hora', 7);           // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeHora');                       // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                      // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorHora', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := Result + StrTran(Retorno,':','');
  end else _ecf12_CodeErro(iHd,'');
  //
end;

function _ecf12_Datadaultimareduo(pP1: Boolean): String;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                          // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeData', 'DataAbertura', 7); // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeData');                            // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                            // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorData', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := Retorno;
  end else _ecf12_CodeErro(iHd,'');
  //
  try
    Result := FormatDateTime('dd/mm/yyyy', StrToDate(Result));
  except
    Result := '00/00/2000';
  end;
end;

function _ecf12_Datadomovimento(pP1: Boolean): String;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                          // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeData', 'DataAbertura', 7); // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeData');                            // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                            // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorData', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := Retorno;
  end else _ecf12_CodeErro(iHd,'');
  //
end;

// Deve retornar uma String com:                                          //
// Os 2 primeiros dígitos são o número de aliquotas gravadas: Ex 16       //
// os póximos de 4 em 4 são as aliquotas Ex: 1800                         //
// Ex: 161800120005000000000000000000000000000000000000000000000000000000 //
function _ecf12_RetornaAliquotas(pP1: Boolean): String;
var
  Retorno: array [0..616] of char;
  I : Integer;
begin
  //
  Result := '16';
  //
  for I := 1 to 16 do
  begin
    //
    DLLG2_LimpaParams(iHd);                                                               // Limpa os parâmetros
    DLLG2_AdicionaParam(iHd, 'CodAliquotaProgramavel',pChar(IntToStr(I)),4);              // Seta os parâmetros
    DLLG2_ExecutaComando(iHd, 'LeAliquota');                                              // Executa a função
    //
    if (DLLG2_ObtemCodErro(iHd) = 0)
      then DLLG2_Retorno(iHd, 0, 'PercentualAliquota', 0, Retorno, sizeof(retorno))
        else Retorno := '0000';
    //
    Result := Result + StrZero(StrToFloat(Retorno)*100,4,0);
    //
  end;
  //
  Result := StrTran(Result,'*','0');
  //
  // ShowMessage(REsult);
  //
end;

function _ecf12_Vincula(pP1: String): Boolean;
begin
  Result := True;
end;


function _ecf12_FlagsDeISS(pP1: Boolean): String;
begin
  // ------------------------------------------ //
  // Flags de Vinculação ao ISS                 //
  // (Cada “bit” corresponde a                  //
  // um totalizador.                            //
  // Um “bit” setado indica vinculação ao ISS)  //
  // ------------------------------------------ //
  Result := Chr(0)+chr(0);
end;

function _ecf12_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
begin
  DLLG2_EncerraDriver(ihd);
  Result := True;
end;

function _ecf12_MudaMoeda(pP1: String): Boolean;
begin
  Result := True;
end;

function _ecf12_MostraDisplay(pP1: String): Boolean;
begin
  Result := True;
end;

function _ecf12_leituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
var
  Retorno: array [0..400] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                    // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd,'Destino','S',7);                  // Seta os parâmetros
  DLLG2_AdicionaParam(iHd,'Operador','1',7);             // Seta os parâmetros
//  DLLG2_AdicionaParam(iHd,'LeituraSimplificada','False',0);  // Seta os parâmetros
//  DLLG2_SetaArquivoLog('RETORNO.TXT');
  //
  if Length(pP2) = 6 then
  begin
    DLLG2_AdicionaParam(iHd,'DataInicial',pChar(Copy(pP2,1,2)+'/'+Copy(pP2,3,2)+'/'+'20'+Copy(pP2,5,2)),2);         // Seta os parâmetros
    DLLG2_AdicionaParam(iHd,'DataFinal',pChar(Copy(pP3,1,2)+'/'+Copy(pP3,3,2)+'/'+'20'+Copy(pP3,5,2)),2);           // Seta os parâmetros
  end else
  begin
    DLLG2_AdicionaParam(iHd,'ReducaoInicial',pChar(pP2),4);         // Seta os parâmetros
    DLLG2_AdicionaParam(iHd,'ReducaoFinal',pChar(pP3),4);           // Seta os parâmetros
  end;
  //
  // URANO  (01451)34628707 Filipe   //
  //
  DLLG2_ExecutaComando(iHd,'EmiteLeituraMF');                 // Executa a função
  //
  //
  DeleteFile(pP1);   // Apaga o arquivo anterior
  AssignFile(Form1.F,pP1);
  Rewrite(Form1.F);           // Abre para gravação
  //
  Retorno := '<INICIO>';
  while AllTrim(Retorno) <> '' do
  begin
    Retorno := '';
    DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
    DLLG2_ExecutaComando(iHd,'LeImpressao');
    if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
    begin
      DLLG2_Retorno(iHd, 0, 'TextoImpressao', 0, Retorno, sizeof(retorno)); // Obtem o retorno
      Writeln(Form1.F,StrTran(Retorno,chr(13),Chr(10)));
    end;
  end;
  CloseFile(Form1.F);  // Fecha o arquivo
  //
  // ShowMessage('O seguinte arquivo foi gravado: '+pP1);
  //
  // CopyFile(pChar('RETORNO.TXT'),pChar(pP1),True);
  //
  Result := True;
  //
end;

function _ecf12_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean;
var
  iRetorno, J, I : Integer;
begin
  //
//  sleep(3000);
  //
  begin
    //
    Estado := ' ';
    //
    DLLG2_LimpaParams(iHd);                                          // Limpa os parâmetros
    //
    if Form1.ibDataSet25ACUMULADO1.AsFloat <> 0 then
    begin
      DLLG2_AdicionaParam(iHd,'NomeMeioPagamento',pchar(AllTrim(Form2.Label9.Caption)),7);  // Cheque
      DLLG2_AdicionaParam(iHd,'Valor',pChar(Form1.ibDataSet25ACUMULADO1.AsString),6);           // Valor da operação.Indica o montante pago com o Meio de Pagamento informado.
      Form1.Label13.Hint := AllTrim(Form2.Label9.Caption);
    end;
    if Form1.ibDataSet25PAGAR.AsFloat <> 0 then
    begin
      DLLG2_AdicionaParam(iHd,'NomeMeioPagamento',pchar(AllTrim(Form2.Label8.Caption)),7);  // Cartão
      DLLG2_AdicionaParam(iHd,'Valor',pChar(Form1.ibDataSet25Pagar.AsString),6);                // Valor da operação.Indica o montante pago com o Meio de Pagamento informado.
      Form1.Label13.Hint := AllTrim(Form2.Label8.Caption);
    end;
    if Form1.ibDataSet25DIFERENCA_.AsFloat <> 0 then
    begin
      DLLG2_AdicionaParam(iHd,'NomeMeioPagamento',pchar(AllTrim(Form2.Label17.Caption)),7); // Prazo
      DLLG2_AdicionaParam(iHd,'Valor',pChar(Form1.ibDataSet25DIFERENCA_.AsString),6);           // Valor da operação.Indica o montante pago com o Meio de Pagamento informado.
      Form1.Label13.Hint := AllTrim(Form2.Label17.Caption);
    end;
    //
    DLLG2_ExecutaComando(iHd,'AbreCreditoDebito');                   // Executa a função
    iRetorno := DLLG2_ObtemCodErro(iHd);
    //
    Form1.Label13.Hint := Form1.Label13.Hint + ' ' + intToStr(iRetorno);
    //
    J := 1;
    for I := 1 to Length(sP1) do
    begin
      if iRetorno = 0 then
      begin
        if (Copy(sP1,I,1) = Chr(10)) or (I-J>=47) then // Linha pode ter no maximo 40 caracteres;
        begin
          DLLG2_LimpaParams(iHd);                                            // Limpa os parâmetros
          DLLG2_AdicionaParam(iHd,'TextoLivre',pChar(Copy(sP1,J,I-J)+' '),7);//
          DLLG2_ExecutaComando(iHd,'ImprimeTexto');                          // Executa a função
          iRetorno := DLLG2_ObtemCodErro(iHd);
          J := I + 1;
        end;
      end;
    end;
    //
    if iRetorno = 0 then
    begin
      DLLG2_LimpaParams(iHd);                                           // Limpa os parâmetros
      DLLG2_ExecutaComando(iHd,'EncerraDocumento');                     // Executa a função
      iRetorno := DLLG2_ObtemCodErro(iHd);
    end;
    //
    if iRetorno = 0 then Result := True else Result := False;
    //
    DLLG2_LimpaParams(iHd);                                           // Limpa os parâmetros
    DLLG2_AdicionaParam(iHd,'Avanco',pChar(FAvancoPapel),12);     // Identificação do operador
    DLLG2_ExecutaComando(iHd,'AvancaPapel'); // Executa a função
    //
    if Form1.sCortaPapel = 'Sim' then
    begin
      DLLG2_LimpaParams(iHd);                                          // Limpa os parâmetros
      DLLG2_AdicionaParam(iHd,'TipoCorte','1',12);               //
      DLLG2_ExecutaComando(iHd,'CortaPapel'); // Executa a função
      Form1.Edit1.SetFocus;
    end;
    //
  end;
  //
  //
end;

function _ecf12_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
var
  iRetorno, I, iI : Integer;
  sLinha : String;
begin
  //
  begin
    //
    Estado := ' ';
    //
    DLLG2_LimpaParams(iHd);                                          // Limpa os parâmetros
    //
    if Pos('IDENTIFICAÇÃO DO PAF-ECF',sP1)<>0 then
    begin
      DLLG2_AdicionaParam(iHd,'CodGerencial','1',4);  // Identificação do PAF
    end else
    begin
      if Pos('Período Solicitado: de',sP1)<>0 then
      begin
        DLLG2_AdicionaParam(iHd,'CodGerencial','4',4);  // Meios de pagamento
      end else
      begin
        if (Pos('Documento: ',sP1)<>0) or (Pos(TITULO_PARCELAS_CARNE_RESUMIDO, sP1) > 0) then  // Sandro Silva 2018-04-29  if Pos('Documento: ',sP1)<>0 then
        begin
          DLLG2_AdicionaParam(iHd,'CodGerencial','2',4); // Venda a prazo
        end else
        begin
          if Pos('DAV EMITIDOS',sP1)<>0 then
          begin
            DLLG2_AdicionaParam(iHd,'CodGerencial','5',4); // DAV Emitidos
          end else
          begin
            if Pos('AUXILIAR DE VENDA (DAV) - OR',sP1)<>0 then
            begin
              DLLG2_AdicionaParam(iHd,'CodGerencial','6',4); // Orçamento (DAV)
            end else
            begin
              if Pos('CONFERENCIA DE CONTA',sP1)<>0 then
              begin
                DLLG2_AdicionaParam(iHd,'CodGerencial','7',4); // Conferencia de conta
              end else
              begin
                if Pos('TRANSFERENCIAS ENTRE CONTA',sP1)<>0 then
                begin
                  DLLG2_AdicionaParam(iHd,'CodGerencial','8',4); // Transferencia entre CONTAS
                end else
                begin
                  // Sandro Silva 2016-02-04 POLIMIG  if (Pos('CONTAS DE CLIENTES ABERTAS',sP1)<>0) or (Pos('CONTAS DE CLIENTES OS ABERTAS',sP1)<>0) or (Pos('NENHUMA',sP1)<>0) then
                  if (Pos('CONTAS DE CLIENTES ABERTAS',sP1)<>0)
                    or (Pos('CONTAS DE CLIENTES OS ABERTAS',sP1)<>0)
                    or ((Pos('NENHUMA',sP1)<>0) and (Pos('CONTA DE CLIENTE',sP1)<>0)) then
                  begin
                    DLLG2_AdicionaParam(iHd,'CodGerencial','9',4); // CONTAS ABERTAS
                  end else
                  begin
                    if Pos('CONFERENCIA DE MESA',sP1)<>0 then
                    begin
                      DLLG2_AdicionaParam(iHd,'CodGerencial','10',4); // CONF MESA
                    end else
                    begin
                      if Pos('TRANSFERENCIAS ENTRE MESA',sP1)<>0 then
                      begin
                        DLLG2_AdicionaParam(iHd,'CodGerencial','11',4); // TRANSF MESA
                      end else
                      begin
                        // Sandro Silva 2016-02-04 POLIMIG  if Pos('MESAS ABERTAS',sP1)<>0 then
                        if (Pos('MESAS ABERTAS',sP1)<>0) or
                         (Pos('NENHUMA MESA',sP1)<>0) then
                        begin
                          DLLG2_AdicionaParam(iHd,'CodGerencial','12',4); // Mesas Abertas
                        end else
                        begin
                          if Pos('Parametros de Configuracao',sP1)<>0 then
                          begin
                            DLLG2_AdicionaParam(iHd,'CodGerencial','13',4); // Parâmetros de Configuração
                          end else
                          begin
                            DLLG2_AdicionaParam(iHd,'CodGerencial','3',4); // CARTAO TEP
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
    DLLG2_ExecutaComando(iHd,'AbreGerencial');                   // Executa a função
    //
    iRetorno := DLLG2_ObtemCodErro(iHd);
    //
    for iI := 1 to 1 do
    begin
      sLinha := '';
      //
      for I := 1 to Length(sP1) do
      begin
       if iRetorno = 0 then
       begin
          //
          if (Copy(sP1,I,1) = chr(10)) or ( Length(sLinha) >=47 ) then // Linha pode ter no maximo 47 caracteres;
          begin
            //
            if (Copy(sP1,I,1) <> chr(10)) then sLinha := sLinha+Copy(sP1,I,1);
            //
            if sLinha = '' then sLinha:=' ';
            //
            DLLG2_LimpaParams(iHd);                                          // Limpa os parâmetros
            DLLG2_AdicionaParam(iHd,'TextoLivre',pChar(ConverteAcentos(sLinha)),7);
            DLLG2_ExecutaComando(iHd,'ImprimeTexto');                   // Executa a função
            iRetorno := DLLG2_ObtemCodErro(iHd);
            sLinha:='';
            //
          end else
          begin
            sLinha := sLinha+Copy(sP1,I,1);
          end;
          //
       end;
      end;
      //
      for I := 1 to 7 do
      begin
        if iRetorno = 0 then
        begin
          DLLG2_LimpaParams(iHd);                                          // Limpa os parâmetros
          DLLG2_AdicionaParam(iHd,'TextoLivre',' ',7);
          DLLG2_ExecutaComando(iHd,'ImprimeTexto');                   // Executa a função
          iRetorno := DLLG2_ObtemCodErro(iHd);
        end;
      end;
      //
      if iRetorno = 0 then sleep(4000); // Da um tempo;
      //
    end;
    //
    if iRetorno = 0 then
    begin
      DLLG2_LimpaParams(iHd);                                           // Limpa os parâmetros
      DLLG2_ExecutaComando(iHd,'EncerraDocumento');                     // Executa a função
      iRetorno := DLLG2_ObtemCodErro(iHd);
    end;
    //
    if iRetorno = 0 then Result := True else Result := False;
    //
    //
    DLLG2_LimpaParams(iHd);                                           // Limpa os parâmetros
    DLLG2_AdicionaParam(iHd,'Avanco',pChar(FAvancoPapel),12);     // Identificação do operador
    DLLG2_ExecutaComando(iHd,'AvancaPapel'); // Executa a função
    //
    if Form1.sCortaPapel = 'Sim' then
    begin
      DLLG2_LimpaParams(iHd);                                          // Limpa os parâmetros
      DLLG2_AdicionaParam(iHd,'TipoCorte','1',12);               //
      DLLG2_ExecutaComando(iHd,'CortaPapel'); // Executa a função
      Form1.Edit1.SetFocus;
    end;
    //
  end;
  //
end;

function _ecf12_FechaCupom2(sP1: Boolean): Boolean;
begin
  //
  DLLG2_LimpaParams(iHd);                                           // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd,'Operador','1',7);     // Identificação do operador
  DLLG2_ExecutaComando(iHd,'EncerraDocumento');                     // Executa a função
  Result := True;
  //
end;

function _ecf12_ImprimeCheque(rP1: Real; sP2: String): Boolean;
begin
  Result := False;
end;

function _ecf12_GrandeTotal(sP1: Boolean): String;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeDadoMonetario', 'GT', 7);     // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeMoeda');                       // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorMoeda', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    try
//       Result := StrZero( StrToFloat(Retorno)*100 ,18,0);
       Result := StrZero( StrToFloat(LimpaNumeroDeixandoAVirgula(Retorno))*100,18,0);
    except
       Result := '000000000000000000';
       ShowMessage('Erro de retorno de GT: '+ Chr(10)+Chr(10)+ retorno );
    end;
  end else
  begin
     _ecf12_CodeErro(iHd,'');
     Result := '000000000000000000';
  end;
  //
end;

function _ecf12_TotalizadoresDasAliquotas(sP1: Boolean): String;
var
  Retorno: array [0..616] of char;
  I : Integer;
begin
  //
  Result := '';
  //
  for I := 1 to 15 do
  begin
    DLLG2_AdicionaParam(iHd, 'NomeDadoMonetario', pChar('TotalDiaValorAliquota['+StrZero(I,2,0)+']'),7); // Seta os parâmetros
    DLLG2_ExecutaComando(iHd, 'LeMoeda');                                                      // Executa a função
    if (DLLG2_ObtemCodErro(iHd) = 0) then                                                     // Verifica se teve erro no retorno
    begin                                                                                    //
      DLLG2_Retorno(iHd, 0, 'ValorMoeda', 0, Retorno, sizeof(retorno));                     // Obtem o retorno
      Result := Result + StrZero(StrToFloat(Retorno)*100,14,0);
    end else
    begin
       _ecf12_CodeErro(iHd,'');
       Result := Replicate('0',15*14);
    end;
   end;
   //
   Result := Result + '00000000000000'; // Aliquota 16
   //
   // Isencao
   //
   Retorno := '0';
   DLLG2_LimpaParams(iHd);                                                       // Limpa os parâmetros
   DLLG2_AdicionaParam(iHd, 'NomeDadoMonetario', 'TotalDiaIsencaoICMS', 7);      // Seta os parâmetros
   DLLG2_ExecutaComando(iHd, 'LeMoeda');                                         // Executa a função
   if (DLLG2_ObtemCodErro(iHd) = 0) then DLLG2_Retorno(iHd, 0, 'ValorMoeda', 0, Retorno, sizeof(retorno));
   Result := Result + StrZero(StrToFloat(Retorno)*100,14,0);
   //
   // Não tributados
   //
   Retorno := '0';
   DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
   DLLG2_AdicionaParam(iHd, 'NomeDadoMonetario', 'TotalDiaNaoTributadoICMS', 7);        // Seta os parâmetros
   DLLG2_ExecutaComando(iHd, 'LeMoeda');                                         // Executa a função
   if (DLLG2_ObtemCodErro(iHd) = 0) then DLLG2_Retorno(iHd, 0, 'ValorMoeda', 0, Retorno, sizeof(retorno));
   Result := Result + StrZero(StrToFloat(Retorno)*100,14,0);
   //
   // Substituição
   //
   Retorno := '0';
   DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
   DLLG2_AdicionaParam(iHd, 'NomeDadoMonetario', 'TotalDiaSubstituicaoTributariaICMS', 7);        // Seta os parâmetros
   DLLG2_ExecutaComando(iHd, 'LeMoeda');                                         // Executa a função
   if (DLLG2_ObtemCodErro(iHd) = 0) then DLLG2_Retorno(iHd, 0, 'ValorMoeda', 0, Retorno, sizeof(retorno));
   Result := Result + StrZero(StrToFloat(Retorno)*100,14,0);
   //
end;

function _ecf12_CupomAberto(sP1: Boolean): boolean;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeInteiro', 'EstadoFiscal', 7);            // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeInteiro');                     // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
    DLLG2_Retorno(iHd, 0, 'ValorInteiro', 0, Retorno, sizeof(retorno)); // Obtem o retorno
  //
  if (AllTrim(Retorno) >= '2') then Result := True else Result := False;
  //
end;

function _ecf12_FaltaPagamento(sP1: Boolean): boolean;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                                // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeInteiro', 'EstadoFiscal', 7);            // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeInteiro');                     // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
    DLLG2_Retorno(iHd, 0, 'ValorInteiro', 0, Retorno, sizeof(retorno)); // Obtem o retorno
  //
  if (AllTrim(Retorno) >= '4') then Result := True else Result := False;
  //
end;


//
// PAF
//

function _ecf12_Marca(sP1: Boolean): String;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeTexto', 'Marca', 7);         // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeTexto');                       // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorTexto', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := Retorno;
  end else _ecf12_CodeErro(iHd,'');
  //
end;

function _ecf12_Modelo(sP1: Boolean): String;
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeTexto', 'Modelo', 7);         // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeTexto');                       // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorTexto', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := Retorno;
  end else _ecf12_CodeErro(iHd,'');
  //
end;

function _ecf12_Tipodaimpressora(pP1: Boolean): String; //
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeTexto', 'TipoECF', 7);         // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeTexto');                       // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorTexto', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := Retorno;
  end else _ecf12_CodeErro(iHd,'');
  //
end;

function _ecf12_VersaoSB(pP1: Boolean): String; //
var
  Retorno: array [0..255] of char;
begin
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeTexto', 'VersaoSW', 7);         // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeTexto');                       // Executa a função
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorTexto', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    Result := Retorno;
  end else _ecf12_CodeErro(iHd,'');
  //
end;

function _ecf12_HoraIntalacaoSB(pP1: Boolean): String; //
begin
  Result := '153025';
end;

function _ecf12_DataIntalacaoSB(pP1: Boolean): String; //
begin
  Result := '19052008';
end;

function _ecf12_ProgramaAplicativo(sP1: Boolean): boolean;
begin
  Result := True;
end;



function _ecf12_DadosDaUltimaReducao(pP1: Boolean): String; //
var
  Retorno: array [0..4000] of char;
  sRetorno : String;
begin
  //
  DLLG2_LimpaParams(iHd);                               // Limpa os parâmetros
  DLLG2_AdicionaParam(iHd, 'NomeTexto', 'DadosUltimaReducaoZ', 7); // Seta os parâmetros
  DLLG2_ExecutaComando(iHd, 'LeTexto');                 // Executa a função
  //
  if (DLLG2_ObtemCodErro(iHd) = 0) then                 // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorTexto', 0, Retorno, sizeof(retorno)); // Obtem o retorno
    sRetorno := Retorno;
  end else
  begin
     _ecf12_CodeErro(iHd,'');
     sRetorno := Replicate(' ',631);
  end;
  //
//   1,	  2 Constante “00” 2
//   3,	 18 GT da última Redução 18
//  21,	 14 Cancelamentos 14
//  35,	 14 Descontos 14
//  49,  64 Tributos 64
// 113,	224 Totalizadores Parciais Tributados 266
// 337,  14 Totalizador de isenção de ICMS
// 351,  14 Totalizador de não incidência de ICMS
// 365,  14 Totalizador de substituição tributária de ICMS
// 379,	 14 Sangria 14
// 393,	 14 Suprimentos 14
// 407,	126 Totalizadores não sujeitos ao ICMS 126
// 533,	 36 Contadores dos Totalizadores Parciais Tributados não sujeitos ao ICMS 36
// 569,	  6 Contador de Ordem de Operação (COO) 6
// 575,	  6 Contador de Operações não sujeitas ao ICMS 6
// 581,	  2 Número de Alíquotas Cadastradas 2
// 583,	  6 Data de Movimento 6
// 589,  14 Acréscimo 14
// 603,  14 Acréscimo Financeiro 14
  //
  Result :=  Copy(sRetorno,583,6)+ //   1,  6 Data
             Copy(sRetorno,569,6)+ //   7,  6 COO
             Copy(sRetorno, 3,18)+ //  13, 18 GT
     StrZero(StrToInt(_ecf12_NmdeRedues(True)),4,0) + //  31,  4 CRZ
      Copy(Form1.sAliquotas,3,64)+ //  35, 64 Aliquotas
          Copy(sRetorno, 127,224)+ //  99,224 Totalizadores das aliquotas
     StrZero(StrToInt(_ecf12_Nmdeintervenestcnicas(True)),4,0)+ // 323,  4 Contador de reinício de operação
            //
            Copy(sRetorno, 21, 14)+ // 327, 14 Totalizador de cancelamentos em ICMS
            Copy(sRetorno, 35, 14)+ // 341, 14 Totalizador de descontos em ICMS
            //
            Copy(sRetorno,351, 14)+ // 355, 14 Totalizador de isenção de ICMS
            Copy(sRetorno,365, 14)+ // 369, 14 Totalizador de não incidência de ICMS
            Copy(sRetorno,337, 14)+ // 383, 14 Totalizador de substituição tributária de ICMS
            '';
  //
  // Ok testado
  //
end;

//
// Retorna o Código do Modelo do ECF Conf Tabéla Nacional de Identificação do ECF
//
function _ecf12_CodigoModeloEcf(pP1: Boolean): String; //
begin
  Result := '492601';
  if Form1.sCodigoIdentificaEcf <> '' then
    Result := Form1.sCodigoIdentificaEcf;
end;


end.



