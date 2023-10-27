//                                                                     //
//                                                                     //
//   _____  __  __  _____  __     __     _____  _____  _____  ______   //
//  /  ___>|  \/  |/  _  \|  |   |  |   /  ___>/     \|  ___||_    _|  //
//  \___  \|      ||  _  ||  |__ |  |__ \___  \|  |  ||  __|   |  |    //
//  <_____/|_|\/|_|\_/ \_/|_____||_____|<_____/\_____/|__|     |__|    //
//                                                                     //
//  All rights reserved                                                //
//                                                                     //



unit SmallFunc;

interface

uses
  SysUtils,{BDE,} DB,dialogs,windows, printers,  xmldom, XMLIntf, MsXml,
  msxmldom, XMLDoc, inifiles, dateutils, Registry, uTestaEmail, Classes, StdCtrls,
  ShellAPI, jpeg, TLHelp32;

// Sandro Silva 2022-12-22  var sDocParaGerarPDF : String;
  function RetornaNomeDoComputador : string;
  function DateToStrInvertida(Data:TdateTime): String;
  function SMALL_Tempo(pP1:Integer):Integer;
  function Potencia(pP1,pP2:Integer):Integer;
  function IntToBin(pP1:Integer ):String;
  function BinToInt(pP1:String ):Integer;
  function TrimDuplicados(AcTexto: String):String;
  function AllTrim(pP1:String):String;
  function AllTrimCHR(pP1:String; pP2:String):String;
  function RTrim(pP1:String):String;
  function PrimeiraMaiuscula(pP1:String):String;
  function Replicate(pP1:String; pP2:Integer):String;
  function LimpaNumero(pP1:String):String;
  function LimpaLetras(pP1:String):String;
  function LimpaNome(pP1:String):String;
  function LimpaLetrasPor_(pP1:String):String;
  function CpfCgc(pP1:String):boolean;
  function ConverteCpfCgc(pP1:String):String;
  function ConverteAcentos(pP1:String):String;
  function ConverteAcentos2(pP1:String):String;
  function ConverteAcentosNome(pP1:String):String;
  function ConverteAcentos3(pP1:String):String;
  function ConverteAcentosIBPT(pP1:String):String;
  function ConverteAcentosPHP(pP1:String):String;
  function ConverteCaracterEspecialXML(Value: String): String;  
  function Bisexto(AAno: Integer): Boolean;
  function DiasPorMes(AAno, AMes: Integer): Integer;
  function DiasDesteMes: Integer;
  function Year(Data:TdateTime): Integer;
  function Month(Data:TdateTime): Integer;
  function Day(Data:TdateTime): Integer;
  {Numeric Formatting}
  function JStrToFloat(S: String): Extended;
  function ReformatNumericString(S:String; Length, Dec : Integer):String;
  function JStoI(S:String): Integer;
  function IsNumericString(S:String):Boolean;
  function IsIntegerString(S:String): Boolean;
  function AllDigits(S: String): Boolean;
  function TrocaVirgula(S: String): String;
  function Right(S : String; numCaracteres : Byte) : String;
  function StrTran(sP1,sP2,sP3 : string):String;
  function StrTranUpper(sP1,sP2,sP3 : string):String;
  function StrZero(Num : Double ; Zeros,Deci: integer): string;
  function Extenso(pP1:double):String;
  function MesExtenso(pP1:Integer):String;
  function DiaUtil(pP1:TDateTime): Boolean;
  function DiasUteisDoMes(AAno, AMes: Integer): Integer;
  function DiasUteisDoPeriodo(pP1, pP2: TDateTime): Integer;
  function SomaDias(Data: TDateTime; Dias: Integer): TDateTime;
  function IsPrinter(X:Byte):Boolean;
  function PrinterOnLine:Boolean;
  function Cartao(pP1:String):Boolean;
  function Modulo_11_Bradesco(pP1:String):String;
  function Modulo_11(pP1:String):String;
  function Modulo_11_Febraban(pP1:String):String;
  Function Modulo_11_BB(pP1:String):String;
  function Modulo_Duplo_Digito_Banrisul(pP1:String):String;
  function Modulo_10(pP1:String):String;
  function Modulo_SICOOB(pP1:String):String;
  function TimeToFloat(pTempo:String):Double;
  function SMALL_NumeroDeCores:integer;
  function VerificaSeTemImpressora():Boolean;
  function SMALL_2of5(sP : String): String;
  function SMALL_2of5_2(sP : String): String;
  function Arredonda(fP1 : Real; iP2 : Integer): Real;
  function Arredonda2(fP1 : Double; iP2 : Integer): Double;
  function LimpaNumeroDeixandoAVirgula(pP1:String):String;
  function LimpaNumeroDeixandoOponto(pP1:String):String;
  function DiaDaSemana(pP1:TDateTime):String;
  function RetornaOperadora(sNumero: String): String;
  function WinVersion: string;
  function CorrentPrinter :String; //Declare a unit Printers na clausula uses
  function FormataCpfCgc(pP1:String):String;
  function FormataCEP(P1:String) : String;
  function FORMATA_TELEFONE(Fone:String):String;
  function ZeroESQ(sP1 : string):String;
  function LimpaNumeroVirg(pP1:String):String;
  function LimpaNumeroDeixandoABarra(pP1:String):String;
//  function ValidaEAN13(sP1:String):Boolean;
  function ValidaEAN(AGTIN:String):Boolean;
  function xmlNodeValue(sXML: String; sNode: String): String;
  function TruncaDecimal(pP1: Real; pP2: Integer): Real;
  procedure FecharAplicacao(sNomeExecutavel: String);
  function CaracteresHTML(pP1:String):String;
  function Endereco_Sem_Numero(sP1:String): String;
  function Numero_Sem_Endereco(sP1:String): String;
  {Sandro Silva 2023-10-16 inicio}
  function ExtraiEnderecoSemONumero(Texto: String): String;
  function ExtraiNumeroSemOEndereco(Texto: String): String;  
  {Sandro Silva 2023-10-16 fim}
  function FusoHorarioPadrao(UF: String): String;
  function DefineFusoHorario(ArquivoIni: String; SecaoIni: String; ChaveIni: String; sUF: String; sFuso: String; bHorarioVerao: Boolean): String;
  function HabilitaHorarioVerao(ArquivoIni: String; SecaoIni: String; ChaveIni: String; sUF: String; bHabilita: Boolean): String;
  function ValidaEmail(AcEmail: String): Boolean;
  function RetornaListaQuebraLinha(AcTexto: string; AcCaracQuebra: String = ';'): TStringList;
  procedure ValidaValor(Sender: TObject; var Key: Char; tipo: string);
  procedure ValidaAceitaApenasUmaVirgula(edit: TCustomEdit; var Key: Char);
  // Sandro Silva 2023-09-22 function HtmlToPDF(AcArquivo: String): Boolean;
  function processExists(exeFileName: string): Boolean;
  function ConsultaProcesso(sDescricao:String): boolean;

implementation

uses uITestaEmail, StrUtils;

function RetornaNomeDoComputador : string;
var
  registro : tregistry;
begin
  registro:=tregistry.create;
  registro.RootKey:=HKEY_LOCAL_MACHINE;
  registro.openkey('SystemCurrentControlSetServicesVXDVNETSUP',false);
  result:=registro.readstring('ComputerName');
end;


function FusoHorarioPadrao(UF: String): String;
// Retorna o fuso horário padrão para a UF
// Abaixo as UF estão ordenadas por região (Sul, sudeste, Centro-Oeste, Norte, Nordeste)
begin
  Result := '';
  UF := AnsiUpperCase(UF);
  //Sul
  if UF = 'RS' then // Rio Grande do Sul
    Result := '-03:00';
  if UF = 'SC' then // Santa Catarina
    Result := '-03:00';
  if UF = 'PR' then // Paraná
    Result := '-03:00';

  //Sudeste
  if UF = 'SP' then // São Paulo
    Result := '-03:00';
  if UF = 'RJ' then // Rio de Janeiro
    Result := '-03:00';
  if UF = 'MG' then // Minas Gerais
    Result := '-03:00';
  if UF = 'ES' then //Espírito Santo
    Result := '-03:00';

  //Centro-Oeste
  if UF = 'GO' then // Goiás
    Result := '-03:00';
  if UF = 'MT' then //Mato Grosso
    Result := '-04:00';
  if UF = 'MS' then // Mato Grosso do Sul
    Result := '-04:00';
  if UF = 'DF' then // Brasília (DF)    Hora Legal
    Result := '-03:00';

  //Norte
  if UF = 'AM' then // Amazonas
    Result := '-04:00';
  if UF = 'AP' then // Amapá
    Result := '-03:00';
  if UF = 'AC' then // Acre
    Result := '-05:00';
  if UF = 'PA' then // Pará
    Result := '-03:00';
  if UF = 'RO' then // Rondônia
    Result := '-04:00';
  if UF = 'RR' then // Roraima
    Result := '-04:00';
  if UF = 'TO' then // Tocantins
    Result := '-03:00';

  //Nordeste
  if UF = 'AL' then // Alagoas
    Result := '-03:00';
  if UF = 'BA' then // Bahia
    Result := '-03:00';
  if UF = 'CE' then // Ceará
    Result := '-03:00';
  if UF = 'MA' then // Maranhão
    Result := '-03:00';
  if UF = 'PB' then // Paraíba
    Result := '-03:00';
  if UF = 'PE' then // Pernambuco
    Result := '-03:00';
  if UF = 'PI' then // Piauí
    Result := '-03:00';
  if UF = 'RN' then // Rio Grande do Norte
    Result := '-03:00';
  if UF = 'SE' then // Sergipe
    Result := '-03:00';

  //Exterior
  if UF = 'EX' then // Sergipe
    Result := '-03:00';
end;

function DefineFusoHorario(ArquivoIni: String; SecaoIni: String; ChaveIni: String; sUF: String; sFuso: String; bHorarioVerao: Boolean): String;
// Define o fuso horário no arquivo .ini de configurações
// Exemplos de uso:
// DefineFusoHorario('nfe.ini','nfe','fuso', 'SC', '', True); // Definirá automáticamente o fuso horário com -03:00, que o fuso de Santa Catarina e em seguida Habilita Horário de Verão. Usar esta maneira após usuário configurar o emitente, quando ainda não há fuso horário definido.
// DefineFusoHorario('nfe.ini','nfe','fuso', '', '-02:00'); // Desconsidera a UF e define o fuso horário que quiser. Usar esta maneira na rotina de configuração de fuso horário.
//
var
  Ini: TIniFile;
begin
  if sFuso = '' then
  begin
    sFuso := FusoHorarioPadrao(AnsiUpperCase(sUF));
  end;
  Ini := TIniFile.Create(ArquivoIni);
  Ini.WriteString(SecaoIni, ChaveIni, sFuso);
  Ini.Free;
  if bHorarioVerao then
    sFuso := HabilitaHorarioVerao(ArquivoIni, SecaoIni, ChaveIni, sUF, True);
  Result := sFuso;
end;

function HabilitaHorarioVerao(ArquivoIni: String; SecaoIni: String;
  ChaveIni: String; sUF: String; bHabilita: Boolean): String;
// Habilita ou desabilita o fuso horário para o horário de verão
// Trata apenas a condição do Brasil, onde todos os fusos são Negativos
// Exemplo de uso:
// HabilitaHorarioVerao('nfe.ini','nfe','fuso', 'SC', True); Ativa horário de verão para o fuso
// HabilitaHorarioVerao('nfe.ini','nfe','fuso', 'SC', False); Desativa horário de verão para o fuso
var
  Ini: TIniFile;
  sFuso: String;
begin

  Ini := TIniFile.Create(ArquivoIni);
  sFuso := Ini.ReadString(SecaoIni, ChaveIni, sFuso);

  if sFuso <> '' then
  begin
    sFuso := StringReplace(sFuso, '-', '', [rfReplaceAll]); // Elimina o sinal negativo

    if bHabilita then // Entrando no horário de verão
      sFuso := Copy(TimeToStr(IncHour(StrToTime(sFuso), -1)), 1, 5)
    else
      sFuso := Copy(TimeToStr(IncHour(StrToTime(sFuso), 1)), 1, 5);

    sFuso := '-' + sFuso;
  end;

  Ini.WriteString(SecaoIni, ChaveIni, sFuso);
  Ini.Free;

  Result := sFuso;
end;





