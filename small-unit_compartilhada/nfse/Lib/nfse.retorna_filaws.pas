unit nfse.retorna_filaws;

interface

uses
  IdHTTP,
  IdSSLOpenSSL,
  System.Classes,
  System.JSON,
  REST.Client,
  rest.Types,
  nfse.classe.retorno,
  System.SysUtils;

Type
  TRetornoFila = Class
  private
    Fjson   : string;
    Ftokenid : string;
    Fendpoint: string;
    FsocketId: string;
    procedure SetsocketId(const Value: string);
  public
    property json    : string read Fjson    write Fjson ;
    property tokenid  : string read Ftokenid  write Ftokenid;
    property endpoint  : string read Fendpoint  write fendpoint;
    property socketId : string read FsocketId write SetsocketId;

  function Enviaretorno(classRetorno : TNFSeRetorno; Retorno : string = ''):  string;

end;

implementation

{ RetornoFila }


function TRetornoFila.Enviaretorno(classRetorno : TNFSeRetorno; Retorno : string = ''): string;
var
  idHttpApi : TIdHTTP;
  IdSSLIOHandlerSocketOpenSSLConexao: TIdSSLIOHandlerSocketOpenSSL;
  JsonToSend  : TStringStream;
  jsonSignup  : TJSONObject;
begin
  JsonToSend := TStringStream.Create(json);
  if Trim(Retorno) <> '' then
    JsonToSend := TStringStream.Create( UTF8Encode(Result))
  else
    JsonToSend := TStringStream.Create( UTF8Encode(classRetorno.AsJson));

  idHttpApi := TIdHTTP.Create(nil);
  IdSSLIOHandlerSocketOpenSSLConexao := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  idHttpApi.IOHandler := IdSSLIOHandlerSocketOpenSSLConexao;

  idHttpApi.Request.CustomHeaders.AddValue('Accept-Language', 'pt_BR');
  if Trim(socketId) <> '' then
    idHttpApi.Request.CustomHeaders.AddValue('Socket-Id', socketId);
  if Trim(tokenid) <> '' then
    idHttpApi.Request.CustomHeaders.AddValue('Authorization-Compufacil', tokenid);

  idHttpApi.Request.Accept := 'application/json;charset=UTF-8';
  idHttpApi.Request.ContentType := 'application/json';
  idHttpApi.HandleRedirects := True;
  idHttpApi.ReadTimeout := 30000;

  try
    Result := idHttpApi.Post(endpoint, JsonToSend);
  except
    on e: EidHttpProtocolException do
    begin
      Result := e.ErrorMessage;
    end;
  end;

end;

procedure TRetornoFila.SetsocketId(const Value: string);
begin
  FsocketId := Value;
end;

end.
