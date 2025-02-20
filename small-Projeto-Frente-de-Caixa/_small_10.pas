unit _Small_10;

interface

uses
  Windows, Messages, SmallFunc, Fiscal, SysUtils,Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Mask, Grids, DBGrids, DB, DBCtrls, SMALL_DBEdit, IniFiles, Unit2,
  Unit7, unit22;

  //--------------------------------------------------------------------------//
  // Módulo para Impressora Sweda 7000I                                       //
  //                                                                          //
  // 15/02/2002 Gaveta                                                        //
  // 08/01/03 : Cupom vinculado op. a prazo                                   //
  // 12/03/03 : n. de vias do cupom vinc.                                     //
  // 15/04/03 : TEF                                                           //
  // 05/10/04 : Versão 2004                                                   //
  // 24/11/04 : Aliquota de ISS não estava sendo registrada                   //
  // 10/12/04 : Versão 2005                                                   //
  //--------------------------------------------------------------------------//

    Function ECFOpen(Porta,Timeout,log,showErro:Integer):Integer; Stdcall; external 'SWECF.dll';// index 1;
    Function ECFWrite(Comando:PChar):Integer; Stdcall; external 'SWECF.dll';// index 2;
    Function ECFRead(Status:PChar;Ext:integer):Integer; Stdcall; external 'SWECF.dll';// index 3;
    Function ECFClose:Integer; Stdcall; external 'SWECF.dll';// index 4;
//     function TXRX(Porta: Integer; Tempo:Integer; Comando:String): Integer; stdcall; external 'SWECF.DLL' name 'TXRX';
     //
     function _ECF10_TXRX(pComando:String):string;
     function _ECF10_CodeErro(Pp1: String):string;
     function _ECF10_Inicializa(Pp1: String):Boolean;
     function _ECF10_FechaCupom(Pp1: Boolean):Boolean;
     function _ECF10_Pagamento(Pp1: Boolean):Boolean;
     function _ECF10_CancelaUltimoItem(Pp1: Boolean):Boolean;
     function _ECF10_SubTotal(Pp1: Boolean):Real;
     function _ECF10_AbreGaveta(Pp1: Boolean):Boolean;
     function _ECF10_Sangria(Pp1: Real):Boolean;
     function _ECF10_Suprimento(Pp1: Real):Boolean;
     function _ECF10_NovaAliquota(Pp1: String):Boolean;
     function _ECF10_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
     function _ECF10_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
     function _ECF10_CancelaUltimoCupom(Pp1: Boolean):Boolean;
     function _ECF10_AbreNovoCupom(Pp1: Boolean):Boolean;
     function _ECF10_NumeroDoCupom(Pp1: Boolean):String;
     function _ECF10_CancelaItemN(pP1, pP2: String):Boolean;
     function _ECF10_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
     function _ECF10_ReducaoZ(pP1: Boolean):Boolean;
     function _ECF10_LeituraX(pP1: Boolean):Boolean;
     function _ECF10_RetornaVerao(pP1: Boolean):Boolean;
     function _ECF10_LigaDesLigaVerao(pP1: Boolean):Boolean;
     function _ECF10_VersodoFirmware(pP1: Boolean): String;
     function _ECF10_NmerodeSrie(pP1: Boolean): String;
     function _ECF10_CGCIE(pP1: Boolean): String;
     function _ECF10_Cancelamentos(pP1: Boolean): String;
     function _ECF10_Descontos(pP1: Boolean): String;
     function _ECF10_ContadorSeqencial(pP1: Boolean): String;
     function _ECF10_Nmdeoperaesnofiscais(pP1: Boolean): String;
     function _ECF10_NmdeCuponscancelados(pP1: Boolean): String;
     function _ECF10_NmdeRedues(pP1: Boolean): String;
     function _ECF10_Nmdeintervenestcnicas(pP1: Boolean): String;
     function _ECF10_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
     function _ECF10_Clichdoproprietrio(pP1: Boolean): String;
     function _ECF10_NmdoCaixa(pP1: Boolean): String;
     function _ECF10_Nmdaloja(pP1: Boolean): String;
     function _ECF10_Moeda(pP1: Boolean): String;
     function _ECF10_Dataehoradaimpressora(pP1: Boolean): String;
     function _ECF10_Datadaultimareduo(pP1: Boolean): String;
     function _ECF10_Datadomovimento(pP1: Boolean): String;
     function _ECF10_Tipodaimpressora(pP1: Boolean): String;
     function _ECF10_StatusGaveta(Pp1: Boolean):String;
     function _ECF10_RetornaAliquotas(pP1: Boolean): String;
     function _ECF10_Vincula(pP1: String): Boolean;
     function _ECF10_FlagsDeISS(pP1: Boolean): String;
     function _ECF10_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
     function _ECF10_MudaMoeda(pP1: String): Boolean;
     function _ECF10_MostraDisplay(pP1: String): Boolean;
     function _ECF10_leituraMemoriaFiscalEmDisco(pP1,pP2,pP3: String): Boolean;
     function _ECF10_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean; //iP2 = Número do Cupom vinculado
     function _ECF10_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
     function _ECF10_FechaCupom2(sP1: Boolean): Boolean;
     function _ECF10_ImprimeCheque(rP1: Real; sP2: String): Boolean;
     function _ECF10_GrandeTotal(sP1: Boolean): String;
     function _ECF10_TotalizadoresDasAliquotas(sP1: Boolean): String;
     function _ECF10_CupomAberto(sP1: Boolean): boolean;
     function _ECF10_FaltaPagamento(sP1: Boolean): boolean;

implementation


Function _ECF10_CodeErro(pP1: String):String; //
var
  vErro    : array [0..99] of String;  // Cria uma matriz com  100 elementos
  I        : Integer;
begin
  //
  for I := 0 to 99 do vErro[I] := 'Comando não executado.';

  // Verificar se falta papel, e no sugerir uma leitura X
  //
  Form1.Panel2.Visible := False;
  //
  if pP1 = 'PAPEL ACABANDO' then
  begin
    if Form1.Memo3.Visible then
    begin
      Form1.Panel2.Visible := True;
      Form1.Panel2.BringToFront;
    end;
  end;


  vErro[00] := 'Sem erro';
  vErro[06] := 'O valor informado no comando não pode ser 0';
//  vErro[07] := 'Problemas de comunicação';
  vErro[99] := 'Falha de comunicação '+chr(10)+chr(10)+
               'Sugestão: verifique as conexões,'+chr(10)+
               'ligue e desligue a impressora. '+chr(10)+chr(10)+
               'O Sistema será Finalizado.';

  if pP1 = '7' then pP1:='99';
  if pP1 = '99' then
     Application.MessageBox(Pchar('ERRO n.'+pP1+'-'+vErro[StrToInt(pP1)]),'Atenção',mb_Ok + mb_DefButton1)
  else
     if Pos('ERRO',pP1) > 0 then
        Application.MessageBox(Pchar(pP1),'Atenção',mb_Ok + mb_DefButton1);

  Result:=pP1;
  if pP1 = '99' then Halt(1);
end;

Function _ECF10_EsperaLiberarECF(iTentativas:Integer; pComando:String):Boolean;
var
  I:Integer;
  Comando: array[0..512] of Char;
  Resp:array[0..512] of Char;
  bPrimeiraVez:Boolean;
  //
begin
  bPrimeiraVez:=True;
  Result:=False;
  for I:=1 to iTentativas do
  begin
    StrPCopy(Comando,chr(27)+'.23}');
    //
    if ECFWrite(Comando) <> 0 then
     begin
       ECFRead(Resp,512);
{            Form1.Label12.left:=40;
            Form1.Label12.Caption:='23-->'+StrPas(Resp);
            Form1.Repaint;}
       if Copy(StrPas(Resp),1,6)='.-P006' then //.-P006 imprimindo
          Sleep(1000)
       else
         if Copy(StrPas(Resp),1,6)='.-P002' then //.-P002 time out de impressão
           Break;
     end
    else
     begin
       ECFRead(Resp,512);
{       Form1.Label12.left:=40;
       Form1.Label12.Caption:=pComando+'-->'+StrPas(Resp);
       Form1.Repaint;}
       // se o status for "Impressora tem papel" ou "Papel Acabando"
       if (Copy(StrPas(Resp),6,1)='0') or (Copy(StrPas(Resp),6,1)='5') then
        begin
          StrPCopy(Comando,chr(27)+'.28}');
          if ECFWrite(Comando) = 0 then
          begin
            ECFRead(Resp,512);
            //showmessage(StrPas(Resp));
{            Form1.Label12.left:=40;
            Form1.Label12.Caption:=StrPas(Resp);
            Form1.Repaint;}
            if ((Copy(StrPas(Resp),1,6)<>'.-P006') and (pComando='08'))  or ((Copy(StrPas(Resp),1,6)<>'.-P006') and (Copy(StrPas(Resp),10,1)='C')) then //(Copy(StrPas(Resp),1,5)='.+000') or
            begin
              Result:=True;
              break;
            end;
          end;
        end
       else
        if (Copy(StrPas(Resp),4,3)='111') and (iTentativas >1) then //off-Line
         begin
            //se acontecer pela primeira vez, espera 2 segundos e tenta novamente
            if bPrimeiraVez then
             begin
               Sleep(2000);
               bPrimeiraVez:=False;
             end
            else
              break; //resulta falso
         end
        else
         begin
           Sleep(1000);
           //showmessage(StrPas(Resp));
         end;
     end;
  end;
end;

// Verifica se a forma de pagamento está cadastrada
function _ECF10_VerificaLegendaNaoFiscal(Legenda:String):String;//Sweda
var
  i,j:integer;
  sRetorno:String;
begin
   Result:='XX';
   sRetorno:=Copy(_ECF10_TXRX('297'),38,90)+Copy(_ECF10_TXRX('298'),8,120)+Copy(_ECF10_TXRX('299'),8,120)+
             Copy(_ECF10_TXRX('29A'),8,120)+Copy(_ECF10_TXRX('29B'),8,120)+Copy(_ECF10_TXRX('29C'),8,120)+
             Copy(_ECF10_TXRX('29D'),8,60);
   j:=1;
   i:=1;
   while i < length(sRetorno) do
   begin
      if Result='XX' then // só entra se ainda não encontrou
         if Pos(UpperCase(Legenda),UpperCase(Copy(sRetorno,i,15)))>0 then Result:='0'+IntToStr(j);
      j:=j+1;
      i:=i+15;
   end;
end;

// Verifica se a forma de pagamento está cadastrada
function _ECF10_VerificaFormaPgtoECF(Forma:String):String;//Sweda OK
var
  i,j:integer;
  sRetorno:String;
begin
   Result:='XX';
   sRetorno:=Copy(_ECF10_TXRX('295'),36,47)+Copy(_ECF10_TXRX('296'),8,111);
   j:=1;
   i:=1;
   while i < length(sRetorno) do
   begin
      if Result='XX' then // só entra se ainda não encontrou
         if Pos(UpperCase(Forma),UpperCase(Copy(sRetorno,i,15)))>0 then Result:='0'+IntToStr(j);
      j:=j+1;
      i:=i+15;
   end;
