program blocox;

uses
  Forms,
  smallfunc in '..\smallfunc.pas',
  ublocox_unit1 in 'ublocox_unit1.pas' {Form1},
  uconstantes_chaves_privadas in '..\..\uconstantes_chaves_privadas.pas',  
  ufuncoesfrente in 'ufuncoesfrente.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
