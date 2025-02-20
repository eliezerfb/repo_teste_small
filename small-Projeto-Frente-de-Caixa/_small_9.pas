unit _Small_9;

interface

uses
  Windows, Messages, SmallFunc, Fiscal, SysUtils,Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Mask, Grids, DBGrids, DB, DBCtrls, SMALL_DBEdit, IniFiles, Unit2,
  Unit7, shellapi, unit22;

  // ------------------ //
  // GENERAL            //
  // ------------------ //

  function OpenFujitsu(  porta:Pointer ):integer; stdcall;
  Function TxFujitsu(  buffer: Pointer ):integer;  stdcall;
  Function RxFujitsu(  buffer: Pointer;  Status1 : Pointer;  Status2: Pointer; TimeOut:Integer ):Integer; stdcall;
  procedure CloseFujitsu; stdcall;
  procedure AnalisaByte( buffer:Pointer; ret:Pointer); stdcall;
  // --------------------------------------------------------------//
  // IF GENERAL GP2000 Versão 1.0                                  //
  // alterado em 06/07/2001 TEF                                    //
  // Alterado em 24/08/01 Motivo: Reg.tipo 60, conv.50/00          //
  // alterado em 21/09/01 Motivo: erro 93 no 1o suprimento do dia  //
  // alterado em 27/10/01 Motivo: Cupom aberto                     //
  // alterado em 24/01/02 Motivo: Leitura de MF usando GP2000 p/MG //
  // Alterado em 19/12/02 Cupom vinculado p/op.prazo               //
  // Alterado em 18/02/03 Número de vias no cupom vinculado        //
  // Alterado em 12/01/04 versão 2004                              //
  // Alterado em 09/02/04 mensagem de erro na entrada e frente.ini //
  // Alterado em 01/06/04 condição no pack(download)               //
  // ------------------------------------------------------------- //
  Function _ecf09_LeituraMemoriaFiscalEmDisco(pP1,pP2,pP3: String):Boolean;
  Function _ecf09_MostraDisplay(pP1:String):Boolean;
  Function _ecf09_IniPortaStr(pP1:integer):integer;     //
  Function _ecf09_FechaPorta:integer;                    // Não tem parâmetro -> função nome_função:tipo_retorno_da_função
  Function _ecf09_CodeErro(Pp1: String):Integer;
  Function _ecf09_Inicializa(Pp1: String):Boolean;
  Function _ecf09_FechaCupom(Pp1: Boolean):Boolean;
  function _ecf09_Pagamento(Pp1: Boolean):Boolean;
  Function _ecf09_CancelaUltimoItem(Pp1: Boolean):Boolean;
  Function _ecf09_SubTotal(Pp1: Boolean):Real;
  Function _ecf09_AbreGaveta(Pp1: Boolean):Boolean;
  Function _ecf09_Sangria(Pp1: Real):Boolean;
  Function _ecf09_Suprimento(Pp1: Real):Boolean;
  Function _ecf09_NovaAliquota(Pp1: String):Boolean;
  Function _ecf09_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
  Function _ecf09_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
  Function _ecf09_CancelaUltimoCupom(Pp1: Boolean):Boolean;
  Function _ecf09_AbreNovoCupom(Pp1: Boolean):Boolean;
  Function _ecf09_NumeroDoCupom(Pp1: Boolean):String;
  Function _ecf09_CancelaItemN(pP1,pP2: String):Boolean;
  Function _ecf09_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pp8: String):Boolean;
  Function _ecf09_ReducaoZ(pP1: Boolean):Boolean;
  Function _ecf09_LeituraX(pP1: Boolean):Boolean;
  Function _ecf09_RetornaVerao(pP1: Boolean):Boolean;
  Function _ecf09_LigaDesLigaVerao(pP1: Boolean):Boolean;
  Function _ecf09_VersodoFirmware(pP1: Boolean): String;
  Function _ecf09_NmerodeSrie(pP1: Boolean): String;
  Function _ecf09_CGCIE(pP1: Boolean): String;
  Function _ecf09_Cancelamentos(pP1: Boolean): String;
  Function _ecf09_Descontos(pP1: Boolean): String;
  Function _ecf09_ContadorSeqencial(pP1: Boolean): String;
  Function _ecf09_Nmdeoperaesnofiscais(pP1: Boolean): String;
  Function _ecf09_NmdeCuponscancelados(pP1: Boolean): String;
  Function _ecf09_NmdeRedues(pP1: Boolean): String;
  Function _ecf09_Nmdeintervenestcnicas(pP1: Boolean): String;
  Function _ecf09_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
  Function _ecf09_Clichdoproprietrio(pP1: Boolean): String;
  Function _ecf09_NmdoCaixa(pP1: Boolean): String;
  Function _ecf09_Nmdaloja(pP1: Boolean): String;
  Function _ecf09_Moeda(pP1: Boolean): String;
  Function _ecf09_Dataehoradaimpressora(pP1: Boolean): String;
  Function _ecf09_Datadaultimareduo(pP1: Boolean): String;
  Function _ecf09_Datadomovimento(pP1: Boolean): String;
  Function _ecf09_Tipodaimpressora(pP1: Boolean): String;
  Function _ecf09_StatusGaveta(Pp1: Boolean):String;
  Function _ecf09_RetornaAliquotas(pP1: Boolean): String;
  Function _ecf09_Vincula(pP1: String): Boolean;
  Function _ecf09_FlagsDeISS(pP1: Boolean): String;
  Function _ecf09_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
  Function _ecf09_MudaMoeda(pP1: String): Boolean;
  function _ecf09_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean; //iP2 = Número do Cupom vinculado
  Function _ecf09_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
  function _ecf09_FechaCupom2(sP1: Boolean): Boolean;
  function _ecf09_ImprimeCheque(rP1: Real; sP2: String): Boolean;
  function _ecf09_TotalizadoresDasAliquotas(sP1: Boolean): String;
  function _ecf09_GrandeTotal(sP1: Boolean): String;
  function _ecf09_CupomAberto(sP1: Boolean): boolean;
  function _ecf09_FaltaPagamento(sP1: Boolean): boolean;
  function _ecf09_Envia(sComando:String; iTimeOut:Integer):String;

implementation

  function OpenFujitsu; external 'general32.dll';
  function TxFujitsu; external 'general32.dll';
  Function RxFujitsu; external 'general32.dll';
  procedure CloseFujitsu; external 'general32.dll';
  procedure AnalisaByte; external 'general32.dll';

// Verifica se a forma de pagamento está cadastrada
function _ecf09_VerificaFormaPgto(Forma:String):String;
var
  i,J:integer;
  sFinalizadoras:string;
begin
    Result:='XX';
    sFinalizadoras:=_ecf09_envia('611', 15)+_ecf09_envia('612', 15);
    for i := 1 to 30 do
    begin
      if I=1 then J:=1 else J:=(16*(I-1))+1;
      if Result='XX' then // só entra se ainda não encontrou
        if Forma='' then  // procura uma forma em branco
         begin
            if Length(AllTrim(Copy(sFinalizadoras,J,15))) <= 1 then Result:=Strzero(i,2,0);
         end
        else
         begin
            if (UpperCase(Forma)='CARTAO') or (UpperCase(Forma)='CHEQUE') then
             begin
               if Pos(UpperCase(Forma),UpperCase(Copy(sFinalizadoras,J,15))) > 0 then
               begin
                 if Right(Copy(sFinalizadoras,J,16),1)='1' then
                   Result:=Strzero(i,2,0)+'S'
                 else
                   Result:=Strzero(i,2,0)+'N';
               end;
             end
            else
              if Pos(UpperCase(Forma),UpperCase(Copy(sFinalizadoras,J,15))) > 0 then Result:=Strzero(i,2,0);
         end;
    end;
end;

// Verifica se a forma de pagamento está cadastrada pelo número, retornando a descrição
function _ecf09_VerificaDescricaoFormaPgto(Forma:String):String;
var
  sFinalizadoras:string;
begin
  Result:='';
  sFinalizadoras:=_ecf09_envia('611', 15)+_ecf09_envia('612', 15);
  Result:=AllTrim(Copy(sFinalizadoras,(16*((StrToInt('0'+AllTrim(Forma)))-1))+1   ,15));
end;



//----------------------------------------------------------------//
// Cadastra a forma de pagamento se tiver em modo de intervenção  //
//----------------------------------------------------------------//
function _ecf09_CadastraFormaPgto(Forma:String):Boolean;
var
   sX:String;
begin
   Result:=False;
   // verifica se está em modo de intervenção técnica
   if Copy(_ecf09_Envia('641', 15),2,1)='1' then
   begin
     if _ecf09_VerificaFormaPgto(Forma) = 'XX' then // não encontrou
     begin
        //Busca a próxima em branco
        sX:=_ecf09_VerificaFormaPgto('');
        if sX <> 'XX' then
        begin
           // cadastra a nova forma de pgto
           if Forma='CARTAO' then
            begin
               if _ecf09_CodeErro(_ecf09_Envia('0A'+sX+Copy(Forma+Replicate(' ',15),1,15)+'1' ,35))=0 then Result:=True;
            end
           else
            begin
              if _ecf09_CodeErro(_ecf09_Envia('0A'+sX+Copy(Forma+Replicate(' ',15),1,15)+'0' ,35))=0 then Result:=True;
            end;
        end;
     end;
  end;
end;


// ---------------------------------- //
// Tratamento de erros da GENERAL     //
// ---------------------------------- //
Function _ecf09_CodeErro(pP1: String):Integer;
var
  vErro    : array [0..161] of String;  // Cria uma matriz com  160 elementos
  I: Integer;

begin
  //
  for I := 0 to 161 do vErro[I] := 'Comando não executado.';

  vErro[00] := 'Sem erro';
  vErro[33] := 'Dados do comando enviado maior que 256 bytes';
  vErro[34] := 'Comando enviado maior que 73';
  vErro[35] := 'Tamanho do comando inválido';
  vErro[36] := 'Comando inválido';
  vErro[41] := 'Estouro do contador de intervenções';
  vErro[42] := 'O Comando deve ser executado após zeramento de toda memória';
  vErro[43] := 'Não é após redução Z';
  vErro[44] := 'Erro de cupom aberto';
  vErro[45] := 'Dados numéricos inválido';
  vErro[46] := 'Data e hora inválida';
  vErro[47] := 'Comando já executado ou proibido';
  vErro[48] := 'Erro de Texto inválido';
  vErro[49] := 'Erro de sequência de operação';
  vErro[50] := 'Erro de parâmetro inválido';
  vErro[51] := 'Erro de flags de operação';
  vErro[52] := 'Necessita programação prévia';
  vErro[53] := 'Estouro de capacidade do acumulador';
  vErro[54] := 'Desconto maior que o permitido';
  vErro[55] := 'Estouro do contador';
  vErro[56] := 'Cupom de relatório aberto';
  vErro[57] := 'Contra vale com valor zero';
  vErro[58] := 'Abertura do dia já realizado';
  vErro[60] := 'Data inválida';
  vErro[63] := 'Não permite este tipo de operação com ISSQN';
  vErro[64] := 'Não permite operação com transferência eletrônica de fundos(TEF)';
  vErro[82] := 'Cupom de Relatório X ou Z aberto';
  vErro[83] := 'Relatório Gerencial não é permitido';
  vErro[93] := 'Abertura do dia não realizada';
  vErro[94] := 'Erro de cálculo desconto/acréscimo';
  vErro[96] := 'O jumper de intervenção na posição errada';
  vErro[97] := 'Redução Z não realizado';
  vErro[99] := 'Redução Z do dia já realizado';

  vErro[113] := 'Falha de comunicação '+chr(10)+chr(10)+
               'Sugestão: verifique as conexões,'+chr(10)+
               'ligue e desligue a impressora. '+chr(10)+chr(10)+
               'O Sistema será Finalizado.';

  vErro[120] := 'Falta de papel';
  vErro[121] := 'Erro referente a memória fiscal';
  vErro[125] := 'Erro de queda de energia';
  vErro[128] := 'Relógio parado';
  vErro[160] := 'Erro na impressora não relatado';
  vErro[161] := 'Time out';
  if Copy(pP1,1,5)='ERRO:' then pP1:=Copy(pP1,6,length(pP1)-5) else pP1:='00';

  if strToInt(pP1) <> 161 then
     if pP1 <> '00' then Application.MessageBox(Pchar('Erro n.'+pP1+'-'+vErro[strToInt(pP1)]),'Atenção',mb_Ok + mb_DefButton1);
  Result:=strToInt(pP1);
  if (pP1 = '113') or (pP1 = '160') then Halt(1);
