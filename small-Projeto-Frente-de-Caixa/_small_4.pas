unit _Small_4;

interface

uses
  Windows, Messages, SmallFunc_xe, Fiscal, SysUtils,Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Mask, Grids, DBGrids, DB//, DBTables
  , DBCtrls, SMALL_DBEdit, IniFiles, Unit2, Unit22;

  // Alterado p/versão 2005 07/01/2005 - RONEI                                //

  // ------------------------------ //
  // MECAF                          //
  // Suporte: trends                //
  // Contato: Fabricio, Roger,      //
  //          Evandro, Daniel       //
  // Fone: (01454)2181736 Suporte   //
  // Fone: (01454)2181700 comercial //
  // Simone area comercial          //
  // ----------- ------------------ //

  // Comandos Autenticacao e Impressao de Cheques
  // function ModoChequeValidacao(Tipo: string; Load: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  // function ImprimeCheque(Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  // function ImprimeValidacao(Leg: string; LinhaOp: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  // function CancelaChequeValidacao(Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';

  //Comandos Cupons Fiscais

  function TotalizarCupomParcial(Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function TotalizarCupom(Oper: string; Toper: string; Valor: string; LegendaOp: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function Pagamento(Reg: string; Valor: string; Subt: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function FechaCupomFiscal(Msg: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function DescontoItem(Desc: string; Valor: string; LegendaOp: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function AbreCupomFiscal(Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function VendaItem(Fmt: string; Qtde: string; ValUnit: string; Trib: string; Desc: string; Valor: string; Unid: string; Cod: string; Ex: string; Descricao: string; LegendaOp: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function CancelamentoItem(Item: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function CancelaCupomFiscal(Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function LeituraX(RelGer: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function ReducaoZ(RelGer: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function LeMemFiscalData(DataI: string; DataF: string; Res: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function LeMemFiscalReducao(RedI: string; RedF: string; Res: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';

  function LeMemFiscalSerialData(DataI: string; DataF: string; Arq: String; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function LeMemFiscalSerialReducao(RedI: string; RedF: string; Arq: String; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';

  //Comandos Cupons Nao Fiscais
  function AbreCupomVinculado(Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function EncerraCupomNaoFiscal(Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function AbreCupomNaoVinculado(Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function OperRegNaoVinculado(Reg: string; Valor: string; Oper: string; Toper: string; ValorOp: string; LegendaOp: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function CancelaCupomNaoFiscal(Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function ImprimeLinhaNaoFiscal(Atrib: string; Linha: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function ProgramaLegenda(Reg: string; Leg: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  //Comandos Diversos
  function AbrirGaveta(Tipo: string; Ton: string; Toff: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function ProgramaHorarioVerao(Hv: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function ImprimeTotalizadores(Reg: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function TransTabAliquotas(Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function TransTotCont(Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function TransDataHora(Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function EcfPar(Par: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function ProgLinhaAdicional(Leg: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function AjusteHora(Dir: string; Hora: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function EcfID(Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function TransStatusDecod(BufStat: string):Integer; stdcall; external 'TRDECF32.DLL';

//  function TransStatusDecod(BitTest: Integer; BufStat: string):Integer; stdcall; external 'TRDECF32.DLL';
//  function TransStatusDcoD(BufStat: string):Integer; stdcall; external 'TRDECF32.DLL';
//  function TransStatus(BufStat: string):Integer; stdcall; external 'TRDECF32.DLL';
  //Comandos Intervencao Tecnica
  function ProgRelogio(Hora: string; Data: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function GravaDados(CGC: string; IE: string; CCM: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function RecompoeDadosNOVRAM(Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function ProgNumSerie(NumSerie: string; Modelo: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function ProgAliquotas(Trib: string; Valor: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function ProgSimbolo(B1: string; B2: string; B3: string; B4: string; B5: string; B6: string; B7: string; B8: string; B9: string; B10: string; Hab: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function ProgRazaoSocial(Razao: string; Nseq: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';
  function ProgMoeda(Retorno: string; Sing: string; Plural: string):Integer; stdcall; external 'TRDECF32.DLL';
  function ProgArredondamento(Par: string; Retorno: string):Integer; stdcall; external 'TRDECF32.DLL';

  function _ecf04_CodeErro(pP1: Integer; pP2: String):Integer;
  function _ecf04_Inicializa(Pp1: String):Boolean;
  function _ecf04_FechaCupom(Pp1: Boolean):Boolean;
  function _ecf04_Pagamento(Pp1: Boolean):Boolean;
  function _ecf04_CancelaUltimoItem(Pp1: Boolean):Boolean;
  function _ecf04_SubTotal(Pp1: Boolean):Real;
  function _ecf04_AbreGaveta(Pp1: Boolean):Boolean;
  function _ecf04_Sangria(Pp1: Real):Boolean;
  function _ecf04_Suprimento(Pp1: Real):Boolean;
  function _ecf04_NovaAliquota(Pp1: String):Boolean;
  function _ecf04_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
  function _ecf04_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
  function _ecf04_CancelaUltimoCupom(Pp1: Boolean):Boolean;
  function _ecf04_AbreNovoCupom(Pp1: Boolean):Boolean;
  function _ecf04_NumeroDoCupom(Pp1: Boolean):String;
  function _ecf04_CancelaItemN(pP1, pP2: String):Boolean;
  function _ecf04_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
  function _ecf04_ReducaoZ(pP1: Boolean):Boolean;
  function _ecf04_LeituraX(pP1: Boolean):Boolean;
  function _ecf04_RetornaVerao(pP1: Boolean):Boolean;
  function _ecf04_LigaDesLigaVerao(pP1: Boolean):Boolean;
  function _ecf04_VersodoFirmware(pP1: Boolean): String;
  function _ecf04_NmerodeSrie(pP1: Boolean): String;
  function _ecf04_CGCIE(pP1: Boolean): String;
  function _ecf04_Cancelamentos(pP1: Boolean): String;
  function _ecf04_Descontos(pP1: Boolean): String;
  function _ecf04_ContadorSeqencial(pP1: Boolean): String;
  function _ecf04_Nmdeoperaesnofiscais(pP1: Boolean): String;
  function _ecf04_NmdeCuponscancelados(pP1: Boolean): String;
  function _ecf04_NmdeRedues(pP1: Boolean): String;
  function _ecf04_Nmdeintervenestcnicas(pP1: Boolean): String;
  function _ecf04_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
  function _ecf04_Clichdoproprietrio(pP1: Boolean): String;
  function _ecf04_NmdoCaixa(pP1: Boolean): String;
  function _ecf04_Nmdaloja(pP1: Boolean): String;
  function _ecf04_Moeda(pP1: Boolean): String;
  function _ecf04_Dataehoradaimpressora(pP1: Boolean): String;
  function _ecf04_Datadaultimareduo(pP1: Boolean): String;
  function _ecf04_Datadomovimento(pP1: Boolean): String;
  function _ecf04_Tipodaimpressora(pP1: Boolean): String;
  function _ecf04_StatusGaveta(Pp1: Boolean):String;
  function _ecf04_RetornaAliquotas(pP1: Boolean): String;
  function _ecf04_Vincula(pP1: String): Boolean;
  function _ecf04_FlagsDeISS(pP1: Boolean): String;
  function _ecf04_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
  function _ecf04_MudaMoeda(pP1: String): Boolean;
  function _ecf04_MostraDisplay(pP1: String): Boolean;
  function _ecf04_leituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
  function _ecf04_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean;
  function _ecf04_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
  function _ecf04_FechaCupom2(sP1: Boolean): Boolean;
  function _ecf04_ImprimeCheque(rP1: Real; sP2: String): Boolean;
  function _ecf04_GrandeTotal(sP1: Boolean): String;
  function _ecf04_TotalizadoresDasAliquotas(sP1: Boolean): String;
  function _ecf04_CupomAberto(sP1: Boolean): boolean;
  function _ecf04_FaltaPagamento(sP1: Boolean): boolean;

implementation

// ---------------------------------- //
// Tratamento de erros da MECAF       //
// ---------------------------------- //
function _ecf04_CodeErro(pP1: Integer; pP2: String):Integer;
var
  vErro    : array [0..100] of String;  // Cria uma matriz com 50 elementos
begin
  //
//  Form1.Image3.Visible := False;
  //
  if (pP1 = 0) and (copy(pP2,1,1) = '-') then
  begin
    // ShowMessage(pP2);
    try
      pP1 := StrToInt(Copy(pP2,6,2));
    except
      pP1 := 100;
    end;
  end;
  //
  for Result := 1 to 100 do vErro[Result] := 'Erro desconhecido, número: '+IntToStr(Result);
  //
  if (Pos('ppap',pP2) <> 0) then
  begin
//    Form1.Image3.Visible := True;
    pP1 := 100;
    vErro[100] := 'Pouco papel, comando não executado. Precione F9 para fazer a leitura X,'+Chr(10)+
                  ' em seguida troque a bobina.' ;
  end;
  //
  if (Pos('leit x',pP2) <> 0) then
  begin
    pP1 := 100;
    vErro[100] := 'Comando não executado. Precione F9 para fazer a leitura X,'+Chr(10)+
                  'antes de abrir o cupom fiscal.' ;
  end;
  //
  if (Pos('ins bob',pP2) <> 0) then
  begin
    pP1 := 100;
    vErro[100] := 'Verifique se a bobina de papel está bem instalada.';
  end;
  //
  if (Pos('Z pnd',pP2) <> 0) then
  begin
    pP1 := 100;
    vErro[100] := 'Redução Z pendente, o comando não foi executado.'+chr(10)+
                 'O sistema fez automaticamente a redução Z.';
    _ecf04_ReducaoZ(True);
    //Form1.EmitirReducaoZ(Form1);// 2015-10-07 Deve emitir mesas aberta, fechar as aberta a mais de 1 dias antes ou logo após da redução Z
  end;
  //
  if (Pos('cupf',pP2) <> 0) then
  begin
    if pP1 <> 32 then pP1 := 0;
  end;
  //
  Result := pP1;
  //
  if (Copy(pP2,1,1) = '-') and (Result <> 0)  then
  begin
    vErro[01] := 'O cabeçalho contém caracteres invalidados';
    vErro[02] := 'Comando inexistente';
    vErro[03] := 'Valor não numérico em campo numérico';
    vErro[04] := 'Valor fora da faixa entre 20h E 7Fh';
    vErro[05] := 'Campo deve iniciar com @, & ou %';
    vErro[06] := 'Campo deve iniciar com $ , # ou ?';
    vErro[07] := 'O intervalo é inconsistente. O primeiro valor deve ser menor que o segundo valor( no caso de datas, valores anteriores a 010195 serão consideradas como pertencentes ao intervalo de anos 2000-2094.';
    vErro[09] := 'A string “TOTAL” não é aceita';
    vErro[10] := 'A sintaxe do comando está errada';
    vErro[11] := 'Excedeu o nº máximo de linhas permitidas pelo comando';
    vErro[12] := 'O terminador enviado não está obedecendo o protocolo de comunicação';
    vErro[13] := 'O checksum enviado está incorreto';
    vErro[15] := 'A situação tributária deve iniciar com T, F, I ou N';
    vErro[16] := 'Data inválida';
    vErro[17] := 'Hora inválida';
    vErro[18] := 'Alíquota não programada ou fora do intervalo';
    vErro[19] := 'O campo de sinal está incorreto';
    vErro[20] := 'Comando só aceito em Intervenção Fiscal';
    vErro[21] := 'Comando só aceito em modo Normal';
    vErro[22] := 'Necessário abrir cupom fiscal';
    vErro[23] := 'Comando não aceito durante cupom fiscal';
    vErro[24] := 'Necessário abrir cupom não Fiscal';
    vErro[25] := 'Comando não aceito durante Cupom Não Fiscal';
    vErro[26] := 'O  relógio já está em horário de verão ';
    vErro[27] := 'O  relógio não está em horário de verão';
    vErro[28] := 'Necessário realizar Redução Z';
    vErro[29] := 'Fechamento do dia (Redução Z ) já executado';
    vErro[30] := 'Necessário programar legenda';
    vErro[31] := 'Item inexistente ou já cancelado';
    vErro[32] := 'O  cupom anterior não pode ser cancelado';
    vErro[33] := 'Detectado falta de papel';
    vErro[36] := 'Necessário programar os dados do estabelecimento';
    vErro[37] := 'Necessário realizar Intervenção Fiscal';
    vErro[38] := 'A memória fiscal não permite mais realizar vendas. Só é possível executar Leitura X ou Leitura da Memória Fiscal';
    vErro[39] := 'A memória fiscal não permite mais realizar vendas.'+Chr(10)+'Só é possível executar Leitura X ou Leitura da Memória Fiscal correu algum problema na memória NOVRAM. Será necessário realizar uma Intervenção Técnica';
    vErro[40] := 'Necessário programar a data do relógio';
    vErro[41] := 'Número máximo de itens por cupom ultrapassado';
    vErro[42] := 'Já foi realizado o ajuste de hora diário';
    vErro[43] := 'Comando válido ainda em execução';
    vErro[44] := 'Está em estado de impressão de cheque';
    vErro[45] := 'Não está em estado de impressão de cheque';
    vErro[46] := 'Necessário inserir o cheque';
    vErro[47] := 'Necessário inserir nova bobina';
    vErro[48] := 'Necessário executar uma Leitura X';
    vErro[49] := 'Detectado algum problema na impressora ( paper jam, sobretensão, etc).';
    vErro[50] := 'Cupom já foi totalizado';
    vErro[51] := 'Necessário totalizar cupom antes de fechar';
    vErro[52] := 'Necessário finalizar cupom com comando correto';
    vErro[53] := 'Ocorreu erro de gravação na memória fiscal';
    vErro[54] := 'Excedeu número máximo de estabelecimentos';
    vErro[55] := 'Memória Fiscal não inicializada';
    vErro[56] := 'Ultrapassou valor do pagamento';
    vErro[57] := 'Registrador não programado ou troco já realizado';
    vErro[58] := 'Falta completar valor do pagamento';
    vErro[59] := 'Campo somente de caracteres não numéricos (Alfabéticos)';
    vErro[60] := 'Excedeu campo máximo de caracteres';
    vErro[61] := 'Troco não realizado';
    vErro[62] := 'Cmd desabilitado';
    vErro[91] := 'Erro na abertura do arquivo de configuração'+Chr(10)+'É necessário criar o arquivo TRDECF32.CFG';

    vErro[92] := 'Erro de comunicação física: '
                                  + chr(10)
                                  + chr(10) + 'Verifique:'
                                  + chr(10)
                                  + chr(10) + '1. Impressora desligada.'
                                  + chr(10) + '2. Cabo não conectado.'
                                  + chr(10) + '3. Porta de comunicação inválida.'
                                  + chr(10) + '4. Chame um técnico habilitado.';

    vErro[93] := 'Parâmetro com tamanho ou tipo inválido (Erro da DLL)';
    vErro[94] := 'Erro no número de parâmetros (Erro da DLL)';
    vErro[95] := 'Comando fora de seqüência (Erro da DLL)';
    vErro[96] := 'Comando não Implementado (Erro da DLL)';
    vErro[97] := 'Impressora desligada (Erro da DLL)';
    vErro[98] := 'Timeout de Transmissão (Erro da DLL)';
    vErro[99] := 'Timeout de Recepção (Erro da DLL)';
    //
    if (Result = 100) or (Result = 25) then _ecf04_FechaCupom2(True) else Application.MessageBox(Pchar(vErro[Result]),'Atenção',mb_Ok + mb_DefButton1);
    //
  end else
  begin
    if Result = 1 then
    begin
      if Form1.Memo3.Visible then
      begin
        Form1.Panel2.Visible := True;
        Form1.Panel2.BringToFront;
      end;
    end;
  end;
  //
end;


// ----------------------------//
// Detecta qual a porta que    //
// a impressora está conectada //
// MECAF                       //
// --------------------------- //
function _ecf04_Inicializa(Pp1: String):Boolean;
var
  I, Y : Integer;
  Mais1Ini: TIniFile;
  Retorno, sAtual : String;
begin
  //
  GetDir(0,sAtual);
  //
  //
  if not FileExists(sAtual+'\TRDECF32.CFG') then
  begin
    Mais1ini := TIniFile.Create(sAtual+'\TRDECF32.CFG');
    Mais1Ini.WriteString('PORT','COM','4');
    Mais1Ini.Free;
  end;
  //
  Retorno := Replicate(' ',1000);
  TransTabAliquotas(Retorno);
  //                                                    //
  // Se retornar um sinal <> de + não é a porta correta //
  //                                                    //
//  if Form22.Label6.Caption = 'Detectando porta de comunicação...' then
//  begin


    if (Copy(Retorno,1,1) <> '+') then
    begin
      // -------------------------------------------- //
      // Se o retorno for diferente de 0 ele entra no //
      // loop no entando não altera nada.             //
      // -------------------------------------------- //
      for I := 7 downto 1 do
      begin
        if (Copy(Retorno,1,1) <> '+') then
        begin
          Mais1ini := TIniFile.Create(sAtual+'\TRDECF32.CFG');
          Mais1Ini.WriteString('PORT','COM',IntToStr(I));
          Mais1Ini.Free;
          ShowMessage('MECAF'+chr(10)+Chr(10)+'Testando a com'+IntToStr(I));
          // Testa 5 x Cada Porta
          Retorno := Replicate(' ',1000);
          for Y := 1 to 5 do if Copy(Retorno,1,1) <> '+' then TransTabAliquotas(Retorno);
          // ------------------------------------------------ //
          // Se o retorno não for 0 testa as outras as portas //
          // até encontrar a impressora fiscal conectada.     //
          // ------------------------------------------------ //
        end;
      end;
    end;
//  end;
  //
  if Copy(Retorno,1,1) = '+'  then
  begin
    Retorno := Replicate(' ',1000);
    _ecf04_CodeErro(ProgramaLegenda('01','Dinheiro        ',Retorno),'');
    _ecf04_CodeErro(ProgramaLegenda('02','Cheque          ',Retorno),'');
    _ecf04_CodeErro(ProgramaLegenda('03','Cartao          ',Retorno),'');
    _ecf04_CodeErro(ProgramaLegenda('04','A Prazo         ',Retorno),'');
    _ecf04_CodeErro(ProgramaLegenda('16','Sangria         ',Retorno),'');
    _ecf04_CodeErro(ProgramaLegenda('17','Suprimento      ',Retorno),'');
    Result := True;
  end else Result := False;
  //
end;

// ------------------------------ //
// Fecha o cupom que está sendo   //
// emitido                        //
// MECAF                          //
// ------------------------------ //
function _ecf04_FechaCupom(Pp1: Boolean):Boolean;
var
  Retorno : String;
begin
  //
  Retorno := Replicate(' ',1000);
  //
  if Format('%12.2n',[Form1.fTotal]) >= Format('%12.2n',[Form1.ibDataSet25RECEBER.AsFloat]) then
  begin
    // Desconto
    TotalizarCupom(Chr(00), chr(38), StrZero((Form1.fTotal - Form1.ibDataSet25RECEBER.AsFloat)*100,15,0), #00, Retorno);
  end else
  begin
    // Acrescimo
    TotalizarCupom(Chr(64), chr(38),StrZero((Form1.ibDataSet25RECEBER.AsFloat - Form1.fTotal)*100,15,0), #00, Retorno);
  end;
  //
  Result := True;
  //
end;

// ------------------------------ //
// Fecha o cupom que está sendo   //
// emitido                        //
// MECAF                          //
// ------------------------------ //

function _ecf04_Pagamento(Pp1: Boolean):Boolean;
var
  I : Integer;
  Retorno : String;
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
  Mais1ini.Free; // Sandro Silva 2018-11-21 Memória 
  //
  Retorno := Replicate(' ',1000);
  // ------------------ //
  // Forma de pagamento //
  // ------------------ //
  //  ShowMessage(
  //    'Em cheque...: '+StrZero(Form1.ibDataSet25ACUMULADO1.AsFloat*100,14,0)+ Chr(10) +
  //    'Em dinheiro.: '+StrZero(Form1.ibDataSet25ACUMULADO2.AsFloat*100,14,0)+ Chr(10) +
  //    'Receber.....: '+StrZero(Form1.ibDataSet25RECEBER.AsFloat*100,14,0)+ Chr(10)+
  //    'Total.......: '+StrZero(Form1.fTotal*100,14,0)+ Chr(10));
  //
  if Form1.ibDataSet25ACUMULADO1.AsFloat <> 0 then Pagamento(sCheque   , StrZero(Form1.ibDataSet25ACUMULADO1.AsFloat*100,15,0), '0', Retorno);  // Cheque
  if Form1.ibDataSet25ACUMULADO2.AsFloat <> 0 then Pagamento(sDinheiro , StrZero(Form1.ibDataSet25ACUMULADO2.AsFloat*100,15,0), '0', Retorno);  // Dinheiro
  if Form1.ibDataSet25PAGAR.AsFloat      <> 0 then Pagamento(sCartao   , StrZero(Form1.ibDataSet25PAGAR.AsFloat*100,15,0),      '0', Retorno);  // Cartão
  if Form1.ibDataSet25DIFERENCA_.Asfloat <> 0 then Pagamento(sPrazo    , StrZero(Form1.ibDataSet25DIFERENCA_.AsFloat*100,15,0), '0', Retorno);  // Prazo
  if Form1.ibDataSet25VALOR01.AsFloat    <> 0 then Pagamento(sExtra1   , StrZero(Form1.ibDataSet25VALOR01.AsFloat * 100,15,0),  '0', Retorno);  // Forma extra 1
  if Form1.ibDataSet25VALOR02.AsFloat    <> 0 then Pagamento(sExtra2   , StrZero(Form1.ibDataSet25VALOR02.AsFloat * 100,15,0),  '0', Retorno);  // Forma extra 2
  if Form1.ibDataSet25VALOR03.AsFloat    <> 0 then Pagamento(sExtra3   , StrZero(Form1.ibDataSet25VALOR03.AsFloat * 100,15,0),  '0', Retorno);  // Forma extra 3
  if Form1.ibDataSet25VALOR04.AsFloat    <> 0 then Pagamento(sExtra4   , StrZero(Form1.ibDataSet25VALOR04.AsFloat * 100,15,0),  '0', Retorno);  // Forma extra 4
  if Form1.ibDataSet25VALOR05.AsFloat    <> 0 then Pagamento(sExtra5   , StrZero(Form1.ibDataSet25VALOR05.AsFloat * 100,15,0),  '0', Retorno);  // Forma extra 5
  if Form1.ibDataSet25VALOR06.AsFloat    <> 0 then Pagamento(sExtra6   , StrZero(Form1.ibDataSet25VALOR06.AsFloat * 100,15,0),  '0', Retorno);  // Forma extra 6
  if Form1.ibDataSet25VALOR07.AsFloat    <> 0 then Pagamento(sExtra7   , StrZero(Form1.ibDataSet25VALOR07.AsFloat * 100,15,0),  '0', Retorno);  // Forma extra 7
  if Form1.ibDataSet25VALOR08.AsFloat    <> 0 then Pagamento(sExtra8   , StrZero(Form1.ibDataSet25VALOR08.AsFloat * 100,15,0),  '0', Retorno);  // Forma extra 8
  //
  for I := 1 to 36 do Form1.sMensagemPromocional := strtran( Form1.sMensagemPromocional,copy('ÁÀÂÄÃÉÈÊËÍÎÏÓÔÕÚÜÇáàâäãéèêëíîïóôõúüç*',I,1),copy('AAAAAEEEEIIIOOOUUCaaaaaeeeeiiiooouuc*',I,1));
  //
  Pagamento(sDinheiro, '000000000000000', '0', Retorno);  // Rogério incluiu esta linha
  FechaCupomFiscal(AllTrim(Form1.sMensagemPromocional), Retorno);
  Result := True;
  //
end;


// ------------------------------ //
// MECAF                          //
// cancela o último item do cupom //
// ------------------------------ //
function _ecf04_CancelaUltimoItem(Pp1: Boolean):Boolean;
//var
//  Retorno : String;
//  I : Integer;
begin
  //
{
  Retorno := Replicate(' ',1000);
  I := CancelamentoItem(Chr(0), Retorno);
  _ecf04_codeErro(I,Retorno);
  Form1.iCancelaItenN := Form1.iCancelaItenN + 1;
  // ------------------------------------------------------------------ //
  // A variável iCancelaItenN deve ser incrementada quando a impressora //
  // considera não considera que o item já foi cancelado isso evita um  //
  // problema de cancelar um item na tela e no arquivo e na impressora  //
  // cancelar outro.                                                    //
  // ------------------------------------------------------------------ //
  Result := True;
  //}
  ShowMessage('Use o sinal - e o número do item que deve ser cancelado.');
  Result := False;
end;

// -------------------------------//
// MECAF                          //
// Cancela o último cupom emitido //
// -------------------------------//
function _ecf04_CancelaUltimoCupom(Pp1: Boolean):Boolean;
var
  I : Integer;
  Retorno  : String;
begin
  Retorno := Replicate(' ',1000);
  I := CancelaCupomFiscal(Retorno);
  I := _ecf04_codeErro(I,Retorno);
  if I = 0 then Result := True else Result := False;
end;

// -------------------------------//
// MECAF                          //
// Subtotal                       //
// -------------------------------//
function _ecf04_SubTotal(Pp1: Boolean):Real;
var
  I : Integer;
  Retorno : String;
begin
  Retorno := Replicate(' ',100);
  I := EcfPar('96',Retorno);
// ShowMessage(Retorno);
  _ecf04_codeErro(I,Retorno);
  Result := StrToFloat(Copy(Retorno,7,14)) / 100;   // total
// ShowMessage(FloatToStr(Result));
  // --------------------- //
  //  Retorno do Subtotal  //
  // --------------------- //
end;

// ------------------------------ //
// Abre um novo cupom fiscal      //
// MECAF                          //
// ------------------------------ //
function _ecf04_AbreNovoCupom(Pp1: Boolean):Boolean;
var
  I : Integer;
  Retorno : String;
begin
  Retorno := Replicate(' ',1000);
  I := AbreCupomFiscal(Retorno);
  I := _ecf04_codeErro(I,Retorno);
  if I = 0 then Result := True else Result := False;
end;

// -------------------------------- //
// Retorna o número do Cupom        //
// MECAF                            //
// -------------------------------- //
function _ecf04_NumeroDoCupom(Pp1: Boolean):String;
var
  I : Integer;
begin
  Result := Replicate(' ',1000);
  I := EcfPar('41',Result);
  _ecf04_codeErro(I,Result);
  Result := Copy(Result,6,6)
end;

// ------------------------------ //
// Cancela um item N              //
// MECAF                          //
// ------------------------------ //
function _ecf04_CancelaItemN(pP1, pP2 : String):Boolean;
var
  Retorno : String;
  I : Integer;
begin
  //
  Result := False;
  Retorno := Replicate(' ',1000);
  I := CancelamentoItem(StrZero(StrToInt(pP1),3,0), Retorno);
  _ecf04_codeErro(I,Retorno);
  if I = 0 then Result := True;
  // ------------------------------------------------------------------ //
  // A variável iCancelaItenN deve ser incrementada quando a impressora //
  // considera não considera que o item já foi cancelado isso evita um  //
  // problema de cancelar um item na tela e no arquivo e na impressora  //
  // cancelar outro.                                                    //
  // ------------------------------------------------------------------ //
end;

// -------------------------------- //
// Abre a gaveta                    //
// MECAF                            //
// -------------------------------- //
function _ecf04_AbreGaveta(Pp1: Boolean):Boolean;
var
  I : Integer;
  Retorno : String;
begin
  Retorno := Replicate(' ',1000);
  I := AbrirGaveta('0', '12', '48', Retorno);
  _ecf04_codeErro(I,Retorno);
  Result := True;
end;

// -------------------------------- //
// Status da gaveta                 //
// MECAF                            //
//                                  //
// 000 Gaveta Fechada.              //
// 255 Gaveta Aberta.               //
// 128 Valor atribuido quando não   //
//     tem gaveta.                  //
// -------------------------------- //
function _ecf04_StatusGaveta(Pp1: Boolean):String;
var
  Retorno : String;
begin
  Retorno := Replicate(' ',1000);
  TransStatusDecoD(Retorno); // Função não documentada
  //
  if Form1.iStatusGaveta = 0 then
  begin
    if Copy(Retorno,28,1) = '1' then Result := '255' else Result := '000' ;
  end else
  begin
    if Copy(Retorno,28,1) = '1' then Result := '000' else Result := '255' ;
  end;
end;

// -------------------------------- //
// SAngria                          //
// MECAF                            //
// -------------------------------- //
function _ecf04_Sangria(Pp1: Real):Boolean;
var
 Retorno : String;
begin
  //
  Retorno := Replicate(' ',1000);
  AbreCupomNaoVinculado(Retorno);
  OperRegNaoVinculado('16',Strzero(pP1*100,15,0), #00, '%', '0000', #00, Retorno);
  Pagamento('16',StrZero(pP1*100,15,0),'0', Retorno);
  EncerraCupomNaoFiscal(Retorno);
  Result := True;
  //
end;

// -------------------------------- //
// Suprimento                       //
// MECAF                            //
// -------------------------------- //
function _ecf04_Suprimento(Pp1: Real):Boolean;
var
 Retorno : String;
begin
  //
  Retorno := Replicate(' ',1000);
  AbreCupomNaoVinculado(Retorno);
  OperRegNaoVinculado('17',Strzero(pP1*100,15,0), #00, '%', '0000', #00, Retorno);
  Pagamento('17',StrZero(pP1*100,15,0),'0', Retorno);
  EncerraCupomNaoFiscal(Retorno);
  Result := True;
  //
end;

// -------------------------------- //
// Nova Aliquota                    //
// MECAF                            //
// -------------------------------- //
function _ecf04_NovaAliquota(Pp1: String):Boolean;
begin
  // Este comando só pode ser feito mediante uma intervenção técnica //
  ShowMessage('Este comando só poderá ser executado mediante uma'
  + chr(10) + 'intervenção técnica.'
  + chr(10)
  + chr(10) + 'Se realmente for necessário cadastrar uma nova aliquota,'
  + chr(10) + 'Chame um técnico habilitado.');
  Result := True;
end;

function _ecf04_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
begin
  ShowMessage('Função não suportada pelo modelo de ECF utilizado.');
  Result := True;
end;


function _ecf04_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
var
  I : Integer;
  Retorno : String;
begin
  Retorno := Replicate(' ',1000);
  if Length(pP1) = 6 then
  begin
    I := LeMemFiscalData(pP1, pP2,'1', Retorno); // Por data
    _ecf04_codeErro(I,Retorno);
  end else
  begin
    I := LeMemFiscalReducao(StrZero(strToInt(pP1),4,0), StrZero(strToInt(pP2),4,0),'1', Retorno);  // Por intervalo de reduções
    _ecf04_codeErro(I,Retorno);
  end;
  Result := True;
end;


// -------------------------------- //
// Venda do Item                    //
// MECAF                            //
// -------------------------------- //
function _ecf04_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
var
  I : Integer;
  Retorno : String;
  s : String;
begin
  // ---------------------------- //
  // pP1 -> Código     13 dígitos //
  // pP2 -> Descricão  29 dígitos //
  // pP3 -> ST          2 dígitos //
  // pP4 -> Quantidade  7 dígitos //
  // pP5 -> Unitário    7 dígitos //
  // pP6 -> Medida      2 dígitos //
  // ---------------------------- //
  //
  if LimpaNumero(pP3) <> '' then pP3 := StrZero(StrToInt(pP3)-1,2,0);
  //
  pP3 := 'T'+pP3;
  // --------------------------------------------------------------- //
  // Tnn tributado ( nn = 00,01, ...15, alíquota correspondente).    //
  // F00 substituição tributária.                                    //
  // I00 isenção                                                     //
  // N00 não incidência.                                             //
  // --------------------------------------------------------------- //
  if AllTrim(pP6) = '' then pP6 := 'UN';
  if pP3 = 'TII' then pP3 := 'I00';
  if pP3 = 'TFF' then pP3 := 'F00';
  if pP3 = 'TNN' then pP3 := 'N00';
  if pP3 = 'T  ' then pP3 := 'I00';
  //
  if StrToInt(Form1.ConfPreco) = 3 then
  begin
    s    := 'D';
//    pP5  := '0'+Copy(pP5,1,6);
  end else s:= #00;
  //
  // --------------------------------------------------------------- //
  Retorno := Replicate(' ',1000);
  //
  if StrToInt(pP8) > 0 then
  begin
    I := VendaItem(  s,
                     Copy(pP4,2,6),                    // Quantidade
                     StrZero(StrToInt(pP5),11,0),      // Unitario
                     pP3,                              // ST
                     '&',                              // tipo de desconto em valor
                     StrZero(StrToInt(pP8),15,0),      // Valor de desconto em $
                     pP6,                              // Unidade de medida
                     pP1,                              // código
                     '1',                              // Tamanho da descrição onde 1 = 38
                     Copy(pP2+Replicate(' ',38),1,38), // Descrição
                     #00,                              // Legenda
                     Retorno);
  end else
  begin
    I := VendaItem(    s,
                       Copy(pP4,2,6),                    // Quantidade
                       StrZero(StrToInt(pP5),11,0),      // Unitario
                       pP3,                              // ST
                       '%',                              // tipo de desconto em percentual
                       Right(pP7,4),                     // Valor de desconto em %
                       pP6,                              // Unidade de medida
                       pP1,                              // código
                       '1',                              // Tamanho da descrição onde 1 = 38
                       Copy(pP2+Replicate(' ',38),1,38), // Descrição
                       #00,                              // Legenda
                       Retorno);
  end;
  //
  if (Copy(Retorno,1,1) = '+') then Result := True else Result := False;
  //
  // ShoWMessage('Teste '+IntToStr(I)+'  '+Retorno);
  //
  _ecf04_codeErro(I,Retorno);
  //
end;

// -------------------------------- //
// Reducao Z                        //
// MECAF                            //
// -------------------------------- //
function _ecf04_ReducaoZ(pP1: Boolean):Boolean;
var
  I : Integer;
  Retorno : String;
begin
  Retorno := Replicate(' ',1000);
  I := ReducaoZ('0', Retorno);
  _ecf04_codeErro(I,Retorno);
  Result := True;
end;

// -------------------------------- //
// Leitura X                        //
// MECAF                            //
// -------------------------------- //
function _ecf04_LeituraX(pP1: Boolean):Boolean;
var
  I : Integer;
  Retorno : String;
begin
  Retorno := Replicate(' ',1000);
  I := LeituraX('0', Retorno);
  _ecf04_codeErro(I,Retorno);
  Result := True;
end;

// ---------------------------------------------- //
// Retorna se o horario de verão está selecionado //
// MECAF                                          //
// ---------------------------------------------- //
function _ecf04_RetornaVerao(pP1: Boolean):Boolean;
var
  Retorno : String;
begin
  //
  Retorno := Replicate(' ',1000);
  TransStatusDecod(Retorno); // Função não documentada
  if Copy(Retorno,7,1) = '1' then Result := True else Result := False;
  //
end;

// -------------------------------- //
// Liga ou desliga horário de verao //
// MECAF                            //
// -------------------------------- //
function _ecf04_LigaDesLigaVerao(pP1: Boolean):Boolean;
var
  I : Integer;
  Retorno : String;
begin
  Retorno := Replicate(' ',1000);
  if (_ecf04_RetornaVerao(True) = True) then I := ProgramaHorarioVerao('-',Retorno) else I :=  ProgramaHorarioVerao('+',Retorno);
  _ecf04_codeErro(I,Retorno);
  Result := True;
end;


// -------------------------------- //
// Retorna a versão do firmware     //
// MECAF                            //
// -------------------------------- //
function _ecf04_VersodoFirmware(pP1: Boolean): String;
var
  I : Integer;
begin
  Result := Replicate(' ',1000);
  I := EcfPar('47',Result);
  _ecf04_codeErro(I,Result);
  Result := Copy(Result,6,7)
end;

// -------------------------------- //
// Retorna o número de série        //
// MECAF                            //
// -------------------------------- //
function _ecf04_NmerodeSrie(pP1: Boolean): String;
var
  I : Integer;
begin
  Result := Replicate(' ',1000);
  I := EcfPar('49',Result);
  _ecf04_codeErro(I,Result);
  Result := Copy(Result,6,10)
end;

// -------------------------------- //
// Retorna o CGC e IE               //
// MECAF                            //
// -------------------------------- //
function _ecf04_CGCIE(pP1: Boolean): String;
begin
  Result := 'Informação não disponivel na tela, está informação pode ser observada no papel.';
end;

// --------------------------------- //
// Retorna o número de cancelamentos //
// MECAF                             //
// --------------------------------- //
function _ecf04_Cancelamentos(pP1: Boolean): String;
var
  I : Integer;
begin
  Result := Replicate(' ',1000);
  I := EcfPar('38',Result);
  _ecf04_codeErro(I,Result);
  Result := Copy(Result,6,15);
end;


// -------------------------------- //
// Retorna o valor de descontos     //
// MECAF                            //
// -------------------------------- //
function _ecf04_Descontos(pP1: Boolean): String;
var
  I : Integer;
begin
  Result := Replicate(' ',1000);
  I := EcfPar('36',Result);
  _ecf04_codeErro(I,Result);
  Result := Copy(Result,6,15);
end;

// -------------------------------- //
// Retorna o contados sequencial    //
// MECAF                            //
// -------------------------------- //
function _ecf04_ContadorSeqencial(pP1: Boolean): String;
var
  I : Integer;
begin
  Result := Replicate(' ',1000);
  I := EcfPar('41',Result);
  _ecf04_codeErro(I,Result);
  Result := Copy(Result,6,6)
end;

// -------------------------------- //
// Retorna o número de operações    //
// não fiscais acumuladas           //
// MECAF                            //
// -------------------------------- //
function _ecf04_Nmdeoperaesnofiscais(pP1: Boolean): String;
var
  I : Integer;
begin
  Result := Replicate(' ',1000);
  I := EcfPar('45',Result);
  _ecf04_codeErro(I,Result);
  Result := Copy(Result,6,4)
end;

function _ecf04_NmdeCuponscancelados(pP1: Boolean): String;
var
  I : Integer;
begin
  Result := Replicate(' ',1000);
  I := EcfPar('44',Result);
  _ecf04_codeErro(I,Result);
  Result := Copy(Result,6,4)
end;

function _ecf04_NmdeRedues(pP1: Boolean): String;
var
  I : Integer;
begin
  Result := Replicate(' ',1000);
  I := EcfPar('42',Result);
  _ecf04_codeErro(I,Result);
  Result := StrZero((StrToInt(Copy(Result,6,4))+1),4,0);
end;

function _ecf04_Nmdeintervenestcnicas(pP1: Boolean): String;
var
  I : Integer;
begin
  Result := Replicate(' ',1000);
  I := EcfPar('43',Result);
  _ecf04_codeErro(I,Result);
  Result := Copy(Result,6,4)
end;

function _ecf04_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
var
  I : Integer;
begin
  Result := Replicate(' ',1000);
  I := EcfPar('46',Result);
  _ecf04_codeErro(I,Result);
  Result := Copy(Result,6,1)
end;

function _ecf04_Clichdoproprietrio(pP1: Boolean): String;
begin
  Result := 'Informação não disponivel';
end;

// ------------------------------------ //
// Importante retornar apenas 3 dígitos //
// Ex: 001                              //
// MECAF                    //
// ------------------------------------ //
function _ecf04_NmdoCaixa(pP1: Boolean): String;
begin
  //
  Result := Replicate(' ',1000);
  EcfPar('48',Result);
  Result := Copy(Result,9,3);
  Form1.sCaixa := Result;
  //
end;

function _ecf04_Nmdaloja(pP1: Boolean): String;
begin
  Result := 'Informação não disponivel';
end;

function _ecf04_Moeda(pP1: Boolean): String;
begin
  Result := StrTran(AllTrim(CurrencyString),'$','');
end;

// ----------------------------------------- //
// Dia + Mês + Ano + Hora + Minuto + Segundo //
// Ex: 26091976200000                        //
// ----------------------------------------- //
function _ecf04_Dataehoradaimpressora(pP1: Boolean): String;
var
  I : Integer;
begin
  Result := Replicate(' ',1000);
  for I := 1 to 100 do if (Copy(REsult,1,1) <> '+') then TransDataHora(Result);
  Result := Copy(Result,6,2)+   // Dia
            Copy(Result,9,2)+   // Mês
            Copy(Result,12,2)+  // Ano
            Copy(Result,15,2)+  // Hora
            Copy(Result,18,2)+  // Minuto
            Copy(Result,21,2);  // Segundo
end;

function _ecf04_Datadaultimareduo(pP1: Boolean): String;
var
  I : Integer;
begin
  Result := Replicate(' ',1000);
  I := EcfPar('83',Result);
  _ecf04_codeErro(I,Result);
  Result := Copy(Result,6,6)
end;

function _ecf04_Datadomovimento(pP1: Boolean): String;
begin
  Result := 'Informação não disponivel';
end;

function _ecf04_Tipodaimpressora(pP1: Boolean): String;
var
  I : Integer;
begin
  //
  Result := Replicate(' ',1000);
  I := EcfPar('95',Result);
  _ecf04_codeErro(I,Result);
  Result := Copy(Result,6,4);
  //
  if Result = '375P' then Result := 'Mecaf 2 estações 40 col';
  if Result = '300P' then Result := 'Mecaf 1 estação 40 col';
  if Result = '100M' then Result := 'Mecaf 1 estação 48 col';
  //
end;

// Deve retornar uma String com:                                          //
// Os 2 primeiros dígitos são o número de aliquotas gravadas: Ex 16       //
// os póximos de 4 em 4 são as aliquotas Ex: 1800                         //
// Ex: 161800120005000000000000000000000000000000000000000000000000000000 //
function _ecf04_RetornaAliquotas(pP1: Boolean): String;
var
  I : Integer;
begin
  Result := Replicate(' ',1000);
  I := TransTabAliquotas(Result);
  _ecf04_codeErro(I,Result);
  Result := '16'+Copy(AllTrim(StrTran(Result,Chr(0),'0'))+Replicate('0',64),6,60);
  //
end;

function _ecf04_Vincula(pP1: String): Boolean;
begin
  Result := True;
end;


function _ecf04_FlagsDeISS(pP1: Boolean): String;
begin
  // ------------------------------------------ //
  // Flags de Vinculação ao ISS                 //
  // (Cada “bit” corresponde a                  //
  // um totalizador.                            //
  // Um “bit” setado indica vinculação ao ISS)  //
  // ------------------------------------------ //
  Result := Chr(0)+chr(0);
end;

function _ecf04_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
var
  hModulo:THandle;
begin
  hModulo:=GetModuleHandle('TRDECF32.DLL');
  FreeLibrary(hModulo);
  Result := True;
end;

function _ecf04_MudaMoeda(pP1: String): Boolean;
begin
  Result := True;
end;

function _ecf04_MostraDisplay(pP1: String): Boolean;
begin
  Result := True;
end;


function _ecf04_leituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
var
  I : Integer;
  Retorno : String;
begin
  Retorno := Replicate(' ',1000);
  if Length(pP2) = 6 then
  begin
    I := LeMemFiscalSerialData(pP2, pP3, pP1 , Retorno); // Por data
    _ecf04_codeErro(I,Retorno);
  end else
  begin
    I := LeMemFiscalSerialReducao(StrZero(strToInt(pP2),4,0), StrZero(strToInt(pP3),4,0),pP1, Retorno);  // Por intervalo de reduções
    _ecf04_codeErro(I,Retorno);
  end;
  Result := True;
  //
end;

function _ecf04_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean;
var
  Retorno : String;
  iRetorno, J, I, iI : Integer;
begin
  //
  // ShowMessage(sP1);
  //
  begin
    Retorno:=Replicate(' ',1000);
    iRetorno := AbreCupomVinculado(Retorno);
    //
    for iI := 1 to 1 do
    begin
      J := 1;
      for I := 1 to Length(sP1) do
      begin
        if (Copy(Retorno,1,1) = '+') and (iRetorno = 0) then
        begin
          if Copy(sP1,I,1) = Chr(10) then
          begin
            iRetorno := ImprimeLinhaNaoFiscal('0',Copy(pChar(Copy(sP1,J,I-J))+Replicate(' ',40),1,40),Retorno);
            Application.ProcessMessages;
            J := I + 1;
          end;
        end;
      end;
      //
      for I := 1 to 10 do if (Copy(Retorno,1,1) = '+') and (iRetorno = 0) then iRetorno := ImprimeLinhaNaoFiscal('0',Replicate(' ',40),Retorno);
      if (Copy(Retorno,1,1) = '+') and (iRetorno = 0) then sleep(4000); // Da um tempo; // Da um tempo
      //
    end;
    if (Copy(Retorno,1,1) = '+') and (iRetorno = 0) then iRetorno := EncerraCupomNaoFiscal(Retorno);
    if (Copy(Retorno,1,1) = '+') and (iRetorno = 0) then Result := True else Result := False;
    //
  end;
  //
end;

function _ecf04_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
var
  Retorno : String;
  iRetorno, J, I, iI: Integer;
begin
  //
  // ShowMessage(sP1);
  //
  // -------------------------- //
  // MECAF                      //
  // Suporte: trends            //
  // Contato: Roger,            //
  //          Evandro, Daniel   //
  // Fone: (01454)2239000       //
  // Fone: (01454)2181700       //
  // -------------------------- //
  //
  // ShowMessage(sP1);
  //
  begin
    //
    Retorno := Replicate(' ',1000);
    iRetorno := LeituraX('1', Retorno);
    //
    for iI := 1 to 1 do
    begin
      //
      J := 1;
      for I := 1 to Length(sP1) do
      begin
        if (Copy(Retorno,1,1) = '+') and (iRetorno = 0) then
        begin
          if Copy(sP1,I,1) = Chr(10) then
          begin
            iRetorno := ImprimeLinhaNaoFiscal('0',Copy(pChar(Copy(sP1,J,I-J))+Replicate(' ',40),1,40),Retorno);
            Application.ProcessMessages;
            J := I + 1;
          end;
        end;
      end;
      //
      for I := 1 to 10 do if (Copy(Retorno,1,1) = '+') and (iRetorno = 0) then iRetorno := ImprimeLinhaNaoFiscal('0',Replicate(' ',40),Retorno);
      if (Copy(Retorno,1,1) = '+') and (iRetorno = 0) then sleep(4000); // Da um tempo; // Da um tempo
    end;
    //
    if (Copy(Retorno,1,1) = '+') and (iRetorno = 0) then iRetorno := EncerraCupomNaoFiscal(Retorno);
    if (Copy(Retorno,1,1) = '+') and (iRetorno = 0) then Result := True else Result := False;
    //
  end;
  //
end;

function _ecf04_FechaCupom2(sP1: Boolean): Boolean;
var
  Retorno : String;
begin
  Retorno := Replicate(' ',1000);
  EncerraCupomNaoFiscal(Retorno);
  Result := True;
end;

function _ecf04_ImprimeCheque(rP1: Real; sP2: String): Boolean;
begin
  Result := False;
end;

function _ecf04_GrandeTotal(sP1: Boolean): String;
var
  I : Integer;
begin
  Result := Replicate(' ',1000);
  I := TransTotCont(Result);
  _ecf04_codeErro(I,Result);
  Result := Copy(Result,18,19);
end;

function _ecf04_TotalizadoresDasAliquotas(sP1: Boolean): String;
var
  I : Integer;
  sTotalizadores: String;
begin
  //
  sTotalizadores := Replicate(' ',1000);
  I := TransTotCont(sTotalizadores);
  _ecf04_codeErro(I,sTotalizadores);
  //
  Result := '';
  for I := 0 to 14 do Result := Result + Copy(Copy(sTotalizadores,37+(I*15),15),2,14);
  Result := Result + '00000000000000'; // Aliquota 16
  Result := Result + Copy(Copy(sTotalizadores,37+(17*15),15),2,14); // Isenção
  Result := Result + Copy(Copy(sTotalizadores,37+(18*15),15),2,14); // Não Incidência
  Result := Result + Copy(Copy(sTotalizadores,37+(16*15),15),2,14); // Substituição Tributária
  //
  //
  Result := Copy(Result + Replicate('0',438),1,438);
  //
//  ShoWmessage('Teste: '+Result);

  //
end;

function _ecf04_CupomAberto(sP1: Boolean): boolean;
var
  Retorno : String;
//  I : Integer;
//  sMensagem: String;
begin
  //
  Retorno := Replicate(' ',1000);
  TransStatusDecoD(Retorno); // Função não documentada
//  sMensagem := '';
//  for I := 1 to 30 do
//  begin
//    sMensagem := sMensagem + IntToStr(I) + ': '+ Copy(Retorno,I,1)+ chr(10);
//  end;
//  ShowMessage(sMensagem);
  //
  if Copy(Retorno,13,1) = '1' then Result := True else Result := False;
  //
  //
end;

function _ecf04_FaltaPagamento(sP1: Boolean): boolean;
var
  Retorno : String;
  I : Integer;
  sMensagem: String;
begin
  //
  Retorno := Replicate(' ',1000);
  TransStatusDecoD(Retorno); // Função não documentada
  sMensagem := '';
  for I := 13 to 50 do
  begin
    sMensagem := sMensagem + IntToStr(I) + ' = '+ Copy(Retorno,I,1)+ chr(10);
  end;
  //
  //  ShowMessage(sMensagem);
  //
//  if Copy(Retorno,40,1) = '1' then Result := True else Result := False;
  /////////////////////////////////////////////////////
  // Retorna true quando o cupom já foi finalizado e //
  // só esta faltando as formas de pagamento         //
  // Se a impressora não retorna este status         //
  Result := False;
  /////////////////////////////////////////////////////
end;

end.






