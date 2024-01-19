unit _Small_5;

interface

uses

  Windows, Messages, SmallFunc_xe, Fiscal, SysUtils,Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Mask, Grids, DBGrids, DB, DBCtrls, SMALL_DBEdit, IniFiles, Unit2, Unit7, ShellApi, Unit22;

  //
  // Alterado p/versão 2005 07/01/2005 - RONEI                                //
  //

  // ---------------------------------- //
  // IF SCHALTER SPRINT 3.0, 3.03, 3.06 //
  // ---------------------------------- //
  // ELGIN
  // (0xx11)32253938
  // ------------------------------------------------------------------------- //
  // Shalter Eletrônica Ltda                                                   //
  // Suporte com Marcial                                                       //
  // Alechandre                                                                //
  // (0xx51)3346 3799                                                          //
  // marcial@schalter.com.br                                                   //
  // ------------------------------------------------------------------------- //

  function ecfLeituraX(operador: LPSTR): integer;stdcall; external 'dll32phi.dll';
  function ecfSubTotal : integer;stdcall; external 'dll32phi.dll';
  function ecfStatusCupom(var general_flag: integer): PChar;stdcall; external 'dll32phi.dll';
  function ecfLineFeed (byEst: integer; wLin:integer): integer;stdcall; external 'dll32phi.dll';
  function ecfParamLXSerial(S1, S2, atm00, atm01, atm02, atm03, atm04, atm05, atm06, atm07, atm08, atm09 : String): integer;stdcall; external 'dll32phi.dll';
  function ecfAbreGaveta : integer;stdcall; external 'dll32phi.dll';
  function ecfCancDoc(operador: LPSTR): integer;stdcall; external 'dll32phi.dll';
  function ecfReducaoZ(operador: LPSTR): integer;stdcall; external 'dll32phi.dll';
  function ecfFimTrans(operador: LPSTR): integer;stdcall; external 'dll32phi.dll';
  function ecfVendaItem (szDescr: LPSTR; szValor:LPSTR; byTaxa: integer): integer;stdcall; external 'dll32phi.dll';
  function ecfVenda_Item (szCodigo: LPSTR; szDescricao:LPSTR; szQInteira:LPSTR; szQFracionada:LPSTR; szValor:LPSTR; byTaxa:integer): integer;stdcall; external 'dll32phi.dll';

  function ecfVendaItem3d (szCodigo: string; szDescricao: string; szQuantidade: string; szValor: string; byTaxa: integer; unidade: string; digitos: string): integer;stdcall; external 'dll32phi.dll';

  function ecfVendaItem78(szDescr: LPSTR; szValor:LPSTR; byTaxa: integer): integer;stdcall; external 'dll32phi.dll';
  function ecfCancItem ( szDescr:LPSTR ): integer;stdcall; external 'dll32phi.dll';
  function ecfCancItemDef ( szItem : LPSTR; szDescr:LPSTR ): integer;stdcall; external 'dll32phi.dll';
  function ecfLeitMemFisc (byTipo:integer; szDi:LPSTR; szDf:LPSTR; wRi:integer; wRf:integer; archive:LPSTR ): integer;stdcall; external 'dll32phi.dll';
  function ecfPrazoCancPrazo (byTipo: integer; szDescr:LPSTR; szValor:LPSTR; byMens:integer;byLmens:integer): integer;stdcall; external 'dll32phi.dll';
  function ecfPagCancPag (byTipo: integer; szDescr:LPSTR; szValor:LPSTR; byMens:integer;byLmens:integer): integer;stdcall; external 'dll32phi.dll';
  function ecfPagamento (byTipo: integer; szPos:LPSTR; szValor:LPSTR; byLmens:integer): integer;stdcall; external 'dll32phi.dll';
  function ChangePort (chose:integer): integer;stdcall; external 'dll32phi.dll';
  function ecfStatusImp : PChar; stdcall; external 'dll32phi.dll';
  function ecfImpLinha(szLinha: LPSTR): integer;stdcall; external 'dll32phi.dll';
  function ecfParamCGC_IE (CGC, IE : String): integer;stdcall; external 'dll32phi.dll';
  function ecfCGC_IE : LPSTR; stdcall;external 'dll32phi.dll';
  function ecfCancAcresDescSubTotal ( byAcres:integer; byTipo:integer; szDescr:LPSTR; szValor:LPSTR): integer;stdcall; external 'dll32phi.dll';
  function ecfProgNFComprov( szPosTab:LPSTR; szTitulo:LPSTR;szDesconto:LPSTR;szAcres:LPSTR;szCancel:LPSTR;szComPag:LPSTR;szVinculado:LPSTR;szVinculo:LPSTR): integer;stdcall; external 'dll32phi.dll';
//  function ecfParamStatusEquipo( marca, modelo, versao, nserie : String): integer;stdcall; external 'dll32phi.dll';
  function ecfStatusEquipo : PChar;stdcall; external 'dll32phi.dll';
  function ecfStatusUser( userposition:integer ): PChar; stdcall; external 'dll32phi.dll';
  function ecfStatusAliquotas ( postab : integer ): PChar;stdcall; external 'dll32phi.dll';

  function ecfInicCupomNFiscal (tipo: integer): integer; stdcall; external 'dll32phi.dll';
  function ecfInicCNFVinculado (order: LPSTR; postab:LPSTR; valor:LPSTR): integer; stdcall; external 'dll32phi.dll';
  function ecfImpCab (byEst: integer): integer;stdcall; external 'dll32phi.dll';
  function ecfStatusVincs (postab:integer): PChar;stdcall; external 'dll32phi.dll';
  function ecfLXGerencial(operador: LPSTR): integer;stdcall; external 'dll32phi.dll';

  function ecfDescItem ( byTipo:integer; szDescr:LPSTR; szValor:LPSTR ): integer;stdcall; external 'dll32phi.dll';

     function _ecf05_CodeErro(Pp1: Integer):Integer;
     function _ecf05_Inicializa(Pp1: String):Boolean;
     function _ecf05_Pagamento(Pp1: Boolean):Boolean;
     function _ecf05_FechaCupom(Pp1: Boolean):Boolean;
     function _ecf05_CancelaUltimoItem(Pp1: Boolean):Boolean;
     function _ecf05_SubTotal(Pp1: Boolean):Real;
     function _ecf05_AbreGaveta(Pp1: Boolean):Boolean;
     function _ecf05_Sangria(Pp1: Real):Boolean;
     function _ecf05_Suprimento(Pp1: Real):Boolean;
     function _ecf05_NovaAliquota(Pp1: String):Boolean;
     function _ecf05_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
     function _ecf05_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
     function _ecf05_CancelaUltimoCupom(Pp1: Boolean):Boolean;
     function _ecf05_AbreNovoCupom(Pp1: Boolean):Boolean;
     function _ecf05_NumeroDoCupom(Pp1: Boolean):String;
     function _ecf05_CancelaItemN(pP1, pP2: String):Boolean;
     function _ecf05_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
     function _ecf05_ReducaoZ(pP1: Boolean):Boolean;
     function _ecf05_LeituraX(pP1: Boolean):Boolean;
     function _ecf05_RetornaVerao(pP1: Boolean):Boolean;
     function _ecf05_LigaDesLigaVerao(pP1: Boolean):Boolean;
     function _ecf05_VersodoFirmware(pP1: Boolean): String;
     function _ecf05_NmerodeSrie(pP1: Boolean): String;
     function _ecf05_CGCIE(pP1: Boolean): String;
     function _ecf05_Cancelamentos(pP1: Boolean): String;
     function _ecf05_Descontos(pP1: Boolean): String;
     function _ecf05_ContadorSeqencial(pP1: Boolean): String;
     function _ecf05_Nmdeoperaesnofiscais(pP1: Boolean): String;
     function _ecf05_NmdeCuponscancelados(pP1: Boolean): String;
     function _ecf05_NmdeRedues(pP1: Boolean): String;
     function _ecf05_Nmdeintervenestcnicas(pP1: Boolean): String;
     function _ecf05_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
     function _ecf05_Clichdoproprietrio(pP1: Boolean): String;
     function _ecf05_NmdoCaixa(pP1: Boolean): String;
     function _ecf05_Nmdaloja(pP1: Boolean): String;
     function _ecf05_Moeda(pP1: Boolean): String;
     function _ecf05_Dataehoradaimpressora(pP1: Boolean): String;
     function _ecf05_Datadaultimareduo(pP1: Boolean): String;
     function _ecf05_Datadomovimento(pP1: Boolean): String;
     function _ecf05_Tipodaimpressora(pP1: Boolean): String;
     function _ecf05_StatusGaveta(Pp1: Boolean):String;
     function _ecf05_RetornaAliquotas(pP1: Boolean): String;
     function _ecf05_Vincula(pP1: String): Boolean;
     function _ecf05_FlagsDeISS(pP1: Boolean): String;
     function _ecf05_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
     function _ecf05_MudaMoeda(pP1: String): Boolean;
     function _ecf05_MostraDisplay(pP1: String): Boolean;
     function _ecf05_leituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
     function _ecf05_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean;
     function _ecf05_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
     function _ecf05_FechaCupom2(sP1: Boolean): Boolean;
     function _ecf05_ImprimeCheque(rP1: Real; sP2: String): Boolean;
     function _ecf05_GrandeTotal(sP1: Boolean): String;
     function _ecf05_TotalizadoresDasAliquotas(sP1: Boolean): String;
     function _ecf05_CupomAberto(sP1: Boolean): boolean;
     function _ecf05_FaltaPagamento(sP1: Boolean): boolean;