end;


// ----------------------------//
// Detecta qual a porta que    //
// a impressora está conectada //
// --------------------------- //

Function _ecf09_Inicializa(Pp1: String):Boolean; // NOK
var
  I, Retorno : Integer;
  Mais1ini:tinifile;
  sPrazo,  sDinheiro, sCheque, sCartao, sExtra1, sExtra2, sExtra3, sExtra4,
  sExtra5, sExtra6, sExtra7, sExtra8, sRetorno: String;
begin
{    _ecf09_Envia('2201000'+Copy(Right('0000000000'+AllTrim(Format('%13f',[8000.00])),13),1,10),25);

     sDinheiro:=ConverteAcentos(Copy(StrTran(Form1.SMensagem,chr(10),' ')+Replicate(' ',168),1,168));


//           showmessage(inttostr(length(sx)));
     // imprime propaganda e encerra o cupom
     _ecf09_Envia('23'+'0'+Copy(sDinheiro,01,42)+
                            '0'+Copy(sDinheiro,43,42)+
                            '0'+Copy(sDinheiro,85,42)+
                            '0'+Copy(sDinheiro,127,42)+'0',25);

   }
  // verifica o estado da impressora
  sRetorno:=_ecf09_Envia('641',15);
  if Form22.Label6.Caption = 'Detectando porta de comunicação...' then
  begin
    if (sRetorno='ERRO:161') then //time out
     begin
        Retorno:=_ecf09_IniPortaStr(StrToInt(Right(pP1,1)));
        for I := 1 to 4 do
        begin
          // ------------------------------------------------ //
          // Se o retorno for 0     testa as outras as portas //
          // até encontrar a impressora fiscal conectada.     //
          // ------------------------------------------------ //
          if Retorno = 0 then
          begin
            ShowMessage('Clique OK para testar a COM'+StrZero(I,1,0));
            Try
              Retorno:=_ecf09_IniPortaStr(I);//'Com'+StrZero(I,1,0));
              pP1     := 'Com'+StrZero(I,1,0);
              Form1.sPorta  := pP1;
            except end;
          end;
        end;
        //
        if (Retorno <> 1) then
          Result:=False
        else
         begin
           Form1.sPorta  := pP1;
           Result:=True;
         end;
     end
    else
     begin
       Result:=True;
     end;
    if Result then
    begin
       //verifica as formas de pagamento e cadastra se não existirem
       if _ecf09_VerificaFormaPgto('DINHEIRO') = 'XX' then
       begin
          // a modalidade dinheiro sempre está cadastrada
          // por isso se não achar é porque deu problema de
          // transmissão na impressora.
          _ecf09_CodeErro('ERRO:113');
       end;
       //-----------------------------------------------------------------------------
       //vefifica as formas de pagamento e cadastra se não existirem.
       // lê o arquivo frente.ini
       Mais1ini  := TIniFile.Create('frente.ini');
       sDinheiro := Mais1Ini.ReadString('Frente de caixa','Dinheiro','XX');
       sCheque   := Mais1Ini.ReadString('Frente de caixa','Cheque','XX');
       sCartao   := Mais1Ini.ReadString('Frente de caixa','Cartao','XX');
       sPrazo    := Mais1Ini.ReadString('Frente de caixa','Prazo','XX');
       if sPrazo='XX' then
       begin
         sPrazo    := Mais1Ini.ReadString('Frente de caixa','a Prazo','XX');
         if sPrazo <> 'XX' then
           Mais1Ini.WriteString('Frente de caixa','Prazo',sPrazo);
       end;
       sExtra1   := Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 1','');
       sExtra2   := Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 2','');
       sExtra3   := Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 3','');
       sExtra4   := Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 4','');
       sExtra5   := Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 5','');
       sExtra6   := Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 6','');
       sExtra7   := Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 7','');
       sExtra8   := Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 8','');

       if (sDinheiro='XX') or (sDinheiro='') then
       begin
         sDinheiro:= _ecf09_VerificaFormaPgto('DINHEIRO');
         if sDinheiro = 'XX' then
          begin
            // vê qual é a próxima disponível
            if not _ecf09_CadastraFormaPgto('DINHEIRO') then
               ShowMessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           'a DINHEIRO, e, não foi possível Cadastrar.'+chr(10)+
                           'Será necessário fazer uma intervenção técnica');
          end
         else
           Mais1Ini.WriteString('Frente de caixa','Dinheiro',StrZero(StrToInt(sDinheiro),2,0));
       end;
       if (sCheque='XX') or (sCheque='') or (FileExists('c:\TEF_DISC\TEF_DISC.INI')) then
       begin
         sCheque:=_ecf09_VerificaFormaPgto('CHEQUE');
         if sCheque = 'XX' then
          begin
            // vê qual é a próxima disponível
            if not _ecf09_CadastraFormaPgto('CHEQUE') then
               ShowMessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           'a CHEQUE, e, não foi possível Cadastrar.'+chr(10)+
                           'Será necessário fazer uma intervenção técnica');
          end
         else
            // Quando a forma for cheque o 3o digito é um S ou N se tem ou não TEF
            if (Copy(sCheque,3,1)='N') and (FileExists('c:\TEF_DISC\TEF_DISC.INI')) then
               Showmessage('A forma de pagamento CHEQUE não está configurada para '+chr(10)+
                           'emitir cupom vinculado. É necessário fazer uma intervenção '+chr(10)+
                           'técnica.')
            else
              Mais1Ini.WriteString('Frente de caixa','Cheque',StrZero(StrToInt(Copy(sCheque,1,2)),2,0));
       end;
       if (sCartao='XX') or (sCartao='') or ((FileExists('c:\TEF_DISC\TEF_DISC.INI')) or (FileExists('c:\TEF_DIAL\TEF_DIAL.INI')) or (FileExists('c:\disktef\bin\ichiper.exe'))  or (FileExists('c:\BCARD\BCARD.INI'))) then
       begin
         sCartao:= _ecf09_VerificaFormaPgto('CARTAO');
         if sCartao = 'XX' then
          begin
            // vê qual é a próxima disponível
            if not _ecf09_CadastraFormaPgto('CARTAO') then
               ShowMessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           'a CARTAO, e, não foi possível Cadastrar.'+chr(10)+
                           'Será necessário fazer uma intervenção técnica');
          end
         else
          begin
            // Quando a forma for cartão o 3o digito é um S ou N se tem ou não TEF
            if (Copy(sCartao,3,1)='N') and (((FileExists('c:\TEF_DISC\TEF_DISC.INI')) or (FileExists('c:\TEF_DIAL\TEF_DIAL.INI')) or (FileExists('c:\disktef\bin\ichiper.exe'))  or (FileExists('c:\BCARD\BCARD.INI')))) then
               Showmessage('A forma de pagamento CARTAO não está configurada para '+chr(10)+
                           'emitir cupom vinculado (TEF). É necessário fazer uma intervenção '+chr(10)+
                           'técnica.')
            else
              Mais1Ini.WriteString('Frente de caixa','Cartao',StrZero(StrToInt(Copy(sCartao,1,2)),2,0));
          end;
       end;
       if (sPrazo='XX') or (sPrazo='') then
       begin
         sPrazo:= _ecf09_VerificaFormaPgto('PRAZO');
         if sPrazo = 'XX' then
          begin
            // vê qual é a próxima disponível
            if not _ecf09_CadastraFormaPgto('PRAZO') then
               ShowMessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           'PRAZO, e, não foi possível Cadastrar.'+chr(10)+
                           'Será necessário fazer uma intervenção técnica');
          end
         else
           Mais1Ini.WriteString('Frente de caixa','Prazo',StrZero(StrToInt(sPrazo),2,0));
       end;
       //verifica as formas extras
       if sExtra1 <> '' then
       begin
         if _ecf09_VerificaDescricaoFormaPgto(sExtra1) = '' then
         begin
           //não encontrou, tenta cadastrá-la
           if _ecf09_VerificaFormaPgto(sExtra1) = 'XX' then
           begin
             // vê qual é a próxima disponível
             if _ecf09_CadastraFormaPgto(Mais1Ini.ReadString('Frente de caixa','Forma extra 1','')) then
               Showmessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           Mais1Ini.ReadString('Frente de caixa','Forma extra 1','')+'.'+chr(10)+
                           'Esta forma foi cadastrada, entre no menu F10-Formas de pagamento para definir sua ordem.')
             else
               Showmessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           Mais1Ini.ReadString('Frente de caixa','Forma extra 1','')+'.'+chr(10)+
                           'Esta forma não foi cadastrada, é necessário fazer uma intervenção técnica.');
           end;
         end;
       end;
       if sExtra2 <> '' then
       begin
         if _ecf09_VerificaDescricaoFormaPgto(sExtra2) = '' then
         begin
           //não encontrou, tenta cadastrá-la
           if _ecf09_VerificaFormaPgto(sExtra2) = 'XX' then
           begin
             // vê qual é a próxima disponível
             if _ecf09_CadastraFormaPgto(Mais1Ini.ReadString('Frente de caixa','Forma extra 2','')) then
               Showmessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           Mais1Ini.ReadString('Frente de caixa','Forma extra 2','')+'.'+chr(10)+
                           'Esta forma foi cadastrada, entre no menu F10-Formas de pagamento para definir sua ordem.')
             else
               Showmessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           Mais1Ini.ReadString('Frente de caixa','Forma extra 2','')+'.'+chr(10)+
                           'Esta forma não foi cadastrada, é necessário fazer uma intervenção técnica.');
           end;
         end;
       end;
       if sExtra3 <> '' then
       begin
         if _ecf09_VerificaDescricaoFormaPgto(sExtra3) = '' then
         begin
           //não encontrou, tenta cadastrá-la
           if _ecf09_VerificaFormaPgto(sExtra3) = 'XX' then
           begin
             // vê qual é a próxima disponível
             if _ecf09_CadastraFormaPgto(Mais1Ini.ReadString('Frente de caixa','Forma extra 3','')) then
               Showmessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           Mais1Ini.ReadString('Frente de caixa','Forma extra 3','')+'.'+chr(10)+
                           'Esta forma foi cadastrada, entre no menu F10-Formas de pagamento para definir sua ordem.')
             else
               Showmessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           Mais1Ini.ReadString('Frente de caixa','Forma extra 3','')+'.'+chr(10)+
                           'Esta forma não foi cadastrada, é necessário fazer uma intervenção técnica.');
           end;
         end;
       end;
       if sExtra4 <> '' then
       begin
         if _ecf09_VerificaDescricaoFormaPgto(sExtra4) = '' then
         begin
           //não encontrou, tenta cadastrá-la
           if _ecf09_VerificaFormaPgto(sExtra4) = 'XX' then
           begin
             // vê qual é a próxima disponível
             if _ecf09_CadastraFormaPgto(Mais1Ini.ReadString('Frente de caixa','Forma extra 4','')) then
               Showmessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           Mais1Ini.ReadString('Frente de caixa','Forma extra 4','')+'.'+chr(10)+
                           'Esta forma foi cadastrada, entre no menu F10-Formas de pagamento para definir sua ordem.')
             else
               Showmessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           Mais1Ini.ReadString('Frente de caixa','Forma extra 4','')+'.'+chr(10)+
                           'Esta forma não foi cadastrada, é necessário fazer uma intervenção técnica.');
           end;
         end;
       end;
       if sExtra5 <> '' then
       begin
         if _ecf09_VerificaDescricaoFormaPgto(sExtra5) = '' then
         begin
           //não encontrou, tenta cadastrá-la
           if _ecf09_VerificaFormaPgto(sExtra5) = 'XX' then
           begin
             // vê qual é a próxima disponível
             if _ecf09_CadastraFormaPgto(Mais1Ini.ReadString('Frente de caixa','Forma extra 5','')) then
               Showmessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           Mais1Ini.ReadString('Frente de caixa','Forma extra 5','')+'.'+chr(10)+
                           'Esta forma foi cadastrada, entre no menu F10-Formas de pagamento para definir sua ordem.')
             else
               Showmessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           Mais1Ini.ReadString('Frente de caixa','Forma extra 5','')+'.'+chr(10)+
                           'Esta forma não foi cadastrada, é necessário fazer uma intervenção técnica.');
           end;
         end;
       end;
       if sExtra6 <> '' then
       begin
         if _ecf09_VerificaDescricaoFormaPgto(sExtra6) = '' then
         begin
           //não encontrou, tenta cadastrá-la
           if _ecf09_VerificaFormaPgto(sExtra6) = 'XX' then
           begin
             // vê qual é a próxima disponível
             if _ecf09_CadastraFormaPgto(Mais1Ini.ReadString('Frente de caixa','Forma extra 6','')) then
               Showmessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           Mais1Ini.ReadString('Frente de caixa','Forma extra 6','')+'.'+chr(10)+
                           'Esta forma foi cadastrada, entre no menu F10-Formas de pagamento para definir sua ordem.')
             else
               Showmessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           Mais1Ini.ReadString('Frente de caixa','Forma extra 6','')+'.'+chr(10)+
                           'Esta forma não foi cadastrada, é necessário fazer uma intervenção técnica.');
           end;
         end;
       end;
       if sExtra7 <> '' then
       begin
         if _ecf09_VerificaDescricaoFormaPgto(sExtra7) = '' then
         begin
           //não encontrou, tenta cadastrá-la
           if _ecf09_VerificaFormaPgto(sExtra7) = 'XX' then
           begin
             // vê qual é a próxima disponível
             if _ecf09_CadastraFormaPgto(Mais1Ini.ReadString('Frente de caixa','Forma extra 7','')) then
               Showmessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           Mais1Ini.ReadString('Frente de caixa','Forma extra 7','')+'.'+chr(10)+
                           'Esta forma foi cadastrada, entre no menu F10-Formas de pagamento para definir sua ordem.')
             else
               Showmessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           Mais1Ini.ReadString('Frente de caixa','Forma extra 7','')+'.'+chr(10)+
                           'Esta forma não foi cadastrada, é necessário fazer uma intervenção técnica.');
           end;
         end;
       end;
       if sExtra8 <> '' then
       begin
         if _ecf09_VerificaDescricaoFormaPgto(sExtra8) = '' then
         begin
           //não encontrou, tenta cadastrá-la
           if _ecf09_VerificaFormaPgto(sExtra8) = 'XX' then
           begin
             // vê qual é a próxima disponível
             if _ecf09_CadastraFormaPgto(Mais1Ini.ReadString('Frente de caixa','Forma extra 8','')) then
               Showmessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           Mais1Ini.ReadString('Frente de caixa','Forma extra 8','')+'.'+chr(10)+
                           'Esta forma foi cadastrada, entre no menu F10-Formas de pagamento para definir sua ordem.')
             else
               Showmessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           Mais1Ini.ReadString('Frente de caixa','Forma extra 8','')+'.'+chr(10)+
                           'Esta forma não foi cadastrada, é necessário fazer uma intervenção técnica.');
           end;
         end;
       end;
    end;
  end;
  if Copy(sRetorno,1,4)='ERRO' then Result:=false else Result:=True;
