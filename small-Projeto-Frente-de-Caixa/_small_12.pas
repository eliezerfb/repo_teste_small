{
Altera��es
Sandro Silva 2016-02-04
- Fiscal de AL exigiu que o nome do relat�rio seja conforme er, podendo abreviar mas n�o suprimir por completo ou incluir texto

Sandro Silva 2024-03-15
- Compatibilizado para compilar com Delphi 11, mas falta testar com ECF

}
unit _Small_12;

interface

uses

  Windows, Messages, SmallFunc_xe, Fiscal, SysUtils,Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Variants, ExtCtrls, Mask, Grids, DBGrids, DB
  , DBCtrls, SMALL_DBEdit, IniFiles, Unit2, Unit22, Unit7;

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

  function  DLLG2_DefineTimeout(MHandle: integer; TempoMaximo: integer): integer; stdcall; external 'DLLG2.DLL';
  function  DLLG2_LeTimeout(Porta: Integer): Integer; stdcall; external 'dllg2.dll';
  function  DLLG2_IniciaDriver(porta: PAnsiChar): integer; stdcall; external 'DLLG2.DLL';
  function  DLLG2_EncerraDriver(MHandle: integer): integer; stdcall; external 'DLLG2.DLL';
  function  DLLG2_Versao(Versao: PAnsiChar; TamVersao: integer): PAnsiChar; stdcall; external 'DLLG2.DLL';
  function  DLLG2_SetaArquivoLog(NomeArquivoLog: PAnsiChar):integer; stdcall;external 'DLLG2.DLL'; // Sandro Silva 2023-12-13 function  DLLG2_SetaArquivoLog(NomeArquivoLog: Pchar):integer; stdcall;external 'DLLG2.DLL';
  function  DLLG2_LimpaParams(MHandle:integer):integer; stdcall;external 'DLLG2.DLL';
  function  DLLG2_AdicionaParam(MHandle:integer; NomePar: PAnsiChar; VlrPar: PAnsiChar; TipoPar: integer): integer; stdcall; external 'DLLG2.DLL'; // Sandro Silva 2023-12-13 function  DLLG2_AdicionaParam(MHandle:integer;NomePar:Pchar;VlrPar:Pchar;TipoPar:integer):integer; stdcall;external 'DLLG2.DLL';
  function  DLLG2_ExecutaComando(MHandle:integer; Comando: PAnsiChar): integer; stdcall; external 'DLLG2.DLL'; // Sandro Silva 2023-12-13 function  DLLG2_ExecutaComando(MHandle:integer;Comando:pchar):integer; stdcall;external 'DLLG2.DLL';
  function  DLLG2_ObtemCodErro(MHandle: integer):integer;stdcall;external 'DLLG2.DLL';
  function  DLLG2_Retorno(MHandle,Indice: integer; NomeRetorno: PAnsiChar;TamNomeRetorno: integer; VlrRetorno: PAnsiChar; TamVlrRetorno: integer): integer; stdcall; external 'DLLG2.DLL'; // Sandro Silva 2023-12-13 function  DLLG2_Retorno(MHandle,Indice:integer;NomeRetorno:pchar;TamNomeRetorno:integer;VlrRetorno:pchar;TamVlrRetorno:integer):integer; stdcall;external 'DLLG2.DLL';
  function  DLLG2_ObtemNomeErro(MHandle: integer; NomeErro: PAnsiChar; TamNomeErro: integer): PAnsiChar; stdcall; external 'DLLG2.DLL'; // Sandro Silva 2023-12-13 function  DLLG2_ObtemNomeErro(MHandle:integer;NomeErro:pchar;TamNomeErro:integer):pchar; stdcall;external 'DLLG2.DLL';
  function  DLLG2_ObtemCircunstancia(MHandle: integer; Circunstancia: PAnsiChar; TamNomeCircus: integer): PAnsiChar; stdcall; external 'DLLG2.DLL'; // Sandro Silva 2023-12-13 function  DLLG2_ObtemCircunstancia(MHandle:integer;Circunstancia:pchar;TamNomeCircus:integer):pchar; stdcall;external 'DLLG2.DLL';
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
  {Sandro Silva 2023-12-13 inicio
  nomeerro: array [0..255] of char;
  circunstancia: array [0..255] of char;
  Retorno: array [0..255] of char;
  }
  {
  nomeerro: array [0..255] of AnsiChar;
  circunstancia: array [0..255] of AnsiChar;
  Retorno: array [0..255] of AnsiChar;
  }
  nomeerro: AnsiString;
  circunstancia: AnsiString;
  Retorno: AnsiString;
