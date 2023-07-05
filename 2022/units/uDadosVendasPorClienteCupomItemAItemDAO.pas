unit uDadosVendasPorClienteCupomItemAItemDAO;

interface

uses
  uIDadosImpressaoDAO, IBDataBase, IBQuery;

type
  TDadosVendasPorClienteCupomItemAItemDAO = class(TInterfacedObject, IDadosImpressaoDAO)
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

{ TDadosVendasPorClienteCupomItemAItemDAO }

function TDadosVendasPorClienteCupomItemAItemDAO.CarregarDados: IDadosImpressaoDAO;
begin
  Result := Self;

  if (not FoQry.IsEmpty) then
    Exit;

  FoQry.Close;
  FoQry.SQL.Clear;
  FoQry.SQL.Add('SELECT');
  FoQry.SQL.Add('    ALTERACA.DATA AS "Data"');
  FoQry.SQL.Add('    , ALTERACA.PEDIDO AS "Número"');
  FoQry.SQL.Add('    , COALESCE(ALTERACA.CLIFOR,'''') AS "Cliente"');
  FoQry.SQL.Add('    , ALTERACA.ITEM AS "Código"');
  FoQry.SQL.Add('    , ALTERACA.DESCRICAO AS "Descrição"');
  FoQry.SQL.Add('    , CAST(ALTERACA.TOTAL AS NUMERIC(18,2)) AS "Total"');
  FoQry.SQL.Add('FROM ALTERACA');
  FoQry.SQL.Add('WHERE');
  FoQry.SQL.Add(FcWhere);
  FoQry.SQL.Add('ORDER BY COALESCE(ALTERACA.CLIFOR,''''), ALTERACA.DATA, ALTERACA.PEDIDO');
  FoQry.Open;
end;

constructor TDadosVendasPorClienteCupomItemAItemDAO.Create;
begin
  FoQry := TIBQuery.Create(nil);
end;

function TDadosVendasPorClienteCupomItemAItemDAO.getDados: TIBQuery;
begin
  Result := FoQry;
end;

class function TDadosVendasPorClienteCupomItemAItemDAO.New: IDadosImpressaoDAO;
begin
  Result := Self.Create;
end;

function TDadosVendasPorClienteCupomItemAItemDAO.setDataBase(AoDataBase: TIBDatabase): IDadosImpressaoDAO;
begin
  Result := Self;

  FoQry.Database := AoDataBase;
end;

function TDadosVendasPorClienteCupomItemAItemDAO.setWhere(AcWhere: string): IDadosImpressaoDAO;
begin
  Result := Self;

  FcWhere := AcWhere;
end;

end.
