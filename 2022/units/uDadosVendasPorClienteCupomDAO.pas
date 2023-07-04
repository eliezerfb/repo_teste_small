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
  FoQry.SQL.Add('SELECT');
  FoQry.SQL.Add('    ALTERACA.DATA AS "Data"');
  FoQry.SQL.Add('    , ALTERACA.PEDIDO AS "Número"');
  FoQry.SQL.Add('    , ALTERACA.CLIFOR AS "Cliente"');
  FoQry.SQL.Add('    , CAST(ALTERACA.TOTAL AS NUMERIC(18,2)) AS "Valor"');
  FoQry.SQL.Add('FROM ALTERACA');
  FoQry.SQL.Add('WHERE');
  FoQry.SQL.Add(FcWhere);
  FoQry.SQL.Add('ORDER BY ALTERACA.CLIFOR, ALTERACA.DATA, ALTERACA.PEDIDO');
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