begin
  //
  nomeerro := Replicate(' ', 255);
  circunstancia := Replicate(' ', 255);
  Retorno := Replicate(' ', 255);

  if (DLLG2_ObtemCodErro(iHd) <> 0) then
  begin
    DLLG2_ObtemNomeErro(iHd, PAnsiChar(AnsiString(nomeerro)), sizeof(nomeerro));
    DLLG2_ObtemCircunstancia(iHd, PAnsiChar(AnsiString(circunstancia)), sizeof(circunstancia));
    application.MessageBox(pchar(nomeerro + ' - ' + circunstancia), 'Logger - Erro', MB_ICONERROR);
    Result := 255;
  end else
  begin
    DLLG2_LimpaParams(iHd);                                                    // Limpa os par�metros
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeIndicador')), PAnsiChar(AnsiString('SensorPoucoPapel')), 7);          // Seta os par�metros
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeIndicador')));                                  // Executa a fun��o
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorTextoIndicador')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
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
// a impressora est� conectada //
// URANO LOG                   //
// --------------------------- //
// Sandro Silva 2016-04-02  function _ecf12_Inicializa(Pp1: String; iTimeOutDLLG2: Integer): Boolean;
function _ecf12_Inicializa(Pp1: String): Boolean;
var
  I : Integer;
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Result := False;
  Form1.sPorta := pP1;

  FAvancoPapel := Form1.sAvancoPapel; // Sandro Silva 2016-08-26  Padr�o 200
  Retorno := Replicate(' ', 255);

  //
  for I := 1 to 3 do
  begin
    if Length(AllTrim(Retorno)) <> 10 then
    begin
      iHd := DLLG2_IniciaDriver(PAnsiChar(AnsiString(pP1))); // Sandro Silva 2023-12-13 iHd := DLLG2_IniciaDriver(pChar(pP1));
      {Sandro Silva 2016-02-18 inicio}
      if Form1.iTimeOutDLLG2 > 5 then
        DLLG2_DefineTimeout(iHd, Form1.iTimeOutDLLG2);
      {Sandro Silva 2016-02-18 final}
      DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
      DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeData')), PAnsiChar(AnsiString('Data')), 7);            // Seta os par�metros
      DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeData')));                        // Executa a fun��o
      DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorData')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
    end;
  end;
  //
  if Length(AllTrim(Retorno)) <> 10 then
  begin
    if Form22.Label6.Caption = 'Detectando porta de comunica��o...' then
    begin
      for I := 1 to 7 do
      begin
        if Length(AllTrim(Retorno)) <> 10 then
        begin
          Result := False;
          ShowMessage('FIT LOGGER'+Chr(10)+'Testando COM'+StrZero(I,1,0)+chr(10)+chr(10)+'Data: '+Retorno);
          iHd := DLLG2_IniciaDriver(PAnsiChar(AnsiString('COM'+StrZero(I,1,0)))); // Sandro Silva 2023-12-13 iHd := DLLG2_IniciaDriver(pChar('COM'+StrZero(I,1,0)));
          {Sandro Silva 2016-02-18 inicio}
          if Form1.iTimeOutDLLG2 > 5 then
            DLLG2_DefineTimeout(iHd, Form1.iTimeOutDLLG2);
          {Sandro Silva 2016-02-18 final}
          DLLG2_LimpaParams(iHd);                                          // Limpa os par�metros
          DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeData')), PAnsiChar(AnsiString('Data')), 7);                 // Seta os par�metros
          DLLG2_ExecutaComando(iHd, 'LeData');                             // Executa a fun��o
          DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorData')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
          Form1.sPorta  := 'COM'+StrZero(I,1,0);
        end else Result := True;
      end;
     end;
  end else Result := True;
  //
  // Nomeia relat�rios gerenciais
  //
  try
    DLLG2_LimpaParams(iHd);                                                              // Limpa os par�metros.
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('1')), 4);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('DescricaoGerencial')), PAnsiChar(AnsiString('IDENT DO PAF')), 7);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeGerencial')), PAnsiChar(AnsiString('IDENT DO PAF')), 7);
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('DefineGerencial')));
  except end;
  try
    DLLG2_LimpaParams(iHd);                                                              // Limpa os par�metros.
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('2')), 4);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('DescricaoGerencial')), PAnsiChar(AnsiString('VENDA PRAZO')), 7);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeGerencial')), PAnsiChar(AnsiString('VENDA PRAZO')), 7);
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('DefineGerencial')));
  except end;
  {Sandro Silva 2016-02-04 inicio
  try
    DLLG2_LimpaParams(iHd);                                                              // Limpa os par�metros.
    DLLG2_AdicionaParam(iHd,'CodGerencial','3',4);
    DLLG2_AdicionaParam(iHd,'DescricaoGerencial','TEF',7);
    DLLG2_AdicionaParam(iHd,'NomeGerencial','TEF',7);
    DLLG2_ExecutaComando(iHd,'DefineGerencial');
  except end;
  }
  try
    DLLG2_LimpaParams(iHd);                                                              // Limpa os par�metros.
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('3')), 4);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('DescricaoGerencial')), PAnsiChar(AnsiString('CARTAO TEF')), 7);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeGerencial')), PAnsiChar(AnsiString('CARTAO TEF')), 7);
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('DefineGerencial')));
  except end;
  {Sandro Silva 2016-02-04 final}
  try
    DLLG2_LimpaParams(iHd);                                                              // Limpa os par�metros.
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('4')), 4);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('DescricaoGerencial')), PAnsiChar(AnsiString('MEIOS DE PAGTO')), 7);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeGerencial')), PAnsiChar(AnsiString('MEIOS DE PAGTO')), 7);
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('DefineGerencial')));
    DLLG2_LimpaParams(iHd);                                                              // Limpa os par�metros.
  except end;
  try
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('5')), 4);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('DescricaoGerencial')), PAnsiChar(AnsiString('DAV Emitidos')), 7);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeGerencial')), PAnsiChar(AnsiString('DAV Emitidos')), 7);
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('DefineGerencial')));
  except end;
  try
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('6')), 4);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('DescricaoGerencial')), PAnsiChar(AnsiString('Or�amento (DAV)')), 7);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeGerencial')), PAnsiChar(AnsiString('Or�amento (DAV)')), 7);
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('DefineGerencial')));
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
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('7')), 4);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('DescricaoGerencial')), PAnsiChar(AnsiString('CONF CONTA CLI')), 7); // 2016-02-04 Fiscal de AL exigiu que o nome do relat�rio seja conforme er, podendo abreviar mas n�o suprimir por completo ou incluir texto
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeGerencial')), PAnsiChar(AnsiString('CONF CONTA CLI')), 7);
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('DefineGerencial')));
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
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('8')), 4);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('DescricaoGerencial')), PAnsiChar(AnsiString('TRANSF CONT CLI')), 7); // 2016-02-11 Fiscal de AL exigiu que o nome do relat�rio seja conforme er, podendo abreviar mas n�o suprimir por completo ou incluir texto
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeGerencial')), PAnsiChar(AnsiString('TRANSF CONT CLI')), 7);
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('DefineGerencial')));
  except end;
  try
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('9')), 4);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('DescricaoGerencial')), PAnsiChar(AnsiString('CONT CLI ABERTA')), 7); // 2016-02-11 Fiscal de AL exigiu que o nome do relat�rio seja conforme er, podendo abreviar mas n�o suprimir por completo ou incluir texto
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeGerencial')), PAnsiChar(AnsiString('CONT CLI ABERTA')), 7);
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('DefineGerencial')));
  except end;
  {Sandro Silva 2016-02-11 final}
  try
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('10')), 4);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('DescricaoGerencial')), PAnsiChar(AnsiString('CONF MESA')), 7);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeGerencial')), PAnsiChar(AnsiString('CONF MESA')), 7);
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('DefineGerencial')));
  except end;
  try
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('11')), 4);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('DescricaoGerencial')), PAnsiChar(AnsiString('TRANSF MESA')), 7);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeGerencial')), PAnsiChar(AnsiString('TRANSF MESA')), 7);
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('DefineGerencial')));
  except end;
  try
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('12')), 4);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('DescricaoGerencial')), PAnsiChar(AnsiString('MESAS ABERTAS')), 7);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeGerencial')), PAnsiChar(AnsiString('MESAS ABERTAS')), 7);
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('DefineGerencial')));
  except end;
  try
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('13')), 4);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('DescricaoGerencial')), PAnsiChar(AnsiString('PARAM CONFIG')), 7);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeGerencial')), PAnsiChar(AnsiString('PARAM CONFIG')), 7);
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('DefineGerencial')));
  except end;
  //
end;


// ------------------------------ //
// Fecha o cupom que est� sendo   //
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
      DLLG2_LimpaParams(iHd);                                                                                    // Limpa os par�metros
      DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Cancelar')), PAnsiChar(AnsiString('False')), 0);  // 	Indicador de cancelamento da opera��o.Se este par�metro for informado (='true'), cancela
      DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('ValorAcrescimo')), PAnsiChar(AnsiString(Format('%12.2f',[Form1.ibDataSet25RECEBER.AsFloat-Form1.fTotal]))), 6);  // Valor do desconto (quando negativo) ou acr�scimo (quando positivo).
      DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('AcresceSubtotal')));
    end;
    //
  end else _ecf12_CancelaUltimoCupom(True);// cupom em branco cancela;
  //
  Result := True;
  //
end;

