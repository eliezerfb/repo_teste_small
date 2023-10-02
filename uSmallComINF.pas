unit uSmallComINF;

interface

uses
  uArquivoDATINFPadrao, uSectionsSmallComINF;

type
  TSmallComINF = class(TArquivoDATINFPadrao)
  private
    FoUso: TSectionUso;
    FoOutros: TSectionOutros;
    FoOrcamento: TSectionOrcamento;
    function getUso: TSectionUso;
    function getOutros: TSectionOutros;
    function getOrcamento: TSectionOrcamento;
  public
    destructor Destroy; override;

    property Uso: TSectionUso read getUso;
    property Outros: TSectionOutros read getOutros;
    property Orcamento: TSectionOrcamento read getOrcamento;
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
  if Assigned(FoOrcamento) then
    FreeAndNil(FoOrcamento);

  inherited;
end;

function TSmallComINF.getOrcamento: TSectionOrcamento;
begin
  if not Assigned(FoOrcamento) then
    FoOrcamento := TSectionOrcamento.Create(FoIni);

  Result := FoOrcamento;
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
