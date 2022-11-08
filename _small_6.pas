unit _Small_6;

interface

uses
  Windows, Messages, SmallFunc, Fiscal, SysUtils,Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Mask, Grids, DBGrids, DB, DBCtrls, SMALL_DBEdit, IniFiles, Unit2,
  Unit7, Unit22;

  // ------------------ //
  // Quattro / Zanthus  //
  // ------------------ //

  // Impressora Quattro / Zanthus                            //
  // Alterado em 15/01/01 Motivo: CFOP maior                 //
  // 19/11/01 : Contra-senha                                 //
  // 27/02/02 : Impressão de cheques                         //
  // 10/01/03 : Cupom vinculado op. a prazo                  //
  // 11/03/03 : Correções                                    //
  // 31/07/03 : Correções para TEF                           //
  // 10/01/04 : Nova versão                                  //
  // 01/06/04 : novo upgrade (download para MG)              //
  // 14/12/04 : Versão 2005                                  //

  function TXRX(Porta: Integer; Tempo:Integer; Comando:String): Integer; stdcall; external 'APF_DLL2.DLL' name 'TXRX';
  //
  function _ecf06_TXRX(pP1:String;pP2:integer;pP3:String):String;
  function _ecf06_CodeErro(Pp1: Integer):String;
  function _ecf06_Inicializa(Pp1: String):Boolean;
  function _ecf06_FechaCupom(Pp1: Boolean):Boolean;
  function _ecf06_Pagamento(Pp1: Boolean):Boolean;
  function _ecf06_CancelaUltimoItem(Pp1: Boolean):Boolean;
  function _ecf06_SubTotal(Pp1: Boolean):Real;
  function _ecf06_AbreGaveta(Pp1: Boolean):Boolean;
  function _ecf06_Sangria(Pp1: Real):Boolean;
  function _ecf06_Suprimento(Pp1: Real):Boolean;
  function _ecf06_NovaAliquota(Pp1: String):Boolean;
  function _ecf06_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
  function _ecf06_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
  function _ecf06_CancelaUltimoCupom(Pp1: Boolean):Boolean;
  function _ecf06_AbreNovoCupom(Pp1: Boolean):Boolean;
  function _ecf06_NumeroDoCupom(Pp1: Boolean):String;
  function _ecf06_CancelaItemN(pP1, pP2: String):Boolean;
  function _ecf06_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
  function _ecf06_ReducaoZ(pP1: Boolean):Boolean;
  function _ecf06_LeituraX(pP1: Boolean):Boolean;
  function _ecf06_RetornaVerao(pP1: Boolean):Boolean;
  function _ecf06_LigaDesLigaVerao(pP1: Boolean):Boolean;
  function _ecf06_VersodoFirmware(pP1: Boolean): String;
  function _ecf06_NmerodeSrie(pP1: Boolean): String;
  function _ecf06_CGCIE(pP1: Boolean): String;
  function _ecf06_Cancelamentos(pP1: Boolean): String;
  function _ecf06_Descontos(pP1: Boolean): String;
  function _ecf06_ContadorSeqencial(pP1: Boolean): String;
  function _ecf06_Nmdeoperaesnofiscais(pP1: Boolean): String;
  function _ecf06_NmdeCuponscancelados(pP1: Boolean): String;
  function _ecf06_NmdeRedues(pP1: Boolean): String;
  function _ecf06_Nmdeintervenestcnicas(pP1: Boolean): String;
  function _ecf06_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
  function _ecf06_Clichdoproprietrio(pP1: Boolean): String;
  function _ecf06_NmdoCaixa(pP1: Boolean): String;
  function _ecf06_Nmdaloja(pP1: Boolean): String;
  function _ecf06_Moeda(pP1: Boolean): String;
  function _ecf06_Dataehoradaimpressora(pP1: Boolean): String;
  function _ecf06_Datadaultimareduo(pP1: Boolean): String;
  function _ecf06_Datadomovimento(pP1: Boolean): String;
  function _ecf06_Tipodaimpressora(pP1: Boolean): String;
  function _ecf06_StatusGaveta(Pp1: Boolean):String;
  function _ecf06_RetornaAliquotas(pP1: Boolean): String;
  function _ecf06_Vincula(pP1: String): Boolean;
  function _ecf06_FlagsDeISS(pP1: Boolean): String;
  function _ecf06_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
  function _ecf06_MudaMoeda(pP1: String): Boolean;
  function _ecf06_MostraDisplay(pP1: String): Boolean;
  function _ecf06_leituraMemoriaFiscalEmDisco(pP1,pP2,pP3: String): Boolean;
  function _ecf06_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean; //iP2 = Número do Cupom vinculado
  function _ecf06_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
  function _ecf06_FechaCupom2(sP1: Boolean): Boolean;
  function _ecf06_ImprimeCheque(rP1: Real; sP2: String): Boolean;
  function _ecf06_GrandeTotal(sP1: Boolean): String;
  function _ecf06_TotalizadoresDasAliquotas(sP1: Boolean): String;
  function _ecf06_CupomAberto(sP1: Boolean): boolean;
  function _ecf06_FaltaPagamento(sP1: Boolean): boolean;

implementation


Function _ecf06_CodeErro(pP1: Integer):String; //Quattro OK
var
  vErro    : array [0..99] of String;  // Cria uma matriz com  100 elementos
  I        : Integer;
begin
  //
  for I := 0 to 99 do vErro[I] := 'Comando não executado.';

  vErro[00] := 'Sem erro';
  vErro[06] := 'O valor informado no comando não pode ser 0';
  vErro[07] := 'Problemas de comunicação';
  vErro[10] := 'Código de tributação não cadastrado';
  vErro[17] := 'O cupom não foi aberto';
  vErro[28] := 'O cupom não está aberto';
  vErro[33] := 'A tabela de formas de pagamento está completa.';
  vErro[42] := 'Comando de cadastro de forma de pagamento não foi aceito';
  vErro[43] := 'É preciso tirar leitura X, Tecle F9';
  vErro[44] := 'É preciso Executar a redução Z';
  vErro[56] := 'Acréscimo maior que o total';
  vErro[60] := 'O cupom não pode ser cancelado';
  vErro[61] := 'O Dia já foi encerrado.'+chr(10)+
               'Se for um novo dia, faça a leitura X (Tecla F9)';
  vErro[62] := 'O cupom está sendo totalizado';
  vErro[75] := 'Já se encontra no horário de verão';
  vErro[76] := 'Já saiu do horário de verão';
  vErro[78] := 'COO informado não consta na tabela';
  vErro[84] := 'O item já foi cancelado';
  vErro[91] := 'Tipo de modalidade de pgto não existe';
  vErro[99] := 'Falha de comunicação '+chr(10)+chr(10)+
               'Sugestão: verifique as conexões,'+chr(10)+
               'ligue e desligue a impressora. '+chr(10)+chr(10)+
               'O Sistema será Finalizado.';

//  if pP1 = 7 then pP1:=99;
  if pP1 <> 0 then
  begin
    if pP1=60 then
      Application.MessageBox(Pchar(vErro[pP1]),'Atenção',mb_Ok + mb_DefButton1)
    else
      Application.MessageBox(Pchar('Erro n.'+StrZero(pP1,2,0)+'-'+vErro[pP1]),'Atenção',mb_Ok + mb_DefButton1);
  end;
  Result:=StrZero(pP1,2,0);
  if pP1 = 99 then Halt(1);
  if pP1 = 61 then Halt(1);
end;



// Verifica se a forma de pagamento está cadastrada
function _ecf06_VerificaFormaPgto(Forma:String):String;
var
  i,j:integer;
  sRetorno:String;
begin
   Result:='XX';
   if _ecf06_VersodoFirmware(True)= '1.02' then
      sRetorno:=Copy(_ecf06_TXRX(Form1.sPorta,15,'.29'+chr(5)),72,45)+Copy(_ecf06_TXRX(Form1.sPorta,15,'.29'+chr(6)),8,105)
   else
      sRetorno:=Copy(_ecf06_TXRX(Form1.sPorta,15,'.295'),72,45)+Copy(_ecf06_TXRX(Form1.sPorta,15,'.296'),8,105);
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
function _ecf06_Inicializa(Pp1: String):Boolean;   // quattro OK
var
  I,k : Integer;
  Retorno:string;
  Mais1ini : TiniFile;
  sPrazo, sDinheiro, sCheque, sCartao: String;
  sFormaExtra: array[1..8] of string;
  //  Retorno:integer;
