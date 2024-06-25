{Recebe as chamdas da API e envia para uWebServiceItau usando a classe uClassesItau}



unit uIntegracaoItau;

interface

uses
  System.SysUtils, REST.JSON, System.Generics.Collections, REST.Json.Types,
  System.IniFiles, Vcl.Forms, REST.Types, IBX.IBDatabase, IBX.IBQuery;

var
  AmbienteItauProd : boolean;

  const URL_ITAU   = 'https://api-conexaoitau.shipay.com.br';
  const URL_ITAU_H = 'https://api-staging.shipay.com.br';

  procedure CarregaTipoAmbiente;
  function AutenticaoITAU(out Mensagem:string) : boolean;
  function RegistraContaItau(user_full_name,user_email,customer_name,customer_email,store_name,
                             store_cnpj_cpf,store_postal_code,store_street,store_street_number,
                             store_city,store_state,store_neighborhood,store_reference,
                             store_pos_names,user_role_id,user_phone, retail_chain_id : string;
                             out client_id,access_key,secret_key : string;
                             out Mensagem:string):boolean;

  function AutenticaoPDV(client_id,access_key,secret_key : string; out Mensagem : string) : boolean;
  function GeraChavePixItau(client_id,access_key,secret_key,order_ref : string;
                            Valor : double; out ChaveQRCode, order_id, Mensagem : string):boolean;
  function GetStatusOrder(order_id:string):string;
  function CancelOrder(order_id:string):boolean;
  function EstornaOrder(order_id:string):boolean;
  function RefreshTokenItau:boolean;
  function CarregaInformacoesItau(IBTRANSACTION: TIBTransaction):Boolean;


implementation

uses
  uClassesItau
  , uWebServiceItau
  , uconstantes_chaves_privadas
  , uLogSistema
  , uSmallConsts, uDialogs, uConectaBancoSmall;

function GetURL : string;
begin
  if AmbienteItauProd then
  begin
    Result  := URL_ITAU;
  end else
  begin
    Result  := URL_ITAU_H;
  end;
end;
  
procedure CarregaTipoAmbiente;
var
  ArqINI: TIniFile;
begin
  try
    ArqINI := TIniFile.Create(ExtractFilePath(Application.ExeName)+'smallcom.inf');
    AmbienteItauProd := not(ArqINI.ReadString(_cSectionSmallComOutros, 'AmbienteItau', _cAmbienteProducao) = _cAmbienteHomologacao);
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
begin
  Result := False;

  Authorization := TAuthorization.Create;

  try
    if AmbienteItauProd then
    begin
      Authorization.AccessKey    := ITAU_access_key;
      Authorization.PosProductId := ITAU_pos_product_id;
    end else
    begin
      Authorization.AccessKey    := ITAU_access_key_H;
      Authorization.PosProductId := ITAU_pos_product_id_H;
    end;

    
    sJson := TJson.ObjectToJsonString(Authorization);

    StatusCode := 0;

    if RequisicaoItau(rmPOST,GetURL+'/pdvsysauth',sJson,sJsonRet,StatusCode,False) then
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
                           store_pos_names,user_role_id,user_phone, retail_chain_id : string;
                           out client_id,access_key,secret_key : string;
                           out Mensagem:string):boolean;
var
  sJson,sJsonRet : string;
  registration_pub : Tregistration_pub;
  registration_pub_ret : Tregistration_pub_ret;

  store_pos_names_ar : TArray<string>;
  StatusCode : integer;
  sMensagem : string;
begin
  Result := False;

  try
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
    registration_pub.RetailChainId       := retail_chain_id;

    sJson := TJson.ObjectToJsonString(registration_pub,[TJsonOption.joIgnoreEmptyStrings]);

    if RequisicaoItau(rmPOST,GetURL+'/registration/pub',sJson,sJsonRet,StatusCode) then
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

      if (pos('CPF already in the database' ,sJsonRet) > 0) then
        sMensagem := 'CNPJ/CPF já cadastrado na base de dados da Conexão Itaú.';

      if (pos('User already in the database' ,sJsonRet) > 0) then
        sMensagem := 'E-mail já cadastrado na base de dados da Conexão Itaú.';

      Mensagem := 'Falha ao criar cadastro.'+#13#10+
                  sMensagem;
    end;
  finally
    FreeandNil(registration_pub);
  end;
