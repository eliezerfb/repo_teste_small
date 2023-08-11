unit uFiltrosRodapeRelatorioCatalogoProdutos;

interface

uses
  Classes, uIFiltrosRodapeRelatorio;

type
  TFiltroRodapeRelCatalogoProdutos = class(TInterfacedObject, IFiltrosRodapeRelatorio)
  private
    FlsItens: TStringList;
    FcFiltroData: String;
    constructor Create;
  public
    destructor Destroy; override;
    class function New: IFiltrosRodapeRelatorio;
    function AddItem(AcDescricao: String): IFiltrosRodapeRelatorio;
    function setFiltroData(AcFiltro: String): IFiltrosRodapeRelatorio;
    function getFiltroData: String;
    function getTitulo: String;
    function getItens: TStringList;
  end;

implementation

uses SysUtils;

{ TFiltroRodapeRelCatalogoProdutos }

function TFiltroRodapeRelCatalogoProdutos.AddItem(AcDescricao: String): IFiltrosRodapeRelatorio;
begin
  Result := Self;
  
  FlsItens.Add(AcDescricao);
end;

constructor TFiltroRodapeRelCatalogoProdutos.Create;
begin
  FlsItens := TStringList.Create;
end;

destructor TFiltroRodapeRelCatalogoProdutos.Destroy;
begin
  FreeAndNil(FlsItens);
  inherited;
end;

function TFiltroRodapeRelCatalogoProdutos.getFiltroData: String;
begin
  Result := FcFiltroData;
end;

function TFiltroRodapeRelCatalogoProdutos.getItens: TStringList;
begin
  Result := FlsItens;
end;

function TFiltroRodapeRelCatalogoProdutos.getTitulo: String;
begin
  Result := EmptyStr;
end;

class function TFiltroRodapeRelCatalogoProdutos.New: IFiltrosRodapeRelatorio;
begin
  Result := Self.Create;
end;

function TFiltroRodapeRelCatalogoProdutos.setFiltroData(AcFiltro: String): IFiltrosRodapeRelatorio;
begin
  Result := Self;

  FcFiltroData := AcFiltro;
end;

end.