begin
  Mais1ini  := TIniFile.Create('frente.ini');
  if TXRX(StrToInt(Right(pP1,1)),10,'.23') = 0 then
     Retorno := _ecf06_TXRX(pP1,1,'.23') // Status da impressora
  else
     Retorno :='ERRO';
  //
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
      if Copy(Retorno,1,1) <> '.' then
      begin
        ShowMessage('Quattro / Zanthus - Testando COM'+StrZero(I,1,0));
        Try
          Retorno := _ecf06_TXRX('COM'+StrZero(I,1,0),1,'.23'); // Status da impressora
          Pp1     := 'COM'+StrZero(I,1,0);
          Form1.sPorta  := pP1;
        except end;
      end;
    end;
    if Copy(Retorno,1,1) = '.' then
      begin
         //verifica as formas de pagamento e cadastra se não existirem
         // lê o arquivo frente.ini
         sDinheiro := Mais1Ini.ReadString('Frente de caixa','Dinheiro','XX');
         sCheque   := Mais1Ini.ReadString('Frente de caixa','Cheque','XX');
         sCartao   := Mais1Ini.ReadString('Frente de caixa','Cartao','XX');
         sPrazo    := Mais1Ini.ReadString('Frente de caixa','Prazo','XX');
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
         if (sDinheiro='XX') or (sDinheiro='') then
         begin
            sDinheiro:=_ecf06_VerificaFormaPgto('DINHEIRO');
            if sDinheiro = 'XX' then
              begin
                 //programa
                 _ecf06_TXRX(Form1.sPorta,10,'.37DINHEIRO       ');//cadastra forma de pgto
                 //Result:=True;//False;
              end
            else
               Mais1Ini.WriteString('Frente de caixa','Dinheiro',sDinheiro);
         end;
         //
         if (sCheque='XX') or (sCheque='') or (FileExists('c:\TEF_DISC\TEF_DISC.INI')) then
         begin
            if FileExists('c:\TEF_DISC\TEF_DISC.INI') then
              sCheque := _ecf06_VerificaFormaPgto('$CHEQUE')
            else
              sCheque := _ecf06_VerificaFormaPgto('CHEQUE');
            if sCheque = 'XX' then
             begin
               //programa
               if FileExists('c:\TEF_DISC\TEF_DISC.INI') then
                  _ecf06_TXRX(Form1.sPorta,10,'.37$CHEQUE        ')//cadastra forma de pgto
               else
                  _ecf06_TXRX(Form1.sPorta,10,'.37CHEQUE         ');//cadastra forma de pgto
               //Result:=True;//False;
             end
            else
              Mais1Ini.WriteString('Frente de caixa','Cheque',sCheque);
         end;
         //
         if (sCartao='XX') or (sCartao='') or ((FileExists('c:\TEF_DISC\TEF_DISC.INI')) or (FileExists('c:\TEF_DIAL\TEF_DIAL.INI')) or (FileExists('c:\disktef\bin\ichiper.exe'))  or (FileExists('c:\BCARD\BCARD.INI'))) then
         begin
            if ((FileExists('c:\TEF_DISC\TEF_DISC.INI')) or (FileExists('c:\TEF_DIAL\TEF_DIAL.INI')) or (FileExists('c:\disktef\bin\ichiper.exe'))  or (FileExists('c:\BCARD\BCARD.INI'))) then
              sCartao := _ecf06_VerificaFormaPgto('$CARTAO')
            else
              sCartao := _ecf06_VerificaFormaPgto('CARTAO');
            if sCartao = 'XX' then
             begin
                //programa
                if ((FileExists('c:\TEF_DISC\TEF_DISC.INI')) or (FileExists('c:\TEF_DIAL\TEF_DIAL.INI')) or (FileExists('c:\disktef\bin\ichiper.exe'))  or (FileExists('c:\BCARD\BCARD.INI'))) then
                  _ecf06_TXRX(Form1.sPorta,10,'.37$CARTAO        ')//cadastra forma de pgto
                else
                  _ecf06_TXRX(Form1.sPorta,10,'.37CARTAO         ');//cadastra forma de pgto
                //Result:=True;//False;
             end
            else
              Mais1Ini.WriteString('Frente de caixa','Cartao',sCartao);
         end;
         //
         if (sPrazo='XX') or (sPrazo='') then
         begin
           sPrazo := _ecf06_VerificaFormaPgto('PRAZO');
           if sPrazo = 'XX' then
            begin
               //programa
               _ecf06_TXRX(Form1.sPorta,10,'.37PRAZO          ');//cadastra forma de pgto
               //Result:=True;//False;
            end
           else
             Mais1Ini.WriteString('Frente de caixa','A prazo',sPrazo);
         end;
         //
         //se as formas extras estão cadastradas, verifica
         //
         for k:=1 to 8 do
         begin
           if sFormaExtra[k]<>'' then
           begin
             sFormaExtra[k] := _ecf06_VerificaFormaPgto(UpperCase(Mais1Ini.ReadString('Frente de caixa','Forma extra '+inttostr(k),'')));
             if sFormaExtra[k] = 'XX' then //não está cadastrada na impressora
              begin
                //programa
                _ecf06_TXRX(Form1.sPorta,10,'.37'+Copy(UpperCase(Mais1Ini.ReadString('Frente de caixa','Forma extra '+inttostr(k),''))+Replicate(' ',15),1,15));//cadastra forma de pgto
              end
             else
               Mais1Ini.WriteString('Frente de caixa','Ordem forma extra '+inttostr(k),sFormaExtra[k]);
           end;
           //
         end;

         //checa de novo
         if sDinheiro='XX' then
         begin
            sDinheiro:=_ecf06_VerificaFormaPgto('DINHEIRO');
            if sDinheiro = 'XX' then
             begin
               ShowMessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                           'DINHEIRO, o sistema poderá cadastrá-la logo após a redução Z. '+chr(10)+
                           'Se ainda assim não for possível, chame um técnico autorizado.');
               //Result:=True;//False;
             end
            else
              Mais1Ini.WriteString('Frente de caixa','Dinheiro',sDinheiro);
         end;
         //
         if sCheque='XX' then
         begin
            if FileExists('c:\TEF_DISC\TEF_DISC.INI') then
             begin
                sCheque := _ecf06_VerificaFormaPgto('$CHEQUE');
                if sCheque = 'XX' then
                 begin
                   ShowMessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                               '$CHEQUE, o sistema poderá cadastrá-la logo após a redução Z. '+chr(10)+
                               'Se ainda assim não for possível, chame um técnico autorizado.');
                   //Result:=True;//False;
                 end
                else
                  Mais1Ini.WriteString('Frente de caixa','Cheque',sCheque);
             end
            else
             begin
               sCheque := _ecf06_VerificaFormaPgto('CHEQUE');
               if sCheque = 'XX' then
                begin
                  ShowMessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                               'CHEQUE, o sistema poderá cadastrá-la logo após a redução Z. '+chr(10)+
                               'Se ainda assim não for possível, chame um técnico autorizado.');
                  //Result:=True;//False;
                end
               else
                 Mais1Ini.WriteString('Frente de caixa','Cheque',sCheque);
             end;
         end;
         //
         if sCartao='XX' then
         begin
            if ((FileExists('c:\TEF_DISC\TEF_DISC.INI')) or (FileExists('c:\TEF_DIAL\TEF_DIAL.INI')) or (FileExists('c:\disktef\bin\ichiper.exe'))  or (FileExists('c:\BCARD\BCARD.INI'))) then
             begin
                sCartao := _ecf06_VerificaFormaPgto('$CARTAO');
                if sCartao = 'XX' then
                 begin
                   ShowMessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                               '$CARTAO, o sistema poderá cadastrá-la logo após a redução Z. '+chr(10)+'Se ainda assim não for possível, chame um técnico autorizado.');
                   //Result:=True;//False;
                 end
                else
                  Mais1Ini.WriteString('Frente de caixa','Cartao',sCartao);
             end
            else
             begin
               sCartao := _ecf06_VerificaFormaPgto('CARTAO');
               if sCartao = 'XX' then
                begin
                  ShowMessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                              'CARTAO, o sistema poderá cadastrá-la logo após a redução Z. '+chr(10)+'Se ainda assim não for possível, chame um técnico autorizado.');
                  //Result:=True;//False;
                end
               else
                 Mais1Ini.WriteString('Frente de caixa','Cartao',sCartao);
             end;
         end;
         //
         if sPrazo='XX' then
         begin
           sPrazo := _ecf06_VerificaFormaPgto('PRAZO');
           if sPrazo = 'XX' then
            begin
              ShowMessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                          'PRAZO, o sistema poderá cadastrá-la logo após a redução Z. '+chr(10)+'Se ainda assim não for possível, chame um técnico autorizado.');
              //Result:=True;//False;
            end
           else
             Mais1Ini.WriteString('Frente de caixa','Prazo',sPrazo);
         end;
         //formas extras

         for k:=1 to 8 do
         begin
           if (sFormaExtra[k]='XX') then
           begin
             sFormaExtra[k] := _ecf06_VerificaFormaPgto(UpperCase(Mais1Ini.ReadString('Frente de caixa','Forma extra '+inttostr(k),'')));
             if sFormaExtra[k] = 'XX' then
              begin
                ShowMessage('O sistema não encontrou nenhuma forma de pagamento'+chr(10)+
                            UpperCase(Mais1Ini.ReadString('Frente de caixa','Forma extra '+inttostr(k),''))+','+chr(10)+
                            'o sistema poderá cadastrá-la logo após a redução Z. '+chr(10)+'Se ainda assim não for possível, chame um técnico autorizado.');
                //Result:=True;//False;
              end
             else
               Mais1Ini.WriteString('Frente de caixa','Ordem forma extra '+inttostr(k),sFormaExtra[k]);
           end;
         end;

         //
      end //if Copy(Retorno,1,1) = '.' then
    else;
    //
  end;
  if Copy(Retorno,1,4) <>'ERRO' then Result := True else Result := False;
  Mais1ini.Free; // Sandro Silva 2018-11-21 Memória 
