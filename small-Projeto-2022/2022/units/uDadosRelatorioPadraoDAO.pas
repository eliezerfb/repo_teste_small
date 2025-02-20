unit uDadosRelatorioPadraoDAO;

interface
uses
  uIDadosImpressaoDAO, DB, IBDatabase;

type
  TDadosRelatorioPadraoDAO = class(TInterfacedObject, IDadosImpressaoDAO)
  private
    FoDataBase: TIBDatabase;
    FoDados: TDataSet;
  public
    class function New: IDadosImpressaoDAO;
    function setDataBase(AoDataBase: TIBDatabase): IDadosImpressaoDAO;
    function getDataBase: TIBDatabase;
    function CarregarDados(AoDataSet: TDataSet): IDadosImpressaoDAO;
    function getDados: TDataSet;
  end;

implementation

uses
  SysUtils;

{ TDadosRelatorioPadraoDAO }

function TDadosRelatorioPadraoDAO.CarregarDados(AoDataSet: TDataSet): IDadosImpressaoDAO;
begin
  Result := Self;

  FoDados := AoDataSet;
end;

function TDadosRelatorioPadraoDAO.getDados: TDataSet;
begin
  Result := FoDados;
end;

function TDadosRelatorioPadraoDAO.getDataBase: TIBDatabase;
begin
  Result := FoDataBase;
end;

class function TDadosRelatorioPadraoDAO.New: IDadosImpressaoDAO;
begin
  Result := Self.Create;
end;

function TDadosRelatorioPadraoDAO.setDataBase(AoDataBase: TIBDatabase): IDadosImpressaoDAO;
begin
  Result := Self;
  
  FoDataBase := AoDataBase;
end;

end.
