unit uIDuplicaNFSe;

interface

uses
  IBX.IBDatabase, Data.DB;

type
  IDuplicaNFSe = interface
  ['{58214692-BF69-4785-9732-0B1B04BE7FCC}']
  function SetTransaction(AoTransaction: TIBTransaction): IDuplicaNFSe;
  function SetNumeroNF(AcNumeroNF: String): IDuplicaNFSe;
  function SetDataSetsNFSe(AoDataSetNFSe, AoDataSetItens: TDataSet): IDuplicaNFSe;
  function Duplicar: Boolean;
  end;

implementation

end.
