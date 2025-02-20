unit _Small_7;

interface

uses
  Windows, Messages, SmallFunc, Fiscal, SysUtils,Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Mask, Grids, DBGrids, DB, DBCtrls, SMALL_DBEdit, IniFiles, Unit2,
  Unit7, Unit22;//,Comms;

  // ------------------ //
  // IF URANO 3.0, 3.03 //
  // ------------------ //

  // ------------------------------------------------------- //
  // IF URANO 1EF e 1EFC Firmware 3.0                        //
  // Alterado em 18/07/00 Motivo: altera��o do modo mercado  //
  // Alterado em 15/01/01 Motivo: CFOP maior                 //
  // Alterado em 22/03/01 Motivo: TEF                        //
  // Alterado em 16/08/01 Motivo: Reg.tipo 60, conv.50/00    //
  // Alterado em 29/10/01 Motivo: Cupom Aberto               //
  // Alterado em 13/03/03 Motivo: Corre��es                  //
  // Alterado em 10/01/04 Motivo: vers�o 2004                //
  // Alterado em 07/06/04 Motivo: download para MG           //
  // Alterado em 07/01/05 Motivo: Vers�o 2005                //
  // ------------------------------------------------------- //
  function InicializaDLL(com:PChar):integer; stdcall;
  function AvancaLinhas(nLinhas:PChar):integer; stdcall;
  function ImprimeCabecalho:integer; stdcall;
  function LeRegistrador(Reg:PChar;Valor:PChar):integer; stdcall;
  function CancelaVenda(Operador:PChar):integer; stdcall;
  function CancelaCupom(Aut:PChar;Op:PChar):integer;stdcall;
  function FinalizaDLL:integer; stdcall;
  function EstadoImpressora:integer; stdcall;
  function AbreGaveta:integer; stdcall;
  function AcrescimoSubtotal(Op:PChar;Desc:PChar;Valor:PChar):integer; stdcall;
  function DescontoSubtotal(Op:PChar;Desc:PChar;Valor:PChar):integer; stdcall;
  function DescontoItem(c:PChar;descr:PChar;valor:PChar):integer; stdcall;
  function Relatorio_XZ(TipoRel:PChar):integer; stdcall;
  function FinalizaRelatorio(Op:PChar):integer; stdcall;
  function Propaganda(Tipo:PChar;Texto:PChar):integer;stdcall;
  function LeSensor(Sensor:PChar):integer; stdcall;
  function VendaItem(Cod:PChar;Desc:PChar;Quant:PChar;Valor:PChar;Taxa:PChar;Uni:PChar;Tipo:PChar):integer; stdcall;
  function CancelaItem(Desc:PChar;Transa:PChar):integer; stdcall;
  function Pagamento(Forma:PChar;Desc:PChar;Valor:PChar;Acumular:PChar):integer; stdcall;
  function FechaCupom(Op:PChar):integer; stdcall;
  function FormaPagamento(Forma:PChar;Desc:PChar):integer; stdcall;
  function SimboloMoeda(Moeda:PChar):integer; stdcall;
  function IdComprador(Nome:PChar;Tipo:PChar;CGC:PChar;Linha1:PChar;Linha2:PChar):integer;stdcall;
  function CargaAliquota(Aliq:PChar;Valor:PChar):integer; stdcall;
  function CargaNaoVinculado(Codigo:PChar;Desc:PChar):integer; stdcall;
  function EmiteNaoVinculado(Codigo:PChar;Desc:PChar;Valor:PChar):integer; stdcall;
  function EmiteVinculado(COO:Pchar;Sequencia:PChar):integer; stdcall;
  function LeituraMF(Tipo:PChar;Inicio:PChar;Fim:PChar;Arquivo:PChar):integer; stdcall;
  function ProgramaRelogio(Tipo:PChar;Data:PChar;Hora:PChar):integer; stdcall;
  function LinhasLivres(Texto:Pchar):integer; stdcall;

     Function _ecf07_LeituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
     function _ecf07_LeReg(NumReg:Integer):String;
     Function _ecf07_MostraDisplay(pP1:String):Boolean;
     function _ecf07_IniPortaStr(pP1:integer):integer;     //
     Function _ecf07_CodeErro(Pp1: Integer):Integer;
     Function _ecf07_Inicializa(Pp1: String):Boolean;
     Function _ecf07_FechaCupom(Pp1: Boolean):Boolean;
     function _ecf07_Pagamento(Pp1: Boolean):Boolean;
     Function _ecf07_CancelaUltimoItem(Pp1: Boolean):Boolean;
     Function _ecf07_SubTotal(Pp1: Boolean):Real;
     Function _ecf07_AbreGaveta(Pp1: Boolean):Boolean;
     Function _ecf07_Sangria(Pp1: Real):Boolean;
     Function _ecf07_Suprimento(Pp1: Real):Boolean;
     Function _ecf07_NovaAliquota(Pp1: String):Boolean;
     Function _ecf07_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
     Function _ecf07_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
     Function _ecf07_CancelaUltimoCupom(Pp1: Boolean):Boolean;
     Function _ecf07_AbreNovoCupom(Pp1: Boolean):Boolean;
     Function _ecf07_NumeroDoCupom(Pp1: Boolean):String;
     Function _ecf07_CancelaItemN(pP1,pP2: String):Boolean;
     Function _ecf07_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
     Function _ecf07_ReducaoZ(pP1: Boolean):Boolean;
     Function _ecf07_LeituraX(pP1: Boolean):Boolean;
     Function _ecf07_RetornaVerao(pP1: Boolean):Boolean;
     Function _ecf07_LigaDesLigaVerao(pP1: Boolean):Boolean;
     Function _ecf07_VersodoFirmware(pP1: Boolean): String;
     Function _ecf07_NmerodeSrie(pP1: Boolean): String;
     Function _ecf07_CGCIE(pP1: Boolean): String;
     Function _ecf07_Cancelamentos(pP1: Boolean): String;
     Function _ecf07_Descontos(pP1: Boolean): String;
     Function _ecf07_ContadorSeqencial(pP1: Boolean): String;
     Function _ecf07_Nmdeoperaesnofiscais(pP1: Boolean): String;
     Function _ecf07_NmdeCuponscancelados(pP1: Boolean): String;
     Function _ecf07_NmdeRedues(pP1: Boolean): String;
     Function _ecf07_Nmdeintervenestcnicas(pP1: Boolean): String;
     Function _ecf07_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
     Function _ecf07_Clichdoproprietrio(pP1: Boolean): String;
     Function _ecf07_NmdoCaixa(pP1: Boolean): String;
     Function _ecf07_Nmdaloja(pP1: Boolean): String;
     Function _ecf07_Moeda(pP1: Boolean): String;
     Function _ecf07_Dataehoradaimpressora(pP1: Boolean): String;
     Function _ecf07_Datadaultimareduo(pP1: Boolean): String;
     Function _ecf07_Datadomovimento(pP1: Boolean): String;
     Function _ecf07_Tipodaimpressora(pP1: Boolean): String;
     Function _ecf07_StatusGaveta(Pp1: Boolean):String;
     Function _ecf07_RetornaAliquotas(pP1: Boolean): String;
     Function _ecf07_Vincula(pP1: String): Boolean;
     Function _ecf07_FlagsDeISS(pP1: Boolean): String;
     Function _ecf07_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
     Function _ecf07_MudaMoeda(pP1: String): Boolean;
     function _ecf07_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean; //iP2 = N�mero d oCupom vinculado
     Function _ecf07_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
     function _ecf07_FechaCupom2(sP1: Boolean): Boolean;
     function _ecf07_ImprimeCheque(rP1: Real; sP2: String): Boolean;
     function _ecf07_GrandeTotal(sP1: Boolean): String;
     function _ecf07_TotalizadoresDasAliquotas(sP1: Boolean): String;
     function _ecf07_CupomAberto(sP1: Boolean): boolean;
     function _ecf07_FaltaPagamento(sP1: Boolean): boolean;


implementation

function InicializaDLL(com:PChar):integer;external 'DLL1EFC3.DLL';
function AvancaLinhas(nLinhas:PChar):integer;external 'DLL1EFC3.DLL';
function ImprimeCabecalho;external 'DLL1EFC3.DLL';
function LeRegistrador(Reg:PChar;Valor:PChar):integer;external 'DLL1EFC3.DLL';
function CancelaVenda(Operador:PChar):integer;external 'DLL1EFC3.DLL';
function CancelaCupom(Aut:PChar;Op:PChar):integer;external 'DLL1EFC3.DLL';
function FinalizaDLL:integer;external 'DLL1EFC3.DLL';
function EstadoImpressora;external 'DLL1EFC3.DLL';
function AbreGaveta;external 'DLL1EFC3.DLL';
function LinhasLivres(Texto:PChar):integer;external 'DLL1EFC3.DLL';
function AcrescimoSubtotal(Op:PChar;Desc:PChar;Valor:PChar):integer;external 'DLL1EFC3.DLL';
function DescontoSubtotal(Op:PChar;Desc:PChar;Valor:PChar):integer;external 'DLL1EFC3.DLL';
function DescontoItem(c:PChar;descr:PChar;valor:PChar):integer;external 'DLL1EFC3.DLL';
function Relatorio_XZ(TipoRel:PChar):integer;external 'DLL1EFC3.DLL';
function FinalizaRelatorio(Op:PChar):integer;external 'DLL1EFC3.DLL';
function Propaganda(Tipo:PChar;Texto:PChar):integer;external 'DLL1EFC3.DLL';
function LeSensor(Sensor:PChar):integer;external 'DLL1EFC3.DLL';
function VendaItem(Cod:PChar;Desc:PChar;Quant:PChar;Valor:PChar;Taxa:PChar;Uni:PChar;Tipo:PChar):integer; external 'DLL1EFC3.DLL';
function CancelaItem(Desc:PChar;Transa:PChar):integer;external 'DLL1EFC3.DLL';
function Pagamento(Forma:PChar;Desc:PChar;Valor:PChar;Acumular:PChar):integer;external 'DLL1EFC3.DLL';
function FechaCupom(Op:PChar):integer;external 'DLL1EFC3.DLL';
function FormaPagamento(Forma:PChar;Desc:PChar):integer;external 'DLL1EFC3.DLL';
function SimboloMoeda(Moeda:PChar):integer;external 'DLL1EFC3.DLL';
function IdComprador(Nome:PChar;Tipo:PChar;CGC:PChar;Linha1:PChar;Linha2:PChar):integer;external 'DLL1EFC3.DLL';
function CargaAliquota(Aliq:PChar;Valor:PChar):integer; external 'DLL1EFC3.DLL';
function CargaNaoVinculado(Codigo:PChar;Desc:PChar):integer; external 'DLL1EFC3.DLL';
function EmiteNaoVinculado(Codigo:PChar;Desc:PChar;Valor:PChar):integer; external 'DLL1EFC3.DLL';
function EmiteVinculado(COO:Pchar;Sequencia:PChar):integer; external 'DLL1EFC3.DLL';
function LeituraMF(Tipo:PChar;Inicio:PChar;Fim:PChar;Arquivo:PChar):integer; external 'DLL1EFC3.DLL';
function ProgramaRelogio(Tipo:PChar;Data:PChar;Hora:PChar):integer; external 'DLL1EFC3.DLL';