end;

// ------------------------------ //
Function _ecf06_FechaCupom(Pp1: Boolean):Boolean; //Quattro
var
  sTempo : String;
begin
   sTempo:='';
   Result:=True;
   if Form1.fTotal = 0 then // cupom em branco cancela
    begin
      Result:=(Copy(_ecf06_TXRX(Form1.sPorta,10,'.05'),1,1)='.');//cancela cupom atual
    end
   else
    begin
      // verifica se tem desconto/acréscimo
      if JStrToFloat(Format('%13.2f',[Form1.fTotal])) > JStrToFloat(Format('%13.2f',[Form1.ibDataSet25RECEBER.AsFloat])) then //Desconto
      begin
         //desconto
         Result:=(Copy(_ecf06_TXRX(Form1.sPorta,10,'.03'+Replicate(' ',10)+
             Copy(Right('000000000000'+AllTrim(Format('%13f',[(Form1.fTotal-Form1.ibDataSet25RECEBER.AsFloat)*100])),15),1,12)
             ),1,1)='.');
      end;
      if JStrToFloat(Format('%13.2f',[Form1.fTotal])) < JStrToFloat(Format('%13.2f',[Form1.ibDataSet25RECEBER.AsFloat])) then //Acrescimo
      begin
         //acrescimo
         Result:=(Copy(_ecf06_TXRX(Form1.sPorta,10,'.11'+Replicate(' ',2)+'0000'+
             Copy(Right('00000000000'+AllTrim(Format('%12f',[(Form1.ibDataSet25RECEBER.AsFloat-Form1.fTotal)*100])),14),1,11)
             ),1,1)='.');
      end;
    end;
end;

function _ecf06_Pagamento(Pp1: Boolean):Boolean;
var
  i,k:integer;
  sTempo,sTempo1 : String;
//  fSubTotal:double;
  Mais1ini : TiniFile;
  sPrazo, sDinheiro, sCheque, sCartao, sExtra1, sExtra2, sExtra3, sExtra4,
  sExtra5, sExtra6, sExtra7, sExtra8 : String;
begin
  //
  Mais1ini  := TIniFile.Create('frente.ini');
  //
  sPrazo    := Strzero( strtoint(Mais1Ini.ReadString('Frente de caixa','Prazo','02')) ,2,0);
  sDinheiro := Strzero( strtoint(Mais1Ini.ReadString('Frente de caixa','Dinheiro','03')),2,0);
  sCheque   := Strzero( strtoint(Mais1Ini.ReadString('Frente de caixa','Cheque','04')),2,0);
  sCartao   := Strzero( strtoint(Mais1Ini.ReadString('Frente de caixa','Cartao','05')),2,0);
  sExtra1   := Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 1','');
  sExtra2   := Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 2','');
  sExtra3   := Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 3','');
  sExtra4   := Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 4','');
  sExtra5   := Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 5','');
  sExtra6   := Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 6','');
  sExtra7   := Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 7','');
  sExtra8   := Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 8','');

  Mais1ini.Free; // Sandro Silva 2018-11-21 Memória 

  if sExtra1 <> '' then sExtra1:=StrZero(StrToInt(sExtra1),2,0);
  if sExtra2 <> '' then sExtra2:=StrZero(StrToInt(sExtra2),2,0);
  if sExtra3 <> '' then sExtra3:=StrZero(StrToInt(sExtra3),2,0);
  if sExtra4 <> '' then sExtra4:=StrZero(StrToInt(sExtra4),2,0);
  if sExtra5 <> '' then sExtra5:=StrZero(StrToInt(sExtra5),2,0);
  if sExtra6 <> '' then sExtra6:=StrZero(StrToInt(sExtra6),2,0);
  if sExtra7 <> '' then sExtra7:=StrZero(StrToInt(sExtra7),2,0);
  if sExtra8 <> '' then sExtra8:=StrZero(StrToInt(sExtra8),2,0);

  sTempo:='';

//  fSubTotal:=_ecf06_SubTotal(True);

  //--------------------- //
  // Forma de pagamento   //
  //--------------------- //
  if Form1.ibDataSet25DIFERENCA_.AsFloat > 0 then sTempo := sTempo + sPrazo    + StrZero(Form1.ibDataSet25DIFERENCA_.AsFloat * 100,12,0);
  if Form1.ibDataSet25ACUMULADO2.AsFloat > 0 then sTempo := sTempo + sDinheiro + StrZero(Form1.ibDataSet25ACUMULADO2.AsFloat * 100,12,0);
  if Form1.ibDataSet25ACUMULADO1.AsFloat > 0 then sTempo := sTempo + sCheque   + StrZero(Form1.ibDataSet25ACUMULADO1.AsFloat * 100,12,0);
  if Form1.ibDataSet25PAGAR.AsFloat      > 0 then sTempo := sTempo + sCartao   + StrZero(Form1.ibDataSet25PAGAR.AsFloat      * 100,12,0);
  if Form1.ibDataSet25VALOR01.AsFloat    > 0 then sTempo := sTempo + sExtra1   + StrZero(Form1.ibDataSet25VALOR01.AsFloat    * 100,12,0);
  if Form1.ibDataSet25VALOR02.AsFloat    > 0 then sTempo := sTempo + sExtra2   + StrZero(Form1.ibDataSet25VALOR02.AsFloat    * 100,12,0);
  if Form1.ibDataSet25VALOR03.AsFloat    > 0 then sTempo := sTempo + sExtra3   + StrZero(Form1.ibDataSet25VALOR03.AsFloat    * 100,12,0);
  if Form1.ibDataSet25VALOR04.AsFloat    > 0 then sTempo := sTempo + sExtra4   + StrZero(Form1.ibDataSet25VALOR04.AsFloat    * 100,12,0);
  if Form1.ibDataSet25VALOR05.AsFloat    > 0 then sTempo := sTempo + sExtra5   + StrZero(Form1.ibDataSet25VALOR05.AsFloat    * 100,12,0);
  if Form1.ibDataSet25VALOR06.AsFloat    > 0 then sTempo := sTempo + sExtra6   + StrZero(Form1.ibDataSet25VALOR06.AsFloat    * 100,12,0);
  if Form1.ibDataSet25VALOR07.AsFloat    > 0 then sTempo := sTempo + sExtra7   + StrZero(Form1.ibDataSet25VALOR07.AsFloat    * 100,12,0);
  if Form1.ibDataSet25VALOR08.AsFloat    > 0 then sTempo := sTempo + sExtra8   + StrZero(Form1.ibDataSet25VALOR08.AsFloat    * 100,12,0);
  //
  // Totaliza o cupom
  //
  Result:=(Copy(_ecf06_TXRX(Form1.sPorta,10,'.10'+sTempo),1,1)='.');
  // finaliza o cupom //
  Form1.sMensagemPromocional:=ConverteAcentos(Form1.sMensagemPromocional);
  //transforma chr(10) em linhas de 40 colunas
  sTempo1:='';
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

  if not Result then Form1.bCupomAberto:=True;
  //fecha o cupom
  Result:=(Copy(_ecf06_TXRX(Form1.sPorta,10,'.12'+ConverteAcentos(sTempo)),1,1)='.');
  if Result then Form1.bCupomAberto:=False;
  Result:=true;//Ronei mandou colocar sempre true.
end;


// ------------------------------ //
// Cancela o último item  emitido //
// ------------------------------ //
function _ecf06_CancelaUltimoItem(Pp1: Boolean):Boolean;//Quattro Ok
begin
  Result:=(Copy(_ecf06_TXRX(Form1.sPorta,60,'.04'),1,1)='.');
end;

function _ecf06_CancelaUltimoCupom(Pp1: Boolean):Boolean;//Quattro OK
begin
   Result:=(Copy(_ecf06_TXRX(Form1.sPorta,10,'.05'),1,1)='.');
end;

function _ecf06_SubTotal(Pp1: Boolean):Real; //Quattro OK
var
  sTempo:String;
begin
  sTempo:=Right(AllTrim('000000000000'+Copy(_ecf06_TXRX(Form1.sPorta,2,'.28'),19,12)),12);
  sTempo:=Copy(sTempo,1,10)+','+Copy(sTempo,11,2);
  Result:=JStrToFloat(sTempo);
end;


