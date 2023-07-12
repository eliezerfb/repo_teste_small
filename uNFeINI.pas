unit uNFeINI;

interface

uses
  uArquivoDATINFPadrao, uSectionsNFeINI;

type
  TNFeINI = class(TArquivoDATINFPadrao)
  private
    FoNFe: TSectionNFEINI;
    function getNFe: TSectionNFEINI;
  public
    destructor Destroy; override;

    property NFE: TSectionNFEINI read getNFe;
  protected
    function NomeArquivo: String; override;
  end;

implementation

uses TypInfo, SysUtils, IniFiles;

{ TNFeINI }

destructor TNFeINI.Destroy;
begin
  FreeAndNil(FoNFe);
  inherited;
end;

function TNFeINI.getNFe: TSectionNFEINI;
begin
  if not Assigned(FoNFe) then
    FoNFe := TSectionNFEINI.Create(FoIni);

  Result := FoNFe;
end;

function TNFeINI.NomeArquivo: String;
begin
  Result := 'NFe.ini';
end;

end.
