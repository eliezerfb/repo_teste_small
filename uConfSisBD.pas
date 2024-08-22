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
  , uCarneSections
  ;

type
  TConfBD = class(TConfiguracoesSistemaBD)
  private
    FoOS: TSectionOS;
    FoOutras: TSectionOutras;
    FoNFSE: TSectionNFSE_BD;
    //FoNFSeInformacoesObtidasPrefeitura: TSectionNFSeInformacoesObtidasNaPrefeitura_BD;
    FoImpressora: TSectionImpressora;
    FoCarne: TSectionCarne;
    function getOS: TSectionOS;
    function getOutras: TSectionOutras;
    function getNFSE: TSectionNFSE_BD;
    function getImpressora: TSectionImpressora;
    function getCarne: TSectionCarne;
  public
    destructor Destroy; override;
    property OS: TSectionOS read getOS;
    property Outras: TSectionOutras read getOutras;
    property NFSe: TSectionNFSE_BD read getNFSE;
    property Impressora: TSectionImpressora read getImpressora;
    property Carne: TSectionCarne read getCarne;
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

function TConfBD.getCarne: TSectionCarne;
begin
  if not Assigned(FoCarne) then
    FoCarne := TSectionCarne.Create(Transaction,_cSectionCarne);

  Result := FoCarne;
end;

function TConfBD.getNFSE: TSectionNFSE_BD;
begin
  if not Assigned(FoNFSE) then
    FoNFSE := TSectionNFSE_BD.Create(Transaction,_cSectionNFSE);

  Result := FoNFSE;
end;

{
function TConfBD.getNFSeCertificao: TSectionNFSeCertificado_BD;
begin
  if not Assigned(FoNFSeCerficicado) then
    FoNFSeCerficicado := TSectionNFSeCertificado_BD.Create(Transaction, _cSectionNFSeCertificado);

  Result := FoNFSeCerficicado;
end;

function TConfBD.getNFSeInformacoesObtidasNaPrefeitura: TSectionNFSeInformacoesObtidasNaPrefeitura_BD;
begin
  if not Assigned(FoNFSeInformacoesObtidasPrefeitura) then
    FoNFSeInformacoesObtidasPrefeitura := TSectionNFSeInformacoesObtidasNaPrefeitura_BD.Create(Transaction, _cSectionNFSeInformacoesObtidasNaPrefeitura);

  Result := FoNFSeInformacoesObtidasPrefeitura;

end;

function TConfBD.getNFSeWebServico: TSectionNFSeWebService_BD;
begin
  if not Assigned(FoNFSeWebService) then
    FoNFSeWebService := TSectionNFSeWebService_BD.Create(Transaction, _cSectionNFSeWebService);

  Result := FoNFSeWebService;
end;
}
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