end;

// ----------------------------//
// Detecta qual a porta que    //
// a impressora está conectada //
// --------------------------- //
function _ECF10_Inicializa(Pp1: String):Boolean;   // Sweda OK
var
  I,k : Integer;
  Retorno:string;
  Mais1ini : TiniFile;
  sPrazo, sDinheiro, sCheque, sCartao, sFormasExtras,sFormasNoECF: String;
  sFormaExtra: array[1..8] of string;
  bPrecisaProgramar:boolean;
  function _ECF10_LeAsFormasNoECF(bPar:Boolean):String;
  begin
    Result:=Copy(_ECF10_TXRX('295'),36,47)+Copy(_ECF10_TXRX('296'),8,111);
  end;
  // Verifica se a forma de pagamento está cadastrada
  function _ECF10_VerificaFormaPgto(Forma:String):String;//Sweda OK
  var
    i,j:integer;
  begin
     Result:='XX';
     //sRetorno:=Copy(_ECF10_TXRX('295'),36,47)+Copy(_ECF10_TXRX('296'),8,111);
     j:=1;
     i:=1;
     while i < length(sFormasNoECF) do
     begin
        if Result='XX' then // só entra se ainda não encontrou
           if Pos(UpperCase(Forma),UpperCase(Copy(sFormasNoECF,i,15)))>0 then Result:='0'+IntToStr(j);
        j:=j+1;
        i:=i+15;
     end;
  end;
begin
  Mais1ini  := TIniFile.Create('frente.ini');
  if ECFOpen(StrToInt(Right(pP1,1)),5,0,0)=0 then
     Retorno := _ECF10_TXRX('23I') // Status da impressora
  else
     Retorno :='ERRO';

  if Form22.Label6.Caption = 'Detectando porta de comunicação...' then
   begin
    // -------------------------------------------- //
    // Se o retorno for diferente de 0 ele entra no //
    // loop no entando não altera nada.             //
    // -------------------------------------------- //
    for I := 1 to 4 do
    begin
      // ------------------------------------------------ //
      // Se o retorno não for 0 testa as outras as portas //
      // até encontrar a impressora fiscal conectada.     //
      // ------------------------------------------------ //
      if Copy(Retorno,2,1) <> '+' then
      begin
        ECFClose();
        ShowMessage('Testando COM'+StrZero(I,1,0));
        Try
          if ECFOpen(I,5,0,0)=0 then
            Retorno := _ECF10_TXRX('23I') // Status da impressora
          else
             Retorno :='ERRO';
          Pp1     := 'COM'+StrZero(I,1,0);
          Form1.sPorta  := pP1;
        except end;
      end;
    end;
    if Copy(Retorno,1,1) = '.' then
      begin
         Result := True;
         //verifica as formas de pagamento e cadastra se não existirem
         sFormasNoECF:=_ECF10_LeAsFormasNoECF(True);
         // lê o arquivo frente.ini
         sDinheiro := Mais1Ini.ReadString('Frente de caixa','Dinheiro','XX');
         sCheque   := Mais1Ini.ReadString('Frente de caixa','Cheque','XX');
         sCartao   := Mais1Ini.ReadString('Frente de caixa','Cartao','XX');
         sPrazo    := Mais1Ini.ReadString('Frente de caixa','Prazo','XX');
         //
         if sPrazo='XX' then
         begin
           sPrazo    := Mais1Ini.ReadString('Frente de caixa','a Prazo','XX');
           Mais1Ini.WriteString('Frente de caixa','Prazo',sPrazo);
         end;
         For k:= 1 to 8 do
         begin
            if Mais1Ini.ReadString('Frente de caixa','Forma extra '+IntToStr(k),'') <> '' then
             begin
               sFormaExtra[k]:= Mais1Ini.ReadString('Frente de caixa','Ordem forma extra '+IntToStr(k),'XX');
               if sFormaExtra[k]='' then sFormaExtra[k]:='XX';
             end
            else
              sFormaExtra[k]:= '';
         end;

         //vefifica as formas de pagamento
         bPrecisaProgramar:=False;
         sFormasExtras:='';
         if (sDinheiro='XX') or (sDinheiro='') then
         begin
            sDinheiro:=_ECF10_VerificaFormaPgto('DINHEIRO');
            if sDinheiro = 'XX' then
              bPrecisaProgramar:=True // não encontrou seta a variável bPrecisaProgramar
            else
              Mais1Ini.WriteString('Frente de caixa','Dinheiro',sDinheiro);
         end;
         //
         if (sCheque='XX') or (sCheque='') then
         begin
            sCheque := _ECF10_VerificaFormaPgto('CHEQUE');
            if sCheque = 'XX' then
              bPrecisaProgramar:=True // não encontrou seta a variável bPrecisaProgramar
            else
              Mais1Ini.WriteString('Frente de caixa','Cheque',sCheque);
         end;
         //
         if (sCartao='XX') or (sCartao='') then
         begin
            sCartao := _ECF10_VerificaFormaPgto('CARTAO');
            if sCartao = 'XX' then
              bPrecisaProgramar:=True // não encontrou seta a variável bPrecisaProgramar
            else
              Mais1Ini.WriteString('Frente de caixa','Cartao',sCartao);
         end;
         //
         if (sPrazo='XX') or (sPrazo='') then
         begin
           sPrazo := _ECF10_VerificaFormaPgto('PRAZO');
           if sPrazo = 'XX' then
              bPrecisaProgramar:=True // não encontrou seta a variável bPrecisaProgramar
           else
             Mais1Ini.WriteString('Frente de caixa','Prazo',sPrazo);
         end;
         //
         //se as formas extras estão cadastradas, verifica
         //
         for k:=1 to 8 do
         begin
           if sFormaExtra[k]<>'' then
           begin
             sFormaExtra[k] := _ECF10_VerificaFormaPgto(UpperCase(Mais1Ini.ReadString('Frente de caixa','Forma extra '+inttostr(k),'')));
             if sFormaExtra[k] = 'XX' then //não está cadastrada na impressora
              begin
                bPrecisaProgramar:=True; // não encontrou seta a variável bPrecisaProgramar
              end
             else
               Mais1Ini.WriteString('Frente de caixa','Ordem forma extra '+inttostr(k),sFormaExtra[k]);
             sFormasExtras:=sFormasExtras+Copy(UpperCase(Mais1Ini.ReadString('Frente de caixa','Forma extra '+inttostr(k),''))+Replicate(' ',15),1,15)
           end;
           //
         end;
         if bPrecisaProgramar then
         begin
            _ECF10_TXRX('39DINHEIRO       CHEQUE         CARTAO         PRAZO          '+sFormasExtras);
//            _ECF10_TXRX('39DINHEIRO       CHEQUE         CARTAO         PRAZO          ');
            sFormasNoECF:=_ECF10_LeAsFormasNoECF(True);
         end;
         //
         //------------------------------------------------------------------------------------------//
         //                CHECA DE NOVO                                                             //
         //------------------------------------------------------------------------------------------//
         if sDinheiro='XX' then
         begin
            sDinheiro:=_ECF10_VerificaFormaPgto('DINHEIRO');
            if sDinheiro = 'XX' then
             begin
               ShowMessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           'DINHEIRO, o sistema poderá cadastrá-la logo após a redução Z. '+chr(10)+
                           'Se ainda assim não for possível, chame um técnico autorizado.');
               Result:=True;//False;
             end
            else
              Mais1Ini.WriteString('Frente de caixa','Dinheiro',sDinheiro);
         end;
         //
         if sCheque='XX' then
         begin
            sCheque := _ECF10_VerificaFormaPgto('CHEQUE');
            if sCheque = 'XX' then
             begin
               ShowMessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                            'CHEQUE, o sistema poderá cadastrá-la logo após a redução Z. '+chr(10)+
                            'Se ainda assim não for possível, chame um técnico autorizado.');
               Result:=True;//False;
             end
            else
              Mais1Ini.WriteString('Frente de caixa','Cheque',sCheque);
         end;
         //
         if sCartao='XX' then
         begin
            sCartao := _ECF10_VerificaFormaPgto('CARTAO');
            if sCartao = 'XX' then
             begin
               ShowMessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           'CARTAO, o sistema poderá cadastrá-la logo após a redução Z. '+chr(10)+'Se ainda assim não for possível, chame um técnico autorizado.');
               Result:=True;//False;
             end
            else
              Mais1Ini.WriteString('Frente de caixa','Cartao',sCartao);
         end;
         //
         if sPrazo='XX' then
         begin
           sPrazo := _ECF10_VerificaFormaPgto('PRAZO');
           if sPrazo = 'XX' then
            begin
              ShowMessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                          'PRAZO, o sistema poderá cadastrá-la logo após a redução Z. '+chr(10)+'Se ainda assim não for possível, chame um técnico autorizado.');
              Result:=True;//False;
            end
           else
             Mais1Ini.WriteString('Frente de caixa','Prazo',sPrazo);
         end;
         //formas extras
         //
         for k:=1 to 8 do
         begin
           if sFormaExtra[k]='XX' then
           begin
             sFormaExtra[k] := _ECF10_VerificaFormaPgto(UpperCase(Mais1Ini.ReadString('Frente de caixa','Forma extra '+inttostr(k),'')));
             if sFormaExtra[k] = 'XX' then
              begin
                ShowMessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                            UpperCase(Mais1Ini.ReadString('Frente de caixa','Forma extra '+inttostr(k),''))+', o sistema poderá cadastrá-la logo após a redução Z. '+chr(10)+
                            'Se ainda assim não for possível, chame um técnico autorizado.');
                Result:=True;//False;
              end
             else
               Mais1Ini.WriteString('Frente de caixa','Ordem forma extra '+inttostr(k),sFormaExtra[k]);
           end;
         end;
      end
    else
      begin
        Result := False;
      end;
   end
  else
    if Copy(Retorno,2,1) <> '+' then
     begin
       Result:=False;
       //showmessage('false'+chr(10)+Retorno);
     end
    else
     begin
       Result:=True;
       //showmessage('True'+chr(10)+Retorno);
     end;
  //
end;

// ------------------------------ //
Function _ECF10_FechaCupom(Pp1: Boolean):Boolean; //Sweda
var
  sTempo: String;
