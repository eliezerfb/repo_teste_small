program orcamento;

{$R 'smallmanifest.res' 'smallmanifest.rc'}

uses
  Forms,
  Windows,
  Messages,
  SysUtils,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}
var
  Hwnd: THandle;
begin
  //
  Hwnd := FindWindow('TForm1', 'Orçamento');
  //
  // Hwnd := 0;
  //
  if Hwnd = 0 then
  begin
    //
    Application.Initialize;
    Application.Title := 'Orçamento';
    Application.CreateForm(TForm1, Form1);
  Application.Run;
    //
  end else
  begin
    //
    if not IsWindowVisible(Hwnd) then PostMessage(Hwnd, wm_User,0,0);
    SetForegroundWindow(Hwnd);
    //
  end;
end.
