unit uEstoqueDAT;

interface

uses
  uArquivoDATINFPadrao, uSectionGeralDAT;

type
  TEstoqueDAT = class(TArquivoDATINFPadrao)
  private
    FoGeral: TSectionGeral;
    function getGeral: TSectionGeral;
  public
    destructor Destroy; override;
    property Geral: TSectionGeral read getGeral;
  protected
    function NomeArquivo: String; override;  
  end;

implementation

uses SysUtils;

{ TEstoqueDAT }

destructor TEstoqueDAT.Destroy;
begin
  if Assigned(FoGeral) then
    FreeAndNil(FoGeral);

  inherited;
end;

function TEstoqueDAT.getGeral: TSectionGeral;
begin
  if not Assigned(FoGeral) then
    FoGeral := TSectionGeral.Create(FoIni);

  Result := FoGeral;
end;

function TEstoqueDAT.NomeArquivo: String;
begin
  Result := 'EST0QUE.DAT';
end;

end.
