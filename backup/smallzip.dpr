program smallzip;

uses
  Forms,
  windows,
  smallbac in 'smallbac.pas' {Form1},
  Abertura in 'Abertura.pas' {SplashForm},
  FormCoringas in 'FormCoringas.pas' {Form2};

{$R *.RES}

var
   Hwnd: THandle;
begin
  //
  // Hwnd := FindWindow('TForm1','Small Zip');
  //
  hwnd:=0;
  //
  if Hwnd = 0 then
   begin
     SplashForm := TSplashForm.Create(Application);
     SplashForm.Show;
     SplashForm.Update;

     Application.Initialize;
     Application.Title := 'Small Zip';
     Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  SplashForm.Hide;
     SplashForm.Free;
     Application.Run;
   end
  else
   begin
     SetForegroundWindow(Hwnd);
   end;
end.
