unit uWebServiceIMendes;

interface


uses
  Windows, SysUtils, Classes, StdCtrls, JSON, uClassesSicoob, IdMultipartFormData,
  ExtCtrls, ComObj, Activex, OleCtrls, IBQuery, Forms, DateUtils,
  Rest.Json, Graphics, TLHelp32, StrUtils, Soap.EncdDecd,  REST.Client,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  REST.Types;

const
  _HostIMendes     = 'http://consultatributos.com.br:8080/api/v1/public/';

  function EnviaRequisicaoIMendes(vMethod : TRESTRequestMethod; Endpoint:string; sBody : string; out sResposta : string) : Boolean;

implementation

uses uconstantes_chaves_privadas;

function EnviaRequisicaoIMendes(vMethod : TRESTRequestMethod; Endpoint:string; sBody : string; out sResposta : string) : Boolean;
var
  FRESTClient: TRESTClient;
  FRESTRequest: TRESTRequest;
  FRESTResponse: TRESTResponse;

  sHostAPI: String;
  Mensagem : string;
begin
  {$Region'////Inicializa////'}
  Result := False;
  FRESTClient := TRESTClient.Create(nil);
  FRESTRequest  := TRESTRequest.Create(nil);
  FRESTResponse := TRESTResponse.Create(nil);
  FRESTRequest.Client   := FRESTClient;
  FRESTRequest.Response := FRESTResponse;
  FRESTRequest.Timeout  := 300000;
  sHostAPI := _HostIMendes;

  FRESTClient.BaseURL :=  sHostAPI+Endpoint;
  FRESTClient.ContentType := 'application/json';

  //Método
  FRESTRequest.Method := vMethod;
  {$Endregion}

  {$Region'////Corpo////'}
  if (vMethod <> rmGET) and (sBody <> '') then
  begin
    with FRESTRequest.Params.AddItem do
    begin
      Kind  := pkREQUESTBODY;
      Name  := 'body';
      Value := sBody;
      ContentType := 'application/json';
    end;
  end;
  {$Endregion}

  {$Region'////Autorização////'}
  with FRESTRequest.Params.AddItem do
  begin
    Options := [poDoNotEncode];
    Kind  := pkHTTPHEADER;
    Name  := 'login';
    Value := IMENDES_login;
  end;


  with FRESTRequest.Params.AddItem do
  begin
    Options := [poDoNotEncode];
    Kind  := pkHTTPHEADER;
    Name  := 'senha';
    Value := IMENDES_senha;
  end;

  {$Endregion}

  try
    FRESTRequest.Execute;
  except
  end;

  {$Region'////Retorno////'}
  if (FRESTResponse.StatusCode <> 200) and (FRESTResponse.StatusCode <> 201) then
  begin
    sResposta := FRESTRequest.Response.JSONValue.ToString;
    Result    := False;
  end else
  begin
    sResposta := FRESTRequest.Response.JSONValue.ToString;
    Result    := True;
  end;
  {$Endregion}

  {$Region'////Finaliza////'}
  FreeAndNil(FRESTRequest);
  FreeAndNil(FRESTResponse);
  FreeAndNil(FRESTClient);
  {$Endregion}
end;


end.
