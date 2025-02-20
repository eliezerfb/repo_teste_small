unit uSectionsNFeINI;

interface

uses
  uSectionDATPadrao, uSmallEnumerados;

type
  TSectionNFEINI = class(TSectionDATPadrao)
  private
    function getAmbiente: tAmbienteNFe;
    procedure setAmbiente(const Value: tAmbienteNFe);
  public
    property Ambiente: tAmbienteNFe read getAmbiente write setAmbiente;
    function AmbienteToStr(AenAmbiente: tAmbienteNFe): String;
    function AmbienteStrToEnum(AcAmbiente: String): tAmbienteNFe;
  protected
    function Section: String; override;
  end;

implementation

uses SysUtils, uSmallConsts;

{ TSectionNFE }

function TSectionNFEINI.AmbienteStrToEnum(AcAmbiente: String): tAmbienteNFe;
begin
  Result := tanfHomologacao;
  if AcAmbiente = _cAmbienteProducao then
    Result := tanfProducao;
end;

function TSectionNFEINI.AmbienteToStr(AenAmbiente: tAmbienteNFe): String;
begin
  Result := _cAmbienteHomologacao;
  if AenAmbiente = tanfProducao then
    Result := _cAmbienteProducao;
end;

function TSectionNFEINI.getAmbiente: tAmbienteNFe;
begin
  Result := tanfHomologacao;

  if AnsiUpperCase(FoIni.ReadString(Section, _cIdentNFEAmbiente, _cAmbienteHomologacao)) = AnsiUpperCase(_cAmbienteProducao) then
    Result := tanfProducao;
end;

function TSectionNFEINI.Section: String;
begin
  Result := _cSectionNFE;
end;

procedure TSectionNFEINI.setAmbiente(const Value: tAmbienteNFe);
var
  cAmbiente: String;
begin
  cAmbiente := _cAmbienteHomologacao;
  if Value = tanfProducao then
    cAmbiente := _cAmbienteProducao;

  FoIni.WriteString(Section, _cIdentNFEAmbiente, cAmbiente);
end;

end.
