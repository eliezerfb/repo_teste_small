unit Unit3;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, IniFiles, Unit99, SmallFunc, ShellApi, HtmlHelp;

type
    TSenhas2 = class(TForm)
    Panel1: TPanel;
    USUARIO: TEdit;
    SENHA: TEdit;
    Button2: TButton;
    Button1: TButton;
    Label4: TLabel;
    Label5: TLabel;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SENHAKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
     SenhaPub2: String;
     UsuarioPub2: String;
     iGiro : Integer;
  end;

var
  Senhas2: TSenhas2;

implementation

uses Mais, Mais3, Unit22;

{$R *.DFM}

procedure TSenhas2.CancelBtnClick(Sender: TObject);
begin
   close;
end;

procedure TSenhas2.FormActivate(Sender: TObject);
begin
  //
  Senhas2.Top             := Form22.Image1.Top + Form22.Image1.Height;
  Senhas2.Left            := (Form22.Width div 2) - (Senhas.Width div 2) ;
  //
  Usuario.Text := 'Administrador';
  SenhaPub2  := '';
  Senha.Text := '';
  Senha.SetFocus;
  //
end;

procedure TSenhas2.Button1Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
  sSenha : String;
  I : Integer;
begin
  SenhaPub2:=Senha.Text;
  UsuarioPub2:=Usuario.Text;
  // Nova senha
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  if Length(Mais1Ini.ReadString('Administrador','Chave','')) = 0 then
  begin
    //
    Form99.ShowModal;
    if Form99.Edit1.Text = Form99.Edit2.Text then
    begin
      //
      sSenha := '';
      for I := 1 to Length(Form99.Edit2.Text) do
      begin
         sSenha := sTrZero((Ord(Form99.Edit2.Text[I])*137)-I*7,5,0) +  sSenha;
      end;
      //
      Mais1Ini.WriteString('Administrador','Chave',sSenha);
      //
    end;
    //
  end;
  Mais1Ini.Free;
  // Nova senha
  close;
end;

procedure TSenhas2.Button2Click(Sender: TObject);
begin
  Close;
end;


procedure TSenhas2.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('login.htm')));
end;

procedure TSenhas2.SENHAKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  if Key = VK_RETURN then Senhas2.Button1Click(Sender);
  if Key = VK_ESCAPE then Senhas2.Button2Click(Sender);
  //
end;

end.


