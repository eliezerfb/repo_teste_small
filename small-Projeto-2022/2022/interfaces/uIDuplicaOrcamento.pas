unit uIDuplicaOrcamento;

interface

uses
  IBDataBase, DB;

type
  IDuplicaOrcamento = interface
  ['{DB55FBB7-D03B-4183-90E3-5AB791D9E01F}']
  function SetTransaction(AoTransaction: TIBTransaction): IDuplicaOrcamento;
  function SetDataSetOrcamento(AoDataSet: TDataSet): IDuplicaOrcamento;
  function SetDataSetOrcamentoOBS(AoDataSet: TDataSet): IDuplicaOrcamento;
  function SetNroOrcamento(AcNroPedido: String): IDuplicaOrcamento;
  function Duplicar: Boolean;
  end;

implementation

end.
