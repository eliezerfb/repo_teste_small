unit uAPIItau;

interface

uses
  System.Generics.Collections, REST.Json.Types, IdHTTP, IdSSLOpenSSL, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, System.Classes,System.SysUtils, Vcl.Forms, Winapi.Windows, FireDAC.Comp.Client;

{$M+}



type
  TAPI = Class
  private
    FMethod,
    FURL,
    FAccessToken : String;
    FJson : TStringStream;
  published
    property Method: string read FMethod write FMethod;
    property URL: string read FURL write FURL;
    property Json: TStringStream read FJson write FJson;
    property AccessToken: String read FAccessToken write FAccessToken;
    function APIEnv(URL_COMANDO:String =''):String;
    procedure TrataErro(aMsg : String);
    procedure AtualizaTokenItau;

  End;

//Auth para PIX
type
  Tpdvauth = class
  private
    [JSONName('access_key')]
    FAccessKey: string;
    [JSONName('client_id')]
    FClientId: string;
    [JSONName('secret_key')]
    FSecretKey: string;
  published
    property AccessKey: string read FAccessKey write FAccessKey;
    property ClientId: string read FClientId write FClientId;
    property SecretKey: string read FSecretKey write FSecretKey;
  end;

type
  TpdvauthRet = class
  private
    [JSONName('access_token')]
    FAccessToken: string;
    [JSONName('refresh_token')]
    FRefreshToken: string;
  published
    property AccessToken: string read FAccessToken write FAccessToken;
    property RefreshToken: string read FRefreshToken write FRefreshToken;
  end;

//PIX
type
  TItems = class
  private
    FEan: string;
    [JSONName('item_title')]
    FItemTitle: string;
    FQuantity: Double;
    FSku: string;
    [JSONName('unit_price')]
    FUnitPrice: Double;
  published
    property Ean: string read FEan write FEan;
    property ItemTitle: string read FItemTitle write FItemTitle;
    property Quantity: Double read FQuantity write FQuantity;
    property Sku: string read FSku write FSku;
    property UnitPrice: Double read FUnitPrice write FUnitPrice;
  end;

  Tbuyer = class
  private
    [JSONName('cpf_cnpj')]
    FCpfCnpj: string;
    FEmail: string;
    FName: string;
    FPhone: string;
  published
    property CpfCnpj: string read FCpfCnpj write FCpfCnpj;
    property Email: string read FEmail write FEmail;
    property Name: string read FName write FName;
    property Phone: string read FPhone write FPhone;
  end;

  TPIX = class
  private
    Fbuyer: Tbuyer;
//    [JSONName('callback_url')]
//    FCallbackUrl: string;
    [JSONName('items'), JSONMarshalled(False)]
    FItemsArray: TArray<TItems>;
    [GenericListReflect]
    FItems: TObjectList<TItems>;
    [JSONName('order_ref')]
    FOrderRef: string;
//    [JSONName('pix_dict_key')]
//    FPixDictKey: string;
    FTotal: Double;
    FWallet: string;
  published
    property buyer: Tbuyer read Fbuyer;
//    property CallbackUrl: string read FCallbackUrl write FCallbackUrl;
//    property Items: TObjectList<TItems> read GetItems;
    property OrderRef: string read FOrderRef write FOrderRef;
//    property PixDictKey: string read FPixDictKey write FPixDictKey;
    property Total: Double read FTotal write FTotal;
    property Wallet: string read FWallet write FWallet;
  public
    constructor Create;
    destructor Destroy; override;
  end;

type
  TPIXRet = class
  private
    [JSONName('deep_link')]
    FDeepLink: string;
    [JSONName('order_id')]
    FOrderId: string;
    [JSONName('pix_dict_key')]
    FPixDictKey: string;
    [JSONName('pix_psp')]
    FPixPsp: string;
    [JSONName('qr_code')]
    FQrCode: string;
    [JSONName('qr_code_text')]
    FQrCodeText: string;
    FStatus: string;
    FWallet: string;
  published
    property DeepLink: string read FDeepLink write FDeepLink;
    property OrderId: string read FOrderId write FOrderId;
    property PixDictKey: string read FPixDictKey write FPixDictKey;
    property PixPsp: string read FPixPsp write FPixPsp;
    property QrCode: string read FQrCode write FQrCode;
    property QrCodeText: string read FQrCodeText write FQrCodeText;
    property Status: string read FStatus write FStatus;
    property Wallet: string read FWallet write FWallet;
  end;

