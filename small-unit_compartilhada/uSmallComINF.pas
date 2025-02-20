unit uSmallComINF;

interface

uses
  uArquivoDATINFPadrao, uSectionGeralDAT, uSectionUsoINF;

type
  TSmallComINF = class(TArquivoDATINFPadrao)
  private
    FoUso: TSectionUso;
    function getUso: TSectionUso;
  public
    destructor Destroy; override;

    property Uso: TSectionUso read getUso;
  protected
    function NomeArquivo: String; override;
  end;

implementation

uses SysUtils;

{ TSmallComINF }

destructor TSmallComINF.Destroy;
begin
  if Assigned(FoUso) then
    FreeAndNil(FoUso);

  inherited;
end;

function TSmallComINF.getUso: TSectionUso;
begin
  if not Assigned(FoUso) then
    FoUso := TSectionUso.Create(FoIni);

  Result := FoUso;
end;

function TSmallComINF.NomeArquivo: String;
begin
  Result := 'smallcom.inf';
end;

end.
