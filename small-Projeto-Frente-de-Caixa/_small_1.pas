unit _Small_1;

interface

uses

  Windows, Messages, SmallFunc_xe, Fiscal, SysUtils,Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Mask, Grids, DBGrids, DB, DBCtrls, SMALL_DBEdit, IniFiles,
  Unit2, ShellApi, Unit22;

  function _ecf01_CodeErro(Pp1: Integer):Integer;
  function _ecf01_Inicializa(Pp1: String):Boolean;
  function _ecf01_Pagamento(Pp1: Boolean):Boolean;
  function _ecf01_FechaCupom(Pp1: Boolean):Boolean;
  function _ecf01_CancelaUltimoItem(Pp1: Boolean):Boolean;
  function _ecf01_SubTotal(Pp1: Boolean):Real;
  function _ecf01_AbreGaveta(Pp1: Boolean):Boolean;
  function _ecf01_Sangria(Pp1: Real):Boolean;
  function _ecf01_Suprimento(Pp1: Real):Boolean;
  function _ecf01_NovaAliquota(Pp1: String):Boolean;
  function _ecf01_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
  function _ecf01_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
  function _ecf01_CancelaUltimoCupom(Pp1: Boolean):Boolean;
  function _ecf01_AbreNovoCupom(Pp1: Boolean):Boolean;
  function _ecf01_NumeroDoCupom(Pp1: Boolean):String;
  function _ecf01_CancelaItemN(pP1, pP2: String):Boolean;
  function _ecf01_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
  function _ecf01_ReducaoZ(pP1: Boolean):Boolean;
  function _ecf01_LeituraX(pP1: Boolean):Boolean;
  function _ecf01_RetornaVerao(pP1: Boolean):Boolean;
  function _ecf01_LigaDesLigaVerao(pP1: Boolean):Boolean;
  function _ecf01_VersodoFirmware(pP1: Boolean): String;
  function _ecf01_NmerodeSrie(pP1: Boolean): String;
  function _ecf01_CGCIE(pP1: Boolean): String;
  function _ecf01_Cancelamentos(pP1: Boolean): String;
  function _ecf01_Descontos(pP1: Boolean): String;
  function _ecf01_ContadorSeqencial(pP1: Boolean): String;
  function _ecf01_Nmdeoperaesnofiscais(pP1: Boolean): String;
  function _ecf01_NmdeCuponscancelados(pP1: Boolean): String;
  function _ecf01_NmdeRedues(pP1: Boolean): String;
  function _ecf01_Nmdeintervenestcnicas(pP1: Boolean): String;
  function _ecf01_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
  function _ecf01_Clichdoproprietrio(pP1: Boolean): String;
  function _ecf01_NmdoCaixa(pP1: Boolean): String;
  function _ecf01_Nmdaloja(pP1: Boolean): String;
  function _ecf01_Moeda(pP1: Boolean): String;
  function _ecf01_Dataehoradaimpressora(pP1: Boolean): String;
  function _ecf01_Datadaultimareduo(pP1: Boolean): String;
  function _ecf01_Datadomovimento(pP1: Boolean): String;
  function _ecf01_Tipodaimpressora(pP1: Boolean): String;
  function _ecf01_StatusGaveta(Pp1: Boolean):String;
  function _ecf01_RetornaAliquotas(pP1: Boolean): String;
  function _ecf01_Vincula(pP1: String): Boolean;
  function _ecf01_FlagsDeISS(pP1: Boolean): String;
  function _ecf01_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
  function _ecf01_MudaMoeda(pP1: String): Boolean;
  function _ecf01_MostraDisplay(pP1: String): Boolean;
  function _ecf01_leituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
  function _ecf01_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean;
  function _ecf01_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
  function _ecf01_FechaCupom2(sP1: Boolean): Boolean;
  function _ecf01_ImprimeCheque(rP1: Real; sP2: String): Boolean;
  function _ecf01_GrandeTotal(sP1: Boolean): String;
  function _ecf01_TotalizadoresDasAliquotas(sP1: Boolean): String;
  function _ecf01_CupomAberto(sP1: Boolean): boolean;
  function _ecf01_FaltaPagamento(sP1: Boolean): boolean;

var

  iCaracteres : Integer;

implementation

uses ufuncoesfrente;

