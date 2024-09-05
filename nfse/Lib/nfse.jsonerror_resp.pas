unit nfse.jsonerror_resp;

interface

uses
  Pkg.Json.DTO;

{$M+}

type

  TAdditional_DataDTO = class
  private
    FError_Fields: string;
  published
    property Error_Fields: string read FError_Fields write FError_Fields;
  end;

  TErrorDTO = class(TJsonDTO)
  private
    FError_Code: Integer;
    FError_Message: string;
    FAdditional_Data: TAdditional_DataDTO;
  published
    property Additional_Data: TAdditional_DataDTO read FAdditional_Data write FAdditional_Data;
    property Error_Code: Integer read FError_Code write FError_Code;
    property Error_Message: string read FError_Message write FError_Message;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

implementation


{ TErrorDTO }

constructor TErrorDTO.Create;
begin
  inherited;
  FAdditional_Data := TAdditional_DataDTO.Create;
end;

destructor TErrorDTO.Destroy;
begin
  FAdditional_Data.Free;
  inherited;
end;

end.
