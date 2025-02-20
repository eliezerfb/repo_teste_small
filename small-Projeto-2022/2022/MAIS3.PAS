unit Mais3;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, IniFiles//, Unit99
  , smallfunc_xe
  , ShellApi, Vcl.Imaging.pngimage;

type
    TSenhas = class(TForm)
    Panel1: TPanel;
    lblSenha: TLabel;
    edtSenha: TEdit;
    lblUsuario: TLabel;
    imgOculta: TImage;
    imgVer: TImage;
    pnlVisSenha2: TPanel;
    imgLogin: TImage;
    imgFundo: TImage;
    imgUsuario: TImage;
    imgSenha: TImage;
    pnlusuario: TPanel;
    Usuario: TComboBox;
    imgLogo: TImage;
    Image2: TImage;
    imgVisSenha2: TImage;
    imgEntrar: TImage;
    lblEntrar: TLabel;
    lblCancelar: TLabel;
    lblConfNS: TLabel;
    edtNovaS: TEdit;
    edtConfNovaS: TEdit;
    lblSenhaDif: TLabel;
    pnlVisSenha1: TPanel;
    imgVisSenha1: TImage;
    pnlVisSenha3: TPanel;
    imgVisSenha3: TImage;
    edtUserAdm: TEdit;
    imgEntrarFoco: TImage;
    imgCancelar: TImage;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure USUARIOKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure USUARIOExit(Sender: TObject);
    procedure UsuarioKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtSenhaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Cancelar;
    procedure FormShow(Sender: TObject);
    procedure Entrar;
    procedure imgVisSenha2Click(Sender: TObject);
    procedure lblCancelarClick(Sender: TObject);
    procedure lblEntrarClick(Sender: TObject);
    procedure SalvaNovaSenha;
    procedure edtNovaSKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtNovaSExit(Sender: TObject);
    procedure edtNovaSChange(Sender: TObject);
    procedure edtConfNovaSChange(Sender: TObject);
    procedure edtConfNovaSKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtConfNovaSMouseEnter(Sender: TObject);
    procedure edtNovaSMouseEnter(Sender: TObject);
    procedure edtSenhaMouseEnter(Sender: TObject);
    procedure imgVisSenha1Click(Sender: TObject);
    procedure imgVisSenha3Click(Sender: TObject);
    procedure lblCancelarMouseEnter(Sender: TObject);
    procedure lblCancelarMouseLeave(Sender: TObject);
    procedure lblEntrarMouseEnter(Sender: TObject);
    procedure lblEntrarMouseLeave(Sender: TObject);
  private
    FcSenhaPub: String;
    FcUsuarioPub: String;
    FcSenhaAdmPub: String;

    function getSenhaPub: String;
    procedure setSenhaPub(const Value: String);
    function getUsuarioPub: String;
    procedure setUsuarioPub(const Value: String);

    procedure DefinirListaUsuariosValidos;
    procedure TremeTela;
    procedure VoltaLogin(iTag:integer);
    function getSenhaAdmPub: String;
    procedure setSenhaAdmPub(const Value: String);
    procedure ConfirmaAdm;
    procedure CarregaNovaSenha(iTag:integer);
  public
    iTpApresentacao : integer;
    property SenhaPub: String read getSenhaPub write setSenhaPub;
    property UsuarioPub: String read getUsuarioPub write setUsuarioPub;
    property SenhaAdmPub: String read getSenhaAdmPub write setSenhaAdmPub;
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
  if iTpApresentacao <> 3 then
  begin
    edtSenha.SetFocus;

    Mais1ini := TIniFile.Create('MAIS1.INI');
    Usuario.Text := Mais1Ini.ReadString('Usuarios','Nome',Usuario.Text);

    DefinirListaUsuariosValidos;

    TremeTela;
  end;
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

procedure TSenhas.edtConfNovaSChange(Sender: TObject);
begin
  lblSenhaDif.Visible := False;
end;

procedure TSenhas.edtConfNovaSKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    SalvaNovaSenha;
end;

procedure TSenhas.edtConfNovaSMouseEnter(Sender: TObject);
begin
  pnlVisSenha3.Visible := True;
  pnlVisSenha3.Top     := TEdit(Sender).Top + 3;
  pnlVisSenha3.Left    := TEdit(Sender).Left + TEdit(Sender).Width - 20;
end;

procedure TSenhas.edtNovaSChange(Sender: TObject);
begin
  lblSenhaDif.Visible := False;
end;

procedure TSenhas.edtNovaSExit(Sender: TObject);
begin
  if Alltrim(edtNovaS.Text) = '' then
    edtNovaS.SetFocus;
end;

procedure TSenhas.edtNovaSKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    edtConfNovaS.SetFocus;
end;

procedure TSenhas.edtNovaSMouseEnter(Sender: TObject);
begin
  pnlVisSenha1.Visible := True;
  pnlVisSenha1.Top     := TEdit(Sender).Top + 3;
  pnlVisSenha1.Left    := TEdit(Sender).Left + TEdit(Sender).Width - 20;
