{*******************************************************}
{                                                       }
{     Unit contendo métodos de uso em comum no Small    }
{                                                       }
{ Copyright(c) 2022 Smallsoft Tecnologia                }
{ Autores: Ronei Ivo Weber                              }
{          Sandro Luis da Silva                         }
{          Gabriel Rogelin                              }
{          Mauricio Parizotto                           }
{                                                       }
{*******************************************************}

unit smallfunc_xe;

interface

uses
  {$IFDEF VER150}
  Classes, SysUtils, StrUtils, Dialogs, IniFiles, Forms, Printers
  , ExtCtrls, IBDatabase, IBQuery, Controls, DBCtrls, StdCtrls
  , Mask, TLHelp32
  {$ELSE}
  System.Classes, System.SysUtils, System.StrUtils, Vcl.Dialogs
  , System.IniFiles, Winapi.WinSock, Vcl.Forms, Soap.EncdDecd
  , Vcl.Printers, Vcl.ExtCtrls, IBX.IBDatabase, IBX.IBQuery
  , Vcl.Controls, Vcl.DBCtrls , Vcl.StdCtrls, Vcl.Mask
  , Winapi.TlHelp32
  {$ENDIF}
  , Windows
  , IdBaseComponent, IdCoder, IdCoder3to4, IdCoderMIME
  , LbCipher, LbClass // 2020-07-21
  , JPeg, Menus
  , DateUtils
  , ShellApi
  , msxmldom
  , XMLDoc
  , xmldom
  , XMLIntf
  , MsXml
  , uConectaBancoSmall
  , uconstantes_chaves_privadas
  ;


const CORPADRAOCARREGAMENTO = $008FC26C;
const CORTITULOGRID         = $00F0F0F0;
const COR_CAMPO_OBRIGATORIO = $0080FFFF; //Mauricio Parizotto 2022-09-14
//Sandro Silva 2021-07-05 migrado para function const IMAGEMICONESSMALL     = 'inicial\Small_21_.bmp';

type
  TConsisteInscricaoEstadual  = function (const Insc, UF: AnsiString): Integer; stdcall; // Usar dinamicamente a dll para validar IE obtida em http://www.sintegra.gov.br/

function ImagemIconesSmall: String;
{$IFNDEF VER150}
function GetIP: String;
{$ENDIF}
function FusoHorarioPadrao(UF: String): String;
function CpfCgc(pP1: String): Boolean;
function FormataCpfCgc(pP1:String):String;
function LimpaNumero(pP1:String):String;
//2020-10-29 function ConsisteInscricaoEstadual(sIE, sUF: String): Boolean; StdCall; External 'DllInscE32.Dll';
function ConsisteInscricaoEstadual(sIE: String; sUF: String): Boolean;
function DecodeBase64(Value: String): String;
function EncodeBase64(Value: String): String;
{$IFNDEF VER150}
function EncodeStreamBase64(Stream: TFileStream): String;
{$ENDIF}
function LerParametroIni(sArquivo: String; sSecao: String;
  sParametro: String; sValorDefault: String): String;
function GravarParametroIni(sArquivo: String; sSecao: String;
  sParametro: String; sValor: String): String;
function AllTrim(Texto: String): String;
function StrTran(sP1,sP2,sP3 : string):String;
function ConverteAcentos(pP1:String):String;
function ConverteAcentos2(pP1:String):String;
function ConverteAcentosXML(pP1: String): String;
function DateToStrInvertida(Data:TdateTime): String;
function Numero_Sem_Endereco(sP1:String): String;
function Endereco_Sem_Numero(sP1:String): String;
function PrimeiraMaiuscula(pP1:String):String;
function Arredonda(fP1 : Real; iP2 : Integer): Real;
function Arredonda2(fP1 : Double; iP2 : Integer): Double;
function ValidaEAN13(sP1:String):Boolean;
function _ecf65_ValidaGtinNFCe(sEan: String): Boolean;
function RetornaValorDaTagNoCampo(sTag: String; sObs: String): String;
function FormatFloatXML(dValor: Double; iPrecisao: Integer = 2): String;
function StrZero(Num : Double ; Zeros,Deci: integer): string;
function Replicate(pP1:String; pP2:Integer):String;
function LimpaNumeroDeixandoAVirgula(pP1:String):String;
function Year(Data:TdateTime): Integer;
{$IFNDEF VER150}
function GetLocalIP: string;
{$ENDIF}
function LimpaNumeroVirg(pP1:String):String;
procedure FecharAplicacao(sNomeExecutavel: String);
function VersaoExe(sNomeExe: String = ''): String; //2020-07-31 Sandro Silva function VersaoExe: String;
function Right(S : String; numCaracteres : Byte) : String;
function FORMATA_TELEFONE(Fone:String):String;
function DDDTelefone(Telefone: String): String;
function TelefoneSemDDD(Telefone: String): String;
function ZeroESQ(sP1 : string):String;
function FormataCEP(P1:String) : String;
function VerificaSeTemImpressora(): Boolean;
procedure MostraImagem(ImgOri: TImage; ImgDest: TImage; iPosIniX: Integer; iPosIniY: Integer);
procedure MostraImagemCoordenada(ImgOri: TImage; ImgDest: TImage; Linha:integer; Coluna: Integer; Tamanho : integer = 70);
function WindowsDir: String;
function base64encode(const Text : AnsiString): AnsiString;
function base64Decode(const Text : ansiString): ansiString;
//function CriaIBTransaction(IBDatabase: TIBDatabase): TIBTransaction; Movido para uConectaBancoSmall
//function CriaIBQuery(IBTRANSACTION: TIBTransaction): TIBQuery; Movido para uConectaBancoSmall
function IntToBin(pP1:Integer ):String;
function DiretorioAplicacao: String;
function MesExtenso(pP1:Integer):String;
function CriaJpg(sP1: String): Boolean;
procedure PosicionarMenuPopUp(Parent: TObject; Sender: TObject;
  PopupMenu: TPopupMenu; Ancora: TAnchorKind = akTop);