// ---------------------------------- //
// ---------------------------------- //
function _ecf01_CodeErro(Pp1: Integer):Integer;
begin
  Result := 0;
end;

//-------------------------------------------//
// Detecta qual a porta que                  //
// a impressora está conectada               //
// MATRICIAL MECAF / BEMATECH MP 2000 CI NF  //
//-------------------------------------------//
function _ecf01_Inicializa(Pp1: String):Boolean;
begin
  //
  Result := True;
  //
end;

// ------------------------------ //
// Fecha o cupom que está sendo   //
// emitido                        //
// ------------------------------ //
function _ecf01_FechaCupom(Pp1: Boolean):Boolean;
begin
  //
  Result := True;
end;


// ------------------------------ //
// Formas de pagamento            //
// ------------------------------ //
function _ecf01_Pagamento(Pp1: Boolean):Boolean;
begin
  Result := True;
end;

// ------------------------------ //
// Cancela o último item          //
// ------------------------------ //
function _ecf01_CancelaUltimoItem(Pp1: Boolean):Boolean;
begin
  Result := True;
end;

function _ecf01_CancelaUltimoCupom(Pp1: Boolean):Boolean;
begin
  Result := True;
end;

function _ecf01_SubTotal(Pp1: Boolean):Real;
begin
  //
  if Form1.fTotal > 999999.98 then
  begin
    Result := 0
  end else
  begin
    Result := Form1.fTotal;
  end;
end;

// ------------------------------ //
// Abre um novo copom fiscal      //
// ------------------------------ //
function _ecf01_AbreNovoCupom(Pp1: Boolean):Boolean;
begin
  //
  Result := True;
  with Form1 do
  begin
    //
    iCupom := StrToInt(_ecf01_NumeroDoCupom(False));
    //

    if (Copy(Form1.sConcomitante,1,5) <> 'CONTA')
      and (Copy(Form1.sConcomitante,1,4) <> 'MESA') then // 2015-09-10
    begin
      Memo1.Lines.Add('Mesa número: '+IntToStr(Form1.iMesaAberta));
    end;
    // ------------------------------------------------------- //
    // Botão finaliza fica desabilitado até não fechar o Cupom //
    // ------------------------------------------------------- //
    Button7.Enabled := False;
    Button2.Enabled := False;
    Button4.Enabled := False;
    Button9.Enabled := False;
    Button18.Enabled  := True;
  end;
  //
end;

// -------------------------------- //
// Retorna o número do Cupom        //
// -------------------------------- //
function _ecf01_NumeroDoCupom(Pp1: Boolean):String;
begin
  //
  Result := FormataNumeroDoCupom(Form1.iMesaAberta); // Sandro Silva 2021-12-02 Result := StrZero(Form1.iMesaAberta,6,0);
  //
end;

// ------------------------------ //
// Cancela um item N              //
// ------------------------------ //
function _ecf01_CancelaItemN(pP1, pP2 : String):Boolean;
begin
  //
  Result := True
  //
end;

// -------------------------------- //
// Abre a gaveta                    //
// -------------------------------- //
function _ecf01_AbreGaveta(Pp1: Boolean):Boolean;
begin
  Result := True;
end;

// -------------------------------- //
// Status da gaveta                 //
// -------------------------------- //
function _ecf01_StatusGaveta(Pp1: Boolean):String;
begin
  Result := '255';
end;

// -------------------------------- //
// SAngria                          //
// -------------------------------- //
function _ecf01_Sangria(Pp1: Real):Boolean;
begin
  Result := True;
end;

// -------------------------------- //
// Suprimento                       //
// -------------------------------- //
function _ecf01_Suprimento(Pp1: Real):Boolean;
begin
  Result := True;
end;

// -------------------------------- //
// REducao Z                        //
// -------------------------------- //
function _ecf01_NovaAliquota(Pp1: String):Boolean;
begin
  Result := False;
end;

function _ecf01_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
begin
  Result := True;
end;

function _ecf01_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
begin
  Result := True;
end;


