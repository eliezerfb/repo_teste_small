unit nfse.envia_xml;

interface

uses
  IdHTTP,
  IdSSLOpenSSL,
  IdMultipartFormData,
  System.Classes,
  System.SysUtils,
  nfse.constants,
  REST.Client,
  Rest.Types,
  IdLogEvent,
  IdStack,
  nfse.funcoes,
  nfse.jsonerror_resp;



Type
  TNfseHTTP = class(TObject)
  private
    FIdHTTPSH: TIdHTTP;
    FAuthSSL: TIdSSLIOHandlerSocketOpenSSL;
    FIDLogEvent: TIdLogEvent;

    FHomolog: Boolean;
    FLocal: Boolean;
    FStaging: Boolean;
    FUrlLocal: String;

    FResponseCode: Integer;
    FResponseJson: String;
    FEndPointPOST: String;
    FResponseError: String;
    FAuthorizationCompufacil: String;
    FConnectionError: Boolean;
    FSilentMode: Boolean;
    FSilentConnectionErrors: Boolean;
    Fxmlconsultasoap: string;
    Fxmlconsulta: string;
    Fnomexml: string;
    function HTTPPost(AJson,
                      typereq : string;
                      idnfse  : integer;
                      AFiles: TStringList = nil): String;
    procedure IdLogEventSent(ASender: TComponent; const AText, AData: string);
    procedure IdLogEventReceived(ASender: TComponent; const AText,
      AData: string);
    procedure SaveLog(AText, AData: String);
  public
    constructor Create(ALoadToken: Boolean = True;
      AAuthorizationToken: String = ''; socketId : string = '');
    destructor Destroy; override;
    property EndPointPOST: String read FEndPointPOST write FEndPointPOST;
    property Homolog: Boolean read FHomolog;
    property ResponseCode: Integer read FResponseCode;
    property ResponseJson: String read FResponseJson;
    property ResponseError: String read FResponseError;
    property ConnectionError: Boolean read FConnectionError;
    property SilentMode: Boolean read FSilentMode write FSilentMode;
    property SilentConnectionErrors: Boolean read FSilentConnectionErrors write FSilentConnectionErrors;
    property xmlconsulta : string read Fxmlconsulta write Fxmlconsulta;
    property xmlconsultasoap : string read Fxmlconsultasoap write Fxmlconsultasoap;
    property nomexml : string read Fnomexml write  Fnomexml;


    function POST(AJson,
                  typereq : string;
                  idnfse  : integer;
                  AFiles: TStringList = nil): String;
    function GET(AJson: String; AEndPoint: String = ''): String;
    function PUT(AJson: String): String;
    function DELETE(AJson: String): String; overload;
    function Delete(AID: Integer): Boolean; overload;
  end;

implementation

constructor TNfseHTTP.Create(ALoadToken: Boolean;
  AAuthorizationToken, socketId: String);
var
  Debug: Boolean;
begin
  FAuthorizationCompufacil := AAuthorizationToken;

  FIdHTTPSH := TIdHTTP.Create(nil);
  FAuthSSL  := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  FIdHTTPSH.IOHandler := FAuthSSL;

  FIDLogEvent := TIdLogEvent.Create(nil);
  FIDLogEvent.OnSent := IdLogEventSent;
  FIDLogEvent.OnReceived := IdLogEventReceived;
  FIDLogEvent.Active := Debug;
  FIdHTTPSH.IOHandler.Intercept := FIDLogEvent;

  if ALoadToken then
  begin
    FIdHTTPSH.Request.CustomHeaders.AddValue('Authorization-Compufacil', AAuthorizationToken);
    FIdHTTPSH.Request.CustomHeaders.AddValue('Socket-Id', socketId);
  end;

  FIdHTTPSH.Request.CustomHeaders.AddValue('Accept-Language', 'pt_BR');

  FIdHTTPSH.Request.Accept := 'application/json;charset=UTF-8';
  FIdHTTPSH.Request.ContentType := 'application/json';

  FIdHTTPSH.HandleRedirects := True;
  FIdHTTPSH.ReadTimeout := 30000;
