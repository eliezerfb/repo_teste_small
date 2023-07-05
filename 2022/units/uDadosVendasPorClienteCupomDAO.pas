unit uDadosVendasPorClienteCupomDAO;

interface

uses
  uIDadosImpressaoDAO, IBDataBase, IBQuery;

type
  TDadosVendasPorClienteCupomDAO = class(TInterfacedObject, IDadosImpressaoDAO)
  private
    FoQry: TIBQuery;
    FcWhere: string;
    constructor Create;
  public
    class function New: IDadosImpressaoDAO;
    function setDataBase(AoDataBase: TIBDatabase): IDadosImpressaoDAO;
    function setWhere(AcWhere: string): IDadosImpressaoDAO;
    function CarregarDados: IDadosImpressaoDAO;
    function getDados: TIBQuery;
  end;

implementation

uses
  SysUtils;

{ TDadosVendasPorClienteCupomDAO }

function TDadosVendasPorClienteCupomDAO.CarregarDados: IDadosImpressaoDAO;
begin
  Result := Self;

  if (not FoQry.IsEmpty) then
    Exit;

  FoQry.Close;
  FoQry.SQL.Clear;
  FoQry.SQL.Add('WITH DADOSAGRUPADOS AS(');
  FoQry.SQL.Add('SELECT');
  FoQry.SQL.Add('    ALTERACA.PEDIDO');
  FoQry.SQL.Add('    , COALESCE(ALTERACA.CLIFOR,'''') AS CLIFOR');
  FoQry.SQL.Add('    , CAST(SUM(ALTERACA.TOTAL) AS NUMERIC(18,2)) AS VALOR');
  FoQry.SQL.Add('FROM ALTERACA');
  FoQry.SQL.Add('WHERE');
  FoQry.SQL.Add(FcWhere);
  FoQry.SQL.Add('GROUP BY ALTERACA.PEDIDO, COALESCE(ALTERACA.CLIFOR,'''')');
  FoQry.SQL.Add(')');
  FoQry.SQL.Add('SELECT');
  FoQry.SQL.Add('    MIN(ALTERACA.DATA) AS "Data"');
  FoQry.SQL.Add('    , ALTERACA.PEDIDO AS "Número"');
  FoQry.SQL.Add('    , ALTERACA.CLIFOR AS "Cliente"');
  FoQry.SQL.Add('    , DADOSAGRUPADOS.VALOR AS "Valor"');
  FoQry.SQL.Add('FROM ALTERACA');
  FoQry.SQL.Add('INNER JOIN DADOSAGRUPADOS');
  FoQry.SQL.Add('    ON (DADOSAGRUPADOS.PEDIDO=ALTERACA.PEDIDO)');
  FoQry.SQL.Add('    AND (DADOSAGRUPADOS.CLIFOR=COALESCE(ALTERACA.CLIFOR,''''))');
  FoQry.SQL.Add('WHERE');
  FoQry.SQL.Add(FcWhere);
  FoQry.SQL.Add('GROUP BY ALTERACA.PEDIDO, ALTERACA.CLIFOR, DADOSAGRUPADOS.VALOR');
  FoQry.SQL.Add('ORDER BY ALTERACA.CLIFOR, ALTERACA.PEDIDO, MIN(ALTERACA.DATA)');
  FoQry.Open;
end;

constructor TDadosVendasPorClienteCupomDAO.Create;
begin
  FoQry := TIBQuery.Create(nil);
end;

function TDadosVendasPorClienteCupomDAO.getDados: TIBQuery;
begin
  Result := FoQry;
end;

class function TDadosVendasPorClienteCupomDAO.New: IDadosImpressaoDAO;
begin
  Result := Self.Create;
end;

function TDadosVendasPorClienteCupomDAO.setDataBase(AoDataBase: TIBDatabase): IDadosImpressaoDAO;
begin
  Result := Self;

  FoQry.Database := AoDataBase;
end;

function TDadosVendasPorClienteCupomDAO.setWhere(AcWhere: string): IDadosImpressaoDAO;
begin
  Result := Self;

  FcWhere := AcWhere;
end;

end.
