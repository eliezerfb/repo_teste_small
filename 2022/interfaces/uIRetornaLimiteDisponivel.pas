unit uIRetornaLimiteDisponivel;

interface

uses
  IBDatabase;

type
  IRetornaLimiteDisponivel = interface
  ['{F44A7887-670D-404C-BF1D-54102717C35A}']
  function setDataBase(AoDataBase: TIBDataBase): IRetornaLimiteDisponivel;
  function setCliente(AcCliente: String): IRetornaLimiteDisponivel;
  function setLimiteCredito: IRetornaLimiteDisponivel; overload;
  function setLimiteCredito(AnValorCredito: Currency = 0): IRetornaLimiteDisponivel; overload;
  function RetornarValor: Currency;
  function TestarLimiteDisponivel: Boolean;
  function CarregarDados: IRetornaLimiteDisponivel;
  end;

implementation

end.
