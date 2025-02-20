unit uIInteligenciaArtificial;

interface

uses
  Groq.Consts, uILogIA;

type
  IInteligenciaArtificial = interface
  ['{2644A89E-5832-4C86-AE16-9B47DC9B664D}']
  function setLogIA(AoLogIA: ILogIA): IInteligenciaArtificial;
  function setAPIKey(AcKey: String): IInteligenciaArtificial;
  function setPrompt(AcPrompt: String): IInteligenciaArtificial;
  function setModeloIA(AenVersaoIA: TModels): IInteligenciaArtificial;
  function setTemperatura(AnTemp: Extended): IInteligenciaArtificial;
  function Perguntar(AcTexto: String): IInteligenciaArtificial;
  function Resposta(var AcResp: String): IInteligenciaArtificial;
  end;

implementation

end.