// l� um registrador
function _ecf07_LeReg(NumReg:Integer):String;
var
  s1,s2: array[1..255] of char;
  Retorno:integer;
begin
  StrPCopy (@s2,StrZero(NumReg,2,0));
  StrCopy (@s1,'valor inicial');
  Retorno := LeRegistrador(@s2,@s1);
  _ecf07_CodeErro(Retorno);
  Result :=AllTrim(StrPas(@s1));
end;

// Verifica se a forma de pagamento est� cadastrada
function _ecf07_VerificaFormaPgto(Forma:String):String;
var
  i:integer;
begin
    Result:='XX';
    for i := 42 to 51 do
    begin
      if Result='XX' then // s� entra se ainda n�o encontrou
        if Forma='' then  // procura uma forma em branco
         begin
            if Length(AllTrim(_ecf07_LeReg(i))) <= 1 then Result:='0'+IntToStr(i-42);
         end
        else
          if Pos(UpperCase(Forma),UpperCase(_ecf07_LeReg(i))) > 0 then Result:='0'+IntToStr(i-42);
    end;
end;

function _ecf07_VerificaDescricaoFormaPgto(Forma:String):String;
begin
  Result:=AllTrim(_ecf07_LeReg(42+(StrToInt('0'+AllTrim(Forma)))));
  if Result='-' then Result:='';
end;


// Cadastra a forma de pagamento
function _ecf07_CadastraFormaPgto(Forma:String):Boolean;
var
   Retorno:integer;
   s1,s2: array[1..255] of char;
   sX:String;
begin
   Result:=False;
   if _ecf07_VerificaFormaPgto(Forma) = 'XX' then // n�o encontrou
   begin
      //Busca a pr�xima em branco
      sX:=_ecf07_VerificaFormaPgto('');
      if sX <> 'XX' then
      begin
         // cadastra a nova forma de pgto
         StrCopy(@s1,Pchar(sX));
         sX:=UpperCase(AllTrim(Forma));
         StrCopy(@s2,Pchar(sX));
         Retorno:=FormaPagamento(@s1,@s2);
         if Retorno = 0 then Result:=True;
      end;
   end;
end;

// Verifica se o documento n�o vinculado est� cadastrado
function _ecf07_VerificaDocNaoVinc(Doc:String):String;
var
  i:integer;
begin
   Result:='XX';
   for i := 62 to 76 do
   begin
     if Result='XX' then // s� entra se ainda n�o encontrou
       if Doc='' then  // procura uma Doc em branco
        begin
           if Length(AllTrim(_ecf07_LeReg(i))) <= 1 then Result:='0'+IntToStr(i-62);
        end
       else
         if Pos(UpperCase(Doc),UpperCase(_ecf07_LeReg(i))) > 0 then Result:='0'+IntToStr(i-62);
   end;
end;

// Cadastra documento n�o vinculado
function _ecf07_CadastraDocNaoVinc(Doc:String):Boolean;
var
   Retorno:integer;
   s1,s2: array[1..255] of char;
   sX:String;
begin
   Result:=False;
   if _ecf07_VerificaDocNaoVinc(Doc) = 'XX' then // n�o encontrou
   begin
      //Busca a pr�xima em branco
      sX:=_ecf07_VerificaDocNaoVinc('');
      if sX <> 'XX' then
      begin
         // cadastra Doc
         StrCopy(@s1,Pchar(sX));
         sX:=UpperCase(AllTrim(Doc));
         StrCopy(@s2,Pchar(sX));
         Retorno:=CargaNaoVinculado(@s1,@s2);
         if Retorno = 0 then Result:=True;
      end;
   end;
end;

// ---------------------------------- //
// Tratamento de erros da URANO 1EFC  //
// ---------------------------------- //
Function _ecf07_CodeErro(pP1: Integer):Integer;
var
  vErro    : array [0..111] of String;  // Cria uma matriz com  100 elementos
  I        : Integer;
begin
  //
  // Verificar se falta papel, e no sugerir uma leitura X
  //
{  Form1.Image6.Visible := False;
  Form1.Image3.Visible := False;
  Form1.Image4.Visible := False;
  //
  if LeSensor('1') = 49 then
  begin
    Form1.Image6.Visible := True;
    Form1.Image3.Visible := True;
    Form1.Image4.Visible := True;
  end;
  if LeSensor('0') = 49 then
  begin
     showmessage('Fim do papel, coloque uma nova bobina');
  end;
}
  //----------------------------------------------
  if pP1=8 then pP1:=99;
  if pP1=33 then pP1:=0;
  for I := 0 to 111 do vErro[I] := 'Comando n�o executado.';

  vErro[00] := 'Sem erro';
  vErro[01] := 'DLL j� inicializada';
  vErro[02] := 'DLL n�o inicializada';
  vErro[03] := 'Falha no acesso a porta serial';
  vErro[04] := 'Falha na configura��o da porta serial';
  vErro[05] := 'Porta serial n�o inicializada';
  vErro[06] := 'Falha na transmiss�o: outra transmiss�o em andamento';
  vErro[07] := 'Tamanho do comando muito grande para a DLL';
  vErro[08] := 'Impressora fora de linha, desligada ou desconectada';
  vErro[09] := 'Falha geral na transmiss�o do comando';
  vErro[10] := 'Timeout na recep��o da resposta da impressora';//urano1efc
  vErro[11] := 'Falha geral na recep��o da resposta';
  vErro[12] := 'Falha no acesso aos buffers internos da porta serial';
  vErro[13] := 'Erro de frame na comunica��o';
  vErro[14] := 'Erro de overrun na comunica��o';
  vErro[15] := 'Break detectado na comunica��o';
  vErro[16] := 'Erro de acesso a porta serial durante a recep��o';
  vErro[17] := 'Tamanho do buffer de recep��o da porta serial insuficiente para recep��o dos dados.';
  vErro[18] := 'Erro de paridade na comunica��o';
  vErro[19] := 'Tamanho do buffer de transmiss�o da porta serial insuficiente para comunica��o.';
  vErro[20] := 'Falha no acesso ao arquivo de leitura da memoria fiscal';
  vErro[36] := 'Al�quota n�o carregada';
  vErro[54] := 'Tentativa de finalizar cupom sem registrar pagamento';
  vErro[73] := 'O Hor�rio de ver�o s� pode ser ajustado ap�s o fechamento do dia (Leitura Z)';
  vErro[74] := 'O Hor�rio de ver�o s� pode ser ajustado uma vez ao dia';

  vErro[85] := 'Item j� cancelado ou cancelamento n�o permitido';  //urano 1efc
//ver
  vErro[99] := 'Falha de comunica��o '+chr(10)+chr(10)+
               'Sugest�o: verifique as conex�es,'+chr(10)+
               'ligue e desligue a impressora. '+chr(10)+chr(10)+
               'O Sistema ser� Finalizado.';
  //
  if pP1 <> 80 then if (pP1 <> 0) then Application.MessageBox(Pchar('Erro n.'+StrZero(pP1,2,0)+'-'+vErro[pP1]),'Aten��o',mb_Ok + mb_DefButton1);
  //
  Result:=pP1;
  if pP1 = 99 then Halt(1);
end;


// ----------------------------//
// Detecta qual a porta que    //
// a impressora est� conectada //
// --------------------------- //

Function _ecf07_Inicializa(Pp1: String):Boolean; //Urano
var
  I, Retorno : Integer;
  Mais1ini:tinifile;
  sDinheiro,  sCheque,  sCartao,  sPrazo,  sExtra1,  sExtra2,  sExtra3, sExtra4,
  sExtra5,  sExtra6,  sExtra7,  sExtra8 :string;
