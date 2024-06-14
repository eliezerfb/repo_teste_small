unit uIntegracaoItau;

interface

uses
  System.SysUtils, REST.JSON, System.Generics.Collections, REST.Json.Types,
  System.IniFiles, Vcl.Forms;

var
  AmbienteItauProd : boolean;

  const URL_ITAU   = 'https://api-conexaoitau.shipay.com.br';
  const URL_ITAU_H = 'https://api-staging.shipay.com.br';

  procedure CarregaTipoAmbiente;
  function AutenticaoITAU(out Mensagem:string) : boolean;
  function RegistraContaItau(user_full_name,user_email,customer_name,customer_email,store_name,
                             store_cnpj_cpf,store_postal_code,store_street,store_street_number,
                             store_city,store_state,store_neighborhood,store_reference,
                             store_pos_names,user_role_id,user_phone : string;
                             out client_id,access_key,secret_key : string;
                             out Mensagem:string):boolean;




implementation

uses
  uClassesItau
  , uWebServiceItau
  , uconstantes_chaves_privadas
  , uLogSistema;

procedure CarregaTipoAmbiente;
var
  ArqINI: TIniFile;
begin
  try
    ArqINI := TIniFile.Create(ExtractFilePath(Application.ExeName)+'smallcom.inf');
    AmbienteItauProd := not(ArqINI.ReadString('Outros', 'AmbienteItau', 'Producao') = 'Homologacao');
  finally
    FreeAndNil(ArqINI);
  end;
end;

function AutenticaoITAU(out Mensagem:string) : boolean;
var
  sJson, sJsonRet : string;
  Authorization : TAuthorization;
  AuthorizationResp : TAuthorizationResp;
  StatusCode : integer;
  Url : string;
begin
  Result := False;

  Authorization := TAuthorization.Create;

  try
    if AmbienteItauProd then
    begin
      Authorization.AccessKey    := ITAU_access_key;
      Authorization.PosProductId := ITAU_pos_product_id;
      Url                        := URL_ITAU;
    end else
    begin
      Authorization.AccessKey    := ITAU_access_key_H;
      Authorization.PosProductId := ITAU_pos_product_id_H;
      Url                        := URL_ITAU_H;
    end;

    sJson := TJson.ObjectToJsonString(Authorization);

    StatusCode := 0;

    if RequisicaoItau(Url+'/pdvsysauth',sJson,sJsonRet,StatusCode,False) then
    begin
      try
        AuthorizationResp  := TJson.JsonToObject<TAuthorizationResp>(sJsonRet);

        ITAU_access_token  := AuthorizationResp.AccessToken;
        ITAU_refresh_token := AuthorizationResp.RefreshToken;
      finally
        FreeAndNil(AuthorizationResp);
      end;

      Result := True;
    end else
    begin
      LogSistema('Falha na autenticação. '+'Código: '+StatusCode.ToString+' '+sJsonRet);

      Mensagem :='Falha na autenticação.'+#13#10+
                 'Verifique com o suporte técnico!'+#13#10+
                 'Código: '+StatusCode.ToString;
    end;
  finally
    FreeAndNil(Authorization);
  end;
end;

function RegistraContaItau(user_full_name,user_email,customer_name,customer_email,store_name,
                           store_cnpj_cpf,store_postal_code,store_street,store_street_number,
                           store_city,store_state,store_neighborhood,store_reference,
                           store_pos_names,user_role_id,user_phone : string;
                           out client_id,access_key,secret_key : string;
                           out Mensagem:string):boolean;
var
  sJson,sJsonRet : string;
  registration_pub : Tregistration_pub;
  registration_pub_ret : Tregistration_pub_ret;

  store_pos_names_ar : TArray<string>;
  StatusCode : integer;
  sMensagem : string;
  Url : string;
begin
  Result := False;

  try
    if AmbienteItauProd then
    begin
      Url    := URL_ITAU;
    end else
    begin
      Url    := URL_ITAU_H;
    end;

    registration_pub   := Tregistration_pub.Create;

    SetLength(store_pos_names_ar,1);
    store_pos_names_ar[0] := store_pos_names;

    registration_pub.CustomerEmail       := customer_email;
    registration_pub.CustomerName        := customer_name;
    registration_pub.user_role_id        := user_role_id;
    registration_pub.StoreCity           := store_city;
    registration_pub.StoreCnpjCpf        := store_cnpj_cpf;
    registration_pub.StoreName           := store_name;
    registration_pub.StoreNeighborhood   := store_neighborhood;
    registration_pub.StorePosNames       := store_pos_names_ar;
    registration_pub.StorePostalCode     := store_postal_code;
    registration_pub.StoreReference      := store_reference;
    registration_pub.StoreState          := store_state;
    registration_pub.StoreStreet         := store_street;
    registration_pub.StoreStreetNumber   := store_street_number;
    registration_pub.TermsAccepted       := True;
    registration_pub.UserEmail           := user_email;
    registration_pub.UserFullName        := user_full_name;
    registration_pub.UserPhone           := user_phone;

    if not AmbienteItauProd then
      registration_pub.RetailChainId     := '2ef0b250-f103-49c5-941e-feb51bc875eb';

    sJson := TJson.ObjectToJsonString(registration_pub,[TJsonOption.joIgnoreEmptyStrings]);

    if RequisicaoItau(Url+'/registration/pub',sJson,sJsonRet,StatusCode) then
    begin
      try
        registration_pub_ret  := TJson.JsonToObject<Tregistration_pub_ret>(sJsonRet);

        client_id  := registration_pub_ret.ClientIds[0].ClientId;
        access_key := registration_pub_ret.CustomerAccessKey;
        secret_key := registration_pub_ret.CustomerSecretKey;
        Result := True;
      finally
        FreeAndNil(registration_pub_ret);
      end;
    end else
    begin
      LogSistema('Falha ao criar cadastro. '+'Código: '+StatusCode.ToString+' '+sJsonRet);

      sMensagem := 'Verifique com o suporte técnico!'+#13#10+
                   'Código: '+StatusCode.ToString;

      if (pos('Customer already in the database' ,sJsonRet) > 0) then
        sMensagem := 'Suas credenciais já foram enviadas, verifique seu e-mail.';

      if (pos('User already in the database' ,sJsonRet) > 0) then
        sMensagem := 'E-mail já cadastrado na base de dados da Conexão Itaú.';

      Mensagem := 'Falha ao criar cadastro.'+#13#10+
                  sMensagem;
    end;
  finally
    FreeandNil(registration_pub);
  end;
end;

end.


