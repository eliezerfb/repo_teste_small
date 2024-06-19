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
  ITAU_ClientId, ITAU_AccessKey, ITAU_SecretKey : string;

  function RequisicaoItau(vMethod : TRESTRequestMethod; EndPoint:string; vBody : string; out Resposta : string; out StatusCode : integer; Authorization : Boolean = True) : Boolean;

implementation

uses uClassesItau, uIntegracaoItau;

function RequisicaoItau(vMethod : TRESTRequestMethod; EndPoint:string; vBody : string; out Resposta : string; out StatusCode : integer; Authorization : Boolean = True) : Boolean;
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
    FRESTRequest.Method := vMethod;
    {$Endregion}

    //Body
    if vBody <> '' then
    begin
      with FRESTRequest.Params.AddItem do
      begin
        ContentTypeStr := 'application/json';
        Options := [];
        Kind    := pkREQUESTBODY;
        Name    := 'body';
        Value   := vBody;
      end;
    end;

    //Authorization
    if Authorization then
    begin
      FRESTRequest.Params.AddHeader('Authorization', 'Bearer ' + ITAU_access_token);
      FRESTRequest.Params.ParameterByName('Authorization').Options := [poDoNotEncode];
    end;

    try
      FRESTRequest.Execute;
    except
    end;

    if FRESTResponse.StatusCode = 200 then
    begin
      Resposta     := FRESTRequest.Response.JSONValue.ToString;
      Result       := True;
    end else
    begin
      try
        Resposta := FRESTRequest.Response.JSONValue.ToString;

        if (FRESTResponse.StatusCode = 401) and not(Authorization) then
        begin
          if RefreshTokenItau then
            Result := RequisicaoItau(vMethod, EndPoint, vBody, Resposta, StatusCode, Authorization);
        end;
      except
      end;
    end;

    StatusCode := FRESTResponse.StatusCode;
  finally
    FreeAndNil(FRESTRequest);
    FreeAndNil(FRESTResponse);
    FreeAndNil(FRESTClient);
  end;
end;


end.
