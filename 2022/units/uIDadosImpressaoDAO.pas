unit uIDadosImpressaoDAO;

interface

uses
  IBDatabase, IBQuery;

type
  IDadosImpressaoDAO = interface
  ['{FCAE6F86-B599-4822-8984-CFB85C8552CA}']
  function setDataBase(AoDataBase: TIBDatabase): IDadosImpressaoDAO;
  function setWhere(AcWhere: String): IDadosImpressaoDAO;
  function CarregarDados: IDadosImpressaoDAO;
  function getDados: TIBQuery;
  end;

implementation

end.