function DefineFusoHorario(ArquivoIni: String; SecaoIni: String;
  ChaveIni: String; sUF: String; sFuso: String; bHorarioVerao: Boolean): String;
function HabilitaHorarioVerao(ArquivoIni: String; SecaoIni: String;
  ChaveIni: String; sUF: String; bHabilita: Boolean): String;
procedure AdicionaRegraEntradaNoFirewall(NomeEntrada : String;
  NomePrograma : String; Protocolo: String; Allow : Boolean = True);
{$IFNDEF VER150}
procedure ValidaValor(Sender: TObject; var Key: Char; tipo: string);
{$ENDIF}
procedure ValidaAceitaApenasUmaVirgula(edit: TCustomEdit; var Key: Char);
function SysWinDir: string;
function SmallMsgBox(const Text, Caption: PChar; Flags: Longint): Integer;
function Day(Data:TdateTime): Integer;
function xmlNodeValue(sXML: String; sNode: String): String;
function xmlNodeValueToDate(sXML: String; sNode: String): TDate;
function xmlNodeValueToFloat(sXML: String; sNode: String): Double;
function SysComputerName: String;
function ConsultaProcesso(sDescricao:String): boolean;//Mauricio Parizotto 2023-08-09
function WinVersion: string;
Function LimpaLetras(pP1:String):String;
{$IFNDEF VER150}
function IsNumericString(S:String):Boolean;
{$ENDIF}
function Extenso(pP1:double):String;
function DiasParaExpirar(IBDATABASE: TIBDatabase; bValidacaoNova: Boolean = True): Integer;
function BuscaSerialSmall: String;
// Sandro Silva 2023-09-22 function HtmlToPDF(AcArquivo: String): Boolean;

var
  IMG: TImage;

implementation


function ImagemIconesSmall: String;
begin
  {
  if FileExists('inicial\Small_21_.bmp') then // Provisório, para manter compatível versão 2021 e 2022
    Result := 'inicial\Small_21_.bmp'
  else
  }
  Result := 'inicial\Small_22_.bmp';
end;