begin
  //
  Result:=false;
  Retorno:=EstadoImpressora();
  if (Retorno > 116) and (Retorno < 128) then
    Result:=True
  else
  //
  if Form22.Label6.Caption = 'Detectando porta de comunica��o...' then
  begin
    Retorno:=_ecf07_IniPortaStr(StrToInt(Right(pP1,1)));
    for I := 1 to 4 do
    begin
      // ------------------------------------------------ //
      // Se o retorno n�o for 0 testa as outras as portas //
      // at� encontrar a impressora fiscal conectada.     //
      // ------------------------------------------------ //
      if Retorno <> 0 then
      begin
        ShowMessage('1EF e 1EFC - Testando COM'+StrZero(I,1,0));
        Try
          Retorno:=_ecf07_IniPortaStr(I);//'Com'+StrZero(I,1,0));
          Pp1     := 'Com'+StrZero(I,1,0);
          Form1.sPorta  := pP1;
        except end;
      end;
    end;
    if (Retorno <> 0) and (Retorno <> 33) then
       Result:=False
    else
      begin
         Form1.sPorta  := pP1;
         Result := True;
         //vefifica as formas de pagamento e cadastra se n�o existirem
         // l� o arquivo frente.ini
         Mais1ini  := TIniFile.Create('frente.ini');
         sDinheiro := Mais1Ini.ReadString('Impressora fiscal','Dinheiro','XX');
         sCheque   := Mais1Ini.ReadString('Impressora fiscal','Cheque','XX');
         sCartao   := Mais1Ini.ReadString('Impressora fiscal','Cartao','XX');
         sPrazo    := Mais1Ini.ReadString('Impressora fiscal','Prazo','XX');
         if sPrazo='XX' then
         begin
           sPrazo    := Mais1Ini.ReadString('Impressora fiscal','a Prazo','XX');
           Mais1Ini.WriteString('Impressora fiscal','Prazo',sPrazo);
         end;
         sExtra1   := Mais1Ini.ReadString('Impressora fiscal','Ordem forma extra 1','');
         sExtra2   := Mais1Ini.ReadString('Impressora fiscal','Ordem forma extra 2','');
         sExtra3   := Mais1Ini.ReadString('Impressora fiscal','Ordem forma extra 3','');
         sExtra4   := Mais1Ini.ReadString('Impressora fiscal','Ordem forma extra 4','');
         sExtra5   := Mais1Ini.ReadString('Impressora fiscal','Ordem forma extra 5','');
         sExtra6   := Mais1Ini.ReadString('Impressora fiscal','Ordem forma extra 6','');
         sExtra7   := Mais1Ini.ReadString('Impressora fiscal','Ordem forma extra 7','');
         sExtra8   := Mais1Ini.ReadString('Impressora fiscal','Ordem forma extra 8','');

         if (sDinheiro='XX') or (sDinheiro='') then
         begin
            sDinheiro:=_ecf07_VerificaFormaPgto('DINHEIRO');
            if sDinheiro = 'XX' then
            begin
              // v� qual � a pr�xima dispon�vel
              if not _ecf07_CadastraFormaPgto('DINHEIRO') then
                 ShowMessage('O sistema n�o encontrou nenhuma forma de pagamento'+chr(10)+
                             'DINHEIRO, e n�o foi poss�vel Cadastrar.'+chr(10)+
                             'Ser� necess�rio fazer uma interven��o t�cnica');
            end
           else
              Mais1Ini.WriteString('Impressora fiscal','Dinheiro',sDinheiro);
         end;
         if (sCheque='XX') or (sCheque='') then
         begin
            sCheque:=_ecf07_VerificaFormaPgto('Cheque');
            if sCheque = 'XX' then
            begin
              // v� qual � a pr�xima dispon�vel
              if not _ecf07_CadastraFormaPgto('CHEQUE') then
                 ShowMessage('O sistema n�o encontrou nenhuma forma de pagamento'+chr(10)+
                             'CHEQUE, e n�o foi poss�vel Cadastrar.'+chr(10)+
                             'Ser� necess�rio fazer uma interven��o t�cnica');
            end
           else
              Mais1Ini.WriteString('Impressora fiscal','Cheque',sCheque);
         end;
         if (sCartao='XX') or (sCartao='') then
         begin
            sCartao:=_ecf07_VerificaFormaPgto('Cartao');
            if sCartao = 'XX' then
            begin
              // v� qual � a pr�xima dispon�vel
              if not _ecf07_CadastraFormaPgto('CARTAO') then
                 ShowMessage('O sistema n�o encontrou nenhuma forma de pagamento'+chr(10)+
                             'CARTAO, e n�o foi poss�vel Cadastrar.'+chr(10)+
                             'Ser� necess�rio fazer uma interven��o t�cnica');
            end
           else
              Mais1Ini.WriteString('Impressora fiscal','Cartao',sCartao);
         end;
         if (sPrazo='XX') or (sPrazo='') then
         begin
            sPrazo:=_ecf07_VerificaFormaPgto('PRAZO');
            if sPrazo = 'XX' then
            begin
              // v� qual � a pr�xima dispon�vel
              if not _ecf07_CadastraFormaPgto('PRAZO') then
                 ShowMessage('O sistema n�o encontrou nenhuma forma de pagamento'+chr(10)+
                             'PRAZO, e n�o foi poss�vel Cadastrar.'+chr(10)+
                             'Ser� necess�rio fazer uma interven��o t�cnica');
            end
           else
              Mais1Ini.WriteString('Impressora fiscal','Prazo',sPrazo);
         end;
         //verifica as formas extras
         if sExtra1 <> '' then
         begin
           if _ecf07_VerificaDescricaoFormaPgto(sExtra1) = '' then
           begin
             //n�o encontrou, tenta cadastr�-la
             if _ecf07_VerificaFormaPgto(sExtra1) = 'XX' then
             begin
               // v� qual � a pr�xima dispon�vel
               _ecf07_CadastraFormaPgto(Mais1Ini.ReadString('Impressora fiscal','Forma extra 1',''));
               Showmessage('O sistema n�o encontrou nenhuma forma de pagamento'+chr(10)+
                           Mais1Ini.ReadString('Impressora fiscal','Forma extra 1','')+'.'+chr(10)+
                           'Esta forma foi cadastrada, entre no menu F10-Formas de pagamento para definir sua ordem.');
             end;
           end;
         end;
         if sExtra2 <> '' then
         begin
           if _ecf07_VerificaDescricaoFormaPgto(sExtra2) = '' then
           begin
             //n�o encontrou, tenta cadastr�-la
             if _ecf07_VerificaFormaPgto(sExtra2) = 'XX' then
             begin
               // v� qual � a pr�xima dispon�vel
               _ecf07_CadastraFormaPgto(Mais1Ini.ReadString('Impressora fiscal','Forma extra 2',''));
               Showmessage('O sistema n�o encontrou nenhuma forma de pagamento'+chr(10)+
                           Mais1Ini.ReadString('Impressora fiscal','Forma extra 2','')+'.'+chr(10)+
                           'Esta forma foi cadastrada, entre no menu F10-Formas de pagamento para definir sua ordem.');
             end;
           end;
         end;
         if sExtra3 <> '' then
         begin
           if _ecf07_VerificaDescricaoFormaPgto(sExtra3) = '' then
           begin
             //n�o encontrou, tenta cadastr�-la
             if _ecf07_VerificaFormaPgto(sExtra3) = 'XX' then
             begin
               // v� qual � a pr�xima dispon�vel
               _ecf07_CadastraFormaPgto(Mais1Ini.ReadString('Impressora fiscal','Forma extra 3',''));
               Showmessage('O sistema n�o encontrou nenhuma forma de pagamento'+chr(10)+
                           Mais1Ini.ReadString('Impressora fiscal','Forma extra 3','')+'.'+chr(10)+
                           'Esta forma foi cadastrada, entre no menu F10-Formas de pagamento para definir sua ordem.');
             end;
           end;
         end;
         if sExtra4 <> '' then
         begin
           if _ecf07_VerificaDescricaoFormaPgto(sExtra4) = '' then
           begin
             //n�o encontrou, tenta cadastr�-la
             if _ecf07_VerificaFormaPgto(sExtra4) = 'XX' then
             begin
               // v� qual � a pr�xima dispon�vel
               _ecf07_CadastraFormaPgto(Mais1Ini.ReadString('Impressora fiscal','Forma extra 4',''));
               Showmessage('O sistema n�o encontrou nenhuma forma de pagamento'+chr(10)+
                           Mais1Ini.ReadString('Impressora fiscal','Forma extra 4','')+'.'+chr(10)+
                           'Esta forma foi cadastrada, entre no menu F10-Formas de pagamento para definir sua ordem.');
             end;
           end;
         end;
         if sExtra5 <> '' then
         begin
           if _ecf07_VerificaDescricaoFormaPgto(sExtra5) = '' then
           begin
             //n�o encontrou, tenta cadastr�-la
             if _ecf07_VerificaFormaPgto(sExtra5) = 'XX' then
             begin
               // v� qual � a pr�xima dispon�vel
               _ecf07_CadastraFormaPgto(Mais1Ini.ReadString('Impressora fiscal','Forma extra 5',''));
               Showmessage('O sistema n�o encontrou nenhuma forma de pagamento'+chr(10)+
                           Mais1Ini.ReadString('Impressora fiscal','Forma extra 5','')+'.'+chr(10)+
                           'Esta forma foi cadastrada, entre no menu F10-Formas de pagamento para definir sua ordem.');
             end;
           end;
         end;
         if sExtra6 <> '' then
         begin
           if _ecf07_VerificaDescricaoFormaPgto(sExtra6) = '' then
           begin
             //n�o encontrou, tenta cadastr�-la
             if _ecf07_VerificaFormaPgto(sExtra6) = 'XX' then
             begin
               // v� qual � a pr�xima dispon�vel
               _ecf07_CadastraFormaPgto(Mais1Ini.ReadString('Impressora fiscal','Forma extra 6',''));
               Showmessage('O sistema n�o encontrou nenhuma forma de pagamento'+chr(10)+
                           Mais1Ini.ReadString('Impressora fiscal','Forma extra 6','')+'.'+chr(10)+
                           'Esta forma foi cadastrada, entre no menu F10-Formas de pagamento para definir sua ordem.');
             end;
           end;
         end;
         if sExtra7 <> '' then
         begin
           if _ecf07_VerificaDescricaoFormaPgto(sExtra7) = '' then
           begin
             //n�o encontrou, tenta cadastr�-la
             if _ecf07_VerificaFormaPgto(sExtra7) = 'XX' then
             begin
               // v� qual � a pr�xima dispon�vel
               _ecf07_CadastraFormaPgto(Mais1Ini.ReadString('Impressora fiscal','Forma extra 7',''));
               Showmessage('O sistema n�o encontrou nenhuma forma de pagamento'+chr(10)+
                           Mais1Ini.ReadString('Impressora fiscal','Forma extra 7','')+'.'+chr(10)+
                           'Esta forma foi cadastrada, entre no menu F10-Formas de pagamento para definir sua ordem.');
             end;
           end;
         end;
         if sExtra8 <> '' then
         begin
           if _ecf07_VerificaDescricaoFormaPgto(sExtra8) = '' then
           begin
             //n�o encontrou, tenta cadastr�-la
             if _ecf07_VerificaFormaPgto(sExtra8) = 'XX' then
             begin
               // v� qual � a pr�xima dispon�vel
               _ecf07_CadastraFormaPgto(Mais1Ini.ReadString('Impressora fiscal','Forma extra 8',''));
               Showmessage('O sistema n�o encontrou nenhuma forma de pagamento'+chr(10)+
                           Mais1Ini.ReadString('Impressora fiscal','Forma extra 8','')+'.'+chr(10)+
                           'Esta forma foi cadastrada, entre no menu F10-Formas de pagamento para definir sua ordem.');
             end;
           end;
         end;
        Mais1ini.Free; // Sandro Silva 2018-11-21 Mem�ria 
      end;
    end;
end;

Function _ecf07_IniPortaStr(pP1: Integer):Integer; //Urano Logger
var
   cCom:array [1..255] of char;
begin
  StrPCopy(@cCom,'COM'+Alltrim(intToStr(pP1)));
  Result:=InicializaDLL(@cCom);
  if (Result=0) then
   begin
      //le o estado da porta
      Result:=EstadoImpressora();
