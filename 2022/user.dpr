program user;

uses
  Forms,
  user1 in 'user1.pas' {Form1},
  uTestaEmail in '..\..\unit_compartilhada\uTestaEmail.pas',
  uITestaEmail in '..\..\unit_compartilhada\interfaces\uITestaEmail.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