{$IFNDEF VER150}
function GetIP: String;
type
  TaPInAddr = array [0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostEnt;
  pptr: PaPInAddr;
  Buffer: array [0..63] of Ansichar;
  i: Integer;
  GInitData: TWSADATA;
begin
  WSAStartup($101, GInitData);
  Result := '';
  GetHostName(Buffer, SizeOf(Buffer));
  phe := GetHostByName(Buffer);
  if phe = nil then
    Exit;
  pptr := PaPInAddr(phe^.h_addr_list);
  i := 0;
  while pptr^[i] <> nil do
  begin
    Result := StrPas(inet_ntoa(pptr^[i]^));
    Inc(i);
  end;
  WSACleanup;
end;
{$ENDIF}

function FusoHorarioPadrao(UF: String): String;
// Retorna o fuso horário padrão para a UF
// Abaixo as UF estão ordenadas por região (Sul, sudeste, Centro-Oeste, Norte, Nordeste)
begin
  Result := '-03:00';
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

function CpfCgc(pP1: String): Boolean;
var
I,J,K,SOMA,DIGITO: Integer;
MULT,DIGITOS,CONTROLE: String;
begin
  if Length(Trim(pP1)) > 0 then
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

function LimpaNumero(pP1:String):String;
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

function LerParametroIni(sArquivo: String; sSecao: String;
  sParametro: String; sValorDefault: String): String;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(sArquivo);

  try
    Result := Trim(Ini.ReadString(sSecao, sParametro, sValorDefault));
  except
  end;
  FreeAndNil(Ini);
end;

function GravarParametroIni(sArquivo: String; sSecao: String;
  sParametro: String; sValor: String): String;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(sArquivo);

  try
    Ini.WriteString(sSecao, sparametro, sValor);
  except
  end;
  FreeAndNil(Ini);
end;

function ConsisteInscricaoEstadual(sIE: String; sUF: String): Boolean;
var
  LibHandle                 : THandle;
  ConsisteInscricaoEstadual : TConsisteInscricaoEstadual;
begin
  Result := False;
  try
    LibHandle := LoadLibrary('DllInscE32.Dll');
    if LibHandle <= HINSTANCE_ERROR then
    begin
      //raise Exception.Create ('Dll não carregada');
    end
    else
    begin
      @ConsisteInscricaoEstadual := GetProcAddress(LibHandle, 'ConsisteInscricaoEstadual');
      if @ConsisteInscricaoEstadual = nil then
      begin
        //raise Exception.Create('Entrypoint Download não encontrado na Dll');
      end
      else
      begin
        Result := (ConsisteInscricaoEstadual(AnsiString(sIE),AnsiString(sUF)) = 0);
      end;
    end;

  finally
    FreeLibrary (LibHandle);
  end;

end;



function DecodeBase64(Value: String): String;
var
  IdDecoderMIME1: TIdDecoderMIME;
begin
  IdDecoderMIME1 := TIdDecoderMIME.Create(nil);

  try
    Result := IdDecoderMIME1.DecodeString(Value);
  except
    Result := '';
  end;
  FreeAndNil(IdDecoderMIME1);
end;

function EncodeBase64(Value: String): String;
var
  IdEncoderMIME1: TIdEncoderMIME;
begin
  IdEncoderMIME1 := TIdEncoderMIME.Create(nil);

  try
    Result := IdEncoderMIME1.EncodeString(Value);
  except
    Result := '';
  end;
  FreeAndNil(IdEncoderMIME1);
end;
{$IFNDEF VER150}
function EncodeStreamBase64(Stream: TFileStream): String;
var
  IdEncoderMIME1: TIdEncoderMIME;
begin
  IdEncoderMIME1 := TIdEncoderMIME.Create(nil);

  try
    Result := IdEncoderMIME1.EncodeStream(Stream);
  except
    Result := '';
  end;
  FreeAndNil(IdEncoderMIME1);
end;
{$ENDIF}
function AllTrim(Texto: String): String;
begin
  Result := Trim(Texto);
end;

function StrTran(sP1,sP2,sP3 : string):String;
//pP1 String, pP2 trecho a ser substituido, pP3 trecho novo
begin
   while(Pos(sP2,sP1)<>0) do
   begin
     Insert(sP3,sP1,pos(sP2,sP1));
     Delete(sP1,pos(sP2,sP1),length(sP2));
   end;
   Result := sP1;
end;

function ConverteAcentos(pP1:String):String;
var
   I:Integer;
begin
  Result:=pP1;
  for I := 1 to 44 do
    Result := strtran( Result
                    ,copy('ÁÀÂÄÃÉÈÊËÍÎÏÓÔÕÚÜÇáàâäãåéèêëíîïìóôõòöúüùûç*º',I,1)
                    ,copy('AAAAAEEEEIIIOOOUUCaaaaaaeeeeiiiiooooouuuuc .',I,1));
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

function ConverteAcentosXML(pP1: String): String;
// Sandro Silva 2016-07-14 Para substituir onde usa ConverteAcentos2. Permite caractere cifrão $
var
  I:Integer;
begin
  pP1 := ConverteAcentos(pP1);
  Result:='';
  for I := 1 to length(pP1) do
  begin
    if Pos(AnsiUpperCase(Copy(pP1,I,1)),'1234567890ABCDEFGHIJKLMNOPQRSTUVXYZW,/.-()%$') > 0 then
      Result := Result+Copy(pP1,I,1) else Result := Result+' ';
  end;
end;


function DateToStrInvertida(Data:TdateTime): String;
begin
  Result := Copy(DateToStr(Data),7,4)+'/'+Copy(DateToStr(Data),4,2)+'/'+Copy(DateToStr(Data),1,2);
end;

function Numero_Sem_Endereco(sP1:String): String;
begin
  //
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
  //
end;

function Endereco_Sem_Numero(sP1:String): String;
begin
  //
  if Numero_Sem_Endereco(sP1) <> '0' then Result := StrTran(StrTran(StrTran(sP1,Numero_Sem_Endereco(sP1),''),',',''),'  ',' ') else Result :=  sP1;
  //
end;

function PrimeiraMaiuscula(pP1: String): String;
Var
  I:integer;
begin
  Result := AnsiUpperCase(pP1);
  for I := 2 to Length(pP1) do
  begin
    if Copy(pP1, I-1, 1) <> ' ' then
    begin
      if Copy(pP1, I-1, 1) <> '.' then
      begin
          Delete(Result,I,1);
          Insert(AnsiLowerCase(Copy(pP1, I, 1)), Result, I);
      end;
    end;
  end;
end;

function Arredonda(fP1 : Real; iP2 : Integer): Real;
begin
  Result := StrToFloat(StrTran(Format('%14.'+IntToStr(iP2)+'n',[fP1]),'.',''));
end;

function Arredonda2(fP1 : Double; iP2 : Integer): Double;
begin
  //
  // Problema de campos no bd double precision ou valores com dizima resolvi desta forma mas nao entendo como isso funciona
  //
  fp1 := StrToFloat(FloatToStr(fP1));
  Result := StrToFloat(StrTran(Format('%14.'+IntToStr(iP2)+'n',[fP1]),'.',''));
  //
end;

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
  //
  if Length(LimpaNumero(sP1))=13 then
  begin
    //
    SomaPar:=0;
    SomaImpar:=0;
    //
    for i:=1 to 12 do
    if Par(i) then
    SomaPar:=SomaPar+StrToInt(sP1[i])
    else SomaImpar:=SomaImpar+StrToInt(sP1[i]);
    //
    SomaPar:=SomaPar*3;
    i:=0;
    while i < (SomaPar+SomaImpar) do
    Inc(i,10);
    //
    if Copy(sP1,13,1) = IntToStr(i-(SomaPar+SomaImpar)) then Result := True else Result := False;
  end else
  begin
    Result := False;
  end;
  //
end;

function _ecf65_ValidaGtinNFCe(sEan: String): Boolean;
// Sandro Silva 2019-06-11
// Valida se o Gtin informado é válido, usando ValidaEAN() e comparando o prefixo
// Prefixo 781 e 792 indicam EAN de uso interno não registrado no GS1
begin
  Result := ValidaEAN13(LimpaNumero(sEan));
  if Result then
  begin
    if (Copy(LimpaNumero(sEan), 1, 3) = '781') or (Copy(LimpaNumero(sEan), 1, 3) = '792') then
      Result := False;
  end;
end;

function RetornaValorDaTagNoCampo(sTag: String; sObs: String): String;
// Exemplo: Obs= <descANP>GLP</descANP> retorna GLP
//          Obs= <descANP>GLP<descANP> retorna GLP
var
  sTextoTag: String;
begin
  Result := '';
  sObs := Trim(sObs);
  sObs := StringReplace(sObs, #$D#$A, '', [rfReplaceAll]); // Eliminar quebras de linha geradas no cadastro de produto pelo campo blob
  if AnsiContainsText(sObs, '<' + sTag + '>') then
  begin
    sTextoTag := Copy(sObs, Pos('<' + sTag + '>', sObs) + Length('<' + sTag + '>'), Length(sObs));
    sTextoTag := StringReplace(STextoTag, '</' + sTag, '<' + sTag, []);
    Result := Copy(sTextoTag, 1, Pos('<' + sTag + '>', STextoTag) -1);
  end;
end;

function FormatFloatXML(dValor: Double; iPrecisao: Integer = 2): String;
// Sandro Silva 2015-12-10 Formata valor float com 2 casas decimais para usar nos elementos do xml da nfce
// Parâmetros:
// dValor: Valor a ser formatado
// iPrecisao: Quantidade de casas decimais resultante no valor formatado. Por default formata com 2 casas. Ex.: 2 = 0,00; 3 = 0,000
var
  sMascara: String;
begin
  sMascara := '##0.' + DupeString('0', iPrecisao);
  Result := StrTran(Alltrim(FormatFloat(sMascara, dValor)), ',', '.'); // Quantidade Comercializada do Item
end;

function StrZero(Num : Double ; Zeros,Deci: integer): string;
begin
   Result:='';
   Result:=Result+StrTran(Format('%'+intToStr(Zeros)+'.'+intToStr(Deci)+'f',[Num]),' ','0');
   if pos('-',Result) > 0 then begin
      Delete(Result,pos('-',Result),1);
      Result:='-'+Result;
   end;
end;

function Replicate(pP1:String; pP2:Integer):String;
var I:Integer;
begin
   Result:='';
   For I := 1 to pP2 do
      Result:=Copy(Result+pP1,1,I);
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

function Year(Data:TdateTime): Integer;
var
   DataD:TdateTime;
begin
   DataD:=Date;
   if Data <> DataD then DataD:=Data;
   result:=StrToInt(Copy(DateToStr(DataD),7,2));
   if length(DateToStr(DataD))= 10 then result:=StrToInt(Copy(DateToStr(DataD),7,4));
end;
{$IFNDEF VER150}
function GetLocalIP: string;
type
  TaPInAddr = array [0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostEnt;
  pptr: PaPInAddr;
  Buffer: array [0..63] of Ansichar;
  i: Integer;
  GInitData: TWSADATA;
begin
  WSAStartup($101, GInitData);
  Result := '';
  GetHostName(Buffer, SizeOf(Buffer));
  phe := GetHostByName(Buffer);
  if phe = nil then
    Exit;
  pptr := PaPInAddr(phe^.h_addr_list);
  i := 0;
  while pptr^[i] <> nil do
  begin
    Result := StrPas(inet_ntoa(pptr^[i]^));
    Inc(i);
  end;
  WSACleanup;
end;
{$ENDIF}

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

procedure FecharAplicacao(sNomeExecutavel: String);
begin
  //Mais eficiente para encerrar as aplicações
  //Substitui os comandos "Application.Terminate" e "Halt(1)"
  //FecharAplicacao(ExtractFileName(Application.ExeName));
  WinExec(PAnsiChar(AnsiString('TASKKILL /F /IM "'+sNomeExecutavel+'"')),SW_HIDE); // Sandro Silva 2021-06-24 WinExec(PansiChar('TASKKILL /F /IM "'+sNomeExecutavel+'"'),SW_HIDE);
end;


function VersaoExe(sNomeExe: String = ''): String; // 2020-07-31 Sandro Silva function VersaoExe: String;
// Retorna a versão do executável. Quando não informar parâmetro sNomeExe usará como nome a aplicação em execução
type
  PFFI = ^vs_FixedFileInfo;
var
  F : PFFI;
  Handle : Dword;
  Len : Longint;
  Data : Pchar;
  Buffer : Pointer;
  Tamanho : Dword;
  Parquivo: Pchar;
  Arquivo : String;
begin
  {2020-07-31 Sandro Silva inicio
  Arquivo := Application.ExeName;
  }
  if Trim(sNomeExe) <> '' then
    Arquivo := sNomeExe
  else
    Arquivo := Application.ExeName;
  {2020-07-31 Sandro Silva fim}

  Parquivo := StrAlloc(Length(Arquivo) + 1);
  StrPcopy(Parquivo, Arquivo);
  Len := GetFileVersionInfoSize(Parquivo, Handle);
  Result := '';

  if Len > 0 then
  begin
    Data:=StrAlloc(Len+1);

    if GetFileVersionInfo(Parquivo,Handle,Len,Data) then
    begin
      VerQueryValue(Data, '\',Buffer,Tamanho);
      F := PFFI(Buffer);
      Result := Format('%d.%d.%d.%d',
      [HiWord(F^.dwFileVersionMs),
      LoWord(F^.dwFileVersionMs),
      HiWord(F^.dwFileVersionLs),
      Loword(F^.dwFileVersionLs)]);
    end;

    StrDispose(Data);
  end;

  StrDispose(Parquivo);
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

function DDDTelefone(Telefone: String): String;
// Retorna o DDD do número de telefone informado
begin
  Result := LimpaNumero(Copy(Telefone, 1, Pos(')', Telefone)));
end;

function TelefoneSemDDD(Telefone: String): String;
//Retorna o número de telefone sem o DDD e sem máscara
begin
  Result := LimpaNumero(Copy(Telefone, Pos(')', Telefone), Length(Telefone)));
end;

function ZeroESQ(sP1 : string):String;
begin
  if sp1 <> '' then
    Result := FloatToStr(StrToFloatDef(LimpaNumeroVirg(sP1), 0)) // Result := FLOATTOSTR(STRTOFLOAT(LimpaNumeroVirg('0'+sP1)))
  else
    Result := '';
end;

function FormataCEP(P1:String) : String;
begin
  P1 := LimpaNumero(P1);
  P1 := Copy(P1,1,5)+'-'+Copy(P1,6,3);
  Result := P1;
end;

function VerificaSeTemImpressora(): Boolean;
var
   Device : array[0..255] of char;
   Driver : array[0..255] of char;
   Port   : array[0..255] of char;
   hDMode : THandle;
begin
   Result := True;
   // Retorna a impressora padrão do windows
   try
      Printer.GetPrinter(Device, Driver, Port, hDMode);
   except
      Result:=False;
   end;
end;

procedure MostraImagem(ImgOri: TImage; ImgDest: TImage; iPosIniX: Integer; iPosIniY: Integer);
begin
  ImgDest.Picture := nil;
  try
    ImgDest.Canvas.CopyRect(Rect(0, 0, ImgDest.Height, ImgDest.Width), ImgOri.Canvas, Rect(iPosIniX, iPosIniY, iPosIniX + ImgDest.Height, iPosIniY + ImgDest.Width));
    ImgDest.Picture.Bitmap.TransparentColor := ImgDest.Picture.BitMap.Canvas.Pixels[1,1];
  except

  end;
end;

{Mauricio Parizotto 2021-07-07 Inicio}
procedure MostraImagemCoordenada(ImgOri: TImage; ImgDest: TImage; Linha:integer; Coluna: Integer; Tamanho : integer = 70);
var
  iPosIniX,iPosIniY : integer;
  margemSup : integer;
begin
  ImgDest.Picture := nil;
  try
    if Linha > 4 then
      margemSup := 40
    else
      margemSup := 30;

    iPosIniY := margemSup + (Tamanho*(Linha-1));
    iPosIniX := 10 + (Tamanho*(Coluna-1));

    ImgDest.AutoSize := False;
    ImgDest.Height   := Tamanho;
    ImgDest.Width    := Tamanho;

    ImgDest.Canvas.CopyRect(Rect(0, 0, ImgDest.Height, ImgDest.Width), ImgOri.Canvas, Rect(iPosIniX, iPosIniY, iPosIniX + ImgDest.Height, iPosIniY + ImgDest.Width));
    ImgDest.Picture.Bitmap.TransparentColor := ImgDest.Picture.BitMap.Canvas.Pixels[1,1];
  except

  end;
end;
{Mauricio Parizotto 2021-07-07 Fim}

function WindowsDir: String;
// Retorna o Diretório do Windows
var
  PWindowsDir: array [0..255] of AnsiChar;
begin
  GetWindowsDirectoryA(PWindowsDir, 255);
  Result := StrPas(PWindowsDir);
end;


function base64encode(const Text : AnsiString): AnsiString;
var
  Encoder : TIdEncoderMime;
begin
  Encoder := TIdEncoderMime.Create(nil);
  try
    Result :=  Encoder.EncodeString(Text);
  finally
    FreeAndNil(Encoder);
  end
end;

function base64Decode(const Text : ansiString): ansiString;
var
  Decoder : TIdDecoderMime;
begin
  Decoder := TIdDecoderMime.Create(nil);
  try
    Result := Decoder.DecodeString(Text);
  finally
    FreeAndNil(Decoder)
  end
end;

function IntToBin(pP1:Integer ):String;
begin
   Result := '';
   while pP1 >= 2 do
   begin
     Result := IntToStr( pP1 - pP1 div 2 * 2 ) +  Result;
     pP1 := pP1 div 2;
   end;
   Result:= IntToStr(pP1) + Result;
end;

function DiretorioAplicacao: String;
begin
  Result := ExtractFilePath(Application.ExeName);
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

function CriaJpg(sP1: String): Boolean;
var
  jp: TJPEGImage;  //Requires the "jpeg" unit added to "uses" clause.
  Image: TImage;
begin
  //
  Image := TImage.Create(Application);
  if FileExists(sP1) then
    Image.Picture.LoadFromFile(sP1)
  else
    Image.Picture := nil;//Form24.Image2.Picture;
  //
  if Image.Picture <> nil then
  begin
    try
      jp := TJPEGImage.Create;
      jp.Assign(Image.Picture.Bitmap);
      jp.CompressionQuality := 100;
      jp.SaveToFile('logotip.jpg');
      FreeAndNil(jp);
      FreeAndNil(Image);
    except
    end;
  end;
  //
  Result := True;
  //
end;

procedure PosicionarMenuPopUp(Parent: TObject; Sender: TObject;
  PopupMenu: TPopupMenu; Ancora: TAnchorKind = akTop);
var
  Ponto: TPoint;
begin
  begin
    if PopupMenu = nil then
       Exit
    else
    begin
      GetCursorPos(Ponto);
      Ponto.X := (Sender as TControl).Left + 1;
      if Ancora = akTop then {Posiciona a partir do top do objeto}
        Ponto.Y := (Sender as TControl).Top - TControl(PopupMenu).Height - 15
      else
        if Ancora = akBottom then {Posiciona a partir do bottom do objeto}
          Ponto.Y := (Sender as TControl).Top + (Sender as TControl).Height + 1;
      Ponto := TControl(Parent).ClientToScreen(Ponto);
      PopupMenu.popup(Ponto.X, Ponto.Y);
    end;
  end;
end;

function DefineFusoHorario(ArquivoIni: String; SecaoIni: String;
  ChaveIni: String; sUF: String; sFuso: String; bHorarioVerao: Boolean): String;
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

procedure AdicionaRegraEntradaNoFirewall(NomeEntrada : String;
  NomePrograma : String; Protocolo: String; Allow : Boolean = True);
// Protocolo = [ANY, TCP, UDP]
begin
  // Primeiro exclui a regra
  WinExec(PAnsiChar(AnsiString('netsh advfirewall firewall delete rule name=' + NomeEntrada + ' protocol=' + Protocolo)), SWP_HIDEWINDOW);
  Sleep(100);
  // Adiciona a regra
  WinExec(PAnsiChar(AnsiString('netsh advfirewall firewall add rule name=' + NomeEntrada + ' dir=in program="' + NomePrograma + '"  action=allow protocol=' + Protocolo)), SWP_HIDEWINDOW);
end;

{$IFNDEF VER150}
procedure ValidaValor(Sender: TObject; var Key: Char; tipo: string);
begin
  {If (key = #13) then
  begin
     key := #0;
     SelectNext((Sender as TwinControl),true,true);
  end;}
  If Tipo='L' then
  begin
     If not CharInSet(key, ['A'..'Z',#8, ' ']) then
       key:=#0 ;
  end;
  //Inteiro
  If Tipo='I' then
  begin
     If not CharInSet(key,['0'..'9',#8]) then
        key:=#0;
     If CharInSet(Key ,['E','e']) then
      key:=#0;
  end;
  //Float
  If Tipo='F' then
  begin
     If not CharInSet(key,['0'..'9',#8,',']) then
        key:=#0;
     If CharInSet(Key ,['E','e']) then
      key:=#0;
     if Sender is TDBEdit then
      ValidaAceitaApenasUmaVirgula(TDBEdit(Sender),Key);
    if Sender is TEdit then
      ValidaAceitaApenasUmaVirgula(TEdit(Sender),Key);
    if Sender is TLabeledEdit then
      ValidaAceitaApenasUmaVirgula(TLabeledEdit(Sender),Key);
    if Sender is TMaskEdit then
      ValidaAceitaApenasUmaVirgula(TMaskEdit(Sender),Key);
  end;
  If Tipo='A' then
  begin
     If not CharInSet(key ,['A'..'Z','0'..'9',#8, ' ', ',', '.', '^', '~', '´', '`', '/', '?', '°', ';', ':', '<', '>',
                      '[', ']', '\', '|', '{', '}', '+', '=', '-', '_', '(', ')', '*', '&', '"', '%', '$', '#', '@', '!']) then
       key:=#0 ;
  end;
end;
{$ENDIF}

procedure ValidaAceitaApenasUmaVirgula(edit: TCustomEdit; var Key: Char);
var
  vTextSelecionado: string;
begin
  vTextSelecionado := Copy(edit.Text, edit.SelStart + 1, edit.SelLength);
  If (key = ',') and not (AnsiContainsText(vTextSelecionado, ',')) then //Se tiver com virgula selecionada vai substituir, logo, pode usar virgula
    If AnsiContainsStr(edit.Text,',') then
      key := #0;
end;


function SysWinDir: string;
begin
  SetLength(Result, MAX_PATH);
  Windows.GetWindowsDirectory(PChar(Result), MAX_PATH);
  Result := string(PChar(Result));
end;



function SmallMsgBox(const Text, Caption: PChar; Flags: Longint): Integer;
begin
  Application.ProcessMessages;
  Result := Application.MessageBox(Pchar(Text), Caption, Flags);
end;


function Day(Data:TdateTime): Integer;
var
   DataD:TDateTime;
begin
   DataD:=Date;
   if Data <> DataD then DataD:=Data;
   result:=StrToInt(Copy(DateToStr(DataD),1,2));
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
  XMLDOM := CoDOMDocument.Create;
  XMLDOM.loadXML(sXML);

  Result := '';
  xNodes := XMLDOM.selectNodes(sNode);
  for iNode := 0 to xNodes.length -1 do
  begin
    Result := utf8Fix(xNodes.item[iNode].text);
  end;

  XMLDOM := nil;
  xNodes := nil;
end;

function xmlNodeValueToDate(sXML: String; sNode: String): TDate;
var
  sData: String;
begin
  Result := 0;
  sData := xmlNodeValue(sXML, sNode);
  if sData <> '' then
  begin
    Result := StrToDate(Copy(sData, 9, 2) + '/' + Copy(sData, 6, 2) + '/' + Copy(sData, 1, 4));
  end;
end;

function xmlNodeValueToFloat(sXML: String; sNode: String): Double;
var
  sValor: String;
begin
  Result := 0;
  sValor := xmlNodeValue(sXML, sNode);
  if sValor <> '' then
  begin
    sValor := StringReplace(sValor, '.', ',',[rfReplaceAll]);
    Result := StrToFloat(sValor);
  end;
end;


//Mauricio Parizotto 2023-08-08
function SysComputerName: String;
var
  I: DWord;
begin
  I := MAX_COMPUTERNAME_LENGTH + 1;
  SetLength(Result, I);
  Windows.GetComputerName(PChar(Result), I);
  Result := String(PChar(Result));
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

{ Dailon Parisotto (f-7189) 2023-08-11 inicio}
function WinVersion: string;
var
  VersionInfo: TOSVersionInfo;
begin
  VersionInfo.dwOSVersionInfoSize:=SizeOf(VersionInfo);
  GetVersionEx(VersionInfo);
  Result := StrZero(VersionInfo.dwMajorVersion,3,0)+StrZero(VersionInfo.dwMinorVersion,3,0)
end;
{ Dailon Parisotto (f-7189) 2023-08-11 fim}

{ Dailon Parisotto (f-7433) 2023-10-02 inicio}
Function LimpaLetras(pP1:String):String;
var
   I:Integer;
begin
   Result := EmptyStr;
   for I := 1 to length(pP1) do
   begin
     if Pos(AnsiUpperCase(Copy(pP1,I,1)),'ABCDEFGHIJKLMNOPQRSTUVXZÇÀÈÌÒÙÁÉÍÓÚÂÊÎÔÛÄÏÖÜÃÕ') > 0 then
        Result:=Result+Copy(pP1,I,1);
   end;
end;
{ Dailon Parisotto (f-7433) 2023-10-02 fim}

{ Dailon Parisotto (f-7267) 2023-10-18 inicio}
{$IFNDEF VER150}
function IsNumericString(S:String):Boolean;
  var i : integer;
      SeenSign : Boolean;
      SeenPoint: Boolean;
begin
  Result := true;
  SeenSign := false;
  SeenPoint := false;
  for i := 1 to length(s) do begin
{    if not (S[i] in ['+', '-', '0'..'9', ' ', '_', ThousandSeparator,DecimalSeparator]) then begin}
    if not (S[i] in ['+', '-', '0'..'9', ' ', FormatSettings.ThousandSeparator,FormatSettings.DecimalSeparator]) then begin
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
    if s[i] = FormatSettings.DecimalSeparator then begin
      if SeenPoint then begin
        Result := false;
        break;
      end else begin
        SeenPoint := true;
      end;
    end;
  end;
end;
{$ENDIF}

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
{ Dailon Parisotto (f-7267) 2023-10-18 fim}

{ Dailon Parisotto (f-7492) 2023-10-24 Inicio}
function DiasParaExpirar(IBDATABASE: TIBDatabase; bValidacaoNova: Boolean = True): Integer;
var
  qyAux: TIBQuery;
  trAux: TIBTransaction;
  Blowfish: TLbBlowfish;
  sDataLimite: String; // Sandro Silva 2022-11-14
begin

  try
    trAux := CriaIBTransaction(IBDATABASE);
    qyAux := CriaIBQuery(trAux);

    Blowfish := TLbBlowfish.Create(Application);

    qyAux.Close;
    qyAux.SQL.Clear;
    qyAux.SQL.Add('select LICENCA from EMITENTE');
    qyAux.Open;

    Blowfish.GenerateKey(CHAVE_CIFRAR); // Minha chave secreta // Sandro Silva 2022-11-24 Blowfish.GenerateKey(CHAVE_SMALL); // Minha chave secreta

    {Sandro Silva 2022-11-14 inicio
    Result := Trunc(365 - (Date - StrToDate(Copy(Blowfish.DecryptString(qyAux.FieldByname('LICENCA').AsString),7,2)+'/'+Copy(Blowfish.DecryptString(qyAux.FieldByname('LICENCA').AsString),5,2)+'/'+Copy(Blowfish.DecryptString(qyAux.FieldByname('LICENCA').AsString),1,4))));
    }
    sDataLimite := Copy(Blowfish.DecryptString(qyAux.FieldByname('LICENCA').AsString),7,2)+'/'+Copy(Blowfish.DecryptString(qyAux.FieldByname('LICENCA').AsString),5,2)+'/'+Copy(Blowfish.DecryptString(qyAux.FieldByname('LICENCA').AsString),1,4);
    if bValidacaoNova = False then
    begin
      // Calcula o número de dias restantes para usar o sistema
      // 365 - (Data do PC - Data do registro)
      Result := Trunc(365 - (Date - StrToDate(sDataLimite)));

    end
    else
    begin
      // Calcula o número de dias restantes para usar o sistema
      // Data limite - data atual do PC
      Result := Trunc((StrToDate(sDataLimite) - Date));

    end;
    {Sandro Silva 2022-11-14 fim}

  except
    on E: Exception do
    begin
      if AnsiContainsText(E.Message, 'Column unknown') and AnsiContainsText(E.Message, 'LICENCA') then
      begin
        Application.MessageBox(PChar('Seu banco de dados está desatualizado' + Chr(10) + Chr(10) +
          'Entre antes no programa "Small" para ajustar os arquivos.'), 'Atenção', MB_OK + MB_ICONWARNING);
        FecharAplicacao(ExtractFileName(Application.ExeName));
        //Abort;
      end;
      Result := 0;
    end;
  end;

  FreeAndNil(trAux);
  FreeAndNil(qyAux);
  FreeAndNil(Blowfish);
end;

function BuscaSerialSmall: String;
// Retorna o serial instalado
var
  INI : TInifile;
  sP1 : String;
  slSeriais: TStringList;
  iVersao: Integer;
  slSecaoSerial: TStrings;
begin
  sP1 := '';
  try
    try
      //
      if FileExists(SysWinDir+'\wind0ws.l0g') then
      begin
        Ini := TIniFile.create(SysWinDir+'\wind0ws.l0g');
        slSeriais := TStringList.Create;

        slSecaoSerial := TStringList.Create;

        Ini.ReadSections(slSecaoSerial);

        slSeriais.Clear;

        for iVersao := 0 to slSecaoSerial.Count - 1 do
        begin
          slSeriais.Add(INI.ReadString(slSecaoSerial.Strings[iVersao], 'Ser', ''));
        end;

        slSeriais.Sorted := True;
        if slSeriais.Count > 0 then
          Result := slSeriais.Strings[slSeriais.Count - 1];//slSeriais.Strings[slSeriais.Count - 1];
        FreeAndNil(slSeriais);

        FreeAndNil(slSecaoSerial);
        Ini.Free;
      end;
    except
    end;
  finally
  end;
end;
{ Dailon Parisotto (f-7492) 2023-10-24 Fim}

end.
