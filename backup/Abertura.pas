unit Abertura;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Gauges;

type
  TSplashForm = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Gauge1: TGauge;
    Label2: TLabel;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SplashForm: TSplashForm;

implementation

{$R *.DFM}


procedure TSplashForm.FormActivate(Sender: TObject);
var
  sAtual: String;
  I, Z : Integer;
begin
  //
  GetDir(0,sAtual);
  I := Random(12);
  //
  try
    //
    for Z := 0 to StrToInt(Copy(TimetoStr(Time),7,2)) do
    begin
      I := Random(12);
    end;
    //
    if FileExists(sAtual+'\inicial\fundo\_small_'+IntToStr(I)+'.bmp') then
    begin
      Image1.Picture.LoadFromFile(sAtual+'\inicial\fundo\_small_'+IntToStr(I)+'.bmp');
      Image1.Repaint;
    end;
    //
  except end;
  //
end;

end.


