unit uRetornaLimiteDisponivel;

interface

uses
  uIRetornaLimiteDisponivel, IBDataBase, IBQuery;

type
  TRetornaLimiteDisponivel = class(TInterfacedObject, IRetornaLimiteDisponivel)
  private
    Fqry: TIBQuery;
    FcCliente: String;
    FnVlrLimite: Currency;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IRetornaLimiteDisponivel;
    function setDataBase(AoDataBase: TIBDataBase): IRetornaLimiteDisponivel;
    function setCliente(AcCliente: String): IRetornaLimiteDisponivel;
    function setLimiteCredito: IRetornaLimiteDisponivel; overload;
    function setLimiteCredito(AnValorCredito: Currency = 0): IRetornaLimiteDisponivel; overload;
    function CarregarDados: IRetornaLimiteDisponivel;
    function RetornarValor: Currency;
    function RetornarValorContasReceber: Currency;
    function TestarLimiteDisponivel: Boolean;
  end;

implementation

uses TypInfo, SysUtils, DB, IBCustomDataSet;

{ TRetornaLimiteDisponivel }

constructor TRetornaLimiteDisponivel.Create;
begin
  Fqry := TIBQuery.Create(nil);
  FnVlrLimite := 0;
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

function TRetornaLimiteDisponivel.CarregarDados: IRetornaLimiteDisponivel;
const
  _cCampoReceber = 'SUM(COALESCE(RECEBER.VALOR_DUPL,0))';
var
  cCredito: String;
begin
  Result := Self;

  cCredito := 'CLIFOR.CREDITO';
  if FnVlrLimite > 0 then
    cCredito := StringReplace(CurrToStr(FnVlrLimite), ',','.', []);

  if FcCliente = EmptyStr then
    Exit;

  Fqry.Close;
  Fqry.SQL.Clear;
  Fqry.SQL.Add('SELECT');
  Fqry.SQL.Add('    ' + _cCampoReceber + ' AS TOTRECEBER');
  Fqry.SQL.Add('    , COUNT(CLIFOR.NOME) AS QTDE');
  Fqry.SQL.Add('    , CAST(COALESCE(' + cCredito + ',0) - '+_cCampoReceber+' AS NUMERIC(18,2)) AS VALOR');
  Fqry.SQL.Add('FROM CLIFOR');
  Fqry.SQL.Add('LEFT JOIN RECEBER');
  Fqry.SQL.Add('    ON (RECEBER.NOME=CLIFOR.NOME)');
  Fqry.SQL.Add('    AND (COALESCE(RECEBER.VALOR_RECE,0) = 0)');
  Fqry.SQL.Add('    AND (COALESCE(RECEBER.ATIVO,0)=0)');
  Fqry.SQL.Add('WHERE');
  Fqry.SQL.Add('(CLIFOR.NOME=:XNOME)');
  if FnVlrLimite = 0 then
    Fqry.SQL.Add('GROUP BY CLIFOR.CREDITO');
  Fqry.ParamByName('XNOME').AsString := FcCliente;
  Fqry.Open;
  Fqry.FetchAll;
end;

function TRetornaLimiteDisponivel.RetornarValor: Currency;
begin
  Result := FnVlrLimite;

  if (not Fqry.IsEmpty) and (Fqry.FieldByName('QTDE').AsInteger > 0) then
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
  Result := FnVlrLimite > 0;
  if not Fqry.IsEmpty then
  begin
    if Fqry.FieldByName('QTDE').AsInteger > 0 then
      Result := Fqry.FieldByName('VALOR').AsCurrency > 0;
  end;
end;

function TRetornaLimiteDisponivel.setLimiteCredito: IRetornaLimiteDisponivel;
var
  qryLim: TIBQuery;
begin
  Result := Self;

  qryLim := TIBQuery.Create(nil);
  try
    qryLim.Close;
    qryLim.Database := Fqry.Database;
    qryLim.SQL.Add('SELECT');
    qryLim.SQL.Add('    CREDITO');
    qryLim.SQL.Add('FROM CLIFOR');
    qryLim.SQL.Add('WHERE');
    qryLim.SQL.Add('(NOME=:XNOME)');
    qryLim.ParamByName('XNOME').AsString := FcCliente;
    qryLim.Open;

    if not qryLim.IsEmpty then
      FnVlrLimite := qryLim.FieldByName('CREDITO').AsCurrency;
  finally
    FreeAndNil(qryLim);
  end;
end;

function TRetornaLimiteDisponivel.setLimiteCredito(AnValorCredito: Currency = 0): IRetornaLimiteDisponivel;
begin
  Result := Self;
  
  FnVlrLimite := AnValorCredito;
end;

function TRetornaLimiteDisponivel.RetornarValorContasReceber: Currency;
begin
  Result := 0;

  if not Fqry.IsEmpty then
    Result := Fqry.Fieldbyname('TOTRECEBER').AsCurrency;
end;

end.