// ------------------------------ //
// Fecha o cupom que est� sendo   //
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
    DLLG2_LimpaParams(iHd);                                                              // Limpa os par�metros.
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeMeioPagamento')), PAnsiChar(AnsiString(AllTrim(Form2.Label9.Caption))), 7); // cheque
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Valor')), PAnsiChar(AnsiString(Form1.ibDataSet25ACUMULADO1.AsString)), 6);          // Valor da opera��o.Indica o montante pago com o Meio de Pagamento informado.
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('PagaCupom')));                     // Executa a fun��o
  end;
  //
  if Form1.ibDataSet25ACUMULADO2.AsFloat <> 0 then
  begin
    DLLG2_LimpaParams(iHd);                                                              // Limpa os par�metros.
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeMeioPagamento')), PAnsiChar(AnsiString(Copy('Dinheiro'+Replicate(' ',16),1,16))), 7);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Valor')), PAnsiChar(AnsiString(Form1.ibDataSet25ACUMULADO2.AsString)), 6);          // Valor da opera��o.Indica o montante pago com o Meio de Pagamento informado.
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('PagaCupom')));
  end;
  //
  if Form1.ibDataSet25PAGAR.AsFloat <> 0 then
  begin
    DLLG2_LimpaParams(iHd);                                                              // Limpa os par�metros.
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeMeioPagamento')), PAnsiChar(AnsiString(AllTrim(Form2.Label8.Caption))), 7); // Cart�o
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Valor')), PAnsiChar(AnsiString(Form1.ibDataSet25Pagar.AsString)), 6);               // Valor da opera��o.Indica o montante pago com o Meio de Pagamento informado.
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('PagaCupom')));                     // Executa a fun��o
  end;
  //
  if Form1.ibDataSet25DIFERENCA_.aSFloat <> 0 then
  begin
    DLLG2_LimpaParams(iHd);                                                               // Limpa os par�metros.
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeMeioPagamento')), PAnsiChar(AnsiString(AllTrim(Form2.Label17.Caption))), 7); // Prazo
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Valor')), PAnsiChar(AnsiString(Form1.ibDataSet25DIFERENCA_.AsString)), 6);           // Valor da opera��o.Indica o montante pago com o Meio de Pagamento informado.
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('PagaCupom')));                     // Executa a fun��o
  end;
  //
  if Form1.ibDataSet25VALOR01.AsFloat    <> 0 then
  begin
    DLLG2_LimpaParams(iHd);                                                       // Limpa os par�metros.
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeMeioPagamento')), PAnsiChar(AnsiString(AllTrim(Form2.Label18.Caption))), 7);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Valor')), PAnsiChar(AnsiString(Form1.ibDataSet25VALOR01.AsString)), 6);   // Valor da opera��o.Indica o montante pago com o Meio de Pagamento informado.
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('PagaCupom')));                     // Executa a fun��o
  end;
  //
  if Form1.ibDataSet25VALOR02.AsFloat    <> 0 then
  begin
    DLLG2_LimpaParams(iHd);                                                       // Limpa os par�metros.
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeMeioPagamento')), PAnsiChar(AnsiString(AllTrim(Form2.Label19.Caption))), 7);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Valor')), PAnsiChar(AnsiString(Form1.ibDataSet25VALOR02.AsString)), 6);   // Valor da opera��o.Indica o montante pago com o Meio de Pagamento informado.
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('PagaCupom')));                     // Executa a fun��o
  end;
  //
  if Form1.ibDataSet25VALOR03.AsFloat    <> 0 then
  begin
    DLLG2_LimpaParams(iHd);                                                       // Limpa os par�metros.
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeMeioPagamento')), PAnsiChar(AnsiString(AllTrim(Form2.Label20.Caption))), 7);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Valor')), PAnsiChar(AnsiString(Form1.ibDataSet25VALOR03.AsString)), 6);   // Valor da opera��o.Indica o montante pago com o Meio de Pagamento informado.
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('PagaCupom')));                     // Executa a fun��o
  end;
  //
  if Form1.ibDataSet25VALOR04.AsFloat    <> 0 then
  begin
    DLLG2_LimpaParams(iHd);                                                       // Limpa os par�metros.
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeMeioPagamento')), PAnsiChar(AnsiString(AllTrim(Form2.Label21.Caption))), 7);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Valor')), PAnsiChar(AnsiString(Form1.ibDataSet25VALOR04.AsString)), 6);   // Valor da opera��o.Indica o montante pago com o Meio de Pagamento informado.
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('PagaCupom')));                     // Executa a fun��o
  end;
  //
  if Form1.ibDataSet25VALOR05.AsFloat    <> 0 then
  begin
    DLLG2_LimpaParams(iHd);                                                       // Limpa os par�metros.
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeMeioPagamento')), PAnsiChar(AnsiString(AllTrim(Form2.Label22.Caption))), 7);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Valor')), PAnsiChar(AnsiString(Form1.ibDataSet25VALOR05.AsString)), 6);   // Valor da opera��o.Indica o montante pago com o Meio de Pagamento informado.
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('PagaCupom')));                     // Executa a fun��o
  end;
  //
  if Form1.ibDataSet25VALOR06.AsFloat    <> 0 then
  begin
    DLLG2_LimpaParams(iHd);                                                       // Limpa os par�metros.
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeMeioPagamento')), PAnsiChar(AnsiString(AllTrim(Form2.Label23.Caption))), 7);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Valor')), PAnsiChar(AnsiString(Form1.ibDataSet25VALOR06.AsString)), 6);   // Valor da opera��o.Indica o montante pago com o Meio de Pagamento informado.
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('PagaCupom')));                     // Executa a fun��o
  end;
  //
  if Form1.ibDataSet25VALOR07.AsFloat    <> 0 then
  begin
    DLLG2_LimpaParams(iHd);                                                       // Limpa os par�metros.
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeMeioPagamento')), PAnsiChar(AnsiString(AllTrim(Form2.Label24.Caption))), 7);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Valor')), PAnsiChar(AnsiString(Form1.ibDataSet25VALOR07.AsString)), 6);   // Valor da opera��o.Indica o montante pago com o Meio de Pagamento informado.
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('PagaCupom')));                     // Executa a fun��o
  end;
  //
  if Form1.ibDataSet25VALOR08.AsFloat    <> 0 then
  begin
    DLLG2_LimpaParams(iHd);                                                       // Limpa os par�metros.
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeMeioPagamento')), PAnsiChar(AnsiString(AllTrim(Form2.Label25.Caption))), 7);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Valor')), PAnsiChar(AnsiString(Form1.ibDataSet25VALOR08.AsString)), 6);   // Valor da opera��o.Indica o montante pago com o Meio de Pagamento informado.
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('PagaCupom')));                     // Executa a fun��o
  end;
  //
  DLLG2_LimpaParams(iHd);                                                        // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('TextoLivre')), PAnsiChar(AnsiString(Alltrim(copy('MD5: '+Form1.sMD5DaLista+Chr(10)+ConverteAcentos2(Form1.sMensagemPromocional)+Replicate(' ',492),1,492)))), 7);
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('ImprimeTexto')));                                      // Executa a fun��o
  //
{
  DLLG2_LimpaParams(iHd);                                           // Limpa os par�metros
  DLLG2_AdicionaParam(iHd,'IdConsumidor',pchar(Alltrim(copy('MD5: '+Form1.sMD5DaLista+chr(10)+ConverteAcentos2(Form1.sMensagemPromocional)+Replicate(' ',492),1,492))),7);     // Identifica��o do operador
  DLLG2_ExecutaComando(iHd,'IdentificaConsumidor');                     // Executa a fun��o
}
  //
  DLLG2_LimpaParams(iHd);                                               // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Operador')), PAnsiChar(AnsiString('')), 7);         // Identifica��o do operador
//  DLLG2_AdicionaParam(iHd,'TextoPromocional',pchar(Alltrim(copy('MD5: '+Form1.sMD5DaLista+Chr(10)+ConverteAcentos(Form1.sMensagemPromocional)+Replicate(' ',492),1,492))),7);
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('EncerraDocumento')));                         // Executa a fun��o
  //
  DLLG2_LimpaParams(iHd);                                           // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Avanco')), PAnsiChar(AnsiString(FAvancoPapel)), 12);
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('AvancaPapel'))); // Executa a fun��o
  //
  if Form1.sCortaPapel = 'Sim' then
  begin
    DLLG2_LimpaParams(iHd);
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('TipoCorte')), PAnsiChar(AnsiString('1')), 12);               //
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('CortaPapel'))); // Executa a fun��o
    Form1.Edit1.SetFocus;
  end;
  //
  Result := True;
  //
end;

// ------------------------------ //
// URANO LOG                      //
// cancela o �ltimo item do cupom //
// ------------------------------ //
function _ecf12_CancelaUltimoItem(Pp1: Boolean):Boolean;
begin
  //
  DLLG2_LimpaParams(iHd);                                           // Limpa os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('CancelaItemFiscal')));                    // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then Result := True              // Verifica se teve erro no retorno
    else Result := False;
  _ecf12_CodeErro(iHd,'');
  //
end;

// -------------------------------//
// URANO LOG                      //
// Cancela o �ltimo cupom emitido //
// -------------------------------//
function _ecf12_CancelaUltimoCupom(Pp1: Boolean):Boolean;
begin
  //
  DLLG2_LimpaParams(iHd);                                           // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Operador')), PAnsiChar(AnsiString('1')), 7);     // Identifica��o do operador
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('CancelaCupom')));                     // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then Result := True              // Verifica se teve erro no retorno
    else Result := False;

  if Result = False then
    ShowMessage('Cancelamento n�o permitido'); // Sandro Silva 2018-10-18

  //
  DLLG2_LimpaParams(iHd);                                           // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Avanco')), PAnsiChar(AnsiString(FAvancoPapel)), 12);     // Identifica��o do operador
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('AvancaPapel'))); // Executa a fun��o
  //
  if Form1.sCortaPapel = 'Sim' then
  begin
    DLLG2_LimpaParams(iHd);                                          // Limpa os par�metros
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('TipoCorte')), PAnsiChar(AnsiString('1')), 12);               //
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('CortaPapel'))); // Executa a fun��o
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
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                                // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeDadoMonetario')), PAnsiChar(AnsiString('TotalDocLiquido')), 7);   // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeMoeda')));                                  // Executa a fun��o

  if (DLLG2_ObtemCodErro(iHd) = 0) then                                  // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorMoeda')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
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
    DLLG2_LimpaParams(iHd);                                                    // Limpa os par�metros
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('IdConsumidor')), PAnsiChar(AnsiString(Form1.sCPF_CNPJ_Validado)), 7); //
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('AbreCupomFiscal')));                               // Executa a fun��o
    if (DLLG2_ObtemCodErro(iHd) = 0) then Result := True else Result := False;
    _ecf12_CodeErro(iHd,'');
  end else Result := True;
  //
end;

// -------------------------------- //
// Retorna o n�mero do Cupom        //
// URANO LOG                            //
// -------------------------------- //
function _ecf12_NumeroDoCupom(Pp1: Boolean):String;
var
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeInteiro')), PAnsiChar(AnsiString('COO')), 7);          // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeInteiro')));                     // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorInteiro')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
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
  DLLG2_LimpaParams(iHd);                                           // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NumItem')), PAnsiChar(AnsiString(pP1)), 4);     // Identifica��o do operador
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('CancelaItemFiscal')));                    // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then Result := True              // Verifica se teve erro no retorno
    else Result := False;
  _ecf12_CodeErro(iHd,'');
  // ------------------------------------------------------------------ //
  // A vari�vel iCancelaItenN deve ser incrementada quando a impressora //
  // considera n�o considera que o item j� foi cancelado isso evita um  //
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
  DLLG2_LimpaParams(iHd);                                           // Limpa os par�metros
