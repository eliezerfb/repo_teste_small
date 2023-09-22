unit uIXMLDocsEletronicos;

interface

uses
  IBDataBase;

type
  IXMLDocsEletronicos = interface
  ['{4F0F170E-E2EC-464F-A45E-4F00928A319C}']
  function setTransaction(AoTransaction: TIBTransaction): IXMLDocsEletronicos;
  function setDatas(AdDataIni, AdDataFim: TDateTime): IXMLDocsEletronicos;
  function setCNPJ(AcCNPJ: String): IXMLDocsEletronicos;
  function Salvar: IXMLDocsEletronicos;
  function Compactar: IXMLDocsEletronicos;
  function getCaminhoArquivos: String;  
  end;

implementation

end.
