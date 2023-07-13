unit uNFSeINI;

interface

uses
  uArquivoDATINFPadrao, uSectionsNFSeINI;

type
  TNFSeINI = class(TArquivoDATINFPadrao)
  private
    FoNFSe: TSectionNFSEINI;
    function getNFSe: TSectionNFSEINI;
  public
    destructor Destroy; override;

    property NFSE: TSectionNFSEINI read getNFSe;
  protected
    function NomeArquivo: String; override;
  end;

implementation

uses TypInfo, SysUtils, IniFiles;

{ TNFSeINI }

destructor TNFSeINI.Destroy;
begin
  FreeAndNil(FoNFSe);
  inherited;
end;

function TNFSeINI.getNFSe: TSectionNFSEINI;
begin
  if not Assigned(FoNFSe) then
    FoNFSe := TSectionNFSEINI.Create(FoIni);

  Result := FoNFSe;
end;

function TNFSeINI.NomeArquivo: String;
begin
  Result := 'nfseConfig.ini';
end;

end.