//  DLLG2_AdicionaParam(iHd,'TempoAcionamentoGaveta','100',7);        // Tempo, em milissegundos, de acionamento do solen�ide.
  DLLG2_ExecutaComando(iHd,'AbreGaveta');                    // Executa a fun��o
  Result := True;
end;

// -------------------------------- //
// Status da gaveta                 //
// URANO LOG                        //
//                                  //
// 000 Gaveta Fechada.              //
// 255 Gaveta Aberta.               //
// 128 Valor atribuido quando n�o   //
//     tem gaveta.                  //
// -------------------------------- //
function _ecf12_StatusGaveta(Pp1: Boolean):String;
var
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeIndicador')), PAnsiChar(AnsiString('SensorGaveta')), 7);   // Seta os par�metros
  //
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeIndicador')));                       // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorTextoIndicador')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
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
  DLLG2_LimpaParams(iHd);                                      // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeNaoFiscal')), PAnsiChar(AnsiString('Sangria')), 7);        //
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('TipoNaoFiscal')), PAnsiChar(AnsiString('False')), 0);          //
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('DefineNaoFiscal')));                 // Executa a fun��o
  //
  DLLG2_LimpaParams(iHd);                                      // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeNaoFiscal')), PAnsiChar(AnsiString('Sangria')), 7);        //
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Valor')), PAnsiChar(AnsiString(FloatToStr(pP1))), 6);   // Valor da opera��o.Indica o montante pago com o Meio de Pagamento informado.
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('EmiteItemNaoFiscal')));              // Executa a fun��o
  //
  DLLG2_LimpaParams(iHd);                                      // Limpa os par�metros.
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodMeioPagamento')), PAnsiChar(AnsiString('-2')), 0);          // �ndice do Meio de Pagamento.
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Valor')), PAnsiChar(AnsiString(FloattoStr(pP1))), 6);   // Valor da opera��o.Indica o montante pago com o Meio de Pagamento informado.
  //
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('PagaCupom')));                       // Executa a fun��o
//  if (DLLG2_ObtemCodErro(iHd) <> 0) then _ecf12_CodeErro(iHd,'');
  //
  DLLG2_LimpaParams(iHd);                                           // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Operador')), PAnsiChar(AnsiString('1')), 7);     // Identifica��o do operador
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('EncerraDocumento')));                     // Executa a fun��o
  //
  if (DLLG2_ObtemCodErro(iHd) <> 0) then
    Result := False
  else
    Result := True;
//  _ecf12_CodeErro(iHd,'');
  //
  DLLG2_LimpaParams(iHd);                                           // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Avanco')), PAnsiChar(AnsiString(FAvancoPapel)), 12);     // Identifica��o do operador
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('AvancaPapel'))); // Executa a fun��o
  //
  if Form1.sCortaPapel = 'Sim' then
  begin
    DLLG2_LimpaParams(iHd);                                          // Limpa os par�metros
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('TipoCorte')), PAnsiChar(AnsiString('1')), 12);               //
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('CortaPapel'))); // Executa a fun��o
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
  DLLG2_LimpaParams(iHd);                                      // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeNaoFiscal')), PAnsiChar(AnsiString('Suprimento')), 7);     //
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('TipoNaoFiscal')), PAnsiChar(AnsiString('True')), 0);           //
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('DefineNaoFiscal')));                 // Executa a fun��o
  //
  DLLG2_LimpaParams(iHd);                                      // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeNaoFiscal')), PAnsiChar(AnsiString('Suprimento')), 7);     //
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Valor')), PAnsiChar(AnsiString(FloatToStr(pP1))), 6);   // Valor da opera��o.Indica o montante pago com o Meio de Pagamento informado.
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('EmiteItemNaoFiscal')));              // Executa a fun��o
  //
  DLLG2_LimpaParams(iHd);                                      // Limpa os par�metros.
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodMeioPagamento')), PAnsiChar(AnsiString('-2')), 0);          // �ndice do Meio de Pagamento.
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Valor')), PAnsiChar(AnsiString(FloattoStr(pP1))), 6);   // Valor da opera��o.Indica o montante pago com o Meio de Pagamento informado.
  //
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('PagaCupom')));                       // Executa a fun��o
//  if (DLLG2_ObtemCodErro(iHd) <> 0) then _ecf12_CodeErro(iHd,'');
  //
  DLLG2_LimpaParams(iHd);                                           // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Operador')), PAnsiChar(AnsiString('1')), 7);     // Identifica��o do operador
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('EncerraDocumento')));                     // Executa a fun��o
  //
  if (DLLG2_ObtemCodErro(iHd) <> 0) then
    Result := False
  else
    Result := True;
//  _ecf12_CodeErro(iHd,'');
  //
  DLLG2_LimpaParams(iHd);                                           // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Avanco')), PAnsiChar(AnsiString(FAvancoPapel)), 12);     // Identifica��o do operador
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('AvancaPapel'))); // Executa a fun��o
  //
  if Form1.sCortaPapel = 'Sim' then
  begin
    DLLG2_LimpaParams(iHd);                                          // Limpa os par�metros
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('TipoCorte')), PAnsiChar(AnsiString('1')), 12);               //
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('CortaPapel'))); // Executa a fun��o
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
  // Este comando s� pode ser feito mediante uma interven��o t�cnica //
  ShowMessage('Este comando s� poder� ser executado mediante uma'
  + chr(10) + 'interven��o t�cnica.'
  + chr(10)
  + chr(10) + 'Se realmente for necess�rio cadastrar uma nova aliquota,'
  + chr(10) + 'Chame um t�cnico habilitado.');
  Result := True;
  //
end;

function _ecf12_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
var
  //Retorno: array [0..400] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..400] of char;
  Retorno: String;
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
    Retorno := Replicate(' ', 400);
    DLLG2_LimpaParams(iHd);                                    // Limpa os par�metros
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Destino')), PAnsiChar(AnsiString('S')), 7);                  // Seta os par�metros
    //
    if Form7.Label3.Caption = 'Data inicial:' then
    begin
      DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('DataInicial')), PAnsiChar(AnsiString(Copy(pP2,1,2)+'/'+Copy(pP2,3,2)+'/'+'20'+Copy(pP2,5,2))), 2);         // Seta os par�metros
      DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('DataFinal')), PAnsiChar(AnsiString(Copy(pP3,1,2)+'/'+Copy(pP3,3,2)+'/'+'20'+Copy(pP3,5,2))), 2);           // Seta os par�metros
    end else
    begin
      DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('COOInicial')), PAnsiChar(AnsiString(StrZero(StrToInt(pP2),6,0))), 4);         // Seta os par�metros
      DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('COOFinal')), PAnsiChar(AnsiString(StrZero(StrToInt(pP3),6,0))), 4);           // Seta os par�metros
    end;
    //
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('EmiteLeituraFitaDetalhe')));               // Executa a fun��o
    //
  {
    DLLG2_LimpaParams(iHd);                                    // Limpa os par�metros
    DLLG2_AdicionaParam(iHd,'Destino','S',7);                  // Seta os par�metros
    DLLG2_AdicionaParam(iHd,'Operador','',7);                  // Seta os par�metros
    //
    DLLG2_ExecutaComando(iHd,'EmiteLeituraX');                 // Executa a fun��o
  }
    //
    if iHd <> 0 then _ecf12_CodeErro(iHd,'');
    //
    //
    DeleteFile(pP1);   // Apaga o arquivo anterior
    AssignFile(Form1.F,pP1);
    Rewrite(Form1.F);           // Abre para grava��o
    Retorno := '<INICIO>';
    sTexto  := '';
    //
    while AllTrim(Retorno) <> '' do
    begin
      //
      Retorno := '';
      //
      sLeep(100);
      DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
      DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeImpressao')));
  //    if iHd <> 0 then _ecf12_CodeErro(iHd,'');
      DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('TextoImpressao')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
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
  DLLG2_LimpaParams(iHd);                                    // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Destino')), PAnsiChar(AnsiString('I')), 7);                  // Seta os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Operador')), PAnsiChar(AnsiString('')), 7);             // Seta os par�metros
  //
  if Form1.sTipo = 's' then
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('LeituraSimplificada')), PAnsiChar(AnsiString('True')), 0)
  else
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('LeituraSimplificada')), PAnsiChar(AnsiString('False')), 0);
  //
  if Length(pP1) = 6 then
  begin
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('DataInicial')), PAnsiChar(AnsiString(Copy(pP1,1,2)+'/'+Copy(pP1,3,2)+'/'+'20'+Copy(pP1,5,2))), 2);         // Seta os par�metros
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('DataFinal')), PAnsiChar(AnsiString(Copy(pP2,1,2)+'/'+Copy(pP2,3,2)+'/'+'20'+Copy(pP2,5,2))), 2);           // Seta os par�metros
  end else
  begin
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('ReducaoInicial')), PAnsiChar(AnsiString(pP1)), 4);         // Seta os par�metros
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('ReducaoFinal')), PAnsiChar(AnsiString(pP2)), 4);           // Seta os par�metros
  end;
  //
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('EmiteLeituraMF')));                 // Executa a fun��o
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
  // pP1 -> C�digo     13 d�gitos //
  // pP2 -> Descric�o  29 d�gitos //
  // pP3 -> ST          2 d�gitos //
  // pP4 -> Quantidade  7 d�gitos //
  // pP5 -> Unit�rio    7 d�gitos //
  // pP6 -> Medida      2 d�gitos //
  // ---------------------------- //
  if Copy(pP3,1,1) = 'F' then pP3 := '-2';     // 42 Substitui��o
  if Copy(pP3,1,1) = 'I' then pP3 := '-3';     // 38 isen��o
  if Copy(pP3,1,1) = 'N' then pP3 := '-4';     // 40 n�o incid�ncia
  //
  DLLG2_LimpaParams(iHd);                                    // Limpa os par�metros