implementation

uses ufuncoesfrente;

// ---------------------------------- //
// Tratamento de erros da IF SCHALTER //
// ---------------------------------- //
function _ecf05_CodeErro(Pp1: Integer):Integer;
var
  I : Integer;
  sVinculado, Mensagem :  String;
begin
  //
  Mensagem := '';
  //
  if Pp1 =  00 then Mensagem := 'Comando OK';
  if Pp1 =  01 then Mensagem := 'Erro de checksum';
  if Pp1 =  02 then Mensagem := 'Timeout RX';
  if Pp1 =  03 then Mensagem := 'Memória insuficiente';
  if Pp1 =  10 then Mensagem := 'Erro de sobreposição';
  if Pp1 =  11 then Mensagem := 'Erro de paridade';
  if Pp1 =  12 then Mensagem := 'Erro de sobreposição e paridade';
  if Pp1 =  13 then Mensagem := 'Erro de formato';
  if Pp1 =  14 then Mensagem := 'Erro de sobreposição e formato';
  if Pp1 =  15 then Mensagem := 'Erro de paridade e sobreposição';
  if Pp1 =  16 then Mensagem := 'Erro de sobreposição, paridade e formato';
  if Pp1 =  20 then Mensagem := 'Erro no cadastro de bancos';
  if Pp1 =  21 then Mensagem := 'Banco não cadastrado';
  if Pp1 =  22 then Mensagem := 'Moeda não cadastrada';
  if Pp1 =  23 then Mensagem := 'Extenso excedido';
//  if Pp1 =  65 then Mensagem := 'Em venda';
  if Pp1 =  66 then Mensagem := 'Limite de cabeçalho alcançado';
//  if Pp1 =  68 then Mensagem := 'Cabeçalho impresso';
  if Pp1 =  69 then Mensagem := 'Não começou venda';
  if Pp1 =  70 then Mensagem := 'Valor inválido';
  if Pp1 =  73 then Mensagem := 'Valor a menor';
  if Pp1 =  74 then Mensagem := 'Valor a maior';
  if Pp1 =  78 then Mensagem := 'Número máximo de Reduções Z alcançado';
  if (Pp1 =  79) or (Pp1 = 4) then
  begin
                    Mensagem := 'Erro de comunicação física: '
                                  + chr(10)
                                  + chr(10) + 'Verifique:'
                                  + chr(10)
                                  + chr(10) + '1. Impressora desligada.'
                                  + chr(10) + '2. Cabo não conectado.'
                                  + chr(10) + '3. Porta de comunicação inválida.'
                                  + chr(10) + '4. Chame um técnico habilitado.'
                                  + chr(10)
                                  + chr(10) + 'Este programa sera fechado.';

    ShowMessage(Mensagem);
    Halt(1);
  end;
  if Pp1 =  80 then Mensagem := 'Palavra reservada';
  if Pp1 =  82 then Mensagem := 'Data não localizada';
  if Pp1 =  84 then Mensagem := 'Erro de memória fiscal';
  if Pp1 =  85 then Mensagem := 'Perda da RAM';
  if Pp1 =  86 then Mensagem := 'Não houve pagamento';
  if Pp1 =  87 then Mensagem := 'Cupom já totalizado';
  if Pp1 =  88 then Mensagem := 'Não pode cancelar venda';
  if Pp1 =  89 then Mensagem := 'Comando não completo';
  if Pp1 =  90 then Mensagem := 'Cupom aberto';
  if Pp1 =  91 then Mensagem := 'Não há cupom a cancelar';
  if Pp1 =  92 then Mensagem := 'Tabela de taxa não inicializada';
  if Pp1 =  94 then Mensagem := 'Seleção de taxa inválida';
  if Pp1 =  95 then Mensagem := 'Cancelamento inválido';
  if Pp1 =  96 then Mensagem := 'Nada a retificar';
  if Pp1 =  97 then Mensagem := 'Redução não localizada';
  if Pp1 =  98 then Mensagem := 'Cabeçalho não carregado';
  if Pp1 =  99 then Mensagem := 'Impressora em intervenção técnica';
//  if Pp1 = 100 then Mensagem := 'Impressora em período de venda';
  if Pp1 = 101 then Mensagem := 'Somente com intervenção técnica';
  if Pp1 = 102 then Mensagem := 'Desconto inválido';
  if Pp1 = 103 then Mensagem := 'Limite de linhas alcançado';
  if Pp1 = 104 then Mensagem := 'Somente após o total';
  if Pp1 = 105 then Mensagem := 'Dados inválidos';
  if Pp1 = 106 then Mensagem := 'Alteração de taxa não disponível';
  if Pp1 = 107 then Mensagem := 'Comando inválido';

//  if Pp1 = 108 then Mensagem := ' Não houve o fechamento do dia';

  if Pp1 = 109 then Mensagem := 'Erro irrecuperável';
  if Pp1 = 110 then Mensagem := 'Alteração inválida';
  if Pp1 = 111 then Mensagem := 'Data já alterada';
  if Pp1 = 112 then Mensagem := 'Alíquota não carregada';

//  if Pp1 = 113 then Mensagem := 'Fechamento diário não realizado';

  if Pp1 = 114 then Mensagem := 'Abertura do dia inválida';
  if Pp1 = 115 then Mensagem := 'Fechamento já realizado';
  if Pp1 = 116 then Mensagem := 'Ajuste somente de +/- 1 hora';
  if Pp1 = 117 then Mensagem := 'Acréscimo inválido';
  if Pp1 = 118 then Mensagem := 'Pagamento incompleto';
  if Pp1 = 121 then Mensagem := 'Erro de gravação na memória fiscal';
  if Pp1 = 126 then Mensagem := 'Comando fora de seqüência';
  if Pp1 = 127 then Mensagem := 'Autenticação sem papel';
  if Pp1 = 132 then Mensagem := 'Queda de energia';
  if Pp1 = 133 then Mensagem := 'Data inválida';
  if Pp1 = 134 then Mensagem := 'Item fora da faixa';
  if Pp1 = 135 then Mensagem := 'Item não vendido';
  if Pp1 = 136 then Mensagem := 'Parâmetro errado';
  if Pp1 = 137 then Mensagem := 'Limite de valor ultrapassado';
  if Pp1 = 138 then Mensagem := 'Relógio fora de operação';
  if Pp1 = 139 then Mensagem := 'Pagamento não definido';
  if Pp1 = 140 then Mensagem := 'Limite de autenticação excedido';
  if Pp1 = 141 then Mensagem := 'Comando inválido';
  // ----------------------------------------------- //
  // retirei porque sempre tento programar novamente //
  // na sangria e no suprimento.                     //
  // ----------------------------------------------- //
  //  if Pp1 = 142 then Mensagem := 'Posição já programada';
  if Pp1 = 143 then Mensagem := 'Posição inexistente';
  if Pp1 = 144 then Mensagem := 'Cupom vinculado pendente';
  if Pp1 = 145 then Mensagem := 'Excesso de documentos vinculados';
  if Pp1 = 147 then Mensagem := 'Em horário já solicitado';
  if Pp1 = 148 then Mensagem := 'Oscilador do relógio desativado';
  if Pp1 = 149 then Mensagem := 'Formas de pagamento não inicializadas';
