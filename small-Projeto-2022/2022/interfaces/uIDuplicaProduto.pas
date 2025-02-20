unit uIDuplicaProduto;

interface

uses
  DB, IBDatabase;

type
  IDuplicaProduto = interface
  ['{D4B0CC7E-73B2-4117-AECA-D79990F78700}']
  function SetTransaction(AoTransaction: TIBTransaction): IDuplicaProduto;
  function SetDataSetEstoque(AoDataSet: TDataSet): IDuplicaProduto;
  function SetDataSetComposicao(AoDataSet: TDataSet): IDuplicaProduto;
  function SetCodigoProduto(AcCodigoProd: String): IDuplicaProduto;
  function Duplicar: Boolean;
  end;

implementation

end.
