unit uWebServiceMinhasNotas;

interface

uses
  Windows, SysUtils, Classes, StdCtrls, JSON, IdMultipartFormData,
  ExtCtrls, ComObj, Activex, OleCtrls, IBQuery, Forms, DateUtils,
  Rest.Json, Graphics, TLHelp32, StrUtils, Soap.EncdDecd,  REST.Client,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  REST.Types, Vcl.Dialogs;

  function RequisicaoMinhasNotas(vMethod : TRESTRequestMethod; EndPoint:string; sToken, sFile : string;
                                 out Resposta : string; out StatusCode : integer) : Boolean;

implementation

uses uLogSistema;

function RequisicaoMinhasNotas(vMethod : TRESTRequestMethod; EndPoint:string; sToken, sFile : string;
                               out Resposta : string; out StatusCode : integer) : Boolean;
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

    //Token
    if sToken <> '' then
    begin
      FRESTRequest.Params.AddHeader('Authorization', sToken);
      FRESTRequest.Params.ParameterByName('Authorization').Options := [poDoNotEncode];
    end;

    FRESTRequest.Params.AddItem('client','small',pkGETorPOST,[],'multipart/form-data');

    if sFile <> '' then
      FRESTRequest.AddFile('file',sFile,'multipart/form-data');

    try
      FRESTRequest.Execute;
    except
      on e:exception do
        LogSistema('Erro ao enviar Minhas Notas '+e.Message,lgErro);
    end;

    if FRESTResponse.StatusCode = 201 then
    begin
      Resposta := FRESTRequest.Response.Content;
      Result   := True;
    end else
    begin
      Resposta := FRESTRequest.Response.Content;
    end;

    StatusCode := FRESTResponse.StatusCode;
  finally
    FreeAndNil(FRESTRequest);
    FreeAndNil(FRESTResponse);
    FreeAndNil(FRESTClient);
  end;
end;


end.