// ------------------------------ //
// Abre um novo copom fiscal      //
// ------------------------------ //
function _ecf06_AbreNovoCupom(Pp1: Boolean):Boolean; //Quattro OK
var
  sRetorno,sTempo:string;
begin
   Result:=False;
   sRetorno:=_ecf06_TXRX(Form1.sPorta,2,'.28');
   // verifica se está em modo de INTERVENÇÃO
   if Alltrim(Copy(sRetorno,8,7))= 'TECNICO' then
    begin
      showmessage('O ECF está em modo de intervenção técnica.'+chr(10)+
                  'Chame um técnico habilitado para retirá-lo deste modo.');
      halt(1);
    end
   else
    begin
       //verifica se tem cupom vinculado aberto e fecha
       sTempo:=_ecf06_TXRX(Form1.sPorta,2,'.5606');
       if (Copy(sTempo,5,1) = 'S') and (Copy(sTempo,7,1) = 'S') then
         _ecf06_TXRX(Form1.sPorta,10,'.12');//fecha o comprovante não fiscal
       //verifica se tem relatório gerencial aberto e fecha
       sTempo:=_ecf06_TXRX(Form1.sPorta,2,'.5605');
       if (Copy(sTempo,5,1) = 'S') then
          _ecf06_TXRX(Form1.sPorta,10,'.08');


       // verifica se necessita redução Z
       if Copy(_ecf06_TXRX(Form1.sPorta,2,'.28'),18,1)= 'F' then
       begin
         //Faz a redução Z
         _ecf06_ReducaoZ(true);
         //Form1.EmitirReducaoZ(Form1);// 2015-10-07 Deve emitir mesas aberta, fechar as aberta a mais de 1 dias antes ou logo após da redução Z
       end;
       if Form1.bCupomAberto then //tenta abrir o cupom sem checagem de erro
        begin
//          _ecf06_TXRX(Form1.sPorta,5,'.17');
          Result:=True;
        end
       else
        begin
           // verifica se necessita leitura X
           if Copy(_ecf06_TXRX(Form1.sPorta,2,'.28'),124,1)= 'N' then
           begin
              //Faz a leitura X
              _ecf06_LeituraX(true);

             {Sandro Silva 2015-10-06 inicio}
             if Trim(Form1.sNumeroDeSerieDaImpressora) = '' then
             begin
               Form1.sNumeroDeSerieDaImpressora := Copy(AllTrim(_ecf06_NmerodeSrie(True)), 1, 20);
             end;
             Form1.Demais('LX'); // 2015-10-06
             {Sandro Silva 2015-10-06 final}
           end;
           //tenta abrir de novo
           sleep(1000);
           _ecf06_TXRX(Form1.sPorta,5,'.17');
           if (Pos('ERRO: 61',sRetorno) >0)  then
            begin
              _ecf06_CodeErro(61);
              Result:=False;
            end
           else
              Result:=True;
        end;
    end;
end;


// -------------------------------- //
// Retorna o número do Cupom        //
// -------------------------------- //
function _ecf06_NumeroDoCupom(Pp1: Boolean):String; //quattro OK
begin
  Result := '000000';
  Result:=Copy(_ecf06_TXRX(Form1.sPorta,2,'.271'),14,4);
end;

// ------------------------------ //
// Cancela um item N              //
// ------------------------------ //
function _ecf06_CancelaItemN(pP1, pP2 : String):Boolean;//quattro OK
//var
//  sX:String;
begin
//  sX:=StrZero((StrToInt(pP1)+Form1.iCancelaItenN),3,0);
//  showmessage(Copy(sX,2,3));
  Result:=(Copy(_ecf06_TXRX(Form1.sPorta,60,'.04'+Right(pP1,3)),1,1)='.');
//  if Result then Form1.iCancelaItenN:=Form1.iCancelaItenN+1;
end;

// -------------------------------- //
// Abre a gaveta                    //
// -------------------------------- //
function _ecf06_AbreGaveta(Pp1: Boolean):Boolean; //Quattro OK
begin
  Result:=(Copy(_ecf06_TXRX(Form1.sPorta,60,'.21'),6,1)='1');
  sleep(500);
end;

// -------------------------------- //
// Status da gaveta                 //
// -------------------------------- //
function _ecf06_StatusGaveta(Pp1: Boolean):String; //Quattro OK
begin
  //
  // 255-gaveta aberta 128-não tem gaveta  000-gaveta fechada
  //
  if Form1.iStatusGaveta = 0 then
  begin
    if Copy(_ecf06_TXRX(Form1.sPorta,60,'.22'),6,1) = '0' then Result:='000' else Result:='255';
  end else
  begin
    if Copy(_ecf06_TXRX(Form1.sPorta,60,'.22'),6,1) = '0' then Result:='255' else Result:='000';
  end;
  //
end;

// -------------------------------- //
// SAngria                          //
// -------------------------------- //
function _ecf06_Sangria(Pp1: Real):Boolean; //Quattro OK
begin
   Result:=False;
   //abre o um comprovante não fiscal
   if Pos('ERRO:',_ecf06_TXRX(Form1.sPorta,60,'.19'))=0 then
      //acumula em registrador não fiscal
      if Pos('ERRO:',_ecf06_TXRX(Form1.sPorta,60,'.07'+ '14'+Copy(Right('000000000000'+AllTrim(Format('%13f',[pP1*100])),15),1,12)+
              Replicate(' ',48)))=0 then
        //fecha o cupom
         if Pos('ERRO:',_ecf06_TXRX(Form1.sPorta,60,'.12'))=0 then
            Result:=True;
end;

// -------------------------------- //
// Suprimento                       //
// -------------------------------- //
function _ecf06_Suprimento(Pp1: Real):Boolean;
begin
   Result:=False;
   //abre o um comprovante não fiscal
   if Pos('ERRO:',_ecf06_TXRX(Form1.sPorta,60,'.19'))=0 then
      //acumula em registrador não fiscal
      if Pos('ERRO:',_ecf06_TXRX(Form1.sPorta,60,'.07'+ '13'+Copy(Right('000000000000'+AllTrim(Format('%13f',[pP1*100])),15),1,12)+
              Replicate(' ',48)))=0 then
        //fecha o cupom
         if Pos('ERRO:',_ecf06_TXRX(Form1.sPorta,60,'.12'))=0 then
            Result:=True;
end;

// -------------------------------- //
// Nova Aliquota                    //
// -------------------------------- //
function _ecf06_NovaAliquota(Pp1: String):Boolean;
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
     Result:=(Copy(_ecf06_TXRX(Form1.sPorta,60,'.33'+'T'+sNomeAliq+pP1),1,1)='.');}
   showmessage('O Cadastro de alíquotas só é permitido através de intervenção técnica');
   result:=false;
end;

function _ecf06_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
begin
  ShowMessage('Função não suportada pelo modelo de ECF utilizado.');
  Result := True;
end;


function _ecf06_LeituraMemoriaFiscal(pP1, pP2: String):Boolean; //Quattro
begin
  if Form7.Label3.Caption = 'Data inicial:' then
     Result:=(Copy(_ecf06_TXRX(Form1.sPorta,60,'.16'+pP1+pP2),1,1)='.')
  else
   begin
     pP1:=StrZero(StrToInt(pP1),4,0);
     // diminui 1 do pp2 fiz isso por que
     // a listagem estava saindo sempre uma red a mais
     pP2:=StrZero(StrToInt(pP2)-1,4,0);
     Result:=(Copy(_ecf06_TXRX(Form1.sPorta,60,'.15'+pP1+pP2),1,1)='.');
   end;
end;


// -------------------------------- //
// Venda do Item                    //
// -------------------------------- //
function _ecf06_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean; //Quattro
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
   Casas:integer;
begin
{  showmessage(' pP1 '+pP1+chr(10)+
              ' pP2 '+pP2+chr(10)+
              ' pP3 '+pP3+chr(10)+
              ' pP4 '+pP4+chr(10)+
              ' pP5 '+pP5+chr(10)+
              ' pP6 '+pP6+chr(10)); }
  if Copy(pP3,1,2)='IS' then  pP3:='S'+Copy(pP3,3,2) else
    if pP3='II' then pP3:= 'I  ' else
      if pP3='FF' then pP3:= 'F  '  else
        if pP3='NN' then pP3:= 'N  ' else
           pP3:= 'T'+pP3;

