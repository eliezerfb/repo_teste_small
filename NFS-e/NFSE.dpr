program ExemploProxyNFSe;

uses
  Forms,
  UExemploNFSeV2 in 'UExemploNFSeV2.pas' {frmExemplo};

begin
  Application.Initialize;
  Application.Title := 'Nota Fiscal de Servi�os Eletr�nica (NFSE)';
  Application.CreateForm(TfrmExemplo, frmExemplo);
  Application.Run;
end.

