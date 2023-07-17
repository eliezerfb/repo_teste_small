unit uDadosVendasPorClienteNotaDAO;

interface

uses
  uIDadosImpressaoDAO, IBDataBase, IBQuery;

type
  TDadosVendasPorClienteNotaDAO = class(TInterfacedObject, IDadosImpressaoDAO)
  private
    FoQry: TIBQuery;
    FcWhere: String;
    constructor Create;
  public
    destructor Destroy; override;
    class function New: IDadosImpressaoDAO;
    function setDataBase(AoDataBase: TIBDatabase): IDadosImpressaoDAO;
    function setWhere(AcWhere: String): IDadosImpressaoDAO;
    function CarregarDados: IDadosImpressaoDAO;
    function getDados: TIBQuery;
  end;

implementation

uses SysUtils;

{ TDadosVendasPorClienteNotaDAO }

function TDadosVendasPorClienteNotaDAO.CarregarDados: IDadosImpressaoDAO;
begin
  Result := Self;
  
  if (not FoQry.IsEmpty) then
    Exit;

  FoQry.Close;
  FoQry.SQL.Clear;
  FoQry.SQL.Add('SELECT');
  FoQry.SQL.Add('    VENDAS.EMISSAO AS "Data"');
  FoQry.SQL.Add('    , SUBSTRING(VENDAS.NUMERONF FROM 1 FOR 9) ||''/''||SUBSTRING(VENDAS.NUMERONF FROM 10 FOR 3) AS "Número da NF"');
  FoQry.SQL.Add('    , VENDAS.CLIENTE AS "Cliente"');
  FoQry.SQL.Add('    , CAST(VENDAS.TOTAL AS NUMERIC(18,2)) AS "Total"');
  FoQry.SQL.Add('FROM VENDAS');
  FoQry.SQL.Add('WHERE');
  FoQry.SQL.Add(FcWhere);
  FoQry.SQL.Add('ORDER BY VENDAS.CLIENTE, VENDAS.EMISSAO, VENDAS.NUMERONF');
  FoQry.Open;
end;

constructor TDadosVendasPorClienteNotaDAO.Create;
begin
  FoQry := TIBQuery.Create(nil);
end;

destructor TDadosVendasPorClienteNotaDAO.Destroy;
begin
  inherited;
end;

function TDadosVendasPorClienteNotaDAO.getDados: TIBQuery;
begin
  Result := FoQry;
end;

class function TDadosVendasPorClienteNotaDAO.New: IDadosImpressaoDAO;
begin
  Result := Self.Create;
end;

function TDadosVendasPorClienteNotaDAO.setDataBase(AoDataBase: TIBDatabase): IDadosImpressaoDAO;
begin
  Result := Self;
  
  FoQry.Database := AoDataBase;
end;

function TDadosVendasPorClienteNotaDAO.setWhere(AcWhere: String): IDadosImpressaoDAO;
begin
  Result := Self;

  FcWhere := AcWhere;
end;

end.
