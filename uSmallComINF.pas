unit uSmallComINF;

interface

uses
  uArquivoDATINFPadrao, uSectionsSmallComINF;

type
  TSmallComINF = class(TArquivoDATINFPadrao)
  private
    FoUso: TSectionUso;
    FoOutros: TSectionOutros;
    function getUso: TSectionUso;
    function getOutros: TSectionOutros;
  public
    destructor Destroy; override;

    property Uso: TSectionUso read getUso;
    property Outros: TSectionOutros read getOutros;
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
  if Assigned(FoOutros) then
    FreeAndNil(FoOutros);

  inherited;
end;

function TSmallComINF.getOutros: TSectionOutros;
begin
  if not Assigned(FoOutros) then
    FoOutros := TSectionOutros.Create(FoIni);

  Result := FoOutros;
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
