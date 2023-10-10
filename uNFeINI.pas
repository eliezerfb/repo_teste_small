unit uNFeINI;

interface

uses
  uArquivoDATINFPadrao, uNFeSections;

type
  TNFeINI = class(TArquivoDATINFPadrao)
  private
    FoNFe: TSectionNFE;
    FoXML: TSectionXML;
    function getNFe: TSectionNFE;
    function getXML: TSectionXML;
  public
    destructor Destroy; override;

    property NFE: TSectionNFE read getNFe;
    property XML: TSectionXML read getXML;
  protected
    function NomeArquivo: String; override;
  end;

implementation

uses TypInfo, SysUtils, IniFiles;

{ TNFeINI }

destructor TNFeINI.Destroy;
begin
  FreeAndNil(FoNFe);
  FreeAndNil(FoXML);
  inherited;
end;

function TNFeINI.getNFe: TSectionNFE;
begin
  if not Assigned(FoNFe) then
    FoNFe := TSectionNFE.Create(FoIni);

  Result := FoNFe;
end;

function TNFeINI.getXML: TSectionXML;
begin
  if not Assigned(FoXML) then
    FoXML := TSectionXML.Create(FoIni);

  Result := FoXML;
end;

function TNFeINI.NomeArquivo: String;
begin
  Result := 'NFe.ini';
end;

end.