//  DLLG2_AdicionaParam(iHd,'AliquotaICMS','True',0);          // Identifica a aliquota como ICMS ('true') ou ISSQN ('false')
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodAliquota')), PAnsiChar(AnsiString(pp3)), 0);       //	�ndice da al�quota
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodProduto')), PAnsiChar(AnsiString(pP1)), 7);        //	C�digo do produto
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeProduto')), PAnsiChar(AnsiString(pP2)), 7);       // Nome descritivo do produto
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('PrecoUnitario')), PAnsiChar(AnsiString(FloatToStr(StrToFloat(pP5)/ StrtoInt('1'+Replicate('0',StrToInt(Form1.ConfPreco)) )))), 6);     // Pre�o Unit�rio.O comando de venda de item trata pre�os unit�rios que possuam at� 3 casas decimais.
  //
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Quantidade')), PAnsiChar(AnsiString(FloatToStr(StrToFloat(pP4)/1000))), 6);        // Quantidade envolvida na transa��o.O comando de venda de item trata quantidades com at� 3 casas decimais.
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Unidade')), PAnsiChar(AnsiString(pP6)), 7);           // Unidade do produto. Se n�o informado ser� assumido o texto "un" (sem as aspas).
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('VendeItem')));                     // Executa a fun��o
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
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Cancelar')), PAnsiChar(AnsiString('False')), 0);     //
    if (StrToInt(pP8) <> 0) then
      DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('ValorAcrescimo')), PAnsiChar(AnsiString( FloatToStr( ( StrToFloat(pP8)/100*-1 )))), 6);     // Pre�o Unit�rio.O comando de venda de item trata pre�os unit�rios que possuam at� 3 casas decimais.
    if (StrToInt(pP7) <> 0) then
      DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('ValorPercentual')), PAnsiChar(AnsiString(FloatToStr( ( StrToFloat(pP7)/100*-1 )))), 6);     // Pre�o Unit�rio.O comando de venda de item trata pre�os unit�rios que possuam at� 3 casas decimais.
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('AcresceItemFiscal')));                                               // Executa a fun��o
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
                'Pre�o: '+pChar(FloatToStr(StrToFloat(pP5)/ StrtoInt('1'+Replicate('0',StrToInt(Form1.ConfPreco)) ))));
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
  DLLG2_LimpaParams(iHd);                                               // Limpa os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('EmiteReducaoZ')));                 // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then Result := True       // Verifica se teve erro no retorno
    else Result := False;
  //
  DLLG2_LimpaParams(iHd);                                           // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Avanco')), PAnsiChar(AnsiString(FAvancoPapel)), 12);     // Identifica��o do operador
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('AvancaPapel'))); // Executa a fun��o
  //
  if Form1.sCortaPapel = 'Sim' then
  begin
    DLLG2_LimpaParams(iHd);                                          // Limpa os par�metros
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('TipoCorte')), PAnsiChar(AnsiString('1')), 12);               //
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('CortaPapel'))); // Executa a fun��o
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
  DLLG2_LimpaParams(iHd);                                    // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Destino')), PAnsiChar(AnsiString('I')), 7);                  // Seta os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Operador')), PAnsiChar(AnsiString('')), 7);                  // Seta os par�metros
  //
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('EmiteLeituraX')));                 // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then Result := True       // Verifica se teve erro no retorno
    else Result := False;
  //
  DLLG2_LimpaParams(iHd);                                           // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Avanco')), PAnsiChar(AnsiString(FAvancoPapel)), 12);     // Identifica��o do operador
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('AvancaPapel'))); // Executa a fun��o
  //
  if Form1.sCortaPapel = 'Sim' then
  begin
    DLLG2_LimpaParams(iHd);                                          // Limpa os par�metros
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('TipoCorte')), PAnsiChar(AnsiString('1')), 12);               //
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('CortaPapel'))); // Executa a fun��o
    Form1.Edit1.SetFocus;
  end;
  //
  // _ecf12_CodeErro(iHd,'');
  //
end;

// ---------------------------------------------- //
// Retorna se o horario de ver�o est� selecionado //
// URANO LOG                                          //
// ---------------------------------------------- //
function _ecf12_RetornaVerao(pP1: Boolean):Boolean;
var
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                         // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeIndicador')), PAnsiChar(AnsiString('HorarioVerao')), 7);   // Seta os par�metros
  //
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeIndicador')));                       // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                           // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorTextoIndicador')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
  end else _ecf12_CodeErro(iHd,'');
  //
  if Copy(Ret1,3,1) = '1' then Result := True else Result := False;
  //
end;

// -------------------------------- //
// Liga ou desliga hor�rio de verao //
// URANO LOG                            //
// -------------------------------- //
function _ecf12_LigaDesLigaVerao(pP1: Boolean):Boolean;
begin
  //
  if (_ecf12_RetornaVerao(True) = True) then
  begin
    DLLG2_LimpaParams(iHd);                                           // Limpa os par�metros
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('EntradaHV')), PAnsiChar(AnsiString('0')), 4);                       // Seta os par�metros
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('AcertaHorarioVerao')));                   // Executa a fun��o
  end else
  begin
    DLLG2_LimpaParams(iHd);                                           // Limpa os par�metros
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('EntradaHV')), PAnsiChar(AnsiString('1')),4);                       // Seta os par�metros
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('AcertaHorarioVerao')));                   // Executa a fun��o
  end;
  //
  _ecf12_CodeErro(iHd, '');
  //
  Result := True;
  //
end;

// -------------------------------- //
// Retorna a vers�o do firmware     //
// URANO LOG                            //
// -------------------------------- //
function _ecf12_VersodoFirmware(pP1: Boolean): String;
var
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                               // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeTexto')), PAnsiChar(AnsiString('VersaoSW')), 7); // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeTexto')));                 // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                 // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorTexto')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
    Result := Retorno;
  end else _ecf12_CodeErro(iHd,'');
  //
end;

// -------------------------------- //
// Retorna o n�mero de s�rie        //
// URANO LOG                            //
// -------------------------------- //
function _ecf12_NmerodeSrie(pP1: Boolean): String;
var
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeTexto')), PAnsiChar(AnsiString('NumeroSerieECF')), 7); // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeTexto')));                       // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorTexto')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
    Result := Retorno;
  end else _ecf12_CodeErro(iHd,'');
end;

// -------------------------------- //
// Retorna o CGC e IE               //
// URANO LOG                            //
// -------------------------------- //
function _ecf12_CGCIE(pP1: Boolean): String;
var
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeTexto')), PAnsiChar(AnsiString('CNPJ')), 7);           // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeTexto')));                       // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorTexto')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
    Result := Retorno;
  end else _ecf12_CodeErro(iHd,'');
  //
  DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeTexto')), PAnsiChar(AnsiString('IE')), 7);           // Seta os par�metros
  DLLG2_ExecutaComando(iHd, 'LeTexto');                       // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, 'ValorTexto', 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
    Result := Result +Chr(10)+ Retorno;
  end else _ecf12_CodeErro(iHd,'');
  //
end;

