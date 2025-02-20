unit uIAssinaturaDigital;

interface

type
  IAssinaturaDigital = interface
  ['{FFEF10AC-5C18-4061-A92A-B0FF6A4562A3}']
  function AssinarTexto(AcTexto: String): String;
  function AssinarArquivo(AcCaminhoArquivo: String): String;
  end;

implementation

end.