// -------------------------------- //
// Venda do Item                    //
// -------------------------------- //
function _ecf01_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
begin
  //
  Result := True;
  {Sandro Silva 2015-03-30 inicio
  Form1.fTotal := Form1.fTotal + TruncaDecimal((TruncaDecimal(Form1.ibDataSet4PRECO.AsFloat,Form1.iTrunca)*(StrToInT(pP4)/1000)),Form1.iTrunca);
  }
  // Sandro Silva 2015-03-30 - Soma o valor lançado no altera. Pode estar importando orçamento com valor alterado no orçamento
  // Sandro Silva 2015-08-04 Form1.fTotal := Form1.fTotal + TruncaDecimal((TruncaDecimal(Form1.ibDataSet27.FieldByName('UNITARIO').AsFloat,Form1.iTrunca)*(StrToInT(pP4)/1000)),Form1.iTrunca);
  Form1.fTotal := Form1.fTotal + TruncaDecimal((TruncaDecimal(Form1.ibDataSet27.FieldByName('TOTAL').AsFloat,Form1.iTrunca)),Form1.iTrunca);
  {Sandro Silva 2015-03-30 final}
  //
end;

// -------------------------------- //
// Reducao Z                        //
// -------------------------------- //
function _ecf01_ReducaoZ(pP1: Boolean):Boolean;
begin
  Result := True;
end;

// -------------------------------- //
// Leitura X                        //
// -------------------------------- //
function _ecf01_LeituraX(pP1: Boolean):Boolean;
begin
  Result := True;
end;

// ---------------------------------------------- //
// Retorna se o horario de verão está selecionado //
// ---------------------------------------------- //
function _ecf01_RetornaVerao(pP1: Boolean):Boolean;
begin
  Result := False;
end;

// -------------------------------- //
// Liga ou desliga horário de verao //
// -------------------------------- //
function _ecf01_LigaDesLigaVerao(pP1: Boolean):Boolean;
begin
  Result := False;
end;

// -------------------------------- //
// Retorna a versão do firmware     //
// -------------------------------- //
function _ecf01_VersodoFirmware(pP1: Boolean): String;
begin
  Result := 'Mesa aberta';
end;

// -------------------------------- //
// Retorna o número de série        //
// -------------------------------- //
function _ecf01_NmerodeSrie(pP1: Boolean): String;
begin
  Result := '00000000000000';
end;

// -------------------------------- //
// Retorna o CGC e IE               //
// -------------------------------- //
function _ecf01_CGCIE(pP1: Boolean): String;
begin
  Result := Form1.ibDataSet13.FieldByname('CGC').AsString+Chr(10)+Form1.ibDataSet13.FieldByname('IE').AsString;
end;

// --------------------------------- //
// Retorna o número de cancelamentos //
// --------------------------------- //
function _ecf01_Cancelamentos(pP1: Boolean): String;
begin
  Result := '0';
end;


// -------------------------------- //
// Retorna o valor de descontos     //
// -------------------------------- //
function _ecf01_Descontos(pP1: Boolean): String;
begin
  Result := '0';
end;

// -------------------------------- //
// Retorna o contados sequencial    //
// -------------------------------- //
function _ecf01_ContadorSeqencial(pP1: Boolean): String;
begin
  Result := '0';
end;

// -------------------------------- //
// Retorna o número de operações    //
// não fiscais acumuladas           //
// -------------------------------- //
function _ecf01_Nmdeoperaesnofiscais(pP1: Boolean): String;
begin
  Result := '';
end;

function _ecf01_NmdeCuponscancelados(pP1: Boolean): String;
begin
  Result := '';
end;

function _ecf01_NmdeRedues(pP1: Boolean): String;
begin
  Result := '';
end;

function _ecf01_Nmdeintervenestcnicas(pP1: Boolean): String;
begin
  Result := '';
end;

function _ecf01_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
begin
  Result := '';
end;

function _ecf01_Clichdoproprietrio(pP1: Boolean): String;
begin
  Result := Form1.ibDataSet13.FieldByname('NOME').AsString+Chr(10)+
            Form1.ibDataSet13.FieldByname('CGC').AsString+Chr(10)+
            AllTrim(Form1.ibDataSet2.FieldByname('ENDERE').AsString)+' '+AllTrim(Form1.ibDataSet2.FieldByname('COMPLE').AsString)+Chr(10)+
            Form1.ibDataSet13.FieldByname('CEP').AsString+Form1.ibDataSet13.FieldByname('CIDADE').AsString+' - '+Form1.ibDataSet13.FieldByname('ESTADO').AsString+Chr(10);
