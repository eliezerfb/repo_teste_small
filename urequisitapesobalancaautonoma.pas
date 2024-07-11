unit urequisitapesobalancaautonoma;

interface

type
  TRequisitaPesoAutonomo = class
  private
    FSinalRecebido: Boolean;
    FResposta: String;
    FRequisicao: String;
    FID: String;
    FPastaResposta: String;
    FPastaRequisicao: String;
    function BalancaLivre: Boolean;
  public
    constructor Create;
    procedure EscreverArquivoRequisicao(iEtapaPesagem: Integer);
    function AguardarResposta: string;
    function RecebeuResposta: Boolean;
    property Requisicao: String read FRequisicao write FRequisicao;
    property Resposta: String read FResposta write FResposta;
    property PastaResposta: String read FPastaResposta write FPastaResposta;
    property PastaRequisicao: String read FPastaRequisicao write FPastaRequisicao;
  end;

implementation

uses
  SysUtils, Classes, Controls, DateUtils,
  StrUtils;

constructor TRequisitaPesoAutonomo.Create;
begin
  FSinalRecebido := False;
end;

procedure TRequisitaPesoAutonomo.EscreverArquivoRequisicao(iEtapaPesagem: Integer);
var
  Arquivo: TextFile;
begin
  DeleteFile(FPastaRequisicao + 'pesar.xml');
  AssignFile(Arquivo, FPastaRequisicao + 'pesar.tmp');
  FRequisicao := TimeToStr(Time);
  FID := TimeToStr(Time);
  try
    Rewrite(Arquivo);
    WriteLn(Arquivo, '<commerce><etapa>' + IntToStr(iEtapaPesagem) + '</etapa></commerce>');
  finally
    CloseFile(Arquivo);
  end;
  RenameFile(FPastaRequisicao + 'pesar.tmp', pastaRequisicao + 'pesar.xml');
end;

function TRequisitaPesoAutonomo.AguardarResposta: string;
var
  ArquivoResposta: TextFile;
  nomeArquivo: string;
  hrEnvio: TDate;
  SegundosDecorridos: Integer;
  sLinha: String;
begin
  FResposta := '';
  Result := '';
  nomeArquivo := 'peso.xml'; // Nome do arquivo de resposta esperado
  hrEnvio := Now;
  repeat
    Sleep(50); // Aguarda 1 segundo (simulação)
    if FileExists(FPastaResposta + nomeArquivo) then
    begin
      AssignFile(ArquivoResposta, FPastaResposta + nomeArquivo);
      try
        Reset(ArquivoResposta);
        sLinha := '';
        while (not eof(ArquivoResposta)) do
        begin
          ReadLn(ArquivoResposta, sLinha);
          FResposta := FResposta + #13 + slinha;
        end
      finally
        CloseFile(ArquivoResposta);
        DeleteFile(FPastaResposta + nomeArquivo);
      end;

      FSinalRecebido := True; // Sinaliza que recebeu a resposta
      //FResposta := Result;
      Result := FResposta;
      Exit;
    end;
    SegundosDecorridos := SecondsBetween(hrEnvio, Now);
    if SegundosDecorridos >= 20 then
      Exit;
  until False;
end;

function TRequisitaPesoAutonomo.RecebeuResposta: Boolean;
begin
  Result := FSinalRecebido;
end;

function TRequisitaPesoAutonomo.BalancaLivre: Boolean;
begin
  Result := not (FileExists(FPastaResposta + 'pesando.tmp'));
end;

end.