//showmessage(inttostr(result));
      if (Result=50) or ((Result >= 118) and (Result <=127)) then
         Result:=0
      else
        begin
          Result:=1;
          FinalizaDll();
        end;
   end
  else
   begin
      Result:=1;
   end;
//showmessage(inttostr(result));

end;


// ------------------------------ //
// Leitura de relatorio X         //
//                                //
// ------------------------------ //
Function _ecf07_LeituraRelX(pP1: integer):String;
{var
  vRetorno : array [1..75] of String[22];  // Cria uma matriz com  100 elementos
  I,J      : Integer;}
begin
{  //
  Result:=FSerial(Form1.sPorta,Form1.iSequencial,'2F','','');
  if Copy(Result,1,2)='00' then
  begin
    Delete(Result,1,2); // apaga o 00
    J:=1;
    I:=1;
    while J <= length(Result) do
    begin
      if Result[J] = '\' then
       begin
         I:=I+1;
         vRetorno[I]:='';
       end
      else
       begin
         vRetorno[I]:=vRetorno[I]+Result[J];
       end;
       J:=J+1;
    end;
    Result:=vRetorno[pP1];
  end
  else
   begin
     Result:='XX';
   end;}
end;


// ------------------------------ //
// Fecha o cupom que est� sendo   //
// emitido                        //
// ------------------------------ //
Function _ecf07_FechaCupom(Pp1: Boolean):Boolean; //URANO
var
  s1: array[1..255] of char;
  retorno:integer;
begin
   Result:=True;
   if Form1.fTotal = 0 then // cupom em branco cancela
    begin
      //Retorno:=EstadoImpressora();
      //showmessage('Estado da impressora '+inttostr(Retorno));
      Retorno:=CancelaVenda(PChar(Form1.sCaixa));
      if Retorno=53 then
      begin
         showmessage('N�o houve lan�amento de nenhum item, '+chr(10)+
                     'esta venda n�o pode ser cancelada.');
         Result:=false;
      end;
    end
   else
    begin
      Retorno:=EstadoImpressora;
      if (Retorno<>119) and (Retorno<>120) then
         Result:=False
      else
         Result:=true;

      if result then
      begin
        // verifica se tem desconto/acr�scimo
        if JStrToFloat(Format('%13.2f',[Form1.fTotal])) > JStrToFloat(Format('%13.2f',[Form1.ibDataSet25RECEBER.AsFloat])) then //Desconto
         begin
           StrPCopy(@s1,Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.fTotal-Form1.ibDataSet25RECEBER.AsFloat)*100])),13),1,10));
           DescontoSubTotal('0','  ',@s1);
           //_ecf07_CodeErro(Retorno);
         end
        else
         begin
           if JStrToFloat(Format('%13.2f',[Form1.fTotal])) < JStrToFloat(Format('%13.2f',[Form1.ibDataSet25RECEBER.AsFloat])) then //Acrescimo
            begin
              StrPCopy(@s1,Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.ibDataSet25RECEBER.AsFloat-Form1.fTotal)*100])),13),1,10));
              AcrescimoSubTotal('0','  ',@s1);
              ///_ecf07_CodeErro(Retorno);
            end
           else
            begin //n�o � desconto nem acr�scimo, d� desconto valor 0
              StrPCopy(@s1,'0000000000');
              DescontoSubTotal('0','  ',@s1);
              //_ecf07_CodeErro(Retorno);
            end;
         end;
      end;
    end;
end;


function _ecf07_Pagamento(Pp1: Boolean):Boolean;
var
  s1,s2,s3: array[1..255] of char;
  sX,  sDinheiro,  sCheque,  sCartao,  sPrazo,  sExtra1,  sExtra2,  sExtra3, sExtra4,
  sExtra5,  sExtra6,  sExtra7,  sExtra8 :string;
  Mais1Ini:tinifile;
  fSubTotal:double;
  sPropaganda : String;
begin
  Result:=True;
  //l� as formas de pgto no ini
  Mais1ini  := TIniFile.Create('frente.ini');
  //
  sPrazo    := Mais1Ini.ReadString('Impressora Fiscal','Prazo','02');
  sDinheiro := Mais1Ini.ReadString('Impressora Fiscal','Dinheiro','03');
  sCheque   := Mais1Ini.ReadString('Impressora Fiscal','Cheque','04');
  sCartao   := Mais1Ini.ReadString('Impressora Fiscal','Cartao','05');
  sExtra1   := Mais1Ini.ReadString('Impressora Fiscal','Ordem forma extra 1','');
  sExtra2   := Mais1Ini.ReadString('Impressora Fiscal','Ordem forma extra 2','');
  sExtra3   := Mais1Ini.ReadString('Impressora Fiscal','Ordem forma extra 3','');
  sExtra4   := Mais1Ini.ReadString('Impressora Fiscal','Ordem forma extra 4','');
  sExtra5   := Mais1Ini.ReadString('Impressora Fiscal','Ordem forma extra 5','');
  sExtra6   := Mais1Ini.ReadString('Impressora Fiscal','Ordem forma extra 6','');
  sExtra7   := Mais1Ini.ReadString('Impressora Fiscal','Ordem forma extra 7','');
  sExtra8   := Mais1Ini.ReadString('Impressora Fiscal','Ordem forma extra 8','');
  Mais1Ini.Free; // Sandro Silva 2018-11-21 Mem�ria 
  //--------------------- //
  // Forma de pagamento   //
  //--------------------- //
  fSubTotal:=_ecf07_SubTotal(True);//sem checagem
  if fSubTotal > 0 then
   begin
    if Form1.ibDataSet25DIFERENCA_.AsFloat = 0 then// � vista
     begin
       if Form1.ibDataSet25ACUMULADO2.AsFloat > 0 then // dinheiro > 0
       begin

  ///        ShowMessage('Fechando em dinheiro, ordem: '+sDinheiro);

          sX:=sDinheiro;//sSMALL_VerificaFormaPgto('DINHEIRO');
          StrCopy(@s1,Pchar(sX));
          sX:=Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.ibDataSet25ACUMULADO2.AsFloat)*100])),13),1,10);
          StrCopy(@s2,'............');
          StrCopy(@s3,PChar(sX));
          Pagamento(@s1,@s2,@s3,'0');
          //SMALL_CodeErro(Retorno);
       end;
       if Form1.ibDataSet25ACUMULADO1.AsFloat > 0 then // cheque > 0
       begin
          sX:=sCheque;//SMALL_VerificaFormaPgto('CHEQUE');
          StrCopy(@s1,Pchar(sX));
          sX:=Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.ibDataSet25ACUMULADO1.AsFloat)*100])),13),1,10);
          StrCopy(@s2,'............');
          StrCopy(@s3,PChar(sX));
          Pagamento(@s1,@s2,@s3,'1');
          //SMALL_CodeErro(Retorno);
       end;
       if Form1.ibDataSet25PAGAR.AsFloat <> 0 then // Cart�o
       begin
          sX:=sCartao;//SMALL_VerificaFormaPgto('CARTAO');
          StrCopy(@s1,Pchar(sX));
          sX:=Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.ibDataSet25PAGAR.AsFloat)*100])),13),1,10);
          StrCopy(@s2,'............');
          StrCopy(@s3,PChar(sX));
          Pagamento(@s1,@s2,@s3,'1');
          //SMALL_CodeErro(Retorno);
       end;
       //
       //   modalidades extras
       //
       if Form1.ibDataSet25VALOR01.AsFloat <> 0 then //Modalidade extra 1
       begin
         // se o valor em dinheiro j� supriu o total da venda
         if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
           showmessage('A modalidade '+Form2.Label18.Caption+' ser� desconsiderada.')
         else
          begin
            sX:=sExtra1;
            StrCopy(@s1,Pchar(sX));
            sX:=Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.ibDataSet25VALOR01.AsFloat)*100])),13),1,10);
            StrCopy(@s2,'............');
            StrCopy(@s3,PChar(sX));
            Pagamento(@s1,@s2,@s3,'0');
            //SMALL_CodeErro(Retorno);
          end;
       end;
       //
       if Form1.ibDataSet25VALOR02.AsFloat <> 0 then //Modalidade extra 2
       begin
         // se o valor em dinheiro j� supriu o total da venda
         if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
           showmessage('A modalidade '+Form2.Label18.Caption+' ser� desconsiderada.')
         else
          begin
            sX:=sExtra2;
            StrCopy(@s1,Pchar(sX));
            sX:=Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.ibDataSet25VALOR02.AsFloat)*100])),13),1,10);
            StrCopy(@s2,'............');
            StrCopy(@s3,PChar(sX));
            Pagamento(@s1,@s2,@s3,'0');
            //SMALL_CodeErro(Retorno);
          end;
       end;
       //
       if Form1.ibDataSet25VALOR03.AsFloat <> 0 then //Modalidade extra 3
       begin
         // se o valor em dinheiro j� supriu o total da venda
         if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
           showmessage('A modalidade '+Form2.Label18.Caption+' ser� desconsiderada.')
         else
          begin
            sX:=sExtra3;
            StrCopy(@s1,Pchar(sX));
            sX:=Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.ibDataSet25VALOR03.AsFloat)*100])),13),1,10);
            StrCopy(@s2,'............');
            StrCopy(@s3,PChar(sX));
            Pagamento(@s1,@s2,@s3,'0');
            //SMALL_CodeErro(Retorno);
          end;
       end;
       //
       if Form1.ibDataSet25VALOR04.AsFloat <> 0 then //Modalidade extra 4
       begin
         // se o valor em dinheiro j� supriu o total da venda
         if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
           showmessage('A modalidade '+Form2.Label18.Caption+' ser� desconsiderada.')
         else
          begin
            sX:=sExtra4;
            StrCopy(@s1,Pchar(sX));
            sX:=Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.ibDataSet25VALOR04.AsFloat)*100])),13),1,10);
            StrCopy(@s2,'............');
            StrCopy(@s3,PChar(sX));
            Pagamento(@s1,@s2,@s3,'0');
            //SMALL_CodeErro(Retorno);
          end;
       end;
       //
       if Form1.ibDataSet25VALOR05.AsFloat <> 0 then //Modalidade extra 5
       begin
         // se o valor em dinheiro j� supriu o total da venda
         if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
           showmessage('A modalidade '+Form2.Label18.Caption+' ser� desconsiderada.')
         else
          begin
            sX:=sExtra5;
            StrCopy(@s1,Pchar(sX));
            sX:=Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.ibDataSet25VALOR05.AsFloat)*100])),13),1,10);
            StrCopy(@s2,'............');
            StrCopy(@s3,PChar(sX));
            Pagamento(@s1,@s2,@s3,'0');
            //SMALL_CodeErro(Retorno);
          end;
       end;
       //
       if Form1.ibDataSet25VALOR06.AsFloat <> 0 then //Modalidade extra 6
       begin
         // se o valor em dinheiro j� supriu o total da venda
         if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
           showmessage('A modalidade '+Form2.Label18.Caption+' ser� desconsiderada.')
         else
          begin
            sX:=sExtra6;
            StrCopy(@s1,Pchar(sX));
            sX:=Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.ibDataSet25VALOR06.AsFloat)*100])),13),1,10);
            StrCopy(@s2,'............');
            StrCopy(@s3,PChar(sX));
            Pagamento(@s1,@s2,@s3,'0');
            //SMALL_CodeErro(Retorno);
          end;
       end;
       //
       if Form1.ibDataSet25VALOR07.AsFloat <> 0 then //Modalidade extra 7
       begin
         // se o valor em dinheiro j� supriu o total da venda
         if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
           showmessage('A modalidade '+Form2.Label18.Caption+' ser� desconsiderada.')
         else
          begin
            sX:=sExtra7;
            StrCopy(@s1,Pchar(sX));
            sX:=Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.ibDataSet25VALOR07.AsFloat)*100])),13),1,10);
            StrCopy(@s2,'............');
            StrCopy(@s3,PChar(sX));
            Pagamento(@s1,@s2,@s3,'0');
            //SMALL_CodeErro(Retorno);
          end;
       end;
       //
       if Form1.ibDataSet25VALOR08.AsFloat <> 0 then //Modalidade extra 8
       begin
         // se o valor em dinheiro j� supriu o total da venda
         if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
           showmessage('A modalidade '+Form2.Label18.Caption+' ser� desconsiderada.')
         else
          begin
            sX:=sExtra8;
            StrCopy(@s1,Pchar(sX));
            sX:=Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.ibDataSet25VALOR08.AsFloat)*100])),13),1,10);
            StrCopy(@s2,'............');
            StrCopy(@s3,PChar(sX));
            Pagamento(@s1,@s2,@s3,'0');
            //SMALL_CodeErro(Retorno);
          end;
       end;
     end
    else
     begin  // prazo
       sX:=_ecf07_VerificaFormaPgto('PRAZO');
       StrCopy(@s1,Pchar(sX));
       sX:=Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.ibDataSet25DIFERENCA_.Asfloat)*100])),13),1,10);
       StrCopy(@s2,'............');
       StrCopy(@s3,PChar(sX));
       Pagamento(@s1,@s2,@s3,'1');
     end;
     //
     // imprime propaganda
     //
     sPropaganda := '';
     //
     // transforma chr(10) em linhas de 48 colunas
     //
{
     Form1.sMensagemPromocional := Form1.sMensagemPromocional + Chr(10);
     //
     for I := 1 to Length(Form1.sMensagemPromocional) do
     begin
       if Copy(Form1.sMensagemPromocional,I,1) = Chr(10) then
       begin
         sPropaganda := sPropaganda + StrTran(Copy(ConverteAcentos(Copy(Form1.sMensagemPromocional,J,I-J))+Replicate(' ',48),1,48),Chr(10),' ');
         J := I;
       end;
     end;
     sPropaganda := StrTran(sPropaganda,Replicate(' ',48),'');
     Propaganda('0',Pchar(sPropaganda));
}
     //
     Propaganda('0',Pchar(StrTran(StrTran(StrTran(StrTran(Form1.sMensagemPromocional,Chr(10),''),'  ',''),'  ',''),'  ','')));
     //
     FechaCupom('');
     AvancaLinhas('7');
     //
     // Finaliza o cupom
     //
   end
  else
  //
  Result:=True;// sempre deve voltar TRUE
  //
