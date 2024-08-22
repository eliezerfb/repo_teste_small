unit uListaToJson;

interface

uses
  System.Classes, System.Generics.Collections, REST.Json.Types, REST.Json;

{$M+}

type
  TParametro = class
  private
    FParametro: string;
    FValor: string;
  published
    property Parametro: string read FParametro write FParametro;
    property Valor: string read FValor write FValor;
  end;

  TParametros = class
  private
    [JSONName('parametros')]
    FParametros: TArray<TParametro>;
    function getJson: String;
  protected
  published
    property Itens: TArray<TParametro> read FParametros write FParametros;
    property Json: String read getJson;
    function IniToJson(Itens: TStrings): String;
    function GetValor(Parametro: String): String;
    procedure SetValor(Parametro: String; Valor: String);
  public
  end;

implementation

{ TParametros }

function TParametros.getJson: String;
begin
  Result := TJson.ObjectToJsonString(Self);
end;

function TParametros.GetValor(Parametro: String): String;
var
  iItem: Integer;
begin

  for iItem := 0 to High(FParametros) do
  begin

    if FParametros[iItem].Parametro = Parametro then
      Result := FParametros[iItem].Valor;
  end;

end;

function TParametros.IniToJson(Itens: TStrings): String;
var
  aParametros: TArray<TParametro>;
  iItem: Integer;
begin

  SetLength(aParametros, 0);
  for iItem := 0 to Itens.Count -1 do
  begin
    SetLength(aParametros, Length(aParametros) + 1);
    aParametros[high(aParametros)] := TParametro.Create;
    aParametros[high(aParametros)].Parametro := Itens.KeyNames[iItem];
    aParametros[high(aParametros)].Valor := Itens.ValueFromIndex[iItem];
  end;

  Self.Itens := aParametros;
  Result := TJson.ObjectToJsonString(Self);

end;

procedure TParametros.SetValor(Parametro, Valor: String);
var
  iItem: Integer;
begin

  for iItem := 0 to High(FParametros) do
  begin

    if FParametros[iItem].Parametro = Parametro then
      FParametros[iItem].Valor := Valor;
  end;

end;

end.