end;

procedure TSenhas.FormCreate(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Senhas.Top             := (Form22.Height div 2) - (Senhas.Height div 2) ;
  Senhas.Left            := (Form22.Width div 2) - (Senhas.Width div 2) ;

  iTpApresentacao := 0;

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
    edtSenha.SetFocus;
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
    edtSenha.SetFocus;
end;

procedure TSenhas.edtSenhaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    lblEntrarClick(Sender);

  if Key = VK_ESCAPE then
    lblCancelarClick(Sender);
end;

procedure TSenhas.SalvaNovaSenha;
var
  sSenha : String;
  I : Integer;
  Mais1Ini: TIniFile;
begin
  if Trim(edtNovaS.Text) = '' then
  begin
    lblSenhaDif.Caption := 'Informe a nova senha!';
    edtNovaS.SetFocus;
    lblSenhaDif.Visible := True;
    Exit;
  end;

  if Trim(edtConfNovaS.Text) = '' then
  begin
    lblSenhaDif.Caption := 'Informe a confirmação da nova senha!';
    edtConfNovaS.SetFocus;
    lblSenhaDif.Visible := True;
    Exit;
  end;

  if edtNovaS.Text <> edtConfNovaS.Text then
  begin
    lblSenhaDif.Caption := 'As senhas digitadas não coincidem!';
    lblSenhaDif.Visible := True;
    Exit;
  end;

  if AnsiUpperCase(edtNovaS.Text) = AnsiUpperCase(edtConfNovaS.Text) then
  begin
    Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');

    sSenha := '';
    for I := 1 to Length(edtConfNovaS.Text) do
      sSenha := sTrZero((Ord(edtConfNovaS.Text[I])*137)-I*7,5,0) +  sSenha;

    if iTpApresentacao <> 4 then
    begin
      Mais1Ini.WriteString(UsuarioPub,'Nome',UsuarioPub)  ;
      Mais1Ini.WriteString(UsuarioPub,'Chave',sSenha);
    end else
    begin
      Mais1Ini.WriteString('Administrador','Chave',sSenha);
      SenhaAdmPub  := edtSenha.Text;
    end;

    Mais1ini.Free;
  end;

  VoltaLogin(0);

  Close;
end;

procedure TSenhas.Cancelar;
begin
  Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
  Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
  FecharAplicacao(ExtractFileName(Application.ExeName));

  if AllTrim(Usuario.Text) = EmptyStr then
    Usuario.Text := '<Usuário>';
  edtSenha.Text  := _cSenhaSair;
  SenhaPub     := SENHAS.Text;
  UsuarioPub   := USUARIO.Text;

  Close;
end;

procedure TSenhas.ConfirmaAdm;
var
  Mais1Ini: TIniFile;
  {Sandro Silva 2024-09-26
  sSenha : String;
  I : Integer;
  }
begin
  try
    // Nova senha adm se não tiver
    Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
    if Length(Mais1Ini.ReadString('Administrador','Chave','')) = 0 then
    begin
      CarregaNovaSenha(4);

      Exit;
    end;
  finally
    Mais1Ini.Free;
  end;

  SenhaAdmPub  := edtSenha.Text;
  Close;
end;

procedure TSenhas.FormShow(Sender: TObject);
var
  Mais1Ini : TIniFile;
begin
  if iTpApresentacao <> 3 then
  begin
    edtUserAdm.Visible := False;
    Usuario.Visible    := True;
    lblEntrar.Caption  := 'Entrar';
    try
      Mais1ini := TIniFile.Create(Form1.sAtual+'\'+Usuario.Text+'.inf');
      Form19.Image7Click(Sender);
      Mais1Ini.Free;
    except
    end;
  end else
  begin
    edtUserAdm.Visible := True;
    Usuario.Visible    := False;
    edtSenha.Text      := '';
    SenhaAdmPub        := '';
    lblEntrar.Caption  := 'Confirmar';
  end;
end;

procedure TSenhas.Entrar;
var
  Mais1Ini: TIniFile;
begin
  Usuario.Setfocus;

  if (AllTrim(Usuario.Text) <> EmptyStr) and (edtSenha.Text <> _cSenhaSair) then
  begin
    SenhaPub:=edtSenha.Text;
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
    try
      Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
      if Length(Mais1Ini.ReadString(UsuarioPub,'Chave','')) = 0 then
      begin
        if UsuarioPub <> Mais1Ini.ReadString(UsuarioPub,'Nome','xXxXxXxXxXxXxX125') then
        begin
          CarregaNovaSenha(1);
          Exit;
        end;
      end;
    finally
      Mais1Ini.Free;
    end;
  end else
  begin
    if edtSenha.Text <> _cSenhaSair then
    begin
      Usuario.SetFocus;
      Abort;
    end;
  end;

  Close;
end;

procedure TSenhas.edtSenhaMouseEnter(Sender: TObject);
begin
  pnlVisSenha2.Visible := True;
  pnlVisSenha2.Top     := TEdit(Sender).Top + 3;
  pnlVisSenha2.Left    := TEdit(Sender).Left + TEdit(Sender).Width - 20;
end;

procedure TSenhas.imgVisSenha1Click(Sender: TObject);
begin
  if edtNovaS.PasswordChar = '*' then
  begin
    imgVisSenha1.Picture := imgOculta.Picture;
    imgVisSenha1.Visible := True;
    edtNovaS.PasswordChar := #0;
  end else
  begin
    imgVisSenha1.Picture := imgVer.Picture;
    imgVisSenha1.Visible := True;
    edtNovaS.PasswordChar := '*';
  end;
end;

procedure TSenhas.imgVisSenha2Click(Sender: TObject);
begin
  if edtSenha.PasswordChar = '*' then
  begin
    imgVisSenha2.Picture := imgOculta.Picture;
    imgVisSenha2.Visible := True;
    edtSenha.PasswordChar := #0;
  end else
  begin
    imgVisSenha2.Picture := imgVer.Picture;
    imgVisSenha2.Visible := True;
    edtSenha.PasswordChar := '*';
  end;
end;

procedure TSenhas.imgVisSenha3Click(Sender: TObject);
begin
  if edtConfNovaS.PasswordChar = '*' then
  begin
    imgVisSenha3.Picture := imgOculta.Picture;
    imgVisSenha3.Visible := True;
    edtConfNovaS.PasswordChar := #0;
  end else
  begin
    imgVisSenha3.Picture := imgVer.Picture;
    imgVisSenha3.Visible := True;
    edtConfNovaS.PasswordChar := '*';
  end;
end;

procedure TSenhas.lblEntrarClick(Sender: TObject);
begin
  case iTpApresentacao of
    0 : Entrar;
    1 : SalvaNovaSenha;
    3 : ConfirmaAdm;
    4 : SalvaNovaSenha;
  end;
end;

procedure TSenhas.lblEntrarMouseEnter(Sender: TObject);
begin
  imgEntrarFoco.Visible := True;
end;

procedure TSenhas.lblEntrarMouseLeave(Sender: TObject);
begin
  imgEntrarFoco.Visible := False;
end;

procedure TSenhas.lblCancelarClick(Sender: TObject);
begin
  case iTpApresentacao of
    0 : Cancelar;
    1 : VoltaLogin(0);
    3 : Close;
    4 : begin
          VoltaLogin(0);
          Close;
        end;
  end;
end;

procedure TSenhas.lblCancelarMouseEnter(Sender: TObject);
begin
  imgCancelar.Visible := True;
end;

procedure TSenhas.lblCancelarMouseLeave(Sender: TObject);
begin
  imgCancelar.Visible := False;
end;

function TSenhas.getSenhaAdmPub: String;
begin
  Result := FcSenhaAdmPub;
end;

function TSenhas.getSenhaPub: String;
begin
  Result := FcSenhaPub;
end;

procedure TSenhas.setSenhaAdmPub(const Value: String);
begin
  FcSenhaAdmPub := Value;
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


procedure TSenhas.TremeTela;
var
  I : Integer;
begin
  if Senhas.edtSenha.Text <> EmptyStr then
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
  Senhas.edtSenha.Text := EmptyStr;
end;


procedure TSenhas.VoltaLogin(iTag:integer);
begin
  iTpApresentacao      := iTag;
  pnlusuario.Visible   := True;
  lblUsuario.Caption   := 'Usuário';
  lblSenha.Caption     := 'Senha';
  lblEntrar.Caption    := 'Entrar';
  pnlVisSenha2.Visible := True;
  edtSenha.Visible     := True;
  lblConfNS.Visible    := False;
  edtNovaS.Visible     := False;
  edtConfNovaS.Visible := False;
  edtNovaS.Text        := '';
  edtConfNovaS.Text    := '';
  lblSenhaDif.Visible  := False;
  pnlVisSenha1.Visible := False;
  pnlVisSenha2.Visible := False;
  pnlVisSenha3.Visible := False;

  if edtSenha.CanFocus then
    edtSenha.SetFocus;
end;

procedure TSenhas.CarregaNovaSenha(iTag:integer);
begin
  //Mauricio Parizotto 2024-07-24
  iTpApresentacao      := iTag;
  lblUsuario.Caption   := 'Nova senha';
  lblSenha.Caption     := 'Confirme a nova senha';
  lblEntrar.Caption    := 'Confirmar';
  pnlusuario.Visible   := False;
  pnlVisSenha2.Visible := False;
  edtSenha.Visible     := False;
  lblConfNS.Visible    := True;
  edtNovaS.Visible     := True;
  edtConfNovaS.Visible := True;
  edtNovaS.Text        := edtSenha.Text;
  edtConfNovaS.Text    := '';
  edtUserAdm.Visible   := False;

  if edtConfNovaS.CanFocus then
    edtConfNovaS.SetFocus;
end;


end.