procedure FecharAplicacao(sNomeExecutavel: String);
begin
  //Mais eficiente para encerrar as aplicações
  //Substitui os comandos "Application.Terminate" e "Halt(1)"
  //FecharAplicacao(ExtractFileName(Application.ExeName));
  {$IFDEF VER150}
  WinExec(PChar('TASKKILL /F /IM "'+sNomeExecutavel+'"'),SW_HIDE);
  {$ELSE}
  WinExec(PAnsiChar(AnsiString('TASKKILL /F /IM "'+sNomeExecutavel+'"')),SW_HIDE);
  {$ENDIF}
end;


function TruncaDecimal(pP1: Real; pP2: Integer): Real;
begin
  Result := pP1;
end;

function xmlNodeValue(sXML: String; sNode: String): String;
{Sandro Silva 2012-02-08 inicio
Extrai valor do elemento no xml}
var
  XMLDOM: IXMLDOMDocument;
  iNode: Integer;
  xNodes: IXMLDOMNodeList;
  function utf8Fix(sTexto: String): String;
  const
    acento : array[1..46] of string = ('á', 'à', 'â', 'ã', 'ä', 'é', 'è', 'ê', 'ë', 'í', 'ì', 'î', 'ï', 'ó', 'ò', 'ô', 'õ', 'ö', 'ú', 'ù', 'û', 'ü', 'ç', 'Á', 'À', 'Â', 'Ã', 'Ä', 'É', 'È', 'Ê', 'Ë', 'Í', 'Ì', 'Î', 'Ï', 'Ó', 'Ò', 'Ô', 'Õ', 'Ö', 'Ú', 'Ù', 'Û', 'Ü', 'Ç');
    UTF8: array[1..46] of string = ('Ã¡','Ã ','Ã¢','Ã£','Ã¤','Ã©','Ã¨','Ãª','Ã«','Ã­','Ã¬','Ã®','Ã¯','Ã³','Ã²','Ã´','Ãµ','Ã¶','Ãº','Ã¹','Ã»','Ã¼','Ã§','Ã','Ã€','Ã‚','Ãƒ','Ã„','Ã‰','Ãˆ','ÃŠ','Ã‹','Ã','ÃŒ','ÃŽ','Ã','Ã“','Ã’','Ã”','Ã•','Ã–','Ãš','Ã™','Ã›','Ãœ','Ã‡');
  var
    iLetra: Integer;
  begin
    Result := sTexto;
    for iLetra := 1 to length(utf8) do
    begin
      if Pos(UTF8[iLetra], Result) > 0 then
        Result := StringReplace(Result, utf8[iLetra], acento[iLetra], [rfReplaceAll]);
    end;
  end;
begin
  Result := EmptyStr;
  
  XMLDOM := CoDOMDocument.Create;
  XMLDOM.loadXML(sXML);

  xNodes := XMLDOM.selectNodes(sNode);
  for iNode := 0 to xNodes.length -1 do
  begin
    Result := utf8Fix(xNodes.item[iNode].text);
  end;

  XMLDOM := nil;
end;

function LimpaNumeroVirg(pP1:String):String;
var
   I:Integer;
begin
   Result:='';
   for I := 1 to length(pP1) do
   begin
     if Pos(Copy(pP1,I,1),'0123456789,.') > 0 then
        Result:=Result+Copy(pP1,I,1);
   end;
end;


function ZeroESQ(sP1 : string):String;
begin
   if sp1 <> '' then
   Result := FLOATTOSTR(STRTOFLOAT(LimpaNumeroVirg('0'+sP1)))
   else
   Result := '';
end;
 
function FORMATA_TELEFONE(Fone:String):String;
var
  sFon : String;
begin
    if LimpaNumero(Fone) <> '0' then
    begin
      sFon := ZeroESQ( LimpaNumero(Fone));
      If Length(sFon) > 10 then
      begin
//        Fone :='';
        if Pos(',',sFon)>0 then
          sFon := LimpaNumero(Copy(sFon,1,11))
        else
          sFon := LimpaNumero(Copy(sFon,1,10));
        ////
        sFon := trim('(0xx'+Copy(sFon,1,2)+')'+Copy(sFon,3,15));
        Fone := sFon;
      end else
      If Length(sFon) = 10 then
      begin
        sFon := trim('(0xx'+Copy(sFon,1,2)+')'+Copy(sFon,3,15));
        Fone := sFon;
      end else
      If Length(sFon) = 9 then
      begin
        sFon := trim('(0xx'+Copy(sFon,1,2)+') '+Copy(sFon,3,15));
        Fone := sFon;
      end else
      begin
      If Length(sFon) < 9 then
        sFon := trim('(0xx00)'+Copy(sFon,1,15));
        Fone := sFon;
      end;
    end;
  Result := Fone;
end;


function FormataCEP(P1:String) : String;
begin
  P1 := LimpaNumero(P1);
  P1 := Copy(P1,1,5)+'-'+Copy(P1,6,3);
  Result := P1;
end;


function FormataCpfCgc(pP1:String):String;
begin
   pP1 := LimpaNumero(pP1);
   if length(pP1)=14 then
      Result:=Copy(pP1,1,2)+'.'+
                  Copy(pP1,3,3)+'.'+
                  Copy(pP1,6,3)+'/'+
                  Copy(pP1,9,4)+'-'+
                  Copy(pP1,13,2)
   else
      Result:=Copy(pP1,1,3)+'.'+
                  Copy(pP1,4,3)+'.'+
                  Copy(pP1,7,3)+'-'+
                  Copy(pP1,10,2);
end;




function DateToStrInvertida(Data:TdateTime): String;
begin
  Result := Copy(DateToStr(Data),7,4)+'/'+Copy(DateToStr(Data),4,2)+'/'+Copy(DateToStr(Data),1,2);
end;


function Modulo_11_bradesco(pP1:String):String;
var
   Acumulado,I,Controle:integer;
begin
  try
    {acumula a soma da multiplicação dos digitos}
    Pp1:=alltrim(pP1);
    Controle:=2;
    Acumulado:=0;
    for I:=length(Pp1) downto 1 do
    begin
      Acumulado:=Acumulado + (StrToInt(Copy(Pp1,I,1))*Controle);
      Controle := Controle + 1;
      if Controle > 7 then Controle:=2;
    end;
    {calcula o digito}
    Acumulado:=11-(Acumulado mod 11);
    if Acumulado = 10 then
    begin
      Result := 'P';
    end else
    begin
      if Acumulado = 11 then Acumulado:=0;
      {devolve o digito de controle}
      Result:=IntToStr(Acumulado);
    end;
  except Result :='0' end;
end;


function Modulo_11(pP1:String):String;
var
   Acumulado,I,Controle:integer;
begin
   //acumula a soma da multiplicação dos digitos
   try
     Pp1:=alltrim(pP1);
     Controle:=2;
     Acumulado:=0;
     for I:=length(Pp1) downto 1 do
     begin
        Acumulado:=Acumulado + (StrToInt(Copy(Pp1,I,1))*Controle);
        Controle := Controle + 1;
        if Controle > 9 then Controle:=2;
     end;
     //calcula o digito
     Acumulado:=11-(Acumulado mod 11);
     if (Acumulado = 10) or (Acumulado = 11)  then Acumulado:=0;
     //devolve o digito de controle
     Result:=IntToStr(Acumulado);
   except Result :='0' end;
end;


Function Modulo_11_Febraban(pP1:String):String;
var
   Acumulado,I,Controle:integer;
begin
   try
     {acumula a soma da multiplicação dos digitos}
     Pp1:=alltrim(pP1);
     Controle:=2;
     Acumulado:=0;
     for I:=length(Pp1) downto 1 do
     begin
        Acumulado:=Acumulado + (StrToInt(Copy(Pp1,I,1))*Controle);
        Controle := Controle + 1;
        if Controle > 9 then Controle:=2;
     end;
     {calcula o digito}
     Acumulado:=11-(Acumulado mod 11);
     if (Acumulado > 9) or (Acumulado < 1) then Acumulado := 1;
     {devolve o digito de controle}
     Result:=IntToStr(Acumulado);
   except Result :='0' end;
end;

Function Modulo_11_BB(pP1:String):String;
var
   Acumulado,I,Controle:integer;
begin
  try
    {acumula a soma da multiplicação dos digitos}
    Pp1:=alltrim(pP1);
    Controle:=2;
    Acumulado:=0;
    for I:=length(Pp1) downto 1 do
    begin
      Acumulado:=Acumulado + (StrToInt(Copy(Pp1,I,1))*Controle);
      Controle := Controle + 1;
      if Controle > 9 then Controle:=2;
    end;
    {calcula o digito}
    Acumulado:=11-(Acumulado mod 11);
    if Acumulado = 10 then
    begin
    Result := 'X';
    end else
    begin
     if Acumulado = 11 then Acumulado:=0;
     {devolve o digito de controle}
     Result:=IntToStr(Acumulado);
    end;
  except Result :='0' end;
end;


function Modulo_Duplo_Digito_Banrisul(pP1:String):String;
var
  J, Z : Integer;
  Acumulado,I,Controle:integer;
  Primeiro_digito : String;
begin
  try
    //
    // Modulo 10
    // acumula a soma da multiplicação dos digitos
    //
    J := 0;
    Z := 2;
    //
    for I := Length(pP1) downto 1 do
    begin
     try
       if StrToInt(IntToStr( StrToInt(Copy(pP1,I,1)) * Z )) > 9 then
       begin
         J  := J  + (StrToInt( IntToStr(StrToInt(Copy(pP1,I,1)) * Z ))-9);
       end else
       begin
         J  := J  + (StrToInt( IntToStr(StrToInt(Copy(pP1,I,1)) * Z )));
       end;
     except end;
     if Z = 2 then Z := 1 else Z:= 2;
    end;
    //
    J := 10 - (J - ((J div 10)*10));
    if J >= 10 then J := 0;
    //
    // devolve o digito de controle
    //
    Primeiro_Digito := IntToStr(J);
    //
    Controle  :=2;
    Acumulado :=0;
    for I := length(pP1 + Primeiro_Digito) downto 1 do
    begin
      Acumulado:=Acumulado + (StrToInt(Copy(pP1 + Primeiro_Digito,I,1))*Controle);
      Controle := Controle + 1;
      if Controle > 7 then Controle:=2;
    end;
    //
    Acumulado := 11 - (Acumulado - ((Acumulado div 11)*11));
    if Acumulado = 11  then Acumulado:=0;
    //
    // Invalido
    //
    if (Acumulado = 10) then // or (Acumulado = 11) then
    begin
      Primeiro_Digito := IntToStr((StrToInt(Primeiro_Digito) + 1));
      if StrToInt(Primeiro_Digito) >= 10 then Primeiro_Digito := '0';
      Controle  :=2;
      Acumulado :=0;
      for I := length(pP1 + Primeiro_Digito) downto 1 do
      begin
        Acumulado:=Acumulado + (StrToInt(Copy(pP1 + Primeiro_Digito,I,1))*Controle);
        Controle := Controle + 1;
        if Controle > 7 then Controle:=2;
      end;
      Acumulado := 11 - (Acumulado - ((Acumulado div 11)*11));
      if (Acumulado = 10) or (Acumulado = 11)  then Acumulado:=0;
    end;
    //
    Result := Primeiro_Digito + IntToStr(Acumulado);
    //
  except Result :='0' end;
end;

Function Modulo_10(pP1:String):String;
var
  I, J, Z : Integer;
begin
  try
    {acumula a soma da multiplicação dos digitos}
    J := 0;
    Z := 2;
    for I := Length(pP1) downto 1 do
    begin
     //
     try
       J  := J  + StrToInt(Copy(IntToStr( StrToInt(Copy(pP1,I,1)) * Z ),1,1));
       J  := J  + StrToInt(Copy(IntToStr( StrToInt(Copy(pP1,I,1)) * Z )+'0',2,1));
     except end;
     if Z = 2 then Z := 1 else Z:= 2;
     //
    end;
    //
    J  := 10 - (J  mod 10);
    if (J  = 10) then J := 0;
    {devolve o digito de controle}
    Result:= IntToStr(J);
  except Result :='0' end;
end;

Function Modulo_SICOOB(pP1: String): String;
var
  S, I, II: integer;
  SS : Real;
begin
  //
  S    := 0;
  II   := 0;
  //
  for I := 1 to 21 do
  begin
    try
      II := II + 1;
      S := S + StrToInt(Copy(pP1,I,1)) * StrToInt(Copy('3197',II,1));
      if II = 4 then II := 0;
    except
    end;
  end;
  //
  SS := S-(Int(S div 11)*11);
  //
  if (S-(Int(S div 11)*11)=0) or (S-(Int(S div 11)*11)=1) then
  begin
    Result := '0';
  end else
  begin
    Result := FloatToStr( 11 - SS );
  end;
  //
