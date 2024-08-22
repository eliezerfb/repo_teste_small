program user;

uses
  Forms,
  user1 in 'user1.pas' {Form1},
  uTestaEmail in '..\..\unit_compartilhada\uTestaEmail.pas',
  uITestaEmail in '..\..\unit_compartilhada\interfaces\uITestaEmail.pas',
  smallfunc_xe in '..\..\unit_compartilhada\smallfunc_xe.pas',
  uConectaBancoSmall in '..\..\unit_compartilhada\uConectaBancoSmall.pas',
  uDialogs in '..\..\unit_compartilhada\uDialogs.pas',
  uconstantes_chaves_privadas in '..\..\..\uconstantes_chaves_privadas.pas',
  uSmallConsts in '..\..\unit_compartilhada\uSmallConsts.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
