unit uIImpressaoOrcamento;

interface

uses
  IBDatabase;

type
  IImpressaoOrcamento = interface
  ['{7A535169-E19F-4CD0-BC5B-EB21179D060C}']
  function SetTransaction(AoTransaction: TIBTransaction): IImpressaoOrcamento;
  function SetNumeroOrcamento(AcNumeroOrcamento: String): IImpressaoOrcamento;
  function GetCaminhoImpressao(var AcCaminho: String): IImpressaoOrcamento;
  procedure Imprimir;
  procedure Salvar;
  end;

implementation

end.
