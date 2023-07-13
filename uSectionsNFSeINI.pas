unit uSectionsNFSeINI;

interface

uses
  uSectionDATPadrao, uSmallEnumerados;

type
  TSectionNFSEINI = class(TSectionDATPadrao)
  private
    function getAmbiente: tAmbienteNFSe;
    procedure setAmbiente(const Value: tAmbienteNFSe);
  public
    property Ambiente: tAmbienteNFSe read getAmbiente write setAmbiente;
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

end.
