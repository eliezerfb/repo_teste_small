program firebird;

uses
  Forms,
  converso_firebird in 'converso_firebird.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Assistente de configura��o do GDB';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
