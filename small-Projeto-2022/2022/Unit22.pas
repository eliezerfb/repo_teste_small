unit Unit22;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  ComCtrls, ExtCtrls, ShellApi, smallfunc_xe, OleCtrls, SHDocVw, uSmallConsts,
  Vcl.Imaging.pngimage, Vcl.Imaging.GIFImg; //, URLMON;

type
  TForm22 = class(TForm)
    pnlFundo: TPanel;
    pnlCarregamento: TPanel;
    imgFundo: TImage;
    lblMsgCarregamento: TLabel;
    lblAguarde: TLabel;
    Image1: TImage;
    Image2: TImage;
    redtSobre: TRichEdit;
    imgOK: TImage;
    lblOK: TLabel;
    lblLicenca: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lblOKClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
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
 // Close; Mauricio Parizotto 2024-08-01
end;

procedure TForm22.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //lblAguarde.Visible         := False;
  lblMsgCarregamento.Caption := '';
  lblOK.Visible              := False;
  imgOK.Visible              := False;
  redtSobre.Visible          := False;
  lblLicenca.Visible         := False;
  pnlCarregamento.Visible    := False;
end;

procedure TForm22.FormKeyPress(Sender: TObject; var Key: Char);
begin
//  Close; Mauricio Parizotto 2024-08-01
end;

procedure TForm22.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = VK_ESCAPE then
    Close;
end;

procedure TForm22.lblOKClick(Sender: TObject);
begin
  Close;
end;

procedure TForm22.FormActivate(Sender: TObject);
var
  ssAtual : String;
begin
  GetDir(0,ssAtual);

  { Mauricio Parizotto 2024-04-24

  Image1.Hint := 'Registrado no INPI (Instituto Nacional da Propriedade'
        +Chr(10)+'Industrial) sob número 829288627'
        +Chr(10)+'em nome de ' + RAZAO_SOCIAL_SOFTWARE_HOUSE + ',' ///Smallsoft Tecnologia em Informática Ltda,'
        +Chr(10)+'CNPJ: ' + CNPJ_SMALLSOFT; //07426598000124';

  Image1.ShowHint := True;}
end;

end.

