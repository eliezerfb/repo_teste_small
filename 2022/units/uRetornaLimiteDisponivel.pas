unit uRetornaLimiteDisponivel;

interface

uses
  uIRetornaLimiteDisponivel, IBDataBase, IBQuery;

type
  TRetornaLimiteDisponivel = class(TInterfacedObject, IRetornaLimiteDisponivel)
  private
    Fqry: TIBQuery;
    FcCliente: String;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IRetornaLimiteDisponivel;
    function setDataBase(AoDataBase: TIBDataBase): IRetornaLimiteDisponivel;
    function setCliente(AcCliente: String): IRetornaLimiteDisponivel;
    function CarregarDados(AnValorCredito: Currency = 0): IRetornaLimiteDisponivel;
    function RetornarValor: Currency;
    function TestarLimiteDisponivel: Boolean;
  end;

implementation

uses TypInfo, SysUtils, DB;

{ TRetornaLimiteDisponivel }

constructor TRetornaLimiteDisponivel.Create;
begin
  Fqry := TIBQuery.Create(nil);
end;

destructor TRetornaLimiteDisponivel.Destroy;
begin
  FreeAndNil(Fqry);
  inherited;
end;

class function TRetornaLimiteDisponivel.New: IRetornaLimiteDisponivel;
begin
  Result := Self.Create;
end;

function TRetornaLimiteDisponivel.CarregarDados(AnValorCredito: Currency = 0): IRetornaLimiteDisponivel;
var
  cCredito: String;
begin
  Result := Self;

  if FcCliente = EmptyStr then
    Exit;

  cCredito := 'CLIFOR.CREDITO';
  if AnValorCredito > 0 then
    cCredito := StringReplace(CurrToStr(AnValorCredito), ',','.', []);

  Fqry.Close;
  Fqry.SQL.Clear;
  Fqry.SQL.Add('SELECT');
  Fqry.SQL.Add('    CAST(COALESCE(' + cCredito + ',0) - SUM(COALESCE(RECEBER.VALOR_DUPL,0)) AS NUMERIC(18,2)) AS VALOR');
  Fqry.SQL.Add('FROM CLIFOR');
  Fqry.SQL.Add('LEFT JOIN RECEBER');
  Fqry.SQL.Add('    ON (RECEBER.NOME=CLIFOR.NOME)');
  Fqry.SQL.Add('    AND (COALESCE(RECEBER.VALOR_RECE,0) = 0)');
  Fqry.SQL.Add('WHERE');
  Fqry.SQL.Add('(CLIFOR.NOME=:XNOME)');
  Fqry.SQL.Add('GROUP BY CLIFOR.CREDITO');
  Fqry.ParamByName('XNOME').AsString := FcCliente;
  Fqry.Open;
  Fqry.FetchAll;
end;

function TRetornaLimiteDisponivel.RetornarValor: Currency;
begin
  Result := 0;
  if not Fqry.IsEmpty then
    Result := Fqry.FieldByName('VALOR').AsCurrency;
end;

function TRetornaLimiteDisponivel.setCliente(AcCliente: String): IRetornaLimiteDisponivel;
begin
  Result := Self;

  FcCliente := AcCliente;
end;

function TRetornaLimiteDisponivel.setDataBase(AoDataBase: TIBDataBase): IRetornaLimiteDisponivel;
begin
  Result := Self;

  Fqry.Database := AoDataBase;
end;

function TRetornaLimiteDisponivel.TestarLimiteDisponivel: Boolean;
begin
  Result := True;
  if not Fqry.IsEmpty then
    Result := Fqry.FieldByName('VALOR').AsCurrency > 0;
end;

end.
