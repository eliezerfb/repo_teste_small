unit uIDadosImpressaoDAO;

interface

uses
  IBDatabase, DB;

type
  IDadosImpressaoDAO = interface
  ['{FCAE6F86-B599-4822-8984-CFB85C8552CA}']
  function setDataBase(AoDataBase: TIBDatabase): IDadosImpressaoDAO;
  function getDataBase: TIBDatabase;
  function CarregarDados(AoDataSet: TDataSet): IDadosImpressaoDAO;
  function getDados: TDataSet;
  end;

implementation

end.
