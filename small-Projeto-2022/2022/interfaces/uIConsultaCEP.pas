unit uIConsultaCEP;

interface

uses
  uObjetoConsultaCEP;

type
  IConsultaCEP = interface
  ['{F7F4F2E6-35B1-40C3-A4E9-F227CF055EA2}']
  function setTimeOut(AnMileseg: Integer = 10000): IConsultaCEP;
  function setCEP(AcCEP: String): IConsultaCEP;
  function SolicitarDados: IConsultaCEP;
  function getObjeto: TObjetoConsultaCEP;
  end;

implementation

end.
