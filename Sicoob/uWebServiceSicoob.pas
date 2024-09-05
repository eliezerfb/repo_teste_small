unit uWebServiceSicoob;

interface


uses
  Windows, SysUtils, Classes, StdCtrls, JSON, uClassesSicoob, IdMultipartFormData,
  ExtCtrls, ComObj, Activex, OleCtrls, IBQuery, Forms, DateUtils,
  Rest.Json, Graphics, TLHelp32, StrUtils, Soap.EncdDecd,  REST.Client,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  REST.Types;

var
  ITAU_access_token, ITAU_refresh_token : string;
  ITAU_ClientId, ITAU_AccessKey, ITAU_SecretKey : string;

  function RequisicaoSicoob(vMethod : TRESTRequestMethod; EndPoint:string; sBody, sToken, sCertFile : string; Campos : TCamposApi; out Resposta : string; out StatusCode : integer) : Boolean;

implementation

uses uClassesItau, uIntegracaoItau;

function RequisicaoSicoob(vMethod : TRESTRequestMethod; EndPoint:string; sBody, sToken, sCertFile : string; Campos : TCamposApi; out Resposta : string; out StatusCode : integer) : Boolean;
var
  FRESTClient: TRESTClient;
  FRESTRequest: TRESTRequest;
  FRESTResponse: TRESTResponse;
  i : integer;
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
    FRESTClient.ContentType := 'multipart/form-data';
    //Método
    FRESTRequest.Method := vMethod;
    {$Endregion}

    //Body
    if sBody <> '' then
    begin
      with FRESTRequest.Params.AddItem do
      begin
        ContentTypeStr := 'application/json';
        Options := [];
        Kind    := pkREQUESTBODY;
        Name    := 'body';
        Value   := sBody;
      end;
    end;

    //Campos form-data
    if Campos <> nil then
    begin
      for I := Low(Campos.CamposApi) to High(Campos.CamposApi) do
      begin
        with FRESTRequest.Params.AddItem do
        begin
          ContentTypeStr := 'multipart/form-data';
          Options := [];
          Kind    := pkGETorPOST;
          Name    := Campos.CamposApi[i].Descricao;
          Value   := Campos.CamposApi[i].Valor;
        end;
      end;
    end;

    if sToken <> '' then
      FRESTRequest.Params.AddItem('token',sToken,pkGETorPOST,[],'multipart/form-data');

    if sCertFile <> '' then
      FRESTRequest.AddFile('apiPixCertificate',sCertFile,'multipart/form-data');

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
