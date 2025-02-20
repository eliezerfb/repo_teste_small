unit uDadosEmitente;

interface

uses
  uIDadosEmitente, IBDataBase, IbQuery;

type
  TDadosEmitente = class(TInterfacedObject, IDadosEmitente)
  private
    FQryDados: TIBQuery;
    constructor Create;
  public
    destructor Destroy; override;
    class function New: IDadosEmitente;
    function setDataBase(AoDataBase: TIBDatabase): IDadosEmitente;
    function getQuery: TIBQuery;
  end;

implementation

uses SysUtils;

{ TDadosEmitente }

constructor TDadosEmitente.Create;
begin
  FQryDados := TIBQuery.Create(nil);
end;

destructor TDadosEmitente.Destroy;
begin
  FreeAndNil(FQryDados);
  inherited;
end;

function TDadosEmitente.getQuery: TIBQuery;
begin
  Result := FQryDados;

  FQryDados.Close;
  FQryDados.SQL.Clear;
  FQryDados.SQL.Add('SELECT FIRST 1 * FROM EMITENTE');
  FQryDados.Open;
end;

class function TDadosEmitente.New: IDadosEmitente;
begin
  Result := Self.Create;
end;

function TDadosEmitente.setDataBase(AoDataBase: TIBDatabase): IDadosEmitente;
begin
  Result := Self;
  
  FQryDados.Database := AoDataBase;
end;

end.
