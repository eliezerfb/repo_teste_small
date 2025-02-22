unit uIRetornaImpressaoOrcamento;

interface

uses
  IBDatabase, System.Classes;

type
  IRetornaImpressaoOrcamento = interface
  ['{2D69B68B-7E21-4355-BB8B-3767CE0262CB}']
  function SetDecimais(AnQtde, AnPreco: Integer): IRetornaImpressaoOrcamento;
  function SetTransaction(AoTransaction: TIBTransaction): IRetornaImpressaoOrcamento;
  function SetNumeroOrcamento(AcNumeroOrcamento: String): IRetornaImpressaoOrcamento;
  function CarregaDados: IRetornaImpressaoOrcamento;
  function MontarHTML: IRetornaImpressaoOrcamento;
  function MontarTXT: IRetornaImpressaoOrcamento;
  function MontarTXT_A5: IRetornaImpressaoOrcamento;
  function RetornarTexto: String;
  function RetornaPaginas: TArray<TStringList>;
  end;

implementation


end.
