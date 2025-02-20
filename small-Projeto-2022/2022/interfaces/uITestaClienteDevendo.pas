unit uITestaClienteDevendo;

interface

uses
  IBDatabase, Graphics;

type
  ITestaClienteDevendo = interface
  ['{8E119824-8E51-4017-A77F-CCE27A6580DE}']
  function setDataBase(AoDataBase: TIBDatabase): ITestaClienteDevendo;
  function setCliente(AcCliente: String): ITestaClienteDevendo;
  function CarregarDados: ITestaClienteDevendo;
  function TestarClienteDevendo: Boolean;
  function RetornarCor: TColor;
  end;

implementation

end.
