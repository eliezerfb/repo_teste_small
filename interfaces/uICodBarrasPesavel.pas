unit uICodBarrasPesavel;

interface

uses
  IBDatabase;

type
  ICodBarrasPesavel = interface
  ['{BB937A27-3104-4B90-AAF4-A4ADA2A70626}']
  function setDatabase(AoDatabase: TIBDatabase): ICodBarrasPesavel;
  function setCodigoBarras(AcCodBarras: String): ICodBarrasPesavel;
  function CarregarDados: ICodBarrasPesavel;
  function CalcularValores: ICodBarrasPesavel;
  function RetornarQtde: Real;
  function RetornarPreco: Real;
  end;

implementation

end.