end;


Function _ecf07_CancelaUltimoItem(Pp1: Boolean):Boolean; //Urano
var
  sX: string;
begin
   Result:=False;
   sX:=_ecf07_LeReg(33);
   if Copy(sX,1,4) <> 'ERRO' then
      Result:=_ecf07_CancelaItemN(right(AllTrim(sX),3),' ');
end;

// ------------------------------ //
// Cancela o �ltimo cupom emitido //
// ------------------------------ //
Function _ecf07_CancelaUltimoCupom(Pp1: Boolean):Boolean; //Urano
var
  Retorno:integer;
begin
  if pP1 then
   begin
     Result:=True;
     Retorno:=CancelaCupom('0','        ');
     if (Retorno <> 0) and (Retorno <> 33) and (Retorno <> 10) then Result:=False;
     if not Result then  Showmessage('N�o foi poss�vel cancelar o cupom');
     AvancaLinhas('7');
   end
  else
   begin
     Result:=False;
   end;
end;

Function _ecf07_SubTotal(Pp1: Boolean):Real; // Urano OK
var
  s1,s2: array[1..255] of char;
begin
//    Result:=JStrToFloat(_ecf07_LeReg(00))
  StrPCopy (@s2,StrZero(00,2,0));
  StrCopy (@s1,'valor inicial');
  if LeRegistrador(@s2,@s1) = 33 then
     Result :=JStrToFloat(AllTrim(StrPas(@s1)))
  else
     Result:=0;
end;

// ------------------------------ //
// Abre um novo cupom fiscal      //
// ------------------------------ //
Function _ecf07_AbreNovoCupom(Pp1: Boolean):Boolean; //Urano
var
  Retorno:integer;
  s1: array[1..255] of char;
begin
  Result:=False;
  Retorno:=EstadoImpressora();
  if (Retorno=127) then //esta em cupom fiscal vinculado
     if _ecf07_FechaCupom2(True) then
        Retorno:=EstadoImpressora();

  if (Retorno=126) then //esta em rel.Gerencial
  begin
    StrCopy(@s1,'        ');
    FinalizaRelatorio(@s1);
    Retorno:=EstadoImpressora();
  end;

  //
  if (Retorno>=119) and (Retorno<=121) then  //cupom j� aberto em venda de �tem /pagamento ou em comercial
     Result:=true
  else
   begin
    if (Retorno=50) then // falta leitura z
    begin
      _ecf07_ReducaoZ(true);
      //Form1.EmitirReducaoZ(Form1);// 2015-10-07 Deve emitir mesas aberta, fechar as aberta a mais de 1 dias antes ou logo ap�s da redu��o Z
       Retorno:=EstadoImpressora();
    end;
    //
    if Retorno=118 then//em periodo de venda
    begin
       // tenta abrir o cupom imprimindo o cabe�alho
      ImprimeCabecalho();
      Result:=True;
    end;
    if(Retorno=124) then Showmessage('Este dia j� foi encerrado, lan�amentos novos'+chr(10)+
                                     'somente ap�s as 24 horas');
   end;
end;

// -------------------------------- //
// Retorna o n�mero do Cupom        //
// -------------------------------- //
Function _ecf07_NumeroDoCupom(Pp1: Boolean):String; // Urano
begin
  Result:=_ecf07_LeReg(18);//contador de ordem de opera��o Final
  Result:=Right(Result,6);
end;

// ------------------------------ //
// Cancela um item N              //
// ------------------------------ //
Function _ecf07_CancelaItemN(pP1,pP2: String):Boolean; //Urano OK
var
  s1,s2: array[1..255] of char;
  Retorno:integer;
  sX:String;
begin
//  sX:=StrZero((StrToInt(pP1)+Form1.iCancelaItenN),3,0);
  sX:=StrZero(StrToInt(pP1),3,0);
  StrPCopy(@s1,' ');
  StrPCopy(@s2,Copy(sX,2,3));
//  showmessage('cancelando pp1:'+pp1+'/pp2: '+pp2);
  Retorno:=CancelaItem(@s1,@s2);
  if Retorno=33 then
   begin
//   Form1.iCancelaItenN:=Form1.iCancelaItenN+1;
     Result := True;
   end
  else
    begin
     _ecf07_CodeErro(Retorno);
     Result := False;
    end;
end;

// -------------------------------- //
// Abre a gaveta                    //
// -------------------------------- //
Function _ecf07_AbreGaveta(Pp1: Boolean):Boolean; // Urano
var
  Retorno:integer;
begin
   Retorno := AbreGaveta();
   if Retorno = 0 then
     Result:= True
   else
     Result:= False;
end;

// -------------------------------- //
// Status da gaveta                 //
// -------------------------------- //
Function _ecf07_StatusGaveta(Pp1: Boolean):String; //Urano
var
  Retorno:integer;
begin
  //
  Result:= '128';
  Retorno:=LeSensor('3'); // sensor da gaveta
  //
  if Form1.iStatusGaveta = 0 then
  begin
    if Retorno = 48 then Result:='000' else Result:='255';
  end else
  begin
    if Retorno = 48 then Result:='255' else Result:='000';
  end;
end;

// -------------------------------- //
// Sangria                          //
// -------------------------------- //
Function _ecf07_Sangria(Pp1: Real):Boolean; // Urano 1EFC
var
  sX:String;
  s1,s2,s3:array [1..255] of char;
  Retorno:integer;
begin
   Result:=True;
   //checa os registradores para verificar qual � a sangria
   sX:=_ecf07_VerificaDocNaoVinc('SANGRIA');
   if sX = 'XX' then // n�o achou
   begin
      if not _ecf07_CadastraDocNaoVinc('SANGRIA') then // n�o cadastrou
       begin
         Result:=False;
       end
      else
       begin
         sX:=_ecf07_VerificaDocNaoVinc('SANGRIA');
         if sX = 'XX' then //Cadastrou mas n�o achou
         begin
           showmessage('� necess�rio sair do programa, desligar a impressora e ligar novamente');
           Result:=False;
         end;
       end;
   end;
   if Result then
   begin
      StrCopy(@s1,Pchar(sX));//c�digo
      StrCopy(@s2,'  ');     //descri��o
      sX:=Copy(Right('000000000'+AllTrim(Format('%9f',[pP1*100])),12),1,9);
      StrCopy(@s3,Pchar(sX));  //Valor
      Retorno:=EmiteNaoVinculado(@s1,@s2,@s3);
      _ecf07_CodeErro(Retorno);

      sX:=_ecf07_VerificaFormaPgto('DINHEIRO');
      StrCopy(@s1,Pchar(sX));
      sX:=Copy(Right('0000000000'+AllTrim(Format('%13f',[pP1*100])),13),1,10);
      StrCopy(@s2,'............');
      StrCopy(@s3,PChar(sX));
      Pagamento(@s1,@s2,@s3,'0');
      _ecf07_CodeErro(Retorno);

      StrCopy(@s1,'  ');     //operador
      Retorno:=FechaCupom(@s1);
      Result:= (Retorno=0) or (Retorno=33);
      AvancaLinhas('7');
   end;
   {  if Copy(FSerial(Form1.sPorta,Form1.iSequencial,'29','0201'+Copy(Right('000000000000'+AllTrim(Format('%13f',[(pP1*100)])),15),1,12)+'0',''),1,2) ='00' then Result:=True else Result:=False;}
