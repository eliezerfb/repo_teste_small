unit uConsultaCEP;

interface

uses
  uIConsultaCEP, uObjetoConsultaCEP, SysUtils, REST.Client, Vcl.Forms,
  Vcl.Controls;

type
  TConsultaCEP = class(TInterfacedObject, IConsultaCEP)
  private
    FcCEP: String;
    FnTimeOut: Integer;
    FoObjCEP: TObjetoConsultaCEP;
    constructor Create;
  public
    destructor Destroy; override;
    class function New: IConsultaCEP;
    function setTimeOut(AnMileseg: Integer = 10000): IConsultaCEP;
    function setCEP(AcCEP: String): IConsultaCEP;
    function SolicitarDados: IConsultaCEP;
    function getObjeto: TObjetoConsultaCEP;
  end;

implementation

uses
  SmallFunc_xe;

{ TConsultaCEP }

class function TConsultaCEP.New: IConsultaCEP;
begin
  Result := Self.Create;
end;

constructor TConsultaCEP.Create;
begin
  // Por padrão 10 segundos
  FnTimeOut := 10000;

  FoObjCEP := nil;
end;

destructor TConsultaCEP.Destroy;
begin
  FreeAndNil(FoObjCEP);

  inherited;
end;

function TConsultaCEP.getObjeto: TObjetoConsultaCEP;
begin
  Result := FoObjCEP;
end;

function TConsultaCEP.setCEP(AcCEP: String): IConsultaCEP;
begin
  Result := Self;

  FcCEP := LimpaNumero(AcCEP);
end;

function TConsultaCEP.setTimeOut(AnMileseg: Integer): IConsultaCEP;
begin
  Result := Self;

  FnTimeOut := AnMileseg;
end;

function TConsultaCEP.SolicitarDados: IConsultaCEP;
const
  _cURL = 'viacep.com.br/ws/%s/json/';
  _cMgsCEPInvalido = 'CEP informado %s é inválido ou não existe.';
var
  oRESTClient: TRESTClient;
  oRESTRequest: TRESTRequest;
  oRESTResponse: TRESTResponse;
  cRetornoErro: String;
begin
  Result := Self;

  try
    if (Trim(FcCEP) = EmptyStr) then
      Exit;

    if (Length(FcCEP) <> 8) then
      raise Exception.Create(Format(_cMgsCEPInvalido, [FcCEP]));


    oRESTClient := TRESTClient.Create(nil);
    oRESTRequest := TRESTRequest.Create(nil);
    oRESTResponse := TRESTResponse.Create(nil);
    try
      Screen.Cursor         := crHourGlass;

      oRESTRequest.Client   := oRESTClient;
      oRESTRequest.Response := oRESTResponse;
      oRESTRequest.Timeout  := FnTimeOut;
      //URL de Conexão
      oRESTClient.BaseURL     :=  Format(_cURL, [FcCEP]);
      oRESTClient.ContentType := 'application/json';

      oRESTRequest.Execute;

      if oRESTResponse.StatusCode = 200 then
      begin
        if Pos('"ERRO":', AnsiUpperCase(oRESTRequest.Response.JSONValue.ToString)) > 0 then
          raise Exception.Create(Format(_cMgsCEPInvalido, [FcCEP]))
        else
          FoObjCEP := (TObjetoConsultaCEP.JsonToObject(oRESTRequest.Response.JSONValue.ToString) as TObjetoConsultaCEP);
      end
      else
      begin
        cRetornoErro := oRESTRequest.Response.Content;

        if Pos('<body>', cRetornoErro) > 0 then
        begin
          cRetornoErro := Trim(Copy(cRetornoErro, Pos('<body>', cRetornoErro)+6, Length(cRetornoErro)));
          cRetornoErro := Trim(Copy(cRetornoErro, 1, Pos('</body>', cRetornoErro)-1));

          cRetornoErro := StringReplace(cRetornoErro, '<h1>', EmptyStr, [rfReplaceAll]);
          cRetornoErro := StringReplace(cRetornoErro, '<h2>', EmptyStr, [rfReplaceAll]);
          cRetornoErro := StringReplace(cRetornoErro, '<h3>', EmptyStr, [rfReplaceAll]);
          cRetornoErro := StringReplace(cRetornoErro, '</h1>', EmptyStr, [rfReplaceAll]);
          cRetornoErro := StringReplace(cRetornoErro, '</h2>', EmptyStr, [rfReplaceAll]);
          cRetornoErro := StringReplace(cRetornoErro, '</h3>', EmptyStr, [rfReplaceAll]);

          while Pos('  ', cRetornoErro) > 0 do
            cRetornoErro := StringReplace(cRetornoErro, '  ', ' ', [rfReplaceAll]);
        end;

        raise Exception.Create(cRetornoErro);
      end;
    finally
      Screen.Cursor := crDefault;

      FreeAndNil(oRESTResponse);
      FreeAndNil(oRESTRequest);
      FreeAndNil(oRESTClient);
    end;
  except
    on e:exception do
    begin
      raise Exception.Create('Não foi possível consultar o CEP: '+FcCEP+'.' + sLineBreak +
                             'Retorno: '+ sLineBreak +
                             e.Message + sLineBreak + sLineBreak +
                             'Verifique o CEP informado ou tente novamente mais tarde.');
    end;
  end;
end;

end.
