unit uFrmTelaProcessamento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, vcl.Imaging.GIFImg,
  Vcl.ComCtrls, frxGIFGraphic;

  procedure MostraTelaProcessamento(sTexto:string);
  procedure FechaTelaProcessamento();


type
  TFrmTelaProcessamento = class(TForm)
    Panel1: TPanel;
    lblAguarde: TLabel;
    Panel2: TPanel;
    lblInformacao: TLabel;
    imgGif: TImage;
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
begin
  (imgGif.Picture.Graphic as TGIFImage).Animate := True;
end;


procedure MostraTelaProcessamento(sTexto:string);
begin
  FrmTelaProcessamento := TFrmTelaProcessamento.Create(nil);
  FrmTelaProcessamento.lblInformacao.Caption := sTexto;
  FrmTelaProcessamento.Show;
end;

procedure FechaTelaProcessamento();
begin
  FrmTelaProcessamento.Close;
  FreeAndNil(FrmTelaProcessamento);
end;


end.
