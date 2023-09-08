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
    function CCe: ITextoEmail;
    function Orcamento: ITextoEmail;           
  end;

implementation

uses
  uTextoEmailNFe, uTextoEmailCCe;

{ TTextoEmailFactory }

function TTextoEmailFactory.CCe: ITextoEmail;
begin
  Result := TTextoEmailCCe.New;
end;

class function TTextoEmailFactory.New: ITextoEmailFactory;
begin
  Result := Self.Create;
end;

function TTextoEmailFactory.NFe: ITextoEmail;
begin
  Result := TTextoEmailNFe.New;
end;

function TTextoEmailFactory.Orcamento: ITextoEmail;
begin
  Result := nil;
end;

end.
