unit uIRetornaImpressaoOrcamento;

interface

uses
  IBDatabase;

type
  IRetornaImpressaoOrcamento = interface
  ['{2D69B68B-7E21-4355-BB8B-3767CE0262CB}']
  function SetDecimais(AnQtde, AnPreco: Integer): IRetornaImpressaoOrcamento;
  function SetTransaction(AoTransaction: TIBTransaction): IRetornaImpressaoOrcamento;
  function SetNumeroOrcamento(AcNumeroOrcamento: String): IRetornaImpressaoOrcamento;
  function CarregaDados: IRetornaImpressaoOrcamento;
  function MontarHTML: IRetornaImpressaoOrcamento;
  function MontarTXT: IRetornaImpressaoOrcamento;
  function RetornarTexto: String;
  end;

implementation

end.