//  showmessage(pP1+pP4+'00'+pP5+Replicate(' ',12)+Copy(pP2,1,24)+'T01');

  if AllTrim(Form1.ConfPreco)='3' then
   begin
     Result:=(Copy(_ecf06_TXRX(Form1.sPorta,20,'.01'+pP1+pP4+'00'+pP5+Replicate(' ',12)+
                           Copy('~'+pP2+Replicate(' ',24),1,24)+pP3),1,1)='.');
     casas:=1000;
   end
  else
   begin
     Result:=(Copy(_ecf06_TXRX(Form1.sPorta,20,'.01'+pP1+pP4+'00'+pP5+Replicate(' ',12)+
                            Copy(pP2+Replicate(' ',24),1,24)+pP3),1,1)='.');
     casas:=100;
   end;
  //
  //se a venda de item foi correta,
  //verifica se tem desconto e aplica
  //
  if Result then
  begin
    if pP7 <> '0000000' then //desconto em percentual
     begin
       Result:=(Copy(_ecf06_TXRX(Form1.sPorta,20,'.02'+Replicate(' ',10)+StrZero(
               (
               (   (StrToFloat(pP7)/100) /100 )*   //multiplica pelo percentual já dividido por 100
               ( (StrToFloat(pP4)/1000) * (StrToFloat(pP5)/Casas) )  //quantidade * Valor unit
               *100) //multiplica p/100 para arredondar casas decimais
               ,12,0))     ,1,1)='.');
     end
    else //desconto em valor
     begin
       if pP8 <> '0000000' then //desconto em valor
         Result:=(Copy(_ecf06_TXRX(Form1.sPorta,20,'.02'+Replicate(' ',10)+'00000'+pP8),1,1)='.');
     end;
  end;
end;

// -------------------------------- //
// Reducao Z                        //
// -------------------------------- //
function _ecf06_ReducaoZ(pP1: Boolean):Boolean; //Quattro OK
begin
  Result:=(Copy(_ecf06_TXRX(Form1.sPorta,60,'.14N'),1,1)='.');
end;

// -------------------------------- //
// Leitura X                        //
// -------------------------------- //
function _ecf06_LeituraX(pP1: Boolean):Boolean; //quattro OK
begin
  if _ecf06_VersodoFirmware(True)= '1.02' then
     Result:=(Copy(_ecf06_TXRX(Form1.sPorta,60,'.13'),1,1)='.')
  else
     Result:=(Copy(_ecf06_TXRX(Form1.sPorta,60,'.13N'),1,1)='.');
end;

// ---------------------------------------------- //
// Retorna se o horario de verão está selecionado //
// ---------------------------------------------- //
function _ecf06_RetornaVerao(pP1: Boolean):Boolean; // Quattro OK
begin
  if Copy(_ecf06_TXRX(Form1.sPorta,5,'.28'),54,1)='S' then
     Result:=True
  else
     Result:=False;
end;

// -------------------------------- //
// Liga ou desliga horário de verao //
// -------------------------------- //
function _ecf06_LigaDesLigaVerao(pP1: Boolean):Boolean; //Quattro OK
begin
  if _ecf06_RetornaVerao(True) then
    Result:=(Copy(_ecf06_TXRX(Form1.sPorta,5,'.36N'),1,1)='.') //desliga
  else
    Result:=(Copy(_ecf06_TXRX(Form1.sPorta,5,'.36S'),1,1)='.');//liga
end;

// -------------------------------- //
// Retorna a versão do firmware     //
// -------------------------------- //
function _ecf06_VersodoFirmware(pP1: Boolean): String;// Quattro OK
begin
   Result:=Right(Copy(_ecf06_TXRX(Form1.sPorta,2,'.272'),8,11),3);
   Result:=Copy(Result,1,1)+'.'+Copy(Result,2,2);
//   Result:='1.'+Copy(_ecf06_TXRX(Form1.sPorta,2,'.52E0002E8'),4,2);
end;

// -------------------------------- //
// Retorna o número de série        //
// -------------------------------- //
function _ecf06_NmerodeSrie(pP1: Boolean): String;//Quattro OK
begin
//  Result:='Veja o rodapé do cupom';
  Result:=Copy(_ecf06_TXRX(Form1.sPorta,2,'.52E000007'),4,6);
end;

// -------------------------------- //
// Retorna o CGC e IE               //
// -------------------------------- //
function _ecf06_CGCIE(pP1: Boolean): String; //Quattro
var
  sRetorno  : String;
  I: integer;
begin
  Screen.Cursor := crHourGlass; // Cursor de Aguardo
  I:=5;
  Result:='';
  while I <> 0 do
  begin
     sRetorno:=Copy(_ecf06_TXRX(Form1.sPorta,15,'.29'+chr(I+64)),61,22)+
               Copy(_ecf06_TXRX(Form1.sPorta,15,'.29'+chr(I+64)),84,20);
     if StrToFloat(LimpaNumero('0'+Copy(sRetorno,1,22))) >0 then
        Result:=sRetorno
     else
        begin
          sRetorno:=Copy(_ecf06_TXRX(Form1.sPorta,15,'.29'+chr(I+64)),8,22)+
                    Copy(_ecf06_TXRX(Form1.sPorta,15,'.29'+chr(I+64)),31,20);
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
function _ecf06_Cancelamentos(pP1: Boolean): String; //Quattro OK
//var
//  retorno:string;
begin
  Result:=Copy(_ecf06_TXRX(Form1.sPorta,2,'.271'),77,12);
//  Result:=Format('%9.2m',[JStrToFloat(Copy(retorno,1,10)+','+Copy(retorno,11,2))]);
end;


// -------------------------------- //
// Retorna o valor de descontos     //
// -------------------------------- //
function _ecf06_Descontos(pP1: Boolean): String; //Quattro OK
//var
//  retorno:string;
begin
  Result:=Copy(_ecf06_TXRX(Form1.sPorta,2,'.271'),93,12);

//  Result:=Format('%9.2m',[JStrToFloat(Copy(retorno,1,10)+','+Copy(retorno,11,2))]);
end;

// -------------------------------- //
// Retorna o contador sequencial    //
// -------------------------------- //
function _ecf06_ContadorSeqencial(pP1: Boolean): String; //Quattro OK
begin
  Result:=Copy(_ecf06_TXRX(Form1.sPorta,2,'.271'),14,4);
end;

// -------------------------------- //
// Retorna o número de operações    //
// não fiscais acumuladas           //
// -------------------------------- //
function _ecf06_Nmdeoperaesnofiscais(pP1: Boolean): String;  //Quattro
begin
  Result:=Copy(_ecf06_TXRX(Form1.sPorta,2,'.271'),117,04);
end;

function _ecf06_NmdeCuponscancelados(pP1: Boolean): String; //Quattro OK
begin
  Result:=Copy(_ecf06_TXRX(Form1.sPorta,2,'.271'),73,04);
end;

function _ecf06_NmdeRedues(pP1: Boolean): String; //Quattro OK
begin
  Result:=Strzero(StrToInt(Copy(_ecf06_TXRX(Form1.sPorta,2,'.271'),41,4))+1,4,0);
end;

function _ecf06_Nmdeintervenestcnicas(pP1: Boolean): String;
begin
  Result:='';//'Função não suportada'
end;


function _ecf06_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
var
  sRetorno  : String;
  I: integer;
begin
  I:=5;
  Result:='';
  while I <> 0 do
  begin
     sRetorno:=Copy(_ecf06_TXRX(Form1.sPorta,15,'.29'+chr(I+64)),61,22);
     if StrToFloat(LimpaNumero('0'+Copy(sRetorno,1,22))) >0 then
        Result:=StrZero(I,2,0)
     else
        begin
          sRetorno:=Copy(_ecf06_TXRX(Form1.sPorta,15,'.29'+chr(I+64)),8,22);
          if StrToFloat(LimpaNumero('0'+Copy(sRetorno,1,22))) > 0 then
             Result:=StrZero(I,2,0);
        end;
     if Result<>'' then
        I:=0
     else
        I:=I-1;
  end;
end;

function _ecf06_Clichdoproprietrio(pP1: Boolean): String;
begin
   Result:='';
   if Copy(_ecf06_TXRX(Form1.sPorta,15,'.18'),1,1)='.' then
      Result:='Cliche impresso';
//  Right(_ecf06_Clichdoproprietrio(true),2);
end;

// ------------------------------------ //
// Importante retornar apenas 3 dígitos //
// Ex: 001                              //
// ------------------------------------ //
function _ecf06_NmdoCaixa(pP1: Boolean): String; //Quattro OK
begin
  Result:=Copy(_ecf06_TXRX(Form1.sPorta,2,'.28'),95,3);
end;

function _ecf06_Nmdaloja(pP1: Boolean): String;
begin
  _ecf06_TotalizadoresDasAliquotas(true);
  Result:='Função não suportada'
end;

function _ecf06_Moeda(pP1: Boolean): String;
begin
  Result := 'R';
end;

function _ecf06_Dataehoradaimpressora(pP1: Boolean): String; //quattro OK
begin
  Result:=_ecf06_TXRX(Form1.sPorta,5,'.28');
  Result := Copy(Result,44,10)+'00'; //DDMMAAHHMMSS
end;

function _ecf06_Datadaultimareduo(pP1: Boolean): String;
begin
  Result:='Função não suportada'
end;

function _ecf06_Datadomovimento(pP1: Boolean): String; //Quattro
begin
  Result:=Copy(_ecf06_TXRX(Form1.sPorta,2,'.271'),7,6);