end;

// -------------------------------- //
// Suprimento                       //
// -------------------------------- //
Function _ecf07_Suprimento(Pp1: Real):Boolean;
var
  sX:String;
  s1,s2,s3:array [1..255] of char;
  Retorno:integer;
begin
   Result:=True;
   //checa os registradores para verificar qual � a sangria
   sX:=_ecf07_VerificaDocNaoVinc('SUPRIMENTO');
   if sX = 'XX' then // n�o achou
   begin
      if not _ecf07_CadastraDocNaoVinc('SUPRIMENTO') then // n�o cadastrou
       begin
         showmessage('n�o Cadastrou');
         Result:=False;
       end
      else
       begin
         sX:=_ecf07_VerificaDocNaoVinc('SUPRIMENTO');
         if sX = 'XX' then //Cadastrou mas n�o achou
         begin
           showmessage('� necess�rio sair do programa, desligar a impressora e ligar novamente');
           Result:=False;
         end;
       end;
   end;
   if Result then
   begin
      StrCopy(@s1,Pchar(sX));//c�digo
      StrCopy(@s2,'  ');     //descri��o
      sX:=Copy(Right('000000000'+AllTrim(Format('%9f',[pP1*100])),12),1,9);
      StrCopy(@s3,Pchar(sX));  //Valor
      Retorno:=EmiteNaoVinculado(@s1,@s2,@s3);
      _ecf07_CodeErro(Retorno);

      sX:=_ecf07_VerificaFormaPgto('DINHEIRO');
      StrCopy(@s1,Pchar(sX));
      sX:=Copy(Right('0000000000'+AllTrim(Format('%13f',[pP1*100])),13),1,10);
      StrCopy(@s2,'............');
      StrCopy(@s3,PChar(sX));
      Pagamento(@s1,@s2,@s3,'0');
      _ecf07_CodeErro(Retorno);

      StrCopy(@s1,'  ');     //operador
      Retorno:=FechaCupom(@s1);
      Result:= (Retorno=0) or (Retorno=33);
      AvancaLinhas('7');
   end;
end;
// -------------------------------- //
// Nova Aliquota                    //
// -------------------------------- //
Function _ecf07_NovaAliquota(Pp1: String):Boolean;
var
   Retorno:integer;
   sX:String;
   s1,s2:array [1..255] of char;
begin
   sX:=_ecf07_LeReg(29); // l� qual � a pr�xima al�quota dispon�vel
   StrCopy(@s1,pchar(sX));
   StrCopy(@s2,pchar(pP1));
   Retorno:=CargaAliquota(@s1,@s2);
   Result:=(retorno=0) or (Retorno=33);
{  showmessage('S� � possivel Cadastrar nova al�quota em modo de interven��o');
  Result := False;}
end;

function _ecf07_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
begin
  ShowMessage('Fun��o n�o suportada pelo modelo de ECF utilizado.');
  Result := True;
end;

Function _ecf07_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;   //Urano
var
  s1,s2,s3,s4:array [1..255] of char;
  Retorno:integer;
begin
  if Form7.Label3.Caption = 'Data inicial:' then
   begin
     StrCopy(@s1,'0');
     pP1:=strzero(strtoint(pP1),6,0);
     pP2:=strzero(strtoint(pP2),6,0);
   end
  else
   begin
     StrCopy(@s1,'1');
     pP1:=strzero(strtoint(pP1),4,0);
     pP2:=strzero(strtoint(pP2),4,0);
   end;

  StrCopy(@s2,Pchar(pP1));
  StrCopy(@s3,Pchar(pP2));
  StrCopy(@s4,' '); //ignorado
  Retorno:=LeituraMF(@s1,@s2,@s3,@s4);
  Result:=(Retorno=0)  or (Retorno=33);
end;


// -------------------------------- //
// Venda do Item                    //
// -------------------------------- //
Function _ecf07_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean; // Urano OK
{       StrZero(StrToInt(ibDataSet4CODIGO.AsString),13,0), // C�digo
                               copy(sDescricao,1,29), // Descric�o
                               ST                   , // ST
         StrZero(ibDataSet27QUANTIDADE.AsFloat*1000,7,0), // Quantidade
            StrZero(ibDataSet27UNITARIO.AsFloat*100,7,0), // Unit�rio
                    Copy(ibDataSet4MEDIDA.AsString,1,2)); // Medida;
             StrZero(ibDataSet25VALOR_1.AsFloat*100,7,0), // Desconto %
             StrZero(ibDataSet25VALOR_2.AsFloat*100,7,0));// Desconto R$
                    }
var
  s1,s2,s3,s4,s5,s6,s7: array[1..255] of char;
  Retorno,casas:integer;
begin
   if pP3 = 'FF' then
      pP3:='07'
   else
      if pP3 = 'II' then
         pP3:='08'
      else
         if pP3 = 'NN' then
            pP3:='09'
         else
            pP3:=StrZero(StrToInt(pP3)-1,2,0);

   StrPCopy(@s1,pP1);//C�digo
   StrPCopy(@s2,pP2);//Descri��o
   if StrToInt(Copy(pP4,5,3)) > 0 then //quantidade fracion�ria
      StrPCopy(@s3,Copy(pP4,2,3)+'.'+Copy(pP4,5,3))
   else
      StrPCopy(@s3,'000'+Copy(pP4,1,4));//Quantidade inteira
//   if AllTrim(Form1.ConfPreco)='3' then
//      StrPCopy(@s4,IntToStr(StrToInt(pP5)))
//   else
   StrPCopy(@s4,'00'+pP5);//Valor Unit�rio
   StrPCopy(@s5,pP3);// ST taxa
   StrPCopy(@s6,pP6);// unidade
   casas:=100;
   if AllTrim(Form1.ConfPreco)='2' then
   begin
       StrCopy(@s7,'0');// tipo
       casas:=100;
   end;
   if AllTrim(Form1.ConfPreco)='3' then
   begin
     StrCopy(@s7,'2');// tipo
     casas:=1000;
   end;
   Retorno:=VendaItem(@s1,@s2,@s3,@s4,@s5,@s6,@s7);
   if Retorno=33 then
      Result := True
   else
    begin
     if Retorno=52 then // comando fora de sequ�ncia est� em subtotal
       Showmessage('Em subtotal, pressione F3 para encerrar o cupom') //aciona o F3
     else
       _ecf07_CodeErro(Retorno);
     Result := False;
    end;
   //desconto
   if Result then
   begin
    if pP7 <> '0000000' then //desconto em percentual
     begin
       StrPCopy(@s1,'0');//desconto
       StrPCopy(@s2,'Desconto sobre item');//Descricao
       StrPCopy(@s3, StrZero(
               (
               (   (StrToFloat(pP7)/100) /100 )*   //multiplica pelo percentual j� dividido por 100
               ( (StrToFloat(pP4)/1000) * (StrToFloat(pP5)/casas) )  //quantidade * Valor unit
               *100) //multiplica p/100 para arredondar casas decimais
               ,11,0));
       Retorno:=DescontoItem(@s1,@s2,@s3);
       if Retorno=33 then
         Result := True
       else
        begin
         _ecf07_CodeErro(Retorno);
         Result := False;
       end;
     end
    else //desconto em valor
     if pP8 <> '0000000' then
     begin
       StrPCopy(@s1,'0');//desconto
       StrPCopy(@s2,'Desconto sobre item');//Descricao
       StrPCopy(@s3,'0000'+pP8 );
       Retorno:=DescontoItem(@s1,@s2,@s3);
       if Retorno=33 then
         Result := True
       else
        begin
         _ecf07_CodeErro(Retorno);
         Result := False;
       end;
     end;
   end;
end;

// -------------------------------- //
// Reducao Z                        //
// -------------------------------- //
Function _ecf07_ReducaoZ(pP1: Boolean):Boolean; // Urano
var
  Retorno:integer;
  s1:array [1..255] of char;
begin
  Result := True;
  Retorno:=Relatorio_XZ('1');
  if (Retorno <> 0) and (Retorno <> 33) then
  begin
    _ecf07_CodeErro(Retorno);
    Result := False;
  end;
  StrCopy(@s1,'        ');
  FinalizaRelatorio(@s1);
  StrCopy(@s1,'07');     //sete linhas
  AvancaLinhas(@s1);
end;
// -------------------------------- //
// Leitura X                        //
// -------------------------------- //
Function _ecf07_LeituraX(pP1: Boolean):Boolean; //Urano OK
var
  Retorno:integer;
  s1:array [1..255] of char;
begin
  Result := True;
  Retorno:=Relatorio_XZ('0');
  if (Retorno <> 0) and (Retorno <> 33)  then
  begin
    _ecf07_CodeErro(Retorno);
    Result := False;
  end;
  StrCopy(@s1,'        ');
  FinalizaRelatorio(@s1);
  AvancaLinhas('7');
end;

// ---------------------------------------------- //
// Retorna se o horario de ver�o est� selecionado //
// ---------------------------------------------- //
Function _ecf07_RetornaVerao(pP1: Boolean):Boolean;     //yanco ok
begin
   Result:=True;
end;

// -------------------------------- //
// Liga ou desliga hor�rio de verao //
// -------------------------------- //
Function _ecf07_LigaDesLigaVerao(pP1: Boolean):Boolean; // yanco OK
var
  bButton,Retorno:integer;

begin
    Retorno:=0;
    bButton := Application.MessageBox(Chr(10) +
                                      '    Para ativar o hor�rio de  ver�o' +chr(10)+
                                      ' clique SIM, para desativar  clique'+chr(10)+
                                      ' N�O, para nenhuma das alternativas'+chr(10)+
                                      ' clique em CANCELAR'+ Chr(10) + Chr(10)
                                      , 'Aten��o',
    mb_YesNoCancel + mb_DefButton1 + MB_ICONQUESTION);
    if bButton = IDYES then //ativa hor�rio de ver�o
       Retorno:=ProgramaRelogio('1','','');
    if bButton = IDNO then //ativa hor�rio de ver�o
       Retorno:=ProgramaRelogio('2','','');
    _ecf07_CodeErro(Retorno);
    Result:=(Retorno=0) or (Retorno=33);

