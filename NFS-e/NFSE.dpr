program NFSE;

{$R 'smallmanifest.res' 'smallmanifest.rc'}

uses
  Forms,
  uemissornfse in 'uemissornfse.pas' {FEmissorNFSe};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Nota Fiscal de Servi�os Eletr�nica (NFSE)';
  Application.CreateForm(TFEmissorNFSe, FEmissorNFSe);
  Application.Run;
end.