type
  TItemsPIX = class
  private
    FEan: string;
    FName: string;
    FQuantity: Double;
    FSku: string;
    [JSONName('unit_price')]
    FUnitPrice: Double;
  published
    property Ean: string read FEan write FEan;
    property Name: string read FName write FName;
    property Quantity: Double read FQuantity write FQuantity;
    property Sku: string read FSku write FSku;
    property UnitPrice: Double read FUnitPrice write FUnitPrice;
  end;

  TRetornoPagPIX = class
  private
    [JSONName('created_at')]
    FCreatedAt: string;
    [JSONName('external_id')]
    FExternalId: string;
    [JSONName('items'), JSONMarshalled(False)]
    FItemsArray: TArray<TItemsPIX>;
    [GenericListReflect]
    FItems: TObjectList<TItemsPIX>;
    [JSONName('order_id')]
    FOrderId: string;
    [JSONName('paid_amount')]
    FPaidAmount: Double;
    [JSONName('payment_date')]
    FPaymentDate: string;
    [JSONName('pix_psp')]
    FPixPsp: string;
    FStatus: string;
    [JSONName('total_order')]
    FTotalOrder: Double;
    [JSONName('updated_at')]
    FUpdatedAt: string;
    FWallet: string;
    [JSONName('wallet_payment_id')]
    FWalletPaymentId: string;
  published
    property CreatedAt: string read FCreatedAt write FCreatedAt;
    property ExternalId: string read FExternalId write FExternalId;
//    property Items: TObjectList<TItemsPIX> read GetItems;
    property OrderId: string read FOrderId write FOrderId;
    property PaidAmount: Double read FPaidAmount write FPaidAmount;
    property PaymentDate: string read FPaymentDate write FPaymentDate;
    property PixPsp: string read FPixPsp write FPixPsp;
    property Status: string read FStatus write FStatus;
    property TotalOrder: Double read FTotalOrder write FTotalOrder;
    property UpdatedAt: string read FUpdatedAt write FUpdatedAt;
    property Wallet: string read FWallet write FWallet;
    property WalletPaymentId: string read FWalletPaymentId write FWalletPaymentId;
  public
    destructor Destroy; override;
  end;


implementation

{ TRoot }




{ TAPI }

function TAPI.APIEnv(URL_COMANDO:String): String;
var
  IdHTTP        : TIdHTTP;
  AuthSSL       : TIdSSLIOHandlerSocketOpenSSL;
begin
  try
    IdHTTP  := TIdHTTP.Create(nil);
    AuthSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    IdHTTP.IOHandler := AuthSSL;
    AuthSSL.SSLOptions.SSLVersions := [sslvTLSv1_2];
    IdHTTP.Request.ContentType := 'application/json';
    IdHTTP.Request.ContentEncoding := 'utf-8';
    IdHTTP.ReadTimeout := 100000;
    if FAccessToken <> '' then
      IdHTTP.Request.CustomHeaders.Add('Authorization: Bearer ' + FAccessToken);
    try
      if FMethod = 'POST' then
        result := IdHTTP.POST(FURL, FJson);
      if FMethod = 'GET' then
        result := IdHTTP.Get(URL_COMANDO);
      if FMethod = 'DELETE' then
        result := IdHTTP.Delete(URL_COMANDO);
    except
      on E: Exception do
      begin
        result := '';
        if E is EIdHTTPProtocolException then
        begin
          if (pos('401',EIdHTTPProtocolException(E).ToString) > 0) or (pos('403',EIdHTTPProtocolException(E).ToString) > 0) then
            Application.MessageBox('Não foi possível autorizar as credenciais, verifique o cadastro da Conexão Itaú e tente novamente.','Atenção',mb_ok + mb_iconinformation)
          else if (pos('/pub' ,FURL) > 0) and (pos('408',EIdHTTPProtocolException(E).ToString) > 0) then
            Application.MessageBox('Não obtivemos retorno da Conexão Itaú, entre no painel e acesse as suas credenciais.','Atenção',mb_ok + mb_iconinformation)

          else
            TrataErro(EIdHTTPProtocolException(E).ToString + sLineBreak + Copy(EIdHTTPProtocolException(E).ErrorMessage, 1, 500))
        end
        else
          TrataErro(E.Message);
      end;
    end;

  finally
    IdHTTP.Free;
    AuthSSL.Free;
  end;
