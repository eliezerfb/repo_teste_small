unit Unit22;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  ComCtrls, ExtCtrls, ShellApi, SmallFunc, OleCtrls, SHDocVw; //, URLMON;

type
  TForm22 = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    RichEdit1: TRichEdit;
    Label6: TLabel;
    Button1: TButton;
    Image3: TImage;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure RichEdit1Enter(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Inicio : TTime;
    iP, iGiro : Integer;
    sTitulo : String;
    sBuild : String;
    sLicenca : String;
    sSerie : String;
    sIniciandoEm : String;
    sUrlDoGdb : String;
    sAtivos : String;

  end;

var
  Form22: TForm22;

implementation

uses Mais, Unit7, uRetornaBuildEXE;

{$R *.DFM}

procedure TForm22.FormCreate(Sender: TObject);
begin
  sBuild := 'Versão e Build: ' + TRetornarBuildEXE.New
                                                  .Retornar;
  iP := 1;
end;

procedure TForm22.FormClick(Sender: TObject);
begin
  Close;
end;

procedure TForm22.FormKeyPress(Sender: TObject; var Key: Char);
begin
  Close;
end;

procedure TForm22.FormActivate(Sender: TObject);
var
  ssAtual : String;
begin
  GetDir(0,ssAtual);
  Image1.Hint := 'Registrado no INPI (Instituto Nacional da Propriedade'
        +Chr(10)+'Industrial) sob número 829288627'
        +Chr(10)+'em nome de ' + RAZAO_SOCIAL_SOFTWARE_HOUSE + ',' ///Smallsoft Tecnologia em Informática Ltda,'
        +Chr(10)+'CNPJ: ' + CNPJ_SMALLSOFT; //07426598000124';

  Image1.ShowHint := True;
end;

procedure TForm22.RichEdit1Enter(Sender: TObject);
begin
  if Form22.Button1.CanFocus then Form22.Button1.SetFocus;
end;

procedure TForm22.Button1Click(Sender: TObject);
begin
  Form22.Close;
end;

procedure TForm22.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Form22.Button1.Visible := False;
end;

procedure TForm22.Image1Click(Sender: TObject);
begin
  if Image1.Tag = 303 then // não encontrei onde seta 303 para Image1.Tag
  begin
    Close;
    Form1.Webbrowser1.Visible := True;
    Form1.WebBrowser1.Align := AlClient;
  end;
end;

end.

