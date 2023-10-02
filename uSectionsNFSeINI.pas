unit uSectionsNFSeINI;

interface

uses
  uSectionDATPadrao, uSmallEnumerados;

type
  TSectionNFSEINI = class(TSectionDATPadrao)
  private
    function getAmbiente: tAmbienteNFSe;
    procedure setAmbiente(const Value: tAmbienteNFSe);
    function getPadraoProvedor: String;
  public
    function AmbienteToStr(AenAmbiente: tAmbienteNFSe): String;
    property Ambiente: tAmbienteNFSe read getAmbiente write setAmbiente;
    property PadraoProvedor: String read getPadraoProvedor;
  protected
    function Section: String; override;
  end;

implementation

uses SysUtils, uSmallConsts;

{ TSectionNFEINI }

function TSectionNFSEINI.getAmbiente: tAmbienteNFSe;
begin
  Result := tAmbienteNFSe(FoIni.ReadInteger(Section, _cIdentNFSEAmbiente, Ord(tanfsHomologacao)));
end;

function TSectionNFSEINI.Section: String;
begin
  Result := _cSectionNFSE;
end;

procedure TSectionNFSEINI.setAmbiente(const Value: tAmbienteNFSe);
begin
  FoIni.WriteInteger(Section, _cIdentNFEAmbiente, Ord(Value));
end;

function TSectionNFSEINI.AmbienteToStr(AenAmbiente: tAmbienteNFSe): String;
begin
  Result := _cAmbienteHomologacao;
  if AenAmbiente = tanfsProducao then
    Result := _cAmbienteProducao;
end;

function TSectionNFSEINI.getPadraoProvedor: String;
begin
  Result := FoIni.ReadString(_cSectionNFSE_InformacoesObtidasPrefeitura, _cIdentiPadraoCidade, '');
end;

end.