end;

function _ecf06_Tipodaimpressora(pP1: Boolean): String; //Quattro OK
begin
   Result:=Copy(_ecf06_TXRX(Form1.sPorta,2,'.272'),8,11)+ ' '+Copy(_ecf06_TXRX(Form1.sPorta,2,'.271'),125,1);
end;

// Deve retornar uma String com:                                          //
// Os 2 primeiros dígitos são o número de aliquotas gravadas: Ex 16       //
// os póximos de 4 em 4 são as aliquotas Ex: 1800                         //
// Ex: 161800120005000000000000000000000000000000000000000000000000000000 //
// retorna + 64 caracteres quando tem ISS                                 //

function _ecf06_RetornaAliquotas(pP1: Boolean): String; //quattro OK
var
  sRetorno,sISS : String;
begin
  Result:='16';
  sISS:='';
  if _ecf06_VersodoFirmware(True)= '1.02' then
     sRetorno:=_ecf06_TXRX(Form1.sPorta,15,'.29'+chr(3))
  else
     sRetorno:=_ecf06_TXRX(Form1.sPorta,15,'.293');
  //verifica qual é a aliquota de ISS
  if Copy(sRetorno,49,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,57,4);
     Result:=Result+'0000';
   end
  else
   begin
     sISS:=sISS+'0000';
     Result:=Result+Copy(sRetorno,57,4);
   end;
  if Copy(sRetorno,65,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,73,4);
     Result:=Result+'0000';
   end
  else
   begin
     sISS:=sISS+'0000';
     Result:=Result+Copy(sRetorno,73,4);
   end;
  if Copy(sRetorno,81,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,89,4);
     Result:=Result+'0000';
   end
  else
   begin
     sISS:=sISS+'0000';
     Result:=Result+Copy(sRetorno,89,4);
   end;
  if Copy(sRetorno,97,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,105,4);
     Result:=Result+'0000';
   end
  else
   begin
     sIss:=sISS+'0000';
     Result:=Result+Copy(sRetorno,105,4);
   end;

  if _ecf06_VersodoFirmware(True)= '1.02' then
     sRetorno:=_ecf06_TXRX(Form1.sPorta,15,'.29'+chr(4))
  else
    sRetorno:=_ecf06_TXRX(Form1.sPorta,15,'.294');
  //verifica qual é a aliquota de ISS
  if Copy(sRetorno,08,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,16,4);
     Result:=Result+'0000';
   end
  else
   begin
      sISS:=sISS+'0000';
      Result:=Result+Copy(sRetorno,16,4);
   end;
  if Copy(sRetorno,24,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,32,4);
     Result:=Result+'0000';
   end
  else
   begin
      sISS:=sISS+'0000';
      Result:=Result+Copy(sRetorno,32,4);
   end;
  if Copy(sRetorno,40,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,48,4);
     Result:=Result+'0000';
   end
  else
   begin
     sISS:=sISS+'0000';
     Result:=Result+Copy(sRetorno,48,4);
   end;
  if Copy(sRetorno,56,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,64,4);
     Result:=Result+'0000';
   end
  else
   begin
     sISS:=sISS+'0000';
     Result:=Result+Copy(sRetorno,64,4);
   end;
  if Copy(sRetorno,72,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,80,4);
     Result:=Result+'0000';
   end
  else
   begin
     sISS:=sISS+'0000';
     Result:=Result+Copy(sRetorno,80,4);
   end;
  if Copy(sRetorno,88,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,096,4);
     Result:=Result+'0000';
   end
  else
   begin
      sISS:=sISS+'0000';
      Result:=Result+Copy(sRetorno,096,4);
   end;
  if Copy(sRetorno,104,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,112,4);
     Result:=Result+'0000';
   end
  else
   begin
     sISS:=sISS+'0000';
     Result:=Result+Copy(sRetorno,112,4);
   end;

//  Result:=Result+Copy(sRetorno,20,4)+Copy(sRetorno,36,4)+Copy(sRetorno,52,4)+
//                 Copy(sRetorno,68,4)+Copy(sRetorno,84,4)+Copy(sRetorno,100,4)+
//                 Copy(sRetorno,116,4);
//alterei estas 3 linhas em 04/04/00
//  Result:=Result+Copy(sRetorno,16,4)+Copy(sRetorno,32,4)+Copy(sRetorno,48,4)+
//                 Copy(sRetorno,64,4)+Copy(sRetorno,80,4)+Copy(sRetorno,96,4)+
//                 Copy(sRetorno,112,4);

  if _ecf06_VersodoFirmware(True)= '1.02' then
     sRetorno:=_ecf06_TXRX(Form1.sPorta,15,'.29'+chr(5))
  else
     sRetorno:=_ecf06_TXRX(Form1.sPorta,15,'.295');
  //verifica qual é a aliquota de ISS
  if Copy(sRetorno,08,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,16,4);
     Result:=Result+'0000';
   end
  else
   begin
     sISS:=sISS+'0000';
     Result:=Result+Copy(sRetorno,16,4);
   end;
  if Copy(sRetorno,24,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,32,4);
     Result:=Result+'0000';
   end
  else
   begin
     sISS:=sISS+'0000';
     Result:=Result+Copy(sRetorno,32,4);
   end;
  if Copy(sRetorno,40,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,48,4);
     Result:=Result+'0000';
   end
  else
   begin
     sISS:=sISS+'0000';
     Result:=Result+Copy(sRetorno,48,4);
   end;
  if Copy(sRetorno,56,1)='S' then
   begin
     sISS:=sISS+Copy(sRetorno,64,4);
     Result:=Result+'0000';
   end
  else
   begin
     sISS:=sISS+'0000';
     Result:=Result+Copy(sRetorno,64,4);
   end;

  Result:=Result+'0000'+sISS+'0000'; //só para fechar 16 alíquotas
//  showmessage(Result+chr(10)+inttostr(Length(Result)));
end;


function _ecf06_Vincula(pP1: String): Boolean;
begin

// FormataTX(Chr(27)+'|38|0000000000000000|'+Chr(27));
{ if _ecf06_codeErro(FormataTX(Chr(27)+'|38|'+ Copy(AllTrim(pP1)+'0000000000000000',1,16) +'|'+Chr(27))) = 0
 then Result := True else Result := False;
}
   Result:=False;
end;


function _ecf06_FlagsDeISS(pP1: Boolean): String;
var
sretorno:string;
begin
   //procura qual é a alíquota de ISS
   Result:='00';
   if _ecf06_VersodoFirmware(True)= '1.02' then
     sRetorno:=_ecf06_TXRX(Form1.sPorta,15,'.29'+chr(3))
   else
     sRetorno:=_ecf06_TXRX(Form1.sPorta,15,'.293');
   if Copy(sRetorno,49,1)='S' then result:='01' else
      if Copy(sRetorno,65,1)='S' then result:='02' else
         if Copy(sRetorno,81,1)='S' then result:='03' else
            if Copy(sRetorno,97,1)='S' then result:='04';
   if _ecf06_VersodoFirmware(True)= '1.02' then
      sRetorno:=_ecf06_TXRX(Form1.sPorta,15,'.29'+chr(4))
   else
      sRetorno:=_ecf06_TXRX(Form1.sPorta,15,'.294');
   if Copy(sRetorno,12,1)='S' then result:='05' else
      if Copy(sRetorno,28,1)='S' then result:='06' else
         if Copy(sRetorno,44,1)='S' then result:='07' else
            if Copy(sRetorno,60,1)='S' then result:='08' else
               if Copy(sRetorno,76,1)='S' then result:='09' else
                  if Copy(sRetorno,92,1)='S' then result:='10' else
                    if Copy(sRetorno,108,1)='S' then result:='11';
   if _ecf06_VersodoFirmware(True)= '1.02' then
      sRetorno:=_ecf06_TXRX(Form1.sPorta,15,'.29'+chr(5))
   else
      sRetorno:=_ecf06_TXRX(Form1.sPorta,15,'.295');
   if Copy(sRetorno,12,1)='S' then result:='12' else
      if Copy(sRetorno,28,1)='S' then result:='13' else
         if Copy(sRetorno,44,1)='S' then result:='14' else
            if Copy(sRetorno,60,1)='S' then result:='15';

   Result:=Right('0000000000000001'+Replicate('0',StrToInt(Result)-1),16);

   Result:=chr(BinToInt(Copy(Result,9,8)))+chr(BinToInt(Copy(Result,1,8)));

end;

function _ecf06_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
var
  hModulo:THandle;
begin
    hModulo:=GetModuleHandle('Apf_Dll2');
    FreeLibrary(hModulo);
    Result := True;
end;

function _ecf06_MudaMoeda(pP1: String): Boolean;
begin
{  FormataTX(Chr(27)+'|1|'+ pP1 + '|'+Chr(27));
  Result := True;}
  Result:=False;
end;

function _ecf06_MostraDisplay(pP1: String): Boolean;
begin
  Result := True;
