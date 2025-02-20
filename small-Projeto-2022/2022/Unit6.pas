unit Unit6;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Gauges, OleCtrls, SHDocVw;

type
  TForm6 = class(TForm)
    WebBrowser1: TWebBrowser;
    Gauge1: TGauge;
    procedure WebBrowser1ProgressChange(Sender: TObject; Progress,
      ProgressMax: Integer);
    procedure WebBrowser1NavigateComplete2(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure WebBrowser1DocumentComplete(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

{$R *.dfm}

procedure TForm6.WebBrowser1ProgressChange(Sender: TObject; Progress,
  ProgressMax: Integer);
begin
  //
  try
    Form6.Gauge1.Progress := 100 * Progress div ProgressMax;
  except end;
  //
  //  if Form6.Gauge1.Progress >=100 then
  //
end;

procedure TForm6.WebBrowser1NavigateComplete2(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  Form6.Tag := 33;
end;

procedure TForm6.WebBrowser1DocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  Form6.Tag := Form6.Tag + 1;
end;

procedure TForm6.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Form6.Tag := 36;
end;

procedure TForm6.FormActivate(Sender: TObject);
begin
  Form6.WebBrowser1.Navigate('https://www.sefaz.rs.gov.br');
  Form6.WebBrowser1.Update;
  Form6.Gauge1.Progress := 0;
end;

end.