begin
  sTempo:='';
  Result:=True;
  if Form1.fTotal = 0 then // cupom em branco cancela
   begin
     Result:=(Copy(_ECF10_TXRX('05'),1,1)='.');//cancela cupom atual
   end
  else
   begin
     // verifica se tem desconto/acréscimo
     if JStrToFloat(Format('%13.2f',[Form1.fTotal])) > JStrToFloat(Format('%13.2f',[Form1.ibDataSet25.FieldByName('RECEBER').AsFloat])) then //Desconto
     begin
        //desconto
        Result:=(Copy(_ECF10_TXRX('03'+Replicate(' ',10)+
            Copy(Right('000000000000'+AllTrim(Format('%13f',[(Form1.fTotal-Form1.ibDataSet25.FieldByName('RECEBER').AsFloat)*100])),15),1,12)+'N'
            ),1,1)='.');
     end;
     if JStrToFloat(Format('%13.2f',[Form1.fTotal])) < JStrToFloat(Format('%13.2f',[Form1.ibDataSet25.FieldByName('RECEBER').AsFloat])) then //Acrescimo
     begin
        //acrescimo
        Result:=(Copy(_ECF10_TXRX('11'+'51'+'0000'+
            Copy(Right('00000000000'+AllTrim(Format('%12f',[(Form1.ibDataSet25.FieldByName('RECEBER').AsFloat-Form1.fTotal)*100])),14),1,11)+'N'
            ),1,1)='.');
     end;
   end;
end;

function _ECF10_Pagamento(Pp1: Boolean):Boolean;
var
  sTempo,sTempo1 : String;
  i,k:integer;
//  fSubTotal:double;
  Mais1ini : TiniFile;
  sPrazo, sDinheiro, sCheque, sCartao, sVinc : String;
  sFormaExtra: array[1..8] of string;
begin
  //
  Result := FAlse;
  Mais1ini  := TIniFile.Create('frente.ini');
  //
  sPrazo    := Mais1Ini.ReadString('Impressora Fiscal','Prazo','02');
  sDinheiro := Mais1Ini.ReadString('Impressora Fiscal','Dinheiro','03');
  sCheque   := Mais1Ini.ReadString('Impressora Fiscal','Cheque','04');
  sCartao   := Mais1Ini.ReadString('Impressora Fiscal','Cartao','05');
  //
  For k:=1 to 8 do
    sFormaExtra[k]:=Mais1Ini.ReadString('Impressora Fiscal','Ordem forma extra '+intToStr(k),'');

  sTempo:='';
  //
  // fSubTotal:=_ECF10_SubTotal(True);
  //
  // PRAZO
  //
  if Form1.ibDataSet25DIFERENCA_.AsFloat > 0 then
  begin
     sTempo:='';
     sTempo:=sTempo+sPrazo+Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25DIFERENCA_.Asfloat*100])),15),1,12);  //prazo
     _ECF10_TXRX('10'+sTempo);
     sVinc:='S';
  end;
  //
  // DINEIRO
  //
  if Form1.ibDataSet25ACUMULADO2.AsFloat > 0 then
  begin
    sTempo:=sTempo+sDinheiro+Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25ACUMULADO2.AsFloat*100])),15),1,12);  //dinheiro
    sVinc:='N';
  end;
  //
  // Cheque
  //
  if Form1.ibDataSet25ACUMULADO1.AsFloat > 0 then //cheque
  begin
    sTempo:=sTempo+sCheque+Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25ACUMULADO1.AsFloat*100])),15),1,12);  //cheque
    sVinc:='S';
  end;
  //
  // Cartão
  //
  if Form1.ibDataSet25.FieldByName('PAGAR').AsFloat <> 0 then // Cartão
  begin
    sTempo:=sTempo+sCartao+Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25.FieldByName('PAGAR').AsFloat*100])),15),1,12);  //Cartão
    sVinc:='S';
  end;
  //
  // Forma Extra 1
  //
  if Form1.ibDataSet25VALOR01.AsFloat <> 0 then //Modalidade extra 1
  begin
    sTempo:=sTempo+sFormaExtra[1]+Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR01.AsFloat*100])),15),1,12);  //Extra1
    sVinc:='N';
  end;
  //
  // Forma Extra 2
  //
  if Form1.ibDataSet25VALOR02.AsFloat <> 0 then
  begin
    sTempo:=sTempo+sFormaExtra[2]+Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR02.AsFloat*100])),15),1,12);  //Extra1
    sVinc:='N';
  end;
  //
  // Forma Extra 3
  //
  if Form1.ibDataSet25VALOR03.AsFloat <> 0 then
  begin
    sTempo:=sTempo+sFormaExtra[3]+Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR03.AsFloat*100])),15),1,12);  //Extra1
    sVinc:='N';
  end;
  //
  // Forma Extra 4
  //
  if Form1.ibDataSet25VALOR04.AsFloat <> 0 then
  begin
    sTempo:=sTempo+sFormaExtra[4]+Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR04.AsFloat*100])),15),1,12);  //Extra1
    sVinc:='N';
  end;
  //
  // Forma Extra 5
  //
  if Form1.ibDataSet25VALOR05.AsFloat <> 0 then
  begin
    sTempo:=sTempo+sFormaExtra[5]+Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR05.AsFloat*100])),15),1,12);  //Extra1
    sVinc:='N';
  end;
  //
  // Forma Extra 6
  //
  if Form1.ibDataSet25VALOR06.AsFloat <> 0 then
  begin
    sTempo:=sTempo+sFormaExtra[6]+Copy(Right('000000000000'+AllTrim(Format('%13f',[Form1.ibDataSet25VALOR06.AsFloat*100])),15),1,12);  //Extra1
    sVinc:='N';
  end;
  //
  // finaliza o cupom
  //
  Form1.sMensagemPromocional:=ConverteAcentos(Form1.sMensagemPromocional);
  //
  k:=0;
  for i:=1 to length(Form1.sMensagemPromocional) do
  begin
    if Copy(Form1.sMensagemPromocional,i,1)=chr(10) then
     begin
       sTempo1:=sTempo1+Replicate(' ',40-k);
       k:=0;
     end
    else
     begin
       sTempo1:=sTempo1+Copy(Form1.sMensagemPromocional,i,1);
       k:=k+1;
     end;
  end;
  //Form1.sMensagemPromocional:=StrTran(Form1.sMensagemPromocional,chr(10),'');
  //sTempo1:=Copy(Form1.sMensagemPromocional+Replicate(' ',320),1,320);
  sTempo1:=Copy(sTempo1+Replicate(' ',320),1,320);
  if AllTrim(Copy(sTempo1,1,40)) <> '' then
    sTempo:='0'+Copy(sTempo1,1,40);
  if AllTrim(Copy(sTempo1,41,40)) <> '' then
    sTempo:=sTempo+'0'+Copy(sTempo1,41,40);
  if AllTrim(Copy(sTempo1,81,40)) <> '' then
    sTempo:=sTempo+'0'+Copy(sTempo1,81,40);
  if AllTrim(Copy(sTempo1,121,40)) <> '' then
    sTempo:=sTempo+'0'+Copy(sTempo1,121,40);
  if AllTrim(Copy(sTempo1,161,40)) <> '' then
    sTempo:=sTempo+'0'+Copy(sTempo1,161,40);
  if AllTrim(Copy(sTempo1,201,40)) <> '' then
    sTempo:=sTempo+'0'+Copy(sTempo1,201,40);
  if AllTrim(Copy(sTempo1,241,40)) <> '' then
    sTempo:=sTempo+'0'+Copy(sTempo1,241,40);
  if AllTrim(Copy(sTempo1,281,40)) <> '' then
    sTempo:=sTempo+'0'+Copy(sTempo1,281,40);
  // fecha o cupom
  // QuattroZanthusResult:=(Copy(_ECF10_TXRX(Form1.sPorta,10,'.12'+ConverteAcentos(sTempo)),1,1)='.');
  if Result then Form1.bCupomAberto:=False;
  Result:=(Copy(_ECF10_TXRX('12'+ sVinc+'N'+ConverteAcentos(sTempo)),1,1)='.');
  sleep(4000);//dá 4 segundos segundo
  if not Result then Form1.bCupomAberto:=True;
  Result:=true;//Ronei mandou colocar sempre true.
end;

// ------------------------------ //
// Cancela o último item  emitido //
// ------------------------------ //
function _ECF10_CancelaUltimoItem(Pp1: Boolean):Boolean;//Sweda OK
begin
  Result:=(Copy(_ECF10_TXRX('04'),1,1)='.');
end;

function _ECF10_CancelaUltimoCupom(Pp1: Boolean):Boolean;//Sweda OK
begin
  if not pP1 then //cancela cupom atual
   begin
      Result:=(Copy(_ECF10_TXRX('05'),1,1)='.');
   end
  else
   begin
      Result:=(Copy(_ECF10_TXRX('05'),1,1)='.');
      if not Result then
        Showmessage('Não é possível cancelar uma venda com cupom vinculado');
   end
//   _ECF10_TXRX('0897');//avança 7 linhas
end;

function _ECF10_SubTotal(Pp1: Boolean):Real; //Sweda OK
var
  sTempo:String;
begin
   sTempo:=Right(AllTrim('000000000000'+Copy(_ECF10_TXRX('28'),22,12)),12);
   sTempo:=Copy(sTempo,1,10)+','+Copy(sTempo,11,2);
   Result:=JStrToFloat(sTempo);
end;

// ------------------------------ //
// Abre um novo copom fiscal      //
// ------------------------------ //
function _ECF10_AbreNovoCupom(Pp1: Boolean):Boolean; //Sweda
var
  sRetorno:string;
begin
   _ECF10_EsperaLiberarECF(10,'');
   Result:=False;
   sRetorno:=_ECF10_TXRX('28');
   //showmessage(sRetorno);
   //só aceita o comando se a última transação foi concuída
   if (Copy(sRetorno,10,1) = 'C') or (Copy(sRetorno,10,8) = 'P VENDAS') or
      (AllTrim(Copy(sRetorno,10,8)) = 'E') then//Copy(sRetorno,19,2) = '17' then
    begin
     // verifica se está em modo de INTERVENÇÃO
     if Copy(sRetorno,124,1)= 'S' then
      begin
        showmessage('O ECF está em modo de intervenção técnica.'+chr(10)+
                    'Chame um técnico habilitado para retirá-lo deste modo.');
        halt(1);
      end
     else
      begin
         // verifica se necessita redução Z
         if Copy(sRetorno,21,1)= 'F' then
         begin
           //Faz a redução Z
           _ECF10_ReducaoZ(true);
           // Form1.EmitirReducaoZ(Form1);// 2015-10-07 Deve emitir mesas aberta, fechar as aberta a mais de 1 dias antes ou logo após da redução Z
           _ECF10_EsperaLiberarEcf(50,'');//Sleep(30000);
         end;
         //se o último comando foi uma redução
         if Copy(sRetorno,11,8)= 'REDUCAO ' then
         begin
           //se o primeira legenda for em branco cadastra
           if AllTrim(Copy(_ECF10_TXRX('297'),38,15))='' then
           begin
             //não tem legenda Cadastrada
             _ECF10_TXRX('38N&RECEBIMENTOS  +SUPRIMENTO    &PAGAMENTOS    -SANGRIA       ');
           end;
         end;
         if Form1.bCupomAberto then //tenta abrir o cupom sem checagem de erro
          begin
            _ECF10_TXRX('17');
            Result:=True;
          end
         else
          begin
             // verifica se necessita leitura X
             if Copy(_ECF10_TXRX('28'),122,1)= 'F' then
             begin
                //Faz a leitura X
                _ECF10_LeituraX(true);
               {Sandro Silva 2015-10-06 inicio}
               if Trim(Form1.sNumeroDeSerieDaImpressora) = '' then
               begin
                 Form1.sNumeroDeSerieDaImpressora := Copy(AllTrim(_ecf10_NmerodeSrie(True)), 1, 20);
               end;
               Form1.Demais('LX'); // 2015-10-06
               {Sandro Silva 2015-10-06 final}
             end;
             //tenta abrir de novo
             sleep(1000);
             sRetorno:=_ECF10_TXRX('17');
             if (Pos('ERRO',sRetorno) >0) or (Pos('DIA ENCERRADO',sRetorno) >0) then
              begin
                showmessage(sRetorno);
                Result:=False;
              end
             else
                Result:=True;
          end;
         //
      end;
    end
   else
    if (Copy(sRetorno,10,8) = 'PLEIT. X')then //Relatório Pendente, encerra
      _ECF10_TXRX('08}');
