program NFSE;

{$R 'smallmanifest.res' 'smallmanifest.rc'}

uses
  Forms,
  uemissornfse in 'uemissornfse.pas' {FEmissorNFSe},
  uconstantes_chaves_privadas in '..\..\..\uconstantes_chaves_privadas.pas',
  ucredencialtecnospeed in '..\..\..\componentes\Smallsoft\ucredencialtecnospeed.pas',
  uconfiguracaonfse in 'uconfiguracaonfse.pas' {FConfiguracaoNFSe},
  SmallFunc in '..\2022\SmallFunc.pas',
  uTestaEmail in '..\..\unit_compartilhada\uTestaEmail.pas',
  uITestaEmail in '..\..\unit_compartilhada\interfaces\uITestaEmail.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Nota Fiscal de Serviços Eletrônica (NFSE)';
  Application.CreateForm(TFEmissorNFSe, FEmissorNFSe);
  Application.Run;
end.