end;

Function _ecf09_IniPortaStr(pP1: Integer):Integer; // OK
var
//  Retorno:string;
  aCom: array[0..10] of char;
begin
  StrPCopy(@aCom,'COM'+Alltrim(intToStr(pP1)));
  Result:=OpenFujitsu( @aCom );
  if _ecf09_envia('641', 15) = '00' then Result:=0;
end;

// ------------------------------ //
// Leitura de relatorio X         //
// ------------------------------ //
Function _ecf09_LeituraRelX(pP1: integer):String;
{var
  vRetorno : array [1..75] of String[22];  // Cria uma matriz com  100 elementos
  I,J      : Integer;}
begin
{  //
  Result:=_ecf09_FSerial(Form1.sPorta,Form1.iSequencial,'2F','','');
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



Function _ecf09_FechaCupom(Pp1: Boolean):Boolean; //
var
  retorno:String;
begin
   Result:=True;
   if Form1.fTotal = 0 then // cupom em branco cancela
    begin
      Retorno:=_ecf09_Envia('29',25);
      if Retorno<>'00' then
      begin
         Result:=false;
      end;
    end
   else
    begin
      // verifica se tem desconto/acréscimo
      if JStrToFloat(Format('%13.2f',[Form1.fTotal])) > JStrToFloat(Format('%13.2f',[Form1.ibDataSet25RECEBER.AsFloat])) then //Desconto
      begin
         //desconto
         Retorno:=_ecf09_Envia('2720000'+StrZero((Form1.fTotal-Form1.ibDataSet25RECEBER.AsFloat)*100,12,0),15);
         if _ecf09_CodeErro(Retorno) <> 0 then Result:=false;
      end;
      if JStrToFloat(Format('%13.2f',[Form1.fTotal])) < JStrToFloat(Format('%13.2f',[Form1.ibDataSet25RECEBER.AsFloat])) then //Acrescimo
      begin
         //acréscimo
         if Form1.ibDataSet25RECEBER.AsFloat >= (Form1.fTotal*2) then
          begin
            showmessage(' Acréscimo maior que o permitido');
            Result:=false;
          end
         else
          begin
            Retorno:=_ecf09_Envia('2740000'+StrZero((Form1.ibDataSet25RECEBER.AsFloat-Form1.fTotal)*100,12,0),15);
            if Copy(Retorno,1,7)='ERRO:47' then
             begin
               showmessage(' Acréscimo maior que o permitido');
               Result:=false;
             end
            else
             begin
               if _ecf09_CodeErro(Retorno) <> 0 then Result:=false;
             end;
          end;
      end;
    end;
end;

function _ecf09_Pagamento(Pp1: Boolean):Boolean;
var
  sPrazo,  sDinheiro, sCheque, sCartao, sExtra1, sExtra2, sExtra3, sExtra4,
  sExtra5, sExtra6, sExtra7, sExtra8, sX,Retorno,sTempo: String;
  i,k:integer;
  fSubTotal:double;
  Mais1ini:tinifile;
begin
  //Result:=True;
  fSubTotal:=_ecf09_SubTotal(True);
  //lê as formas de pgto no ini
  Mais1ini  := TIniFile.Create('frente.ini');
  //
  sDinheiro := StrZero(StrToInt(Mais1Ini.ReadString('Frente de caixa','Dinheiro','02')),2,0);
  sCheque   := StrZero(StrToInt(Mais1Ini.ReadString('Frente de caixa','Cheque','03')),2,0);
  sPrazo    := StrZero(StrToInt(Mais1Ini.ReadString('Frente de caixa','Prazo','04')),2,0);
  sCartao   := StrZero(StrToInt(Mais1Ini.ReadString('Frente de caixa','Cartao','05')),2,0);

  sExtra1   := Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 1','');
  if sExtra1<>'' then sExtra1:=StrZero(StrToInt(sExtra1),2,0);
  sExtra2   := Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 2','');
  if sExtra2<>'' then sExtra2:=StrZero(StrToInt(sExtra2),2,0);
  sExtra3   := Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 3','');
  if sExtra3<>'' then sExtra3:=StrZero(StrToInt(sExtra3),2,0);
  sExtra4   := Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 4','');
  if sExtra4<>'' then sExtra4:=StrZero(StrToInt(sExtra4),2,0);
  sExtra5   := Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 5','');
  if sExtra5<>'' then sExtra5:=StrZero(StrToInt(sExtra5),2,0);
  sExtra6   := Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 6','');
  if sExtra6<>'' then sExtra6:=StrZero(StrToInt(sExtra6),2,0);
  sExtra7   := Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 7','');
  if sExtra7<>'' then sExtra7:=StrZero(StrToInt(sExtra7),2,0);
  sExtra8   := Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 8','');
  if sExtra8<>'' then sExtra8:=StrZero(StrToInt(sExtra8),2,0);
  //--------------------- //
  // Forma de pagamento   //
  //--------------------- //
  if Form1.ibDataSet25DIFERENCA_.AsFloat = 0 then// à vista
   begin
//    while Form1.sGaveta = '255' do
//        Form1.sGaveta:=_ecf09_StatusGaveta(True);
     if Form1.ibDataSet25ACUMULADO2.AsFloat > 0 then // dinheiro > 0
     begin
       sX:=sDinheiro;//_ecf09_VerificaFormaPgto('DINHEIRO');
       Retorno:=_ecf09_Envia('22'+sX+'000'+Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.ibDataSet25ACUMULADO2.AsFloat)*100])),13),1,10),25);
       _ecf09_CodeErro(Retorno);
     end;

     if Form1.ibDataSet25ACUMULADO1.AsFloat > 0 then // cheque > 0
     begin
      // se o valor em dinheiro já supriu o total da venda
      if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
        showmessage('A modalidade cheque será desconsiderada.')
      else
       begin
         sX:=sCheque;//_ecf09_VerificaFormaPgto('CHEQUE');
         Retorno:=_ecf09_Envia('22'+sX+'000'+Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.ibDataSet25ACUMULADO1.AsFloat)*100])),13),1,10),25);
         _ecf09_CodeErro(Retorno);
       end;
     end;
     if Form1.ibDataSet25PAGAR.AsFloat <> 0 then // Cartão
     begin
      // se o valor em dinheiro+chrque já supriu o total da venda
       if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat+Form1.ibDataSet25ACUMULADO1.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
         showmessage('A modalidade cartão será desconsiderada.')
       else
         begin
           sX:=sCartao;//_ecf09_VerificaFormaPgto('CARTAO');
           Retorno:=_ecf09_Envia('22'+sX+'000'+Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.ibDataSet25PAGAR.AsFloat)*100])),13),1,10),25);
           _ecf09_CodeErro(Retorno);
         end;
     end;

     //
     //   modalidades extras
     //
     if Form1.ibDataSet25VALOR01.AsFloat <> 0 then //Modalidade extra 1
     begin
       // se o valor em dinheiro já supriu o total da venda
       if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
         showmessage('A modalidade '+Mais1Ini.ReadString('Frente de caixa','Forma extra 1','')+' será desconsiderada.')
       else
        begin
          sX:=sExtra1;
          Retorno:=_ecf09_Envia('22'+sX+'000'+Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.ibDataSet25VALOR01.AsFloat)*100])),13),1,10),25);
          _ecf09_CodeErro(Retorno);
        end;
     end;
     //
     if Form1.ibDataSet25VALOR02.AsFloat <> 0 then //Modalidade extra 2
     begin
       // se o valor em dinheiro já supriu o total da venda
       if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
         showmessage('A modalidade '+Mais1Ini.ReadString('Frente de caixa','Forma extra 2','')+' será desconsiderada.')
       else
        begin
          sX:=sExtra2;
          Retorno:=_ecf09_Envia('22'+sX+'000'+Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.ibDataSet25VALOR02.AsFloat)*100])),13),1,10),25);
          _ecf09_CodeErro(Retorno);
        end;
     end;
     //
     if Form1.ibDataSet25VALOR03.AsFloat <> 0 then //Modalidade extra 3
     begin
       // se o valor em dinheiro já supriu o total da venda
       if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
         showmessage('A modalidade '+Mais1Ini.ReadString('Frente de caixa','Forma extra 3','')+' será desconsiderada.')
       else
        begin
          sX:=sExtra3;
          Retorno:=_ecf09_Envia('22'+sX+'000'+Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.ibDataSet25VALOR03.AsFloat)*100])),13),1,10),25);
          _ecf09_CodeErro(Retorno);
        end;
     end;
     //
     if Form1.ibDataSet25VALOR04.AsFloat <> 0 then //Modalidade extra 4
     begin
       // se o valor em dinheiro já supriu o total da venda
       if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
         showmessage('A modalidade '+Mais1Ini.ReadString('Frente de caixa','Forma extra 4','')+' será desconsiderada.')
       else
        begin
          sX:=sExtra4;
          Retorno:=_ecf09_Envia('22'+sX+'000'+Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.ibDataSet25VALOR04.AsFloat)*100])),13),1,10),25);
          _ecf09_CodeErro(Retorno);
        end;
     end;
     //
     if Form1.ibDataSet25VALOR05.AsFloat <> 0 then //Modalidade extra 5
     begin
       // se o valor em dinheiro já supriu o total da venda
       if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
         showmessage('A modalidade '+Mais1Ini.ReadString('Frente de caixa','Forma extra 5','')+' será desconsiderada.')
       else
        begin
          sX:=sExtra5;
          Retorno:=_ecf09_Envia('22'+sX+'000'+Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.ibDataSet25VALOR05.AsFloat)*100])),13),1,10),25);
          _ecf09_CodeErro(Retorno);
        end;
     end;
     //
     if Form1.ibDataSet25VALOR06.AsFloat <> 0 then //Modalidade extra 6
     begin
       // se o valor em dinheiro já supriu o total da venda
       if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
         showmessage('A modalidade '+Mais1Ini.ReadString('Frente de caixa','Forma extra 6','')+' será desconsiderada.')
       else
        begin
          sX:=sExtra6;
          Retorno:=_ecf09_Envia('22'+sX+'000'+Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.ibDataSet25VALOR06.AsFloat)*100])),13),1,10),25);
          _ecf09_CodeErro(Retorno);
        end;
     end;
     //
     if Form1.ibDataSet25VALOR07.AsFloat <> 0 then //Modalidade extra 7
     begin
       // se o valor em dinheiro já supriu o total da venda
       if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
         showmessage('A modalidade '+Mais1Ini.ReadString('Frente de caixa','Forma extra 7','')+' será desconsiderada.')
       else
        begin
          sX:=sExtra7;
          Retorno:=_ecf09_Envia('22'+sX+'000'+Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.ibDataSet25VALOR07.AsFloat)*100])),13),1,10),25);
          _ecf09_CodeErro(Retorno);
        end;
     end;
     //
     if Form1.ibDataSet25VALOR08.AsFloat <> 0 then //Modalidade extra 8
     begin
       // se o valor em dinheiro já supriu o total da venda
       if JStrToFloat(Format('%13.2f',[Form1.ibDataSet25ACUMULADO2.AsFloat])) >= JStrToFloat(Format('%13.2f',[fSubTotal])) then
         showmessage('A modalidade '+Mais1Ini.ReadString('Frente de caixa','Forma extra 8','')+' será desconsiderada.')
       else
        begin
          sX:=sExtra8;
          Retorno:=_ecf09_Envia('22'+sX+'000'+Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.ibDataSet25VALOR08.AsFloat)*100])),13),1,10),25);
          _ecf09_CodeErro(Retorno);
        end;
     end;
     Form1.sMensagemPromocional:=ConverteAcentos(Form1.sMensagemPromocional);
     //transforma chr(10) em linhas de 42 colunas
     k:=0;
     sTempo:='';
     for i:=1 to length(Form1.sMensagemPromocional) do
     begin
       if Copy(Form1.sMensagemPromocional,i,1)=chr(10) then
        begin
          sTempo:=sTempo+Replicate(' ',42-k);
          k:=0;
        end
       else
        begin
          sTempo:=sTempo+Copy(Form1.sMensagemPromocional,i,1);
          k:=k+1;
        end;
     end;
     sX:=sTempo+Replicate(' ',337);

