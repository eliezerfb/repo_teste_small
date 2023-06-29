unit uDadosVendasPorClienteNotaItemAItemDAO;

interface

uses
  uIDadosImpressaoDAO, IBDataBase, IBQuery;

type
  TDadosVendasPorClienteNotaItemAItemDAO = class(TInterfacedObject, IDadosImpressaoDAO)
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

{ TDadosImpVendasClienteItemAItemDAO }

function TDadosVendasPorClienteNotaItemAItemDAO.CarregarDados: IDadosImpressaoDAO;
begin
  Result := Self;

  if (not FoQry.IsEmpty) then
    Exit;

  FoQry.Close;
  FoQry.SQL.Clear;
  FoQry.SQL.Add('SELECT');
  FoQry.SQL.Add('    VENDAS.EMISSAO AS "Data"');
  FoQry.SQL.Add('    , VENDAS.NUMERONF AS "Número da NF"');
  FoQry.SQL.Add('    , VENDAS.CLIENTE AS "Cliente"');
  FoQry.SQL.Add('    , ITENS001.CODIGO || '' - '' || ITENS001.DESCRICAO AS "Produto"');
  FoQry.SQL.Add('    , CAST(ITENS001.TOTAL AS NUMERIC(18,2)) AS "Valor"');
  FoQry.SQL.Add('FROM VENDAS');
  FoQry.SQL.Add('INNER JOIN ITENS001');
  FoQry.SQL.Add('    ON (ITENS001.NUMERONF=VENDAS.NUMERONF)');
  FoQry.SQL.Add('WHERE');
  FoQry.SQL.Add(FcWhere);
  FoQry.SQL.Add('ORDER BY VENDAS.CLIENTE, VENDAS.EMISSAO, VENDAS.NUMERONF');
  FoQry.Open;
end;

constructor TDadosVendasPorClienteNotaItemAItemDAO.Create;
begin
  FoQry := TIBQuery.Create(nil);
end;

function TDadosVendasPorClienteNotaItemAItemDAO.getDados: TIBQuery;
begin
  Result := FoQry;
end;

class function TDadosVendasPorClienteNotaItemAItemDAO.New: IDadosImpressaoDAO;
begin
  Result := Self.Create;
end;

function TDadosVendasPorClienteNotaItemAItemDAO.setDataBase(AoDataBase: TIBDatabase): IDadosImpressaoDAO;
begin
  Result := Self;

  FoQry.Database := AoDataBase;
end;

function TDadosVendasPorClienteNotaItemAItemDAO.setWhere(AcWhere: string): IDadosImpressaoDAO;
begin
  Result := Self;

  FcWhere := AcWhere;
end;

end.