end;


function Potencia(pP1,pP2:Integer):Integer;
var
  i:integer;
begin
//  Result:=0;
  if pP2=0 then
    Result:=1
  else
     if pP2=1 then
        Result:= pP1
     else
       begin
         Result:=pP1;
         For i:= 1 to pP2-1 do Result:=Result*pP1;
       end;
end;
{egin
  Result:=Trunc(Exp(Ln(pP1)*(pP2)));
end;}

Function IntToBin(pP1:Integer ):String;
begin
   Result := '';
   while pP1 >= 2 do
   begin
     Result := IntToStr( pP1 - pP1 div 2 * 2 ) +  Result;
     pP1 := pP1 div 2;
   end;
   Result:= IntToStr(pP1) + Result;
end;

Function BinToInt(pP1:String ):Integer;
var
  I:integer;
  sTemp:String;
begin
   Result := 0 ;
   sTemp:='';
   // inverte
   for I:= 1 to length(pP1) do sTemp:=Copy(pP1,I,1)+sTemp;
   for I:= 1 to length(sTemp) do
   begin
     if Result >= 0 then
       if (StrToInt(Copy(sTemp,I,1))) > 1 then Result:=-1 else // se o n for > 1 não é binário
          Result := Result+ (StrToInt(Copy(sTemp,I,1)) * Potencia(2,I-1));
   end;
end;

{ Dailon (f-7224) 2023-08-07 Inicio}
function TrimDuplicados(AcTexto: String):String;
begin
  Result := Trim(AcTexto);
  while Pos('  ', Result) > 0 do
    Result := StringReplace(Result, '  ', ' ', [rfReplaceAll]);
end;
{ Dailon (f-7224) 2023-08-07 Fim}

Function AllTrim(pP1:String):String;
begin
   While Copy(pP1,Length(pP1),1) = ' ' do
      pP1:=Copy(pP1,1,Length(pP1)-1);
   While Copy(pP1,1,1) = ' ' do
      pP1:=Copy(pP1,2,Length(pP1)-1);
   Result:=pP1;
end;

Function AllTrimCHR(pP1:String; pP2:String):String;
begin
   While Copy(pP1,Length(pP1),1) = pP2 do
      pP1:=Copy(pP1,1,Length(pP1)-1);
   While Copy(pP1,1,1) = pP2 do
      pP1:=Copy(pP1,2,Length(pP1)-1);
   Result:=pP1;
end;



Function RTrim(pP1:String):String;
begin
   While Copy(pP1,Length(pP1),1) = ' ' do
      pP1:=Copy(pP1,1,Length(pP1)-1);
   Result:=pP1;
end;

Function PrimeiraMaiuscula(pP1:String):String;
Var
  I:integer;

begin
   Result:=AnsiUpperCase(pP1);
   for I := 2 to length(pP1) do
   begin
      if copy(pP1,I-1,1)<> ' ' then
      begin
         if copy(pP1,I-1,1)<> '.' then
         begin
            Delete(Result,I,1);
            Insert(AnsiLowerCase(copy(pP1,I,1)),Result,I);
         end;
      end;
   end;
end;
{--- fim da função PrimeiraMaiúscula ---}

Function Replicate(pP1:String; pP2:Integer):String;
Var I:Integer;
begin
   Result:='';
   For I := 1 to pP2 do
      Result:=Copy(Result+pP1,1,I);
end;

Function CpfCgc(pP1:String):boolean;

var
I,J,K,SOMA,DIGITO : Integer;
MULT,DIGITOS,CONTROLE: String;
begin
  if length(AllTrim(pP1)) > 0 then
  begin
    DIGITO := 0;
    MULT := '543298765432';
    {se for CGC}
    if length(pP1) = 14 then
       begin
          DIGITOS := Copy(pP1, 13, 2); {dígitos informados}
          MULT := '543298765432';
          CONTROLE := '';
          {loop de verificação}
          {J := 1;}
          for J := 1 to 2 do
           begin
              SOMA := 0;
              {I := 1;}
              for I := 1 to 12 do
                SOMA := SOMA + StrToInt(Copy(pP1, I, 1))*StrToInt(Copy(Mult, I, 1));
              if J = 2 then SOMA := SOMA+(2* DIGITO);
              DIGITO := (SOMA*10) mod 11;
              if DIGITO = 10 then DIGITO := 0;
              CONTROLE := CONTROLE+IntToStr(DIGITO);
              MULT := '654329876543'
           end;
           {compara os dígitos calculados(CONTROLE)}
           {com os dígitos informados (DIGITOS)}
           if CONTROLE <> DIGITOS then
              Result := FALSE
           else
              Result := TRUE;
       end
    {se for CPF}
    else if length(pP1) = 11 then
       begin
          DIGITOS := Copy(pP1, 10, 2); {dígitos informados}
          MULT := '100908070605040302';
          CONTROLE := '';
          {loop de verificação}
          for J := 1 to 2 do
           begin
              SOMA := 0;
              K:=0; {coloquei para não dar erro}
              for I := 1 to 9 do
                begin
                   if I = 1 then K:=1
                   else
                      K:=K+2;
                   SOMA := SOMA + StrToInt(Copy(pP1, I, 1))*StrToInt(Copy(Mult, K, 2));
                end;
              if J = 2 then SOMA := SOMA+(2* DIGITO);
              DIGITO := (SOMA*10) mod 11;
              if DIGITO = 10 then DIGITO := 0;
              CONTROLE := CONTROLE+IntToStr(DIGITO);
              MULT := '111009080706050403'
           end;
           {compara os dígitos calculados(CONTROLE)}
           {com os dígitos informados (DIGITOS)}
           if CONTROLE <> DIGITOS then
              Result := FALSE
           else
              Result := TRUE;
       end
    else
       Result := FALSE;
  end
  else
     Result:= True;
end;
Function LimpaNumero(pP1:String):String;
var
   I:Integer;
begin
   Result:='';
   for I := 1 to length(pP1) do
   begin
     if Pos(Copy(pP1,I,1),'0123456789') > 0 then
        Result:=Result+Copy(pP1,I,1);
   end;
end;

Function LimpaLetras(pP1:String):String;
var
   I:Integer;
begin
   Result:='';
   for I := 1 to length(pP1) do
   begin
     if Pos(AnsiUpperCase(Copy(pP1,I,1)),'ABCDEFGHIJKLMNOPQRSTUVXZÇÀÈÌÒÙÁÉÍÓÚÂÊÎÔÛÄÏÖÜÃÕ') > 0 then
        Result:=Result+Copy(pP1,I,1);
   end;
end;

Function LimpaLetrasPor_(pP1:String):String;
var
   I:Integer;
begin
   Result:='';
   for I := 1 to length(pP1) do
   begin
     if Pos(AnsiUpperCase(Copy(pP1,I,1)),'ABCDEFGHIJKLMNOPQRSTUVXZ') > 0 then
        Result := Result+Copy(pP1,I,1) else Result := Result+'_';
   end;
end;


Function LimpaNome(pP1:String):String;
var
   I:Integer;
begin
   Result:='';
   for I := 1 to length(pP1) do
   begin
     if Pos(AnsiUpperCase(Copy(pP1,I,1)),'1234567890ABCDEFGHIJKLMNOPQRSTUVXZ') > 0 then
        Result := Result+Copy(pP1,I,1) else Result := Result+'_';
   end;
end;


Function ConverteCpfCgc(pP1:String):String;
begin
   if length(pP1)=14 then
      Result:=Copy(pP1,1,2)+'.'+
                  Copy(pP1,3,3)+'.'+
                  Copy(pP1,6,3)+'/'+
                  Copy(pP1,9,4)+'-'+
                  Copy(pP1,13,2)
   else
      Result:=Copy(pP1,1,3)+'.'+
                  Copy(pP1,4,3)+'.'+
                  Copy(pP1,7,3)+'-'+
                  Copy(pP1,10,2);
end;


function ConverteAcentos(pP1:String):String;
var
   I:Integer;
begin
   Result:=pP1;
   for I := 1 to 44 do
     Result :=  strtran( Result
                      ,copy('ÁÀÂÄÃÉÈÊËÍÎÏÓÔÕÚÜÇáàâäãåéèêëíîïìóôõòöúüùûç*º',I,1)
                      ,copy('AAAAAEEEEIIIOOOUUCaaaaaaeeeeiiiiooooouuuuc .',I,1));
end;

function ConverteAcentos3(pP1:String):String;
var
   I:Integer;
begin
   Result:=pP1;
   for I := 1 to 44 do
     Result :=  strtran( Result
                      ,copy('ÁÀÂÄÃÉÈÊËÍÎÏÓÔÕÚÜÇáàâäãåéèêëíîïìóôõòöúüùûç*º',I,1)
                      ,copy('____________________________________________',I,1));
end;


function ConverteAcentos2(pP1:String):String;
var
   I:Integer;
begin
   pP1 := ConverteAcentos(pP1);
   Result:='';
   for I := 1 to length(pP1) do
   begin
     if Pos(AnsiUpperCase(Copy(pP1,I,1)),'1234567890ABCDEFGHIJKLMNOPQRSTUVXYZW,/.-()%') > 0 then
        Result := Result+Copy(pP1,I,1) else Result := Result+' ';
   end;
end;

function ConverteAcentosNome(pP1:String):String;
var
  I:Integer;
begin
  pP1 := ConverteAcentos(pP1);
  Result:='';
  for I := 1 to length(pP1) do
  begin
    if Pos(AnsiUpperCase(Copy(pP1,I,1)),'1234567890ABCDEFGHIJKLMNOPQRSTUVXYZW,/.-()%&') > 0 then
      Result := Result+Copy(pP1,I,1)
    else
      Result := Result+' ';
  end;
end;

function ConverteAcentosIBPT(pP1:String):String;
var
   I:Integer;
begin
   pP1 := ConverteAcentos(pP1);
   Result:='';
   for I := 1 to length(pP1) do
   begin
     if Pos(AnsiUpperCase(Copy(pP1,I,1)),'1234567890ABCDEFGHIJKLMNOPQRSTUVXYZW,.;') > 0 then
        Result := Result+Copy(pP1,I,1) else Result := Result+' ';
   end;
end;

function ConverteAcentosPHP(pP1:String):String;
var
   I:Integer;
begin
   pP1 := ConverteAcentos(pP1);
   Result:='';
   for I := 1 to length(pP1) do
   begin
     if Pos(AnsiUpperCase(Copy(pP1,I,1)),'1234567890ABCDEFGHIJKLMNOPQRSTUVXYZW,.;') > 0 then
        Result := Result+Copy(pP1,I,1) else Result := Result+' ';
   end;
end;

function ConverteCaracterEspecialXML(Value: String): String;
//Elimina caracteres especiais do texto usado em XML
var
  I: Integer;
  sTexto: String;
begin
  sTexto := Value;
  for I := 1 to 42 do
    sTexto :=  StringReplace(sTexto,
                             Copy('ÁÀÂÄÃÉÈÊËÍÎÏÓÔÕÚÜÇáàâäãåéèêëíîïìóôõòöúüùûç', I, 1),
                             Copy('AAAAAEEEEIIIOOOUUCaaaaaaeeeeiiiiooooouuuuc', I, 1),
                             [rfReplaceAll]);

  Result := '';
  for I := 1 to Length(sTexto) do
  begin
    if Pos(AnsiUpperCase(Copy(sTexto, I, 1)), '1234567890ABCDEFGHIJKLMNOPQRSTUVXYZW!@#$%*()_+-=;:/|\?,.ºª[]') > 0 then
      Result := Result + Copy(sTexto, I, 1)
    else
      Result := Result + ' ';
  end;
end;


function Year(Data:TdateTime): Integer;
var
   DataD:TdateTime;
begin
   DataD:=Date;
   if Data <> DataD then DataD:=Data;
   result:=StrToInt(Copy(DateToStr(DataD),7,2));
   if length(DateToStr(DataD))= 10 then result:=StrToInt(Copy(DateToStr(DataD),7,4));
end;


function Month(Data:TdateTime): Integer;
var
   DataD:TDateTime;
begin
   DataD:=Date;
   if Data <> DataD then DataD:=Data;
   result:=StrToInt(Copy(DateToStr(DataD),4,2));
