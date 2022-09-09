program prLeBal;

uses
  Forms,
  untPrincipal in 'untPrincipal.pas' {frmPrincipal};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Filizola - Programa de Leitura de Balança / Delphi 5';
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
