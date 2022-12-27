unit Unit22;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, ShellApi, SmallFunc, Buttons
  ;

type
  TForm22 = class(TForm)
    Panel1: TPanel;
    RichEdit1: TRichEdit;
    Label6: TLabel;
    Image2: TImage;
    Button1: TBitBtn;
    Image1: TImage;
    Image5: TImage;
    Image4: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Label6Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure RichEdit1Enter(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
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
  end;

var
  Form22: TForm22;

implementation

uses Fiscal, ufuncoesfrente;

{$R *.DFM}

procedure TForm22.FormCreate(Sender: TObject);
var
  iObj: Integer;
begin
  {Sandro Silva 2021-07-19 inicio}
  if Aplicacao = nil then
    Aplicacao := TMyApplication.Create(Application);

  Image1.Left := ((Self.Width - Image1.Width) div 2) - 5;
  Image1.BringToFront;
  //Panel1.Left := Image1.Left - 120;

  Button1.Left  := (Self.Width - Button1.Width) div 2;

  sBuild := 'Versão e Build: ' + Build;

  {Sandro Silva 2022-04-11 inicio
  if AnsiUpperCase(Copy(BuscaSerialSmall, 4, 1)) = 'I' then
    Image1.Picture.Bitmap := Image5.Picture.Bitmap
  else
    if AnsiUpperCase(Copy(BuscaSerialSmall, 4, 1)) = 'S' then
      Image1.Picture.Bitmap := Image4.Picture.Bitmap;
  }

  //Image1.Visible := True;
  Aplicacao.ImgLogo.Picture.Bitmap := Image1.Picture.Bitmap;
  {Sandro Silva 2021-07-19 fim}


  Self.Color := Image1.Canvas.Pixels[1,1];
  Panel1.ParentBackground := False;
  Panel1.Color := Color;
  RichEdit1.Color := Color;
  //Label2.Caption := Application.Title;

  for iObj := 0 to ComponentCount - 1 do
  begin
    if Components[iObj].ClassType = TLabel then
      TLabel(Components[iObj]).Font.Color := clWhite; // Sandro Silva 2021-07-19 clBlack; // Sandro Silva 2020-07-20  clWhite;
  end;
  Panel1.Font.Color := clWhite;

  WindowState := wsMaximized; // Sandro Silva 2019-08-20
end;

procedure TForm22.FormClick(Sender: TObject);
begin
  Close;
end;

procedure TForm22.FormKeyPress(Sender: TObject; var Key: Char);
begin
  Close;
end;

procedure TForm22.Label6Click(Sender: TObject);
begin
  Image1.Tag := Image1.Tag + 1;
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
  Image1.Hint := 'Registrado no INPI (Instituto Nacional da Propriedade'
        +Chr(10)+'Industrial) sob número 829288627'
        +Chr(10)+'em nome de ' + RAZAO_SOCIAL_SOFTWARE_HOUSE_PAF + ',' ///Smallsoft Tecnologia em Informática Ltda,'
        +Chr(10)+'CNPJ: ' + LimpaNumero(CNPJ_SOFTWARE_HOUSE_PAF); //07426598000124';
  {Sandro Silva 2022-12-02 Final Unochapeco}
  //
  //
end;

procedure TForm22.RichEdit1Enter(Sender: TObject);
begin
  //
  if Form22.Button1.CanFocus then Form22.Button1.SetFocus;
  //
end;

procedure TForm22.Button1Click(Sender: TObject);
begin
  Form22.Close;
end;

procedure TForm22.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Form22.Button1.Visible := False;
end;

procedure TForm22.FormShow(Sender: TObject);
begin
  //Label6.AutoSize := True; // Sandro Silva 2016-09-22
end;

end.