end;


// -------------------------------- //
// Retorna o número do Cupom        //
// -------------------------------- //
function _ECF10_NumeroDoCupom(Pp1: Boolean):String; //Sweda OK
begin
  Result := '000000';
  Result:=Copy(_ECF10_TXRX('271'),14,4);
end;

// ------------------------------ //
// Cancela um item N              //
// ------------------------------ //
function _ECF10_CancelaItemN(pP1, pP2 : String):Boolean;// Sweda OK
//var
//  sX:String;
begin
//  sX:=StrZero((StrToInt(pP1)+Form1.iCancelaItenN),3,0);
//  showmessage(Copy(sX,2,3));
  Result:=(Copy(_ECF10_TXRX('04'+Right(pP1,3)),1,1)='.');
//  if Result then Form1.iCancelaItenN:=Form1.iCancelaItenN+1;
end;

// -------------------------------- //
// Abre a gaveta                    //
// -------------------------------- //
function _ECF10_AbreGaveta(Pp1: Boolean):Boolean; //
begin
   Result:=False;
//   Showmessage('Form1.sGaveta  ' +Form1.sGaveta);
   if Form1.sGaveta <> '128' then
   begin
//      Showmessage(_ECF10_Tipodaimpressora(true));
      if _ECF10_Tipodaimpressora(true)='IF S-7000I' then
         Result:=(Copy(_ECF10_TXRX('21'),6,1)='1') //se true gaveta fechada
      else
         Result:=(Copy(_ECF10_TXRX('42'),6,1)='0');
   end;
end;

// -------------------------------- //
// Status da gaveta                 //
// -------------------------------- //
function _ECF10_StatusGaveta(Pp1: Boolean):String; //
var
  Mais1ini : TiniFile;
begin
  if Pp1 then
   begin
      Mais1ini  := TIniFile.Create('frente.ini');
      if Mais1Ini.ReadString('Frente de caixa','Gaveta','X') = '2' then //tem gaveta Menno
       begin
         if _ECF10_Tipodaimpressora(true)='IF S-7000I' then
          begin
            if Copy(_ECF10_TXRX('22'),6,1) = '1' then // Gaveta fechada ou sem gaveta
               Result:='255'//Gaveta Aberta
            else
               Result:='000';
          end
         else
          begin
            if Copy(_ECF10_TXRX('43'),6,1) = '0' then // Gaveta fechada ou sem gaveta
               Result:='000'
            else
               Result:='255';//Gaveta Aberta
          end;
       end
      else
        if Mais1Ini.ReadString('Frente de caixa','Gaveta','X') = '1' then //tem gaveta não Menno
         begin
           if _ECF10_Tipodaimpressora(true)='IF S-7000I' then
            begin
              if Copy(_ECF10_TXRX('22'),6,1) = '1' then // Gaveta fechada ou sem gaveta
                 Result:='000'
              else
                 Result:='255';//Gaveta Aberta
            end
           else
            begin
              if Copy(_ECF10_TXRX('43'),6,1) = '0' then // Gaveta fechada ou sem gaveta
                 Result:='000'
              else
                 Result:='255';//Gaveta Aberta
            end;
         end
        else
         if Mais1Ini.ReadString('Frente de caixa','Gaveta','X') = 'X' then //Verifica se tem
          begin
            if Application.MessageBox(Pchar('Existe gaveta conectada ? '),'Confirma',mb_YesNo + MB_DEFBUTTON2+ MB_ICONWARNING) <> IDYES then
             begin
               Mais1Ini.WriteString('Frente de caixa','Gaveta','0');
               Result:='128'; //sem gaveta
             end
            else
             begin
               Mais1Ini.WriteString('Frente de caixa','Gaveta','1');
               if _ECF10_Tipodaimpressora(true)='IF S-7000I' then
                begin
                  if Copy(_ECF10_TXRX('22'),6,1) = '1' then // Gaveta fechada ou sem gaveta
                     Result:='000'
                  else
                     Result:='255';//Gaveta Aberta
                end
               else
                begin
                  if Copy(_ECF10_TXRX('43'),6,1) = '0' then // Gaveta fechada ou sem gaveta
                     Result:='000'
                  else
                     Result:='255';//Gaveta Aberta
                end;
             end;
          end
         else
          Result:='128'; //sem gaveta
      Mais1ini.Free;
   end;
   sleep(500)
end;

// -------------------------------- //
// Sangria                          //
// -------------------------------- //
function _ECF10_Sangria(Pp1: Real):Boolean; // Sweda OK
var
  sLegenda:String;
begin
   Result:=False;
   sLegenda:=_ECF10_VerificaLegendaNaoFiscal('PAGAMENTOS');
   if sLegenda='XX' then
    begin
      Showmessage('O Sistema não encontrou a legenda PAGAMENTOS.'+chr(10)+
                  'Esta legenda deverá ser cadastrada em intervenção técnica.');
    end
   else
    begin
     //_ECF10_TXRX('38N&RECEBIMENTOS  +SUPRIMENTO    &PAGAMENTOS    -SANGRIA       ');

     //abre o um comprovante não fiscal
     if Pos('ERRO',_ECF10_TXRX('19'+sLegenda+'      '))=0 then
     begin
       // procura a legenta SUPRIMENTO
       sLegenda:=_ECF10_VerificaLegendaNaoFiscal('SANGRIA');
       if sLegenda='XX' then
        begin
          Showmessage('O Sistema não encontrou a legenda SANGRIA.'+chr(10)+
                      'Esta legenda deverá ser cadastrada em intervenção técnica.');
        end
       else
        begin
          //acumula em registrador não fiscal
          if Pos('ERRO',_ECF10_TXRX('07'+sLegenda+Copy(Right('000000000000'+AllTrim(Format('%13f',[pP1*100])),15),1,12)+
                  Replicate(' ',40)))=0 then
          begin
            if Pos('ERRO',_ECF10_TXRX('12NN'))=0 then
               Result:=True;
          end;
    //   _ECF10_TXRX('0897');//avança 7 linhas
        end;
     end;
    end;
  _ECF10_EsperaLiberarECF(50,'');  //  sleep(3000);//Dá um tempo para não dar erro na abertura do Cupom
end;

// -------------------------------- //
// Suprimento                       //
// -------------------------------- //
function _ECF10_Suprimento(Pp1: Real):Boolean;//Sweda OK
var
   sTempo,sForma,sLegenda:String;
begin
   Result:=False;
   sLegenda:=_ECF10_VerificaLegendaNaoFiscal('RECEBIMENTOS');

   if sLegenda='XX' then
    begin
      Showmessage('O Sistema não encontrou a legenda RECEBIMENTOS.'+chr(10)+
                  'Esta legenda deverá ser cadastrada em intervenção técnica.');
    end
   else
    begin
     //_ECF10_TXRX('38N&RECEBIMENTOS  +SUPRIMENTO    &PAGAMENTOS    -SANGRIA       ');

     //abre o um comprovante não fiscal
     if Pos('ERRO',_ECF10_TXRX('19'+sLegenda+'      '))=0 then
     begin
       // procura a legenta SUPRIMENTO
       sLegenda:=_ECF10_VerificaLegendaNaoFiscal('SUPRIMENTO');
       if sLegenda='XX' then
        begin
          Showmessage('O Sistema não encontrou a legenda SUPRIMENTO.'+chr(10)+
                      'Esta legenda deverá ser cadastrada em intervenção técnica.');
        end
       else
        begin
          //acumula em registrador não fiscal
          if Pos('ERRO',_ECF10_TXRX('07'+sLegenda+Copy(Right('000000000000'+AllTrim(Format('%13f',[pP1*100])),15),1,12)+
                  Replicate(' ',40)))=0 then
          begin
            //procura a forma de pgto dinheiro
            sForma:=_ECF10_VerificaFormaPgtoECF('DINHEIRO');
            if sForma = 'XX' then
             begin
               ShowMessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           'DINHEIRO, o sistema poderá cadastrá-la logo após a redução Z. '+chr(10)+'Se ainda assim não for possível, chame um técnico autorizado.');
             end
            else
             begin
               sTempo:=sTempo+sForma+Copy(Right('000000000000'+AllTrim(Format('%13f',[pP1*100])),15),1,12);  //dinheiro
               if Pos('ERRO',_ECF10_TXRX('10'+sTempo))=0 then
                 //fecha o cupom
                 if Pos('ERRO',_ECF10_TXRX('12NN'))=0 then
                 begin
                    Result:=True;
                 end;
             end;
           end;
    //   _ECF10_TXRX('0897');//avança 7 linhas
        end;
     end;
    end;
  _ECF10_EsperaLiberarEcf(50,'');//sleep(3000);//Dá um tempo para não dar erro na abertura do Cupom
end;

// -------------------------------- //
// Nova Aliquota                    //
// -------------------------------- //
function _ECF10_NovaAliquota(Pp1: String):Boolean;
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
     Result:=(Copy(_ECF10_TXRX(Form1.sPorta,60,'33'+'T'+sNomeAliq+pP1),1,1)='.');}
   showmessage('O Cadastro de alíquotas só é permitido através de intervenção técnica');
   result:=false;
end;

function _ECF10_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
begin
  ShowMessage('Função não suportada pelo modelo de ECF utilizado.');
  Result := True;
end;

function _ECF10_LeituraMemoriaFiscal(pP1, pP2: String):Boolean; //
begin
  if Form7.Label3.Caption = 'Data inicial:' then
     Result:=(Copy(_ECF10_TXRX('16'+pP1+pP2),1,1)='.')
  else
   begin
     pP1:=strzero(strtoint(pP1),4,0);
     pP2:=strzero(strtoint(pP2),4,0);
     Result:=(Copy(_ECF10_TXRX('15'+pP1+pP2),1,1)='.');
   end;
//  _ECF10_TXRX('0897');
end;


