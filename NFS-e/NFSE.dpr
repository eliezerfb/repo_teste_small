program NFSE;

{$R 'smallmanifest.res' 'smallmanifest.rc'}

uses
  Forms,
  uemissornfse in 'uemissornfse.pas' {FEmissorNFSe},
  uconstantes_chaves_privadas in '..\..\..\uconstantes_chaves_privadas.pas',
  ucredencialtecnospeed in '..\..\..\componentes\Smallsoft\ucredencialtecnospeed.pas',
  uconfiguracaonfse in 'uconfiguracaonfse.pas' {FConfiguracaoNFSe};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Nota Fiscal de Serviços Eletrônica (NFSE)';
  Application.CreateForm(TFEmissorNFSe, FEmissorNFSe);
  Application.Run;
end.