//           showmessage(inttostr(length(sx)));

     Retorno:=_ecf09_Envia('2C0'+Copy(sX,01,42)+
                '0'+Copy(sX,43,42)+
                '0'+Copy(sX,85,42)+
                '0'+Copy(sX,127,42),25);

     // imprime propaganda e encerra o cupom
     Retorno:=_ecf09_Envia('23'+'0'+Copy(sX,169,42)+
                            '0'+Copy(sX,211,42)+
                            '0'+Copy(sX,253,42)+
                            '0'+Copy(sX,295,42)+'0',25);

     _ecf09_CodeErro(Retorno);
   end
  else
   begin//prazo
      sX:=sPrazo;//_ecf09_VerificaFormaPgto('PRAZO');
      Retorno:=_ecf09_Envia('22'+sX+'000'+Copy(Right('0000000000'+AllTrim(Format('%13f',[(Form1.ibDataSet25RECEBER.AsFloat)*100])),13),1,10),25);
      _ecf09_CodeErro(Retorno);

      begin
         Form1.sMensagemPromocional:=ConverteAcentos(Form1.sMensagemPromocional);
         //transforma chr(10) em linhas de 42 colunas
         k:=0;
         sTempo:='';
         for i:=1 to length(Form1.sMensagemPromocional) do
         begin
           if Copy(Form1.sMensagemPromocional,i,1)=chr(10) then
            begin
              sTempo:=sTempo+Replicate(' ',42-k);
              k:=0;
            end
           else
            begin
              sTempo:=sTempo+Copy(Form1.sMensagemPromocional,i,1);
              k:=k+1;
            end;
         end;
         sX:=sTempo+Replicate(' ',337);

    //           showmessage(inttostr(length(sx)));

         Retorno:=_ecf09_Envia('2C0'+Copy(sX,01,42)+
                    '0'+Copy(sX,43,42)+
                    '0'+Copy(sX,85,42)+
                    '0'+Copy(sX,127,42),25);

         // imprime propaganda e encerra o cupom
         Retorno:=_ecf09_Envia('23'+'0'+Copy(sX,169,42)+
                                '0'+Copy(sX,211,42)+
                                '0'+Copy(sX,253,42)+
                                '0'+Copy(sX,295,42)+'0',25);
      end;


       _ecf09_CodeErro(Retorno);
   end;
   Result:=true;
end;
// ----------------------------- //
// Cancela o último item emitido //
// ----------------------------- //
Function _ecf09_CancelaUltimoItem(Pp1: Boolean):Boolean; //
var
  Retorno:String;
begin
  if (Copy(AllTrim(TLAbel(Form1.Components[Form1.ComponentCount-1]).Caption),1,8) = 'Desconto') or (Copy(AllTrim(TLAbel(Form1.Components[Form1.ComponentCount-1]).Caption),1,8) = 'Cancelad') then
     Result:=False
  else
   begin
     Result:=False;
     Retorno:=_ecf09_Envia('641',15);
     if Right(Retorno,3) = '010' then // posição de efetuar venda
        if _ecf09_SubTotal(True) > 0 then
        begin
           Retorno:=_ecf09_Envia('24',15); //
           if Copy(Retorno,1,5)='ERRO:' then
             Result:=False
           else
             Result:=True;
        end;
   end;
end;

Function _ecf09_CancelaUltimoCupom(pP1: Boolean):Boolean; // OK
var
  Retorno:String;
begin
  if not pP1 then //cancela cupom atual
   begin
     Retorno:=_ecf09_Envia('29',25);
     if Retorno<>'00' then
      begin
        _ecf09_CodeErro(Retorno);
        Result:=false;
      end
     else
      Result:=True;
   end
  else
   begin
    Retorno:=_ecf09_Envia('2A',25);
    if Retorno = 'ERRO:51' then
     begin
       Showmessage('Não é possível cancelar uma venda com cupom vinculado');
       Result:=False;
     end
    else
     if _ecf09_CodeErro(Retorno) <> 0 then
       Result:=false
     else
        Result:=True;
   end;
end;

Function _ecf09_SubTotal(Pp1: Boolean):Real; //
var
  sTemp:String;
begin
   sTemp:=_ecf09_envia('6782',15);
   Delete(sTemp,1,2); // tira o 14
   insert(',',sTemp,13);
   Result:=JStrToFloat(sTemp);// ver casas decimais
end;

// ------------------------------ //
// Abre um novo cupom fiscal      //
// ------------------------------ //
Function _ecf09_AbreNovoCupom(Pp1: Boolean):Boolean; // OK
var
  Retorno:string;
begin
  Result:=False;
  // verifica o estado da impressora
  Retorno:=_ecf09_Envia('641',15);
//  if (Right(Retorno,3) = '001') or (Right(Retorno,3) = '010') then // cupom já aberto ou em posição de venda
  if (Right(Retorno,3) <> '000') then // cupom já aberto ou em posição de venda
     Result:=True
  else
   begin
      // tenta abrir o cupom
      Retorno:=_ecf09_Envia('200',25);
      if Copy(Retorno,1,4)='ERRO' then // deu ERRO
       begin
         if Copy(Retorno,6,2)='97' then // necessita Redução Z
          begin
             Retorno:=_ecf09_Envia('520',75); // faz Relatorio Z
             Retorno:=_ecf09_Envia('50',75);  // abre o dia
             // tenta abrir o cupom de novo
             Retorno:=_ecf09_Envia('200',25);
             if Copy(Retorno,1,4)='ERRO' then
                showmessage(Retorno)
             else
                result:=True;
          end
         else
          if Copy(Retorno,6,2)='93' then // falta abrir o dia
           begin
             Retorno:=_ecf09_Envia('50',75); // abre o dia
             // tenta abrir o cupom de novo
             Retorno:=_ecf09_Envia('200',25);
             if Copy(Retorno,1,4)='ERRO' then
                showmessage(Retorno)
             else
                result:=True;
           end
          else
           if (Copy(Retorno,6,2)='51') then // cupom não vinculado aberto
            begin
              //tenta fechar o relatório
              Retorno:=_ecf09_Envia('56', 25);
              // tenta abrir o cupom de novo
              Retorno:=_ecf09_Envia('200',25);
              if Copy(Retorno,1,4)='ERRO' then
                 showmessage(Retorno)
              else
                 result:=True;
            end
           else
            showmessage(Retorno);
       end
      else
        result:=true;
   end;
