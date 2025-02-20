unit uFiltrosRodapeRelatorioPadrao;

interface

uses
  Classes, uIFiltrosRodapeRelatorio;

type
  TFiltroRodapeRelPadrao = class(TInterfacedObject, IFiltrosRodapeRelatorio)
  private
    FlsItens: TStringList;
    FcTitulo: String;
    FcFiltroData: String;
    constructor Create;
  public
    destructor Destroy; override;
    class function New: IFiltrosRodapeRelatorio;
    function AddItem(AcDescricao: String): IFiltrosRodapeRelatorio;
    function setFiltroData(AcFiltro: String): IFiltrosRodapeRelatorio;
    function getFiltroData: String;
    function setTitulo(AcTitulo: String): IFiltrosRodapeRelatorio;
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

  FcTitulo := 'Filtros utilizados';
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
  Result := FcTitulo;
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

function TFiltroRodapeRelPadrao.setTitulo(AcTitulo: String): IFiltrosRodapeRelatorio;
begin
  Result := Self;

  FcTitulo := AcTitulo;
end;

end.