// --------------------------------- //
// Retorna o n�mero de cancelamentos //
// URANO LOG                             //
// --------------------------------- //
function _ecf12_Cancelamentos(pP1: Boolean): String;
var
  //Retorno: array [0..606] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..606] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 606);
  DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeDadoMonetario')), PAnsiChar(AnsiString('TotalDiaCancelamentosICMS')), 7); // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeMoeda')));                                          // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                                          // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorMoeda')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno));            // Obtem o retorno
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
  //Retorno: array [0..606] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..606] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 606);
  DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeDadoMonetario')), PAnsiChar(AnsiString('TotalDiaDescontos')), 7);        // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeMoeda')));                                         // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                                         // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorMoeda')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno));           // Obtem o retorno
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
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeInteiro')), PAnsiChar(AnsiString('COO')), 7);          // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeInteiro')));                     // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorInteiro')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
    Result := StrZero(StrToInt(Retorno),6,0);
  end else
  begin
     _ecf12_CodeErro(iHd,'');
     Result := '000000';
  end;
  //
end;

// -------------------------------- //
// Retorna o n�mero de opera��es    //
// n�o fiscais acumuladas           //
// URANO LOG                            //
// -------------------------------- //
function _ecf12_Nmdeoperaesnofiscais(pP1: Boolean): String;
var
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeInteiro')), PAnsiChar(AnsiString('GNF')), 7);          // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeInteiro')));                     // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorInteiro')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
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
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeInteiro')), PAnsiChar(AnsiString('CFC')), 7);          // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeInteiro')));                     // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorInteiro')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
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
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeInteiro')), PAnsiChar(AnsiString('CRZ')), 7);          // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeInteiro')));                     // Executa a fun��o
  //
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorInteiro')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
    Result := StrZero(StrToInt(Retorno),6,0);
  end else
  begin
     _ecf12_CodeErro(iHd,'');
     Result := '000000';
  end;
  //
  // ShowMessage('Contador de Redu��o Z (CRZ): '+Result);
  //
end;

function _ecf12_Nmdeintervenestcnicas(pP1: Boolean): String;
var
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeInteiro')), PAnsiChar(AnsiString('CRO')), 7);          // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeInteiro')));                     // Executa a fun��o
  //
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorInteiro')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
    Result := StrZero(StrToInt(Retorno),6,0);
  end else
  begin
     _ecf12_CodeErro(iHd,'');
     Result := '000000';
  end;
  //
  // ShowMessage('Contador de Rein�cio de Opera��o (Interven��es T�cnicas realizadas): '+Result);
  //
end;

// Sandro Silva 2017-10-09  Contador Geral de Relat�rio Gerencial
function _ecf12_NmContadorGeraldeRelatrioGerencial(pP1: Boolean): String;
var
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeInteiro')), PAnsiChar(AnsiString('GRG')), 7);          // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeInteiro')));                     // Executa a fun��o
  //
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorInteiro')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
    Result := StrZero(StrToInt(Retorno),6,0);
  end else
  begin
     _ecf12_CodeErro(iHd,'');
     Result := '000000';
  end;
  //
  // ShowMessage('Contador Geral de Relat�rio Gerencial: '+Result);
  //
end;

function _ecf12_NmContadordeCuponsFiscal(pP1: Boolean): String;
var
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeInteiro')), PAnsiChar(AnsiString('CCF')), 7);          // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeInteiro')));                     // Executa a fun��o
  //
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorInteiro')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
    Result := StrZero(StrToInt(Retorno),6,0);
  end else
  begin
     _ecf12_CodeErro(iHd,'');
     Result := '000000';
  end;
  //
  // ShowMessage('Contador Geral de Relat�rio Gerencial: '+Result);
  //
end;

// Sandro Silva 2017-10-09 Contador de Cupons Cr�dito/D�bito
function _ecf12_NmContadordeCuponsCrditoDbito(pP1: Boolean): String;
var
  // Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeInteiro')), PAnsiChar(AnsiString('CDC')), 7);          // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeInteiro')));                     // Executa a fun��o
  //
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorInteiro')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
    Result := StrZero(StrToInt(Retorno),6,0);
  end else
  begin
     _ecf12_CodeErro(iHd,'');
     Result := '000000';
  end;
  //
  // ShowMessage('Contador Geral de Relat�rio Gerencial: '+Result);
  //
end;

function _ecf12_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
var
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                                       // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeInteiro')), PAnsiChar(AnsiString('ContadorProprietarios')), 7);          // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeInteiro')));                                       // Executa a fun��o
  //
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorInteiro')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
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
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13   Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                               // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeTexto')), PAnsiChar(AnsiString('Cliche')), 7); // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeTexto')));                 // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                 // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorTexto')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
    Result := Retorno;
  end else _ecf12_CodeErro(iHd,'');
  //
end;

// ------------------------------------ //
// Importante retornar apenas 3 d�gitos //
// Ex: 001                              //
// URANO LOG                    //
// ------------------------------------ //
function _ecf12_NmdoCaixa(pP1: Boolean): String;
var
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeInteiro')), PAnsiChar(AnsiString('ECF')), 7);            // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeInteiro')));                        // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorInteiro')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
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
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeInteiro')), PAnsiChar(AnsiString('Loja')), 7);            // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeInteiro')));                        // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorInteiro')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
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
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeTexto')), PAnsiChar(AnsiString('SimboloMoeda')), 7);          // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeTexto')));                       // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorTexto')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
    Result := StrTran(AllTrim(Retorno),'$','');
  end else _ecf12_CodeErro(iHd,'');
  //
end;

// ----------------------------------------- //
// Dia + M�s + Ano + Hora + Minuto + Segundo //
// Ex: 26091976200000                        //
// ----------------------------------------- //
function _ecf12_Dataehoradaimpressora(pP1: Boolean): String;
var
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeData')), PAnsiChar(AnsiString('Data')), 7);            // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeData')));                        // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorData')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
    Result := Copy(StrTran(Retorno,'/',''),1,4)+Copy(StrTran(Retorno,'/',''),7,2);
  end else _ecf12_CodeErro(iHd,'');
  //
  DLLG2_LimpaParams(iHd);                                    // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeHora')), PAnsiChar(AnsiString('Hora')), 7);           // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeHora')));                       // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                      // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorHora')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
    Result := Result + StrTran(Retorno,':','');
  end else _ecf12_CodeErro(iHd,'');
  //
end;

function _ecf12_Datadaultimareduo(pP1: Boolean): String;
var
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                          // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeData')), PAnsiChar(AnsiString('DataAbertura')), 7); // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeData')));                            // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                            // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorData')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
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
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                          // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeData')), PAnsiChar(AnsiString('DataAbertura')), 7); // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeData')));                            // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                            // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorData')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
    Result := Retorno;
  end else _ecf12_CodeErro(iHd,'');
  //
end;

// Deve retornar uma String com:                                          //
// Os 2 primeiros d�gitos s�o o n�mero de aliquotas gravadas: Ex 16       //
// os p�ximos de 4 em 4 s�o as aliquotas Ex: 1800                         //
// Ex: 161800120005000000000000000000000000000000000000000000000000000000 //
function _ecf12_RetornaAliquotas(pP1: Boolean): String;
var
  //Retorno: array [0..616] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..616] of char;
  Retorno: AnsiString;
  I : Integer;
begin
  //
  Result := '16';
  Retorno := Replicate(' ', 616);
  //
  for I := 1 to 16 do
  begin
    //
    DLLG2_LimpaParams(iHd);                                                               // Limpa os par�metros
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodAliquotaProgramavel')), PAnsiChar(AnsiString(IntToStr(I))),4);              // Seta os par�metros
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeAliquota')));                                              // Executa a fun��o
    //
    if (DLLG2_ObtemCodErro(iHd) = 0)
      then DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('PercentualAliquota')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno))
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
  // Flags de Vincula��o ao ISS                 //
  // (Cada �bit� corresponde a                  //
  // um totalizador.                            //
  // Um �bit� setado indica vincula��o ao ISS)  //
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
  //Retorno: array [0..400] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..400] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 400);
  DLLG2_LimpaParams(iHd);                                    // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Destino')), PAnsiChar(AnsiString('S')), 7);                  // Seta os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Operador')), PAnsiChar(AnsiString('1')), 7);             // Seta os par�metros
