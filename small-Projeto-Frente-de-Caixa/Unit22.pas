unit Unit22;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, ShellApi, SmallFunc_xe, Buttons,
  Vcl.Imaging.pngimage
  ;

type
  TForm22 = class(TForm)
    pnlFundo: TPanel;
    pnlCarregamento: TPanel;
    imgFundo: TImage;
    Image1: TImage;
    Image2: TImage;
    lblAguarde: TLabel;
    lblMensagem: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
  private
    FcMensagem: String;
    procedure setMensagem(const Value: String);
    { Private declarations }
  public
    { Public declarations }
    Inicio : TTime;
    iGiro : Integer;
    sTitulo : String;
    sBuild : String;
    //sBuildFormatada: String;
    sLicenca : String;
    sSerie : String;
    sIniciandoEm : String;
    sUrlDoGdb : String;
    sAtivos : String;
    sHoraNoServidor : String;

    property Mensagem: String read FcMensagem write setMensagem;
  end;

var
  Form22: TForm22;

implementation

uses Fiscal, ufuncoesfrente;

{$R *.DFM}

procedure TForm22.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  lblMensagem.Caption := EmptyStr;
  Application.ProcessMessages;
end;

procedure TForm22.FormCreate(Sender: TObject);
var
  iObj: Integer;
begin
  if Aplicacao = nil then
    Aplicacao := TMyApplication.Create(Application);

  lblMensagem.Caption := EmptyStr;

  sBuild := 'Versão e Build: ' + Build;
end;

procedure TForm22.FormResize(Sender: TObject);
begin
  pnlCarregamento.Left    := (Self.Width div 2) - (pnlCarregamento.Width div 2) ;
  pnlCarregamento.Top     := (Self.Height div 2) - (pnlCarregamento.Height div 2);
  pnlCarregamento.Visible := True;
end;

procedure TForm22.setMensagem(const Value: String);
begin
  FcMensagem := Value;

  lblMensagem.Visible := False;
  lblMensagem.Caption := FcMensagem;
  lblMensagem.Visible := True;
  Form22.pnlCarregamento.Visible := True;
  Application.ProcessMessages;
end;

procedure TForm22.FormActivate(Sender: TObject);
var
  ssAtual : String;
begin
  //
  GetDir(0,ssAtual);
  //
  {Sandro Silva 2022-12-02 Início Unochapeco
  Image1.Hint := 'Registrado no INPI (Instituto Nacional da Propriedade'
        +Chr(10)+'Industrial) sob número 829288627 em nome de Smallsoft'
        +Chr(10)+'Tecnologia em Informática EIRELI, CNPJ: 07426598000124';
  }
{  Image1.Hint := 'Registrado no INPI (Instituto Nacional da Propriedade'
        +Chr(10)+'Industrial) sob número 829288627'
        +Chr(10)+'em nome de ' + RAZAO_SOCIAL_SOFTWARE_HOUSE_PAF + ',' ///Smallsoft Tecnologia em Informática Ltda,'
        +Chr(10)+'CNPJ: ' + LimpaNumero(CNPJ_SOFTWARE_HOUSE_PAF);} //07426598000124';
  {Sandro Silva 2022-12-02 Final Unochapeco}
  //
  //
end;

end.

