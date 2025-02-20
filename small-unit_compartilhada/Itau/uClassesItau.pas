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
  end;


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


type
  TOrderItems = class
  private
    [JSONName('item_title')]
    FItemTitle: string;
    FQuantity: Double;
    [JSONName('unit_price')]
    FUnitPrice: Double;
  published
    property ItemTitle: string read FItemTitle write FItemTitle;
    property Quantity: Double read FQuantity write FQuantity;
    property UnitPrice: Double read FUnitPrice write FUnitPrice;
  end;

type
  TOrder = class
  private
    [JSONName('items')]
    FItems: TArray<TOrderItems>;
    [JSONName('order_ref')]
    FOrderRef: string;
    FTotal: Double;
    FWallet: string;
  published
    property Items: TArray<TOrderItems> read FItems write FItems;
    property OrderRef: string read FOrderRef write FOrderRef;
    property Total: Double read FTotal write FTotal;
    property Wallet: string read FWallet write FWallet;
  end;



type
  TOrderRet = class
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
  TRetornoPagPIX = class
  private
    [JSONName('created_at')]
    FCreatedAt: string;
    [JSONName('external_id')]
    FExternalId: string;
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
    property OrderId: string read FOrderId write FOrderId;
    property PaidAmount: Double read FPaidAmount write FPaidAmount;
    property PaymentDate: string read FPaymentDate write FPaymentDate;
    property PixPsp: string read FPixPsp write FPixPsp;
    property Status: string read FStatus write FStatus;
    property TotalOrder: Double read FTotalOrder write FTotalOrder;
    property UpdatedAt: string read FUpdatedAt write FUpdatedAt;
    property Wallet: string read FWallet write FWallet;
    property WalletPaymentId: string read FWalletPaymentId write FWalletPaymentId;
  end;


type
  TOrderCancelRet = class
  private
    FMessage: string;
    [JSONName('order_id')]
    FOrderId: string;
    FStatus: string;
  published
    property Message: string read FMessage write FMessage;
    property OrderId: string read FOrderId write FOrderId;
    property Status: string read FStatus write FStatus;
  end;

implementation


end.