end;

function _ecf06_leituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
//   Result:=(Copy(_ecf06_TXRX(Form1.sPorta,60,'.15'+'00009999'+'|'),1,1)='.');
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
      pP2:=StrZero(StrToInt(pP2),4,0);
      pP3:=StrZero(StrToInt(pP3),4,0);
      //Retorno:=_ecf06_TXRX(Form1.sPorta,10,'.15'+'00019999#');//+chr(124));
      Retorno:=_ecf06_TXRX(Form1.sPorta,10,'.15'+pP2+pP3+'#');
   end
  else // por data
   begin
      Retorno:=_ecf06_TXRX(Form1.sPorta,10,'.16'+pP2+pP3+'#');
   end;
  // Retorno:=_ecf06_Fserial(Form1.sPorta,Form1.iSequencial,'2D','0','');
  assignfile(t,Form1.sAtual+'\MEMFIS.TXT');
  rewrite(t);
  Writeln(t,'--[ Gerado em '+' '+DateTimeToStr(Now)+' ]--');
  while Copy(Retorno,2,1) <> ']' do
  begin
     Form7.Label5.Caption:='Recebendo linha:'+Copy(Retorno,3,4);
     Form7.Refresh;
     //     form7.statusBar1.Simpletext:=Retorno;
     if Copy(Retorno,2,1) <> ']' then
        Writeln(t,Copy(Retorno,7,Length(Retorno)-7));
     Retorno:=_ecf06_TXRX(Form1.sPorta,10,'.++');
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


//Function _ecf06_TXRX(pP1:String;pP2:integer;pP3:String):string;
//               // porta      tempo      comando
//var
//  F:TextFile;
//begin
//  Result:=TXRX(StrToInt(Right(pP1,1)),pP2,pP3);
//  AssignFile(F,'RespApf.txt');
//  Reset(F);
//  ReadLn(F,S);
//  CloseFile(F);
//  if Pos('ERRO:',S) > 0 then Result:=StrToInt('0'+AllTrim(Copy(S,Pos('ERRO:',S)+5, Pos('}',S)-(Pos('ERRO:',S)+5))));
//end;

Function _ecf06_TXRX(pP1:String;pP2:integer;pP3:String):string;
               // porta      tempo      comando
var
  F:TextFile;
begin
  Result:='';
  if TXRX(StrToInt(Right(pP1,1)),pP2,pP3) = 0 then
   begin
      if FileExists('RespApf.txt') then
       begin
          AssignFile(F,'RespApf.txt');
          Reset(F);
          ReadLn(F,Result);
          CloseFile(F);
          if Pos('ERRO:',Result) > 0 then
             if (pP3='.23') then
              begin
                Result:='ERRO: 99 '+Result;
              end
             else
                // se for erro 99 troca pelo erro 7
                if StrToInt('0'+AllTrim(Copy(Result,Pos('ERRO:',Result)+5, Pos('}',Result)-(Pos('ERRO:',Result)+5))))=99 then
                   Result:='ERRO: 07'
                else
                  Result:=_ecf06_CodeErro(StrToInt('0'+AllTrim(Copy(Result,Pos('ERRO:',Result)+5, Pos('}',Result)-(Pos('ERRO:',Result)+5)))));
       end
      else
       _ecf06_CodeErro(99);
   end
  else
    if (pP3='.23') then
      begin
        Result:='ERRO: 99';
      end
    else
       _ecf06_CodeErro(99);
//  if Pos('ERRO:',S) > 0 then Result:=StrToInt('0'+AllTrim(Copy(S,Pos('ERRO:',S)+5, Pos('}',S)-(Pos('ERRO:',S)+5))));
end;

function _ecf06_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean; //iP2 = Número do Cupom vinculado
var
  I,J : Integer;
  sMod, sX,sTempo: String;
  Mais1ini : TiniFile;
begin
  //verifica se tem cupom fiscal aberto e fecha
  sTempo:=_ecf06_TXRX(Form1.sPorta,2,'.5606');
  if (Copy(sTempo,5,1) = 'S') and (Copy(sTempo,6,1) = 'S') then
     _ecf06_TXRX(Form1.sPorta,10,'.12');//fecha c fiscal

//  Result := False;
   begin
    //le o ini para saber qual foi a modalidade
    Mais1ini  := TIniFile.Create('frente.ini');
    if Form1.ibDataSet25DIFERENCA_.AsFloat = 0 then// à vista considera Cartão
      sMod:= Mais1Ini.ReadString('Frente de caixa','Cartao','03')
    else
      sMod:= Mais1Ini.ReadString('Frente de caixa','Prazo','04');

    Mais1ini.Free; // Sandro Silva 2018-11-21 Memória 

    // Comando Para Abrir Comprovante Não Fiscal Vinculado
    Result:=(Copy(_ecf06_TXRX(Form1.sPorta,10,'.1900'+StrZero(iP2,4,0)+sMod),1,1)='.');

    if Result = True then
    begin
      Result:=(Copy(_ecf06_TXRX(Form1.sPorta,10,'.0897'),1,1)='.');//linhas em branco
    end;
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
                 if length(sX) > 42 then
                   sX:=Copy(sX,2,Length(sX)-1);
                 //
{                 tempo:='';
                 for k:=1 to Length(sX) do
                   tempo:=tempo+inttostr(ord(sx[k]))+'/';
                 showmessage(sX+chr(10)+tempo);          }
                 //
                 //imprime a linha
                 Result:=(Copy(_ecf06_TXRX(Form1.sPorta,10,'.080'+Copy(sX+Replicate(' ' ,42),1,42)),1,1)='.');
                 sX:='';
               end
              else
               begin
                 Result:=(Copy(_ecf06_TXRX(Form1.sPorta,10,'.0891'),1,1)='.');//linha em branco
                 sX:='';
               end;
            end;
        end;
      end;
      if AllTrim(sX) <> '' then
      begin
        sX:=Copy(sX,2,Length(sX)-1);
{                 tempo:='';
                 for k:=1 to Length(sX) do
                   tempo:=tempo+Inttostr(ord(sx[k]))+'/';
                 showmessage(sX+chr(10)+tempo);}
        //imprime a linha
        Result:=(Copy(_ecf06_TXRX(Form1.sPorta,10,'.080'+Copy(sX+Replicate(' ' ,42),1,42)),1,1)='.');
      end;

      //avança 7 linhas
      if Result = True then
      begin
        Result:=(Copy(_ecf06_TXRX(Form1.sPorta,10,'.0897'),1,1)='.');//linhas em branco
      end;

      if Result = True then sleep(2500); // Da um tempo

      if Result = True then
      begin
        Result:=(Copy(_ecf06_TXRX(Form1.sPorta,10,'.0897'),1,1)='.');//linhas em branco
      end;
    end;
    //fecha o comprovante não fiscal
    Result:=(Copy(_ecf06_TXRX(Form1.sPorta,10,'.12'),1,1)='.');
  end;
end;

function _ecf06_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
var
  I, J : Integer;
  sX,sTempo: String;
begin
  //verifica se tem cupom fiscal aberto e fecha
  sTempo:=_ecf06_TXRX(Form1.sPorta,2,'.5606');
  if (Copy(sTempo,5,1) = 'S') and (Copy(sTempo,6,1) = 'S') then
     _ecf06_TXRX(Form1.sPorta,10,'.12');//fecha c fiscal
  //
   begin
    //leitura X com relatorio Gerencial
    Result:=(Copy(_ecf06_TXRX(Form1.sPorta,60,'.13S'),1,1)='.');
    if Result = True then
    begin
      Result:=(Copy(_ecf06_TXRX(Form1.sPorta,10,'.0897'),1,1)='.');//linhas em branco
    end;
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
                 if length(sX) > 42 then
                   sX:=Copy(sX,2,Length(sX)-1);
                 //imprime a linha
                 Result:=(Copy(_ecf06_TXRX(Form1.sPorta,10,'.080'+Copy(sX+Replicate(' ' ,42),1,42)),1,1)='.');
                 sX:='';
               end
              else
               begin
                 Result:=(Copy(_ecf06_TXRX(Form1.sPorta,10,'.0891'),1,1)='.');//linha em branco
                 sX:='';
               end;
            end;
        end;
      end;
      if AllTrim(sX) <> '' then
      begin
        sX:=Copy(sX,2,Length(sX)-1);
        //imprime a linha
        Result:=(Copy(_ecf06_TXRX(Form1.sPorta,10,'.080'+Copy(sX+Replicate(' ' ,42),1,42)),1,1)='.');
      end;

      //avança 7 linhas
      if Result = True then
      begin
        Result:=(Copy(_ecf06_TXRX(Form1.sPorta,10,'.0897'),1,1)='.');//linhas em branco
      end;

      if Result = True then sleep(2500); // Da um tempo

      if Result = True then
      begin
        Result:=(Copy(_ecf06_TXRX(Form1.sPorta,10,'.0897'),1,1)='.');//linhas em branco
      end;
    end;
    //fecha o relatório gerencial
    Result:=(Copy(_ecf06_TXRX(Form1.sPorta,10,'.08'),1,1)='.');
  end;
