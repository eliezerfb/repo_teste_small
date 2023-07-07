unit uFiltrosRodapeRelatorioVendasClienteCupom;

interface

uses
  Classes, uIFiltrosRodapeRelatorio;

type
  TFiltroRodapeRelVendasClienteCupom = class(TInterfacedObject, IFiltrosRodapeRelatorio)
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

{ TFiltroRodapeRelVendasCliente }

function TFiltroRodapeRelVendasClienteCupom.AddItem(AcDescricao: String): IFiltrosRodapeRelatorio;
begin
  Result := Self;
  
  FlsItens.Add(AcDescricao);
end;

constructor TFiltroRodapeRelVendasClienteCupom.Create;
begin
  FlsItens := TStringList.Create;
end;

destructor TFiltroRodapeRelVendasClienteCupom.Destroy;
begin
  if Assigned(FlsItens) then
    FreeAndNil(FlsItens);
  inherited;
end;

function TFiltroRodapeRelVendasClienteCupom.getFiltroData: String;
begin
  Result := FcFiltroData;
end;

function TFiltroRodapeRelVendasClienteCupom.getItens: TStringList;
begin
  Result := FlsItens;
end;

function TFiltroRodapeRelVendasClienteCupom.getTitulo: String;
begin
  Result := EmptyStr;
end;

class function TFiltroRodapeRelVendasClienteCupom.New: IFiltrosRodapeRelatorio;
begin
  Result := Self.Create;
end;

function TFiltroRodapeRelVendasClienteCupom.setFiltroData(AcFiltro: String): IFiltrosRodapeRelatorio;
begin
  Result := Self;

  FcFiltroData := AcFiltro;
end;
end.
