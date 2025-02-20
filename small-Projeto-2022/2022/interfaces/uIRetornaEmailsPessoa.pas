unit uIRetornaEmailsPessoa;

interface

uses
  IBDatabase;

type
  IRetornarEmailsPessoa = interface
  function setDataBase(AoDataBase: TIBDataBase): IRetornarEmailsPessoa;
  function setTabela(AcTabela: String): IRetornarEmailsPessoa;
  function setCodigoCadastro(AcCodigoCad: String): IRetornarEmailsPessoa;
  function Retornar: String;
  end;

implementation

end.
