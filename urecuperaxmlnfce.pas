{ *************************************************************************** }
{                                                                             }
{ Classe responsável por recuperar XML de NFC-e                               }
{                                                                             }
{ Pesquisa arquivos com extensão XML, no caminho definido, que contenham      }
{ informações de NFC-e emitidas                                               }
{ Retorna o conteúdo do arquivo correspondente encontrado, o status, o ID     }
{ da NFC-e                                                                    }
{                                                                             }
{ *************************************************************************** }

unit urecuperaxmlnfce;

interface

uses
  Classes, Forms, ShellApi, Windows, StrUtils, Dialogs
  , SmallFunc
  , ufuncoesfrente
  ;

type
  TRecuperaNFCe = class
  private
    FNumeroNFCe: String;
    FXmlRecuperado: String;
    FDigestAutorizado: String;
    FIdNFCe: String;
    FcStatNFCe: String;
    FslListaXml: TStringList;
    FCaminho: String;
    //procedure SetNumeroNFCe(const Value: String);
    procedure ListaXmlNFCe(dirAtual: String);
  public
    property cStatNFCe: String read FcStatNFCe;
    property IdNFCe: String read FIdNFCe;
    property XmlRecuperado: String read FXmlRecuperado;
    procedure RecuperaXML(NumeroNFCe: String; Caminho: String);
  end;

implementation

uses SysUtils;

{ TRecuperaNFCe }

procedure TRecuperaNFCe.ListaXmlNFCe(dirAtual: String);
// Lista todos xml referente ao número da NFC-e informado
// Lista por ordem de data invertido do último para o primeiro
var
  sArqTmp: String;
  sArqTxt: String;
  sArquivo: String;
  sData: String;
begin

  sData := FormatDateTime('YYYY-MM-dd-HH-mm-ss-zzz-', Now);
  sArqTmp := sData + FNumeroNFCe + '.tmp';
  sArqTxt := sData + FNumeroNFCe + '.txt';
  sArquivo := FCaminho + '\*65???' + FormatFloat('000000000', StrToInt(FNumeroNFCe)) + '*.xml';
  DeleteFile(PAnsiChar(dirAtual + '\' + sArqTmp));
  DeleteFile(PAnsiChar(dirAtual + '\' + sArqTxt));
  Sleep(250);

  ShellExecute(Application.Handle, 'runas', 'cmd.exe', PAnsiChar('/C dir "' + sArquivo + '" /s/B/O-D > "' + dirAtual + '\' + sArqTmp + '"'), nil, SW_HIDE);

  while RenameFile(PansiChar(dirAtual + '\' + sArqTmp), PAnsiChar(dirAtual + '\' + sArqTxt)) = False do
  begin
    Sleep(250);
    Application.ProcessMessages;
  end;

  FslListaXml.LoadFromFile(dirAtual + '\' + sArqTxt);
  
  DeleteFile(PAnsiChar(dirAtual + '\' + sArqTmp));
  DeleteFile(PAnsiChar(dirAtual + '\' + sArqTxt));

end;

procedure TRecuperaNFCe.RecuperaXML(NumeroNFCe: String; Caminho: String);
var
  slXml: TStringList;
  sAtual: String;
  sXmlSituacao: String;
  iFile: Integer;
begin

  if FslListaXml = nil then
    FslListaXml := TStringList.Create
  else
    FslListaXml.Clear;

  FXmlRecuperado    := '';
  FDigestAutorizado := '';
  FIdNFCe           := '';
  FCaminho          := Caminho;
  FNumeroNFCe       := NumeroNFCe;

  if FCaminho = '' then
  begin
    ShowMessage('Informe o caminho de pesquisa');
    Exit;
  end;

  if FNumeroNFCe = '' then
  begin
    ShowMessage('Informe o número da NFC-e a recuperar');
    Exit;
  end;


  slXml := TStringList.Create;

  sAtual := ExtractFilePath(Application.ExeName);

  ListaXmlNFCe(sAtual);

  FDigestAutorizado := '';

  for iFile := 0 to FslListaXml.Count -1 do // Percorre todos xml localizados
  begin

    slXml.Clear;

    slXml.LoadFromFile(FslListaXml.Strings[iFile]);

    if FDigestAutorizado = '' then // se estiver vazio ainda não processou xml de resposta de autorização
    begin

      if FIdNFCe = '' then
      begin
        // Para recuperar o último ID da NFC-e
        if LimpaNumero(xmlNodeValue(slXml.Text, '//@Id')) <> '' then
          FIdNFCe        := LimpaNumero(xmlNodeValue(slXml.Text, '//@Id'));
        if LimpaNumero(xmlNodeValue(slXml.Text, '//chNFe')) <> '' then
          FIdNFCe        := LimpaNumero(xmlNodeValue(slXml.Text, '//chNFe'));
      end;

      if AnsiContainsText(slXml.Text, '<cStat>135</cStat>') then // Valida se é xml de situação de cancelamento
      begin
        sXmlSituacao   := slXml.Text; // memoriza o xml da situação
        FIdNFCe        := xmlNodeValue(sXmlSituacao, '//chNFe');
        FcStatNFCe     := NFCE_CSTAT_CANCELADA_135;
        FXmlRecuperado := slXml.Text;
        Break;
      end;

      if AnsiContainsText(slXml.Text, '<cStat>100</cStat>') or AnsiContainsText(slXml.Text, '<cStat>150</cStat>') then // valida se é xml de situação de autorizado
      begin
        FDigestAutorizado := xmlNodeValue(slXml.Text, '//digVal'); // memoriza o digest value da autorização
        sXmlSituacao      := slXml.Text; // memoriza o xml da situação
        FIdNFCe           := xmlNodeValue(sXmlSituacao, '//chNFe');
      end;

    end;

    if FDigestAutorizado <> '' then
    begin
      // Processou xml de resposta de autorização
      FIdNFCe := Trim(FIdNFCe);

      if (FIdNFCe <> '') and (FIdNFCe = LimpaNumero(xmlNodeValue(slXml.Text, '//@Id')))  then
      begin
        if FDigestAutorizado = xmlNodeValue(slXml.Text, '//DigestValue') then
        begin
          FcStatNFCe     := NFCE_CSTAT_AUTORIZADO_100;
          FXmlRecuperado := ConcatencaNodeNFeComProtNFe(slxml.Text, sXmlSituacao);
          Break;
        end;
      end;

    end;

  end;

  FcStatNFCe     := Trim(FcStatNFCe);
  FXmlRecuperado := Trim(FXmlRecuperado);

  FreeAndNil(slXml);
  FreeAndNil(FslListaXml);
end;

{
procedure TRecuperaNFCe.SetNumeroNFCe(const Value: String);
begin
  FNumeroNFCe       := Value;
end;
}

end.