end;

function AutenticaoPDV(client_id,access_key,secret_key : string; out Mensagem : string) : boolean;
var
  sJson, sJsonRet : string;
  pdvauth : Tpdvauth;
  pdvauthRet : TpdvauthRet;
  StatusCode : integer;
begin
  Result := False;

  ITAU_ClientId  := client_id;
  ITAU_AccessKey := access_key;
  ITAU_SecretKey := secret_key;

  pdvauth := Tpdvauth.Create;

  try
    pdvauth.AccessKey := access_key;
    pdvauth.ClientId  := client_id;
    pdvauth.SecretKey := secret_key;

    sJson := TJson.ObjectToJsonString(pdvauth);

    StatusCode := 0;

    if RequisicaoItau(rmPOST,GetURL+'/pdvauth',sJson,sJsonRet,StatusCode,False) then
    begin
      try
        pdvauthRet  := TJson.JsonToObject<TpdvauthRet>(sJsonRet);

        ITAU_access_token  := pdvauthRet.AccessToken;
        ITAU_refresh_token := pdvauthRet.RefreshToken;
      finally
        FreeAndNil(pdvauthRet);
      end;

      Result := True;
    end else
    begin
      LogSistema('Falha na autenticação PDV. '+'Código: '+StatusCode.ToString+' '+sJsonRet);

      Mensagem :='Falha na autenticação PDV.'+#13#10+
                 'Verifique com o suporte técnico!'+#13#10+
                 'Código: '+StatusCode.ToString;
    end;
  finally
    FreeAndNil(pdvauth);
  end;
end;


function GeraChavePixItau(client_id,access_key,secret_key,order_ref : string;
                          Valor : double; out ChaveQRCode, order_id, Mensagem : string):boolean;
var
  sJson, sJsonRet : string;
  OrderItemsAr : TArray<TOrderItems>;
  Order : TOrder;
  OrderRet : TOrderRet;
  StatusCode : integer;  
  sWallet  : string;
begin
  Result := False;

  if ITAU_access_token = '' then
  begin
    if not AutenticaoPDV(client_id,access_key,secret_key,Mensagem) then
      Exit;
  end;

  if AmbienteItauProd then
  begin
    sWallet  := 'pix';
  end else
  begin
    sWallet  := 'shipay-pagador';
  end;

  try
    SetLength(OrderItemsAr,1);
    OrderItemsAr[0] := TOrderItems.Create;
    OrderItemsAr[0].ItemTitle := order_ref;
    OrderItemsAr[0].Quantity  := 1;
    OrderItemsAr[0].UnitPrice := Valor;

    Order := TOrder.Create;
    Order.Items    := OrderItemsAr;
    Order.OrderRef := order_ref;
    Order.Wallet   := sWallet;
    Order.Total    := Valor;

    sJson := TJson.ObjectToJsonString(Order);

    if RequisicaoItau(rmPOST,GetURL+'/order',sJson,sJsonRet,StatusCode) then
    begin
      try
        OrderRet  := TJson.JsonToObject<TOrderRet>(sJsonRet);

        ChaveQRCode := OrderRet.QrCodeText;
        order_id    := OrderRet.OrderId;
      finally
        FreeAndNil(OrderRet);
      end;

      Result := True;
    end else
    begin
      LogSistema('Falha ao gerar chave PIX. '+'Código: '+StatusCode.ToString+' '+sJsonRet);
      
      Mensagem :='Falha ao gerar chave PIX.'+#13#10+
                 'Verifique com o suporte técnico!'+#13#10+
                 'Código: '+StatusCode.ToString;
    end;
    
    
  finally
    FreeAndNil(Order);
    OrderItemsAr[0].Free;
  end;
end;

function GetStatusOrder(order_id:string):string;
var
  sJsonRet : string;
  StatusCode : integer;
  RetornoPagPIX : TRetornoPagPIX;