end;

function TNfseHTTP.Delete(AID: Integer): Boolean;
var
  Response: String;
begin

end;

function TNfseHTTP.DELETE(AJson: String): String;
begin

end;

destructor TNfseHTTP.Destroy;
begin
  FIdHTTPSH.Free;
  FAuthSSL.Free;

  FreeAndNil(FIdHTTPSH);
  FreeAndNil(FAuthSSL);

  inherited;
end;


function TNfseHTTP.GET(AJson: String; AEndPoint: String): String;
var
  EndPoint: String;
begin

  if not(AEndPoint = '') then
    EndPoint := AEndPoint;

  if EndPoint = '' then
    raise Exception.Create('Endpoint GET not implemented.');

  if AJson = '' then
    AJson := '{}';

end;



function TNfseHTTP.HTTPPost(AJson,
                            typereq : string;
                            idnfse  : integer;
                            AFiles: TStringList): String;
const
  CONSULT_THE_DOCS_ERRROR = 'Consult the docs at <a href="http://developer.compufacil.com.br">here</a>.';
  CONNECTION_REFUSED_ERROR = 'Connection refused';
var
  JsonToSend : TStringStream;
  MultiPart: TIdMultiPartFormDataStream;
  File_: String;
begin
  if not(AFiles = nil) then
  begin
    MultiPart := TIdMultiPartFormDataStream.Create;

    for File_ in AFiles do
      MultiPart.AddFile(file_, File_);
  end;
  MultiPart.AddFormField('nfseId',IntToStr(idnfse));
  MultiPart.AddFormField('action',typereq);

  JsonToSend := TStringStream.Create(UTF8Encode(AJson));
  try
    try
      if AFiles = nil then
        FResponseJson := FIdHTTPSH.Post(getEndPointEnviaXml, JsonToSend)
      else
        FResponseJson := FIdHTTPSH.Post(getEndPointEnviaXml, MultiPart);

      if FResponseJson = CONSULT_THE_DOCS_ERRROR then
        raise Exception.Create(CONSULT_THE_DOCS_ERRROR);
    except
      on E: EIdSocketError do
      begin
        SaveLog(E.Message, '');
        FConnectionError := True;
        FResponseError := E.Message;
        if not(pos(CONNECTION_REFUSED_ERROR, E.Message) = 0) then
          FResponseError := 'Conexão recusada.'+#13+#13+FResponseError;

        if (MsgAllowOffLine(e.Message)) and not(SilentConnectionErrors) then
          raise Exception.Create(e.Message);
      end;
      on E: EIdHTTPProtocolException do
      begin
        FConnectionError := True;
        SaveLog(E.ErrorMessage, FResponseJson);
        FResponseJson := E.ErrorMessage;
        if not(SilentMode) then
        begin
          if FResponseError = '' then
            FResponseError := E.ErrorMessage;

        end;
      end;
      on E: Exception do
      begin
        FConnectionError := True;
      end;
    end;
  finally
    if FResponseJson = CONSULT_THE_DOCS_ERRROR then
      FResponseCode := 0
    else
      FResponseCode := FIdHTTPSH.ResponseCode;
    Result := FResponseJson;
    JsonToSend.Free;
    if not(AFiles = nil) then
      MultiPart.Free;
  end;

end;

procedure TNfseHTTP.IdLogEventReceived(ASender: TComponent; const AText,
  AData: string);
begin

end;

procedure TNfseHTTP.IdLogEventSent(ASender: TComponent; const AText,
  AData: string);
begin

end;

function TNfseHTTP.POST(AJson,
                        typereq : string;
                        idnfse  : integer;
                        AFiles: TStringList = nil): String;
begin
  Result := HTTPPost(AJson, typereq, idnfse, afiles);
end;

function TNfseHTTP.PUT(AJson: String): String;
begin

end;

procedure TNfseHTTP.SaveLog(AText, AData: String);
begin

end;

end.