end;

// -------------------------------- //
// Retorna o número do Cupom        //
// -------------------------------- //
Function _ecf09_NumeroDoCupom(Pp1: Boolean):String; //OK
begin
   Result:=Copy(_ecf09_envia('6776',15),3,6);
end;

// ------------------------------ //
// Cancela um item N              //
// ------------------------------ //
Function _ecf09_CancelaItemN(pP1,pP2: String):Boolean; //
var
  Retorno:String;
  i,j:integer;
begin
  Result:=False;
  Retorno:=_ecf09_Envia('641',15);
  if Right(Retorno,3) = '010' then // posição de efetuar venda
     if _ecf09_SubTotal(True) > 0 then
     begin
//        _ecf09_Envia('25'+StrZero((StrToInt(pP1)+Form1.iCancelaItenN),3,0)); //
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
           Retorno:=_ecf09_Envia('25'+StrZero(j,3,0),15); //StrToInt(pP1),3,0),15);
           if (Retorno='ERRO:54') or (Retorno='ERRO:47') then
            begin
              showmessage('Não é possível cancelar este item');
              Result:=False;
            end
           else
   //        Form1.iCancelaItenN:=Form1.iCancelaItenN+1;
              Result:=True;
         end;
      end;
end;

// -------------------------------- //
// Abre a gaveta                    //
// -------------------------------- //
Function _ecf09_AbreGaveta(Pp1: Boolean):Boolean; // OK
var
   Retorno:string;
begin
   Retorno:=_ecf09_Envia('451',15);
   if Copy(Retorno,6,2)='93' then // falta abrir o dia
   begin
     Retorno:=_ecf09_Envia('50',75); // abre o dia
     // tenta abrir a gaveta de novo
     Retorno:=_ecf09_Envia('451',15);
     if Copy(Retorno,1,4)='ERRO' then
        showmessage(Retorno);
   end;
   //if _ecf09_CodeErro(Retorno)=0 then Result:=true else Result:=False;
   sleep(500);
   Result:=true;
end;

// -------------------------------- //
// Status da gaveta                 //
// -------------------------------- //
Function _ecf09_StatusGaveta(Pp1: Boolean):String; //
var
   Retorno:string;
begin
   //
   Retorno:=_ecf09_Envia('641',15);
   //
   if _ecf09_CodeErro(Retorno)=0 then
   begin
      if Form1.iStatusGaveta = 0 then
      begin
        if Copy(Retorno,4,1)='1' then Result:= '000' else Result:= '255';
      end else
      begin
        if Copy(Retorno,4,1)='1' then Result:= '255' else Result:= '000';
      end;
   end else
   begin
     Result:='255';
   end;
end;

// -------------------------------- //
// Sangria                          //
// -------------------------------- //
Function _ecf09_Sangria(Pp1: Real):Boolean; // OK
var
   Retorno:string;
begin
   Retorno:=_ecf09_Envia('410501'+strzero(pP1*100,13,0),25);
   if _ecf09_CodeErro(Retorno)=0 then Result:=true else Result:=False;
end;

// -------------------------------- //
// Suprimento                       //
// -------------------------------- //
Function _ecf09_Suprimento(Pp1: Real):Boolean;//OK
var
   Retorno:string;
begin
   Retorno:=_ecf09_Envia('410401'+strzero(pP1*100,13,0),25);
   if Copy(Retorno,6,2)='93' then // falta abrir o dia
   begin
     Retorno:=_ecf09_Envia('50',75); // abre o dia
     // tenta fazer o suprimento de novo
     Retorno:=_ecf09_Envia('410401'+strzero(pP1*100,13,0),25);
     if Copy(Retorno,1,4)='ERRO' then
        showmessage(Retorno);
   end;
   if _ecf09_CodeErro(Retorno)=0 then Result:=true else Result:=False;
end;

// -------------------------------- //
// Nova Aliquota                    //
// -------------------------------- //
Function _ecf09_NovaAliquota(Pp1: String):Boolean;
begin
  showmessage('Só é possivel Cadastrar nova alíquota em modo de intervenção');
  Result := False;
end;

Function _ecf09_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
begin
  ShowMessage('Função não suportada pelo modelo de ECF utilizado.');
  Result := True;
end;

Function _ecf09_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;   //OK
var
   Retorno:string;
begin
  if Form7.Label3.Caption = 'Data inicial:' then
   begin
     if StrToInt(Copy(pP1,5,2)) > 90 then
        _ecf09_Envia('55'+Copy(pP1,1,4)+'19'+Copy(pP1,5,2)+Copy(pP2,1,4)+'19'+Copy(pP2,5,2),15)
     else
        _ecf09_Envia('55'+Copy(pP1,1,4)+'20'+Copy(pP1,5,2)+Copy(pP2,1,4)+'20'+Copy(pP2,5,2),15);
   end
  else
   begin
     pP1:=StrZero(StrToInt('0'+pP1),4,0);
     pP2:=StrZero(StrToInt('0'+pP2),4,0);
     Retorno:=_ecf09_Envia('54'+pP1+pP2,15);
   end;
  if _ecf09_CodeErro(Retorno)=0 then Result:=true else Result:=False;
end;

