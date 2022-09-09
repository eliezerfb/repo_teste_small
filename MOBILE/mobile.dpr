program mobile;

uses
  Forms,
  Windows,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

var
  Hwnd: THandle;
begin
  //
  Hwnd := FindWindow('TForm1', 'SMALL MOBILE MONITOR');
  if Hwnd = 0 then
  begin
    Application.Initialize;
    Application.Title := 'SMALL MOBILE MONITOR';
    Application.CreateForm(TForm1, Form1);
    Application.Run;
  end;
  //
end.
