unit Unit36;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm36 = class(TForm)
    Memo1: TMemo;
    Label1: TLabel;
    Button1: TButton;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Memo1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form36: TForm36;

implementation

{$R *.dfm}

procedure TForm36.Button1Click(Sender: TObject);
begin
  Form36.Tag := 1;
  Close;
end;

procedure TForm36.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Form36.Tag = 0 then Form36.Memo1.Text := '';
end;

procedure TForm36.Memo1Change(Sender: TObject);
begin
  if Length(Form36.Memo1.Text) >= 30 then
  begin
    Form36.Label2.Caption := 'Caracteres disponíveis '+IntToStr(1000-Length(Form36.Memo1.Text));
  end else
  begin
    Form36.Label2.Caption := 'Faltam '+IntToStr(30-Length(Form36.Memo1.Text))+' caracteres';
  end;
end;

procedure TForm36.FormActivate(Sender: TObject);
begin
  Form36.Tag := 0;
  Form36.Memo1.Text := '';
  form36.Memo1.SetFocus;  
end;

end.
