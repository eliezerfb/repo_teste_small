unit uInteligenciaArtificial;

interface

uses
  uIInteligenciaArtificial, Groq, Groq.Consts, System.SysUtils, uILogIA;

type
  TInteligenciaArtificial = class(TInterfacedObject, IInteligenciaArtificial)
  private
    FoGroq: TGroq;
    FoLogIA: ILogIA;
    FcResposta: String;
    procedure GroqError(AStatusMessage, AMessage: string);
    procedure GroqComplete(AMessage: string);
    procedure GeraLog(AenTipoUsuario: TTipoUsuario; AcTexto: String);
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IInteligenciaArtificial;
    function setLogIA(AoLogIA: ILogIA): IInteligenciaArtificial;
    function setAPIKey(AcKey: String): IInteligenciaArtificial;
    function setModeloIA(AenVersaoIA: TModels): IInteligenciaArtificial;
    function setPrompt(AcPrompt: String): IInteligenciaArtificial;
    function setTemperatura(AnTemp: Extended): IInteligenciaArtificial;
    function Perguntar(AcTexto: String): IInteligenciaArtificial;
    function Resposta(var AcResp: String): IInteligenciaArtificial;
  end;

implementation

{ TInteligenciaArtificial }

constructor TInteligenciaArtificial.Create;
begin
  // Cria componenete e seta as propriedades
  FoGroq := TGroq.Create(nil);
  FoGroq.Prompt := EmptyStr;
  FoGroq.Temperatura := 0.3;
  FoGroq.Modelo := Groq.Consts.llama3_8b_8192;
  // Define os eventos do componente
  FoGroq.OnError    := GroqError;
  FoGroq.OnComplete := GroqComplete;
end;

destructor TInteligenciaArtificial.Destroy;
begin
  FreeAndNil(FoGroq);
  inherited;
end;

class function TInteligenciaArtificial.New: IInteligenciaArtificial;
begin
  Result := Self.Create;
end;

function TInteligenciaArtificial.Perguntar(AcTexto: String): IInteligenciaArtificial;
begin
  Result := Self;

  GeraLog(tuIA, AcTexto);

  if (FoGroq.APIKey = EmptyStr) then
  begin
    FcResposta := 'Chave API da IA não configurada.';
    Exit;
  end;
  if (FoGroq.Prompt = EmptyStr) then
  begin
    FcResposta := 'Base de conhecimento da IA não configurada.';
    Exit;
  end;

  FoGroq.Enviar(AcTexto, Ord(FoGroq.Modelo), FoGroq.Temperatura);
  Sleep(100);

  if not FoGroq.Erro then
    FcResposta := FoGroq.Resposta;
end;

function TInteligenciaArtificial.Resposta(var AcResp: String): IInteligenciaArtificial;
begin
  Result := Self;

  AcResp := FcResposta;

  GeraLog(tuIA, AcResp);
end;

function TInteligenciaArtificial.setAPIKey(AcKey: String): IInteligenciaArtificial;
begin
  Result := Self;

  FoGroq.APIKey := AcKey;
end;

function TInteligenciaArtificial.setLogIA(AoLogIA: ILogIA): IInteligenciaArtificial;
begin
  Result := Self;

  FoLogIA := AoLogIA;
end;

function TInteligenciaArtificial.setPrompt(AcPrompt: String): IInteligenciaArtificial;
begin
  Result := Self;

  FoGroq.Prompt := AcPrompt;

  GeraLog(tuUsuario, 'Prompt definido: ' + sLineBreak + AcPrompt);
end;

function TInteligenciaArtificial.setTemperatura(AnTemp: Extended): IInteligenciaArtificial;
begin
  Result := Self;
  // Quanto maior o valor mais a IA irá chutar a resposta
  // Quanto mais baixo menos a IA irá chutar a resposta
  // Padrão utilizado 0.3
  FoGroq.Temperatura := AnTemp;
end;

function TInteligenciaArtificial.setModeloIA(AenVersaoIA: TModels): IInteligenciaArtificial;
begin
  Result := Self;

  FoGroq.Modelo := AenVersaoIA;
end;

procedure TInteligenciaArtificial.GroqError(AStatusMessage, AMessage: string);
begin
  GeraLog(tuUsuario, 'FALHA: ' + AStatusMessage + ' - ' + AMessage);

  FcResposta := AMessage;
end;

procedure TInteligenciaArtificial.GroqComplete(AMessage: string);
begin
  GeraLog(tuUsuario, 'Tokens utilizados: ' + FoGroq.TotalTokens.ToString);
end;

procedure TInteligenciaArtificial.GeraLog(AenTipoUsuario: TTipoUsuario; AcTexto: String);
begin
  // Se DEV não definiou qual LOG gerar então não gera nenhum log
  if Assigned(FoLogIA) then
    FoLogIA.Salvar(AenTipoUsuario, AcTexto);
end;

end.