end;

procedure TAPI.TrataErro(aMsg : String);
var
  sMensagem : string;
begin
  sMensagem := copy(aMsg, Pos(aMsg, '"message": '), 1000);
  Application.MessageBox(pChar('Erro ao processar os dados: ' + #13 + #13 + sMensagem ),'Atenção',mb_ok + mb_iconinformation);
end;

constructor TPIX.Create;
begin
  inherited;
  Fbuyer := Tbuyer.Create;
end;

destructor TPIX.Destroy;
begin
  Fbuyer.Free;
  inherited;
end;


destructor TRetornoPagPIX.Destroy;
begin
  inherited;
end;

procedure TAPI.AtualizaTokenItau;
var
  qryItau            : TFDQuery;
  pdvauth            : Tpdvauth;
  pdvauthRet         : TpdvauthRet;
  aJsonEnvio         : TStringStream;
  API                : TAPI;
  IdHTTP             : TIdHTTP;
  AuthSSL            : TIdSSLIOHandlerSocketOpenSSL;
begin

  try
    IdHTTP  := TIdHTTP.Create(nil);
    AuthSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    IdHTTP.IOHandler := AuthSSL;
    AuthSSL.SSLOptions.SSLVersions := [sslvTLSv1_2];
    IdHTTP.Request.ContentType := 'application/json';
    IdHTTP.Request.ContentEncoding := 'utf-8';
    IdHTTP.ReadTimeout := 100000;
    //qryItau := TFuncao.SQL.CriarQuery(Conexao);
    qryItau.Open('Select ACCESS_TOKEN_PIX, USUARIO, SENHA, CLIENTID from TB_CONFIG_CONEXAOITAU');
    API := TAPI.Create;
    pdvauth            := Tpdvauth.Create;
    pdvauthRet         := TpdvauthRet.Create;
    API.AccessToken := qryItau.fieldByName('ACCESS_TOKEN_PIX').asstring;

    {
    if API.AccessToken <> '' then
      IdHTTP.Request.CustomHeaders.Add('Authorization: Bearer ' + API.AccessToken);
    try
      IdHTTP.Get(sURL + '/v1/wallets');
    except
      on E: Exception do
      begin
        if E is EIdHTTPProtocolException then
        begin
          if (pos('401',EIdHTTPProtocolException(E).ToString) > 0) or (pos('403',EIdHTTPProtocolException(E).ToString) > 0)  then
          begin
            pdvauth.AccessKey := trim(qryItau.FieldByName('USUARIO').AsString);
            pdvauth.SecretKey := trim(qryItau.FieldByName('SENHA').AsString);
            pdvauth.ClientId := trim(qryItau.FieldByName('CLIENTID').AsString);
            //
            aJsonEnvio := TStringStream.Create(pdvauth.AsJson, TEncoding.UTF8);
            API.Method := 'POST';
            API.URL    := sURL+'/pdvauth';
            API.Json   := aJsonEnvio;
            //
            pdvauthRet.AsJson := API.APIEnv;
            //
            qryItau.sql.Text :=  'update TB_CONFIG_CONEXAOITAU set ACCESS_TOKEN_PIX = :ACCESS_TOKEN_PIX, REFRESH_TOKEN = :REFRESH_TOKEN ';
            qryItau.ParamByName('ACCESS_TOKEN_PIX').AsString := pdvauthRet.AccessToken;
            qryItau.ParamByName('REFRESH_TOKEN').AsString    := pdvauthRet.RefreshToken;
            qryItau.ExecSQL;
            Conexao.Commit;
          end;
        end;
      end;
    end;

    }
  finally
    IdHTTP.Free;
    AuthSSL.Free;

    qryItau.free;
    pdvauth.free;
    pdvauthRet.Free;
  end;

end;


end.
