unit nfse.checaservico;

interface
uses
  System.SysUtils;

type
  TClassCheckService = class
    private

    public
      class function CheckService(message_return : string) : integer ;
  end;

implementation

{ TClassCheckService }

class function TClassCheckService.CheckService(message_return: string): integer;
begin
  Result := 3;
  if pos('não implementado',lowercase(message_return)) > 0 then
    Result := 5;
end;

end.