//  Form1.Image3.Visible := False;
  //
  if (pp1 = 108) or (pP1 = 113) then
  begin
    _ecf05_ReducaoZ(True);
    //Form1.EmitirReducaoZ(Form1);// 2015-10-07 Deve emitir mesas aberta, fechar as aberta a mais de 1 dias antes ou logo após da redução Z
    ecfLineFeed(1,6);
    ShellExecute( 0, 'Open', 'frente.EXE', '', '', SW_SHOW);
    Halt(1);
  end;
  //
  // se Pp1 for = 81 então não mostrar a mensagem na tela
  // troca a cor da tarja no cupom.
  //
  if Pp1 = 81 then
  begin
    if Form1.Memo3.Visible then
    begin
      Form1.Panel2.Visible := True;
      Form1.Panel2.BringToFront;
    end;
  end;
  //
  if Mensagem <> 'Comando OK' then if Mensagem <> '' then ShowMessage(Mensagem);
  Result := Pp1;
  //
  if (pP1 = 144) or (pP1 = 145) or (pP1 = 146) then
  begin
    for I := 0 to 29 do
    begin
      sVinculado := EcfStatusVincs(I);
      if Copy(sVinculado,1,1) = 'S' then
      begin
        EcfInicCNFVinculado(pChar(StrZero(StrToInt(AllTrim(Copy(sVinculado,46,6))),6,0)),'18',pChar(StrTran(Right(Copy(sVinculado,3,21),9),',',''))); // Retorna 146
        ecfImpLinha(pChar('Fechamento automatico de cupom vinculado'));
        ecfFimTrans('');
      end;
    end;
    for I := 0 to 29 do
    begin
      sVinculado := EcfStatusVincs(I);
      if Copy(sVinculado,1,1) = 'S' then
      begin
        EcfInicCNFVinculado(pChar(StrZero(StrToInt(AllTrim(Copy(sVinculado,46,6))),6,0)),'19',pChar(StrTran(Right(Copy(sVinculado,3,21),9),',',''))); // Retorna 146
        ecfImpLinha(pChar('Fechamento automatico de cupom vinculado'));
        ecfFimTrans('');
      end;
    end;
    ecfLineFeed(1,6);
    ShellExecute( 0, 'Open', 'frente.exe', '', '', SW_SHOW);
    Halt(1);
  end;
  //
end;

// ----------------------------//
// Detecta qual a porta que    //
// a impressora está conectada //
// IF SHALTER SPRINT           //
// --------------------------- //
function _ecf05_Inicializa(Pp1: String):Boolean;
var
  I, J : Integer;
  sS : String;
begin
  //
  ChangePort(StrtoInt(Copy(pP1,4,1))-1);
  //
  //
  for I := 1 to 5 do
  begin
    sS := ecfStatusImp();
    if Copy(sS,1,4) = 'Erro' then Result := False else Result := True;
  end;
  //
  if Form22.Label6.Caption = 'Aguarde, detectando a porta de comunicação...' then
  begin
    for I := 1 to 4 do
    begin
      if not Result then
      begin
        ShowMessage('Schalter SPRINT 3.0, Testando COM'+StrZero(I,1,0));
        ChangePort(I-1);
        //
        for J := 1 to 5 do
        begin
          sS := ecfStatusImp();
          if Copy(sS,1,4) = 'Erro' then Result := False else
          begin
            Result := True;
            Pp1 := 'COM'+StrZero(I,1,0);
            Form1.sPorta  := pP1;
            //
          end;
        end;
      end;
    end;
  end;
  //
end;

function _ecf05_Pagamento(Pp1: Boolean):Boolean;
var
  Mais1ini : TiniFile;
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
  I, J : Integer;
