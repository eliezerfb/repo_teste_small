unit uITestaProdutoExiste;

interface

uses
  IBDatabase, IBQuery;

type
  ITestaProdutoExiste = interface
  ['{CFC9E70A-4104-4D8E-8705-84206170B2FE}']
  function setDataBase(AoDataBase: TIBDataBase): ITestaProdutoExiste;
  function setTextoPesquisar(AcTexto: String): ITestaProdutoExiste;
  function getQuery: TIBQuery;
  function Testar: Boolean;
  end;

implementation

end.