end;

// ------------------------------------ //
// Importante retornar apenas 3 dígitos //
// Ex: 001                              //
// ------------------------------------ //
function _ecf01_NmdoCaixa(pP1: Boolean): String;
begin
  //
  Result := StrZero(Form1.iMEsaAberta,3,0);
  //
end;

function _ecf01_Nmdaloja(pP1: Boolean): String;
begin
  Result := '999';
end;

function _ecf01_Moeda(pP1: Boolean): String;
begin
  Result := Copy(FormatSettings.CurrencyString,1,1);
end;

function _ecf01_Dataehoradaimpressora(pP1: Boolean): String;
begin
  FormatSettings.ShortDateFormat := 'dd/mm/yy';   {Bug 2001 free}
  Result := StrTran(StrTran(Copy(DateToStr(Date),1,8)+TimeToStr(Time),'/',''),':','');
  FormatSettings.ShortDateFormat := 'dd/mm/yyyy';   {Bug 2001 free}
end;

function _ecf01_Datadaultimareduo(pP1: Boolean): String;
begin
  Result := '00/00/0000';
end;

function _ecf01_Datadomovimento(pP1: Boolean): String;
begin
  Result := '00/00/0000';
end;

function _ecf01_Tipodaimpressora(pP1: Boolean): String;
begin
  Result := 'Mesa aberta';
end;

// Deve retornar uma String com:                                          //
// Os 2 primeiros dígitos são o número de aliquotas gravadas: Ex 16       //
// os póximos de 4 em 4 são as aliquotas Ex: 1800                         //
// Ex: 161800120005000000000000000000000000000000000000000000000000000000 //
function _ecf01_RetornaAliquotas(pP1: Boolean): String;
begin
  Result := Replicate('0',72);
end;

function _ecf01_Vincula(pP1: String): Boolean;
begin
  Result := False;
end;


function _ecf01_FlagsDeISS(pP1: Boolean): String;
begin
  Result := chr(0)+chr(0);
end;

function _ecf01_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
begin
  Result := True;
end;

function _ecf01_MudaMoeda(pP1: String): Boolean;
begin
  Result := True;
end;

function _ecf01_MostraDisplay(pP1: String): Boolean;
begin
  Result := True;
end;

function _ecf01_leituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
begin
  Result := True;
end;

function _ecf01_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean;
begin
  Result := True;
end;

function _ecf01_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
begin
  Result := True;
end;

function _ecf01_FechaCupom2(sP1: Boolean): Boolean;
begin
  Result := True;
end;

function _ecf01_ImprimeCheque(rP1: Real; sP2: String): Boolean;
begin
  Result := False;
end;

function _ecf01_GrandeTotal(sP1: Boolean): String;
begin
  Result := Replicate('0',18);
end;

function _ecf01_TotalizadoresDasAliquotas(sP1: Boolean): String;
begin
  Result := Replicate('0',438);
end;

function _ecf01_CupomAberto(sP1: Boolean): boolean;
begin
  //
  // Mesa Aberta
  //
  Form1.IBQuery1.Close;
  Form1.IBQuery1.SQL.Clear;
  Form1.IBQuery1.SQL.Add('select * from ALTERACA where PEDIDO = '+QuotedStr(FormataNumeroDoCupom(Form1.iMesaAberta))+' and (TIPO=''MESA'' or TIPO=''DEKOL'')'); // Sandro Silva 2021-12-01 Form1.IBQuery1.SQL.Add('select * from ALTERACA where PEDIDO = '+QuotedStr(StrZero(Form1.iMesaAberta,6,0))+' and (TIPO=''MESA'' or TIPO=''DEKOL'')');
  {Sandro Silva 2011-09-06 final}
  Form1.IBQuery1.Open;
  //
  if Form1.IBQuery1.FieldByName('PEDIDO').AsString = FormataNumeroDoCupom(Form1.iMesaAberta) then // Sandro Silva 2021-12-01 if Form1.IBQuery1.FieldByName('PEDIDO').AsString = StrZero(Form1.iMesaAberta,6,0) then
  begin
    Result := True;
  end else
  begin
    Result := False;
  end;
end;

function _ecf01_FaltaPagamento(sP1: Boolean): boolean;
begin
  Result := False;
end;

end.






