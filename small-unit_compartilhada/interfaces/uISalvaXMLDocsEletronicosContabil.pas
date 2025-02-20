unit uISalvaXMLDocsEletronicosContabil;

interface

uses
  IBDataBase, DB;

type
  ISalvaXMLDocsEletronicosContabil = interface
  ['{2C277539-F573-4627-BD3D-7242C0770C85}']
  function setTransaction(AoTransaction: TIBTransaction): ISalvaXMLDocsEletronicosContabil;
  function setDatas(AdDataIni, AdDataFim: TDateTime): ISalvaXMLDocsEletronicosContabil;
  function setDataSet(AoDataSet: TDataSet): ISalvaXMLDocsEletronicosContabil;
  function setCNPJ(AcCNPJ: String): ISalvaXMLDocsEletronicosContabil;
  function Salvar: ISalvaXMLDocsEletronicosContabil;
  function Compactar: ISalvaXMLDocsEletronicosContabil;
  function getCaminhoArquivos: String;  
  end;

implementation

end.
