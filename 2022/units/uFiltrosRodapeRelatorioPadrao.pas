unit uFiltrosRodapeRelatorioPadrao;

interface

uses
  Classes, uIFiltrosRodapeRelatorio;

type
  TFiltroRodapeRelPadrao = class(TInterfacedObject, IFiltrosRodapeRelatorio)
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

function TFiltroRodapeRelPadrao.AddItem(AcDescricao: String): IFiltrosRodapeRelatorio;
begin
  Result := Self;
  
  FlsItens.Add(AcDescricao);
end;

constructor TFiltroRodapeRelPadrao.Create;
begin
  FlsItens := TStringList.Create;
end;

destructor TFiltroRodapeRelPadrao.Destroy;
begin
  FreeAndNil(FlsItens);
  inherited;
end;

function TFiltroRodapeRelPadrao.getFiltroData: String;
begin
  Result := FcFiltroData;
end;

function TFiltroRodapeRelPadrao.getItens: TStringList;
begin
  Result := FlsItens;
end;

function TFiltroRodapeRelPadrao.getTitulo: String;
begin
  Result := 'Filtros utilizados';
end;

class function TFiltroRodapeRelPadrao.New: IFiltrosRodapeRelatorio;
begin
  Result := Self.Create;
end;

function TFiltroRodapeRelPadrao.setFiltroData(AcFiltro: String): IFiltrosRodapeRelatorio;
begin
  Result := Self;

  FcFiltroData := AcFiltro;
end;

end.
