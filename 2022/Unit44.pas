unit Unit44;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TForm44 = class(TForm)
    Timer2: TTimer;
    procedure Timer2Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form44: TForm44;

implementation

{$R *.dfm}

procedure TForm44.Timer2Timer(Sender: TObject);
begin
   if Form44.AlphaBlendValue < 255 then Form44.AlphaBlendValue := Form44.AlphaBlendValue + 1;

end;

procedure TForm44.FormShow(Sender: TObject);
begin
  Form44.AlphaBlend      := True;
  Form44.AlphaBlendValue := 0;
end;

procedure TForm44.FormClick(Sender: TObject);
begin
  Close;
end;

end.