{  Result := False;
  if Form1.Ligardesligarhorriodevero1.Checked then
   begin // tenda desligar
    if Copy(FSerial(Form1.sPorta,Form1.iSequencial,'08','0',''),1,2)='00' then
       Result:=True;
   end
  else
   begin  //tenta ligar
    if Copy(FSerial(Form1.sPorta,Form1.iSequencial,'08','1',''),1,2)='00' then
       Result := True;
   end;
  if not Result then showmessage('Para utilizar esta fun��o, o cupom deve estar finalizado'+chr(10)+
                                 'e as vendas brutas do dia igual a zero');}
end;

// -------------------------------- //
// Retorna a vers�o do firmware     //
// -------------------------------- //
Function _ecf07_VersodoFirmware(pP1: Boolean): String; //Urano OK
begin
   Result:='A vers�o do firmware � impressa no rodap� do '+ Chr(10)+
              'cupom fiscal';
end;

// -------------------------------- //
// Retorna o n�mero de s�rie        //
// -------------------------------- //
Function _ecf07_NmerodeSrie(pP1: Boolean): String;  //Urano OK
begin
   Result:=_ecf07_LeReg(25);
end;

// -------------------------------- //
// Retorna o CGC e IE               //
// -------------------------------- //
Function _ecf07_CGCIE(pP1: Boolean): String;// Urano OK
begin
   Result:=_ecf07_LeReg(30)+chr(10)+_ecf07_LeReg(31);
end;

// --------------------------------- //
// Retorna o valor  de cancelamentos //
// --------------------------------- //
Function _ecf07_Cancelamentos(pP1: Boolean): String; // Urano OK
begin
   Result:=_ecf07_LeReg(02);
   Result:=StrTran(Result,',','');
   Result:=StrTran(Result,'.','');
end;


// -------------------------------- //
// Retorna o valor de descontos     //
// -------------------------------- //
Function _ecf07_Descontos(pP1: Boolean): String; //Urano OK
begin
   Result:=Format('%12.2n',[JStrToFloat(_ecf07_LeReg(03))+JStrToFloat(_ecf07_LeReg(04))]);
   Result:=StrTran(Result,',','');
   Result:=StrTran(Result,'.','');
end;

// -------------------------------- //
// Retorna o contador sequencial    //
// -------------------------------- //
Function _ecf07_ContadorSeqencial(pP1: Boolean): String; //Urano OK
begin
   Result:=_ecf07_LeReg(18);
end;

// -------------------------------- //
// Retorna o n�mero de opera��es    //
// n�o fiscais acumuladas           //
// -------------------------------- //
Function _ecf07_Nmdeoperaesnofiscais(pP1: Boolean): String; //Urano
begin
   Result:=_ecf07_LeReg(20);
end;

Function _ecf07_NmdeCuponscancelados(pP1: Boolean): String;//Urano
begin
   Result:=_ecf07_LeReg(21);
end;

Function _ecf07_NmdeRedues(pP1: Boolean): String; //Urano
begin
   Result:=_ecf07_LeReg(24);
   Result:=StrZero(StrToInt(Result)+1,6,0);
end;

Function _ecf07_Nmdeintervenestcnicas(pP1: Boolean): String; //Urano
begin
   Result:=_ecf07_LeReg(23);
end;

Function _ecf07_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
begin
{  Result := 'Opera��o n�o suportada';}
end;

Function _ecf07_Clichdoproprietrio(pP1: Boolean): String;
begin
{  Result := 'Opera��o n�o suportada';}
end;

Function _ecf07_NmdoCaixa(pP1: Boolean): String;//Urano
begin
   Result:=Right(_ecf07_LeReg(26),3);
end;

Function _ecf07_Nmdaloja(pP1: Boolean): String; //
begin
{  Result:=FSerial(Form1.sPorta,Form1.iSequencial,'34','075','');
  if Copy(Result,1,2) = '00' then Result:=Copy(Result,3,length(Result)-2) else
     CodeErro(StrToInt(Copy(Result,1,2)));}
end;

Function _ecf07_Moeda(pP1: Boolean): String; // Urano esta fun��o n�o existe
begin
  Result:='R';
end;

Function _ecf07_Dataehoradaimpressora(pP1: Boolean): String; // Urano OK
var
  Temp:String;
begin
  Result:=_ecf07_LeReg(27);//data
  Result:=Copy(Result,1,2)+Copy(Result,4,2)+Copy(Result,7,2);
  Temp:=_ecf07_LeReg(28);//Hora
  Temp:=StrTran(Temp,':','');
  Result:=Result+Temp;
end;

Function _ecf07_Datadaultimareduo(pP1: Boolean): String;
begin
{  Result := 'Opera��o n�o suportada';}
end;

Function _ecf07_Datadomovimento(pP1: Boolean): String;
begin
{  Result := 'Opera��o n�o suportada';}
end;

Function _ecf07_Tipodaimpressora(pP1: Boolean): String; // Urano OK
begin
   Result:='URANO 1EFC firmware 3.0'+chr(10)+
           'URANO 1EF firmware 3.0'+chr(10)+
           'Usa a DLL DLL1EFC3.DLL'+chr(10)+_ecf07_LeReg(41);
end;

Function _ecf07_RetornaAliquotas(pP1: Boolean): String; //Urano
var
  i:integer;
  Temp:String;
begin
  Result:='';
  for i:= 34 to 40 do
  begin
     Temp:=_ecf07_LeReg(i);
     if Copy(Temp,1,4) <> 'ERRO'  then Result:=Result+Right(Temp,5);
  end;
  for i:= 94 to 95 do
  begin
     Temp:=_ecf07_LeReg(i);
     if Copy(Temp,1,4) <> 'ERRO'  then Result:=Result+Right(Temp,5);
  end;
  Result:=StrTran(Result,',','');
  Result:='16'+Copy(Result+Replicate('0',64),1,64);
end;


Function _ecf07_Vincula(pP1: String): Boolean;
begin
{  if CodeErro(FormataTX(Chr(27)+'|38|'+pP1+'|'+Chr(27))) = 0
  then Result := True else Result := False;}
  Result:=false;
end;


Function _ecf07_FlagsDeISS(pP1: Boolean): String;
  // ------------------------------------------ //
  // Flags de Vincula��o ao ISS                 //
  // (Cada �bit� corresponde a                  //
  // um totalizador.                            //
  // Um �bit� setado indica vincula��o ao ISS)  //
  // ------------------------------------------ //
//var
//  i:integer;
begin
   Result:='10';
   Result:=Right('0000000000000001'+Replicate('0',StrToInt(Result)-1),16);
   Result:=chr(BinToInt(Copy(Result,9,8)))+chr(BinToInt(Copy(Result,1,8)));
{  Result:=FSerial(Form1.sPorta,Form1.iSequencial,'2E','','');//Leitura dos parametros
  if Copy(Result,1,2) <> '00' then
   begin
     CodeErro(StrToInt(Copy(Result,1,2)));
   end
  else
   begin
    Result:=Copy(Result,3,80);//Leitura dos parametros
    for i:=0 to 16 do
    begin
     if UpperCase(Copy(Result,((i*5)+1),1))= 'I' then
     begin
       Result:= StrZero(I+1,2,0);
     end;
    end;
   end;
  if length(Result) <> 2 then
   begin
     Showmessage('Erro ! Aliquota de ISS n�o cadastrada. Chame um t�cnico');
     Result:='';
   end
  else
   begin
     Result:=Right('0000000000000001'+Replicate('0',StrToInt(Result)-1),16);
     Result:=chr(BinToInt(Copy(Result,9,8)))+chr(BinToInt(Copy(Result,1,8)));
   end;}
end;

Function _ecf07_FechaPortaDeComunicacao(pP1: Boolean): Boolean; //Urano
begin
   FinalizaDll();
   Result := True;
end;

Function _ecf07_MudaMoeda(pP1: String): Boolean; //Urano
var
  s1: array[1..255] of char;
  Retorno:integer;
begin
  StrCopy (@s1,'R$  ');
  Retorno := SimboloMoeda(@s1);
  if (Retorno=0) or (Retorno=33) then Result:=True else  Result := False;
end;


Function _ecf07_MostraDisplay(pP1:String):Boolean;
 // Par�metros:   texto
begin
   Result:=True;
end;

function _ecf07_leituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;// Urano 1EFC
//                                    Form7.SaveDialog1.FileName,MaskEdit1.Text, MaskEdit2.Text
var
  s1,s2,s3,s4:array [1..255] of char;
  Retorno:integer;
begin
  Form7.Label3.Visible:=True;
  Form7.Label3.Caption:='Aguarde recebendo dados do ECF';
  Form7.Label5.Visible:=True;
  Screen.Cursor := crHourGlass; // Cursor de Aguardo
  if length(pP2)=4 then //por redu��o
   begin
     StrCopy(@s1,'3'); //por redu��o via serial
     pP2:=strzero(strtoint(pP2),4,0);
     pP3:=strzero(strtoint(pP3),4,0);
     StrCopy(@s2,Pchar(pP2));//'0000');
     StrCopy(@s3,Pchar(pP3));//'9999');
     StrCopy(@s4,Pchar(pP1)); //nome do arquivo
   end
  else
   begin //por data
     StrCopy(@s1,'2'); //por data via serial
     StrCopy(@s2,Pchar(pP2));//'010103');
     StrCopy(@s3,Pchar(pP3));//'311204');
     StrCopy(@s4,Pchar(pP1)); //nome do arquivo
   end;
  Retorno:=LeituraMF(@s1,@s2,@s3,@s4);
//  function LeituraMF(Tipo:PChar;Inicio:PChar;Fim:PChar;Arquivo:PChar):integer; stdcall;
  Form7.Label3.Visible:=False;
  Form7.Label5.Visible:=False;
  Screen.Cursor := crDefault; // Cursor normal
  Result:=(Retorno=0) or  (Retorno=33);
end;

function _ecf07_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean; //iP2 = N�mero do Cupom vinculado
var
  s1,s2:array [1..255] of char;
  Retorno, LinhasEmBranco, I, J:integer;
  sX, sSeq, sCupom:String;