end;

function Day(Data:TdateTime): Integer;
var
   DataD:TDateTime;
begin
   DataD:=Date;
   if Data <> DataD then DataD:=Data;
   result:=StrToInt(Copy(DateToStr(DataD),1,2));
end;


function Bisexto(AAno: Integer): Boolean;
begin
  Result := (AAno mod 4 = 0) and ((AAno mod 100 <> 0) or (AAno mod 400 = 0));
end;

function DiasPorMes(AAno, AMes: Integer): Integer;
const
  DiasNoMes: array[1..12] of Integer = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
begin
  Result := DiasNoMes[AMes];
  if (AMes = 2) and Bisexto(AAno) then Inc(Result); { leap-year Feb is special }
end;

function DiasDesteMes: Integer;
begin
  Result := DiasPorMes(Year(Date), Month(Date));
end;

{soma um numero de dias em uma data}
function SomaDias(Data: TDateTime; Dias: Integer): TDateTime;
var
   I,D,M,A:integer;
begin
   D:=Day(Data);
   M:=Month(Data);
   A:=Year(Data);
   for I:= 1 to Dias do
   begin
      D:=D+1;
      if D > DiasPorMes(A,M) then
      begin
        if M=12 then {se for dezembro atribui Mes=1 e soma 1 no ano}
          begin
           M:=1;
           A:=A+1;
          end
        else M:=M+1;
        D:=1;
      end;
   end;
   result:=StrToDate(IntToStr(D)+'/'+IntToStr(M)+'/'+IntToStr(A));
end;



(*** Numeric Formatting Routines ***)
function JStrToFloat(S: String): Extended;
  var i : integer;
      Sign : Char;
      IntPart : String;
      DecPart : String;
      SeenSign : Boolean;
      SeenDigit : Boolean;
      SeenPoint : Boolean;
      RetString : String;
begin
  Sign := '+';
  IntPart := '';
  DecPart := '';
  SeenSign := false;
  SeenDigit := false;
  SeenPoint := false;
  for i := 1 to length(S) do begin

    (* Breakout loop *)
    while true do begin
      if (S[i] in ['+', '-']) and (not SeenSign) and (not SeenDigit) and (not SeenPoint) then begin
        SeenSign := true;
        Sign := S[i];
        break;
      end;

      {$IFDEF VER150}
      if (S[i] = DecimalSeparator) and (not SeenPoint) then
      {$ELSE}
      if (S[i] = FormatSettings.DecimalSeparator) and (not SeenPoint) then
      {$ENDIF}
      begin
        SeenPoint := true;
        break;
      end;
      if S[i] in ['0'..'9'] then begin
        SeenDigit := true;
        if SeenPoint then begin
          DecPart := DecPart + S[i];
        end else begin
          IntPart := IntPart + S[i];
        end;
        break;
      end;
      break;
    end;
  end; (* for *)

  {$IFDEF VER150}
  RetString := Sign+IntPart+DecimalSeparator+DecPart;
  {$ELSE}
  RetString := Sign+IntPart+FormatSettings.DecimalSeparator+DecPart;
  {$ENDIF}

  try
    Result := StrToFloat(RetString);
  except
    on E: EConvertError do begin
      Result := 0.00;
    end;
  end;
end;

function ReformatNumericString(S:String; Length, Dec : Integer):String;
  var F : Extended;
      formatstring : String;
begin
  F := JStrToFloat(S);
  if Dec = 0 then begin
    FormatString := '%'+IntToStr(Length)+'d';
    result := format(FormatString,[Trunc(F)]);
  end else begin
    FormatString := '%'+IntToStr(Length)+'.'+IntToStr(Dec)+'f';
    result := format(FormatString,[F]);
  end;
end;

function JStoI(S:String): Integer;
  var i : integer;
      NumString: String;
      SeenSign: Boolean;
      SeenPoint: Boolean;
      Sign : Char;
begin
  SeenSign := false;
  SeenPoint := false;
  NumString := '';
  Sign := '+';
  for i := 1 to length(s) do
  begin
    {Break-out loop}
    while true do begin
      if (s[i] in ['+', '-']) and (not SeenSign) then begin
        SeenSign := true;
        Sign := s[i];
        break;
      end;

      {$IFDEF VER150}
      if s[i] = DecimalSeparator then
      {$ELSE}
      if s[i] = FormatSettings.DecimalSeparator then
      {$ENDIF}
      begin
        SeenPoint := true;
        break;
      end;
      if (s[i] in ['0'..'9']) and (not SeenPoint) then begin
        NumString := NumString + s[i];
      end;
      break;

    end; {whil true}
  end; {for}

  if NumString = '' then begin
    Result := 0;
  end else begin
    try
      Result := StrToInt(Sign+NumString);
    except
      on E: EConvertError do
        result := 0;
    end;
  end;
end;

function IsNumericString(S:String):Boolean;
  var i : integer;
      SeenSign : Boolean;
      SeenPoint: Boolean;
begin
  Result := true;
  SeenSign := false;
  SeenPoint := false;
  for i := 1 to length(s) do
  begin
    {$IFDEF VER150}
    if not (S[i] in ['+', '-', '0'..'9', ' ', ThousandSeparator,DecimalSeparator]) then
    {$ELSE}
    if not (S[i] in ['+', '-', '0'..'9', ' ', FormatSettings.ThousandSeparator,FormatSettings.DecimalSeparator]) then
    {$ENDIF}
    begin
      Result := false;
      break;
    end;
    if s[i] in ['+', '-'] then begin
      if SeenSign then begin
        Result := false;
        break;
      end else begin
        SeenSign := true;
      end;
    end;

    {$IFDEF VER150}
    if s[i] = DecimalSeparator then
    {$ELSE}
    if s[i] = FormatSettings.DecimalSeparator then
    {$ENDIF}
    begin
      if SeenPoint then
      begin
        Result := false;
        break;
      end else
      begin
        SeenPoint := true;
      end;
    end;
  end;
end;

function IsIntegerString(S:String):Boolean;
  var i : integer;
      SeenSign : Boolean;
begin
  Result := true;
  SeenSign := false;
  for i := 1 to length(s) do begin
{    if not (S[i] in ['+', '-', '0'..'9', ' ', '_', ThousandSeparator]) then begin}
    {$IFDEF VER150}
    if not (S[i] in ['+', '-', '0'..'9', ' ', ThousandSeparator]) then
    {$ELSE}
    if not (S[i] in ['+', '-', '0'..'9', ' ', FormatSettings.ThousandSeparator]) then
    {$ENDIF}
    begin
      Result := false;
      break;
    end;
    if s[i] in ['+', '-'] then begin
      if SeenSign then begin
        Result := false;
        break;
      end else begin
        SeenSign := true;
      end;
    end;
  end;
end;

function AllDigits(S: String): Boolean;
  var i: Integer;
begin
  result := true;
  for i := 1 to length(S) do begin
    if not (S[i] in ['0'..'9']) then begin
      result := false;
      break;
    end;
  end;
end;
(*** End Numeric Formatting Routines ***)
function TrocaVirgula(S:String): String;
var I:Integer;
begin
  for I := 1 to length(S) do
  begin
    if copy(S,I,1)='.'then
    begin
      Delete(S,I,1);
      Insert(',',S,I);
    end;
  end;
  Result:=S;
end;

function Right(S : String; numCaracteres : Byte) : String;
{var
  index : Byte;}
begin
  if numCaracteres >= Length(S) then
    Result := S
  else
    begin
{      index := Length(S) - numCaracteres+1;}
      Result := Copy(S,(Length(S) - numCaracteres+1),numCaracteres)
    end
end;

{Funçao STRTRAN busca e troca uma parte de uma string em outra}
{pP1 String, pP2 trecho a ser substituido, pP3 trecho novo}
{function StrTran(pP1,pP2,pP3:String):String;
var
   I,J:Integer;
   achei:boolean;
begin
   Result:=pP1;
   achei:=false;
   J:=1;
   I:=1;
   while I <= length(Result) do
    begin
       if Copy(Result,I,1) = Copy(pP2,1,1) then
       begin
         achei:=true;
         for J:= 2 to length(pP2) do
         begin
            if Copy(Result,I+J-1,1) <> Copy(pP2,J,1) then
            begin
              achei:=false;
              break;
            end;
         end;
         if achei then
           begin
             Delete(Result,I,length(pP2));
             Insert(pP3,Result,I);
             I:=I+length(pP3);
           end;
       end;
       Inc(I);
    end;
end; }

//    Funçao STRTRAN busca e troca uma parte de uma string em outra
//               pP1 String, pP2 trecho a ser substituido, pP3 trecho novo    //
Function StrTran(sP1,sP2,sP3 : string):String;
//pP1 String, pP2 trecho a ser substituido, pP3 trecho novo
begin
  //
  if Pos(sP2,sP3) = 0 then
  begin
    while (Pos(sP2,sP1)<>0) do
    begin
      Insert(sP3,sP1,pos(sP2,sP1));
      Delete(sP1,pos(sP2,sP1),length(sP2));
    end;
  end;
  //
  Result := sP1;
  //
end;

Function StrTranUpper(sP1,sP2,sP3 : string):String;
//pP1 String, pP2 trecho a ser substituido, pP3 trecho novo
begin
  if alltrim(sP2) <> allTrim(sP3) then
  begin
     while(Pos(UpperCase(sP2),UpperCase(sP1))<>0) do
     begin
        Insert(sP3,sP1,pos(UpperCase(sP2),UpperCase(sP1)));
        Delete(sP1,pos(UpperCase(sP2),UpperCase(sP1)),length(sP2));
     end;
   end;
   //
   Result := sP1;
end;


function StrZero(Num : Double ; Zeros,Deci: integer): string;
{var
  I : integer;
  zer : string;
begin
   Result:='';
   if Deci = 0 then
      Num:=int(Num);
   Str(Num:Zeros:Deci, Result);

   Result := Alltrim(Result);
   zer := '';
   for I := 1 to (Zeros-length(Result)) do
      zer := zer + '0';
   Result := Right(zer+Result,Zeros);
end;}
begin
   Result:='';
{   if Num < 0 then begin
      Num:=Abs(Num);
      Result:='-';
   end;}
   Result:=Result+StrTran(Format('%'+intToStr(Zeros)+'.'+intToStr(Deci)+'f',[Num]),' ','0');
   if pos('-',Result) > 0 then begin
      Delete(Result,pos('-',Result),1);
      Result:='-'+Result;
   end;
end;

{função EXTENSO
 pP1 valor numérico, pP2 moeda (real, dolar), retorna uma string}

{
function Extenso(pP1:double):String;
var
   N:double;
   R:string;
   I:integer;
begin
   for I:= 3 downto 0 do
   begin
     if I <> 0 then
        begin
          N:=StrToFloat(Copy(Right(Copy(StrZero(pP1,15,2),1,12),3*I),1,3));
        end
     else
      begin
         R:= R+' reais';
         N:=StrToFloat(right(StrZero(pP1,12,2),2));
      end;
     if N <> 0 then
     begin
        R := R+' '+trim(Copy('            '+
                             'cem         '+
                             'duzentos    '+
                             'trezentos   '+
                             'quatrocentos'+
                             'quinhentos  '+
                             'seiscentos  '+
                             'setecentos  '+
                             'oitocentos  '+
                             'novecentos  ',(Trunc(int(N/100)*12)+1),12));
        N := N - int(N/100)*100;
        if N <> 0 then
          begin
           if length(trim(R))<> 0 then
              R:= R+' e ';
           R:= R + trim(Copy('         '+
                             'dez      '+
                             'vinte    '+
                             'trinta   '+
                             'quarenta '+
                             'cinqüenta'+
                             'sessenta '+
                             'setenta  '+
                             'oitenta  '+
                             'noventa  ',Trunc((int(N/10)*9)+1),9));
          end;
        N:= N - int(N/10)*10;
        if N <> 0 then
          begin
           if length(trim(R))<> 0 then
              R:= R+' e ';
           R:= R + trim(Copy('      '+
                             'um    '+
                             'dois  '+
                             'três  '+
                             'quatro'+
                             'cinco '+
                             'seis  '+
                             'sete  '+
                             'oito  '+
                             'nove  ',Trunc((N*6)+1),6));
          end;
        if I <> 0 then
        begin
          R:=R+' '+trim(Copy('        '+
                             'mil,    '+
                             'milhões,'+
                             'bilhões,'+
                             'trilhões',(I-1)*8+1,8));
        end;
        if I = 0 then
           R:=R+' centavos';
     end;
   end;
   //
   R:=StrTran(R,'  ',' ');
   R:=StrTran(R,'dez e um',    'onze');
   R:=StrTran(R,'dez e dois',  'doze');
   R:=StrTran(R,'dez e três',  'treze');
   R:=StrTran(R,'dez e quatro','catorze');
   R:=StrTran(R,'dez e cinco', 'quinze');
   R:=StrTran(R,'dez e seis',  'dezesseis');
   R:=StrTran(R,'dez e sete',  'dezessete');
   R:=StrTran(R,'dez e oito',  'dezoito');
   R:=StrTran(R,'dez e nove',  'dezenove');
   R:=StrTran(R,'cem e',       'cento e');
   R:=StrTran(R,'e e',        'e');
   R:=StrTran(R,'e e',        'e');
   R:=StrTran(R,'ões e',      'ões');
   R:=StrTran(R,'um milhões',  'um milhão');
   R:=StrTran(R,'um bilhões',  'um bilhão');
   R:=StrTran(R,'um trilhões', 'um trilhão');
   R:=StrTran(R,', reais',     ' reais');
   R:=StrTran(R,', e',         ' e');
   //
   if Copy(AllTrim(R),1,8)='reais e ' then Delete(R,1,8);
   if Pos('um reais',AllTrim(R)) = 1 then R:=StrTran(R,'um reais','um real');
   if Pos('um centavos',AllTrim(R)) = 1 then R:=StrTran(R,'um centavos', 'um centavo');
   //
   result:=Alltrim(R);
   //
end;
}