// -------------------------------- //
// Venda do Item                    //
// -------------------------------- //
function _ECF10_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
{       StrZero(StrToInt(ibDataSet4.FieldByname('CODIGO').AsString),13,0), // Código
                               copy(sDescricao,1,29), // Descricão
                               ST                   , // ST
         StrZero(ibDataSet27QUANTIDADE.AsFloat*1000,7,0), // Quantidade
            StrZero(ibDataSet27UNITARIO.AsFloat*100,7,0), // Unitário
                    Copy(ibDataSet4.FieldByname('MEDIDA').AsString,1,2)); // Medida;
                        StrZero(ibDataSet25VALOR_1.AsFloat*100,7,0),          // Desconto %
                        StrZero(ibDataSet25VALOR_2.AsFloat*100,7,0));         // Destonco R$
}
var
  sTempo:string;
  function RetornaAliquota(iP1:integer):string;
  begin
    sTempo:='';
    Result:='';
    sTempo:=_ECF10_TXRX('293');
    delete(sTempo,1,48);
    Result:=Result+Copy(sTempo,1,28);
    sTempo:=_ECF10_TXRX('294');//'.+T0014T292900T303000T151500T292900T292900T292900T292900';
    delete(sTempo,1,7);
    Result:=Result+Copy(sTempo,1,49);
    sTempo:=_ECF10_TXRX('295');
    delete(sTempo,1,7);
    Result:=Result+Copy(sTempo,1,28);
    //showmessage(Result+chr(10)+pP1+inttostr(length(Result)));
    Result:=Copy(Result,(((iP1-1)*7))+1,3);
  end;
//  fTempo:double;
begin
{  showmessage(' pP1 '+pP1+chr(10)+
              ' pP2 '+pP2+chr(10)+
              ' pP3 '+pP3+chr(10)+
              ' pP4 '+pP4+chr(10)+
              ' pP5 '+pP5+chr(10)+
              ' pP6 '+pP6+chr(10));}

{  showmessage('sTempo:'+sTempo+chr(10)+
  inttostr(Pos('T07',sTempo)));
  pP3:=Copy(sTempo,(((StrToInt(pP3)-1)*7)+49),3);
  showmessage('pP3:'+pP3);}

//  showmessage('sTmpAliq:'+sTmpAliq);
//  showmessage('pP3:'+pP3);

//  sTempo:='';
//  sTmpAliq:='';

  if Copy(pP3,1,2)='IS' then
//     pP3:='S'+Copy(pP3,3,2)
     pP3:=RetornaAliquota(StrToInt(Copy(pP3,3,2)))
  else
    if pP3='II' then
       pP3:= 'I  '
    else
      if pP3='FF' then
        pP3:= 'F  '
      else
        if pP3='NN' then
           pP3:= 'N  '
        else
          begin
        //  ler a posição da aliquota e pegar o nome da alíquota relacionada
{            sTempo:=_ECF10_TXRX('293');
            delete(sTempo,1,48);
            sTmpAliq:=sTmpAliq+Copy(sTempo,1,28);
            sTempo:=_ECF10_TXRX('294');//'.+T0014T292900T303000T151500T292900T292900T292900T292900';
            delete(sTempo,1,7);
            sTmpAliq:=sTmpAliq+Copy(sTempo,1,49);
            sTempo:=_ECF10_TXRX('295');
            delete(sTempo,1,7);
            sTmpAliq:=sTmpAliq+Copy(sTempo,1,28);
            showmessage(sTmpAliq+chr(10)+pP3+inttostr(length(StempAliq)));
            pP3:=Copy(sTmpAliq,(((StrToInt(pP3)-1)*7))+1,3);
            }
            pP3:=RetornaAliquota(StrToInt(pP3));
          end;

//  showmessage(pP1+pP4+'00'+pP5+Replicate(' ',12)+Copy(pP2,1,24)+'T01');
{  showmessage('01'+pP1+pP4+'00'+pP5+
           StrZero(((StrToInt(pP4)/1000)*StrToInt(pP5)),12,0)+
                        Copy(pP2+Replicate(' ',24),1,24)+pP3);
}
   if Form1.ConfPreco='3' then
       sTempo:=_ECF10_CodeErro(_ECF10_TXRX('01'+pP1+pP4+'00'+pP5+
              StrZero(((StrToInt(pP4)/1000)*(StrToFloat(pP5)/10)),12,0)+
                           Copy('~'+pP2+Replicate(' ',24),1,24)+pP3))
   else
     begin
      if Frac(((StrToInt(pP4)/1000)*(StrToInt(pP5)/100))*100) >= 0.500 then
       begin
         delete(pP5,1,1);
         pP5:=pP5+'0';
         sTempo:=_ECF10_CodeErro(_ECF10_TXRX('01'+pP1+pP4+'00'+pP5+
                 StrZero(((StrToInt(pP4)/1000)*StrToInt(pP5)/10),12,0)+
                              Copy('~'+pP2+Replicate(' ',24),1,24)+pP3));
       end
      else
         sTempo:=_ECF10_CodeErro(_ECF10_TXRX('01'+pP1+pP4+'00'+pP5+
              StrZero(((StrToInt(pP4)/1000)*StrToInt(pP5)),12,0)+
                           Copy(pP2+Replicate(' ',24),1,24)+pP3));

     end;
   if Pos('ERRO',sTempo) >0 then
    begin
      Result:=False;
      if sTempo='ERRO-INDICADOR TRIB. INVALIDO' then
         showmessage('As Alíquotas devem ser programadas da seguinte forma:'+chr(10)+
                     'T01 para a primeira alíquota,'+chr(10)+
                     'T02 para a segunda'+chr(10)+
                     'T03 para a terceira, e assim, sucessivamente.');
    end
   else
      Result:=True;

  //
  //se a venda de item foi correta,
  //verifica se tem desconto e aplica
  //
  if Result then
  begin
    if _ECF10_Tipodaimpressora(true)='IF S-7000I' then
     begin
        if pP7 <> '0000000' then //desconto em percentual
         begin
    //       sTempo:=_ECF10_CodeErro(_ECF10_TXRX('02'+Right(pP7,4)+Replicate('0',12)));
            sTempo:=_ECF10_CodeErro(_ECF10_TXRX('02'+Copy(Right(pP7,4),1,2)+','+Right(pP7,2)+' %   '+
            StrZero(
                   (
                   (   (StrToFloat(pP7)/100) /100 )*   //multiplica pelo percentual já dividido por 100
                   ( (StrToFloat(pP4)/1000) * (StrToFloat(pP5)/100) )  //quantidade * Valor unit
                   *100) //multiplica p/100 para arredondar casas decimais
                   ,12,0)));
         end
        else //desconto em valor
         begin
           if pP8 <> '0000000' then //desconto em valor
             sTempo:=_ECF10_CodeErro(_ECF10_TXRX('02'+'          '+'00000'+pP8));
         end;
     end
    else
     begin
        if pP7 <> '0000000' then //desconto em percentual
         begin
    //       sTempo:=_ECF10_CodeErro(_ECF10_TXRX('02'+Right(pP7,4)+Replicate('0',12)));
            sTempo:=_ECF10_CodeErro(_ECF10_TXRX('02'+Right(pP7,4)+
            StrZero(
                   (
                   (   (StrToFloat(pP7)/100) /100 )*   //multiplica pelo percentual já dividido por 100
                   ( (StrToFloat(pP4)/1000) * (StrToFloat(pP5)/100) )  //quantidade * Valor unit
                   *100) //multiplica p/100 para arredondar casas decimais
                   ,12,0)));
         end
        else //desconto em valor
         begin
           if pP8 <> '0000000' then //desconto em valor
             sTempo:=_ECF10_CodeErro(_ECF10_TXRX('02'+'0000'+'00000'+pP8));
         end;
     end;
  end;
  if Pos('ERRO',sTempo) >0 then
  begin
    Result:=False;
  end;
end;

// -------------------------------- //
// Reducao Z                        //
// -------------------------------- //
function _ECF10_ReducaoZ(pP1: Boolean):Boolean; //
var
  sData:String;
begin
   sData:=DateToStr(Date);
   sData:=Copy(sData,1,2)+Copy(sData,4,2)+Copy(sData,9,2);
   Result:=(Copy(_ECF10_TXRX('14N'+sData),1,1)='.');
   _ECF10_EsperaLiberarEcf(50,'');//sleep(39000);// espera 37 segundos
//   _ECF10_TXRX('0897');//avança 7 linhas
//   result:=true;
end;

// -------------------------------- //
// Leitura X                        //
// -------------------------------- //
function _ECF10_LeituraX(pP1: Boolean):Boolean; // Sweda OK
begin
   Result:=(Copy(_ECF10_TXRX('13N'),1,1)='.');
   _ECF10_EsperaLiberarECF(39,'');
   //sleep(39000);// espera 39 segundos
end;

// ---------------------------------------------- //
// Retorna se o horario de verão está selecionado //
// ---------------------------------------------- //
function _ECF10_RetornaVerao(pP1: Boolean):Boolean; // Sweda OK
begin
  Result:=(Copy(_ECF10_TXRX('28'),57,1)='S');
end;

// -------------------------------- //
// Liga ou desliga horário de verao //
// -------------------------------- //
function _ECF10_LigaDesLigaVerao(pP1: Boolean):Boolean; //Sweda OK
begin
  if _ECF10_RetornaVerao(True) then
    Result:=(Copy(_ECF10_TXRX('36N'),1,1)='.') //desliga
  else
    Result:=(Copy(_ECF10_TXRX('36S'),1,1)='.');//liga
end;

// -------------------------------- //
// Retorna a versão do firmware     //
// -------------------------------- //
function _ECF10_VersodoFirmware(pP1: Boolean): String;// sweda OK
begin
  Result:=Copy(_ECF10_TXRX('27G'),28,3);
end;

// -------------------------------- //
// Retorna o número de série        //
// -------------------------------- //
function _ECF10_NmerodeSrie(pP1: Boolean): String;//sweda OK
begin
  Result:=Copy(_ECF10_TXRX('273'),13,9);
end;

// -------------------------------- //
// Retorna o CGC e IE               //
// -------------------------------- //
function _ECF10_CGCIE(pP1: Boolean): String; //Sweda OK
var
  sRetorno  : String;
  I: integer;
begin
  Screen.Cursor := crHourGlass; // Cursor de Aguardo
  I:=5;
  Result:='';
  while I <> 0 do
  begin
     sRetorno:=_ECF10_TXRX('29'+chr(I+71));
     sRetorno:=Copy(sRetorno,8,43);
     if StrToFloat(LimpaNumero('0'+Copy(sRetorno,1,22))) >0 then
        Result:=sRetorno
     else
        begin
          sRetorno:=Copy(_ECF10_TXRX('29'+chr(I+71)),8,22)+
                    Copy(_ECF10_TXRX('29'+chr(I+71)),31,20);
          if StrToFloat(LimpaNumero('0'+Copy(sRetorno,1,22))) > 0 then
             Result:=sRetorno;
        end;
     if Result<>'' then
      begin
        I:=0;
        Result:= 'CNPJ: '+Copy(Result,1,22)+chr(10)+
                 'IE:   '+Copy(Result,23,20);
      end
     else
        I:=I-1;
  end;

  Screen.Cursor := crDefault; // Cursor normal
