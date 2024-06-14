unit uFrmTelaProcessamento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, vcl.Imaging.GIFImg,
  frxGIFGraphic, Vcl.ComCtrls;

  procedure MostraTelaProcessamento();
  procedure FechaTelaProcessamento();


type
  TFrmTelaProcessamento = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Panel2: TPanel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmTelaProcessamento: TFrmTelaProcessamento;

implementation

{$R *.dfm}

procedure TFrmTelaProcessamento.FormCreate(Sender: TObject);
  var
    aGIF:TGIFImage;
begin
  try
    image1.Picture.SaveToFile(ExtractFilePath(Application.ExeName)+'loading.gif');
    aGIF := TGIFImage.Create;
    aGIF.LoadFromFile(ExtractFilePath(Application.ExeName)+'loading.gif');
    aGIF.Animate := true;
    image1.Picture.Graphic := aGIF;
    FreeAndNil(aGIF);
  except
  end;
end;


procedure MostraTelaProcessamento();
begin
  FrmTelaProcessamento := TFrmTelaProcessamento.Create(nil);
  FrmTelaProcessamento.Show;
end;

procedure FechaTelaProcessamento();
begin
  FrmTelaProcessamento.Close;
  FreeAndNil(FrmTelaProcessamento);
end;


end.