end;

function _ecf06_FechaCupom2(sP1: Boolean): Boolean;
var
  sTempo:string;
begin
  //
  // se estiver em relatório gerencial fecha o mesmo, senão fecha o vinculado
  sTempo:=_ecf06_TXRX(Form1.sPorta,2,'.5605');
  if (Copy(sTempo,5,1) = 'S') then
     Result:=(Copy(_ecf06_TXRX(Form1.sPorta,10,'.08'),1,1)='.')
  else
   begin
     sTempo:=_ecf06_TXRX(Form1.sPorta,2,'.5606');
     if (Copy(sTempo,5,1) = 'S') and (Copy(sTempo,7,1) = 'S') then
       //fecha o comprovante não fiscal
       Result:=(Copy(_ecf06_TXRX(Form1.sPorta,10,'.12'),1,1)='.')
     else
       Result:=true;
{     //avança 5 linhas
     if Result = True then
     begin
       Result:=(Copy(_ecf06_TXRX(Form1.sPorta,10,'.0895'),1,1)='.');//linhas em branco
     end;}
   end;
end;

function _ecf06_ImprimeCheque(rP1: Real; sP2: String): Boolean;
begin
  Result := False;
  if AllTrim(Form1.ibDataSet13.FieldByname('MUNICIPIO').AsString) <> '' then
    begin
      ShowMessage('Posicione o cheque na impressora, e tecle <enter>. '+sP2);
      //
      Result := True;

{      if _ecf06_codeErro(_ecf06_FormataTx(
      ConverteAcentos(Chr(27)+'|57|'+sP2+'|'+StrZero(rP1*100,14,0)+'|'
      +Form1.ibDataSet13.FieldByname('NOME').AsString+'|'
      +AllTrim(Form1.ibDataSet13.FieldByname('MUNICIPIO').AsString)+'|'
      +StrZero(Day(Date),2,0)+'| '
      +AllTrim(MesExtenso(Month(Date)))+'|  '
      +Right(Strzero(Year(Date),4,0),2)+'||'+Chr(27))
      )) <> 0 then Result := False; }

      _ecf06_TXRX(Form1.sPorta,2,'.5901'+ConverteAcentos(Form1.ibDataSet13.FieldByname('NOME').AsString));//favorecido
      _ecf06_TXRX(Form1.sPorta,2,'.5902'+ConverteAcentos(Form1.ibDataSet13.FieldByname('MUNICIPIO').AsString));//município
      _ecf06_TXRX(Form1.sPorta,2,'.5903'+StrZero(Day(Date),2,0)+StrZero(Month(Date),2,0)+Right(Strzero(Year(Date),4,0),2));//data DDMMAA
      _ecf06_TXRX(Form1.sPorta,2,'.5904'+StrZero(rP1*100,12,0));//valor
      _ecf06_TXRX(Form1.sPorta,2,'.5907'+'real');//Moeda singular
      _ecf06_TXRX(Form1.sPorta,2,'.5908'+'reais');//Moeda plural
      _ecf06_TXRX(Form1.sPorta,30,'.5909'+sP2+'S');//Número do banco imprime Barras


      ShowMessage('Retire o cheque na impressora, e tecle <enter>.');
    end
  else
     ShowMessage('O município do emitente não está preenchido.');
  //

end;

function _ecf06_GrandeTotal(sP1: Boolean): String;//
begin
  Result := '0';
  Result:=Copy(_ecf06_TXRX(Form1.sPorta,2,'.271'),20,17);
end;

function _ecf06_TotalizadoresDasAliquotas(sP1: Boolean): String;
var
  i : Integer;
  pRetorno : String;
begin
  Result := '';
  // Total Tributário 1
  pRetorno:=_ecf06_TXRX(Form1.sPorta,2,'.272');
  Result:='00'+Copy(pRetorno,98,12); //coloquei 2 zeros a esq para completar 14 dígitos

  // Total Tributário 2 a 8
  pRetorno:=_ecf06_TXRX(Form1.sPorta,2,'.273');

  //deleta o ultimo caracter que é um }
  delete(pRetorno,Length(pRetorno),1);
  delete(pRetorno,1,7);//deleta os 7 primeiros dígitos
  for I:= 1 to 7 do
  begin
    if (Copy(pRetorno,1,1)<>'0') then //if (Copy(pRetorno,1,1)<>'S') and (Copy(pRetorno,1,1)<>'0') then
       Result:=Result+'00'+Copy(pRetorno,4,12)
    else
       Result:=Result+Replicate('0',14);
    //
    if Copy(pRetorno,1,3)='000' then
      delete(pRetorno,1,12)
    else
      delete(pRetorno,1,15);
  end;

  // Total Tributário 9 a 15
  pRetorno:=_ecf06_TXRX(Form1.sPorta,2,'.274');

  //deleta o ultimo caracter que é um }
  delete(pRetorno,Length(pRetorno),1);
  delete(pRetorno,1,7);//deleta os 7 primeiros dígitos
  for I:= 1 to 7 do
  begin
    if (Copy(pRetorno,1,1)<>'0') then  //(Copy(pRetorno,1,1)<>'S') and (Copy(pRetorno,1,1)<>'0') then
       Result:=Result+'00'+Copy(pRetorno,4,12)
    else
       Result:=Result+Replicate('0',14);
    //
    if Copy(pRetorno,1,3)='000' then
      delete(pRetorno,1,12)
    else
      delete(pRetorno,1,15);
  end;

  Result:=Result+Replicate('0',14);//como só tem 15 alíq. e deve ter 16 complementa com 1 X 14 zeros
  //
  //isento
  pRetorno:=_ecf06_TXRX(Form1.sPorta,2,'.272');
  Result:=Result+'00'+Copy(pRetorno,19,12); //coloquei 2 zeros a esq para completar 14 dígitos
//  showmessage(Result);
  //não incidência
  Result:=Result+'00'+Copy(pRetorno,31,12); //coloquei 2 zeros a esq para completar 14 dígitos
  //substituição
  Result:=Result+'00'+Copy(pRetorno,43,12); //coloquei 2 zeros a esq para completar 14 dígitos
  showmessage(Result+chr(10)+inttostr(length(Result)));
end;

function _ecf06_CupomAberto(sP1: Boolean): boolean;
var
  sTempo:string;
begin
   if _ecf06_VersodoFirmware(True)= '1.02' then
      Result:=False
   else
     begin
       //verifica se tem relatório gerencial aberto e fecha
       sTempo:=_ecf06_TXRX(Form1.sPorta,2,'.5605');
       if (Copy(sTempo,5,1) = 'S') then
          _ecf06_TXRX(Form1.sPorta,10,'.08');

       //verifica se tem cupom vinculado aberto e fecha
       sTempo:=_ecf06_TXRX(Form1.sPorta,2,'.5606');
       if (Copy(sTempo,5,1) = 'S') and (Copy(sTempo,7,1) = 'S') then
         //fecha o comprovante não fiscal
         _ecf06_TXRX(Form1.sPorta,10,'.12');

       //showmessage(stempo);
       Result:=((Copy(sTempo,5,1) = 'S') and (Copy(sTempo,6,1)='S'));
     end;
end;

function _ecf06_FaltaPagamento(sP1: Boolean): boolean;
var
  sTempo:string;
begin
   if _ecf06_VersodoFirmware(True)= '1.02' then
      Result:=False
   else
     begin
       sTempo:=_ecf06_TXRX(Form1.sPorta,2,'.5608');
       Result:=((Copy(sTempo,5,1) = 'S') or (Copy(sTempo,6,1)='S'));
       if not Result then
       begin
         sTempo:=_ecf06_TXRX(Form1.sPorta,2,'.52M8390');
         //A resposta será:
         //.+M status(32)
         //No status(1):
         //O status(1) está na faixa: "0","1", .. ,"F"
         if _ecf06_VersodoFirmware(True)= '1.04' then
          begin
             //Na versao 01.04 isto é verdade apenas para o acrescimo. Pode-se verificar o desconto, comparando-se o bruto e o líquido do cupom no <esc>.28}
            Result:=(Copy(Right(IntToBin(StrToInt('$'+Copy(sTempo,4,1))),3),1,1)='1');
          end
         else
          begin
            //bit 3 =1 se houve desconto
            //bit 2 =1 se houve acréscimo
            //showmessage(sTempo+chr(10)+Right(IntToBin(StrToInt('$'+Copy(sTempo,4,1))),3));
            Result:=(Copy(Right(IntToBin(StrToInt('$'+Copy(sTempo,4,1))),4),1,1)='1') or
               (Copy(Right(IntToBin(StrToInt('$'+Copy(sTempo,4,1))),3),1,1)='1');
          end;
       end;
     end;
end;

end.