end;

// --------------------------------- //
// Retorna o valor  de cancelamentos //
// --------------------------------- //
function _ECF10_Cancelamentos(pP1: Boolean): String; //Sweda OK
begin
  result:=Copy(_ECF10_TXRX('271'),77,12);
//  Result:=Format('%9.2m',[JStrToFloat(Copy(retorno,1,10)+','+Copy(retorno,11,2))]);
end;


// -------------------------------- //
// Retorna o valor de descontos     //
// -------------------------------- //
function _ECF10_Descontos(pP1: Boolean): String; //Sweda OK
//var
//  retorno:string;
begin
  result:=Copy(_ECF10_TXRX('271'),93,12);
//  Result:=Format('%9.2m',[JStrToFloat(Copy(retorno,1,10)+','+Copy(retorno,11,2))]);
end;

// -------------------------------- //
// Retorna o contador sequencial    //
// -------------------------------- //
function _ECF10_ContadorSeqencial(pP1: Boolean): String; //Sweda OK
begin
  Result:=Copy(_ECF10_TXRX('271'),14,4);
end;

// -------------------------------- //
// Retorna o número de operações    //
// não fiscais acumuladas           //
// -------------------------------- //
function _ECF10_Nmdeoperaesnofiscais(pP1: Boolean): String;  //Sweda OK
begin
  Result:=Copy(_ECF10_TXRX('271'),117,04);
end;

function _ECF10_NmdeCuponscancelados(pP1: Boolean): String; //Sweda OK
begin
  Result:=Copy(_ECF10_TXRX('271'),73,04);
end;

function _ECF10_NmdeRedues(pP1: Boolean): String; //Sweda OK
begin
  Result:=Copy(_ECF10_TXRX('271'),41,4);
  Result:=StrZero(StrToInt(Result)+1,6,0);
end;

function _ECF10_Nmdeintervenestcnicas(pP1: Boolean): String; //Sweda OK
begin
  Result:=Copy(_ECF10_TXRX('27G'),16,4);
end;

function _ECF10_Nmdesubstituiesdeproprietrio(pP1: Boolean): String; // Sweda OK
var
  sRetorno  : String;
  I: integer;
begin
  I:=5;
  Result:='';
  while I <> 0 do
  begin
     sRetorno:=Copy(_ECF10_TXRX('29'+chr(I+71)),61,22);
     if StrToFloat(LimpaNumero('0'+Copy(sRetorno,1,22))) >0 then
        Result:=StrZero(I,2,0)
     else
        begin
          sRetorno:=Copy(_ECF10_TXRX('29'+chr(I+71)),8,22);
          if StrToFloat(LimpaNumero('0'+Copy(sRetorno,1,22))) > 0 then
             Result:=StrZero(I,2,0);
        end;
     if Result<>'' then
        I:=0
     else
        I:=I-1;
  end;
end;

function _ECF10_Clichdoproprietrio(pP1: Boolean): String;//Sweda
begin
   Result:='';
   if Copy(_ECF10_TXRX('18'),1,1)='.' then
      Result:='Cliche impresso';
   _ECF10_EsperaLiberarEcf(50,'');//sleep(37000);// espera 37 segundos
   _ECF10_TXRX('0897');//avança 7 linhas
end;

// ------------------------------------ //
// Importante retornar apenas 3 dígitos //
// Ex: 001                              //
// ------------------------------------ //
function _ECF10_NmdoCaixa(pP1: Boolean): String; //Sweda OK
begin
  Result:=Copy(_ECF10_TXRX('28'),93,3);
end;

function _ECF10_Nmdaloja(pP1: Boolean): String;
begin
  Result:='Função não suportada';
//  showmessage(_ECF10_TXRX('28'));
end;

function _ECF10_Moeda(pP1: Boolean): String; //Sweda OK
begin
//  Result := 'R';
  Result:=_ECF10_TXRX('29F');
  Result := Copy(Result,81,1);
end;

function _ECF10_Dataehoradaimpressora(pP1: Boolean): String; //Sweda OK
begin
  Result:=_ECF10_TXRX('28');
  Result := Copy(Result,47,10)+'00'; //DDMMAAHHMMSS
  if (length(AllTrim(Result)) <> 12) or (not IsNumericString(Result)) then
  begin
    //dá um tempo e faz a leitura novamente
    sleep(3000);
    Result:=_ECF10_TXRX('28');
    Result := Copy(Result,47,10)+'00'; //DDMMAAHHMMSS
  end;
end;

function _ECF10_Datadaultimareduo(pP1: Boolean): String;
begin
  Result:='Função não suportada'
end;

function _ECF10_Datadomovimento(pP1: Boolean): String; //Sweda OK
begin
  Result:=Copy(_ECF10_TXRX('271'),8,6);
  Result:=Copy(Result,1,2)+'/'+Copy(Result,3,2)+'/'+Copy(Result,5,2);
end;

function _ECF10_Tipodaimpressora(pP1: Boolean): String; //Sweda OK
begin
   Result:=Copy(_ECF10_TXRX('271'),125,1);
   if Result='B'then
      Result:='IF S-7000I'
   else
     if Result='C'then
        Result:='IF S-7000II'
     else
       if Result='D'then
          Result:='IF S-7000IE';
end;

// Deve retornar uma String com:                                          //
// Os 2 primeiros dígitos são o número de aliquotas gravadas: Ex 16       //
// os póximos de 4 em 4 são as aliquotas Ex: 1800                         //
// Ex: 161800120005000000000000000000000000000000000000000000000000000000 //
// retorna + 64 caracteres quando tem ISS                                 //

function _ECF10_RetornaAliquotas(pP1: Boolean): String; //
var
  sRetorno,sISS : String;
begin
  Result:='16';
  sISS:='';
  sRetorno:=_ECF10_TXRX('293');
  //verifica qual é a aliquota de ISS

  if Copy(sRetorno,49,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,52,4);
     Result:=Result+'0000';
   end
  else
   begin
     sISS:=sISS+'0000';
     Result:=Result+Right('0000'+AllTrim(Copy(sRetorno,52,4)),4);
//     showmessage('1:'+Copy(sRetorno,49,3)+chr(10)+Result);
   end;
  //
  if Copy(sRetorno,56,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,59,4);
     Result:=Result+'0000';
   end
  else
   begin
     sISS:=sISS+'0000';
     Result:=Result+Right('0000'+AllTrim(Copy(sRetorno,59,4)),4);
//     showmessage('2:'+Copy(sRetorno,56,3)+chr(10)+Result);
   end;
  //
  if Copy(sRetorno,63,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,66,4);
     Result:=Result+'0000';
   end
  else
   begin
     sISS:=sISS+'0000';
     Result:=Result+Right('0000'+AllTrim(Copy(sRetorno,66,4)),4);
//     showmessage('3:'+Result);
   end;
  //
  if Copy(sRetorno,70,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,73,4);
     Result:=Result+'0000';
   end
  else
   begin
     sISS:=sISS+'0000';
     Result:=Result+Right('0000'+AllTrim(Copy(sRetorno,73,4)),4);
   end;
  sRetorno:=_ECF10_TXRX('294');
  //verifica qual é a aliquota de ISS
  if Copy(sRetorno,08,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,11,4);
     Result:=Result+'0000';
   end
  else
   begin
      sISS:=sISS+'0000';
      Result:=Result+Right('0000'+AllTrim(Copy(sRetorno,11,4)),4);
   end;
  //
  if Copy(sRetorno,15,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,18,4);
     Result:=Result+'0000';
   end
  else
   begin
      sISS:=sISS+'0000';
      Result:=Result+Right('0000'+AllTrim(Copy(sRetorno,18,4)),4);
   end;
  //
  if Copy(sRetorno,22,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,25,4);
     Result:=Result+'0000';
   end
  else
   begin
      sISS:=sISS+'0000';
      Result:=Result+Right('0000'+AllTrim(Copy(sRetorno,25,4)),4);
   end;
  //
  if Copy(sRetorno,29,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,32,4);
     Result:=Result+'0000';
   end
  else
   begin
      sISS:=sISS+'0000';
      Result:=Result+Right('0000'+AllTrim(Copy(sRetorno,32,4)),4);
   end;
  //
  if Copy(sRetorno,36,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,39,4);
     Result:=Result+'0000';
   end
  else
   begin
      sISS:=sISS+'0000';
      Result:=Result+Right('0000'+AllTrim(Copy(sRetorno,39,4)),4);
   end;
  //
  if Copy(sRetorno,43,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,46,4);
     Result:=Result+'0000';
   end
  else
   begin
      sISS:=sISS+'0000';
      Result:=Result+Right('0000'+AllTrim(Copy(sRetorno,46,4)),4);
   end;
  //
  if Copy(sRetorno,50,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,53,4);
     Result:=Result+'0000';
   end
  else
   begin
      sISS:=sISS+'0000';
      Result:=Result+Right('0000'+AllTrim(Copy(sRetorno,53,4)),4);
   end;
  sRetorno:=_ECF10_TXRX('295');

  //verifica qual é a aliquota de ISS
  if Copy(sRetorno,08,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,11,4);
     Result:=Result+'0000';
   end
  else
   begin
      sISS:=sISS+'0000';
      Result:=Result+Right('0000'+AllTrim(Copy(sRetorno,11,4)),4);
   end;
  //
  if Copy(sRetorno,15,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,18,4);
     Result:=Result+'0000';
   end
  else
   begin
      sISS:=sISS+'0000';
      Result:=Result+Right('0000'+AllTrim(Copy(sRetorno,18,4)),4);
   end;
  //
  if Copy(sRetorno,22,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,25,4);
     Result:=Result+'0000';
   end
  else
   begin
      sISS:=sISS+'0000';
      Result:=Result+Right('0000'+AllTrim(Copy(sRetorno,25,4)),4);
   end;
  //
  if Copy(sRetorno,29,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,32,4);
     Result:=Result+'0000';
   end
  else
   begin
      sISS:=sISS+'0000';
      Result:=Result+Right('0000'+AllTrim(Copy(sRetorno,32,4)),4);
   end;
  Result:=Result+'0000'+sISS+'0000'; //só para fechar 16 alíquotas
//  showmessage(Result+chr(10)+inttostr(Length(Result)));
end;


function _ECF10_Vincula(pP1: String): Boolean;
begin

// FormataTX(Chr(27)+'|38|0000000000000000|'+Chr(27));
{ if _ECF10_codeErro(FormataTX(Chr(27)+'|38|'+ Copy(AllTrim(pP1)+'0000000000000000',1,16) +'|'+Chr(27))) = 0
 then Result := True else Result := False;
}
   Result:=False;
