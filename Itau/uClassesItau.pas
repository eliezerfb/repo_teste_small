unit uClassesItau;

interface

uses
  System.Generics.Collections, REST.Json.Types;


type
  TAuthorization = class
  private
    [JSONName('access_key')]
    FAccessKey: string;
    [JSONName('pos_product_id')]
    FPosProductId: string;
  published
    property AccessKey: string read FAccessKey write FAccessKey;
    property PosProductId: string read FPosProductId write FPosProductId;
  end;

type
  TAuthorizationResp = class
  private
    [JSONName('access_token')]
    FAccessToken: string;
    [JSONName('refresh_token')]
    FRefreshToken: string;
  published
    property AccessToken: string read FAccessToken write FAccessToken;
    property RefreshToken: string read FRefreshToken write FRefreshToken;
  end;

type
  Tregistration_pub = class
  private
    [JSONName('customer_email')]
    FCustomerEmail: string;
    [JSONName('customer_name')]
    FCustomerName: string;
    [JSONName('user_role_id')]
    Fuser_role_id: string;
    [JSONName('store_city')]
    FStoreCity: string;
    [JSONName('store_cnpj_cpf')]
    FStoreCnpjCpf: string;
    [JSONName('store_name')]
    FStoreName: string;
    [JSONName('store_neighborhood')]
    FStoreNeighborhood: string;
    [JSONName('store_pos_names')]
    FStorePosNames: TArray<string>;
    [JSONName('store_postal_code')]
    FStorePostalCode: string;
    [JSONName('store_reference')]
    FStoreReference: string;
    [JSONName('store_state')]
    FStoreState: string;
    [JSONName('store_street')]
    FStoreStreet: string;
    [JSONName('store_street_number')]
    FStoreStreetNumber: string;
    [JSONName('terms_accepted')]
    FTermsAccepted: Boolean;
    [JSONName('user_email')]
    FUserEmail: string;
    [JSONName('user_full_name')]
    FUserFullName: string;
    [JSONName('user_password')]
    FUserPassword: string;
    [JSONName('user_phone')]
    FUserPhone: string;
    [JSONName('retail_chain_id')]
    FRetailChainId : string;
  published
    property CustomerEmail: string read FCustomerEmail write FCustomerEmail;
    property CustomerName: string read FCustomerName write FCustomerName;
    property user_role_id: string read Fuser_role_id write Fuser_role_id;
    property StoreCity: string read FStoreCity write FStoreCity;
    property StoreCnpjCpf: string read FStoreCnpjCpf write FStoreCnpjCpf;
    property StoreName: string read FStoreName write FStoreName;
    property StoreNeighborhood: string read FStoreNeighborhood write FStoreNeighborhood;
    property StorePosNames: TArray<string> read FStorePosNames write FStorePosNames;
    property StorePostalCode: string read FStorePostalCode write FStorePostalCode;
    property StoreReference: string read FStoreReference write FStoreReference;
    property StoreState: string read FStoreState write FStoreState;
    property StoreStreet: string read FStoreStreet write FStoreStreet;
    property StoreStreetNumber: string read FStoreStreetNumber write FStoreStreetNumber;
    property TermsAccepted: Boolean read FTermsAccepted write FTermsAccepted;
    property UserEmail: string read FUserEmail write FUserEmail;
    property UserPassword: string read FUserPassword write FUserPassword;
    property UserFullName: string read FUserFullName write FUserFullName;
    property UserPhone: string read FUserPhone write FUserPhone;
    property RetailChainId: string read FRetailChainId write FRetailChainId;
  public
    destructor Destroy; override;
  end;

type
  TClientIds = class
  private
    [JSONName('client_id')]
    FClientId: string;
    [JSONName('store_pos_id')]
    FStorePosId: string;
    [JSONName('store_pos_name')]
    FStorePosName: string;
  published
    property ClientId: string read FClientId write FClientId;
    property StorePosId: string read FStorePosId write FStorePosId;
    property StorePosName: string read FStorePosName write FStorePosName;
  end;


  Tregistration_pub_ret = class
  private
    [JSONName('client_ids'), JSONMarshalled(False)]
    FClientIds: TArray<TClientIds>;
    [JSONName('customer_access_key')]
    FCustomerAccessKey: string;
    [JSONName('customer_id')]
    FCustomerId: string;
    [JSONName('customer_secret_key')]
    FCustomerSecretKey: string;
    [JSONName('registration_id')]
    FRegistrationId: string;
    [JSONName('store_id')]
    FStoreId: string;
  published
    property ClientIds: TArray<TClientIds> read FClientIds write FClientIds;
    property CustomerAccessKey: string read FCustomerAccessKey write FCustomerAccessKey;
    property CustomerId: string read FCustomerId write FCustomerId;
    property CustomerSecretKey: string read FCustomerSecretKey write FCustomerSecretKey;
    property RegistrationId: string read FRegistrationId write FRegistrationId;
    property StoreId: string read FStoreId write FStoreId;
  public
    destructor Destroy; override;
  end;

implementation

{ Tregistration_pub }

destructor Tregistration_pub.Destroy;
begin
  inherited;
end;

{ Tregistration_pub_ret }

destructor Tregistration_pub_ret.Destroy;
begin
  inherited;
end;

end.
