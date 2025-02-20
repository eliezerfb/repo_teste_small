unit uILogIA;

interface

type
  TTipoUsuario = (tuUsuario, tuIA);

  ILogIA = interface
  ['{E2816FF8-6B2D-4ACA-AE7A-9B94E7D49CA4}']
  function setNomeUsuario(AcNome: String): ILogIA;
  function setNomeIA(AcNome: String): ILogIA;
  function Salvar(AenTipoUsuario: TTipoUsuario; AcTexto: String): ILogIA;
  end;

implementation

end.
