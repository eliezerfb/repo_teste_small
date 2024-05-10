unit uConfSisBD;

interface

uses
  uArquivoDATINFPadrao
  , uOSSections
  , uOutrasSections
  , uSmallConsts
  , uNFSeSections
  , SysUtils
  , uImpressoraSections
  ;

type
  TConfBD = class(TConfiguracoesSistemaBD)
  private
    FoOS: TSectionOS;
    FoOutras: TSectionOutras;
    FoNFSE: TSectionNFSE_BD;
    FoImpressora: TSectionImpressora;
    function getOS: TSectionOS;
    function getOutras: TSectionOutras;
    function getNFSE: TSectionNFSE_BD;
    function getImpressora: TSectionImpressora;
  public
    destructor Destroy; override;
    property OS: TSectionOS read getOS;
    property Outras: TSectionOutras read getOutras;
    property NFSE: TSectionNFSE_BD read getNFSE;
    property Impressora: TSectionImpressora read getImpressora;
  protected
  end;

implementation


{ TOSBD }


destructor TConfBD.Destroy;
begin
  FreeAndNil(FoOS);
  inherited;
end;

function TConfBD.getImpressora: TSectionImpressora;
begin
  if not Assigned(FoImpressora) then
    FoImpressora := TSectionImpressora.Create(Transaction,_cSectionImpressora);

  Result := FoImpressora;
end;

function TConfBD.getNFSE: TSectionNFSE_BD;
begin
  if not Assigned(FoNFSE) then
    FoNFSE := TSectionNFSE_BD.Create(Transaction,_cSectionNFSE);

  Result := FoNFSE;
end;

function TConfBD.getOS: TSectionOS;
begin
  if not Assigned(FoOS) then
    FoOS := TSectionOS.Create(Transaction,_cSectionOS);

  Result := FoOS;
end;

function TConfBD.getOutras: TSectionOutras;
begin
  if not Assigned(FoOutras) then
    FoOutras := TSectionOutras.Create(Transaction,_cSectionOutras);

  Result := FoOutras;
end;

end.
