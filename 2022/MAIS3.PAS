unit Mais3;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, IniFiles, Unit99
  {$IFDEF VER150}
  , SmallFunc
  {$ELSE}
  , smallfunc_xe
  {$ENDIF}
  , ShellApi, HtmlHelp;

type
    TSenhas = class(TForm)
    Panel1: TPanel;
    Label5: TLabel;
    Usuario: TComboBox;
    SENHA: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label4: TLabel;
    Image3: TImage;
    Panel2: TPanel;
    Image1: TImage;
    Image4: TImage;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure USUARIOKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure USUARIOExit(Sender: TObject);
    procedure UsuarioKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SENHAKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SENHAEnter(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure SENHAMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Image1Click(Sender: TObject);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  private
    FcSenhaPub: String;
    FcUsuarioPub: String;

    function getSenhaPub: String;
    procedure setSenhaPub(const Value: String);
    function getUsuarioPub: String;
    procedure setUsuarioPub(const Value: String);

    procedure DefinirListaUsuariosValidos;
  public
    property SenhaPub: String read getSenhaPub write setSenhaPub;
    property UsuarioPub: String read getUsuarioPub write setUsuarioPub;
  end;

var
  Senhas: TSenhas;

implementation

uses Mais, Unit22, Unit19, Unit7, uSmallConsts, uDialogs;

{$R *.DFM}

procedure TSenhas.FormActivate(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Senhas.Top             := Form22.Image1.Top + Form22.Image1.Height;
  Senhas.Left            := (Form22.Width div 2) - (Senhas.Width div 2) ;
  Form22.Button1.Visible := False;
  
  Senhas.SENHA.SetFocus;

  Mais1ini := TIniFile.Create('MAIS1.INI');
  Usuario.Text := Mais1Ini.ReadString('Usuarios','Nome',Usuario.Text);

  DefinirListaUsuariosValidos;
end;

procedure TSenhas.DefinirListaUsuariosValidos;
var
  oArq: TIniFile;
  i: Integer;
  slSecoes: TStringList;
begin
  Usuario.Items.Clear;
  
  slSecoes := TStringList.Create;
  oArq := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  try
    oArq.ReadSections(slSecoes);
    for I := 0 to (slSecoes.Count - 1) do
    begin
      if oArq.ReadString(slSecoes[I],'Chave','ÁstreloPitecus') <> 'ÁstreloPitecus' then
      begin
        if AllTrim(slSecoes[I]) <> _cUsuarioAdmin then
        begin
          if oArq.ReadString(slSecoes[I],'Chave','') <> '' then
          begin
            Usuario.Items.Add(slSecoes[I]);
          end else
          begin
            oArq.EraseSection(slSecoes[I]);
          end;
        end;
      end;
    end;
  finally
    oArq.Free;
    FreeAndNil(slSecoes);
  end;
end;

procedure TSenhas.FormCreate(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Mais1ini := TIniFile.Create('MAIS1.INI');
  Usuario.Text := Mais1Ini.ReadString('Usuarios','Nome',Usuario.Text);
  Mais1Ini.Free;
  if length(Usuario.Text) = 0 then
    Usuario.TabOrder := 0;
end;

procedure TSenhas.USUARIOKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    SENHA.SetFocus;
end;

procedure TSenhas.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('login.htm')));
end;

procedure TSenhas.USUARIOExit(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  if UpperCase(AllTrim(USUARIO.Text)) = UpperCase(_cUsuarioAdmin) then
  begin
    //ShowMessage('Usuário inválido.'); Mauricio Parizotto 2023-10-25
    MensagemSistema('Usuário inválido.');
    USUARIO.Text := '';
    USUARIO.SetFocus;
  end else
  begin
    try
      Mais1ini := TIniFile.Create(Form1.sAtual+'\'+USUARIO.Text+'.inf');
      Mais1Ini.WriteString('Senha','Usuário e senha válidos','Sim');
      Mais1Ini.Free;
    except end;
  end;
end;

procedure TSenhas.UsuarioKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Senha.SetFocus;
end;

procedure TSenhas.SENHAKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Senhas.Button1Click(Sender);
  if Key = VK_ESCAPE then
    Senhas.Button2Click(Sender);
end;

procedure TSenhas.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Mais1Ini: TIniFile;
  sSenha : String;
  I : Integer;
begin
  if (AllTrim(Usuario.Text) <> EmptyStr) and (Senha.Text <> _cSenhaSair) then
  begin
    SenhaPub:=Senha.Text;
    UsuarioPub:=Usuario.Text;
    // Grava o o nome do último a usar o programa no .INI
    if UsuarioPub <> _cUsuarioAdmin then
    begin
      Mais1ini := TIniFile.Create('MAIS1.INI');
      Mais1Ini.WriteString('Usuarios','Nome',UsuarioPub);
      Mais1Ini.Free;
    end;
    // Só grava a senha e o nome do usuáro se ainda não estiver cadastrado no .INF
    // Nova Senha
    Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
    if Length(Mais1Ini.ReadString(UsuarioPub,'Chave','')) = 0 then
    begin
      if UsuarioPub <> Mais1Ini.ReadString(UsuarioPub,'Nome','xXxXxXxXxXxXxX125') then
      begin
        Form99.ShowModal;
        if AnsiUpperCase(Form99.Edit1.Text) = AnsiUpperCase(Form99.Edit2.Text) then
        begin
          sSenha := '';
          Mais1Ini.WriteString(UsuarioPub,'Nome',UsuarioPub);

          for I := 1 to Length(Form99.Edit2.Text) do
            sSenha := sTrZero((Ord(Form99.Edit2.Text[I])*137)-I*7,5,0) +  sSenha;

          Mais1Ini.WriteString(UsuarioPub,'Chave',sSenha);
        end;
      end;
    end;
    Mais1Ini.Free;
    close;
  end else
  begin
    if Senha.Text <> _cSenhaSair then
    begin
      Usuario.SetFocus;
      Abort;
    end;
  end;
end;

procedure TSenhas.Button2Click(Sender: TObject);
begin
  Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
  Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
  FecharAplicacao(ExtractFileName(Application.ExeName));

  if AllTrim(Usuario.Text) = EmptyStr then
    Usuario.Text := '<Usuário>';
  SENHA.Text  := _cSenhaSair;
  SenhaPub     := SENHAS.Text;
  UsuarioPub   := USUARIO.Text;

  Close;
end;

procedure TSenhas.FormShow(Sender: TObject);
var
  Mais1Ini : TIniFile;
begin
  try
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+Usuario.Text+'.inf');
    Form19.Image7Click(Sender);
    Form19.CheckBox8.Checked  := True;
    Form19.CheckBox10.Checked := False;
    Form19.CheckBox11.Checked := False;
    Mais1Ini.Free;
  except
  end;
end;

procedure TSenhas.Button1Click(Sender: TObject);
begin
  Usuario.Setfocus;
  Close;
end;

procedure TSenhas.SENHAEnter(Sender: TObject);
var
  I : Integer;
begin
  if Senhas.SENHA.Text <> EmptyStr then
  begin
    for I := 1 to 3 do
    begin
      Senhas.Left := Senhas.Left +10;  Senhas.Repaint; sleep(20);
      Senhas.Left := Senhas.Left -10;  Senhas.Repaint; sleep(20);
      Senhas.Left := Senhas.Left +08;  Senhas.Repaint; sleep(15);
      Senhas.Left := Senhas.Left -08;  Senhas.Repaint; sleep(15);
      Senhas.Left := Senhas.Left +06;  Senhas.Repaint; sleep(10);
      Senhas.Left := Senhas.Left -06;  Senhas.Repaint; sleep(10);
      Senhas.Left := Senhas.Left +04;  Senhas.Repaint; sleep(05);
      Senhas.Left := Senhas.Left -04;  Senhas.Repaint; sleep(05);
    end;
  end;
  Senhas.Senha.Text := EmptyStr;
end;

procedure TSenhas.Image2Click(Sender: TObject);
begin
  Form1.Ajustararquivos1Click(Sender);
  Senhas.BringToFront;

  ShellExecute( 0, 'Open',pChar('http://www.smallsoft.com.br/promocao.php?cnpj='+
                Limpanumero(Form7.ibDAtaSet13CGC.AsString)+
                '&serial='+AllTrim(Copy(Form22.sSerie+Replicate(' ',50),18,20))+''),'', '', SW_SHOWMAXIMIZED);
  Form1.bMKP    := True;
end;

procedure TSenhas.SENHAMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Panel2.Top     := SENHA.Top+8;
  Panel2.Left    := SENHA.Left + SENHA.Width -20;
  Panel2.Visible := True;
  Panel2.Repaint;
end;

procedure TSenhas.Image1Click(Sender: TObject);
begin
  if SENHA.PasswordChar = '*' then
  begin
    Image1.Picture := Image3.Picture;
    Image1.Visible := True;
    SENHA.PasswordChar := #0;
  end else
  begin
    Image1.Picture := Image4.Picture;
    Image1.Visible := True;
    SENHA.PasswordChar := '*';
  end;
end;

procedure TSenhas.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Panel2.Visible := False;
  Image1.Picture := Image4.Picture;
  Image1.Visible := True;
  SENHA.PasswordChar := '*';
end;

function TSenhas.getSenhaPub: String;
begin
  Result := FcSenhaPub;
end;

procedure TSenhas.setSenhaPub(const Value: String);
begin
  FcSenhaPub := Value;
end;

function TSenhas.getUsuarioPub: String;
begin
  Result := FcUsuarioPub;
end;

procedure TSenhas.setUsuarioPub(const Value: String);
begin
  FcUsuarioPub := Value;
end;

end.



