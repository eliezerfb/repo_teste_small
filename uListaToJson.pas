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
    procedure SetJson(const Value: String);
  protected
  published
    property Itens: TArray<TParametro> read FParametros write FParametros;
    property Json: String read getJson write SetJson;
    function IniToJson(Itens: TStrings): String;
    function GetValorParametro(Parametro: String): String;
    procedure SetValorParametro(Parametro: String; Valor: String);
  public
  end;

implementation

{ TParametros }

function TParametros.getJson: String;
begin
  Result := TJson.ObjectToJsonString(Self);
end;

function TParametros.GetValorParametro(Parametro: String): String;
var
  iItem: Integer;
begin
  Result := '';
  if not(Assigned(Self)) then
    Exit;

  for iItem := 0 to High(FParametros) do
  begin

    if FParametros[iItem].Parametro = Parametro then
    begin
      Result := FParametros[iItem].Valor;
      Exit;
    end;
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
    aParametros[high(aParametros)].Valor     := Itens.ValueFromIndex[iItem];
  end;

  Self.Itens := aParametros;
  Result := Self.getJson;
end;

procedure TParametros.SetJson(const Value: String);
begin
  Self := TJson.JsonToObject<TParametros>(value);
end;

procedure TParametros.SetValorParametro(Parametro, Valor: String);
var
  iItem: Integer;
  bAchou: Boolean;
  aParametro: TParametro;
begin

  bAchou := False;
  for iItem := 0 to High(FParametros) do
  begin

    if FParametros[iItem].Parametro = Parametro then
    begin
      FParametros[iItem].Valor := Valor;
      bAchou := True;
      Break;
    end;
  end;
  if bAchou = False then
  begin
    SetLength(FParametros, Length(FParametros) + 1);
    FParametros[High(FParametros)] := TParametro.Create;
    FParametros[High(FParametros)].Parametro := Parametro;
    FParametros[High(FParametros)].Valor     := Valor;
  end;
  getJson;
end;

end.

