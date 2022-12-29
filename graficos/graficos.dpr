program graficos;

uses
  Forms,
  Grafico in 'Grafico.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Small Gráficos';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
