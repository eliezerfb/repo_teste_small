unit uClassesSicoob;

interface

uses
  System.Generics.Collections, REST.Json.Types, System.SysUtils;


type
  TCampoApi = class
  public
    Descricao: string;
    Valor: string;
  end;

  TCamposApi = class
  public
    CamposApi : TArray<TCampoApi>;
    destructor Destroy; override;
  end;

type
  TRetornoBankAccount = class
  private
    FApiPixCertificate: string;
    FApiPixClientId: string;
    FApiPixClientSecret: string;
    FApiPixPwdCertificate: string;
    [SuppressZero, JSONName('created_at')]
    FCreatedAt: TDateTime;
    FDescription: string;
    FIdBank: string;
    FIdBankAccount: Integer;
    FIdClient: Integer;
    FPixKey: string;
    FPixMerchantCity: string;
    FPixMerchantName: string;
    [SuppressZero, JSONName('updated_at')]
    FUpdatedAt: TDateTime;
  published
    property ApiPixCertificate: string read FApiPixCertificate write FApiPixCertificate;
    property ApiPixClientId: string read FApiPixClientId write FApiPixClientId;
    property ApiPixClientSecret: string read FApiPixClientSecret write FApiPixClientSecret;
    property ApiPixPwdCertificate: string read FApiPixPwdCertificate write FApiPixPwdCertificate;
    property CreatedAt: TDateTime read FCreatedAt write FCreatedAt;
    property Description: string read FDescription write FDescription;
    property IdBank: string read FIdBank write FIdBank;
    property IdBankAccount: Integer read FIdBankAccount write FIdBankAccount;
    property IdClient: Integer read FIdClient write FIdClient;
    property PixKey: string read FPixKey write FPixKey;
    property PixMerchantCity: string read FPixMerchantCity write FPixMerchantCity;
    property PixMerchantName: string read FPixMerchantName write FPixMerchantName;
    property UpdatedAt: TDateTime read FUpdatedAt write FUpdatedAt;
  end;

type
  TPixGenerate = class
  private
    FDaysToExpire: Integer;
    FDebtorIdentifier: string;
    FDebtorName: string;
    FDescription: string;
    FIdBankAccount: Integer;
    FValue: Double;
  published
    property DaysToExpire: Integer read FDaysToExpire write FDaysToExpire;
    property DebtorIdentifier: string read FDebtorIdentifier write FDebtorIdentifier;
    property DebtorName: string read FDebtorName write FDebtorName;
    property Description: string read FDescription write FDescription;
    property IdBankAccount: Integer read FIdBankAccount write FIdBankAccount;
    property Value: Double read FValue write FValue;
  end;

type
  TRetPixGenerate = class
  private
    FApiRequest: string;
    FApiResponse: string;
    [SuppressZero, JSONName('created_at')]
    FCreatedAt: TDateTime;
    FDaysToExpire: Integer;
    FDebtorIdentifier: string;
    FDebtorName: string;
    FDescription: string;
    FIdBankAccount: Integer;
    FIdClient: Integer;
    FIdPixCharge: Integer;
    FPaidOut: Boolean;
    FPayloadQrCode: string;
    FPixImageUrl: string;
    FSecondsToExpire: Integer;
    FSequence: Integer;
    FTxId: string;
    [SuppressZero, JSONName('updated_at')]
    FUpdatedAt: TDateTime;
    FValue: Integer;
    FEndToEndId: string;
    FCnpjSicoob: string;
  published
    property ApiRequest: string read FApiRequest write FApiRequest;
    property ApiResponse: string read FApiResponse write FApiResponse;
    property CreatedAt: TDateTime read FCreatedAt write FCreatedAt;
    property DaysToExpire: Integer read FDaysToExpire write FDaysToExpire;
    property DebtorIdentifier: string read FDebtorIdentifier write FDebtorIdentifier;
    property DebtorName: string read FDebtorName write FDebtorName;
    property Description: string read FDescription write FDescription;
    property IdBankAccount: Integer read FIdBankAccount write FIdBankAccount;
    property IdClient: Integer read FIdClient write FIdClient;
    property IdPixCharge: Integer read FIdPixCharge write FIdPixCharge;
    property PaidOut: Boolean read FPaidOut write FPaidOut;
    property PayloadQrCode: string read FPayloadQrCode write FPayloadQrCode;
    property PixImageUrl: string read FPixImageUrl write FPixImageUrl;
    property SecondsToExpire: Integer read FSecondsToExpire write FSecondsToExpire;
    property Sequence: Integer read FSequence write FSequence;
    property TxId: string read FTxId write FTxId;
    property UpdatedAt: TDateTime read FUpdatedAt write FUpdatedAt;
    property Value: Integer read FValue write FValue;

    property EndToEndId: string read FEndToEndId write FEndToEndId;
    property CnpjSicoob: string read FCnpjSicoob write FCnpjSicoob;
  end;


type
  TRetErro = class
  private
    FMessage: string;
    FStatus: Boolean;
  published
    property Message: string read FMessage write FMessage;
    property Status: Boolean read FStatus write FStatus;
  end;

type
  TGetStatus = class
  private
    FIdBankAccount: Integer;
    FTxId: string;
  published
    property IdBankAccount: Integer read FIdBankAccount write FIdBankAccount;
    property TxId: string read FTxId write FTxId;
  end;

implementation

destructor TCamposApi.Destroy;
var
  i : integer;
begin
  for I := Low(CamposApi) to High(CamposApi) do
  begin
    FreeAndNil(CamposApi[i]);
  end;
end;

end.
