unit uWebServiceItau;

interface


uses
  Windows, SysUtils, Classes, StdCtrls, JSON,
  ExtCtrls, ComObj, Activex, OleCtrls, IBQuery, Forms, DateUtils,
  Rest.Json, Graphics, TLHelp32, StrUtils, Soap.EncdDecd,  REST.Client,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  REST.Types;

var
  ITAU_access_token, ITAU_refresh_token : string;

  function RequisicaoItau(EndPoint:string; vBody : string; out Resposta : string; out StatusCode : integer; Authorization : Boolean = True) : Boolean;

implementation

function RequisicaoItau(EndPoint:string; vBody : string; out Resposta : string; out StatusCode : integer; Authorization : Boolean = True) : Boolean;
var
  FRESTClient: TRESTClient;
  FRESTRequest: TRESTRequest;
  FRESTResponse: TRESTResponse;
begin
  Result := False;

  try
    {$Region'////Inicializa////'}
    FRESTClient   := TRESTClient.Create(nil);
    FRESTRequest  := TRESTRequest.Create(nil);
    FRESTResponse := TRESTResponse.Create(nil);
    FRESTRequest.Client   := FRESTClient;
    FRESTRequest.Response := FRESTResponse;
    FRESTRequest.Timeout  := 30000;

    //URL de Conexão
    FRESTClient.BaseURL     :=  EndPoint;
    FRESTClient.ContentType := 'application/json';
    //Método
    FRESTRequest.Method := rmPOST;
    {$Endregion}

    //Body
    with FRESTRequest.Params.AddItem do
    begin
      ContentTypeStr := 'application/json';
      Options := [];
      Kind    := pkREQUESTBODY;
      Name    := 'body';
      Value   := vBody;
    end;

    //Authorization
    if Authorization then
    begin
      FRESTRequest.Params.AddHeader('Authorization', 'Bearer ' + ITAU_access_token);
      FRESTRequest.Params.ParameterByName('Authorization').Options := [poDoNotEncode];
    end;

    FRESTRequest.Execute;
    if FRESTResponse.StatusCode <> 200 then
    begin
      Resposta := FRESTRequest.Response.JSONValue.ToString;
    end else
    begin
      Resposta := FRESTRequest.Response.JSONValue.ToString;
      Result := True;
    end;

    StatusCode := FRESTResponse.StatusCode;
  finally
    FreeAndNil(FRESTRequest);
    FreeAndNil(FRESTResponse);
    FreeAndNil(FRESTClient);
  end;
end;

end.
