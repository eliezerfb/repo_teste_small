unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, IniFiles;

type
  TForm5 = class(TForm)
    Image1: TImage;
    Label2: TLabel;
    USUARIO: TEdit;
    SENHA: TEdit;
    Button2: TButton;
    Button1: TButton;
    Label5: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

uses fiscal;

{$R *.DFM}

procedure TForm5.Button1Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
  sSenha  : String;
  sSenhaX : String;
  I : Integer;
  sAtual : String;
begin
  Getdir(0,sAtual);
  Mais1ini := TIniFile.Create(sAtual+'\EST0QUE.DAT');
  sSenhaX := Mais1Ini.ReadString('Administrador','Chave','15706143431572013809150491382314104');
  Mais1Ini.Free; // Sandro Silva 2018-11-21 Memória 
  sSenha := '';
  // ----------------------------- //
  // Fórmula para ler a nova senha //
  // ----------------------------- //
  for I := 1 to (Length(sSenhaX) div 5) do
    sSenha := Chr((StrToInt(
                  Copy(sSenhaX,(I*5)-4,5)
                  )+((Length(sSenhaX) div 5)-I+1)*7) div 137) + sSenha;
  // ----------------------------- //
  if AnsiUpperCase(sSenha) = AnsiUpperCase(Senha.Text) then
  begin
    Form5.Caption := 'Liberado';
    Form1.Label_10.Caption := '<LIBERADO>';
    Form1.Label_10.Repaint;
    Form5.Repaint;
  end else
  begin
    ShowMessage('Senha do Administrador inválida.');
  end;
  //
  SENHA.Text    := '';
  Close;
  //
end;

procedure TForm5.FormActivate(Sender: TObject);
begin
  Form5.Caption := 'Senha';
  SENHA.Text    := '';
  SENHA.SetFocus;
end;

procedure TForm5.Button2Click(Sender: TObject);
begin
  Close;
end;

end.
