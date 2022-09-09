program Instalar;

{$R 'smallmanifest.res' 'smallmanifest.rc'}

uses
  Forms,
  Instal in 'INSTAL.PAS' {Form1};

{$R *.RES}

begin
  try
    Application.CreateForm(TForm1, Form1);
    Application.Run;
  except end;
end.
