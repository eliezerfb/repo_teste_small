unit uFiltrosRodapeRelatorioVendasClienteNota;

interface

uses
  Classes, uIFiltrosRodapeRelatorio;

type
  TFiltroRodapeRelVendasClienteNota = class(TInterfacedObject, IFiltrosRodapeRelatorio)
  private
    FlsItens: TStringList;
    FcFiltroData: String;
    constructor Create;
  public
    destructor Destroy; override;
    class function New: IFiltrosRodapeRelatorio;
    function AddItem(AcDescricao: String): IFiltrosRodapeRelatorio;
    function setFiltroData(AcFiltro: String): IFiltrosRodapeRelatorio;
    function setTitulo(AcTitulo: String): IFiltrosRodapeRelatorio;
    function getFiltroData: String;
    function getTitulo: String;
    function getItens: TStringList;
  end;

implementation

uses SysUtils;

{ TFiltroRodapeRelVendasCliente }

function TFiltroRodapeRelVendasClienteNota.AddItem(AcDescricao: String): IFiltrosRodapeRelatorio;
begin
  Result := Self;
  
  FlsItens.Add(AcDescricao);
end;

constructor TFiltroRodapeRelVendasClienteNota.Create;
begin
  FlsItens := TStringList.Create;
end;

destructor TFiltroRodapeRelVendasClienteNota.Destroy;
begin
  FreeAndNil(FlsItens);
  inherited;
end;

function TFiltroRodapeRelVendasClienteNota.getFiltroData: String;
begin
  Result := FcFiltroData;
end;

function TFiltroRodapeRelVendasClienteNota.getItens: TStringList;
begin
  Result := FlsItens;
end;

function TFiltroRodapeRelVendasClienteNota.getTitulo: String;
begin
  Result := 'Opera��es listadas:';
end;

class function TFiltroRodapeRelVendasClienteNota.New: IFiltrosRodapeRelatorio;
begin
  Result := Self.Create;
end;

function TFiltroRodapeRelVendasClienteNota.setFiltroData(AcFiltro: String): IFiltrosRodapeRelatorio;
begin
  Result := Self;

  FcFiltroData := AcFiltro;
end;

function TFiltroRodapeRelVendasClienteNota.setTitulo(AcTitulo: String): IFiltrosRodapeRelatorio;
begin
  Result := Self;
end;

end.
