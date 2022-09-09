program ExemploProxyNFSe;

uses
  Forms,
  UExemploNFSeV2 in 'UExemploNFSeV2.pas' {frmExemplo};

begin
  Application.Initialize;
  Application.Title := 'Nota Fiscal de Serviços Eletrônica (NFSE)';
  Application.CreateForm(TfrmExemplo, frmExemplo);
  Application.Run;
end.