function Extenso(pP1:double):String;
var
  N:double;
  I:integer;
begin
  Result := '';
  for I:= 3 downto 0 do
  begin
    if I <> 0 then
    begin
      N:=StrToFloat(Copy(Right(Copy(StrZero(pP1,15,2),1,12),3*I),1,3));
    end else
    begin
      Result:= Result+' reais';
      N:=StrToFloat(right(StrZero(pP1,12,2),2));
    end;
    if N <> 0 then
    begin
      Result := Result+' '+trim(Copy('            '+
                           'cem         '+
                           'duzentos    '+
                           'trezentos   '+
                           'quatrocentos'+
                           'quinhentos  '+
                           'seiscentos  '+
                           'setecentos  '+
                           'oitocentos  '+
                           'novecentos  ',(Trunc(int(N/100)*12)+1),12));
      N := N - int(N/100)*100;
      if N <> 0 then
      begin
        if length(trim(Result)) <> 0 then Result:= Result+' e ';
        Result := Result + trim(Copy('         '+
                           'dez      '+
                           'vinte    '+
                           'trinta   '+
                           'quarenta '+
                           'cinqüenta'+
                           'sessenta '+
                           'setenta  '+
                           'oitenta  '+
                           'noventa  ',Trunc((int(N/10)*9)+1),9));

      end;
      N:= N - int(N/10)*10;
      if N <> 0 then
      begin
        if length(trim(Result))<> 0 then Result := Result +' e ';
        Result := Result + trim(Copy('      '+
                         'um    '+
                         'dois  '+
                         'três  '+
                         'quatro'+
                         'cinco '+
                         'seis  '+
                         'sete  '+
                         'oito  '+
                         'nove  ',Trunc((N*6)+1),6));
      end;
      if I <> 0 then Result := Result +' '+trim(Copy('        '+
                           'mil,    '+
                           'milhões,'+
                           'bilhões,'+
                           'trilhões',(I-1)*8+1,8));
      if I = 0 then Result := Result +' centavos';
    end;
  end;
  Result:=StrTran(Result,'  ',' ');
  Result:=StrTran(Result,'dez e um',    'onze');
  Result:=StrTran(Result,'dez e dois',  'doze');
  Result:=StrTran(Result,'dez e três',  'treze');
  Result:=StrTran(Result,'dez e quatro','catorze');
  Result:=StrTran(Result,'dez e cinco', 'quinze');
  Result:=StrTran(Result,'dez e seis',  'dezesseis');
  Result:=StrTran(Result,'dez e sete',  'dezessete');
  Result:=StrTran(Result,'dez e oito',  'dezoito');
  Result:=StrTran(Result,'dez e nove',  'dezenove');
  Result:=StrTran(Result,'cem e',       'cento e');
  Result:=StrTran(Result,'e e',        'e');
  Result:=StrTran(Result,'e e',        'e');
  Result:=StrTran(Result,'ões e',      'ões');
  Result:=StrTran(Result,'um milhões',  'um milhão');
  Result:=StrTran(Result,'um bilhões',  'um bilhão');
  Result:=StrTran(Result,'um trilhões', 'um trilhão');
  Result:=StrTran(Result,', reais',     ' reais');
  Result:=StrTran(Result,', e',         ' e');
  if Copy(AllTrim(Result),1,8)='reais e ' then Delete(Result,1,8);
  if Pos('um reais',AllTrim(Result)) = 1 then Result:=StrTran(Result,'um reais','um real');
  if Pos('um centavos',AllTrim(Result)) = 1 then Result:=StrTran(Result,'um centavos', 'um centavo');
end;


function MesExtenso(pP1:Integer):String;
begin
   Result:='';
   if (pP1 >= 1) and (pP1 <= 12) then
   begin
      Result:=Copy('Janeiro  FevereiroMarço    Abril    Maio     Junho    '+
                   'Julho    Agosto   Setembro Outubro  Novembro Dezembro ',
                   ((pP1-1)*9)+1,9);
   end;
end;

function DiaUtil(pP1:TDateTime): Boolean;
var
   I:Integer;
const feriados : array[0..7] of PChar =
('01/01/', '21/04/', '01/05/', '07/09/','12/10/', '02/11/', '15/11/', '25/12/');
begin
   Result:=True;
   for I:= 0 to 7 do
   begin
      if dateToStr(pP1) = (StrPas(Feriados[I])+Copy(DateToStr(pP1),7,2)) then
         Result:=False;
   end;
   if (DayOfWeek(pP1)=1) or (DayOfWeek(pP1)=7) then
      Result:=False;
end;

function DiasUteisDoMes(AAno, AMes: Integer): Integer;
var
  I:Integer;
begin
   Result:=0;
   for I:= 1 to DiasPorMes(AAno,AMes) do
   begin
     if DiaUtil(StrToDate(IntToStr(I)+'/'+IntToStr(AMes)+'/'+IntToStr(AAno))) then
        Result:=Result+1;
   end;
end;

function DiasUteisDoPeriodo(pP1, pP2: TDateTime): Integer;
begin
   Result:=0;
   while pP1 <= pP2 do
   begin
      if DiaUtil(pP1) then Result:=Result+1;
      pP1:=pP1+1;
   end;
end;

{function IsPrinter(X:Byte):Boolean; Assembler;
asm
  SUB DH,DH
  MOV DL,X   //que impressora checar
  MOV AH, 02H //funcao para printer status
  INT 17H     //le status impressora
  MOV AL, FALSE
  CMP AH, 90H // 90H OK
  JNE @@Exit //retorna falso se AH <> 90H
  MOV AL, TRUE
@@Exit:
end;
}

function IsPrinter(X:Byte):Boolean;
//var
// nResult:byte;
begin
{  try
    asm
      SUB DH,DH
      MOV DL,X   //que impressora checar
      MOV AH, 02H //funcao para printer status
      INT 17H     //le status impressora
      MOV AL, FALSE
      CMP AH, 90H // 90H OK
      JNE @@Exit //retorna falso se AH <> 90H
      MOV AL, TRUE
    @@Exit:
      mov nResult,AL;
    end;
  except
    nResult:=1;
  end;
  if nResult=0 then result:=False
  else
  }
  Result:=True;
end;


function PrinterOnLine:Boolean;
const
   PrnStInt : Byte = $17;
   StRq : Byte = $02;
   PrnNum : Word=0; //0 para LPT1
var
 nResult:byte;
begin (*PrinterOnLine*)
  try
    asm
      mov ah,StRq;
      mov dx,PrnNum;
      Int $17;
      mov nResult,ah;
    end;
    PrinterOnLine:=(nResult and $90)=$80;
  except
    PrinterOnLine:=True;
  end;
end;

Function Cartao(pP1:String):Boolean;
var
  CalcCartao,calcs,I:Integer;
  NumeroCartao:String;
begin
  NumeroCartao:=pP1;
  CalcCartao:=0;
  For I := 1 to length(NumeroCartao) do
  begin
     if (I mod 2) = 0 then // posicao par só acumula
        Calcs:=StrToInt(Copy(NumeroCartao,I,1))
     else
       begin
         Calcs:=StrToInt(Copy(NumeroCartao,I,1))*2;
         if Calcs > 9 then Calcs:=Calcs-9;
       end;
     CalcCartao:=CalcCartao+Calcs;
  end;
  if (CalcCartao < 150) and ((CalcCartao mod 10) = 0) then //se o resto da divisão por 10 for zero
    Result:=True
  else
    Result:=False;
end;

function SMALL_Tempo(pP1:Integer):Integer;
var
  I : Integer;
begin
  I := (StrToInt(Copy(TimeToStr(Now),7,2))) +
              (StrToInt(Copy(TimeToStr(Now),4,2)) * 60) +
              (StrToInt(Copy(TimeToStr(Now),1,2)) * 60 * 60) + pP1;

  while I > (StrToInt(Copy(TimeToStr(Now),7,2))) +
              (StrToInt(Copy(TimeToStr(Now),4,2)) * 60) +
              (StrToInt(Copy(TimeToStr(Now),1,2)) * 60 * 60) do ;

  Result := Pp1;

end;

function TimeToFloat(pTempo:String):Double;
begin
   try
     if Pos(',',pTempo) > 0 then
        Result:=JStrToFloat(pTempo)
     else
        Result:=StrToFloat(Copy(pTempo,1,3))+((StrToFloat(Copy(pTempo,5,2))*100)/60/100);
   except
     result:=0;
   end;
end;

