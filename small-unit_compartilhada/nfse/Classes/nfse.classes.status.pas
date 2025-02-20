unit nfse.classes.status;

interface
uses
  Pkg.Json.DTO;


type
  TNFSeStatus = class(TJsonDTO)
  private
    Fdescstatus: string;
    Fstatus: Integer;
    procedure Setdescstatus(const Value: string);
    procedure Setstatus(const Value: Integer);


  published
    property status : Integer read Fstatus write Setstatus;
    property descstatus : string read Fdescstatus write Setdescstatus;
  end;



implementation

{ TNFSeStatus }

procedure TNFSeStatus.Setdescstatus(const Value: string);
begin
  Fdescstatus := Value;
end;

procedure TNFSeStatus.Setstatus(const Value: Integer);
begin
  Fstatus := Value;
end;

end.