end;


function _ECF10_FlagsDeISS(pP1: Boolean): String;
var
sretorno:string;
begin
   //procura qual é a alíquota de ISS
   Result:='00';
   sRetorno:=_ECF10_TXRX('293');
   if Copy(sRetorno,49,1)='S' then result:='01' else
      if Copy(sRetorno,65,1)='S' then result:='02' else
         if Copy(sRetorno,81,1)='S' then result:='03' else
            if Copy(sRetorno,97,1)='S' then result:='04';
   sRetorno:=_ECF10_TXRX('294');
   if Copy(sRetorno,12,1)='S' then result:='05' else
      if Copy(sRetorno,28,1)='S' then result:='06' else
         if Copy(sRetorno,44,1)='S' then result:='07' else
            if Copy(sRetorno,60,1)='S' then result:='08' else
               if Copy(sRetorno,76,1)='S' then result:='09' else
                  if Copy(sRetorno,92,1)='S' then result:='10' else
                    if Copy(sRetorno,108,1)='S' then result:='11';
   sRetorno:=_ECF10_TXRX('295');
   if Copy(sRetorno,12,1)='S' then result:='12' else
      if Copy(sRetorno,28,1)='S' then result:='13' else
         if Copy(sRetorno,44,1)='S' then result:='14' else
            if Copy(sRetorno,60,1)='S' then result:='15';

//   Result:='14';
//   Result:=Right('0000000000000001'+Replicate('0',StrToInt(Result)-1),16);

   if Result='00'then Result:=Replicate('0',16) else
      Result:=Replicate('0',StrToInt(Result)-1)+'1'+Replicate('0',8);

//   Result:=chr(BinToInt(Copy(Result,9,8)))+chr(BinToInt(Copy(Result,1,8)));
   Result:=chr(BinToInt(Copy(Result,1,8)))+chr(BinToInt(Copy(Result,9,8)));

end;

function _ECF10_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
//var
//  hModulo:THandle;
begin
//    hModulo:=GetModuleHandle('SWECF');
//    FreeLibrary(hModulo);
    Result:=False;
    if ECFClose() = 0 then
       Result := True;
end;

function _ECF10_MudaMoeda(pP1: String): Boolean;
begin
{  FormataTX(Chr(27)+'|1|'+ pP1 + '|'+Chr(27));
  Result := True;}
  Result:=False;
end;

function _ECF10_MostraDisplay(pP1: String): Boolean;
begin
  Result := True;
end;

function _ECF10_leituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;//Sweda OK
//   Result:=(Copy(_ECF10_TXRX(Form1.sPorta,60,'15'+'00009999'+'|'),1,1)='.');
var
  Retorno:String;
  t:textfile;
  Stream1,Stream2:TfileStream;
begin
  Form7.Label3.Visible:=True;
  Form7.Label3.Caption:='Aguarde recebendo dados do ECF';
  Form7.Label5.Visible:=True;
  Screen.Cursor := crHourGlass; // Cursor de Aguardo
  if length(pP2)=4 then // por redução
   begin
      //Retorno:=_ECF10_TXRX(Form1.sPorta,10,'15'+'00019999#');//+chr(124));
      pP2:=strzero(strtoint(pP2),4,0);
      pP3:=strzero(strtoint(pP3),4,0);
      Retorno:=_ECF10_CodeErro(_ECF10_TXRX('15'+pP2+pP3+'#'));
   end
  else // por data
   begin
      Retorno:=_ECF10_CodeErro(_ECF10_TXRX('16'+pP2+pP3+'#'));
   end;
  // Retorno:=_ECF10_Fserial(Form1.sPorta,Form1.iSequencial,'2D','0','');
  assignfile(t,Form1.sAtual+'\MEMFIS.TXT');
  rewrite(t);
  Writeln(t,'--[ Gerado em '+' '+DateTimeToStr(Now)+' ]--');
  while (Copy(Retorno,2,1) <> ']') and (Pos('ERRO',Retorno) = 0) do
  begin
     Form7.Label5.Caption:='Recebendo linha:'+Copy(Retorno,3,4);
     Form7.Refresh;
     //     form7.statusBar1.Simpletext:=Retorno;
     if Copy(Retorno,2,1) <> ']' then
        Writeln(t,Copy(Retorno,7,Length(Retorno)-7));
     Retorno:=_ECF10_CodeErro(_ECF10_TXRX('++'));
  end;
  closefile(t);

  Stream1:=TFileStream.Create(Form1.sAtual+'\MEMFIS.TXT',fmOpenRead);
  Stream2:=TFileStream.Create(pP1,fmOpenWrite or fmCreate);
  if Stream2.CopyFrom(Stream1, Stream1.Size)> 0 then  Result:= True  else Result:= False;
//  Stream2.Seek(0,0);
//  Stream2.seek(Stream2.size, soFromBeginning);
//  Stream1.Free;
//  Stream1:=TFileStream.Create(Form1.sAtual+'\MEMFIS.TMP',fmOpenRead);
//  if Stream2.CopyFrom(Stream1, Stream1.Size) > 0 then  Result:= True  else Result:= False;
  Stream1.Free;
  Stream2.Free;
//  DeleteFile(Form1.sAtual+'\MEMFIS.TMP');
  DeleteFile(Form1.sAtual+'\MEMFIS.TXT');
  Form7.Label3.Visible:=False;
  Form7.Label5.Visible:=False;
  Screen.Cursor := crDefault; // Cursor normal
end;

function _ECF10_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean; //iP2 = Número do Cupom vinculado
var
  I,J : Integer;
  sMod, sX: String;
  sTempo:string;
  Mais1ini : TiniFile;
begin
  //verificar esta rotina

  sTempo:=_ECF10_TXRX('28');
  if ((Copy(sTempo,11,8) = ' VENDAS ') and (Copy(sTempo,10,1)='E')) then
      _ECF10_TXRX('05');//cancela cupom atual
  if ((Copy(sTempo,11,8) = ' VENDAS ') and (Copy(sTempo,10,1)='P')) then
//     _ECF10_TXRX('12'+ sVinc+'N'+ConverteAcentos(sTempo));
     _ECF10_TXRX('12'+'NN'+ConverteAcentos(sTempo));

  //-----------------------------------------------------------
  //le o ini para saber qual foi a modalidade
  Mais1ini  := TIniFile.Create('frente.ini');
   begin
     if Form1.ibDataSet25DIFERENCA_.AsFloat > 0 then
       sMod:= Mais1Ini.ReadString('Frente de caixa','Prazo','04')
     else
       if Form1.ibDataSet25.FieldByName('PAGAR').AsFloat   > 0 then
         sMod:= Mais1Ini.ReadString('Frente de caixa','Cartao','03')
       else
         if Form1.ibDataSet25ACUMULADO1.AsFloat > 0 then
             sMod:= Mais1Ini.ReadString('Frente de caixa','Cheque','02');

     // Comando Para Abrir Comprovante Não Fiscal Vinculado
     Result:=(Copy(_ECF10_TXRX('1900'+StrZero(iP2,4,0)+sMod),1,1)='.');

     if Result then
     begin

       for J := 1 to 1 do
       begin
         if Result = True then
         begin
           //Result:=(Copy(_ECF10_TXRX('0897'),1,1)='.');//7 linhas em branco
           Result:= _ECF10_EsperaLiberarECF(5,'08');//novo
           if Result then                       //novo
             Result:=(Copy(_ECF10_TXRX('0897'),1,1)='.');//7 linhas em branco
         end;
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
                  Result:= _ECF10_EsperaLiberarECF(5,'08');
                  if Result then
                     Result:=(Copy(_ECF10_TXRX('080'+Copy(sX+Replicate(' ' ,42),1,42)),1,1)='.');
                  //sTempo:=_ECF10_TXRX('080'+Copy(sX+Replicate(' ' ,42),1,42));
                  //Result:=(Copy(sTempo,1,1)='.');//7 linhas em branco
                  sX:='';
                end
               else
                begin
                  //Result:=(Copy(_ECF10_TXRX('0891'),1,1)='.');//linha em branco
                  //sTempo:=_ECF10_TXRX('0891');//linha em branco
                  //Result:=(Copy(sTempo,1,1)='.');//7 linhas em branco
                  Result:= _ECF10_EsperaLiberarECF(5,'08');//novo
                  if Result then                       //novo
                    Result:=(Copy(_ECF10_TXRX('0891'),1,1)='.');// linha em branco
                  sX:='';
                end;
              end;
           end;
         end;//for
         if AllTrim(sX) <> '' then
         begin
           //imprime a linha
           //Result:=(Copy(_ECF10_TXRX('080'+Copy(sX+Replicate(' ' ,42),1,42)),1,1)='.');
           //sTempo:=_ECF10_TXRX('080'+Copy(sX+Replicate(' ' ,42),1,42));
           //Result:=(Copy(sTempo,1,1)='.');//7 linhas em branco
           Result:= _ECF10_EsperaLiberarECF(5,'08');
           if Result then
              Result:=(Copy(_ECF10_TXRX('080'+Copy(sX+Replicate(' ' ,42),1,42)),1,1)='.');
           sX:='';
         end;

         //avança 7 linhas
         if Result = True then
         begin
         //Result:=(Copy(_ECF10_TXRX('0897'),1,1)='.');//linhas em branco
           //sTempo:=_ECF10_TXRX('0897');//linhas em branco
           //Result:=(Copy(sTempo,1,1)='.');//7 linhas em branco
           Result:= _ECF10_EsperaLiberarECF(5,'08');//novo
           if Result then                       //novo
             Result:=(Copy(_ECF10_TXRX('0897'),1,1)='.');//7 linhas em branco
         end;

         {if Result = True then
         begin
           _ECF10_EsperaLiberarECF(50,'') ;
           sleep(2500); // Da um tempo
         end;}

         begin
           if Result then
           begin
             _ECF10_EsperaLiberarECF(11,'00') ;
             sleep(2500); // Da um tempo
           end;
         end;
       end;//for J
     end; //if Result
    //fecha o comprovante não fiscal
    //Result:=(Copy(_ECF10_TXRX('12'),1,1)='.');
    //sTempo:=_ECF10_TXRX('12');
    //Result:=(Copy(sTempo,1,1)='.');
    if Result then
    begin
      _ECF10_EsperaLiberarECF(5,'');
      Result:= _ECF10_EsperaLiberarECF(5,'08');
      if Result then
         Result:=(Copy(_ECF10_TXRX('12'),1,1)='.');
    end;

//    if Result then showmessage('True') else showmessage('False');
    //sleep(2000);
    //
  end;
end;

function _ECF10_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
var
  I,J : Integer;
  sX: String;