{Function _ecf09_LeituraMemoriaFiscalEmDisco(pP1,pP2,pP3: String):Boolean;   //
//pP1 é a unidade onde será gravado o arquivo.
var
//  Retorno:String;
//  t,t1:textfile;
  Stream1,Stream2:TfileStream;
//  sDados:String;
//  sCabecalho: array [0..4] of string;
//  i:integer;
//  bTipo1,bTipo2,bTipo3,bTipo4,bTipo5,bTipo6,bTipo7:boolean;
begin
  bTipo1:=False;bTipo2:=False;bTipo3:=False;bTipo4:=False;bTipo5:=False;bTipo6:=False;bTipo7:=False;
  // busca os números de CNPJ, I.E. e I.M.
   sDados:=_ecf09_Envia('64',15);
   sCabecalho[0]:='CNPJ/CGC: '+Copy(sDados,35,18);
   sCabecalho[1]:='I.E.:     '+Copy(sDados,53,18);
   sCabecalho[2]:='I.M.:     '+Copy(sDados,71,18);
   sCabecalho[3]:=Copy(sDados,1,2)+'-'+Copy(sDados,3,2)+'-'+Copy(sDados,5,4)+' '+Copy(sDados,9,2)+':'+Copy(sDados,11,2)+'   GNF:';
   sCabecalho[4]:='     RELATORIO DE TODA MEMORIA FISCAL';
  //
  Retorno:=_ecf09_Envia('660',15);
  if _ecf09_CodeErro(Retorno)=0  then
  begin
    assignfile(t,Form1.sAtual+'\MEMFIS.TXT');
    assignfile(t1,Form1.sAtual+'\MEMFIS.TMP');
    rewrite(t);
    rewrite(t1);

//    Writeln(t,'--------------------[ Gerado em '+DateTimeToStr(Now)+' ]-------------------');
//    Writeln(t1,'--------------------[ VENDAS BRUTAS ]------------------');
    while Copy(Retorno,1,1) <> '8' do   // 8 é o fim de arquivo
    begin
     if Copy(Retorno,1,1) = '1' then // cabeçalho
      begin
        if not bTipo1 then
        begin
           sCabecalho[3]:=sCabecalho[3]+Copy(Retorno,1,6)+'   COO:'+Copy(Retorno,7,6);
           For i:=0 to 4 do
             Writeln(t,sCabecalho[i]);
           Writeln(' ');//linha em branco
           bTipo1:=True;
        end;

//        Writeln(t,'MARCA '+Copy(Retorno,26,15)+' MODELO '+Copy(Retorno,41,15)+' NUMERO DE SERIE: '+Copy(Retorno,18,8));
//        Writeln(t,'VERSAO DE FABRICA: '+Copy(Retorno,56,4));
      end
     else
      if Copy(Retorno,1,1) = '2' then // usuários
       begin
         if not bTipo2 then
         begin
            Writeln(t,'          RELACAO DOS USUARIOS');
            Writeln(t,'DATA       HORA  CRO                 VBRUT');
            Writeln(t,'------------------------------------------');
            bTipo2:=True;
         end
         Writeln(t,'CGC/CNPJ: '+Copy(Retorno,36,18));
         Writeln(t,'I.E.:     '+Copy(Retorno,53,18));
         Writeln(t,'I.M.:     '+Copy(Retorno,72,18));
         Writeln(' ');//linha em branco

//         Writeln(t,'CRO='+Copy(Retorno,14,4)+' D='+Copy(Retorno,2,2)+'/'+Copy(Retorno,4,2)+'/'+Copy(Retorno,6,4)+' H='+Copy(Retorno,10,2)+':'+Copy(Retorno,12,2)+' GT='+Copy(Retorno,18,18));
//         Writeln(t,'CNPJ='+Copy(Retorno,36,18)+' IE='+Copy(Retorno,53,18)+' IM='+Copy(Retorno,72,18));
       end
      else
        if Copy(Retorno,1,1) = '3' then // intervenção
         begin
           if not bTipo3 then
           begin
              Writeln(t,'         --REINICIO DE OPERACAO--');
              Writeln(t,'DATA       HORA  CRO');
              Writeln(t,'------------------------------------------');
              bTipo3:=true;
           end;
           Writeln(t,Copy(Retorno,2,2)+'/'+Copy(Retorno,4,2)+'/'+Copy(Retorno,6,4)+' '+Copy(Retorno,10,2)+':'+Copy(Retorno,12,2)+' '+Copy(Retorno,14,4));
           //           Writeln(t,'CRO='+Copy(Retorno,14,4)+' '+Copy(Retorno,2,2)+'/'+Copy(Retorno,4,2)+'/'+Copy(Retorno,6,4)+' '+Copy(Retorno,10,2)+':'+Copy(Retorno,12,2));
         end
        else
         if Copy(Retorno,1,1) = '4' then // vendas
          begin
            if not bTipo4 then
            begin
              Writeln(' ');//linha em branco
              Writeln(t,'         ---REDUCOES DIARIAS ---');
              Writeln(t,'DATA       HORA  CRO  CRZ            VBRUT');
              Writeln(t,'------------------------------------------');
              Writeln(t,'URUARIO :'+
              bTipo4:=true;
            end;

            Writeln(t1,'D='+Copy(Retorno,2,2)+'/'+Copy(Retorno,4,2)+'/'+Copy(Retorno,6,4)+' H='+Copy(Retorno,10,2)+':'+Copy(Retorno,12,2)+' CRO='+Copy(Retorno,14,4)+' CRZ='+Copy(Retorno,18,4)+' V.B.='+Copy(Retorno,22,14));
            Writeln(t1,'TABELA='+Copy(Retorno,36,3)+' I='+Copy(Retorno,39,14)+' F='+Copy(Retorno,53,14)+' N='+Copy(Retorno,67,14)+' C='+Copy(Retorno,81,14)+' D='+Copy(Retorno,95,14));
          end
         else
          if Copy(Retorno,1,1) = '5' then // vendas 2.Parte
           begin
             Writeln(t1,'T1='+Copy(Retorno,2,14)+' T2='+Copy(Retorno,16,14)+' T3='+Copy(Retorno,30,14)+' T4='+Copy(Retorno,54,14)+' T5='+Copy(Retorno,68,14)+' T6='+Copy(Retorno,82,14)+' T7='+Copy(Retorno,96,14)+' T8='+Copy(Retorno,110,14));
             Writeln(t1,'T9='+Copy(Retorno,124,14)+' T10='+Copy(Retorno,138,14)+' T11='+Copy(Retorno,152,14)+' T12='+Copy(Retorno,166,14)+' T13='+Copy(Retorno,180,14)+' T14='+Copy(Retorno,194,14)+' T15='+Copy(Retorno,208,14)+' T16='+Copy(Retorno,222,14));
           end
          else
           if Copy(Retorno,1,1) = '6' then // situação tributária
           begin
              Writeln(t1,'A1='+Copy(Retorno,2,5)+' A2='+Copy(Retorno,7,5)+' A3='+Copy(Retorno,12,5)+' A4='+Copy(Retorno,17,5)+' A5='+Copy(Retorno,22,5)+' A6='+Copy(Retorno,27,5)+' A7='+Copy(Retorno,32,5)+' A8='+Copy(Retorno,37,5));
              Writeln(t1,'A9='+Copy(Retorno,42,5)+' A10='+Copy(Retorno,47,5)+' A11='+Copy(Retorno,52,5)+' A12='+Copy(Retorno,57,5)+' A13='+Copy(Retorno,62,5)+' A14='+Copy(Retorno,67,5)+' A15='+Copy(Retorno,72,5)+' A16='+Copy(Retorno,77,5));
           end;
      Retorno:=_ecf09_Envia('661',15);// próximo registro
    end;
  end;
  closefile(t1);
  closefile(t);

  Stream1:=TFileStream.Create(Form1.sAtual+'\MEMFIS.TXT',fmOpenRead);
  Stream2:=TFileStream.Create(pP1,fmOpenWrite or fmCreate);
  Stream2.CopyFrom(Stream1, Stream1.Size);
  Stream2.Seek(0,0);
  Stream2.seek(Stream2.size, soFromBeginning);
  Stream1.Free;
  Stream1:=TFileStream.Create(Form1.sAtual+'\MEMFIS.TMP',fmOpenRead);
  if Stream2.CopyFrom(Stream1, Stream1.Size) > 0 then  Result:= True  else Result:= False;
  Stream1.Free;
  Stream2.Free;
  DeleteFile(Form1.sAtual+'\MEMFIS.TMP');
  DeleteFile(Form1.sAtual+'\MEMFIS.TXT');
}


Function _ecf09_LeituraMemoriaFiscalEmDisco(pP1,pP2,pP3: String):Boolean;   //
//pP1 é a unidade onde será gravado o arquivo.
var
  Retorno:String;
  t,t1:textfile;
  Stream1,Stream2:TfileStream;
begin
  if not (UpperCase(Form1.ibDataSet13.FieldByName('ESTADO').AsString)= 'MG') then
    begin
      Retorno:=_ecf09_Envia('660',15);
      if _ecf09_CodeErro(Retorno)=0  then
      begin
        assignfile(t,Form1.sAtual+'\MEMFIS.TXT');
        assignfile(t1,Form1.sAtual+'\MEMFIS.TMP');
        rewrite(t);
        rewrite(t1);
        Writeln(t,'--------------------[ Gerado em '+DateTimeToStr(Now)+' ]-------------------');
        Writeln(t1,'--------------------[ VENDAS BRUTAS ]------------------');
        while Copy(Retorno,1,1) <> '8' do   // 8 é o fim de arquivo
        begin
         if Copy(Retorno,1,1) = '1' then // cabeçalho
          begin
            Writeln(t,'MARCA '+Copy(Retorno,26,15)+' MODELO '+Copy(Retorno,41,15)+' NUMERO DE SERIE: '+Copy(Retorno,18,8));
            Writeln(t,'VERSAO DE FABRICA: '+Copy(Retorno,56,4));
          end
         else
          if Copy(Retorno,1,1) = '2' then // usuários
           begin
             Writeln(t,'--------------------[ USUARIO ]-------------------');
             Writeln(t,'CRO='+Copy(Retorno,14,4)+' D='+Copy(Retorno,2,2)+'/'+Copy(Retorno,4,2)+'/'+Copy(Retorno,6,4)+' H='+Copy(Retorno,10,2)+':'+Copy(Retorno,12,2)+' GT='+Copy(Retorno,18,18));
             Writeln(t,'CNPJ='+Copy(Retorno,36,18)+' IE='+Copy(Retorno,53,18)+' IM='+Copy(Retorno,72,18));
           end
          else
            if Copy(Retorno,1,1) = '3' then // intervenção
             begin
               Writeln(t,'--------------------[ INTERVENCAO ]-------------------');
               Writeln(t,'CRO='+Copy(Retorno,14,4)+' '+Copy(Retorno,2,2)+'/'+Copy(Retorno,4,2)+'/'+Copy(Retorno,6,4)+' '+Copy(Retorno,10,2)+':'+Copy(Retorno,12,2));
             end
            else
             if Copy(Retorno,1,1) = '4' then // vendas
              begin
                Writeln(t1,'D='+Copy(Retorno,2,2)+'/'+Copy(Retorno,4,2)+'/'+Copy(Retorno,6,4)+' H='+Copy(Retorno,10,2)+':'+Copy(Retorno,12,2)+' CRO='+Copy(Retorno,14,4)+' CRZ='+Copy(Retorno,18,4)+' V.B.='+Copy(Retorno,22,14));
                Writeln(t1,'TABELA='+Copy(Retorno,36,3)+' I='+Copy(Retorno,39,14)+' F='+Copy(Retorno,53,14)+' N='+Copy(Retorno,67,14)+' C='+Copy(Retorno,81,14)+' D='+Copy(Retorno,95,14));
              end
             else
              if Copy(Retorno,1,1) = '5' then // vendas 2.Parte
               begin
                 Writeln(t1,'T1='+Copy(Retorno,2,14)+' T2='+Copy(Retorno,16,14)+' T3='+Copy(Retorno,30,14)+' T4='+Copy(Retorno,54,14)+' T5='+Copy(Retorno,68,14)+' T6='+Copy(Retorno,82,14)+' T7='+Copy(Retorno,96,14)+' T8='+Copy(Retorno,110,14));
                 Writeln(t1,'T9='+Copy(Retorno,124,14)+' T10='+Copy(Retorno,138,14)+' T11='+Copy(Retorno,152,14)+' T12='+Copy(Retorno,166,14)+' T13='+Copy(Retorno,180,14)+' T14='+Copy(Retorno,194,14)+' T15='+Copy(Retorno,208,14)+' T16='+Copy(Retorno,222,14));
               end
              else
               if Copy(Retorno,1,1) = '6' then // situação tributária
               begin
                  Writeln(t1,'A1='+Copy(Retorno,2,5)+' A2='+Copy(Retorno,7,5)+' A3='+Copy(Retorno,12,5)+' A4='+Copy(Retorno,17,5)+' A5='+Copy(Retorno,22,5)+' A6='+Copy(Retorno,27,5)+' A7='+Copy(Retorno,32,5)+' A8='+Copy(Retorno,37,5));
                  Writeln(t1,'A9='+Copy(Retorno,42,5)+' A10='+Copy(Retorno,47,5)+' A11='+Copy(Retorno,52,5)+' A12='+Copy(Retorno,57,5)+' A13='+Copy(Retorno,62,5)+' A14='+Copy(Retorno,67,5)+' A15='+Copy(Retorno,72,5)+' A16='+Copy(Retorno,77,5));
               end;
          Retorno:=_ecf09_Envia('661',15);// próximo registro
        end;
      end;
      closefile(t1);
      closefile(t);

      Stream1:=TFileStream.Create(Form1.sAtual+'\MEMFIS.TXT',fmOpenRead);
      Stream2:=TFileStream.Create(pP1,fmOpenWrite or fmCreate);
      Stream2.CopyFrom(Stream1, Stream1.Size);
      Stream2.Seek(0,0);
      Stream2.seek(Stream2.size, soFromBeginning);
      Stream1.Free;
      Stream1:=TFileStream.Create(Form1.sAtual+'\MEMFIS.TMP',fmOpenRead);
      if Stream2.CopyFrom(Stream1, Stream1.Size) > 0 then  Result:= True  else Result:= False;
      Stream1.Free;
      Stream2.Free;
      DeleteFile(Form1.sAtual+'\MEMFIS.TMP');
      DeleteFile(Form1.sAtual+'\MEMFIS.TXT');
    end
  else
    begin
      // fecha a porta serial
      _ecf09_FechaPortaDeComunicacao(true);
      // executa o programa da General
      shellexecute(0,'Open','LerMF.bat','','',SW_SHOW);
      // reabre a porta
      while not FileExists(Form1.sAtual+'\MFGEN.TXT') do
      begin
         sleep(1000);
      end;

      if FileExists(Form1.sAtual+'\MFGEN.TXT') then
        begin
          Stream1:=TFileStream.Create(Form1.sAtual+'\MF.TXT',fmOpenRead);
          Stream2:=TFileStream.Create(pP1,fmOpenWrite or fmCreate);
          if Stream2.CopyFrom(Stream1, Stream1.Size) > 0 then  Result:= True  else Result:= False;
          Stream1.Free;
          Stream2.Free;
          DeleteFile(Form1.sAtual+'\MF.TXT');
          DeleteFile(Form1.sAtual+'\MFGEN.TXT');
        end
      else
        Result:=False;
      showmessage('O sistema vai reconectar a impressora');
      _ecf09_inicializa(Form1.sPorta);
    end;
end;


// -------------------------------- //
// Venda do Item                    //
// -------------------------------- //
Function _ecf09_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean; //
        // pP1 REFERENCIA Código
        // pP2 copy(sDescricao,1,29)
        // pP3 ST
        // pP4 StrZero(ibDataSet27QUANTIDADE.AsFloat*1000,7,0)
        // pP5 StrZero(ibDataSet27UNITARIO.AsFloat*StrToInt('1'+Replicate('0',StrToInt(Form1.ConfPreco))),7,0),
        // pP6 Copy(ibDataSet4.FieldByname('MEDIDA').AsString,1,2));
var
  Retorno:string;
  sCasasDecimais:string[1];
begin
  Retorno:='';
{  showmessage(pp1+' - '+inttostr(length(pP1))+chr(10)+
              pp2+' - '+inttostr(length(pP2))+chr(10)+
              pp3+' - '+inttostr(length(pP3))+chr(10)+
              pp4+' - '+inttostr(length(pP4))+chr(10)+
              pp5+' - '+inttostr(length(pP5))+chr(10)+
              pp6+' - '+inttostr(length(pP6))+chr(10));}

  {if pP3 = 'II' then pP3:='17';
  if pP3 = 'FF' then pP3:='18';
  if pP3 = 'NN' then pP3:='19';}

  if Copy(pP3,1,2)='IS' then
   begin
     pP3:=Copy(pP3,3,2);
   end
  else
    if pP3='II' then
       pP3:= '17'
    else
      if pP3='FF' then
        pP3:= '18'
      else
        if pP3='NN' then
           pP3:= '19';


  case StrToInt(Form1.ConfPreco) of
   2: sCasasDecimais:='2';
   3: sCasasDecimais:='3';
  else
     sCasasDecimais:='0';
  end;
  if sCasasDecimais = '0' then
   begin
     Showmessage('Esta impressora só aceita 2 ou 3 casas decimais.'+chr(10)+
                 'configure o número de casas decimais no sistema '+chr(10)+
                 'Small Commerce.');
     Result:=False;
   end
  else
   begin
     Retorno:=_ecf09_Envia('21'+pP1+Copy(pP2+Replicate(' ',28),1,28)+pP4+'0'+pP5+sCasasDecimais+StrZero(
              ( ((StrToFloat(pP4)/1000) * (StrToFloat(pP5)/StrToFloat('1'+Replicate('0',StrToInt(sCasasDecimais))))))*StrToFloat('1'+Replicate('0',StrToInt(sCasasDecimais)))
              ,12,0)+pP3,15);
     //
     if Copy(Retorno,1,4)<> 'ERRO' then
        Result:=True
     else
       Result:=False;
   end;

  if Result then
  begin
    if pP7<>'0000000' then //desconto em percentual
     begin
       Retorno:=_ecf09_Envia('26'+'1'+Right(pP7,4)+'000000000000',15);
       if Copy(Retorno,1,4)<> 'ERRO' then
          Result:=True
       else
          Result:=False;
     end
    else
      if pP8<>'0000000' then //desconto em valor
      begin
        Retorno:=_ecf09_Envia('26'+'2'+'0000'+'00000'+pP8,15);
        if Copy(Retorno,1,4)<> 'ERRO' then
          Result:=True
        else
          Result:=False;
      end;
  end;


end;

// -------------------------------- //
// Reducao Z                        //
// -------------------------------- //
Function _ecf09_ReducaoZ(pP1: Boolean):Boolean; //
var
  Retorno:String;
begin
   Retorno:=_ecf09_Envia('520',75);
   if Copy(Retorno,1,4)<> 'ERRO' then
      Result:=True
   else
      Result:=False;
end;

// -------------------------------- //
// Leitura X                        //
// -------------------------------- //
Function _ecf09_LeituraX(pP1: Boolean):Boolean; //
var
  Retorno:String;
begin
   Retorno:=_ecf09_Envia('510',75);
   if Copy(Retorno,1,4)<> 'ERRO' then
      Result:=True
   else
      Result:=False;
end;

// ---------------------------------------------- //
// Retorna se o horario de verão está selecionado //
// ---------------------------------------------- //
Function _ecf09_RetornaVerao(pP1: Boolean):Boolean;     //
begin
   Result:=False;
end;

// -------------------------------- //
// Liga ou desliga horário de verao //
// -------------------------------- //
Function _ecf09_LigaDesLigaVerao(pP1: Boolean):Boolean; //
var
  Retorno:String;
begin
  Result := False;
  Retorno:=_ecf09_Envia('71',25);
  if Copy(Retorno,1,4)<> 'ERRO' then Result:=True;
  if not Result then showmessage('Para utilizar esta função, o cupom deve estar finalizado'+chr(10)+
                                 'e após redução Z.');
end;

// -------------------------------- //
// Retorna a versão do firmware     //
// -------------------------------- //
Function _ecf09_VersodoFirmware(pP1: Boolean): String; //OK
var
  Retorno:String;
begin
  Result:='ERRO';
  Retorno:=_ecf09_Envia('660',15);
  if _ecf09_CodeErro(Retorno)=0  then
  begin
     if Copy(Retorno,1,1) = '1' then // cabeçalho
        Result:=Copy(Retorno,56,4);
  end;
end;

// -------------------------------- //
// Retorna o número de série        //
// -------------------------------- //
Function _ecf09_NmerodeSrie(pP1: Boolean): String;//OK
var
  Retorno:String;
begin
   Retorno:=_ecf09_Envia('64',15);
   if _ecf09_CodeErro(Retorno)=0 then
      Result:=Copy(Retorno,27,8)
   else
      Result:='0000';
end;

// -------------------------------- //
// Retorna o CGC e IE               //
// -------------------------------- //
Function _ecf09_CGCIE(pP1: Boolean): String;//OK
var
  Retorno:String;
begin
   Retorno:=_ecf09_Envia('64',15);
   if _ecf09_CodeErro(Retorno)=0 then
      Result:='CNPJ '+Copy(Retorno,35,18)+' IE '+Copy(Retorno,53,18)
   else
      Result:='0000';
end;

// --------------------------------- //
// Retorna o valor  de cancelamentos //
// --------------------------------- //
Function _ecf09_Cancelamentos(pP1: Boolean): String; //
var
  Retorno:String;
begin
   Retorno:=_ecf09_Envia('6704',15);
   if _ecf09_CodeErro(Retorno)=0 then Result:=Copy(Retorno,3,StrToInt(Copy(Retorno,1,2))) else Result:='0000';
end;


// -------------------------------- //
// Retorna o valor de descontos     //
// -------------------------------- //
Function _ecf09_Descontos(pP1: Boolean): String; //
var
  Retorno:String;
begin
   Retorno:=_ecf09_Envia('6705',15);
   if _ecf09_CodeErro(Retorno)=0 then Result:=Copy(Retorno,3,StrToInt(Copy(Retorno,1,2))) else Result:='0000';
end;

// -------------------------------- //
// Retorna o contador sequencial    //
// -------------------------------- //
Function _ecf09_ContadorSeqencial(pP1: Boolean): String; //
var
  Retorno:String;
begin
   Retorno:=_ecf09_Envia('6776',15);
   if _ecf09_CodeErro(Retorno)=0 then Result:=Copy(Retorno,3,StrToInt(Copy(Retorno,1,2))) else Result:='0000';
end;

// -------------------------------- //
// Retorna o número de operações    //
// não fiscais acumuladas           //
// -------------------------------- //
Function _ecf09_Nmdeoperaesnofiscais(pP1: Boolean): String;
var
  Retorno:String;
begin
   Retorno:=_ecf09_Envia('6777',15);
   if _ecf09_CodeErro(Retorno)=0 then Result:=Copy(Retorno,3,StrToInt(Copy(Retorno,1,2))) else Result:='0000';
end;

Function _ecf09_NmdeCuponscancelados(pP1: Boolean): String;//OK
var
  Retorno:String;
begin
   Retorno:=_ecf09_Envia('6781',15);
   if _ecf09_CodeErro(Retorno)=0 then Result:=Copy(Retorno,3,StrToInt(Copy(Retorno,1,2))) else Result:='0000';
end;

Function _ecf09_NmdeRedues(pP1: Boolean): String;//OK
var
  Retorno:String;
begin
   Retorno:=_ecf09_Envia('6778',15);
   if _ecf09_CodeErro(Retorno)=0 then Result:=Copy(Retorno,3,StrToInt(Copy(Retorno,1,2))) else Result:='0000';
   Result:=StrZero(StrToInt(Result)+1,6,0);
end;

Function _ecf09_Nmdeintervenestcnicas(pP1: Boolean): String;
var
  Retorno:String;
begin
   Retorno:=_ecf09_Envia('6780',15);
   if _ecf09_CodeErro(Retorno)=0 then Result:=Copy(Retorno,3,StrToInt(Copy(Retorno,1,2))) else Result:='0000';
end;

Function _ecf09_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
begin
  Result := 'Operação não suportada';
//  _ecf09_ImpressaoNaoSujeitoaoICMS('Rogerio Paulo Girotto'+chr(10)+'Estou Testando o relatorio nao gerencial');
end;

Function _ecf09_Clichdoproprietrio(pP1: Boolean): String;
begin
  Result := 'Operação não suportada';
end;

Function _ecf09_NmdoCaixa(pP1: Boolean): String;//OK
begin
  Result:=Copy(_ecf09_envia('64',15),97,3);
end;

Function _ecf09_Nmdaloja(pP1: Boolean): String; //OK
begin
  Result:=Copy(_ecf09_envia('64',15),93,3);
end;

Function _ecf09_Moeda(pP1: Boolean): String; // OK
begin
  Result:=Copy(_ecf09_envia('64',15),89,1);
end;

Function _ecf09_Dataehoradaimpressora(pP1: Boolean): String; // OK
begin
   Result:=Copy(_ecf09_envia('64',15),1,12)+'00';
   Delete(Result,5,2);
end;

Function _ecf09_Datadaultimareduo(pP1: Boolean): String; //ver
begin
  Result := 'Operação não suportada';
end;

Function _ecf09_Datadomovimento(pP1: Boolean): String; //ver
begin
  Result := 'Operação não suportada';
end;

Function _ecf09_Tipodaimpressora(pP1: Boolean): String; //Modelo
var
  Retorno:String;
begin
  Result:='ERRO';
  Retorno:=_ecf09_Envia('660',15);
  if _ecf09_CodeErro(Retorno)=0  then
  begin
     if Copy(Retorno,1,1) = '1' then // cabeçalho
        Result:=Copy(Retorno,41,15);
  end;
end;

Function _ecf09_RetornaAliquotas(pP1: Boolean): String; //OK
var
  i:integer;
  sRetorno,sICM,sISS:string;
begin
  sRetorno:=_ecf09_Envia('60',15);//Leitura dos parametros
  sRetorno:=Copy(sRetorno,1,80);//Leitura dos parametros
  sICM:='';sISS:='';
  i:=1;
  while i <=80 do
  begin
    if Copy(sRetorno,i,1)='S' then
     begin
       sISS:=sISS+Copy(sRetorno,i+1,4);
       sICM:=sICM+'0000';
     end
    else
     begin
       sISS:=sISS+'0000';
       sICM:=sICM+Right('0000'+AllTrim(Copy(sRetorno,i+1,4)),4);
     end;
    i:=i+5;
  end;
  Result:='16'+sICM+sISS; //só para fechar 16 alíquotas
end;

Function _ecf09_Vincula(pP1: String): Boolean;
begin
{  if _ecf09_CodeErro(FormataTX(Chr(27)+'|38|'+pP1+'|'+Chr(27))) = 0
  then Result := True else Result := False;}
  Result:=false;
end;


Function _ecf09_FlagsDeISS(pP1: Boolean): String;
  // ------------------------------------------ //
  // Flags de Vinculação ao ISS                 //
  // (Cada “bit” corresponde a                  //
  // um totalizador.                            //
  // Um “bit” setado indica vinculação ao ISS)  //
  // ------------------------------------------ //
var
  i:integer;
  sTemp:String;
begin
  Result:=_ecf09_Envia('60',15);
  sTemp:='';
  if _ecf09_CodeErro(Result)=0  then
    begin
      for i:=0 to 16 do
      begin
        if UpperCase(Copy(Result,((i*5)+1),1))= 'S' then
          sTemp:=sTemp+'1' else sTemp:=sTemp+'0';
      end;
      Result:=chr(BinToInt(Copy(sTemp,1,8)))+chr(BinToInt(Copy(sTemp,9,8)));
    end
   else
     Result:=chr(BinToInt('00000000'))+chr(BinToInt('00000000'));
end;

Function _ecf09_FechaPortaDeComunicacao(pP1: Boolean): Boolean; //
begin
  _ecf09_FechaPorta();
  Result := True;
end;

Function _ecf09_MudaMoeda(pP1: String): Boolean;//ver
begin
  // somente em intervenção
  Result := False;
end;

Function _ecf09_MostraDisplay(pP1:String):Boolean;
 // Parâmetros:   texto
begin
   Result:=True;
end;


Function _ecf09_FechaPorta:integer;
begin
  CloseFujitsu;
  Result:=0;
end;

function _ecf09_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean; //iP2 = Número do Cupom vinculado
var
  I,J : Integer;
  Retorno, sX: String;
begin
  //
  //  ShowMessage(IntToStr(Length(sP1)));
//  ShowMessage(sP1);
  //
{  if EstadoImpressora()=126 then //Relatório Gerencial
  begin
     StrCopy(@s1,'        ');
     FinalizaRelatorio(@s1);
  end;}

  Result := True;
  if 1 <> 0 then
   begin
      // Comando Para Abrir Comprovante Não Fiscal Vinculado
      Retorno:=_ecf09_Envia('201',25);//primeira via do comprovante não fiscal vinculado
//      if Retorno='ERRO:64' then
//      showmessage('Esta forma de pagamento deve ser cadastrada como TEF '+chr(10)+
//                 '(Cupom não fiscal vinculado), através de intervenção técnica.');
      if Retorno <> '00' then //(_ecf09_CodeErro(Retorno) <> 0)  then
      begin
        Result := False;
      end;
      if Result then
      begin
        for J := 1 to 1 do
        begin
          //imprime 7 linhas em branco
          if Result = True then
          begin
            I:=0;
            while  (I<7) and (Result) do
            begin
              Retorno:=_ecf09_Envia('420'+Replicate(' ' ,42),15);//linhas em branco
              if Retorno <> '00' then Result:=False;
              I:=I+1;
            end;
          end;
          //
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
                     Retorno:=_ecf09_Envia('420'+Copy(sX+Replicate(' ' ,42),1,42),15);//linha
                     if Retorno <> '00' then Result:= false;//if (_ecf09_CodeErro(Retorno) <> 0)  then Result:=False;
                     sX:='';
                   end
                  else
                   begin
                     Retorno:=_ecf09_Envia('420'+Replicate(' ' ,42),15);//linha em branco
                     if Retorno <> '00' then Result:= false;//if (_ecf09_CodeErro(Retorno) <> 0)  then Result:=False;
                     sX:='';
                   end;
                end;
            end;
          end;
          if AllTrim(sX) <> '' then
          begin
             //imprime a linha
             Retorno:=_ecf09_Envia('420'+Copy(sX+Replicate(' ' ,42),1,42),15);//linha
             if Retorno <> '00' then Result:=false;//if (_ecf09_CodeErro(Retorno) <> 0)  then Result:=False;
             sX:='';
          end;
          //avança 7 linhas
          if Result = True then
          begin
            I:=0;
            while  (I<7) and (Result) do
            begin
              Retorno:=_ecf09_Envia('420'+Replicate(' ' ,42),15);//linhas em branco
              if Retorno <> '00' then Result:=false;//if (_ecf09_CodeErro(Retorno) <> 0)  then Result:=False;
              I:=I+1;
            end;
          end;
          if Result = True then sleep(2500); // Da um tempo
        end;//for
      end;//if result
      Retorno:=_ecf09_Envia('43', 25); //fecha o comprovante não fiscal
      if Retorno <> '00' then Result:=false;//if (_ecf09_CodeErro(Retorno) <> 0)  then Result:=False;
   end
  else
    Result:=True;
end;

function _ecf09_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
var
  I,J : Integer;
  Retorno, sX: String;
begin
  //
  //  ShowMessage(IntToStr(Length(sP1)));
//  ShowMessage(sP1);
  //
{  if EstadoImpressora()=126 then //Relatório Gerencial
  begin
     StrCopy(@s1,'        ');
     FinalizaRelatorio(@s1);
  end;}

  // verifica o estado da impressora
//  Retorno:=_ecf09_Envia('641',15);

  Result := True;
  if 1 <> 0 then
   begin
    Retorno:=_ecf09_Envia('511', 75);//leitura X com relatório gerencial
    if Retorno <> '00' then Result:=false;//if (_ecf09_CodeErro(Retorno) <> 0)  then Result:=False;
    // verifica o estado da impressora
  //  Retorno:=_ecf09_Envia('641',15);
    if Result then
    begin
      for J := 1 to 1 do
      begin
        //avança 7 linhas
        if Result = True then
        begin
          I:=0;
          while  (I<7) and (Result) do
          begin
            Retorno:=_ecf09_Envia('570'+Replicate(' ' ,42),15);//linhas em branco
            if Retorno <> '00' then Result:=false;//if (_ecf09_CodeErro(Retorno) <> 0)  then Result:=False;
            I:=I+1;
          end;
        end;

        if Result = True then
        begin
          sX:='';
      //    showmessage(sP1);
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
                     Retorno:=_ecf09_Envia('570'+Copy(sX+Replicate(' ' ,42),1,42),15);//linha
                     if Retorno <> '00' then Result:=false;//if (_ecf09_CodeErro(Retorno) <> 0)  then Result:=False;
                     sX:='';
                   end
                  else
                   begin
                     Retorno:=_ecf09_Envia('570'+Replicate(' ' ,42),15);//linha em branco
                     if Retorno <> '00' then Result:=false;//if (_ecf09_CodeErro(Retorno) <> 0)  then Result:=False;
                     sX:='';
                   end;
                end;
            end;
          end;
        end;
        if Result = True then
        begin
          if AllTrim(sX) <> '' then
          begin
             //imprime a linha
             Retorno:=_ecf09_Envia('570'+Copy(sX+Replicate(' ' ,42),1,42),15);//linha
             if Retorno <> '00' then Result:=false;//if (_ecf09_CodeErro(Retorno) <> 0)  then Result:=False;
             sX:='';
          end;
        end;
        //avança 7 linhas
        if Result = True then
        begin
          I:=0;
          while  (I<7) and (Result) do
          begin
            Retorno:=_ecf09_Envia('570'+Replicate(' ' ,42),15);//linhas em branco
            if Retorno <> '00' then Result:=false;//if (_ecf09_CodeErro(Retorno) <> 0)  then Result:=False;
            I:=I+1;
          end;
        end;
        if Result = True then sleep(2500); // Da um tempo;
      end;//for
    end;//if result
    //

    Retorno:=_ecf09_Envia('56',25); //fecha o relatorio
    if Retorno <> '00' then Result:=false;//if (_ecf09_CodeErro(Retorno) <> 0)  then Result:=False;
   end
  else
    Result:=True;
end;

function _ecf09_FechaCupom2(sP1: Boolean): Boolean;
var
   Retorno:String;
begin
  Result:=False;
  Retorno:='';
  Retorno:=_ecf09_Envia('43',25);//fecha comprov. nào fiscal vinculado
  if Retorno='00'  then
  begin
     Result:=True;
     Retorno:=_ecf09_Envia('4405',15); //avança 5 linhas
  end;
end;

function _ecf09_ImprimeCheque(rP1: Real; sP2: String): Boolean;
begin
  Result:=False;
end;

function _ecf09_GrandeTotal(sP1: Boolean): String;
var
  Retorno:String;
begin
  Result:='ERRO';
  Retorno:=_ecf09_Envia('651',15);
  if _ecf09_CodeErro(Retorno)=0  then
  begin
//      showmessage(Retorno);
      Result:=Copy(Retorno,31,16);
//      showmessage(Result);
  end;
end;

function _ecf09_TotalizadoresDasAliquotas(sP1: Boolean): String;
var
  Retorno:String;
begin
  Result:='ERRO';
  Retorno:=_ecf09_Envia('656',15);
  if _ecf09_CodeErro(Retorno)=0  then
  begin
      Result:=Retorno;
  end;
  Retorno:=_ecf09_Envia('657',15);
  if _ecf09_CodeErro(Retorno)=0  then
  begin
      //        isento             não incidência    Substituição
      Result:=Result+Copy(Retorno,1,14)+Copy(Retorno,29,14)+Copy(Retorno,15,14);
  end;
end;


function _ecf09_CupomAberto(sP1: Boolean): boolean;
var
  Retorno:string;
begin
  Result:=False;
  // verifica o estado da impressora
  Retorno:=_ecf09_Envia('641',15);
//  if (Right(Retorno,3) = '001') or (Right(Retorno,3) = '010') then // cupom já aberto ou em posição de venda
//  if (Right(Retorno,3) = '000') then // cupom fechado
//     Result:=False;
  if (Right(Retorno,3) = '001') or (Right(Retorno,3) = '010') then // cupom já aberto ou em posição de venda
     Result:=True;
end;

{
var
  sTempo:string;
begin
   sTempo:=_ecf09_TXRX('28');
//   showmessage(stempo);
   if ((Copy(sTempo,11,8) = ' VENDAS ') and (Copy(sTempo,10,1)='E')) then
      if (Copy(_ecf09_TXRX('05'),1,1)='.') then //cancela cupom atual
         _ecf09_TXRX('0897');//avança 7 linhas

   Result:=((Copy(sTempo,11,8) = ' VENDAS ') and (Copy(sTempo,10,1)='P'));
end;
}

function _ecf09_FaltaPagamento(sP1: Boolean): boolean;
var
  Retorno:string;
begin
  Result:=False;
  // verifica o estado da impressora
  Retorno:=_ecf09_Envia('641',15);
  if (Right(Retorno,3) = '011') or (Right(Retorno,3) = '100') then // Finalizando a Totalização
     Result:=True;
end;


function _ecf09_Envia(sComando:String; iTimeOut:Integer):String;
var
   p:PChar;
   ret : array[0..256] of char;
   status1 : array[0..1] of char;
   Status2 : array[0..1] of char;
   retBit : array[0..9] of char;
   aCom: array[0..10] of char;
   iRet, iRetTx : Integer;
   bAnalisa:Boolean;
begin
    Result:='';
    if sComando='641' then
     begin
       sComando:='64';
       bAnalisa:=True;
     end
    else
       bAnalisa:=False;
    p := pchar(sComando);
    iRetTx := TxFujitsu(p);
    if iRetTx = 0 then // impressora não conectada ou desligada
    begin
       CloseFujitsu;
       if sComando <> '64' then
         sleep(5000);//         Showmessage(' A Impressora está desligada ou desconectada.'+chr(10)+                     ' O sistema vai tentar enviar o comando novamente');
       StrPCopy(@aCom,'COM'+Right(Form1.sPorta,1));
       OpenFujitsu( @aCom );
       iRetTx := TxFujitsu(p);
    end;
    if iRetTx > 0 then
     begin
      iRet := RxFujitsu(@ret, @status1,@status2, iTimeOut);
//      if iRet<0 then showmessage('Resposta não entendida');
//      if iRet=0 then showmessage('Dados incorretos no pacote de dados');
//      if iRet>0 then showmessage('Comando executado com sucesso.');

      if (iRet > 0) and (ord(status2[0]) = 255) then
       begin
         result := strPas( @ret );
         if (copy(Result,1,2)=Copy(sComando,1,2)) then Delete(Result,1,2);
         // comandos sem retorno
         if (Copy(sComando,1,2)='22') or (Copy(sComando,1,2)='23') or (Copy(sComando,1,2)='2C')
            or (Copy(sComando,1,2)='29') or (Copy(sComando,1,2)='45') then Result:='';
       end
      else
       begin
         if ord(status2[0]) > 0 then
            Result:='ERRO:'+IntToStr(ord(status2[0]))
         else
            result:='ERRO:161';//+IntToStr(ord(status2[0]));
       end;

      if bAnalisa then // se for o comando 64 com param 1 analisa o estado da impressora
      begin
         AnalisaByte(@status1,@retBit);
//      if StrPas(retBit) =  then //OK
         Result:=retbit;
//         showmessage('estado da impressora:='+retbit);
      end;
     end
    else
     begin
        result:='ERRO:161';//+IntToStr(ord(status2[0]));
        if sComando='61' then showmessage(inttostr(iRetTx));
     end;
    if Alltrim(Result)='' then Result:='00';
end;



end.








