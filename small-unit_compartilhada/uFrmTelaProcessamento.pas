unit uFrmTelaProcessamento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, vcl.Imaging.GIFImg,
  Vcl.ComCtrls;

  procedure MostraTelaProcessamento(sTexto:string);
  procedure AtualizaStatusProc(sTexto, sTexto2:string);
  procedure FechaTelaProcessamento();


type
  TFrmTelaProcessamento = class(TForm)
    Panel1: TPanel;
    lblAguarde: TLabel;
    Panel2: TPanel;
    lblInformacao: TLabel;
    imgGif: TImage;
    TimerAtu: TTimer;
    lblInformacao2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure TimerAtuTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    sInformacao, sInformacao2 : string;
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
  FrmTelaProcessamento.sInformacao            := sTexto;
  FrmTelaProcessamento.lblInformacao.Caption  := sTexto;
  FrmTelaProcessamento.lblInformacao2.Caption := '';
  FrmTelaProcessamento.Show;
end;

procedure FechaTelaProcessamento();
begin
  FrmTelaProcessamento.Close;
  FreeAndNil(FrmTelaProcessamento);
end;


procedure TFrmTelaProcessamento.TimerAtuTimer(Sender: TObject);
begin
  lblInformacao.Caption := sInformacao;
  lblInformacao2.Caption := sInformacao2;
  Application.ProcessMessages;
end;


procedure AtualizaStatusProc(sTexto,sTexto2:string);
begin
  if FrmTelaProcessamento <> nil then
  begin
    FrmTelaProcessamento.sInformacao  := sTexto;
    FrmTelaProcessamento.sInformacao2 := sTexto2;
  end;
end;

end.