//  DLLG2_AdicionaParam(iHd,'LeituraSimplificada','False',0);  // Seta os par�metros
//  DLLG2_SetaArquivoLog('RETORNO.TXT');
  //
  if Length(pP2) = 6 then
  begin
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('DataInicial')), PAnsiChar(AnsiString(Copy(pP2,1,2)+'/'+Copy(pP2,3,2)+'/'+'20'+Copy(pP2,5,2))), 2);         // Seta os par�metros
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('DataFinal')), PAnsiChar(AnsiString(Copy(pP3,1,2)+'/'+Copy(pP3,3,2)+'/'+'20'+Copy(pP3,5,2))), 2);           // Seta os par�metros
  end else
  begin
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('ReducaoInicial')), PAnsiChar(AnsiString(pP2)), 4);         // Seta os par�metros
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('ReducaoFinal')), PAnsiChar(AnsiString(pP3)), 4);           // Seta os par�metros
  end;
  //
  // URANO  (01451)34628707 Filipe   //
  //
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('EmiteLeituraMF')));                 // Executa a fun��o
  //
  //
  DeleteFile(pP1);   // Apaga o arquivo anterior
  AssignFile(Form1.F,pP1);
  Rewrite(Form1.F);           // Abre para grava��o
  //
  Retorno := '<INICIO>';
  while AllTrim(Retorno) <> '' do
  begin
    Retorno := '';
    DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeImpressao')));
    if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
    begin
      DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('TextoImpressao')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
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
    DLLG2_LimpaParams(iHd);                                          // Limpa os par�metros
    //
    if Form1.ibDataSet25ACUMULADO1.AsFloat <> 0 then
    begin
      DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeMeioPagamento')), PAnsiChar(AnsiString(AllTrim(Form2.Label9.Caption))), 7);  // Cheque
      DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Valor')), PAnsiChar(AnsiString(Form1.ibDataSet25ACUMULADO1.AsString)), 6);           // Valor da opera��o.Indica o montante pago com o Meio de Pagamento informado.
      Form1.Label13.Hint := AllTrim(Form2.Label9.Caption);
    end;
    if Form1.ibDataSet25PAGAR.AsFloat <> 0 then
    begin
      DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeMeioPagamento')), PAnsiChar(AnsiString(AllTrim(Form2.Label8.Caption))), 7);  // Cart�o
      DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Valor')), PAnsiChar(AnsiString(Form1.ibDataSet25Pagar.AsString)), 6);                // Valor da opera��o.Indica o montante pago com o Meio de Pagamento informado.
      Form1.Label13.Hint := AllTrim(Form2.Label8.Caption);
    end;
    if Form1.ibDataSet25DIFERENCA_.AsFloat <> 0 then
    begin
      DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeMeioPagamento')), PAnsiChar(AnsiString(AllTrim(Form2.Label17.Caption))), 7); // Prazo
      DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Valor')), PAnsiChar(AnsiString(Form1.ibDataSet25DIFERENCA_.AsString)), 6);           // Valor da opera��o.Indica o montante pago com o Meio de Pagamento informado.
      Form1.Label13.Hint := AllTrim(Form2.Label17.Caption);
    end;
    //
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('AbreCreditoDebito')));                   // Executa a fun��o
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
          DLLG2_LimpaParams(iHd);                                            // Limpa os par�metros
          DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('TextoLivre')), PAnsiChar(AnsiString(Copy(sP1,J,I-J)+' ')), 7);//
          DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('ImprimeTexto')));                          // Executa a fun��o
          iRetorno := DLLG2_ObtemCodErro(iHd);
          J := I + 1;
        end;
      end;
    end;
    //
    if iRetorno = 0 then
    begin
      DLLG2_LimpaParams(iHd);                                           // Limpa os par�metros
      DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('EncerraDocumento')));                     // Executa a fun��o
      iRetorno := DLLG2_ObtemCodErro(iHd);
    end;
    //
    if iRetorno = 0 then Result := True else Result := False;
    //
    DLLG2_LimpaParams(iHd);                                           // Limpa os par�metros
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Avanco')), PAnsiChar(AnsiString(FAvancoPapel)), 12);     // Identifica��o do operador
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('AvancaPapel'))); // Executa a fun��o
    //
    if Form1.sCortaPapel = 'Sim' then
    begin
      DLLG2_LimpaParams(iHd);                                          // Limpa os par�metros
      DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('TipoCorte')), PAnsiChar(AnsiString('1')), 12);               //
      DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('CortaPapel'))); // Executa a fun��o
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
  sLinha : AnsiString;
begin
  //
  begin
    //
    Estado := ' ';
    //
    DLLG2_LimpaParams(iHd);                                          // Limpa os par�metros
    //
    if Pos('IDENTIFICA��O DO PAF-ECF',sP1)<>0 then
    begin
      DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('1')), 4);  // Identifica��o do PAF
    end else
    begin
      if Pos('Per�odo Solicitado: de',sP1)<>0 then
      begin
        DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('4')), 4);  // Meios de pagamento
      end else
      begin
        if (Pos('Documento: ',sP1)<>0) or (Pos(TITULO_PARCELAS_CARNE_RESUMIDO, sP1) > 0) then  // Sandro Silva 2018-04-29  if Pos('Documento: ',sP1)<>0 then
        begin
          DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('2')), 4); // Venda a prazo
        end else
        begin
          if Pos('DAV EMITIDOS',sP1)<>0 then
          begin
            DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('5')), 4); // DAV Emitidos
          end else
          begin
            if Pos('AUXILIAR DE VENDA (DAV) - OR',sP1)<>0 then
            begin
              DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('6')), 4); // Or�amento (DAV)
            end else
            begin
              if Pos('CONFERENCIA DE CONTA',sP1)<>0 then
              begin
                DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('7')), 4); // Conferencia de conta
              end else
              begin
                if Pos('TRANSFERENCIAS ENTRE CONTA',sP1)<>0 then
                begin
                  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('8')), 4); // Transferencia entre CONTAS
                end else
                begin
                  // Sandro Silva 2016-02-04 POLIMIG  if (Pos('CONTAS DE CLIENTES ABERTAS',sP1)<>0) or (Pos('CONTAS DE CLIENTES OS ABERTAS',sP1)<>0) or (Pos('NENHUMA',sP1)<>0) then
                  if (Pos('CONTAS DE CLIENTES ABERTAS',sP1)<>0)
                    or (Pos('CONTAS DE CLIENTES OS ABERTAS',sP1)<>0)
                    or ((Pos('NENHUMA',sP1)<>0) and (Pos('CONTA DE CLIENTE',sP1)<>0)) then
                  begin
                    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('9')), 4); // CONTAS ABERTAS
                  end else
                  begin
                    if Pos('CONFERENCIA DE MESA',sP1)<>0 then
                    begin
                      DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('10')), 4); // CONF MESA
                    end else
                    begin
                      if Pos('TRANSFERENCIAS ENTRE MESA',sP1)<>0 then
                      begin
                        DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('11')), 4); // TRANSF MESA
                      end else
                      begin
                        // Sandro Silva 2016-02-04 POLIMIG  if Pos('MESAS ABERTAS',sP1)<>0 then
                        if (Pos('MESAS ABERTAS',sP1)<>0) or
                         (Pos('NENHUMA MESA',sP1)<>0) then
                        begin
                          DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('12')), 4); // Mesas Abertas
                        end else
                        begin
                          if Pos('Parametros de Configuracao',sP1)<>0 then
                          begin
                            DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('13')), 4); // Par�metros de Configura��o
                          end else
                          begin
                            DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('CodGerencial')), PAnsiChar(AnsiString('3')), 4); // CARTAO TEP
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
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('AbreGerencial')));                   // Executa a fun��o
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
            DLLG2_LimpaParams(iHd);                                          // Limpa os par�metros
            DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('TextoLivre')), PAnsiChar(AnsiString(ConverteAcentos(sLinha))), 7);
            DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('ImprimeTexto')));                   // Executa a fun��o
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
          DLLG2_LimpaParams(iHd);                                          // Limpa os par�metros
          DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('TextoLivre')), PAnsiChar(AnsiString(' ')), 7);
          DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('ImprimeTexto')));                   // Executa a fun��o
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
      DLLG2_LimpaParams(iHd);                                           // Limpa os par�metros
      DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('EncerraDocumento')));                     // Executa a fun��o
      iRetorno := DLLG2_ObtemCodErro(iHd);
    end;
    //
    if iRetorno = 0 then Result := True else Result := False;
    //
    //
    DLLG2_LimpaParams(iHd);                                           // Limpa os par�metros
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Avanco')), PAnsiChar(AnsiString(FAvancoPapel)), 12);     // Identifica��o do operador
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('AvancaPapel'))); // Executa a fun��o
    //
    if Form1.sCortaPapel = 'Sim' then
    begin
      DLLG2_LimpaParams(iHd);                                          // Limpa os par�metros
      DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('TipoCorte')), PAnsiChar(AnsiString('1')), 12);               //
      DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('CortaPapel'))); // Executa a fun��o
      Form1.Edit1.SetFocus;
    end;
    //
  end;
  //
end;

