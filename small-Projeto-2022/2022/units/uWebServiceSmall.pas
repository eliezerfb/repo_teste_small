unit uWebServiceSmall;

interface

uses
  System.Generics.Collections,  SysUtils, Classes, JSON,
  Rest.Json, StrUtils, REST.Client, REST.Types;


  function RequisicaoSmall(vMethod : TRESTRequestMethod; EndPoint:string; sBody : string; out Resposta : string; out StatusCode : integer) : Boolean;

implementation

uses uClassesItau, uIntegracaoItau;

function RequisicaoSmall(vMethod : TRESTRequestMethod; EndPoint:string; sBody : string; out Resposta : string; out StatusCode : integer) : Boolean;
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
    //FRESTClient.ContentType := 'multipart/form-data';
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