begin
  Result := '';

  try
    if RequisicaoItau(rmGET,GetURL+'/order/'+order_id,'',sJsonRet,StatusCode) then
    begin
      try
        RetornoPagPIX  := TJson.JsonToObject<TRetornoPagPIX>(sJsonRet);

        if order_id = RetornoPagPIX.OrderId then
          Result := RetornoPagPIX.Status;
      finally
        FreeAndNil(RetornoPagPIX);
      end;
    end;
  except
  end;
end;


function CancelOrder(order_id:string):boolean;
var
  sJsonRet : string;
  StatusCode : integer;
  OrderCancelRet : TOrderCancelRet;
begin
  Result := False;

  try
    if RequisicaoItau(rmDELETE,GetURL+'/order/'+order_id,'',sJsonRet,StatusCode) then
    begin
      try
        OrderCancelRet  := TJson.JsonToObject<TOrderCancelRet>(sJsonRet);

        if order_id = OrderCancelRet.OrderId then
          Result := True;
      finally
        FreeAndNil(OrderCancelRet);
      end;
    end;
  except
  end;
end;

function EstornaOrder(order_id:string):boolean;
var
  sJsonRet : string;
  StatusCode : integer;
  OrderCancelRet : TOrderCancelRet;
begin
  Result := False;

  try
    if RequisicaoItau(rmDELETE,GetURL+'/order/'+order_id+'/refund','',sJsonRet,StatusCode) then
    begin
      try
        OrderCancelRet  := TJson.JsonToObject<TOrderCancelRet>(sJsonRet);

        if order_id = OrderCancelRet.OrderId then
          Result := True;
      finally
        FreeAndNil(OrderCancelRet);
      end;
    end;
  except
  end;
end;

function RefreshTokenItau:boolean;
var
  sJsonRet : string;
  StatusCode : integer;
  pdvauthRet : TpdvauthRet;
  Mensagem : string;
begin
  Result := False;

  try
    ITAU_access_token := ITAU_refresh_token;
  
    if RequisicaoItau(rmPOST,GetURL+'/refresh-token','',sJsonRet,StatusCode) then
    begin
      try
        pdvauthRet  := TJson.JsonToObject<TpdvauthRet>(sJsonRet);

        ITAU_access_token  := pdvauthRet.AccessToken;
        ITAU_refresh_token := pdvauthRet.RefreshToken;

        Result := True;
      finally
        FreeAndNil(pdvauthRet);
      end;
    end else
    begin
      ITAU_access_token  := '';
      ITAU_refresh_token := '';

      //Tenta autenticar novamente se refresh não funcionou
      Result := AutenticaoPDV(ITAU_ClientId, ITAU_AccessKey, ITAU_SecretKey, Mensagem);
    end;
  except
  end;
end;


function CarregaInformacoesItau(IBTRANSACTION: TIBTransaction):Boolean;
var
  ibqItau: TIBQuery;
  client_id,access_key,secret_key,Mensagem : string;
begin
  Result := False;

  if ITAU_access_token <> '' then
  begin
    Result := True;
    Exit;
  end;

  try
    ibqItau := CriaIBQuery(IBTRANSACTION);
    ibqItau.SQL.Text := ' Select '+
                        ' 	I.USUARIO,'+
                        ' 	I.SENHA,'+
                        ' 	I.CLIENTID,'+
                        ' 	B.INSTITUICAOFINANCEIRA'+
                        ' From CONFIGURACAOITAU I'+
                        ' 	Left Join BANCOS B on B.IDBANCO = I.IDBANCO'+
                        ' Where I.HABILITADO = ''S'' ';
    ibqItau.Open;

    //Nenhum banco configurado com pix estático
    if ibqItau.IsEmpty then
    begin
      MensagemSistema('Nenhuma integração habilitada!',msgAtencao);
      Exit;
    end;

    client_id  := ibqItau.FieldByName('CLIENTID').AsString;
    access_key := ibqItau.FieldByName('USUARIO').AsString;
    secret_key := ibqItau.FieldByName('SENHA').AsString;

    if not AutenticaoPDV(client_id,access_key,secret_key,Mensagem) then
    begin
      MensagemSistema(Mensagem,msgAtencao);
      Exit;
    end;

    Result := True;
  finally
    FreeAndNil(ibqItau);
  end;
end;


end.