function SMALL_NumeroDeCores : Integer;
{Retorna a quantidade atual de cores no Windows (16, 256, 65536 = 16 ou 24 bit}
var
  DC:HDC;
  BitsPorPixel: Integer;
begin
  Dc := GetDc(0); // 0 = vídeo
  BitsPorPixel := GetDeviceCaps(Dc,BitsPixel);
  Result := 2 shl (BitsPorPixel - 1);
end;


function VerificaSeTemImpressora():Boolean;
var
   Device : array[0..255] of char;
   Driver : array[0..255] of char;
   Port   : array[0..255] of char;
   hDMode : THandle;
begin
   Result:=True;
   // Retorna a impressora padrão do windows
   try
      Printer.GetPrinter(Device, Driver, Port, hDMode);
   except
      Result:=False;
   end;
end;

function RetornaOperadora(sNumero: String): String;
begin
  //
  // 4999127336
  //
  sNumero := LimpaNumero(sNumero);
  //
  if Copy(sNumero,1,1) = '0' then sNumero := Copy(sNumero,2,Length(SNumero)-2);
  if Copy(sNumero,3,1) <= '5' then Result := 'Convencional';
  //
  // Rio de janeiro, Espirito Santo
  //
  if (Copy(sNumero,1,2) >= '21') and (Copy(sNumero,1,2) <= '28') then
  begin
    if (Copy(sNumero,3,2) >= '96') and (Copy(sNumero,3,2) <= '99') then Result := 'Vivo - Rio de janeiro, Espirito Santo';
    if (Copy(sNumero,3,2) >= '91') and (Copy(sNumero,3,2) <= '94') then Result := 'Claro - Rio de janeiro, Espirito Santo';
    if (Copy(sNumero,3,2) >= '86') and (Copy(sNumero,3,2) <= '89') then Result := 'Oi - Rio de janeiro, Espirito Santo';
    if (Copy(sNumero,3,2) >= '81') and (Copy(sNumero,3,2) <= '83') then Result := 'Tim - Rio de janeiro, Espirito Santo';
    if (Copy(sNumero,3,2) = '95')                                  then Result := 'Vivo - Rio de janeiro';
  end;
  //
  // Amazônia
  //
  if (Copy(sNumero,1,2) >= '91') and (Copy(sNumero,1,2) <= '99') then
  begin
    if (Copy(sNumero,3,2) >= '96') and (Copy(sNumero,3,2) <= '99') then Result := 'Amazônia celular - Amazônia';
    if (Copy(sNumero,3,2) >= '91') and (Copy(sNumero,3,2) <= '94') then Result := 'Vivo - Amazônia';
    if (Copy(sNumero,3,2) >= '86') and (Copy(sNumero,3,2) <= '89') then Result := 'Oi - Amazônia';
    if (Copy(sNumero,3,2) >= '81') and (Copy(sNumero,3,2) <= '83') then Result := 'Tim - Amazônia';
  end;
  //
  // Minas Gerais
  //
  if (Copy(sNumero,1,2) >= '31') and (Copy(sNumero,1,2) <= '38') then
  begin
    if (Copy(sNumero,3,2) >= '96') and (Copy(sNumero,3,2) <= '99') then Result := 'Telemig - Minas Gerais';
    if (Copy(sNumero,3,2) >= '91') and (Copy(sNumero,3,2) <= '94') then Result := 'Tim - Minas Gerais';
    if (Copy(sNumero,3,2) >= '86') and (Copy(sNumero,3,2) <= '89') then Result := 'Oi - Minas Gerais';
    if (Copy(sNumero,3,2) = '81') or (Copy(sNumero,3,2) = '84')    then Result := 'Claro - Minas Gerais';
  end;
  //
  // Bahia, Sergipe
  //
  if (Copy(sNumero,1,2) >= '71') and (Copy(sNumero,1,2) <= '79') then
  begin
    if (Copy(sNumero,3,2) >= '96') and (Copy(sNumero,3,2) <= '99') then Result := 'Vivo - Bahia, Sergipe';
    if (Copy(sNumero,3,2) >= '91') and (Copy(sNumero,3,2) <= '94') then Result := 'Tim - Bahia, Sergipe';
    if (Copy(sNumero,3,2) = '81')                                  then Result := 'Claro - Bahia, Sergipe';
  end;
  //
  // Nordeste
  //
  if (Copy(sNumero,1,2) >= '81') and (Copy(sNumero,1,2) <= '89') then
  begin
    if (Copy(sNumero,3,2) >= '96') and (Copy(sNumero,3,2) <= '99') then Result := 'Tim - Nordeste';
    if (Copy(sNumero,3,2) >= '91') and (Copy(sNumero,3,2) <= '94') then Result := 'Claro - Nordeste';
    if (Copy(sNumero,3,1) >= '8') then Result := 'Claro - Nordeste verificar';
  end;
  //
  // Parana, Santa Catarina
  //
  if (Copy(sNumero,1,2) >= '41') and (Copy(sNumero,1,2) <= '49') then
  begin
    if (Copy(sNumero,3,2) >= '96') and (Copy(sNumero,3,2) <= '99') then Result := 'Tim - Parana, Santa Catarina';
    if (Copy(sNumero,3,2) >= '91') and (Copy(sNumero,3,2) <= '94') then Result := 'Vivo - Parana, Santa Catarina';
    if (Copy(sNumero,3,2) = '88')                                  then Result := 'Claro - Parana, Santa Catarina';
    if (Copy(sNumero,3,2) = '84')                                  then Result := 'Brasil Telecom - Parana, Santa Catarina';
  end;
  //
  // Rio Grande do Sul
  //
  if (Copy(sNumero,1,2) >= '51') and (Copy(sNumero,1,2) <= '55') then
  begin
    if (Copy(sNumero,3,2) >= '96') and (Copy(sNumero,3,2) <= '99') then Result := 'Vivo - Rio Grande do Sul';
    if (Copy(sNumero,3,2) >= '91') and (Copy(sNumero,3,2) <= '94') then Result := 'Claro - Rio Grande do Sul';
    if (Copy(sNumero,3,2) = '81')                                  then Result := 'Tim - Rio Grande do Sul';
    if (Copy(sNumero,3,2) = '84')                                  then Result := 'Brasil Telecom - Rio Grande do Sul';
  end;
  //
  // Centro Oeste
  //
  if (Copy(sNumero,1,2) >= '61') and (Copy(sNumero,1,2) <= '69') then
  begin
    if (Copy(sNumero,3,2) >= '96') and (Copy(sNumero,3,2) <= '99') then Result := 'Vivo - Centro Oeste';
    if (Copy(sNumero,3,2) >= '91') and (Copy(sNumero,3,2) <= '94') then Result := 'Claro - Centro Oeste';
    if (Copy(sNumero,3,2) = '81')                                  then Result := 'Tim - Centro Oeste';
    if (Copy(sNumero,3,2) = '84')                                  then Result := 'Brasil Telecom - Centro Oeste';
// Ver
    if (Copy(sNumero,3,2) = '95')                                  then Result := 'Claro - Distrito Federal';
  end;
  //
  // São Paulo
  //
  if (Copy(sNumero,1,2) >= '11') and (Copy(sNumero,1,2) <= '19') then
  begin
    //
    if (Copy(sNumero,1,2) = '11') then
    begin
      if (Copy(sNumero,3,3) >= '996') and (Copy(sNumero,3,3) <= '999') then Result := 'Vivo - São Paulo';
      if (Copy(sNumero,3,3) >= '971') and (Copy(sNumero,3,3) <= '974') then Result := 'Vivo - São Paulo';
      if (Copy(sNumero,3,3) >= '991') and (Copy(sNumero,3,3) <= '994') then Result := 'Claro - São Paulo';
      if (Copy(sNumero,3,3) >= '981') and (Copy(sNumero,3,3) <= '986') then Result := 'Tim - São Paulo';
      if (Copy(sNumero,3,3) = '995')                                  then Result := 'Vivo - São Paulo';
      if (Copy(sNumero,3,3) = '976') and (Copy(sNumero,3,3) = '989')   then Result := 'Claro - São Paulo';
    end else
    begin
      if (Copy(sNumero,3,2) >= '96') and (Copy(sNumero,3,2) <= '99') then Result := 'Vivo - São Paulo';
      if (Copy(sNumero,3,2) >= '71') and (Copy(sNumero,3,2) <= '74') then Result := 'Vivo - São Paulo';
      if (Copy(sNumero,3,2) >= '91') and (Copy(sNumero,3,2) <= '94') then Result := 'Claro - São Paulo';
      if (Copy(sNumero,3,2) >= '81') and (Copy(sNumero,3,2) <= '86') then Result := 'Tim - São Paulo';
      if (Copy(sNumero,3,2) = '95')                                  then Result := 'Vivo - São Paulo';
      if (Copy(sNumero,3,2) = '76') and (Copy(sNumero,3,2) = '89')   then Result := 'Claro - São Paulo';
    end;
    //
  end;
  //
  // Londrina e Tamarana, PR
  //
  if (Copy(sNumero,1,2) >= '43') then
  begin
    if (Copy(sNumero,3,2) = '81') then Result := 'Tim - Londrina e Tamarana, PR';
    if (Copy(sNumero,3,2) = '9')  then Result := 'Sercomtel - Londrina e Tamarana, PR';
  end;
  //
  // Pelotas e região
  //
  if (Copy(sNumero,1,2) >= '53') then
  begin
    if (Copy(sNumero,3,4) = '9911')                                    then Result := 'Tim - Pelotas e região';
    if (Copy(sNumero,3,4) = '9913')                                    then Result := 'Tim - Pelotas e região';
    if (Copy(sNumero,3,4) = '9939')                                    then Result := 'Tim - Pelotas e região';
    if (Copy(sNumero,3,4) >= '9981') and (Copy(sNumero,3,4) <= '9989') then Result := 'Tim - Pelotas e região';
  end;
  //
end;


{
//------------------------------------------------------------------------
Function SMALL_IE(sNumero:String;UF:String):Boolean;
var
  bTamanho,bInicio:boolean;
  sDigito1,sDigito2,sSoNumero:string;
  Function Modulo_11AP(pNumero:String):String;
  var
     Acumulado,D,I,Controle:integer;
  begin
     Acumulado:=0;
     D:=0;
     if (StrToInt(pNumero) >= 3000001) and (StrToInt(pNumero) <= 3017000) then
      begin
       Acumulado:=5;
      end
     else
       if (StrToInt(pNumero) >= 3017001) and (StrToInt(pNumero) <= 3019022) then
        begin
          Acumulado:=9;
          D:=1;
        end
       else
         if (StrToInt(pNumero) >= 3019023)  then
         begin
           Acumulado:=0;
         end;
     //acumula a soma da multiplicação dos digitos
     pNumero:=alltrim(pNumero);
     Controle:=2;
     for I:=length(pNumero) downto 1 do
     begin
        Acumulado:=Acumulado + (StrToInt(Copy(pNumero,I,1))*Controle);
        Controle := Controle + 1;
        if Controle > 9 then Controle:=2;
     end;
     //calcula o digito
     Acumulado:=11-(Acumulado mod 11);
     if (Acumulado = 10) then Acumulado:=0;
     if (Acumulado = 11) then Acumulado:=D;
     //devolve o digito de controle
     Result:=IntToStr(Acumulado);
  end;

  Function Modulo_10(pP1:String):String;
  var
     Acumulado,I,Controle:integer;
  begin
     //acumula a soma da multiplicação dos digitos
     Pp1:=alltrim(pP1);
     Controle:=2;
     Acumulado:=0;
     for I:=length(Pp1) downto 1 do
     begin
        Acumulado:=Acumulado + (StrToInt(Copy(Pp1,I,1))*Controle);
        Controle := Controle + 1;
        if Controle > 9 then Controle:=2;
     end;
     //calcula o digito
     Acumulado:=10-(Acumulado mod 10);
     if Acumulado=10 then Acumulado:=0;
     //devolve o digito de controle
     Result:=IntToStr(Acumulado);
  end;

  Function Modulo_11ComLimite(pNumero:String;pLimite:Integer):String;
  var
     Acumulado,I,Controle:integer;
  begin
     //acumula a soma da multiplicação dos digitos
     pNumero:=alltrim(pNumero);
     Acumulado:=0;
     Controle:=2;
     for I:=length(pNumero) downto 1 do
     begin
        Acumulado:=Acumulado + (StrToInt(Copy(pNumero,I,1))*Controle);
        Controle := Controle + 1;
        if Controle > pLimite then Controle:=2;
     end;
     //calcula o digito
     Acumulado:=11-(Acumulado mod 11);
     if (Acumulado = 10) or (Acumulado = 11)  then Acumulado:=0;
     //devolve o digito de controle
     Result:=IntToStr(Acumulado);
  end;

  Function Modulo_RR(pP1:String):String;
  var
     I,Acumulado:integer;
  begin
     //acumula a soma da multiplicação dos digitos
     Acumulado:=0;
     for I:=1 to length(Pp1) do
     begin
        Acumulado:=Acumulado + (StrToInt(Copy(pP1,I,1))*I);
     end;
     //calcula o digito
     Result:=IntToStr((Acumulado mod 9));
  end;

  Function Modulo_MG(pNumero:String):String;
  var
     Acumulado,I,Controle:integer;
     sSoma:String;
  begin
     //acumula a soma da multiplicação dos digitos
     pNumero:=alltrim(pNumero);
     Controle:=2;
     Acumulado:=0;
     // módulo louco 21
     sSoma:='';
     for I:=length(pNumero) downto 1 do
     begin
        sSoma:=sSoma + AllTrim(IntToStr((StrToInt(Copy(pNumero,I,1))*Controle)));
        if Controle = 2 then Controle:=1 else Controle:=2;
     end;
     for I:=1 to Length(sSoma) do Acumulado:=Acumulado+StrToInt(Copy(sSoma,I,1));
     //calcula o digito
     if (Acumulado mod 10) = 0 then
       Acumulado:=0
     else
       begin
         I:=Acumulado;
         while (I mod 10) <> 0 do I:=I+1;
         Acumulado:=I-Acumulado;
       end;
     //devolve o digito de controle
     Result:=IntToStr(Acumulado);
  end;

  Function Modulo_SP(pNumero:String;pTipo:string):String;
  var
     Acumulado,I,Controle:integer;
     aI: array[1..8] of integer;
  begin
     //acumula a soma da multiplicação dos digitos
     pNumero:=alltrim(pNumero);
     Controle:=2;
     Acumulado:=0;
     if pTipo='2' then // módulo 11
      begin
        for I:=length(pNumero) downto 1 do
        begin
           Acumulado:=Acumulado + (StrToInt(Copy(pNumero,I,1))*Controle);
           Controle := Controle + 1;
           if Controle > 10 then Controle:=2;
        end;
        //calcula o digito
        Acumulado:=(Acumulado mod 11);
      end
     else
      begin // módulo louco
        aI[1]:=1; aI[2]:=3; aI[3]:=4; aI[4]:=5; aI[5]:=6; aI[6]:=7; aI[7]:=8; aI[8]:=10;
        for I:=length(pNumero) downto 1 do
        begin
           Acumulado:=Acumulado + (StrToInt(Copy(pNumero,I,1))*aI[I]);
        end;
        //calcula o digito
        Acumulado:=(Acumulado mod 11);
      end;

     //devolve o digito de controle
     Result:=Right(IntToStr(Acumulado),1);
  end;

  Function Modulo_PE(pNumero:String):String;
  var
     Acumulado,I,Controle:integer;
  begin
     //acumula a soma da multiplicação dos digitos
     pNumero:=alltrim(pNumero);
     Controle:=2;
     Acumulado:=0;
     for I:=length(pNumero) downto 1 do
     begin
        Acumulado:=Acumulado + (StrToInt(Copy(pNumero,I,1))*Controle);
        Controle := Controle + 1;
        if Controle > 9 then Controle:=1;
     end;
     //calcula o digito
     Acumulado:=11-(Acumulado mod 11);
     if (Acumulado = 10) or (Acumulado = 11)  then Acumulado:=0;
     //devolve o digito de controle
     Result:=IntToStr(Acumulado);
  end;

  function PR_Antiga(sInscricao:string):string;
  var
   sMascara1,sMascara2,sCaracter1,sCaracter2,sCaracter3:string;
   iTemp1,iTemp2,I,iTemp3:integer;
  begin
     sMascara1:='000000001110001111000011001100412345670112460246133404151526';
     sMascara2:='MNPQRJKL--DEFGHABC--VWXYZSTU';
     iTemp1:=0;
     iTemp2:=0;
     for I:= 1 to 8  do
     begin
        sCaracter1:=Copy(sInscricao,I, 1);
        iTemp3:= (Trunc(I / 3) * 30) - (I * 10) + Ord(sCaracter1[1]);
        sCaracter2:=Copy(sMascara1, iTemp3 - 27, 1);
        iTemp1:= iTemp1 + Ord(sCaracter2[1]);
        sCaracter3:=Copy(sMascara1, iTemp3 + 3, 1);
        iTemp2:= iTemp2 + Ord(sCaracter3[1]);
     end;
     Result:= Copy(sMascara2, iTemp1 mod 3 * 10 + iTemp2 mod 8 + 1, 1);
  end;

begin
   Result:=False;
   UF:=AllTrim(UpperCase(UF));
   if Pos(UF,'AC,AL,AM,AP,BA,CE,DF,ES,GO,MA,MG,MS,MT,PA,PB,PE,PI,PR,RJ,RN,RO,RR,RS,SC,SE,SP,TO') > 0 then
   begin
      // extrai somente os números
      sSoNumero:=LimpaNumero(sNumero);
      if UF='TO' then // deve-se extrair dois dígitos
         // se não for os números abaixo, deixa com 11 dígitos e bTamanho ficará falso
         if (Copy(sSoNumero,3,2)='01') or (Copy(sSoNumero,3,2)='02') or (Copy(sSoNumero,3,2)='03') or (Copy(sSoNumero,3,2)='99') then
            sSoNumero:=Copy(sSoNumero,1,2)+Copy(sSoNumero,5,7);
      if UF='RO' then
         sSoNumero:=Copy(sSoNumero,4,6);

      // verifica o tamanho
      if UF='MT' then
         bTamanho:=(length(sSoNumero)>=9)
      else
         if (UF='DF') or (UF='MG') then
            bTamanho:=(length(sSoNumero)=13)
         else
           if UF='PE' then
              bTamanho:=(length(sSoNumero)=14)
           else
             if UF='RO' then
                bTamanho:=(length(sSoNumero)=6)
             else
                if (UF='RJ') or (UF='BA')then
                   bTamanho:=(length(sSoNumero)=8)
                else
                  if (UF='RS')  then
                     bTamanho:=(length(sSoNumero)=10)
                  else
                    if UF='SP' then
                       bTamanho:=(length(sSoNumero)=12)
                    else
                       if (UF='PR') then
                          bTamanho:=((length(sSoNumero)=8) or (length(sSoNumero)=10))
                       else
                          bTamanho:=(length(sSoNumero)=9);


      bInicio:=False;
      if bTamanho then
      begin
        // verifica o inicio
        if UF='RN' then
           bInicio:=(Copy(sSoNumero,1,2)='20')
        else
           if UF='AL' then
              bInicio:=(Copy(sSoNumero,1,2)='24')
           else
              if UF='AP' then
                 bInicio:=(Copy(sSoNumero,1,2)='03')
              else
                if UF='DF' then
                   bInicio:=(Copy(sSoNumero,1,2)='07')
                else
                   if UF='GO' then
                      bInicio:=((Copy(sSoNumero,1,2)='10')or(Copy(sSoNumero,1,2)='11')or(Copy(sSoNumero,1,2)='15'))
                   else
                      if UF='MA' then
                         bInicio:=(Copy(sSoNumero,1,2)='12')
                      else
                         if UF='MS' then
                            bInicio:=(Copy(sSoNumero,1,2)='28')
                         else
                            if UF='PA' then
                               bInicio:=(Copy(sSoNumero,1,2)='15')
                            else
                               if UF='RR' then
                                  bInicio:=(Copy(sSoNumero,1,2)='24')
                               else
                                  if UF='RS' then
                                     bInicio:=(StrToInt(Copy(sSoNumero,1,3)) < 468)
                                  else
                                     bInicio:=true;
      end;

      if bTamanho and bInicio then
      begin
        if UF='AP' then
         begin
            if Copy(sSoNumero,Length(sSoNumero),1) = Modulo_11AP(Copy(sSoNumero,1,Length(sSoNumero)-1)) then Result:=True;
         end
        else
         if UF='BA' then
          begin
            if Pos(Copy(sSoNumero,1,1),'0123458') > 0 then
             begin
               sDigito2:=Modulo_10(Copy(sSoNumero,1,6));
               sDigito1:=Modulo_10(Copy(sSoNumero,1,6)+sDigito2);
             end
            else
             begin
               sDigito2:=Modulo_11(Copy(sSoNumero,1,6));
               sDigito1:=Modulo_11(Copy(sSoNumero,1,6)+sDigito2);
             end;
            if Right(sSoNumero,2) = sDigito1+sDigito2 then Result:=True;
          end
         else
          if UF='DF' then
           begin
             sDigito1:=Modulo_11(Copy(sSoNumero,1,11));
             sDigito2:=Modulo_11(Copy(sSoNumero,1,11)+sDigito1);
             if Right(sSoNumero,2) = sDigito1+sDigito2 then Result:=True;
           end
          else
           if UF='MG' then
            begin
              sDigito1:=Modulo_MG(Copy(sSoNumero,1,3)+'0'+Copy(sSoNumero,4,8));
              sDigito2:=Modulo_11ComLimite(Copy(sSoNumero,1,11)+sDigito1,11);
              if Right(sSoNumero,2) = sDigito1+sDigito2 then Result:=True;
            end
           else
            if UF='SP' then
             begin
               if UpperCase(Copy(sNumero,1,1))='P' then // produtor Rural
                begin
                  sDigito1:=Modulo_SP(Copy(sSoNumero,1,8),'1');
                  if Copy(sSoNumero,9,1) = sDigito1 then Result:=True;
                end
               else
                begin // comercio ou indústria
                  sDigito1:=Modulo_SP(Copy(sSoNumero,1,8),'1');
                  sDigito2:=Modulo_SP(Copy(sSoNumero,1,8)+sDigito1+Copy(sSoNumero,10,2),'2');
                  if Copy(sSoNumero,9,1)+Copy(sSoNumero,12,1) = sDigito1+sDigito2 then Result:=True;
                end;
             end
            else
             if UF='PR' then
              begin
                if (length(sSoNumero)=10) then //inscrição nova
                 begin
                   sDigito1:=Modulo_11ComLimite(Copy(sSoNumero,1,8),7);
                   sDigito2:=Modulo_11ComLimite(Copy(sSoNumero,1,8)+sDigito1,7);
                   if Right(sSoNumero,2) = sDigito1+sDigito2 then Result:=True;
                 end
                else
                 begin
                   if (length(sSoNumero)=8) then // inscrição Antiga
                     if Copy(LimpaLetras(sNumero),1,1)=PR_Antiga(sSoNumero) then Result:=True;
                 end;
              end
             else
              if UF='PE' then
               begin
                 if Copy(sSoNumero,Length(sSoNumero),1) = Modulo_PE(Copy(sSoNumero,1,Length(sSoNumero)-1)) then Result:=True;
               end
              else
               if UF='RR' then
                begin
                  if Copy(sSoNumero,Length(sSoNumero),1) = Modulo_RR(Copy(sSoNumero,1,Length(sSoNumero)-1)) then Result:=True;
                end
               else
                if UF='RJ' then
                 begin
                   if Copy(sSoNumero,Length(sSoNumero),1) = Modulo_11ComLimite(Copy(sSoNumero,1,Length(sSoNumero)-1),7) then Result:=True;
                 end
                else
                  // verifica o módulo 11
                  if Copy(sSoNumero,Length(sSoNumero),1) = Modulo_11(Copy(sSoNumero,1,Length(sSoNumero)-1)) then Result:=True;
      end;
      if length(sSoNumero)=0 then Result:=True; // se for em branco aceita
   end;
end;
}



//------------------------------------------------------------------------

function SMALL_2of5(sP : String): String;
var
  I : Integer;
begin
  Result := '';
  sP := LimpaNumero(AllTrim(sP));
  for I := 1 to Length(sP) div 2 do
  begin
    if (StrToInt(Copy(sP,(I*2)-1,2)) <= 49) then  Result := Result + Chr((StrToInt(Copy(sP,(I*2)-1,2))+48));
    if (StrToInt(Copy(sP,(I*2)-1,2)) >= 50) then  Result := Result + Chr((StrToInt(Copy(sP,(I*2)-1,2))+142));
  end;
end;

function SMALL_2of5_2(sP : String): String;
var
  I : Integer;
begin
  // 130 > 229
  sP := LimpaNumero(AllTrim(sP));
  for I := 1 to Length(sP) div 2 do
  begin
    Result := Result + Chr( (StrToInt(Copy(sP,(I*2)-1,2))+130) );
  end;
end;

function Arredonda(fP1 : Real; iP2 : Integer): Real;
begin
  Result := StrToFloat(StrTran(Format('%14.'+IntToStr(iP2)+'n',[fP1]),'.',''));
end;

function Arredonda2(fP1 : Double; iP2 : Integer): Double;
begin
  // Problema de campos no bd double precision ou valores com dizima resolvi desta forma mas nao entendo como isso funciona
  fp1 := StrToFloat(FloatToStr(fP1));
  Result := StrToFloat(StrTran(Format('%14.'+IntToStr(iP2)+'n',[fP1]),'.',''));
end;


function LimpaNumeroDeixandoAVirgula(pP1:String):String;
var
   I:Integer;
begin
   Result:='';
   for I := 1 to length(pP1) do
   begin
     if Pos(Copy(pP1,I,1),'0123456789,-') > 0 then
        Result:=Result+Copy(pP1,I,1);
   end;
end;

function LimpaNumeroDeixandoOponto(pP1:String):String;
var
   I:Integer;
begin
   Result:='';
   for I := 1 to length(pP1) do
   begin
     if Pos(Copy(pP1,I,1),'0123456789.-') > 0 then
        Result:=Result+Copy(pP1,I,1);
   end;
end;


function LimpaNumeroDeixandoABarra(pP1:String):String;
var
   I:Integer;
begin
   Result:='';
   for I := 1 to length(pP1) do
   begin
     if Pos(Copy(pP1,I,1),'0123456789/') > 0 then
        Result:=Result+Copy(pP1,I,1);
   end;
end;



function DiaDaSemana(pP1:TDateTime):String;
begin
  Result := Copy('DomingoSegundaTerça  Quarta Quinta Sexta  Sábado ',((DayOfWeek(pP1)-1)*7)+1,7);
end;

function WinVersion: string;
var
  VersionInfo: TOSVersionInfo;
begin
  VersionInfo.dwOSVersionInfoSize:=SizeOf(VersionInfo);
  GetVersionEx(VersionInfo);
  Result := StrZero(VersionInfo.dwMajorVersion,3,0)+StrZero(VersionInfo.dwMinorVersion,3,0)
end;

function CorrentPrinter :String; //Declare a unit Printers na clausula uses
var
  Device : array[0..255] of char;
  Driver : array[0..255] of char;
  Port : array[0..255] of char;
  hDMode : THandle;
begin
  Printer.GetPrinter(Device, Driver, Port, hDMode);
  Result := Device;
end;

{
function ValidaEAN13(sP1:String):Boolean;
  function Par(Cod:Integer):Boolean;
  begin
    Result:= Cod Mod 2 = 0 ;
  end;
var
  i,
  SomaPar,
  SomaImpar:Integer;
begin
  if (Length(LimpaNumero(sP1))=13) and (Length(LimpaNumero(sP1))=Length(sP1)) then
  begin
    SomaPar:=0;
    SomaImpar:=0;

    for i:=1 to 12 do
    if Par(i) then
    SomaPar:=SomaPar+StrToInt(sP1[i])
    else SomaImpar:=SomaImpar+StrToInt(sP1[i]);

    SomaPar:=SomaPar*3;
    i:=0;
    while i < (SomaPar+SomaImpar) do
    Inc(i,10);
    
    if Copy(sP1,13,1) = IntToStr(i-(SomaPar+SomaImpar)) then Result := True else Result := False;
  end else
  begin
    Result := False;
  end;
end;
Mauricio Parizotto 2023-07-05}

function ValidaEAN(AGTIN:String):Boolean;
  function Par(Cod:Integer):Boolean;
  begin
    Result:= Cod Mod 2 = 0 ;
  end;
var
  i,
  soma, resultado, base10: integer;
begin
  Result := False;

  if (Length(LimpaNumero(AGTIN)) <> Length(AGTIN)) then
  begin
    Exit;
  end;
  
  if not (Length(AGTIN) in [8,12,13,14]) then
  begin
    Exit;
  end;

  soma:= 0;
  for i:= 1 to (Length(AGTIN) -1) do
  begin
    if Length(AGTIN) = 13 then
    begin
      if Odd(i) then
        soma:= soma + (strtoint(AGTIN[i]) * 1)
      else
        soma:= soma + (strtoint(AGTIN[i]) * 3);
    end
    else
    begin
      if Odd(i) then
        soma:= soma + (strtoint(AGTIN[i]) * 3)
      else
        soma:= soma + (strtoint(AGTIN[i]) * 1);
    end;
  end;

  base10:= soma;
  //Verifica se base10 é múltiplo de 10
  if not (base10 mod 10 = 0) then
  begin
    while not (base10 mod 10 = 0) do
    begin
      base10:= base10 + 1;
    end;
  end;
  resultado:= base10 - soma;
  //Verifica se o resultado encontrado é igual ao caractere de controle
  if resultado = strtoint(AGTIN[Length(AGTIN)]) then
    Result:= True
  else
    Result:= False;

end;


function CaracteresHTML(pP1:String):String;
begin
  pP1 := StrTran(pP1,'<',' ');
  pP1 := StrTran(pP1,'>',' ');
  //
  Result := ConverteAcentos(pP1);
end;

function Numero_Sem_Endereco(sP1:String): String;
begin
  if Limpanumero(sP1) = '' then
  begin
    Result := '0';
  end else
  begin
    if Pos(',',sP1) <> 0 then
    begin
      Result := AllTrim(Copy(sP1,Pos(',',sP1)+1,Length(sp1)-Pos(',',sP1)+1));
      if Pos(' ',Result) <> 0 then
      begin
        Result := Copy(Result,1, Pos(' ',Result));
      end;
      Result := LimpaNumero(Result);
      if Result = '' then Result := '0';
    end else
    begin
      Result := Limpanumero(sP1);
    end;
  end;
end;


function Endereco_Sem_Numero(sP1:String): String;
begin
  if Numero_Sem_Endereco(sP1) <> '0' then
    Result := StrTran(StrTran(StrTran(sP1,Numero_Sem_Endereco(sP1),''),',',''),'  ',' ')
  else
    Result :=  sP1;
end;

{Sandro Silva 2023-10-16 inicio}
function ExtraiEnderecoSemONumero(Texto: String): String;
var
 iPosicaoNumero: Integer;
 i: Integer;
 sNumero: String;
begin
  // Método criado para geração do XML da NF-e
  // Para ser usado em outras rotinas, substituindo o outro método similar, deverá ser consultado o P.O. e analisando o impacto da mudança de comportamento
  Texto := Trim(Texto); // Sandro Silva 2023-10-25 Espaçamentos no início e final do texto impedem de extrair corretamente a informação (Ficha 7498)
  iPosicaoNumero := 0;
  for i := Length(Texto) DownTo 0 do
  begin
    if Copy(Texto, i, 1) = ',' then
    begin
      iPosicaoNumero := i;
      Break
    end;
  end;

  if iPosicaoNumero = 0 then
  begin
    for i := Length(Texto) DownTo 0 do
    begin
      if Copy(Texto, i, 1) = ' ' then
      begin
        iPosicaoNumero := i;
        Break
      end;
    end;
  end;

  Result := Copy(Texto, 1, iPosicaoNumero - 1);
  // Validando quando o endereço não tiver um número e vírgula separando o texto que representaria o número
  // Quando o endereço tiver somente o nome da rua (Rua Getulio Vargas) não retornar a última parte do nome da rua (Vargas) como sendo o número
  if AnsiContainsText(Texto, ',') = False then
  begin
    sNumero := Copy(Texto, iPosicaoNumero, Length(Texto));
    if (LimpaNumero(sNumero) = '') and (AnsiContainsText(sNumero, 'S/N') = False) then
      Result := Texto;
  end;
end;

function ExtraiNumeroSemOEndereco(Texto: String): String;
begin
  // Método criado para geração do XML da NF-e
  // Para ser usado em outras rotinas, substituindo o outro método similar, deverá ser consultado o P.O. e analisando o impacto da mudança de comportamento
  Texto := Trim(Texto); // Sandro Silva 2023-10-25 Espaçamentos no início e final do texto impedem de extrair corretamente a informação (Ficha 7498)
  Result := StringReplace(Texto, ExtraiEnderecoSemONumero(Texto), '', [rfReplaceAll]);
  Result := Trim(StringReplace(Result, ', ' , '', [rfReplaceAll]));
  if Copy(Result, 1, 1) = ',' then
    Result := Copy(Result, 2, Length(Result));
  if Trim(Result) = '' then
    Result := 'S/N';
end;
{Sandro Silva 2023-10-16 fim}

function ValidaEmail(AcEmail: String): Boolean;
begin
  Result := TTestaEmail.New
                       .setEmail(AcEmail)
                       .Testar;
end;

function RetornaListaQuebraLinha(AcTexto: string; AcCaracQuebra: String = ';'): TStringList;
begin
  Result := TStringList.Create;

  if (Pos(AcCaracQuebra, AcTexto) <= 0) and (Trim(AcTexto) <> EmptyStr) then
    Result.Add(AcTexto)
  else
  begin
    while Pos(AcCaracQuebra, AcTexto) > 0 do
    begin
      Result.Add(Copy(AcTexto, 1, Pos(AcCaracQuebra, AcTexto)-Length(AcCaracQuebra)));
      AcTexto := Copy(AcTexto, Pos(AcCaracQuebra, AcTexto) + Length(AcCaracQuebra), Length(AcTexto));
    end;
    if AcTexto <> EmptyStr then
      Result.Add(AcTexto);
  end;
end;


procedure ValidaValor(Sender: TObject; var Key: Char; tipo: string);
begin
  If Tipo='L' then
  begin
   If not (key in ['A'..'Z',#8, ' ']) then
     key:=#0 ;
  end;

  //Inteiro
  If Tipo='I' then
  begin
    If not (key in ['0'..'9',#8]) then
      key:=#0;

    If (Key in ['E','e']) then
      key:=#0;
  end;

  //Float
  If Tipo='F' then
  begin
    If not (key in ['0'..'9',#8,',']) then
      key:=#0;

    If (Key in ['E','e']) then
     key:=#0;

    ValidaAceitaApenasUmaVirgula(TCustomEdit(Sender),Key);
  end;

  If Tipo='A' then
  begin
    If not (key in ['A'..'Z','0'..'9',#8, ' ', ',', '.', '^', '~', '´', '`', '/', '?', '°', ';', ':', '<', '>',
                      '[', ']', '\', '|', '{', '}', '+', '=', '-', '_', '(', ')', '*', '&', '"', '%', '$', '#', '@', '!']) then
       key:=#0 ;
  end;
end;



procedure ValidaAceitaApenasUmaVirgula(edit: TCustomEdit; var Key: Char);
var
  vTextSelecionado: string;
begin
  vTextSelecionado := Copy(edit.Text, edit.SelStart + 1, edit.SelLength);
                          
  If (key = ',') and not (AnsiContainsText(vTextSelecionado, ',')) then //Se tiver com virgula selecionada vai substituir, logo, pode usar virgula
    If AnsiContainsStr(edit.Text,',') then
      key := #0;
end;

{Sandro Silva 2023-09-22 inicio  Movido para uConverteHtmlToPDF
function HtmlToPDF(AcArquivo: String): Boolean;
var
  cCaminhoEXE: String;
begin
  cCaminhoEXE := GetCurrentDir;
  try
    //
    while FileExists(pChar(AcArquivo+'.pdf')) do
    begin
      //
      try
        DeleteFile(pChar(AcArquivo+'.pdf'));
        DeleteFile(pChar(AcArquivo+'_.pdf'));
      except end;
      //
      Sleep(10);
      //
    end;
    //
    chdir(pChar(cCaminhoEXE+'\HTMLtoPDF'));
    //
    while FileExists(pChar('tempo_ok.pdf')) do
    begin
      DeleteFile(pChar('tempo_ok.pdf'));
      Sleep(10);
    end;
    //
    while FileExists(pChar('tempo.pdf')) do
    begin
      DeleteFile(pChar('tempo.pdf'));
      Sleep(10);
    end;
    //
    ShellExecute( 0, 'runas', pChar('html2pdf'),pchar('"'+cCaminhoEXE+'\'+AcArquivo+'.htm" "tempo.pdf"'), '', SW_HIDE);
    Sleep(10);
    //
    while not FileExists(pChar(cCaminhoEXE+'\HTMLtoPDF\tempo_ok.pdf')) do
    begin
      RenameFile(pChar(cCaminhoEXE+'\HTMLtoPDF\tempo.pdf'),pChar(cCaminhoEXE+'\HTMLtoPDF\tempo_ok.pdf'));
      Sleep(10);
    end;
    //
    chdir(pChar(cCaminhoEXE));
    //
    CopyFile(pChar(cCaminhoEXE+'\HTMLtoPDF\tempo_ok.pdf'), pChar(AcArquivo+'_.pdf'),False);
    //
    while not FileExists(pChar(AcArquivo+'.pdf')) do
    begin
      RenameFile(pChar(AcArquivo+'_.pdf'), pChar(AcArquivo+'.pdf'));
      Sleep(10);
    end;
    //
  except end;
  //
  Result := True;
end;
Sandro Silva 2023-09-22 fim}


function processExists(exeFileName: string): Boolean;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(exeFileName)) or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(exeFileName))) then
    begin
      Result := True;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

function ConsultaProcesso(sDescricao:String): boolean;//Mauricio Parizotto 2023-08-09
var
  Snapshot: THandle;
  ProcessEntry32: TProcessEntry32;
begin
  Result   := False;
  Snapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);

  if (Snapshot = Cardinal(-1)) then
    exit;

  ProcessEntry32.dwSize := SizeOf(TProcessEntry32);

  // pesquisa pela lista de processos
  if (Process32First(Snapshot, ProcessEntry32)) then
  repeat
    // enquanto houver processos
    // SubItems.Add(IntToStr(ProcessEntry32.th32ParentPro cessID));
    if ProcessEntry32.szExeFile = sDescricao then
      Result := True;
  until not Process32Next(Snapshot, ProcessEntry32);

  CloseHandle (Snapshot);
end;

end.








































//                                                                     //
//                                                                     //
//   _____  __  __  _____  __     __     _____  _____  _____  ______   //
//  /  ___>|  \/  |/  _  \|  |   |  |   /  ___>/     \|  ___||_    _|  //
//  \___  \|      ||  _  ||  |__ |  |__ \___  \|  |  ||  __|   |  |    //
//  <_____/|_|\/|_|\_/ \_/|_____||_____|<_____/\_____/|__|     |__|    //
//                                                                     //
//  All rights reserved                                                //
//                                                                     //
