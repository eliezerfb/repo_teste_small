unit uConfSisBD;

interface

uses
  uArquivoDATINFPadrao
  , uOSSections
  , uSmallConsts
  , SysUtils
  ;

type
  TConfBD = class(TConfiguracoesSistemaBD)
  private
    FoOS: TSectionOS;
    function getOS: TSectionOS;
  public
    destructor Destroy; override;
    property OS: TSectionOS read getOS;
  protected
  end;

implementation


{ TOSBD }

destructor TConfBD.Destroy;
begin
  FreeAndNil(FoOS);
  inherited;
end;

function TConfBD.getOS: TSectionOS;
begin
  if not Assigned(FoOS) then
    FoOS := TSectionOS.Create(Transaction,_cSectionOS);

  Result := FoOS;
end;

end.
