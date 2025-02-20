unit uIRetornaCustoMedio;

interface

uses
  IBX.IBDatabase;

type
  IRetornaCustoMedio = interface
  ['{E1F80C41-0D01-4EB2-B87E-16A78841CD54}']
  function setCodigo(AcCodigo: String): IRetornaCustoMedio;
  function setDecimaisCusto(AnDecimais: Integer): IRetornaCustoMedio;
  function setTransaction(AoTransaction: TIBTransaction): IRetornaCustoMedio;
  function ConsultaDados: IRetornaCustoMedio;
  function CustoMedio: Double;
  end;

implementation

end.
