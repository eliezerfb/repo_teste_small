unit uTextoEmailFactory;

interface

uses
  uITextoEmailFactory, uITextoEmail;

type
  TTextoEmailFactory = class(TInterfacedObject, ITextoEmailFactory)
  private
  public
    class function New: ITextoEmailFactory;
    function NFe: ITextoEmail;
  end;

implementation

uses
  uTextoEmailNFe;

{ TTextoEmailFactory }

class function TTextoEmailFactory.New: ITextoEmailFactory;
begin
  Result := Self.Create;
end;

function TTextoEmailFactory.NFe: ITextoEmail;
begin
  Result := TTextoEmailNFe.New;
end;

end.