function _ecf12_FechaCupom2(sP1: Boolean): Boolean;
begin
  //
  DLLG2_LimpaParams(iHd);                                           // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('Operador')), PAnsiChar(AnsiString('1')), 7);     // Identifica��o do operador
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('EncerraDocumento')));                     // Executa a fun��o
  Result := True;
  //
end;

function _ecf12_ImprimeCheque(rP1: Real; sP2: String): Boolean;
begin
  Result := False;
end;

function _ecf12_GrandeTotal(sP1: Boolean): String;
var
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeDadoMonetario')), PAnsiChar(AnsiString('GT')), 7);     // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeMoeda')));                       // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorMoeda')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
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
  //Retorno: array [0..616] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..616] of char;
  Retorno: AnsiString;
  I : Integer;
begin
  //
  Result := '';
  Retorno := Replicate(' ', 616);
  //
  for I := 1 to 15 do
  begin
    DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeDadoMonetario')), PAnsiChar(AnsiString('TotalDiaValorAliquota['+StrZero(I,2,0)+']')), 7); // Seta os par�metros
    DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeMoeda')));                                                      // Executa a fun��o
    if (DLLG2_ObtemCodErro(iHd) = 0) then                                                     // Verifica se teve erro no retorno
    begin                                                                                    //
      DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorMoeda')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno));                     // Obtem o retorno
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
   DLLG2_LimpaParams(iHd);                                                       // Limpa os par�metros
   DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeDadoMonetario')), PAnsiChar(AnsiString('TotalDiaIsencaoICMS')), 7);      // Seta os par�metros
   DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeMoeda')));                                         // Executa a fun��o
   if (DLLG2_ObtemCodErro(iHd) = 0) then DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorMoeda')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno));
   Result := Result + StrZero(StrToFloat(Retorno)*100,14,0);
   //
   // N�o tributados
   //
   Retorno := '0';
   DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
   DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeDadoMonetario')), PAnsiChar(AnsiString('TotalDiaNaoTributadoICMS')), 7);        // Seta os par�metros
   DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeMoeda')));                                         // Executa a fun��o
   if (DLLG2_ObtemCodErro(iHd) = 0) then DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorMoeda')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno));
   Result := Result + StrZero(StrToFloat(Retorno)*100,14,0);
   //
   // Substitui��o
   //
   Retorno := '0';
   DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
   DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeDadoMonetario')), PAnsiChar(AnsiString('TotalDiaSubstituicaoTributariaICMS')), 7);        // Seta os par�metros
   DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeMoeda')));                                         // Executa a fun��o
   if (DLLG2_ObtemCodErro(iHd) = 0) then DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorMoeda')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno));
   Result := Result + StrZero(StrToFloat(Retorno)*100,14,0);
   //
end;

function _ecf12_CupomAberto(sP1: Boolean): boolean;
var
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeInteiro')), PAnsiChar(AnsiString('EstadoFiscal')), 7);            // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeInteiro')));                     // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorInteiro')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
  //
  if (AllTrim(Retorno) >= '2') then Result := True else Result := False;
  //
end;

function _ecf12_FaltaPagamento(sP1: Boolean): boolean;
var
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                                // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeInteiro')), PAnsiChar(AnsiString('EstadoFiscal')),  7);            // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeInteiro')));                     // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorInteiro')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
  //
  if (AllTrim(Retorno) >= '4') then Result := True else Result := False;
  //
end;


//
// PAF
//

function _ecf12_Marca(sP1: Boolean): String;
var
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeTexto')), PAnsiChar(AnsiString('Marca')), 7);         // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeTexto')));                       // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorTexto')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
    Result := Retorno;
  end else _ecf12_CodeErro(iHd,'');
  //
end;

function _ecf12_Modelo(sP1: Boolean): String;
var
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeTexto')), PAnsiChar(AnsiString('Modelo')), 7);         // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeTexto')));                       // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorTexto')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
    Result := Retorno;
  end else _ecf12_CodeErro(iHd,'');
  //
end;

function _ecf12_Tipodaimpressora(pP1: Boolean): String; //
var
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeTexto')), PAnsiChar(AnsiString('TipoECF')), 7);         // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeTexto')));                       // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorTexto')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
    Result := Retorno;
  end else _ecf12_CodeErro(iHd,'');
  //
end;

function _ecf12_VersaoSB(pP1: Boolean): String; //
var
  //Retorno: array [0..255] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..255] of char;
  Retorno: AnsiString;
begin
  //
  Retorno := Replicate(' ', 255);
  DLLG2_LimpaParams(iHd);                                     // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeTexto')), PAnsiChar(AnsiString('VersaoSW')), 7);         // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeTexto')));                       // Executa a fun��o
  if (DLLG2_ObtemCodErro(iHd) = 0) then                       // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorTexto')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
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
  //Retorno: array [0..4000] of AnsiChar; // Sandro Silva 2023-12-13 Retorno: array [0..4000] of char;
  Retorno: AnsiString;
  sRetorno: String;
begin
  //
  Retorno := Replicate(' ', 4000);
  DLLG2_LimpaParams(iHd);                               // Limpa os par�metros
  DLLG2_AdicionaParam(iHd, PAnsiChar(AnsiString('NomeTexto')), PAnsiChar(AnsiString('DadosUltimaReducaoZ')), 7); // Seta os par�metros
  DLLG2_ExecutaComando(iHd, PAnsiChar(AnsiString('LeTexto')));                 // Executa a fun��o
  //
  if (DLLG2_ObtemCodErro(iHd) = 0) then                 // Verifica se teve erro no retorno
  begin
    DLLG2_Retorno(iHd, 0, PAnsiChar(AnsiString('ValorTexto')), 0, PAnsiChar(AnsiString(Retorno)), sizeof(retorno)); // Obtem o retorno
    sRetorno := Retorno;
  end else
  begin
     _ecf12_CodeErro(iHd,'');
     sRetorno := Replicate(' ',631);
  end;
  //
//   1,	  2 Constante �00� 2
//   3,	 18 GT da �ltima Redu��o 18
//  21,	 14 Cancelamentos 14
//  35,	 14 Descontos 14
//  49,  64 Tributos 64
// 113,	224 Totalizadores Parciais Tributados 266
// 337,  14 Totalizador de isen��o de ICMS
// 351,  14 Totalizador de n�o incid�ncia de ICMS
// 365,  14 Totalizador de substitui��o tribut�ria de ICMS
// 379,	 14 Sangria 14
// 393,	 14 Suprimentos 14
// 407,	126 Totalizadores n�o sujeitos ao ICMS 126
// 533,	 36 Contadores dos Totalizadores Parciais Tributados n�o sujeitos ao ICMS 36
// 569,	  6 Contador de Ordem de Opera��o (COO) 6
// 575,	  6 Contador de Opera��es n�o sujeitas ao ICMS 6
// 581,	  2 N�mero de Al�quotas Cadastradas 2
// 583,	  6 Data de Movimento 6
// 589,  14 Acr�scimo 14
// 603,  14 Acr�scimo Financeiro 14
  //
  Result :=  Copy(sRetorno,583,6)+ //   1,  6 Data
             Copy(sRetorno,569,6)+ //   7,  6 COO
             Copy(sRetorno, 3,18)+ //  13, 18 GT
     StrZero(StrToInt(_ecf12_NmdeRedues(True)),4,0) + //  31,  4 CRZ
      Copy(Form1.sAliquotas,3,64)+ //  35, 64 Aliquotas
          Copy(sRetorno, 127,224)+ //  99,224 Totalizadores das aliquotas
     StrZero(StrToInt(_ecf12_Nmdeintervenestcnicas(True)),4,0)+ // 323,  4 Contador de rein�cio de opera��o
            //
            Copy(sRetorno, 21, 14)+ // 327, 14 Totalizador de cancelamentos em ICMS
            Copy(sRetorno, 35, 14)+ // 341, 14 Totalizador de descontos em ICMS
            //
            Copy(sRetorno,351, 14)+ // 355, 14 Totalizador de isen��o de ICMS
            Copy(sRetorno,365, 14)+ // 369, 14 Totalizador de n�o incid�ncia de ICMS
            Copy(sRetorno,337, 14)+ // 383, 14 Totalizador de substitui��o tribut�ria de ICMS
            '';
  //
  // Ok testado
  //
end;

//
// Retorna o C�digo do Modelo do ECF Conf Tab�la Nacional de Identifica��o do ECF
//
function _ecf12_CodigoModeloEcf(pP1: Boolean): String; //
begin
  Result := '492601';
  if Form1.sCodigoIdentificaEcf <> '' then
    Result := Form1.sCodigoIdentificaEcf;
end;


end.