begin
//  ShowMessage(sP1);
// Comando Para Abrir Comprovante N�o Fiscal Vinculado
//  Result:=False;
   begin
    sSeq:='01';// sX;//  '01';
    sCupom:=StrZero(iP2,6,0);//Form1.iCupom
    StrCopy(@s1,Pchar(sCupom)); //
    StrCopy(@s2,Pchar(sSeq)); //sequencia
    //Retorno:=EmiteVinculado(@s1,@s2);
    //if Retorno <> 33  then  Result:=False;
    EmiteVinculado(@s1,@s2);
    // verificar o status da impressora
    Retorno:=EstadoImpressora;
    if Retorno<>127 then
       Result:=False
    else
       Result:=true;

    if Result then
    begin
      for J := 1 to 1 do
      begin
        LinhasEmBranco:=0;
        sX:='';
        for I := 1 to Length(sP1) do
        begin
          if Result = True then
          begin
             if Copy(sP1,I,1) <> chr(10) then
              begin
                if LinhasEmBranco > 0 then
                begin
                   sX:=StrZero(LinhasEmBranco,2,0);
                   StrCopy(@s1,Pchar(sX));     //sete linhas
                   Retorno:=AvancaLinhas(@s1);
                   if Retorno <> 33 then Result:=false;
                   sX:='';
                   LinhasEmBranco:=0;
                end;
                sX:=sX+Copy(sP1,I,1);
              end
             else
              begin
                if AllTrim(sX) <> '' then
                  begin
                    StrCopy(@s1,Pchar(sX));
                    try
      //                 Retorno:=-1;
      //                 sleep(600);
                       Retorno:=LinhasLivres(@s1);
                       while Retorno=-1 do
                       begin
                          sleep(1000);
                          Retorno:=EstadoImpressora;
                          Application.ProcessMessages;
                       end;
                    except
                       Retorno:=0;
                    end;
                    if (Retorno <> 33) then Result:=False;
                    sX:='';
                  end
                else
                  LinhasEmBranco:=LinhasEmBranco+1;
              end;
          end;
        end;
        if LinhasEmBranco > 0 then
        begin
           sX:=StrZero(LinhasEmBranco,2,0);
           StrCopy(@s1,Pchar(sX));     //sete linhas
           Retorno:=AvancaLinhas(@s1);
           if Retorno <> 33 then Result:=false;
        end;

        //avan�a 7 linhas
        if J < 1  then
        begin
          //avan�a 7 linhas
          if Result = True then
          begin
            StrCopy(@s1,'07');     //sete linhas
            Retorno:=AvancaLinhas(@s1);
            if Retorno <> 33 then Result:=false;
          end;

          if Result = True then sleep(2500); // D� um tempo 2,5 segundos
        end;
      end;
    end;
    if Result = True then
    begin
      Retorno:=FechaCupom('');
      if Retorno <> 33 then  Result:=False;
    end;
    if Result = True then
    begin
      StrCopy(@s1,'07');     //sete linhas
      AvancaLinhas(@s1);
    end;
   end;
end;

function _ecf07_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
var
  s1:array [1..255] of char;
  Retorno, LinhasEmBranco, I : Integer;
  sX: String;
begin
  //
  //  ShowMessage(IntToStr(Length(sP1)));
//  ShowMessage(sP1);
  //
  if EstadoImpressora()=126 then //Relat�rio Gerencial
  begin
     StrCopy(@s1,'        ');
     FinalizaRelatorio(@s1);
  end;

  Result := True;
  Retorno:=Relatorio_XZ('2');//leitura X com relat�rio gerencial
  if (Retorno <> 0) and (Retorno <> 33)  then
  begin
    //_ecf07_CodeErro(Retorno);
    Result := False;
  end;

  if Result = True then
  begin
    StrCopy(@s1,'07');     //sete linhas
    Retorno:=AvancaLinhas(@s1);
    if Retorno <> 33 then Result:=false;
  end;

  LinhasEmBranco:=0;
  sX:='';
  for I := 1 to Length(sP1) do
  begin
    if Result = True then
    begin
       if Copy(sP1,I,1) <> chr(10) then
        begin
          if LinhasEmBranco > 0 then
          begin
             sX:=StrZero(LinhasEmBranco,2,0);
             StrCopy(@s1,Pchar(sX));     //sete linhas
             Retorno:=AvancaLinhas(@s1);
             if Retorno <> 33 then Result:=false;
             sX:='';
             LinhasEmBranco:=0;
          end;
          sX:=sX+Copy(sP1,I,1);
        end
       else
        begin
          if AllTrim(sX) <> '' then
            begin
              StrCopy(@s1,Pchar(sX));
              try
//                 Retorno:=-1;
                 sleep(600);
                 Retorno:=LinhasLivres(@s1);
                 while Retorno=-1 do
                 begin
                    sleep(1000);
                    Retorno:=EstadoImpressora;
                    Application.ProcessMessages;
                 end;
              except
                 Retorno:=0;
              end;
              if (Retorno <> 33) then Result:=False;
              sX:='';
            end
          else
            LinhasEmBranco:=LinhasEmBranco+1;
        end;
    end;
  end;
  if LinhasEmBranco > 0 then
  begin
     sX:=StrZero(LinhasEmBranco,2,0);
     StrCopy(@s1,Pchar(sX));     //sete linhas
     Retorno:=AvancaLinhas(@s1);
     if Retorno <> 33 then Result:=false;
  end;

  if Result = True then
  begin
    StrCopy(@s1,'07');     //sete linhas
    Retorno:=AvancaLinhas(@s1);
    if Retorno <> 33 then Result:=false;
  end;

  if Result = True then sleep(3000); // Da um tempo; // Da um tempo

  LinhasEmBranco:=0;
  sX:='';
  for I := 1 to Length(sP1) do
  begin
    if Result = True then
    begin
       if Copy(sP1,I,1) <> chr(10) then
        begin
          if LinhasEmBranco > 0 then
          begin
             sX:=StrZero(LinhasEmBranco,2,0);
             StrCopy(@s1,Pchar(sX));     //sete linhas
             Retorno:=AvancaLinhas(@s1);
             if Retorno <> 33 then Result:=false;
             sX:='';
             LinhasEmBranco:=0;
          end;
          sX:=sX+Copy(sP1,I,1);
        end
       else
        begin
          if AllTrim(sX) <> '' then
            begin
              StrCopy(@s1,Pchar(sX));
              try
//                 Retorno:=-1;
                 sleep(600);
                 Retorno:=LinhasLivres(@s1);
                 while Retorno=-1 do
                 begin
                    sleep(1000);
                    Retorno:=EstadoImpressora;
                    Application.ProcessMessages;
                 end;
              except
                 Retorno:=0;
              end;
              if (Retorno <> 33) then Result:=False;
              sX:='';
            end
          else
            LinhasEmBranco:=LinhasEmBranco+1;
        end;
    end;
  end;
  if LinhasEmBranco > 0 then
  begin
     sX:=StrZero(LinhasEmBranco,2,0);
     StrCopy(@s1,Pchar(sX));     //sete linhas
     Retorno:=AvancaLinhas(@s1);
     if Retorno <> 33 then Result:=false;
  end;

  StrCopy(@s1,'        ');
  FinalizaRelatorio(@s1);
  if Result = True then
  begin
    StrCopy(@s1,'07');     //sete linhas
    AvancaLinhas(@s1);
    // n�o precisa mais disso if Retorno <> 33 then Result:=false;
  end;
end;

function _ecf07_FechaCupom2(sP1: Boolean): Boolean;
var
   Retorno:integer;
   s1:array [1..255] of char;
begin
  // -------------------------- //
  Result := True;
  //Finaliza o cupom
  Retorno:=FechaCupom('');
  if Retorno <> 33 then  Result:=False;
  //
  if Result = True then
  begin
    StrCopy(@s1,'07');     //sete linhas
    AvancaLinhas(@s1);
    // n�o precisa mais disso if Retorno <> 33 then Result:=false;
  end;
end;

function _ecf07_ImprimeCheque(rP1: Real; sP2: String): Boolean;
begin
  Result:=False;
end;

function _ecf07_GrandeTotal(sP1: Boolean): String;
//var
// I : Integer;
begin
//  I := 0;
//  Result := StrTran(copy(EcfStatusCupom(I),49,19),',','');
  Result:=StrTran(_ecf07_LeReg(1),',','');
  Result:=StrTran(Result,'.','');
//  showmessage(Result);

end;

function _ecf07_TotalizadoresDasAliquotas(sP1: Boolean): String;
var
  I : Integer;
  pRetorno : String;
begin
  Result:='';
  //
  for I := 6 to 12 do
  begin
      pRetorno := _ecf07_LeReg(I);
      Result := Result + Right(Replicate('0',14)+AllTrim(StrTran(pRetorno,',','')),14);
//      showmessage(Result);
  end;
  Result:=Result+Replicate('0',126);//como s� tem 7 al�q. e deve ter 16 complementa com 9 X 14 zeros
  //

  pRetorno := _ecf07_LeReg(14);//isento
//  showmessage('isento'+chr(10)+Right(Replicate('0',14)+AllTrim(StrTran(pRetorno,',','')),14));
  Result := Result + Right(Replicate('0',14)+AllTrim(StrTran(pRetorno,',','')),14);
  pRetorno := _ecf07_LeReg(15);//n�o incid�ncia
//  showmessage('n�o incid�ncia'+chr(10)+Right(Replicate('0',14)+AllTrim(StrTran(pRetorno,',','')),14));
  Result := Result + Right(Replicate('0',14)+AllTrim(StrTran(pRetorno,',','')),14);
  pRetorno := _ecf07_LeReg(13);//substitui��o
//  showmessage('substitui��o'+chr(10)+Right(Replicate('0',14)+AllTrim(StrTran(pRetorno,',','')),14));
  Result := Result + Right(Replicate('0',14)+AllTrim(StrTran(pRetorno,',','')),14);

  Result := Copy(Result+Replicate('0',438),1,438);
//  showmessage('Result'+chr(10)+Result);
  //
end;

function _ecf07_CupomAberto(sP1: Boolean): boolean;
var
  Retorno:integer;
begin
   Retorno:=EstadoImpressora();
   if (Retorno=119) then
      Result:=True
   else
      Result:=False;
end;
function _ecf07_FaltaPagamento(sP1: Boolean): boolean;
var
  Retorno:integer;
begin
   Retorno:=EstadoImpressora();
   if (Retorno=120) or (Retorno=121) then
      Result:=True
   else
      Result:=False;
end;

end.







