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
    procedure Timer1Timer(Sender: TObject);
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

uses Mais, Unit7;

{$R *.DFM}

procedure TForm22.FormCreate(Sender: TObject);
var
  Size, Size2: DWord;
  Pt, Pt2: Pointer;
begin
  //
  Size := GetFileVersionInfoSize(PChar (ParamStr (0)), Size2);
  GetMem (Pt, Size);
  GetFileVersionInfo (PChar (ParamStr (0)), 0, Size, Pt);
  VerQueryValue(Pt,'\StringFileInfo\041604E4\FileVersion',Pt2, Size2);
  sBuild := 'Vers�o e Build: ' + PChar (pt2);
  FreeMem (Pt);
  iP := 1;
  //
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
  //
  GetDir(0,ssAtual);
  //
  Image1.Hint := 'Registrado no INPI (Instituto Nacional da Propriedade'
        +Chr(10)+'Industrial) sob n�mero 829288627 em nome de Smallsoft'
        +Chr(10)+'Tecnologia em Inform�tica Ltda, CNPJ: 07426598000124';

  //
  Image1.ShowHint := True;        
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

procedure TForm22.Image1Click(Sender: TObject);
begin
  if Image1.Tag = 303 then
  begin
    Close;
    Form1.Webbrowser1.Visible := True;
    Form1.WebBrowser1.Align := AlClient;
  end;
end;

procedure TForm22.Timer1Timer(Sender: TObject);
begin
{
  //
  if Image3.Left = (Image1.Left+50) then Ip := -1;
  if Image3.Left = (Image1.Left) then Ip := +1;
  //
  Image3.Left := Image3.Left + Ip;
  //
  Image3.Repaint;
  Image1.Repaint;
  //
//  Form22.Button1.Caption := IntToStr(Image3.Left-Image1.Left);
//  Form22.Button1.Repaint;
  //
}  
end;

end.

