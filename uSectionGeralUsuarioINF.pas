unit uSectionGeralUsuarioINF;

interface

uses
  uSectionDATPadrao;

type
  TSectionGeralUsuario = class(TSectionDATPadrao)
  private
    function getMarketplaceAtivo: Boolean;
    procedure setMarketplaceAtivo(const Value: Boolean);
    function getMobileAtivo: Boolean;
    procedure setMobileAtivo(const Value: Boolean);
  public
    property MarketplaceAtivo: Boolean read getMarketplaceAtivo write setMarketplaceAtivo;
    property MobileAtivo: Boolean read getMobileAtivo write setMobileAtivo;
  protected
    function Section: String; override;
  end;

implementation

uses SysUtils, uSmallConsts;

{ TSectionGeral }

function TSectionGeralUsuario.getMarketplaceAtivo: Boolean;
begin
  Result := (FoIni.ReadString(Section, _cIdentGeralUsuMarketPlaceAtivo, _cNao) = _cSim);
end;

function TSectionGeralUsuario.getMobileAtivo: Boolean;
begin
  Result := (FoIni.ReadString(Section, _cIdentGeralUsuMobileAtivo, _cNao) = _cSim);
end;

function TSectionGeralUsuario.Section: String;
begin
  Result := _cSectionGeralUsuario;
end;

procedure TSectionGeralUsuario.setMarketplaceAtivo(const Value: Boolean);
var
  cValor: String;
begin
  cValor := _cNao;
  if Value then
    cValor := _cSim;

  FoIni.WriteString(Section, _cIdentGeralUsuMarketPlaceAtivo, cValor);
end;

procedure TSectionGeralUsuario.setMobileAtivo(const Value: Boolean);
var
  cValor: String;
begin
  cValor := _cNao;
  if Value then
    cValor := _cSim;

  FoIni.WriteString(Section, _cIdentGeralUsuMobileAtivo, cValor);
end;

end.
