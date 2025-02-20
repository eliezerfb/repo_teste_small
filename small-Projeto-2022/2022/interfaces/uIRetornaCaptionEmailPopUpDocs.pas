unit uIRetornaCaptionEmailPopUpDocs;

interface

uses
  IBDatabase;

type
  IRetornaCaptionEmailPopUpDocs = interface
  ['{FA64ABF7-9CA7-4E18-8E3D-0A3DF9CDECD3}']
  function setDataBase(AoDataBase: TIBDataBase): IRetornaCaptionEmailPopUpDocs;
  function setCodigoClifor(AcCodigoCad: String): IRetornaCaptionEmailPopUpDocs;
  function setCodigoTranspor(AcCodigoCad: String): IRetornaCaptionEmailPopUpDocs;
  function Retornar: String;
  end;

implementation

end.