begin
  Result:=_ECF10_EsperaLiberarECF(5,'08');
  if Result then
  begin
    Result:=(Copy(_ECF10_TXRX('13S'),1,1)='.');//leitura x com rel gerencial
    _ECF10_EsperaLiberarECF(30,'');
    if Result then
    begin
     for J := 1 to 1 do
     begin
       if Result = True then
       begin
         Result:= _ECF10_EsperaLiberarECF(5,'08');
         if Result then
            Result:=(Copy(_ECF10_TXRX('0897'),1,1)='.');//7 linhas em branco
       end;
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
                Result:= _ECF10_EsperaLiberarECF(5,'08');
                if Result then
                  Result:=(Copy(_ECF10_TXRX('080'+Copy(sX+Replicate(' ' ,42),1,42)),1,1)='.');
                sX:='';
              end
             else
              begin
                Result:= _ECF10_EsperaLiberarECF(5,'08');
                if Result then
                  Result:=(Copy(_ECF10_TXRX('0891'),1,1)='.');//linha em branco
                sX:='';
              end;
            end;
         end;
       end;//for
       if AllTrim(sX) <> '' then
       begin
         //imprime a linha
         Result:= _ECF10_EsperaLiberarECF(5,'08');
         if Result then
           Result:=(Copy(_ECF10_TXRX('080'+Copy(sX+Replicate(' ' ,42),1,42)),1,1)='.');
         sX:='';
       end;

       //avança 7 linhas
       if Result = True then
       begin
         Result:= _ECF10_EsperaLiberarECF(5,'08');
         if Result then
           Result:=(Copy(_ECF10_TXRX('0897'),1,1)='.');//linhas em branco
       end;
       begin
         if Result then
         begin
           _ECF10_EsperaLiberarECF(11,'00') ;
           sleep(2500); // Da um tempo
         end;
       end;
       //if Result = True then sleep(3500); // Da um tempo
     end;//for J
     //fecha o relatório gerencial
     if Result then
     begin
       _ECF10_EsperaLiberarECF(5,'');
       Result:= _ECF10_EsperaLiberarECF(5,'08');
       if Result then
         Result:=(Copy(_ECF10_TXRX('08}'),1,1)='.');
     end;
    end; //if Result
    _ECF10_EsperaLiberarECF(50,'08');
  //  showmessage('Liberei');
    //
  end;
end;

function _ECF10_FechaCupom2(sP1: Boolean): Boolean;
begin
  // -------------------------- //
  // -------------------------- //
  Result:=_ECF10_EsperaLiberarECF(5,'08');
  if Result then
    Result:=(Copy(_ECF10_TXRX('12'),1,1)='.');
  if not _ECF10_EsperaLiberarECF(30,'') then
    sleep(30000);
//  Result := True;
  //
end;

function _ECF10_ImprimeCheque(rP1: Real; sP2: String): Boolean;
begin
  Result:=False;
end;

function _ECF10_GrandeTotal(sP1: Boolean): String;//
begin
  Result := '0';
  Result:=Copy(_ECF10_TXRX('271'),20,17);
end;

function _ECF10_TotalizadoresDasAliquotas(sP1: Boolean): String;
var
//  I : Integer;
  pRetorno : String;
begin
  Result := '';
  // Total Tributário 1
  Result:='00'+Copy(_ECF10_TXRX('273'),97,12); //coloquei 2 zeros a esq para completar 14 dígitos

  // Total Tributário 2 a 8
  pRetorno:=_ECF10_TXRX('274');
  Result:=Result+'00'+Copy(pRetorno,11,12); //coloquei 2 zeros a esq para completar 14 dígitos
  Result:=Result+'00'+Copy(pRetorno,26,12); //coloquei 2 zeros a esq para completar 14 dígitos
  Result:=Result+'00'+Copy(pRetorno,41,12); //coloquei 2 zeros a esq para completar 14 dígitos
  Result:=Result+'00'+Copy(pRetorno,56,12); //coloquei 2 zeros a esq para completar 14 dígitos
  Result:=Result+'00'+Copy(pRetorno,71,12); //coloquei 2 zeros a esq para completar 14 dígitos
  Result:=Result+'00'+Copy(pRetorno,86,12); //coloquei 2 zeros a esq para completar 14 dígitos
  Result:=Result+'00'+Copy(pRetorno,101,12); //coloquei 2 zeros a esq para completar 14 dígitos

  // Total Tributário 9 a 15
  pRetorno:=_ECF10_TXRX('275');
  Result:=Result+'00'+Copy(pRetorno,11,12); //coloquei 2 zeros a esq para completar 14 dígitos
  Result:=Result+'00'+Copy(pRetorno,26,12); //coloquei 2 zeros a esq para completar 14 dígitos
  Result:=Result+'00'+Copy(pRetorno,41,12); //coloquei 2 zeros a esq para completar 14 dígitos
  Result:=Result+'00'+Copy(pRetorno,56,12); //coloquei 2 zeros a esq para completar 14 dígitos
  Result:=Result+'00'+Copy(pRetorno,71,12); //coloquei 2 zeros a esq para completar 14 dígitos
  Result:=Result+'00'+Copy(pRetorno,86,12); //coloquei 2 zeros a esq para completar 14 dígitos
  Result:=Result+'00'+Copy(pRetorno,101,12); //coloquei 2 zeros a esq para completar 14 dígitos


  Result:=Result+Replicate('0',14);//como só tem 15 alíq. e deve ter 16 complementa com 1 X 14 zeros
  //
  //isento
  pRetorno:=_ECF10_TXRX('273');

  Result:=Result+'00'+Copy(pRetorno,22,12); //coloquei 2 zeros a esq para completar 14 dígitos
  //não incidência
  Result:=Result+'00'+Copy(pRetorno,34,12); //coloquei 2 zeros a esq para completar 14 dígitos
  //substituição
  Result:=Result+'00'+Copy(pRetorno,46,12); //coloquei 2 zeros a esq para completar 14 dígitos
//  showmessage(Result+chr(10)+'tamanho '+inttostr(length(Result)));
end;

function _ECF10_CupomAberto(sP1: Boolean): boolean;//sweda OK
var
  sTempo:string;
begin
   sTempo:=_ECF10_TXRX('28');
   //se estiver em cupom n.Fiscal, encerra
   if ((Copy(sTempo,11,8) = 'N.FISCAL') and (Copy(sTempo,10,1)='E')) then
   begin
      _ECF10_TXRX('12NN');//encerra cupom não fiscal atual
      sleep(3000);
      //lê de novo
      sTempo:=_ECF10_TXRX('28');
   end;

   if ((Copy(sTempo,11,8) = ' VENDAS ') and (Copy(sTempo,10,1)='E')) then
   begin
      //showmessage('teste..............Cupom Aberto');
      //_ECF10_TXRX('05');//cancela cupom atual
      Form1.Button4Click(Form1.Button4);
      showmessage('O Sistema deverá ser reiniciado.');
      Application.Terminate;
      //
   end;

//      if (Copy(_ECF10_TXRX('05'),1,1)='.') then //cancela cupom atual
//         _ECF10_TXRX('0897');//avança 7 linhas
   Result:=((Copy(sTempo,11,8) = ' VENDAS ') and (Copy(sTempo,10,1)='P'));
end;

function _ECF10_FaltaPagamento(sP1: Boolean): boolean;
//var
//  sTempo:string;
begin
//   sTempo:=_ECF10_TXRX('28');
{   if StrToInt(Copy(sTempo,98,12)) > 0 then
      Result:=true
   else
      Result:=False;}
   //compara o valor líquido e o valor bruto da venda
{   showmessage(sTempo);
   if Copy(sTempo,22,12) = Copy(sTempo,34,12) then
      Result:=False
   else
      Result:=True;}

  //Fiz retornar sempre falso pois não existe forma de saber se está em pagamento ou
  // em venda de ítens
  Result:=False;
end;


Function _ECF10_TXRX(pComando:String):string;
var
  Comando: array[0..512] of Char;
  Resp:array[0..512] of Char;
  iTentativas:integer;
  bPrimeiraVez:Boolean;
begin
  bPrimeiraVez:=True;
  iTentativas:=2;
  while iTentativas > 0 do
  begin
    Result:='';
    //primeiro tenta o comando 23 se deu 000 daí tenta o próximo
//    StrPCopy(Comando,chr(27)+'.23}');
//    if ECFWrite(Comando) = 0 then
//    begin
//       ECFRead(Resp,512);
//       Result:=StrPas(Resp);
//       //
//       if Copy(Result,1,6)='.+P000' then
//       begin
        if pComando='23I' then
           StrPCopy(Comando,chr(27)+'.23}')
        else
           StrPCopy(Comando,chr(27)+'.'+pComando+'}');
        //
        if ECFWrite(Comando) <> 0 then
         begin
           if (Copy(pComando,1,2)='08') then //comando de linhas livres
            begin
              iTentativas:=50;
            end
           else
            if (pComando='23I') then // or  (Copy(pComando,1,2)='08') then //comando de inicialização ou linhas livres
             begin
               iTentativas:=0;
               Result:='.-';
             end
            else
             if (pComando='273') and (bPrimeiraVez) then //está vendo o número de série na abertura do cupom
              begin
                iTentativas:=100;
                bPrimeiraVez:=False;
              end
             else
              begin
                iTentativas:=0;
                Result:='ERRO: 99';
                //_ECF10_CodeErro('99'); //aqui
              end;
         end
        else
         begin
            ECFRead(Resp,512);
            Result:=StrPas(Resp);
            //
            if Copy(Result,2,1)<>'+' then
              begin // sinal de - houve problema
                if Pos('ERRO',Result) > 0 then
                 begin
                   iTentativas:=0;
                   if (pComando='23') then //status da impressora
                      Result:='ERRO: 99'
                   else
      //                _ECF10_CodeErro(StrToInt('0'+AllTrim(Copy(Result,Pos('ERRO:',Result)+5, Pos('}',Result)-(Pos('ERRO:',Result)+5)))));
                      Result:=Copy(Result,Pos('ERRO',Result), Pos('}',Result)-(Pos('ERRO',Result)))+' Comando n.'+pComando;
                 end
                else
                 if Copy(Result,6,1) = '5' then //papel acabando
                  begin
                    _ECF10_CodeErro('PAPEL ACABANDO');
                    iTentativas:=0;
                  end
                 else
                  if Copy(Result,6,1) = '2' then //time out
                     sleep(5000) //espera 5 segundos
                  else
                     if pComando<>'++' then
                        Result:='ERRO'+'-'+Copy(Result,7,Pos('}',Result)-7);
              end
             else
              iTentativas:=0;
         end;//if ECFWrite(Comando) <> 0 then
//       end; //Copy(Result,1,6)='.+P000' then
//    end //if ECFWrite(Comando) = 0
//   else
    iTentativas:=iTentativas-1;
  end; //while
  if (Copy(Result,2,1)<>'+') and (Copy(Result,6,1) = '2') then //time out
    if (Copy(Result,7,13)='DIA ENCERRADO') then
       Result:='DIA ENCERRADO, não é possível efetuar vendas.'
    else
       Result:='ERRO-Tempo de Espera do comando -> '+pComando;
end;

end.