begin
  //
  Mais1ini  := TIniFile.Create('frente.ini');
  //
  sDinheiro := Mais1Ini.ReadString('Frente de caixa','Dinheiro'   ,'00');
  sCheque   := Mais1Ini.ReadString('Frente de caixa','Cheque'     ,'01');
  sCartao   := Mais1Ini.ReadString('Frente de caixa','Cartao'     ,'02');
  sPrazo    := Mais1Ini.ReadString('Frente de caixa','Prazo'      ,'03');
  //
  sExtra1   := StrZero(StrToInt(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 1','5')),2,0);
  sExtra2   := StrZero(StrToInt(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 2','6')),2,0);
  sExtra3   := StrZero(StrToInt(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 3','7')),2,0);
  sExtra4   := StrZero(StrToInt(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 4','8')),2,0);
  sExtra5   := StrZero(StrToInt(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 5','9')),2,0);
  sExtra6   := StrZero(StrToInt(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 6','10')),2,0);
  sExtra7   := StrZero(StrToInt(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 7','11')),2,0);
  sExtra8   := StrZero(StrToInt(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 8','12')),2,0);
  //
//  ShowMessage(
//  'Prazo.......: '+StrZero(Form1.ibDataSet25DIFERENCA_.Asfloat*100,14,0)+ Chr(10) +
//  'Em cheque...: '+StrZero(Form1.ibDataSet25ACUMULADO1.AsFloat*100,14,0)+ Chr(10) +
//  'Em dinheiro.: '+StrZero(Form1.ibDataSet25ACUMULADO2.AsFloat*100,14,0)+ Chr(10) +
//  'Receber.....: '+StrZero(Form1.ibDataSet25RECEBER.AsFloat*100,14,0)+ Chr(10)+
//  'Total.......: '+StrZero(Form1.fTotal*100,14,0)+ Chr(10));
  //
  if Form1.ibDataSet25DIFERENCA_.Asfloat <> 0 then ecfProgNFComprov('18','A prazo             ','S','S','S','N','S',pChar(sPrazo));   // A Prazo
  //
  if (FileExists('c:\TEF_DISC\TEF_DISC.INI')) or (FileExists('c:\TEF_DIAL\TEF_DIAL.INI')) or (FileExists('c:\disktef\bin\ichiper.exe')) or (FileExists('c:\BCARD\BCARD.INI')) then
    if Form1.ibDataSet25PAGAR.AsFloat      <> 0 then ecfProgNFComprov('19','TEF                 ','S','S','S','N','S',pChar(sCartao));  // Cartão
  //
  if FileExists('c:\TEF_DISC\TEF_DISC.INI') then
    if Form1.ibDataSet25ACUMULADO1.AsFloat <> 0 then ecfProgNFComprov('17','Cheque              ','S','S','S','N','S',pChar(sCheque));  // Cheque
  //
//  ecfProgNFComprov('03','Sangria             ','N','N','N','N','N',pChar(sDinheiro));
//  ecfProgNFComprov('04','Suprimento          ','N','N','N','N','N',pChar(sDinheiro));
  //
  if Form1.ibDataSet25ACUMULADO1.AsFloat <> 0 then (ecfPagamento(0,pChar(sCheque)  ,pChar(StrZero(Form1.ibDataSet25ACUMULADO1.AsFloat * 100,10,0)),0)); // Cheque
  if Form1.ibDataSet25ACUMULADO2.AsFloat <> 0 then (ecfPagamento(0,pChar(sDinheiro),pChar(StrZero(Form1.ibDataSet25ACUMULADO2.AsFloat * 100,10,0)),0)); // Dinheiro
  if Form1.ibDataSet25PAGAR.AsFloat      <> 0 then (ecfPagamento(0,pChar(sCartao)  ,pChar(StrZero(Form1.ibDataSet25PAGAR.AsFloat      * 100,10,0)),0)); // Cartão
  if Form1.ibDataSet25DIFERENCA_.Asfloat <> 0 then (EcfPagamento(0,pChar(sPrazo)   ,pChar(StrZero(Form1.ibDataSet25DIFERENCA_.Asfloat * 100,10,0)),0)); // Prazo                        // Prazo
  if Form1.ibDataSet25VALOR01.AsFloat    <> 0 then (ecfPagamento(0,pChar(sExtra1)  ,pChar(StrZero(Form1.ibDataSet25VALOR01.AsFloat * 100,10,0)),0));    // Forma extra 1
  if Form1.ibDataSet25VALOR02.AsFloat    <> 0 then (ecfPagamento(0,pChar(sExtra2)  ,pChar(StrZero(Form1.ibDataSet25VALOR02.AsFloat * 100,10,0)),0));    // Forma extra 2
  if Form1.ibDataSet25VALOR03.AsFloat    <> 0 then (ecfPagamento(0,pChar(sExtra3)  ,pChar(StrZero(Form1.ibDataSet25VALOR03.AsFloat * 100,10,0)),0));    // Forma extra 3
  if Form1.ibDataSet25VALOR04.AsFloat    <> 0 then (ecfPagamento(0,pChar(sExtra4)  ,pChar(StrZero(Form1.ibDataSet25VALOR04.AsFloat * 100,10,0)),0));    // Forma extra 4
  if Form1.ibDataSet25VALOR05.AsFloat    <> 0 then (ecfPagamento(0,pChar(sExtra5)  ,pChar(StrZero(Form1.ibDataSet25VALOR05.AsFloat * 100,10,0)),0));    // Forma extra 5
  if Form1.ibDataSet25VALOR06.AsFloat    <> 0 then (ecfPagamento(0,pChar(sExtra6)  ,pChar(StrZero(Form1.ibDataSet25VALOR06.AsFloat * 100,10,0)),0));    // Forma extra 6
  if Form1.ibDataSet25VALOR07.AsFloat    <> 0 then (ecfPagamento(0,pChar(sExtra7)  ,pChar(StrZero(Form1.ibDataSet25VALOR07.AsFloat * 100,10,0)),0));    // Forma extra 7
  if Form1.ibDataSet25VALOR08.AsFloat    <> 0 then (ecfPagamento(0,pChar(sExtra8)  ,pChar(StrZero(Form1.ibDataSet25VALOR08.AsFloat * 100,10,0)),0));    // Forma extra 8
  //
  J := 0;
  Form1.sMensagemPromocional := Form1.sMensagemPromocional + chr(10);
  //
  for I := 1 to Length(Form1.sMensagemPromocional) do
  begin
    J := J + 1;
    if Copy(Form1.sMensagemPromocional,I,1) = Chr(10) then
    begin
      EcfImpLinha( pChar( Copy(Form1.sMensagemPromocional,I-J+1,J-1) ) );
//      ShowMessage( Copy(Form1.sMensagemPromocional,I-J+1,J-1) );
      J := 0;
    end;
  end;
  //
  // EcfImpLinha(Pchar(Form1.sMensagemPromocional));
  //
  ecfFimTrans('');
  for I := 1 to 8 do ecfLineFeed(1,1);
  //
  Result := True;
  //
  //
end;

// ------------------------------ //
// Fecha o cupom que está sendo   //
// emitido                        //
// IF SCHALTER SPRINT             //
// ------------------------------ //
function _ecf05_FechaCupom(Pp1: Boolean):Boolean;
begin
  // ------------------ //
  // acréscimo          //
  // ------------------ //
  if Form1.fTotal < Form1.ibDataSet25RECEBER.AsFloat then
    ecfCancAcresDescSubTotal( 1, 0,'ACRÉSCIMO',Pchar(StrZero((Form1.ibDataSet25RECEBER.AsFloat - Form1.fTotal)*100,10,0)));
  // ------------------ //
  // Desconto           //
  // ------------------ //
  if Form1.fTotal >= Form1.ibDataSet25RECEBER.AsFloat then
    ecfCancAcresDescSubTotal( 0, 0,'DESCONTO',Pchar(StrZero((Form1.fTotal - Form1.ibDataSet25RECEBER.AsFloat)*100,10,0)));
  //
  _ecf05_codeErro(ecfSubTotal());
  //
  Result := True;
  //
end;

// --------------------- //
// Cancela o último item //
// IF SHALTER SPRINT     //
// --------------------- //
function _ecf05_CancelaUltimoItem(Pp1: Boolean):Boolean;
begin
  // if _ecf05_CancelaItemN('0000','') then Result := True else Result := False;
  ShowMessage('Use o sinal - e o número do item que deve ser cancelado.');
  Result := False;
end;

// ------------------------------ //
// Cancela o último cupom emitido //
// IF SHALTER SPRINT              //
// ------------------------------ //
function _ecf05_CancelaUltimoCupom(Pp1: Boolean):Boolean;
begin
  //
  if Pp1 then
  begin
    if _ecf05_codeErro(ecfCancDoc('')) = 0 then Result := True else Result := False;
    ecfLineFeed(1,7); // Imprime 7 linhas em Branco
  end else Result := False;
  //
end;


// ------------------- //
// Sub-Total           //
// IF SHALTER SPRINT   //
// ------------------- //
function _ecf05_SubTotal(Pp1: Boolean):Real;
var
  I : Integer;
  pMensagem : pChar;
begin
  //
  Result := 0;
  try
    I := 0;
    pMensagem := EcfStatusCupom(I);
    //
    if Copy( pMensagem ,1,4) = 'Erro' then Result := 0
       else Result := StrToFloat(StrTran(StrTran(Copy(pMensagem,26,21),',',''),'.',''))/100; // Sub-Total //
  except end;
end;

// ------------------------------ //
// Abre um novo copom fiscal      //
// IF SHALTER SPRINT              //
// ------------------------------ //
function _ecf05_AbreNovoCupom(Pp1: Boolean):Boolean;
begin
  //
  case _ecf05_codeErro(ecfImpCab(30)) of
  0  : Result := True;
  65 : Result := True;
//  68 : Result := True;
  68 : begin _ecf05_FechaCupom2(True); Result := False; end;
//  81 : Result := True;
  100: Result := True;
  else Result := False; end;
  //
end;

// -------------------------------- //
// Retorna o número do Cupom        //
// IF SHALTER SPRINT                //
// -------------------------------- //
function _ecf05_NumeroDoCupom(Pp1: Boolean):String;
var
  I : Integer;
begin
  I := 0;
  Result    := ecfStatusCupom(I);
  if Copy(Result,1,4) = 'Erro' then
  begin
    _ecf05_codeErro(StrToInt(Copy(Result,6,2)));
    Result := '0000000';
  end else if pP1 then Result := Copy(Result ,6,6) else Result := StrZero(StrToInt(Copy(Result ,6,6))-1,6,0); // Número do ECF
  //
end;

// ------------------------------ //
// Cancela um item N              //
// IF SHALTER SPRINT              //
// ------------------------------ //
function _ecf05_CancelaItemN(pP1, pP2 : String):Boolean;
begin
  //
  if _ecf05_codeErro(ecfCancItemDef(Pchar( StrZero(StrToInt(pP1),3,0) ),'')) = 0 then Result := True else Result := False;
  //
end;

// -------------------------------- //
// Abre a gaveta                    //
// IF SHALTER SPRINT              //
// -------------------------------- //
function _ecf05_AbreGaveta(Pp1: Boolean):Boolean;
begin
  ecfAbreGaveta();
  Result := True;
end;

// -------------------------------- //
// Status da gaveta                 //
// IF SHALTER SPRINT              //
// -------------------------------- //
function _ecf05_StatusGaveta(Pp1: Boolean):String;
begin
  if Form1.iStatusGaveta = 0 then
  begin
    if Copy(ecfStatusImp(),8,1) = '0' then Result := '000' else Result := '255';
  end else
  begin
    if Copy(ecfStatusImp(),8,1) = '0' then Result := '255' else Result := '000';
  end;
end;

// -------------------------------- //
// SAngria                          //
// IF SHALTER SPRINT              //
// -------------------------------- //
function _ecf05_Sangria(Pp1: Real):Boolean;
begin
  //
  ecfProgNFComprov('03','Sangria             ','N','N','N','N','N','00');
  _ecf05_codeErro(ecfImpCab(0));
  _ecf05_codeErro(ecfInicCupomNFiscal(1));
  _ecf05_codeErro(ecfVendaItem('Sangria',pChar(StrZero(pP1*100,9,0)),03));
  _ecf05_codeErro(ecfPagCancPag(0,'Sangria   ',pChar(StrZero(pP1*100,9,0)),0,1));
  _ecf05_codeErro(ecfFimTrans(''));
  ecfLineFeed(1,8);
  Result := True;
  //
end;

// -------------------------------- //
// Suprimento                       //
// IF SHALTER SPRINT              //
// -------------------------------- //
function _ecf05_Suprimento(Pp1: Real):Boolean;
begin
  //
  ecfProgNFComprov('04','Suprimento          ','N','N','N','N','N','00');
  _ecf05_codeErro(ecfImpCab(0));
  _ecf05_codeErro(ecfInicCupomNFiscal(1));
  _ecf05_codeErro(ecfVendaItem('Suprimento',pChar(StrZero(pP1*100,9,0)),04));
  _ecf05_codeErro(ecfPagCancPag(0,'Suprimento',pChar(StrZero(pP1*100,9,0)),0,1));
  _ecf05_codeErro(ecfFimTrans(''));
  ecfLineFeed(1,8);
  Result := True;
  //
end;

// -------------------------------- //
// Nova Aliquota                    //
// IF SHALTER SPRINT                //
// -------------------------------- //
function _ecf05_NovaAliquota(Pp1: String):Boolean;
begin
  Result := True;
end;

function _ecf05_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
begin
  ShowMessage('Função não suportada pelo modelo de ECF utilizado.');
  Result := True;
end;


function _ecf05_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
begin
  //
  if Form7.Label3.Caption = 'Data inicial:' then
  begin
    _ecf05_codeErro(ecfLeitMemFisc(1,pChar(pP1),pChar(pP2), 0,0, 'MEMORIA.TXT'));
  end else
  begin
    _ecf05_codeErro(ecfLeitMemFisc(2,'','',StrToInt(pP1),StrToInt(pP2),'MEMORIA.TXT'));
  end;
  // --------------- //
  // Avanço de linha //
  // --------------- //
  ecfLineFeed(1,7);
  //
  Result := True;
end;


// -------------------------------- //
// Venda do Item                    //
// IF SHALTER SPRINT              //
// -------------------------------- //
function _ecf05_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
begin
  //
  if pP3 = 'II' then pP3 := '18'; // Adicionei  ao valor p/q desconto 1 na linha abaixo
  if pP3 = 'FF' then pP3 := '17'; // Adicionei  ao valor p/q desconto 1 abaixo
  if pP3 = 'NN' then pP3 := '19'; // Adicionei  ao valor p/q desconto 1 abaixo
  if pP3 = '  ' then pP3 := '18'; // Adicionei  ao valor p/q desconto 1 abaixo
  //

  _ecf05_codeErro(
   ecfVendaItem3d(
            pChar(Copy(pP1+Replicate(' ',13),1,13)                 ),    // Código
            pChar(Copy(pP2+Replicate(' ',62),1,62)                 ),    // Descricao

            pChar( Copy(pP4,1,4)+','+Copy(pP4,5,3) ),        // Quantidade


//            pChar( StrZero(StrToInt(LimpaNumero(Copy(Format('%7.3n',[StrToFloat(pP4)/1000]),1,4))),3,0))+','+    // Quantidade //
//            pChar( StrZero(StrToInt(LimpaNumero(Copy(Format('%7.3n',[StrToFloat(pP4)/1000]),5,3))),3,0)),        // Quantidade //



            pChar(StrZero(StrToInt(LimpaNumero(pP5)),9,0)                  ),    // Valor 9 Caracteres //
            (StrToInt(pP3)-1),                                                   // Aliquota
            Copy(pP6,1,2),                                                       // Peça
            pChar(Copy(AllTrim(Form1.ConfPreco),1,1))
            ));                                                                  // Aliquota


  // *****************
  // Desconto em %   *
  // *****************

  if StrToInt(pP7) > 0 then _ecf05_codeErro(ecfDescItem(0,' ',pChar(StrZero(((StrToInt(pp5)/ StrToInt('1'+Replicate('0',StrToInt(Form1.ConfPreco)))  * StrToInT(pP4)/1000)*StrToInt(pp7)/100),9,0))));

  // *****************
  // Desconto em R$  *
  // *****************

  if StrToInt(pP8) > 0 then _ecf05_codeErro(ecfDescItem(0,' ',pChar(StrZero(StrToInt(pP8),9,0))));

//  _ecf05_codeErro(
//    ecfVenda_Item(
//
//            pChar(Copy(pP1+Replicate(' ',13),1,13)                 ),    // Código
//            pChar(Copy(pP2+Replicate(' ',62),1,62)                 ),    // Descricao
//
//            pChar( StrZero(StrToInt(Copy(Format('%7.3n',[StrToFloat(pP4)/1000]),1,3)),3,0)),    // Quantidade
//            pChar( StrZero(StrToInt(Copy(Format('%7.3n',[StrToFloat(pP4)/1000]),5,3)),3,0)),    // Quantidade
//
//            pChar(StrZero(StrToInt(pP5),9,0)                  ),    // Valor 9 Caracteres //
//            StrToInt(pP3)-1)); // Aliquota
  Result := True;
  //
end;

// -------------------------------- //
// Reducao Z                        //
// IF SHALTER SPRINT              //
// -------------------------------- //
function _ecf05_ReducaoZ(pP1: Boolean):Boolean;
begin
  _ecf05_codeErro(ecfReducaoZ(''));
  ecfLineFeed(1,6);
  Result := True;
end;

// -------------------------------- //
// Leitura X                        //
// IF SHALTER SPRINT              //
// -------------------------------- //
function _ecf05_LeituraX(pP1: Boolean):Boolean;
begin
  if _ecf05_codeErro(ecfLeituraX('00000000')) = 0 then
  Result := True else Result := False;
  ecfLineFeed(1,10);
end;

// ---------------------------------------------- //
// Retorna se o horario de verão está selecionado //
// IF SHALTER SPRINT                            //
// ---------------------------------------------- //
function _ecf05_RetornaVerao(pP1: Boolean):Boolean;
begin
  Result := False;
end;

// -------------------------------- //
// Liga ou desliga horário de verao //
// IF SHALTER SPRINT              //
// -------------------------------- //
function _ecf05_LigaDesLigaVerao(pP1: Boolean):Boolean;
begin
  Result := True;
end;

// -------------------------------- //
// Retorna a versão do firmware     //
// IF SHALTER SPRINT              //
// -------------------------------- //
function _ecf05_VersodoFirmware(pP1: Boolean): String;
begin
  Result := 'Marca:' + Copy(ecfStatusEquipo(),01,10) + Chr(10) +
            'Modelo:' + Copy(ecfStatusEquipo(),11,15) + Chr(10) +
            'Firmware: ' + Copy(ecfStatusEquipo(),26,04);
end;

// -------------------------------- //
// Retorna o número de série        //
// IF SHALTER SPRINT              //
// -------------------------------- //
function _ecf05_NmerodeSrie(pP1: Boolean): String;
begin
//  try
    Result := Copy(ecfStatusEquipo(),30,09);
//  except
//    Result := Copy(ecfStatusEquipo(),30,09);
//    ecfFimTrans('')
//  end;
end;

// -------------------------------- //
// Retorna o CGC e IE               //
// IF SHALTER SPRINT                //
// -------------------------------- //
function _ecf05_CGCIE(pP1: Boolean): String;
begin
  Result := ecfCGC_IE() + Replicate(' ',32);
  Result := 'CGC: ' + Copy(Result,1,18) + Chr(10) +
            'IE: ' +  Copy(Result,19,14);
end;

// --------------------------------- //
// Retorna o número de cancelamentos //
// IF SHALTER SPRINT               //
// --------------------------------- //
function _ecf05_Cancelamentos(pP1: Boolean): String;
var
  S1,
  S2,
  atm00,
  atm01,
  atm02,
  atm03,
  atm04,
  atm05,
  atm06,
  atm07,
  atm08,
  atm09
   : String;
begin

     S1   := Replicate('X',173);
     S2   := Replicate('X',163);
     atm00 := Replicate('X',42);
     atm01 := Replicate('X',42);
     atm02 := Replicate('X',42);
     atm03 := Replicate('X',42);
     atm04 := Replicate('X',42);
     atm05 := Replicate('X',42);
     atm06 := Replicate('X',42);
     atm07 := Replicate('X',42);
     atm08 := Replicate('X',42);
     atm09 := Replicate('X',42);

     _ecf05_codeErro(ecfParamLXSerial(  S1,
                        S2,
                        atm00,
                        atm01,
                        atm02,
                        atm03,
                        atm04,
                        atm05,
                        atm06,
                        atm07,
                        atm08,
                        atm09));

  Result := StrTran(StrTran(Copy(S1,29+6,21),',',''),'.','');
end;


// -------------------------------- //
// Retorna o valor de descontos     //
// IF SHALTER SPRINT              //
// -------------------------------- //
function _ecf05_Descontos(pP1: Boolean): String;
var
  S1,
  S2,
  atm00,
  atm01,
  atm02,
  atm03,
  atm04,
  atm05,
  atm06,
  atm07,
  atm08,
  atm09
   : String;
begin

     S1   := Replicate('X',173);
     S2   := Replicate('X',163);
     atm00 := Replicate('X',42);
     atm01 := Replicate('X',42);
     atm02 := Replicate('X',42);
     atm03 := Replicate('X',42);
     atm04 := Replicate('X',42);
     atm05 := Replicate('X',42);
     atm06 := Replicate('X',42);
     atm07 := Replicate('X',42);
     atm08 := Replicate('X',42);
     atm09 := Replicate('X',42);

     _ecf05_codeErro(ecfParamLXSerial(  S1,
                        S2,
                        atm00,
                        atm01,
                        atm02,
                        atm03,
                        atm04,
                        atm05,
                        atm06,
                        atm07,
                        atm08,
                        atm09));
  try
    Result := StrTran(Copy(S1,56,21),',','');
  except Result := '0' end;

end;

// -------------------------------- //
// Retorna o contados sequencial    //
// IF SHALTER SPRINT              //
// -------------------------------- //
function _ecf05_ContadorSeqencial(pP1: Boolean): String;
var
  S1,
  S2,
  atm00,
  atm01,
  atm02,
  atm03,
  atm04,
  atm05,
  atm06,
  atm07,
  atm08,
  atm09
   : String;
begin

     S1   := Replicate('X',173);
     S2   := Replicate('X',163);
     atm00 := Replicate('X',42);
     atm01 := Replicate('X',42);
     atm02 := Replicate('X',42);
     atm03 := Replicate('X',42);
     atm04 := Replicate('X',42);
     atm05 := Replicate('X',42);
     atm06 := Replicate('X',42);
     atm07 := Replicate('X',42);
     atm08 := Replicate('X',42);
     atm09 := Replicate('X',42);

     _ecf05_codeErro(ecfParamLXSerial(  S1,
                        S2,
                        atm00,
                        atm01,
                        atm02,
                        atm03,
                        atm04,
                        atm05,
                        atm06,
                        atm07,
                        atm08,
                        atm09));

  Result := Copy(S1,23,6);

end;

// -------------------------------- //
// Retorna o número de operações    //
// não fiscais acumuladas           //
// IF SHALTER SPRINT              //
// -------------------------------- //
function _ecf05_Nmdeoperaesnofiscais(pP1: Boolean): String;
begin
  Result := '';
end;

function _ecf05_NmdeCuponscancelados(pP1: Boolean): String;
begin
  Result := '';
end;

function _ecf05_NmdeRedues(pP1: Boolean): String;
var
  S1,
  S2,
  atm00,
  atm01,
  atm02,
  atm03,
  atm04,
  atm05,
  atm06,
  atm07,
  atm08,
  atm09
   : String;
begin

     S1   := Replicate('X',173);
     S2   := Replicate('X',163);
     atm00 := Replicate('X',42);
     atm01 := Replicate('X',42);
     atm02 := Replicate('X',42);
     atm03 := Replicate('X',42);
     atm04 := Replicate('X',42);
     atm05 := Replicate('X',42);
     atm06 := Replicate('X',42);
     atm07 := Replicate('X',42);
     atm08 := Replicate('X',42);
     atm09 := Replicate('X',42);

     _ecf05_codeErro(ecfParamLXSerial(  S1,
                        S2,
                        atm00,
                        atm01,
                        atm02,
                        atm03,
                        atm04,
                        atm05,
                        atm06,
                        atm07,
                        atm08,
                        atm09));

  try
    Result := IntToStr(StrToInt(Copy(S1,1,4)));
  except Result := '' end;
end;

function _ecf05_Nmdeintervenestcnicas(pP1: Boolean): String;
var
  S1,
  S2,
  atm00,
  atm01,
  atm02,
  atm03,
  atm04,
  atm05,
  atm06,
  atm07,
  atm08,
  atm09
   : String;
begin

     S1   := Replicate('X',173);
     S2   := Replicate('X',163);
     atm00 := Replicate('X',42);
     atm01 := Replicate('X',42);
     atm02 := Replicate('X',42);
     atm03 := Replicate('X',42);
     atm04 := Replicate('X',42);
     atm05 := Replicate('X',42);
     atm06 := Replicate('X',42);
     atm07 := Replicate('X',42);
     atm08 := Replicate('X',42);
     atm09 := Replicate('X',42);

     _ecf05_codeErro(ecfParamLXSerial(  S1,
                        S2,
                        atm00,
                        atm01,
                        atm02,
                        atm03,
                        atm04,
                        atm05,
                        atm06,
                        atm07,
                        atm08,
                        atm09));

  try
    Result := IntToStr(StrToInt(Copy(S1,13,4)));
  except Result := '' end;
  //
//  ShowMessage(S1);
  //
end;

function _ecf05_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
begin
  Result := 'Informação não disponível.';
end;

function _ecf05_Clichdoproprietrio(pP1: Boolean): String;
begin
  Result := '';
end;

// ------------------------------------ //
// Importante retornar apenas 3 dígitos //
// Ex: 001                              //
// IF SHALTER SPRINT                  //
// ------------------------------------ //
function _ecf05_NmdoCaixa(pP1: Boolean): String;
var
  I : Integer;
begin
  I := 0;
  Result    := ecfStatusCupom(I);
  if Copy(Result,1,4) = 'Erro' then
  begin
///    _ecf05_codeErro( StrToInt(Copy(Result,6,2)) );
    Result := '000';
  end else Result := Copy( Result ,2,3); // Número do ECF
end;

function _ecf05_Nmdaloja(pP1: Boolean): String;
begin
  Result := '';
end;

// ----------------------------- //
// Retorna o padrão do windows   //
// ----------------------------- //
function _ecf05_Moeda(pP1: Boolean): String;
begin
  Result := StrTran(AllTrim(CurrencyString),'$','');
end;

function _ecf05_Dataehoradaimpressora(pP1: Boolean): String;
var
  I : Integer;
  sStatus : String;
begin
  I := 0;
  sStatus := ecfStatusCupom(I);
  if Copy(Result,1,4) = 'Erro' then
  begin
    _ecf05_codeErro( StrToInt(Copy(Result,6,2)) );
    Result := '000000000000';
  end else
  begin
    Result := Copy(sStatus,18,2)+ // Data: 01/01/99
              Copy(sStatus,21,2)+ // Data: 01/01/99
              Copy(sStatus,24,2)+ // Data: 01/01/99
              Copy(sStatus,12,6); // Hora: 120000
  end;
  //
  if (Length(AllTrim(Limpanumero(Result))) <> 12) then
  begin
    ShowMessage('Esta impressora não esta retornando a DATA e a HORA corretamente,'+chr(10)+'no lugar da data e da hora está retornando: '+sStatus);
    ShortDateFormat := 'dd/mm/yy';                                                          {Bug 2001 free}
    Result := StrTran(StrTran(Copy(DateToStr(Date),1,8)+TimeToStr(Time),'/',''),':','');
    ShortDateFormat := 'dd/mm/yyyy';                                                        {Bug 2001 free}
  end;
  //
end;

function _ecf05_Datadaultimareduo(pP1: Boolean): String;
begin
  Result := 'Informação não disponível.';
end;

function _ecf05_Datadomovimento(pP1: Boolean): String;
begin
  Result := 'Informação não disponível.';
end;

function _ecf05_Tipodaimpressora(pP1: Boolean): String;
begin
  Result := 'Informação não disponível.';
end;

// Deve retornar uma String com:                                          //
// Os 2 primeiros dígitos são o número de aliquotas gravadas: Ex 16       //
// os póximos de 4 em 4 são as aliquotas Ex: 1800                         //
// Ex: 161800120005000000000000000000000000000000000000000000000000000000 //
function _ecf05_RetornaAliquotas(pP1: Boolean): String;
var
  Mais1ini : TiniFile;
  sDinheiro : String;
  fTotal : Real;
  S1,
  S2,
  atm00,
  atm01,
  atm02,
  atm03,
  atm04,
  atm05,
  atm06,
  atm07,
  atm08,
  atm09
   : String;
begin
  //
  Result := Replicate('0',128);
  //
  while Result = Replicate('0',128) do
  begin
     //
     S1   := Replicate('X',173);
     S2   := Replicate('X',163);
     atm00 := Replicate('X',42);
     atm01 := Replicate('X',42);
     atm02 := Replicate('X',42);
     atm03 := Replicate('X',42);
     atm04 := Replicate('X',42);
     atm05 := Replicate('X',42);
     atm06 := Replicate('X',42);
     atm07 := Replicate('X',42);
     atm08 := Replicate('X',42);
     atm09 := Replicate('X',42);
     //
     _ecf05_codeErro(ecfParamLXSerial(  S1,
                        S2,
                        atm00,
                        atm01,
                        atm02,
                        atm03,
                        atm04,
                        atm05,
                        atm06,
                        atm07,
                        atm08,
                        atm09));

     Result := '16' +
            Copy(Atm00,1,2) + Copy(Atm00,4,2) +
            Copy(Atm01,1,2) + Copy(Atm01,4,2) +
            Copy(Atm02,1,2) + Copy(Atm02,4,2) +
            Copy(Atm03,1,2) + Copy(Atm03,4,2) +
            Copy(Atm04,1,2) + Copy(Atm04,4,2) +
            Copy(Atm05,1,2) + Copy(Atm05,4,2) +
            Copy(Atm06,1,2) + Copy(Atm06,4,2) +
            Copy(Atm07,1,2) + Copy(Atm07,4,2) +
            Copy(Atm08,1,2) + Copy(Atm08,4,2) +
            Copy(Atm09,1,2) + Copy(Atm09,4,2) +
            '0000' +
            '0000' +
            '0000' +
            '0000' +
            '0000' +
            '0000' +
            '0000';
     //
     if Result[3] = '' then
     begin
      //
      try
        Mais1ini  := TIniFile.Create('frente.ini');
        sDinheiro := Mais1Ini.ReadString('Frente de caixa','Dinheiro'   ,'00');
        Mais1ini.Free; // Sandro Silva 2018-11-21 Memória 
        Result := Replicate('0',128);
        fTotal := _ecf05_Subtotal(True);
        ShowMessage('O cupom aberto será finalizado. Valor do cupom R$'+Format('%12.2n',[fTotal]));
        ecfPagamento(0,pChar(sDinheiro),pChar(StrZero( fTotal * 100,10,0)),0); // Dinheiro
        ecfFimTrans('');
        ecfLineFeed(1,7); // Imprime 7 linhas em Branco
        Form1.Button4.Enabled := True;
      except
        ecfFimTrans('');
        ecfFimTrans('');
        ecfFimTrans('');
      end;
      //
      try
        _ecf05_CancelaUltimoCupom(True);
      except end;
      //
       {
       try
         Result := Replicate('0',128);
         ShowMessage('O cupom aberto será finalizado.');
         fTotal := _ecf05_Subtotal(True);
         ecfPagamento(0,'00',pChar(StrZero(fTotal*100,10,0)),0); // Dinheiro
         ecfFimTrans('');
         ecfLineFeed(1,7); // Imprime 7 linhas em Branco
         Form1.Button4.Enabled := True;
         SaldoDoCaixa(fTotal,'À Vista');
       except
         _ecf05_CancelaUltimoCupom(True);
       end;
       }
       //
     end;
  end;
  //
end;

function _ecf05_Vincula(pP1: String): Boolean;
begin
 Result := True;
end;

function _ecf05_FlagsDeISS(pP1: Boolean): String;
var
  I, iOp1, iOp2 : Integer;
//sString : String;
begin
  // ------------------------------------------ //
  // Flags de Vinculação ao ISS                 //
  // (Cada “bit” corresponde a                  //
  // um totalizador.                            //
  // Um “bit” setado indica vinculação ao ISS)  //
  // ------------------------------------------ //
//sString := '';
//for I := 0 to 15 do
//begin
//  sString := sString + ecfStatusAliquotas(I) + Chr(10);
//end;
//ShowMessage(sString);
  //
  iOp1 := 0;
  for I := 0 to 7 do if Copy(ecfStatusAliquotas(I  ),2,1) = 'S' then iOP1 := iOP1 + potencia(2,7-I);
  iOp2 := 0;
  for I := 0 to 7 do if Copy(ecfStatusAliquotas(I+8),2,1) = 'S' then iOP2 := iOP2 + potencia(2,7-I);
  Result := Chr(iOp1)+chr(iOp2);
  //
end;

function _ecf05_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
begin
  Result := True;
end;

function _ecf05_MudaMoeda(pP1: String): Boolean;
begin
  Result := True;
end;

function _ecf05_MostraDisplay(pP1: String): Boolean;
begin
  Result := True;
end;


function _ecf05_leituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
begin
  //
  if Form7.Label3.Caption = 'Data inicial:' then
  begin
    _ecf05_codeErro(ecfLeitMemFisc(3,pChar(pP2),pChar(pP3), 0,0, pchar(pP1)));
  end else
  begin
    _ecf05_codeErro(ecfLeitMemFisc(4,'','',StrToInt(pP2),StrToInt(pP3), pchar(pP1)));
  end;
  //
  // _ecf05_codeErro(ecfLeitMemFisc(4,'','',StrToInt(pP2),StrToInt(pP3),pChar(pP1)));
  //
  ShowMessage('O seguinte arquivo será gravado: '+pP1);
  Result := True;
  //
end;



function _ecf05_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean;
var
  iRetorno, I, iI, J: Integer;
  sPrazo, sCartao, sCheque : String;
  Mais1ini : TiniFile;
begin

  // ------------------------------------------------------------------------- //
  // Shalter Eletrônica Ltda                                                   //
  // Suporte com Marcial                                                       //
  // (0xx51)3346 3799                                                          //
  // marcial@schalter.com.br                                                   //
  // Alechandre                                                                //
  // ------------------------------------------------------------------------- //
  begin
    //
    Mais1ini  := TIniFile.Create('frente.ini');
    //
    sCheque   := Mais1Ini.ReadString('Frente de caixa','Cheque'    ,'01');
    sCartao   := Mais1Ini.ReadString('Frente de caixa','Cartao'    ,'02');
    sPrazo    := Mais1Ini.ReadString('Frente de caixa','A prazo'   ,'03');
    Mais1ini.Free; // Sandro Silva 2018-11-21 Memória 
    //
    // ShowMessage(sP1);
    //
    iRetorno  := ecfImpCab(30); // Retorna 0
    //
    if iRetorno = 0 then
    begin
      //
      if Form1.ibDataSet25ACUMULADO1.AsFloat > 0 then iRetorno := EcfInicCNFVinculado(pChar(CupomFormatado(Form1.icupom)),'17',pChar(StrZero((Form1.ibDataSet25ACUMULADO1.AsFloat*100),9,0))); // Retorna 146 // Sandro Silva 2021-11-29 if Form1.ibDataSet25ACUMULADO1.AsFloat > 0 then iRetorno := EcfInicCNFVinculado(pChar(StrZero(Form1.icupom,6,0)),'17',pChar(StrZero((Form1.ibDataSet25ACUMULADO1.AsFloat*100),9,0))); // Retorna 146
      if Form1.ibDataSet25DIFERENCA_.AsFloat > 0 then iRetorno := EcfInicCNFVinculado(pChar(CupomFormatado(Form1.icupom)),'18',pChar(StrZero((Form1.ibDataSet25DIFERENCA_.AsFloat*100),9,0))); // Retorna 146 // Sandro Silva 2021-11-29 if Form1.ibDataSet25DIFERENCA_.AsFloat > 0 then iRetorno := EcfInicCNFVinculado(pChar(StrZero(Form1.icupom,6,0)),'18',pChar(StrZero((Form1.ibDataSet25DIFERENCA_.AsFloat*100),9,0))); // Retorna 146
      if Form1.ibDataSet25PAGAR.AsFloat      > 0 then iRetorno := EcfInicCNFVinculado(pChar(CupomFormatado(Form1.icupom)),'19',pChar(StrZero((Form1.ibDataSet25PAGAR.AsFloat*100),9,0)));      // Retorna 146 // Sandro Silva 2021-11-29 if Form1.ibDataSet25PAGAR.AsFloat      > 0 then iRetorno := EcfInicCNFVinculado(pChar(StrZero(Form1.icupom,6,0)),'19',pChar(StrZero((Form1.ibDataSet25PAGAR.AsFloat*100),9,0)));      // Retorna 146
      //
    end;
    //
    if iRetorno = 0 then
    begin
      for iI := 1 to 1 do
      begin
        J := 1;
        for I := 1 to Length(sP1) do
        begin
          if Copy(sP1,I,1) = Chr(10) then
          begin
            iRetorno := ecfImpLinha(pChar(Copy(sP1,J,I-J)));
            J := I + 1;
          end;
        end;
        //
        if iREtorno = 0 then ecfLineFeed(1,7); // Imprime 7 linhas em Branco
        if iRetorno = 0 then sleep(4000);      // Da um tempo; // Da um tempo
      end;
      if iRetorno = 0 then Result := True else Result := False;
      ecfFimTrans('');
      // ecfFimTransVinc('00','01');
      if iREtorno = 0 then ecfLineFeed(1,7); // Imprime 7 linhas em Branco
      //
    end else Result := False;
    //
  end;
  //
end;

function _ecf05_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
var
  iRetorno, I, J: Integer;
begin
  // ------------------------------------------------------------------------- //
  // Shalter Eletrônica Ltda                                                   //
  // Suporte com Marcial                                                       //
  // (0xx51)3346 3799                                                          //
  // marcial@schalter.com.br                                                   //
  // Alechandre                                                                //
  // ------------------------------------------------------------------------- //
  iRetorno := ecfLXGerencial('GERENCIAL');
  //
  J := 1;
  for I := 1 to Length(sP1) do
  begin
    if Copy(sP1,I,1) = Chr(10) then
    begin
      iRetorno := ecfImpLinha(pChar(Copy(sP1,J,I-J)));
      J := I + 3;
    end;
  end;
  //
  if iREtorno = 0 then
  begin
    ecfLineFeed(1,7); // Imprime 7 linhas em Branco
    sleep(4000);      // Da um tempo; // Da um tempo
  end;
  //
  J := 1;
  for I := 1 to Length(sP1) do
  begin
    if Copy(sP1,I,1) = Chr(10) then
    begin
      iRetorno := ecfImpLinha(pChar(Copy(sP1,J,I-J)));
      J := I + 1;
    end;
  end;
  //
  ecfFimTrans('');
  if iREtorno = 0 then ecfLineFeed(1,7); // Imprime 7 linhas em Branco
  if iRetorno = 0 then Result := True else Result := False;
  //
end;

function _ecf05_FechaCupom2(sP1: Boolean): Boolean;
begin
  // -------------------------- //
  ecfFimTrans('');
  ecfFimTrans('');
  ecfFimTrans('');
  Result := True;
  //
end;

//                                      //
// Imprime cheque - Parametro é o valor //
//                                      //
function _ecf05_ImprimeCheque(rP1: Real; sP2: String): Boolean;
begin
  //
  Result := True;
  //
end;

function _ecf05_GrandeTotal(sP1: Boolean): String;
var
 I : Integer;
begin
  I := 0;
  Result := StrTran(StrTran(copy(EcfStatusCupom(I),49,19),',',''),'.','');
end;

function _ecf05_TotalizadoresDasAliquotas(sP1: Boolean): String;
var
  I : Integer;
  pRetorno : PChar;
begin
  //
  for I := 0 to 18 do
  begin
    if I <> 16 then
    begin
      pRetorno := ecfStatusAliquotas(I);
      Result := Result + Right(Replicate('0',14)+StrTran(StrTran(copy(pRetorno,9,15),',',''),'.',''),14);
    end;
  end;
  //
  pRetorno := ecfStatusAliquotas(16);
  Result := Result + Right(Replicate('0',14)+StrTran(StrTran(copy(pRetorno,9,15),',',''),'.',''),14);
  Result := Copy(Result+Replicate('0',438),1,438);
  //
end;

function _ecf05_CupomAberto(sP1: Boolean): boolean;
begin
  Result := False;
end;

function _ecf05_FaltaPagamento(sP1: Boolean): boolean;
begin
  /////////////////////////////////////////////////////
  // Retorna true quando o cupom já foi finalizado e //
  // só esta faltando as formas de pagamento         //
  /////////////////////////////////////////////////////
  Result := False;
  /////////////////////////////////////////////
  // Se a impressora não retorna este status //
  // Result := False;                        //
  /////////////////////////////////////////////
end;

end.


// ------------------------------------------------------------------------- //
// Shalter Eletrônica Ltda                                                   //
// Suporte com Marcial                                                       //
// (0xx51)3346 3799                                                          //
// marcial@schalter.com.br                                                   //
// Alechandre                                                                //
// ------------------------------------------------------------------------- //



